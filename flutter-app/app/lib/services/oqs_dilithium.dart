import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

final DynamicLibrary nativeLib = Platform.isAndroid
    ? DynamicLibrary.open("libdilithium.so")
    : DynamicLibrary.process();

typedef DilithiumSignNative = Pointer<Utf8> Function(Pointer<Utf8> message);
typedef DilithiumSign = Pointer<Utf8> Function(Pointer<Utf8> message);

final DilithiumSign dilithiumSign = nativeLib
    .lookup<NativeFunction<DilithiumSignNative>>("dilithium_sign")
    .asFunction();

String signWithDilithium(String message) {
  final msgPtr = message.toNativeUtf8();
  final resultPtr = dilithiumSign(msgPtr);
  final result = resultPtr.toDartString();
  calloc.free(msgPtr);
  return result;
}
