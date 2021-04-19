#-----------------------------------------------------------------
# Toolchain Cross RPI 2/3/4 onlyarmv7
#-----------------------------------------------------------------

if("$ENV{RASPBIAN_ROOTFS}" STREQUAL "")
	message(FATAL_ERROR "Define the RASPBIAN_ROOTFS environment variable to point to the raspbian rootfs.")
else()
	set(SYSROOT_PATH "$ENV{RASPBIAN_ROOTFS}")
endif()

# This one will be changing more often than anticipated
set(TOOLCHAIN_HOST "armv7-rpi3-linux-gnueabihf")

message(STATUS "Using sysroot path: ${SYSROOT_PATH}")

set(TOOLCHAIN_CC "${TOOLCHAIN_HOST}-gcc")
set(TOOLCHAIN_CXX "${TOOLCHAIN_HOST}-g++")
set(TOOLCHAIN_LD "${TOOLCHAIN_HOST}-ld")
set(TOOLCHAIN_AR "${TOOLCHAIN_HOST}-ar")
set(TOOLCHAIN_RANLIB "${TOOLCHAIN_HOST}-ranlib")
set(TOOLCHAIN_STRIP "${TOOLCHAIN_HOST}-strip")
set(TOOLCHAIN_NM "${TOOLCHAIN_HOST}-nm")

set(CMAKE_CROSSCOMPILING TRUE)
set(CMAKE_SYSROOT "${SYSROOT_PATH}")

# Define name of the target system
set(CMAKE_SYSTEM_NAME "Linux")
set(CMAKE_SYSTEM_PROCESSOR "armv7l")

# Define the compiler
set(CMAKE_C_COMPILER_WORKS 1)
set(CMAKE_CXX_COMPILER_WORKS 1)
set(CMAKE_C_COMPILER ${TOOLCHAIN_CC})
set(CMAKE_CXX_COMPILER ${TOOLCHAIN_CXX})

set(CMAKE_PREFIX_PATH "${CMAKE_PREFIX_PATH};${SYSROOT_PATH}/usr/lib/arm-linux-gnueabihf")
set(CMAKE_FIND_ROOT_PATH "${CMAKE_INSTALL_PREFIX};${CMAKE_PREFIX_PATH};${CMAKE_SYSROOT}")

# search for programs in the build host directories
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# for libraries and headers in the target directories
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

