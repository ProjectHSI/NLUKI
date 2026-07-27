NLUKI_KLIBC_SHARED_OPTIONS := KLIBCARCH=$(NLUKI_KERNEL_ARCH) CROSS_COMPILE=$(NLUKI_GCC_ARCH)-pc-linux- INSTALLROOT=$(NLUKI_TARGET_SYSROOT_OVERLAYS)/klibc KLIBCKERNELSRC=$(NLUKI_BUILDROOT)/PrimarySysRoot/usr/

# Install KLibc
$(NLUKI_BUILDROOT)/klibc-install.stamp: $(NLUKI_BUILDROOT)/klibc-build.stamp
	mkdir -p $(NLUKI_TARGET_SYSROOT_OVERLAYS)/klibc
	$(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_PATH,crosssysroot); $(call NLUKI_AUTO_HOST_CLASSIC_SYSROOT_PATH,hostsysroot); \
	$(NLUKI_QUICK_TARGET_COMPILER_ENV); \
	$(MAKE) -C $(NLUKI_TARGET_BUILDROOT)/klibc \
	-f $(MKFILE_DIR)/Submodules/klibc/Makefile KBUILD_SRC=$(MKFILE_DIR)/Submodules/klibc $(NLUKI_KLIBC_SHARED_OPTIONS) install
	touch $(NLUKI_BUILDROOT)/klibc-install.stamp

klibc-install: $(NLUKI_BUILDROOT)/klibc-install.stamp
.PHONY : klibc-install

# Make KLibC
$(NLUKI_BUILDROOT)/klibc-build.stamp: $(NLUKI_BUILDROOT)/linux_headers-install.stamp $(NLUKI_BUILDROOT)/firstpass-gcc-install.stamp $(NLUKI_BUILDROOT)/binutils-install.stamp | $(MKFILE_DIR)/Submodules/klibc
	mkdir -p $(NLUKI_TARGET_BUILDROOT)/klibc
	$(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_PATH,crosssysroot); $(call NLUKI_AUTO_HOST_CLASSIC_SYSROOT_PATH,hostsysroot); \
	$(NLUKI_QUICK_TARGET_COMPILER_ENV); \
	$(MAKE) -C $(NLUKI_TARGET_BUILDROOT)/klibc \
	-f $(MKFILE_DIR)/Submodules/klibc/Makefile KBUILD_SRC=$(MKFILE_DIR)/Submodules/klibc $(NLUKI_KLIBC_SHARED_OPTIONS)
	touch $(NLUKI_BUILDROOT)/klibc-build.stamp

klibc-build: $(NLUKI_BUILDROOT)/klibc-build.stamp
.PHONY : klibc-build