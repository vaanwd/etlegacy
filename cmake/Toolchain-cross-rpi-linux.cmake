############################################################################
# toolchain-raspberry.cmake
# Copyright (C) 2021  ET Legacy Team
# Copyright (C) 2014  Belledonne Communications, Grenoble France
#
############################################################################
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
############################################################################

# Based on:
# https://gitlab.linphone.org/BC/public/linphone-cmake-builder/blob/master/toolchains/toolchain-raspberry.cmake

# RASPBIAN_ROOTFS should point to the local directory which contains all the libraries and includes from the target raspi.
# Get them with:
# rsync -vR --progress -rl --delete-after --safe-links pi@192.168.1.PI:/{lib,usr,opt/vc/lib} $HOME/rpi/rootfs
# Then RASPBIAN_ROOTFS=$HOME/rpi/rootfs

if("$ENV{RASPBIAN_ROOTFS}" STREQUAL "")
	message(FATAL_ERROR "Define the RASPBIAN_ROOTFS environment variable to point to the raspbian rootfs.")
else()
	set(SYSROOT_PATH "$ENV{RASPBIAN_ROOTFS}")
endif()
set(TOOLCHAIN_HOST "arm-linux-gnueabihf")

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
set(CMAKE_C_COMPILER ${TOOLCHAIN_CC})
set(CMAKE_CXX_COMPILER ${TOOLCHAIN_CXX})

# List of library dirs where LD has to look. Pass them directly through gcc. LD_LIBRARY_PATH is not evaluated by arm-*-ld
set(LIB_DIRS 
	"/opt/cross-pi-gcc/arm-linux-gnueabihf/lib"
	"/opt/cross-pi-gcc/lib"
	"${SYSROOT_PATH}/opt/vc/lib"
	"${SYSROOT_PATH}/lib/${TOOLCHAIN_HOST}"
	"${SYSROOT_PATH}/usr/local/lib"
	"${SYSROOT_PATH}/usr/lib/${TOOLCHAIN_HOST}"
	"${SYSROOT_PATH}/usr/lib"
	"${SYSROOT_PATH}/usr/lib/${TOOLCHAIN_HOST}/blas"
	"${SYSROOT_PATH}/usr/lib/${TOOLCHAIN_HOST}/lapack"
)
# You can additionally check the linker paths if you add the flags ' -Xlinker --verbose'
set(COMMON_FLAGS "-I${SYSROOT_PATH}/usr/include ")
FOREACH(LIB ${LIB_DIRS})
	set(COMMON_FLAGS "${COMMON_FLAGS} -L${LIB} -Wl,-rpath-link,${LIB}")
ENDFOREACH()

set(CMAKE_PREFIX_PATH "${CMAKE_PREFIX_PATH};${SYSROOT_PATH}/usr/lib/${TOOLCHAIN_HOST}")
set(CMAKE_FIND_ROOT_PATH "${CMAKE_INSTALL_PREFIX};${CMAKE_PREFIX_PATH};${CMAKE_SYSROOT}")


# search for programs in the build host directories
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# for libraries and headers in the target directories
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
