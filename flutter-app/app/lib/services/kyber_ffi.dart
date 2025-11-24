import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';

class KyberEncapResult {
  final Uint8List ciphertext;   // ~768 bytes (ML-KEM-512)
  final Uint8List sharedSecret; // 32 bytes
  KyberEncapResult(this.ciphertext, this.sharedSecret);
}

class KyberFfi {
  static DynamicLibrary? _lib;
  static bool _isInitialized = false;
  static bool _keyPairGenerated = false; // only needed if you also expose client keypair APIs

  // Expected sizes for ML-KEM-512
  static const int pkLen512 = 800;
  static const int ctLen512 = 768;
  static const int ssLen = 32;

  static bool _init() {
    if (_lib != null) return _isInitialized;
    try {
      if (Platform.isAndroid) {
        _lib = DynamicLibrary.open("libkyber.so");
      } else if (Platform.isIOS) {
        _lib = DynamicLibrary.process();
      } else {
        print("❌ Unsupported platform for Kyber");
        return false;
      }
      _isInitialized = true;
      print("✅ Kyber library loaded successfully");
      return true;
    } catch (e) {
      print("❌ Failed to load Kyber library: $e");
      _lib = null;
      _isInitialized = false;
      return false;
    }
  }

  // ─────────────────────────────────────────────────────────
  // Existing helpers you already had (kept as-is)
  // ─────────────────────────────────────────────────────────

  static Future<bool> generateKyberKeyPair() async {
    if (!_init()) return false;
    try {
      final generate = _lib!
          .lookup<NativeFunction<Int32 Function()>>("kyber_generate_keypair")
          .asFunction<int Function()>();
      final result = generate();
      final getLen = _lib!
          .lookup<NativeFunction<Int32 Function()>>("kyber_get_public_key_length")
          .asFunction<int Function()>();
      final len = getLen();
      final ok = (result == 0 && len > 0);
      _keyPairGenerated = ok;
      print(ok
          ? "✅ Kyber key pair generated (pub len: $len)"
          : "❌ Kyber key gen failed (code=$result, len=$len)");
      return ok;
    } catch (e) {
      print("❌ Error during Kyber key generation: $e");
      return false;
    }
  }

  static Future<Uint8List> getPublicKey() async {
    if (!_init()) return Uint8List(0);
    if (!_keyPairGenerated) {
      final ok = await generateKyberKeyPair();
      if (!ok) return Uint8List(0);
    }
    try {
      final getLen = _lib!
          .lookup<NativeFunction<Int32 Function()>>("kyber_get_public_key_length")
          .asFunction<int Function()>();
      final getKey = _lib!
          .lookup<NativeFunction<Pointer<Uint8> Function()>>("kyber_get_public_key")
          .asFunction<Pointer<Uint8> Function()>();
      final len = getLen();
      final ptr = getKey();
      if (ptr == nullptr || len <= 0) return Uint8List(0);
      return Uint8List.fromList(ptr.asTypedList(len));
    } catch (e) {
      print("❌ Error getting public key: $e");
      return Uint8List(0);
    }
  }

  static Future<Uint8List> getPrivateKey() async {
    if (!_init()) return Uint8List(0);
    if (!_keyPairGenerated) {
      print("❌ Key pair not generated yet");
      return Uint8List(0);
    }
    try {
      final getLen = _lib!
          .lookup<NativeFunction<Int32 Function()>>("kyber_get_private_key_length")
          .asFunction<int Function()>();
      final getKey = _lib!
          .lookup<NativeFunction<Pointer<Uint8> Function()>>("kyber_get_private_key")
          .asFunction<Pointer<Uint8> Function()>();
      final len = getLen();
      final ptr = getKey();
      if (ptr == nullptr || len <= 0) return Uint8List(0);
      return Uint8List.fromList(ptr.asTypedList(len));
    } catch (e) {
      print("❌ Error getting private key: $e");
      return Uint8List(0);
    }
  }

  @Deprecated('Kyber is a KEM; use encapsulate(serverPk) which returns (ct, ss).')
  static Future<Uint8List> computeSharedSecret(Uint8List serverPubKey) async {
    if (!_init()) return Uint8List(0);
    if (serverPubKey.isEmpty) return Uint8List(0);
    Pointer<Uint8>? input;
    Pointer<Uint8>? output;
    try {
      final compute = _lib!
          .lookup<
              NativeFunction<
                  Int32 Function(Pointer<Uint8>, Int32, Pointer<Uint8>)>>(
            "kyber_compute_shared_secret",
          )
          .asFunction<int Function(Pointer<Uint8>, int, Pointer<Uint8>)>();

      input = calloc<Uint8>(serverPubKey.length);
      input.asTypedList(serverPubKey.length).setAll(0, serverPubKey);
      output = calloc<Uint8>(ssLen);

      final rc = compute(input, serverPubKey.length, output);
      if (rc != 0) {
        print("❌ kyber_compute_shared_secret failed: $rc");
        return Uint8List(0);
      }
      return Uint8List.fromList(output.asTypedList(ssLen));
    } catch (e) {
      print("❌ Error computing shared secret: $e");
      return Uint8List(0);
    } finally {
      if (input != null) calloc.free(input);
      if (output != null) calloc.free(output);
    }
  }

  // ─────────────────────────────────────────────────────────
  // ✅ Proper KEM path: encapsulate(serverPk) → (ct, ss)
  // ─────────────────────────────────────────────────────────

  static Future<KyberEncapResult> encapsulate(Uint8List serverPublicKey) async {
    if (!_init()) {
      throw StateError("Kyber library not initialized");
    }
    if (serverPublicKey.isEmpty) {
      throw ArgumentError("serverPublicKey is empty");
    }

    // Look up native symbol
    final nativeEncap = _lib!
        .lookup<
            NativeFunction<
                Int32 Function(
                  Pointer<Uint8>, Int32,        // server pk + len
                  Pointer<Uint8>, Pointer<Int32>, // out ct + out ct len
                  Pointer<Uint8>, Pointer<Int32>  // out ss + out ss len
                )>>("kyber_encapsulate")
        .asFunction<
            int Function(
              Pointer<Uint8>, int,
              Pointer<Uint8>, Pointer<Int32>,
              Pointer<Uint8>, Pointer<Int32>
            )>();

    Pointer<Uint8>? pkPtr;
    Pointer<Uint8>? ctPtr;
    Pointer<Int32>? ctLenPtr;
    Pointer<Uint8>? ssPtr;
    Pointer<Int32>? ssLenPtr;

    try {
      // Allocate inputs/outputs
      pkPtr = calloc<Uint8>(serverPublicKey.length);
      pkPtr.asTypedList(serverPublicKey.length).setAll(0, serverPublicKey);

      ctPtr = calloc<Uint8>(ctLen512); // worst-case buffer
      ctLenPtr = calloc<Int32>()..value = ctLen512;

      ssPtr = calloc<Uint8>(ssLen);
      ssLenPtr = calloc<Int32>()..value = ssLen;

      final rc = nativeEncap(pkPtr, serverPublicKey.length, ctPtr, ctLenPtr, ssPtr, ssLenPtr);
      if (rc != 0) {
        throw Exception("kyber_encapsulate failed (code=$rc)");
      }

      final int ctLen = ctLenPtr.value;
      final int outSsLen = ssLenPtr.value;
      if (ctLen <= 0 || outSsLen != ssLen) {
        throw Exception("Invalid output sizes: ct=$ctLen, ss=$outSsLen");
      }

      final ct = Uint8List.fromList(ctPtr.asTypedList(ctLen));
      final ss = Uint8List.fromList(ssPtr.asTypedList(outSsLen));
      return KyberEncapResult(ct, ss);
    } finally {
      if (pkPtr != null) calloc.free(pkPtr);
      if (ctPtr != null) calloc.free(ctPtr);
      if (ctLenPtr != null) calloc.free(ctLenPtr);
      if (ssPtr != null) calloc.free(ssPtr);
      if (ssLenPtr != null) calloc.free(ssLenPtr);
    }
  }

  // Utilities
  static bool isReady() => _isInitialized && _keyPairGenerated;
  static void reset() { _keyPairGenerated = false; _isInitialized = false; _lib = null; }

  static void checkAvailableFunctions() {
    if (!_init()) { print("❌ Library not initialized"); return; }
    for (final name in [
      "kyber_generate_keypair",
      "kyber_get_public_key",
      "kyber_get_public_key_length",
      "kyber_get_private_key",
      "kyber_get_private_key_length",
      "kyber_compute_shared_secret",
      "kyber_encapsulate", // ✅ NEW
    ]) {
      try { _lib!.lookup(name); print("✅ Found: $name"); }
      catch (_) { print("❌ Missing: $name"); }
    }
  }
}
