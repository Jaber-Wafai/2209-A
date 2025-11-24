cmake_minimum_required(VERSION 3.10.2)
project(nativecrypto LANGUAGES C CXX)

# ---- Build type / visibility / PIC -------------------------------------------------
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type" FORCE)
endif()

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

# Hide all symbols by default; we explicitly mark JNI exports in code
set(CMAKE_C_VISIBILITY_PRESET hidden)
set(CMAKE_CXX_VISIBILITY_PRESET hidden)
set(CMAKE_VISIBILITY_INLINES_HIDDEN ON)

# ---- liboqs feature switches (future-proof) ---------------------------------------
# Some liboqs versions gate Kyber under ML-KEM; others still expose KYBER.
# Turn ON both to be safe; liboqs will ignore unknown/obsolete switches.
set(OQS_USE_OPENSSL OFF CACHE BOOL "Disable OpenSSL")
set(OQS_ENABLE_SIG_DILITHIUM ON  CACHE BOOL "Enable Dilithium signature scheme")

# Newer naming (preferred as of recent liboqs)
set(OQS_ENABLE_KEM_ML_KEM ON CACHE BOOL "Enable ML-KEM (Kyber)")

# Older naming (fallback/alias)
set(OQS_ENABLE_KEM_KYBER  ON CACHE BOOL "Enable Kyber KEM (alias)")

# Disable everything you don't use (optional, keeps build small)
set(OQS_ENABLE_SIG_FALCON            OFF CACHE BOOL "")
set(OQS_ENABLE_SIG_SPHINCS           OFF CACHE BOOL "")
set(OQS_ENABLE_KEM_BIKE              OFF CACHE BOOL "")
set(OQS_ENABLE_KEM_FRODOKEM          OFF CACHE BOOL "")
set(OQS_ENABLE_KEM_SABER             OFF CACHE BOOL "")
set(OQS_ENABLE_KEM_NTRUPRIME         OFF CACHE BOOL "")
set(OQS_ENABLE_KEM_CLASSIC_MCELIECE  OFF CACHE BOOL "")
set(OQS_ENABLE_KEM_HQC               OFF CACHE BOOL "")

# ---- Bring liboqs ---------------------------------------------------------------
# Expect liboqs as a subfolder: ${CMAKE_SOURCE_DIR}/liboqs
# This creates target 'oqs'
add_subdirectory(liboqs)

# ---- Android log lib ------------------------------------------------------------
find_library(log-lib log)

# ---- Includes ------------------------------------------------------------------
include_directories(
  ${CMAKE_SOURCE_DIR}
  ${CMAKE_SOURCE_DIR}/liboqs/include
  ${CMAKE_BINARY_DIR}/liboqs/include
)

# ---- Dilithium shared lib ------------------------------------------------------
add_library(dilithium SHARED
  dilithium_native.cpp
  base64.cpp
)

target_link_libraries(dilithium
  oqs
  ${log-lib}
)

target_compile_definitions(dilithium PRIVATE
  # ensure we use default visibility only for explicitly annotated symbols
  DILITHIUMJNI_EXPORTS
)

# ---- Kyber shared lib -----------------------------------------------------------
add_library(kyber SHARED
  kyber_native.cpp
  base64.cpp
)

target_link_libraries(kyber
  oqs
  ${log-lib}
)

target_compile_definitions(kyber PRIVATE
  KYBERNATIVE_EXPORTS
)

# Optional: tighten warnings (uncomment if you want)
# foreach(tgt dilithium kyber)
#   target_compile_options(${tgt} PRIVATE -Wall -Wextra -Wconversion -Wno-unused-parameter)
# endforeach()
