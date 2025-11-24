#include <jni.h>
#include <string>
#include <vector>
#include <chrono>
#include <oqs/oqs.h>
#include "android/log.h"
#include "base64.h"

#define LOGD(...) __android_log_print(ANDROID_LOG_DEBUG, "DilithiumJNI", __VA_ARGS__)

static std::string dilithium_public_key;
static std::string dilithium_secret_key;

extern "C" {

const char* dilithium_generate_keypair() {
    auto start = std::chrono::high_resolution_clock::now();
    OQS_SIG* sig = OQS_SIG_new(OQS_SIG_alg_dilithium_3);
    if (!sig) return strdup("ERROR: sig init");

    std::vector<uint8_t> pk(sig->length_public_key);
    std::vector<uint8_t> sk(sig->length_secret_key);

    if (OQS_SIG_keypair(sig, pk.data(), sk.data()) != OQS_SUCCESS) {
        OQS_SIG_free(sig);
        return strdup("ERROR: keypair failed");
    }

    OQS_SIG_free(sig);

    auto end = std::chrono::high_resolution_clock::now();
    long duration = std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count();

    dilithium_public_key = base64_encode(pk.data(), pk.size());
    dilithium_secret_key = std::string((char*)sk.data(), sk.size());

    std::string result = dilithium_public_key + "[time=" + std::to_string(duration) + "]";
    return strdup(result.c_str());
}

const char* dilithium_get_public_key() {
    return strdup(dilithium_public_key.c_str());
}

const char* dilithium_sign(const char* msg) {
    if (dilithium_secret_key.empty()) return strdup("ERROR: no keypair");

    OQS_SIG* sig = OQS_SIG_new(OQS_SIG_alg_dilithium_3);
    if (!sig) return strdup("ERROR: sig init");

    std::vector<uint8_t> sk(dilithium_secret_key.begin(), dilithium_secret_key.end());
    std::string input(msg);
    std::vector<uint8_t> message(input.begin(), input.end());
    std::vector<uint8_t> signature(sig->length_signature);
    size_t sig_len = 0;

    if (OQS_SIG_sign(sig, signature.data(), &sig_len, message.data(), message.size(), sk.data()) != OQS_SUCCESS) {
        OQS_SIG_free(sig);
        return strdup("ERROR: signing failed");
    }

    OQS_SIG_free(sig);
    signature.resize(sig_len);
    std::string b64 = base64_encode(signature.data(), sig_len);
    return strdup(b64.c_str());
}

}

