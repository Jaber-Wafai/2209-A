import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ffi/ffi.dart';
import 'package:cryptography/cryptography.dart';
import 'package:http/http.dart' as http;

enum SignatureAlgorithm { ed25519, dilithium }

class KeyService {
  final SignatureAlgorithm algorithm;
  final storage = const FlutterSecureStorage();

  late SimpleKeyPair edKeyPair;
  late SimplePublicKey edPublicKey;

  late SimpleKeyPair x25519KeyPair;
  late SimplePublicKey x25519ServerPublicKey;
  late SecretKey sharedAesKey;

  static const _ed25519KeyStorage = 'ed25519_private_key';

  final DynamicLibrary _nativeLib = Platform.isAndroid
      ? DynamicLibrary.open("libdilithium.so")
      : DynamicLibrary.process();

  late final Pointer<Utf8> Function() _generateDilithiumKeypair;
  late final Pointer<Utf8> Function() _getDilithiumPublicKey;
  late final Pointer<Utf8> Function(Pointer<Utf8>) _signDilithium;

  String lastDilithiumPublicKey = "";
  int lastDilithiumKeyGenTime = 0;

  KeyService({required this.algorithm}) {
    if (algorithm == SignatureAlgorithm.dilithium) {
      _generateDilithiumKeypair = _nativeLib
          .lookup<NativeFunction<Pointer<Utf8> Function()>>(
              "dilithium_generate_keypair")
          .asFunction();

      _getDilithiumPublicKey = _nativeLib
          .lookup<NativeFunction<Pointer<Utf8> Function()>>(
              "dilithium_get_public_key")
          .asFunction();

      _signDilithium = _nativeLib
          .lookup<NativeFunction<Pointer<Utf8> Function(Pointer<Utf8>)>>(
              "dilithium_sign")
          .asFunction();
    }
  }

  Future<void> generateAndSaveKeyPair() async {
    if (algorithm == SignatureAlgorithm.ed25519) {
      final edAlgo = Ed25519();
      edKeyPair = await edAlgo.newKeyPair();
      final extracted = await edKeyPair.extract();
      await storage.write(
        key: _ed25519KeyStorage,
        value: base64Encode(extracted.bytes),
      );
      edPublicKey = await edKeyPair.extractPublicKey();
    } else {
      final result = _generateDilithiumKeypair().toDartString();

      final timeMatch = RegExp(r"\\[time=(\\d+)]").firstMatch(result);
      lastDilithiumKeyGenTime =
          timeMatch != null ? int.tryParse(timeMatch.group(1)!) ?? 0 : 0;

      final keyOnly = result.replaceAll(RegExp(r"\\[time=\\d+)]"), "");
      lastDilithiumPublicKey = keyOnly;

      print("🧪 Native Key: ${lastDilithiumPublicKey.substring(0, 30)}...");
      print("⏱ Real Native Time: ${lastDilithiumKeyGenTime} ms");
    }
  }

  Future<String> getPublicKeyBase64() async {
    if (algorithm == SignatureAlgorithm.ed25519) {
      final raw = edPublicKey.bytes;
      final header = [
        0x30,
        0x2a,
        0x30,
        0x05,
        0x06,
        0x03,
        0x2b,
        0x65,
        0x70,
        0x03,
        0x21,
        0x00
      ];
      final fullKey = Uint8List.fromList(header + raw);
      return base64Encode(fullKey);
    } else {
      return lastDilithiumPublicKey;
    }
  }

  Future<String> signData(dynamic data) async {
    Uint8List bytes;
    if (data is String) {
      bytes = Uint8List.fromList(utf8.encode(data));
    } else if (data is Uint8List) {
      bytes = data;
    } else {
      throw ArgumentError("Data must be String or Uint8List");
    }

    if (algorithm == SignatureAlgorithm.ed25519) {
      final sig = await Ed25519().sign(bytes, keyPair: edKeyPair);
      return base64Encode(sig.bytes);
    } else {
      final stopwatch = Stopwatch()..start();
      final msgPtr = base64Encode(bytes).toNativeUtf8(); // ✅ safe and correct
      final sigPtr = _signDilithium(msgPtr);
      final result = sigPtr.toDartString();
      calloc.free(msgPtr);
      stopwatch.stop();

      return result;
    }
  }

  Future<bool> loadSavedKeyPair() async {
    if (algorithm == SignatureAlgorithm.ed25519) {
      final stored = await storage.read(key: _ed25519KeyStorage);
      if (stored == null) return false;

      final privateBytes = base64Decode(stored);
      final edAlgo = Ed25519();
      edKeyPair = await edAlgo.newKeyPairFromSeed(privateBytes);
      edPublicKey = await edKeyPair.extractPublicKey();
      return true;
    } else {
      return true; // No persistence yet for Dilithium
    }
  }

  Future<void> clearKey() async {
    await storage.delete(key: _ed25519KeyStorage);
  }

  Future<void> performKeyExchangeWithServer() async {
    final xAlgo = X25519();
    x25519KeyPair = await xAlgo.newKeyPair();
    final clientPublicKey = await x25519KeyPair.extractPublicKey();
    final clientPubKeyBase64 = base64Encode(clientPublicKey.bytes);

    final response = await http.post(
      Uri.parse('http://192.168.1.161:8080/api/cards/request-aes-key'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'clientPublicKey': clientPubKeyBase64}),
    );

    if (response.statusCode != 200) {
      throw Exception("❌ Server failed to provide AES key: \${response.body}");
    }

    final json = jsonDecode(response.body);
    final serverPubKeyBase64 = json['serverPublicKey'];

    x25519ServerPublicKey = SimplePublicKey(
      base64Decode(serverPubKeyBase64),
      type: KeyPairType.x25519,
    );

    sharedAesKey = await xAlgo.sharedSecretKey(
      keyPair: x25519KeyPair,
      remotePublicKey: x25519ServerPublicKey,
    );
  }

  Future<String> getClientX25519PublicKeyBase64() async {
    final pub = await x25519KeyPair.extractPublicKey();
    return base64Encode(pub.bytes);
  }
}
