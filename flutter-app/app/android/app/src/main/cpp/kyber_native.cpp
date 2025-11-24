// kyber_native.cpp
// Build: liboqs with OQS_ENABLE_KEM_KYBER=ON
// Target: Android NDK (but works elsewhere if you swap logging)

#include <cstdint>
#include <cstdlib>
#include <cstring>
#include <vector>
#include <exception>

#include <oqs/oqs.h>

#ifdef __ANDROID__
  #include <android/log.h>
  #define LOGI(...) __android_log_print(ANDROID_LOG_INFO , "KyberNative", __VA_ARGS__)
  #define LOGE(...) __android_log_print(ANDROID_LOG_ERROR, "KyberNative", __VA_ARGS__)
#else
  #include <cstdio>
  #define LOGI(...) std::printf(__VA_ARGS__), std::printf("\n")
  #define LOGE(...) std::fprintf(stderr, __VA_ARGS__), std::fprintf(stderr, "\n")
#endif

// ─────────────────────────────────────────────────────────────────────────────
// Globals (simple demo storage — not thread-safe)
// In a real app, store keys in a keystore/HSM and avoid global state.
// ─────────────────────────────────────────────────────────────────────────────
static std::vector<uint8_t> g_pubkey;
static std::vector<uint8_t> g_seckey;
static bool g_keys_initialized = false;

// Zeroize utility (best-effort)
static inline void secure_bzero(void* p, size_t n) {
#if defined(_WIN32)
  SecureZeroMemory(p, n);
#else
  volatile uint8_t* vp = static_cast<volatile uint8_t*>(p);
  while (n--) *vp++ = 0;
#endif
}

// Helper: create KEM
static OQS_KEM* make_kem() {
  if (!OQS_KEM_alg_is_enabled(OQS_KEM_alg_kyber_512)) {
    LOGE("Kyber-512 not enabled in liboqs");
    return nullptr;
  }
  OQS_KEM* kem = OQS_KEM_new(OQS_KEM_alg_kyber_512);
  if (!kem) {
    LOGE("OQS_KEM_new failed");
    return nullptr;
  }
  return kem;
}

// Export visibility (optional, helps some linkers)
#if defined(__GNUC__) || defined(__clang__)
  #define EXPORT __attribute__((visibility("default")))
#else
  #define EXPORT
#endif

extern "C" {

// ─────────────────────────────────────────────────────────────────────────────
// Keypair management (client local demo)
// ─────────────────────────────────────────────────────────────────────────────

/**
 * Generate a Kyber-512 keypair and keep it in process memory.
 * Returns 0 on success.
 */
EXPORT int32_t kyber_generate_keypair() {
  LOGI("kyber_generate_keypair: start");
  OQS_KEM* kem = make_kem();
  if (!kem) return -1;

  try {
    g_pubkey.resize(kem->length_public_key);
    g_seckey.resize(kem->length_secret_key);

    const int rc = OQS_KEM_keypair(kem, g_pubkey.data(), g_seckey.data());
    if (rc != OQS_SUCCESS) {
      LOGE("kyber_generate_keypair: OQS_KEM_keypair failed (%d)", rc);
      g_pubkey.clear();
      g_seckey.clear();
      g_keys_initialized = false;
      OQS_KEM_free(kem);
      return -2;
    }

    g_keys_initialized = true;
    LOGI("kyber_generate_keypair: ok (pk=%zu, sk=%zu)",
         g_pubkey.size(), g_seckey.size());

    if (g_pubkey.size() >= 4) {
      LOGI("pk[0..3]=%02x %02x %02x %02x",
           g_pubkey[0], g_pubkey[1], g_pubkey[2], g_pubkey[3]);
    }

    OQS_KEM_free(kem);
    return 0;
  } catch (const std::exception& e) {
    LOGE("kyber_generate_keypair: exception: %s", e.what());
    g_pubkey.clear();
    g_seckey.clear();
    g_keys_initialized = false;
    OQS_KEM_free(kem);
    return -3;
  }
}

/** Return pointer to internal public key buffer (do not free). */
EXPORT const uint8_t* kyber_get_public_key() {
  if (!g_keys_initialized || g_pubkey.empty()) {
    LOGE("kyber_get_public_key: keys not initialized");
    return nullptr;
  }
  return g_pubkey.data();
}

/** Return length of internal public key buffer. */
EXPORT int32_t kyber_get_public_key_length() {
  if (!g_keys_initialized) return 0;
  return static_cast<int32_t>(g_pubkey.size());
}

/** Return pointer to internal secret key buffer (do not free). */
EXPORT const uint8_t* kyber_get_private_key() {
  if (!g_keys_initialized || g_seckey.empty()) {
    LOGE("kyber_get_private_key: keys not initialized");
    return nullptr;
  }
  return g_seckey.data();
}

/** Return length of internal secret key buffer. */
EXPORT int32_t kyber_get_private_key_length() {
  if (!g_keys_initialized) return 0;
  return static_cast<int32_t>(g_seckey.size());
}

// ─────────────────────────────────────────────────────────────────────────────
// ❗ Deprecated: does encapsulation but DROPS ciphertext (server can't decap)
// Kept only for backward compatibility with older FFI. Prefer kyber_encapsulate.
// ─────────────────────────────────────────────────────────────────────────────

/**
 * DEPRECATED.
 * Computes a shared secret with a *server* public key by performing encapsulation,
 * BUT DOES NOT RETURN THE CIPHERTEXT. This breaks KEM correctness for a
 * client-server protocol. Use kyber_encapsulate instead.
 *
 * Returns 0 on success, shared secret written to shared_secret_out (32 bytes).
 */
EXPORT int32_t kyber_compute_shared_secret(const uint8_t* server_pub_key,
                                           int32_t len,
                                           uint8_t* shared_secret_out) {
  if (!server_pub_key || len <= 0 || !shared_secret_out) {
    LOGE("kyber_compute_shared_secret: invalid args");
    return -1;
  }

  OQS_KEM* kem = make_kem();
  if (!kem) return -2;

  std::vector<uint8_t> ss(kem->length_shared_secret);
  std::vector<uint8_t> ct(kem->length_ciphertext);

  const int rc = OQS_KEM_encaps(kem, ct.data(), ss.data(), server_pub_key);
  if (rc != OQS_SUCCESS) {
    LOGE("kyber_compute_shared_secret: OQS_KEM_encaps failed (%d)", rc);
    OQS_KEM_free(kem);
    return -3;
  }

  std::memcpy(shared_secret_out, ss.data(), ss.size());
  LOGI("kyber_compute_shared_secret: ok (ss=%zu)", ss.size());

  // Zeroize temp
  secure_bzero(ss.data(), ss.size());
  secure_bzero(ct.data(), ct.size());
  OQS_KEM_free(kem);
  return 0;
}

// ─────────────────────────────────────────────────────────────────────────────
// ✅ Proper KEM client API: encapsulate(server_pk) → ciphertext + shared_secret
// Use this from Flutter (client). Server will decapsulate using its secret key.
// ─────────────────────────────────────────────────────────────────────────────

/**
 * Encapsulate to the given server public key.
 *
 * Inputs:
 *   server_pub_key, pk_len  - server ML-KEM-512 public key
 *   ct_out, ct_out_cap      - output buffer for ciphertext (~768 bytes)
 *   ct_len_out              - actual ciphertext length
 *   ss_out, ss_out_cap      - output buffer for shared secret (32 bytes)
 *   ss_len_out              - actual shared secret length (should be 32)
 *
 * Returns 0 on success.
 */
EXPORT int32_t kyber_encapsulate(const uint8_t* server_pub_key, int32_t pk_len,
                                 uint8_t* ct_out, int32_t ct_out_cap, int32_t* ct_len_out,
                                 uint8_t* ss_out, int32_t ss_out_cap, int32_t* ss_len_out) {
  if (!server_pub_key || pk_len <= 0 || !ct_out || !ct_len_out || !ss_out || !ss_len_out) {
    LOGE("kyber_encapsulate: invalid args");
    return -1;
  }

  OQS_KEM* kem = make_kem();
  if (!kem) return -2;

  const size_t need_ct = kem->length_ciphertext;     // ~768
  const size_t need_ss = kem->length_shared_secret;  // 32

  if (ct_out_cap < static_cast<int32_t>(need_ct) || ss_out_cap < static_cast<int32_t>(need_ss)) {
    LOGE("kyber_encapsulate: insufficient output buffers (ct_cap=%d need=%zu, ss_cap=%d need=%zu)",
         ct_out_cap, need_ct, ss_out_cap, need_ss);
    OQS_KEM_free(kem);
    return -3;
  }

  const int rc = OQS_KEM_encaps(kem, ct_out, ss_out, server_pub_key);
  if (rc != OQS_SUCCESS) {
    LOGE("kyber_encapsulate: OQS_KEM_encaps failed (%d)", rc);
    OQS_KEM_free(kem);
    return -4;
  }

  *ct_len_out = static_cast<int32_t>(need_ct);
  *ss_len_out = static_cast<int32_t>(need_ss);

  LOGI("kyber_encapsulate: ok (ct=%zu, ss=%zu)", need_ct, need_ss);
  OQS_KEM_free(kem);
  return 0;
}

// ─────────────────────────────────────────────────────────────────────────────
// Server-side decapsulation (handy for JNI on backend or local tests)
// ─────────────────────────────────────────────────────────────────────────────

/**
 * Decapsulate on the server with its secret key and the client's ciphertext.
 *
 * Returns 0 on success. Writes 32-byte shared secret to ss_out.
 */
EXPORT int32_t kyber_decapsulate(const uint8_t* server_secret_key, int32_t sk_len,
                                 const uint8_t* ct, int32_t ct_len,
                                 uint8_t* ss_out, int32_t ss_out_cap, int32_t* ss_len_out) {
  if (!server_secret_key || sk_len <= 0 || !ct || ct_len <= 0 || !ss_out || !ss_len_out) {
    LOGE("kyber_decapsulate: invalid args");
    return -1;
  }

  OQS_KEM* kem = make_kem();
  if (!kem) return -2;

  const size_t need_ss = kem->length_shared_secret; // 32
  if (ss_out_cap < static_cast<int32_t>(need_ss)) {
    LOGE("kyber_decapsulate: insufficient ss_out_cap");
    OQS_KEM_free(kem);
    return -3;
  }

  const int rc = OQS_KEM_decaps(kem, ss_out, ct, server_secret_key);
  if (rc != OQS_SUCCESS) {
    LOGE("kyber_decapsulate: OQS_KEM_decaps failed (%d)", rc);
    OQS_KEM_free(kem);
    return -4;
  }

  *ss_len_out = static_cast<int32_t>(need_ss);
  LOGI("kyber_decapsulate: ok (ss=%zu)", need_ss);
  OQS_KEM_free(kem);
  return 0;
}

// ─────────────────────────────────────────────────────────────────────────────
// Diagnostics
// ─────────────────────────────────────────────────────────────────────────────

/** Quick liboqs self-test & length report. */
EXPORT int32_t kyber_test_oqs() {
  LOGI("kyber_test_oqs: start");
  if (!OQS_KEM_alg_is_enabled(OQS_KEM_alg_kyber_512)) {
    LOGE("kyber_test_oqs: Kyber-512 not enabled");
    return -1;
  }
  OQS_KEM* kem = OQS_KEM_new(OQS_KEM_alg_kyber_512);
  if (!kem) {
    LOGE("kyber_test_oqs: OQS_KEM_new failed");
    return -2;
  }
  LOGI("Kyber-512 lengths: pk=%zu sk=%zu ct=%zu ss=%zu",
       kem->length_public_key,
       kem->length_secret_key,
       kem->length_ciphertext,
       kem->length_shared_secret);
  OQS_KEM_free(kem);
  return 0;
}

/** Reset in-memory keys (testing). */
EXPORT void kyber_reset() {
  LOGI("kyber_reset: clearing in-memory keys");
  if (!g_seckey.empty()) secure_bzero(g_seckey.data(), g_seckey.size());
  g_pubkey.clear();
  g_seckey.clear();
  g_keys_initialized = false;
}

} // extern "C"
