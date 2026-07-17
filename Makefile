MKFILE := $(abspath $(lastword $(MAKEFILE_LIST)))
MKFILE_DIR := $(dir $(MKFILE))
PWD := $(shell pwd)

include $(MKFILE_DIR)/Globals.mak

$(NLUKI_BUILDROOT)/VMLinux.efi: $(NLUKI_BUILDROOT)/VMLinux-pre.efi
	cp -fv $(NLUKI_BUILDROOT)/VMLinux-pre.efi $(NLUKI_BUILDROOT)/VMLinux.efi

ifneq ($(NLUKI_DISABLE_HOST_MAKEFILE_INC),yes)
include $(MKFILE_DIR)/Host.mak
endif

include $(MKFILE_DIR)/PathSupport.mak
include $(MKFILE_DIR)/ClassicSysRootSupport.mak
include $(MKFILE_DIR)/SegmentedSysRootSupport.mak
include $(MKFILE_DIR)/PrimarySysRootSupport.mak

include $(MKFILE_DIR)/FirstPassCrossCompiler.mak
include $(MKFILE_DIR)/LinuxKernelHeaders.mak
include $(MKFILE_DIR)/LSB.mak
include $(MKFILE_DIR)/GLibC.mak
include $(MKFILE_DIR)/KLibC.mak

include $(MKFILE_DIR)/BareSysRoot.mak

include $(MKFILE_DIR)/SecondPassCrossCompiler.mak

include $(wildcard $(MKFILE_DIR)/Packages/**.mak)

include $(MKFILE_DIR)/Kernel.mak

include $(MKFILE_DIR)/PrimarySysRoot.mak

include $(MKFILE_DIR)/JumpStarter/Makefile
include $(MKFILE_DIR)/JumpStarterSysRoot.mak

# Download GCC Prerequisites
$(GCC_PREREQS):	
	cd $(MKFILE_DIR)/Submodules/gcc; contrib/download_prerequisites
	
.NOTPARALLEL: $(GCC_PREREQS)

ifneq ($(NLUKI_BYPASS_NIX_CHECK),yes)
ifneq ($(IN_NIX_SHELL),pure)
  $(error Please run 'make' inside a NixOS Shell with the '--pure' flag)
endif
endif

ifeq ($(findstring L,$(MAKEFLAGS)),)
  #$(shell echo $(MAKEFLAGS))
  $(error Please run 'make' with the -L flag. It is required for this Makefile to work properly)
endif