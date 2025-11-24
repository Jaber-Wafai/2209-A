# Install script for directory: C:/Users/jaber/Desktop/baklawatiApp/app/android/app/src/main/cpp/liboqs/src

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "C:/Program Files (x86)/nativecrypto")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "RelWithDebInfo")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "0")
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "TRUE")
endif()

# Set default install directory permissions.
if(NOT DEFINED CMAKE_OBJDUMP)
  set(CMAKE_OBJDUMP "C:/Users/jaber/AppData/Local/Android/Sdk/ndk/26.3.11579264/toolchains/llvm/prebuilt/windows-x86_64/bin/llvm-objdump.exe")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/jaber/Desktop/baklawatiApp/app/android/app/.cxx/RelWithDebInfo/464h5g6p/x86_64/liboqs/src/common/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("C:/Users/jaber/Desktop/baklawatiApp/app/android/app/.cxx/RelWithDebInfo/464h5g6p/x86_64/liboqs/src/sig/dilithium/cmake_install.cmake")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/liboqs" TYPE FILE FILES
    "C:/Users/jaber/Desktop/baklawatiApp/app/android/app/.cxx/RelWithDebInfo/464h5g6p/x86_64/liboqs/src/liboqsConfig.cmake"
    "C:/Users/jaber/Desktop/baklawatiApp/app/android/app/.cxx/RelWithDebInfo/464h5g6p/x86_64/liboqs/src/liboqsConfigVersion.cmake"
    )
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/pkgconfig" TYPE FILE FILES "C:/Users/jaber/Desktop/baklawatiApp/app/android/app/.cxx/RelWithDebInfo/464h5g6p/x86_64/liboqs/src/liboqs.pc")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/jaber/Desktop/baklawatiApp/app/android/app/.cxx/RelWithDebInfo/464h5g6p/x86_64/liboqs/lib/liboqs.a")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/liboqs/liboqsTargets.cmake")
    file(DIFFERENT EXPORT_FILE_CHANGED FILES
         "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/liboqs/liboqsTargets.cmake"
         "C:/Users/jaber/Desktop/baklawatiApp/app/android/app/.cxx/RelWithDebInfo/464h5g6p/x86_64/liboqs/src/CMakeFiles/Export/lib/cmake/liboqs/liboqsTargets.cmake")
    if(EXPORT_FILE_CHANGED)
      file(GLOB OLD_CONFIG_FILES "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/liboqs/liboqsTargets-*.cmake")
      if(OLD_CONFIG_FILES)
        message(STATUS "Old export file \"$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/liboqs/liboqsTargets.cmake\" will be replaced.  Removing files [${OLD_CONFIG_FILES}].")
        file(REMOVE ${OLD_CONFIG_FILES})
      endif()
    endif()
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/liboqs" TYPE FILE FILES "C:/Users/jaber/Desktop/baklawatiApp/app/android/app/.cxx/RelWithDebInfo/464h5g6p/x86_64/liboqs/src/CMakeFiles/Export/lib/cmake/liboqs/liboqsTargets.cmake")
  if("${CMAKE_INSTALL_CONFIG_NAME}" MATCHES "^([Rr][Ee][Ll][Ww][Ii][Tt][Hh][Dd][Ee][Bb][Ii][Nn][Ff][Oo])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/liboqs" TYPE FILE FILES "C:/Users/jaber/Desktop/baklawatiApp/app/android/app/.cxx/RelWithDebInfo/464h5g6p/x86_64/liboqs/src/CMakeFiles/Export/lib/cmake/liboqs/liboqsTargets-relwithdebinfo.cmake")
  endif()
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/oqs" TYPE FILE FILES
    "C:/Users/jaber/Desktop/baklawatiApp/app/android/app/src/main/cpp/liboqs/src/oqs.h"
    "C:/Users/jaber/Desktop/baklawatiApp/app/android/app/src/main/cpp/liboqs/src/common/aes/aes_ops.h"
    "C:/Users/jaber/Desktop/baklawatiApp/app/android/app/src/main/cpp/liboqs/src/common/common.h"
    "C:/Users/jaber/Desktop/baklawatiApp/app/android/app/src/main/cpp/liboqs/src/common/rand/rand.h"
    "C:/Users/jaber/Desktop/baklawatiApp/app/android/app/src/main/cpp/liboqs/src/common/sha2/sha2_ops.h"
    "C:/Users/jaber/Desktop/baklawatiApp/app/android/app/src/main/cpp/liboqs/src/common/sha3/sha3_ops.h"
    "C:/Users/jaber/Desktop/baklawatiApp/app/android/app/src/main/cpp/liboqs/src/common/sha3/sha3x4_ops.h"
    "C:/Users/jaber/Desktop/baklawatiApp/app/android/app/src/main/cpp/liboqs/src/kem/kem.h"
    "C:/Users/jaber/Desktop/baklawatiApp/app/android/app/src/main/cpp/liboqs/src/sig/sig.h"
    "C:/Users/jaber/Desktop/baklawatiApp/app/android/app/src/main/cpp/liboqs/src/sig/dilithium/sig_dilithium.h"
    "C:/Users/jaber/Desktop/baklawatiApp/app/android/app/.cxx/RelWithDebInfo/464h5g6p/x86_64/liboqs/include/oqs/oqsconfig.h"
    )
endif()

