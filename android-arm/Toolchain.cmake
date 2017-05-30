set(CMAKE_SYSTEM_NAME Android)
set(CMAKE_SYSTEM_VERSION 1)
set(CMAKE_ANDROID_ARCH_ABI armeabi-v7a)

set(cross_triple arm-linux-androideabi)
set(CMAKE_ANDROID_STANDALONE_TOOLCHAIN /usr/${cross_triple}/)
set(CMAKE_ANDROID_ARM_MODE 1)
set(CMAKE_ANDROID_ARM_NEON 1)

set(CMAKE_C_COMPILER /usr/${cross_triple}/bin/${cross_triple}-clang)
set(CMAKE_CXX_COMPILER /usr/${cross_triple}/bin/${cross_triple}-clang++)

set(CMAKE_FIND_ROOT_PATH /usr/${cross_triple})
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY BOTH)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE BOTH)
set(CMAKE_SYSROOT $ENV{CROSS_ROOT}/sysroot)

set(CMAKE_CROSSCOMPILING_EMULATOR /usr/bin/qemu-arm)
