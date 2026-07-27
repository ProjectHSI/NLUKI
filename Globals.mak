HOST_CC ?= gcc
export NLUKI_TARGET_ARCH ?= x86_64
# TODO: This won't work with a target arch of "Host".
ifeq ($(NLUKI_TARGET_ARCH),x86_64)
export NLUKI_TARGET_WORD_SIZE ?= 64
export NLUKI_KERNEL_ARCH := x86_64
export NLUKI_GCC_ARCH := x86_64

else ifeq ($(NLUKI_TARGET_ARCH),x86)
export NLUKI_TARGET_WORD_SIZE ?= 32
export NLUKI_KERNEL_ARCH := x86
export NLUKI_GCC_ARCH := i686

else ifeq ($(NLUKI_TARGET_ARCH),arm64)
export NLUKI_TARGET_WORD_SIZE ?= 64
export NLUKI_KERNEL_ARCH := arm64
export NLUKI_GCC_ARCH := aarch64

else ifeq ($(NLUKI_TARGET_ARCH),arm)
export NLUKI_TARGET_WORD_SIZE ?= 64
export NLUKI_KERNEL_ARCH := arm64
export NLUKI_GCC_ARCH := arm
endif

NLUKI_GCC_OPTIONS := --disable-bootstrap --enable-year2038
NLUKI_BINUTILS_OPTIONS :=

NLUKI_GCC_SOURCE := $(MKFILE_DIR)/Submodules/gcc/

NLUKI_BUILDROOT := $(PWD)/Build/$(NLUKI_TARGET_ARCH)/
NLUKI_HOSTROOT := $(PWD)/Build/Host/
NLUKI_DEV_SYSROOT := $(NLUKI_BUILDROOT)/DevSysRoot/
NLUKI_TARGET_SYSROOT := $(NLUKI_BUILDROOT)/SysRoot/
NLUKI_HOST_SYSROOT := $(NLUKI_HOSTROOT)/SysRoot/
NLUKI_TARGET_BUILDROOT := $(NLUKI_BUILDROOT)/BuildRoot/
NLUKI_HOST_BUILDROOT := $(NLUKI_HOSTROOT)/BuildRoot/
NLUKI_TARGET_SYSROOT_OVERLAYS := $(NLUKI_BUILDROOT)/SysRootOverlays/
NLUKI_HOST_SYSROOT_OVERLAYS := $(NLUKI_HOSTROOT)/SysRootOverlays/
NLUKI_TARGET_SYSROOTS := $(NLUKI_BUILDROOT)/SysRoots/
NLUKI_HOST_SYSROOTS := $(NLUKI_HOSTROOT)/SysRoots/
NLUKI_TARGET_CLASSIC_SYSROOTS := $(NLUKI_BUILDROOT)/ClassicSysRoots/
NLUKI_HOST_CLASSIC_SYSROOTS := $(NLUKI_HOSTROOT)/ClassicSysRoots/

NLUKI_HOST_TRIPLET = $(shell $(NLUKI_HOST_CLASSIC_SYSROOTS)/hostsysroot/usr/bin/gcc -dumpmachine)

NLUKI_QUICK_TARGET_COMPILER_ENV := export CC=$(NLUKI_GCC_ARCH)-pc-linux-gcc LD=$(NLUKI_GCC_ARCH)-pc-linux-ld OBJCOPY=$(NLUKI_GCC_ARCH)-pc-linux-objcopy READELF=$(NLUKI_GCC_ARCH)-pc-linux-readelf AR=$(NLUKI_GCC_ARCH)-pc-linux-ar OBJDUMP=$(NLUKI_GCC_ARCH)-pc-linux-objdump STRIP=$(NLUKI_GCC_ARCH)-pc-linux-strip NM=$(NLUKI_GCC_ARCH)-pc-linux-nm CXX=$(NLUKI_GCC_ARCH)-pc-linux-g++

# Add some of these to the start of a command if bad env vars are ruining a build.

# Makes sure Nix doesn't mess up a cross-compile.
NLUKI_DESTROY_BAD_ENV_VARS := export CPATH=""; export NIX_CFLAGS_COMPILE=""