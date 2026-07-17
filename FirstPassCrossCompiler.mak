# --- Install First Pass Target GCC
$(NLUKI_BUILDROOT)/firstpass-gcc-install.stamp: $(NLUKI_BUILDROOT)/firstpass-gcc-build.stamp
	mkdir -p $(NLUKI_TARGET_CLASSIC_SYSROOTS)/crosssysroot
	mkdir -p $(NLUKI_BUILDROOT)/PrimarySysRoot
	$(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_PATH,crosssysroot); $(call NLUKI_AUTO_HOST_CLASSIC_SYSROOT_PATH,hostsysroot); cd $(NLUKI_TARGET_BUILDROOT)/fp_gcc; $(MAKE) install
	touch $(NLUKI_BUILDROOT)/firstpass-gcc-install.stamp

firstpass-gcc-install: $(NLUKI_BUILDROOT)/firstpass-gcc-install.stamp
.PHONY: firstpass-gcc-install

# --- Make First Pass Target GCC
$(NLUKI_BUILDROOT)/firstpass-gcc-build.stamp: $(DEPENDS_ON_GCC) $(NLUKI_TARGET_BUILDROOT)/fp_gcc/Makefile
	$(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_PATH,crosssysroot); $(call NLUKI_AUTO_HOST_CLASSIC_SYSROOT_PATH,hostsysroot); cd $(NLUKI_TARGET_BUILDROOT)/fp_gcc; $(MAKE)
	touch $(NLUKI_BUILDROOT)/firstpass-gcc-build.stamp

firstpass-gcc-build: $(NLUKI_BUILDROOT)/firstpass-gcc-build.stamp
.PHONY: firstpass-gcc-build

# First Pass Target GCC Easy-Target
firstpass-gcc-configure: $(NLUKI_TARGET_BUILDROOT)/fp_gcc/Makefile ;
.PHONY: firstpass-gcc-configure

# Configure First Pass Target GCC
$(NLUKI_TARGET_BUILDROOT)/fp_gcc/Makefile: $(NLUKI_BUILDROOT)/binutils-install.stamp $(DEPENDS_ON_GCC)
	mkdir -p $(NLUKI_TARGET_BUILDROOT)/fp_gcc
	cd $(NLUKI_TARGET_BUILDROOT)/fp_gcc; \
	$(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_PATH,crosssysroot); $(call NLUKI_AUTO_HOST_CLASSIC_SYSROOT_PATH,hostsysroot); $(MKFILE_DIR)/Submodules/gcc/configure \
		$(NLUKI_GCC_OPTIONS) \
		--prefix=$(NLUKI_TARGET_CLASSIC_SYSROOTS)/crosssysroot \
		--target=$(NLUKI_TARGET_ARCH)-pc-linux \
		--disable-multilib --disable-threads --disable-libatomic \
		--disable-libgomp --disable-libquadmath \
		--disable-libssp --disable-libvtv --disable-libstdcxx \
		--with-newlib --disable-nls --disable-shared \
		--enable-default-pie --enable-default-ssp --without-headers \
		--with-glibc-version=2.43 --enable-languages=c,c++ \
		--disable-werror CFLAGS="-Wno-format-security" CXXFLAGS="-Wno-format-security"

#$(eval $(call NLUKI_MAKE_SYS_ROOT_TARGET,fp_gcc,fp_binutils,,gcc binutils))

# --- Install Target Binutils
$(NLUKI_BUILDROOT)/binutils-install.stamp: $(NLUKI_BUILDROOT)/binutils-build.stamp
	mkdir -p $(NLUKI_TARGET_CLASSIC_SYSROOTS)/crosssysroot
	$(call NLUKI_AUTO_HOST_CLASSIC_SYSROOT_PATH,hostsysroot); cd $(NLUKI_TARGET_BUILDROOT)/binutils; $(MAKE) install
	touch $(NLUKI_BUILDROOT)/binutils-install.stamp

binutils-install: $(NLUKI_BUILDROOT)/binutils-install.stamp
.PHONY: binutils-install

# --- Make Target Binutils
$(NLUKI_BUILDROOT)/binutils-build.stamp: $(DEPENDS_ON_BINUTILS) $(NLUKI_TARGET_BUILDROOT)/binutils/Makefile
	$(call NLUKI_AUTO_HOST_CLASSIC_SYSROOT_PATH,hostsysroot); cd $(NLUKI_TARGET_BUILDROOT)/binutils; $(MAKE)
	touch $(NLUKI_BUILDROOT)/binutils-build.stamp

binutils-build: $(NLUKI_BUILDROOT)/binutils-build.stamp
.PHONY: binutils-build

# --- Target Binutils Easy-Target
binutils-configure: $(NLUKI_TARGET_BUILDROOT)/binutils/Makefile ;
.PHONY: binutils-configure

# --- Configure Target Binutils
$(NLUKI_TARGET_BUILDROOT)/binutils/Makefile: $(DEPENDS_ON_BINUTILS) $(NLUKI_HOSTROOT)/nluki-host.stamp
	mkdir -p $(NLUKI_TARGET_BUILDROOT)/binutils
	cd $(NLUKI_TARGET_BUILDROOT)/binutils; \
	$(call NLUKI_AUTO_HOST_CLASSIC_SYSROOT_PATH,hostsysroot); $(MKFILE_DIR)/Submodules/binutils/configure \
		$(NLUKI_BINUTILS_OPTIONS) \
		--target=$(NLUKI_TARGET_ARCH)-pc-linux \
		--prefix=$(NLUKI_TARGET_CLASSIC_SYSROOTS)/crosssysroot \
		--disable-nls --enable-gprofng=no --enable-new-dtags \
		--enable-default-hash-style=gnu --enable-shared --disable-werror \
		--enable-64-bit-bfd CFLAGS="-O3" CXXFLAGS="-O3"