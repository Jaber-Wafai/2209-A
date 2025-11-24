package com.example.app

class NativeCrypto {
    companion object {
        init {
            System.loadLibrary("native-lib")
        }
    }

    external fun signWithDilithium(message: ByteArray): ByteArray
}
