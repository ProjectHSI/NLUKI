ifeq ($(origin MKFILE_DIR), undefined)
  MKFILE := $(abspath $(lastword $(MAKEFILE_LIST)))
  MKFILE_DIR := $(dir $(MKFILE))
  PWD := $(shell pwd)
endif

include $(MKFILE_DIR)/Globals.mak

include $(MKFILE_DIR)/HostClassicSysRootSupport.mak
include $(MKFILE_DIR)/HostSegmentedSysRootSupport.mak

$(NLUKI_HOSTROOT)/nluki-host.stamp: $(NLUKI_HOSTROOT)/host-glibc-install.sentinel $(NLUKI_HOSTROOT)/host-gcc-install.sentinel $(NLUKI_HOSTROOT)/host-binutils-install.sentinel
	touch $(NLUKI_HOSTROOT)/nluki-host.stamp

nluki-host: $(NLUKI_HOSTROOT)/nluki-host.stamp
.PHONY : nluki-host

include Host.*.mak