ifeq ($(origin MKFILE_DIR), undefined)
  MKFILE := $(abspath $(lastword $(MAKEFILE_LIST)))
  MKFILE_DIR := $(dir $(MKFILE))
  PWD := $(shell pwd)
endif

ifeq ($(origin NLUKI_COMING_FROM), undefined)
  NLUKI_COMING_FROM := Host.mak
endif

include $(MKFILE_DIR)/Globals.mak

include $(MKFILE_DIR)/HostClassicSysRootSupport.mak
include $(MKFILE_DIR)/HostSegmentedSysRootSupport.mak

$(NLUKI_HOSTROOT)/nluki-host.stamp: $(NLUKI_HOSTROOT)/host-glibc-install.sentinel $(NLUKI_HOSTROOT)/host-gcc-install.sentinel $(NLUKI_HOSTROOT)/host-binutils-install.sentinel $(NLUKI_HOSTROOT)/nluki-host-extra.stamp
	touch $(NLUKI_HOSTROOT)/nluki-host.stamp

nluki-host: $(NLUKI_HOSTROOT)/nluki-host.stamp
.PHONY : nluki-host

NLUKI_TARGETS_TO_STILL_BUILD_AS_HOST := 

include Host.*.mak

$(NLUKI_HOSTROOT)/nluki-host-extra.stamp:
	mkdir -p $(NLUKI_HOSTROOT)/
	touch $(NLUKI_HOSTROOT)/nluki-host-extra.stamp

nluki-host-extra: $(NLUKI_HOSTROOT)/nluki-host-extra.stamp
.PHONY : nluki-host-extra

ifeq ($(NLUKI_COMING_FROM),Host.mak)
include $(wildcard $(MKFILE_DIR)/Packages/**.mak)

nluki-host-extra: $(NLUKI_TARGETS_TO_STILL_BUILD_AS_HOST)
endif
