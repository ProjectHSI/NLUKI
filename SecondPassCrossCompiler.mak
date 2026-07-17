#NLUKI_GCC_SECONDPASS_PREFIX = gcc-
#NLUKI_BINUTILS_SECONDPASS_PREFIX = binutils-
$(NLUKI_BUILDROOT)/gcc-install.stamp: $(NLUKI_BUILDROOT)/gcc-build.stamp
	mkdir -p $(NLUKI_TARGET_SYSROOT_OVERLAYS)/gcc
	$(call NLUKI_AUTO_HOST_CLASSIC_SYSROOT_PATH,hostsysroot); $(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_PATH,crosssysroot); \
	$(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_CPATH,crosssysroot); $(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_LIBRARY_PATH,crosssysroot); \
	$(NLUKI_AUTO_TARGET_PRIMARYSYSROOT_LIBRARY_PATH); $(NLUKI_AUTO_TARGET_PRIMARYSYSROOT_CPATH); \
	cd $(NLUKI_TARGET_BUILDROOT)/gcc; $(MAKE) install
	touch $(NLUKI_BUILDROOT)/gcc-install.stamp

gcc-install: $(NLUKI_BUILDROOT)/gcc-install.stamp
.PHONY: gcc-install

# Make Second Pass Target GCC
$(NLUKI_BUILDROOT)/gcc-build.stamp: $(DEPENDS_ON_GCC) $(NLUKI_TARGET_BUILDROOT)/gcc/Makefile
	$(call NLUKI_AUTO_HOST_CLASSIC_SYSROOT_PATH,hostsysroot); $(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_PATH,crosssysroot); \
	$(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_CPATH,crosssysroot); $(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_LIBRARY_PATH,crosssysroot); \
	$(NLUKI_AUTO_TARGET_PRIMARYSYSROOT_LIBRARY_PATH); $(NLUKI_AUTO_TARGET_PRIMARYSYSROOT_CPATH); \
	cd $(NLUKI_TARGET_BUILDROOT)/gcc; $(MAKE)
	touch $(NLUKI_BUILDROOT)/gcc-build.stamp

gcc-build: $(NLUKI_BUILDROOT)/gcc-build.stamp
.PHONY: gcc-build

# Configure Second Pass Target GCC
$(NLUKI_TARGET_BUILDROOT)/gcc/Makefile: $(DEPENDS_ON_BINUTILS) $(DEPENDS_ON_GCC) $(NLUKI_BUILDROOT)/glibc-install.stamp $(NLUKI_BUILDROOT)/binutils-install.stamp $(NLUKI_BUILDROOT)/firstpass-gcc-install.stamp
	mkdir -p $(NLUKI_TARGET_BUILDROOT)/gcc
	mkdir -p $(NLUKI_TARGET_SYSROOT)
	cd $(NLUKI_TARGET_BUILDROOT)/gcc; \
	$(call NLUKI_AUTO_HOST_CLASSIC_SYSROOT_PATH,hostsysroot); $(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_PATH,crosssysroot); \
	$(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_CPATH,crosssysroot); $(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_LIBRARY_PATH,crosssysroot); \
	$(NLUKI_AUTO_TARGET_PRIMARYSYSROOT_LIBRARY_PATH); $(NLUKI_AUTO_TARGET_PRIMARYSYSROOT_CPATH); \
	$(MKFILE_DIR)/Submodules/gcc/configure \
		$(NLUKI_GCC_OPTIONS) \
		--prefix=$(NLUKI_TARGET_CLASSIC_SYSROOTS)/crosssysroot \
		--target=$(NLUKI_TARGET_ARCH)-pc-linux \
		--with-sysroot=$(NLUKI_BUILDROOT)/PrimarySysRoot \
		--enable-default-pie --enable-default-ssp --disable-multilib \
		--with-glibc-version=2.43 --enable-languages=c,c++ \
		--disable-werror CFLAGS="-Wno-format-security -O3" CXXFLAGS="-Wno-format-security -O3"