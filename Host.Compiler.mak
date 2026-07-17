HOST_GLIBC_FLAGS := -O3
HOST_GLIBC_FLAGS_EXPANDED := CFLAGS="$(HOST_GLIBC_FLAGS)" CXXFLAGS="$(HOST_GLIBC_FLAGS)"

# TODO: I really don't like how this second-pass overwrites the first-pass of GCC.
#       Should probably be replaced with a more robust system at somepoint, but I just don't know how.
#       ~ ProjectHSI

# Make Host GCC
$(NLUKI_HOSTROOT)/host-gcc-install.sentinel: $(NLUKI_HOSTROOT)/host-gcc-build.sentinel
	mkdir -p $(NLUKI_HOST_CLASSIC_SYSROOTS)/hostsysroot
	cd $(NLUKI_HOST_BUILDROOT)/gcc; $(MAKE) install
	touch $(NLUKI_HOSTROOT)/host-gcc-install.sentinel

$(NLUKI_HOSTROOT)/host-gcc-build.sentinel: $(DEPENDS_ON_GCC) $(NLUKI_HOST_BUILDROOT)/gcc/Makefile
	$(NLUKI_DESTROY_BAD_ENV_VARS); $(call NLUKI_AUTO_HOST_CLASSIC_SYSROOT_PATH,hostsysroot); $(call NLUKI_AUTO_HOST_CLASSIC_SYSROOT_CPATH,hostsysroot); $(call NLUKI_AUTO_HOST_CLASSIC_SYSROOT_LIBRARY_PATH,hostsysroot); \
	cd $(NLUKI_HOST_BUILDROOT)/gcc; $(MAKE)
	touch $(NLUKI_HOSTROOT)/host-gcc-build.sentinel

# Configure Host GCC
$(NLUKI_HOST_BUILDROOT)/gcc/Makefile: $(DEPENDS_ON_GCC) $(NLUKI_HOSTROOT)/host-glibc-install.sentinel \
									$(NLUKI_HOSTROOT)/host-fp-gcc-install.sentinel $(NLUKI_HOSTROOT)/host-binutils-install.sentinel
	mkdir -p $(NLUKI_HOST_BUILDROOT)/gcc
	mkdir -p $(NLUKI_HOST_SYSROOT)
	cd $(NLUKI_HOST_BUILDROOT)/gcc; \
	$(NLUKI_DESTROY_BAD_ENV_VARS); $(call NLUKI_AUTO_HOST_CLASSIC_SYSROOT_PATH,hostsysroot); $(call NLUKI_AUTO_HOST_CLASSIC_SYSROOT_CPATH,hostsysroot); $(call NLUKI_AUTO_HOST_CLASSIC_SYSROOT_LIBRARY_PATH,hostsysroot); \
	$(MKFILE_DIR)/Submodules/gcc/configure \
		$(NLUKI_GCC_OPTIONS) \
		--prefix=$(NLUKI_HOST_CLASSIC_SYSROOTS)/hostsysroot \
		--disable-multilib \
		--disable-nls --disable-libsanitizer \
		--with-glibc-version=2.43 --enable-languages=c,c++ \
		--with-native-system-header-dir=$(NLUKI_HOST_CLASSIC_SYSROOTS)/hostsysroot
		--with-sysroot=$(NLUKI_HOST_CLASSIC_SYSROOTS)/hostsysroot
		--disable-werror CFLAGS="-Wno-format-security -O3" CXXFLAGS="-Wno-format-security -O3"

#$(eval $(call NLUKI_MAKE_SYS_ROOT_HOST,gcc,glibc libstdc++ binutils fp-gcc,,))

# Make libstdc++
#$(NLUKI_HOSTROOT)/host-libstdc++-install.sentinel: $(NLUKI_HOSTROOT)/host-libstdc++-build.sentinel
#	mkdir -p $(NLUKI_HOST_CLASSIC_SYSROOTS)/hostsysroot
#	cd $(NLUKI_HOST_BUILDROOT)/libstdc++; $(MAKE) install
#	touch $(NLUKI_HOSTROOT)/host-libstdc++-install.sentinel
	
#$(NLUKI_HOSTROOT)/host-libstdc++-build.sentinel: $(NLUKI_HOST_BUILDROOT)/libstdc++/Makefile
#	$(NLUKI_DESTROY_BAD_ENV_VARS); $(call NLUKI_AUTO_HOST_CLASSIC_SYSROOT_PATH,hostsysroot); $(call NLUKI_AUTO_HOST_CLASSIC_SYSROOT_CPATH,hostsysroot); $(call NLUKI_AUTO_HOST_CLASSIC_SYSROOT_LIBRARY_PATH,hostsysroot); \
	cd $(NLUKI_HOST_BUILDROOT)/libstdc++; $(MAKE)
#	touch $(NLUKI_HOSTROOT)/host-libstdc++-build.sentinel

# Configure libstdc++
$(NLUKI_HOST_BUILDROOT)/libstdc++/Makefile: $(DEPENDS_ON_GCC) $(NLUKI_HOSTROOT)/host-glibc-install.sentinel
	mkdir -p $(NLUKI_HOST_BUILDROOT)/libstdc++
	mkdir -p $(NLUKI_HOST_SYSROOT)
	cd $(NLUKI_HOST_BUILDROOT)/libstdc++; \
	$(NLUKI_DESTROY_BAD_ENV_VARS); $(call NLUKI_AUTO_HOST_CLASSIC_SYSROOT_PATH,hostsysroot); $(call NLUKI_AUTO_HOST_CLASSIC_SYSROOT_CPATH,hostsysroot); $(call NLUKI_AUTO_HOST_CLASSIC_SYSROOT_LIBRARY_PATH,hostsysroot); \
	$(MKFILE_DIR)/Submodules/gcc/libstdc++-v3/configure \
		--prefix=$(NLUKI_HOST_CLASSIC_SYSROOTS)/hostsysroot \
		--disable-multilib \
		--disable-nls --disable-libstdcxx-pch \
		--disable-werror \
		--with-gxx-include-dir=$(NLUKI_HOST_CLASSIC_SYSROOTS)/hostsysroot/include \
		CFLAGS="-O3" CXXFLAGS="-O3"

# Make GLibC
$(NLUKI_HOSTROOT)/host-glibc-install.sentinel: $(NLUKI_HOSTROOT)/host-glibc-build.sentinel
	mkdir -p $(NLUKI_HOST_CLASSIC_SYSROOTS)/hostsysroot
	cd $(NLUKI_HOST_BUILDROOT)/glibc; $(MAKE) $(HOST_GLIBC_FLAGS_EXPANDED) install
	touch $(NLUKI_HOSTROOT)/host-glibc-install.sentinel

$(NLUKI_HOSTROOT)/host-glibc-build.sentinel: $(NLUKI_HOST_BUILDROOT)/glibc/Makefile
	$(call NLUKI_AUTO_HOST_CLASSIC_SYSROOT_PATH,hostsysroot); $(call NLUKI_AUTO_HOST_CLASSIC_SYSROOT_CPATH,hostsysroot); $(call NLUKI_AUTO_HOST_CLASSIC_SYSROOT_LIBRARY_PATH,hostsysroot); \
	cd $(NLUKI_HOST_BUILDROOT)/glibc; $(MAKE) $(HOST_GLIBC_FLAGS_EXPANDED)
	touch $(NLUKI_HOSTROOT)/host-glibc-build.sentinel

# Configure GLibC
$(NLUKI_HOST_BUILDROOT)/glibc/Makefile: $(NLUKI_HOSTROOT)/host-fp-gcc-install.sentinel $(NLUKI_HOST_BUILDROOT)/glibc/configparams $(NLUKI_HOSTROOT)/host-binutils-install.sentinel
	mkdir -p $(NLUKI_HOST_BUILDROOT)/glibc
	cd $(NLUKI_HOST_BUILDROOT)/glibc; \
	$(NLUKI_DESTROY_BAD_ENV_VARS); $(call NLUKI_AUTO_HOST_CLASSIC_SYSROOT_PATH,hostsysroot); $(call NLUKI_AUTO_HOST_CLASSIC_SYSROOT_CPATH,hostsysroot); $(call NLUKI_AUTO_HOST_CLASSIC_SYSROOT_LIBRARY_PATH,hostsysroot); \
	$(MKFILE_DIR)/Submodules/glibc/configure \
		--with-build-sysroot=$(NLUKI_HOST_CLASSIC_SYSROOTS)/hostsysroot \
		--enable-stack-protector=strong \
		--disable-nscd \
		--with-headers=/usr/include/ \
		libc_cv_slibdir=$(NLUKI_HOST_CLASSIC_SYSROOTS)/hostsysroot/usr/lib \
		--prefix=$(NLUKI_HOST_CLASSIC_SYSROOTS)/hostsysroot \
		--disable-werror $(HOST_GLIBC_FLAGS_EXPANDED) \
		CFLAGS="-O3" CXXFLAGS="-O3"

$(NLUKI_HOST_BUILDROOT)/glibc/configparams:
	mkdir -p $(NLUKI_HOST_BUILDROOT)/glibc
	cd $(NLUKI_HOST_BUILDROOT)/glibc; echo "rootsbindir=/usr/sbin" > configparams

# Make First Pass Host GCC
$(NLUKI_HOSTROOT)/host-fp-gcc-install.sentinel: $(NLUKI_HOSTROOT)/host-fp-gcc-build.sentinel
	mkdir -p $(NLUKI_HOST_CLASSIC_SYSROOTS)/fp
	cd $(NLUKI_HOST_BUILDROOT)/fp-gcc; $(MAKE) install
	touch $(NLUKI_HOSTROOT)/host-fp-gcc-install.sentinel

$(NLUKI_HOSTROOT)/host-fp-gcc-build.sentinel: $(DEPENDS_ON_GCC)	$(NLUKI_HOST_BUILDROOT)/fp-gcc/Makefile
	cd $(NLUKI_HOST_BUILDROOT)/fp-gcc; $(MAKE)
	touch $(NLUKI_HOSTROOT)/host-fp-gcc-build.sentinel

# Configure First Pass Host GCC
$(NLUKI_HOST_BUILDROOT)/fp-gcc/Makefile: $(DEPENDS_ON_BINUTILS) $(DEPENDS_ON_GCC) $(NLUKI_HOSTROOT)/host-binutils-install.sentinel
	mkdir -p $(NLUKI_HOST_BUILDROOT)/fp-gcc
	cd $(NLUKI_HOST_BUILDROOT)/fp-gcc; \
	$(MKFILE_DIR)/Submodules/gcc/configure \
		$(NLUKI_GCC_OPTIONS) \
		--prefix=$(NLUKI_HOST_CLASSIC_SYSROOTS)/hostsysroot \
		--disable-multilib --disable-threads --disable-libatomic \
		--disable-libgomp --disable-libquadmath \
		--disable-libssp --disable-libvtv --disable-libstdcxx \
		--disable-nls --disable-libgmp \
		--enable-default-pie --enable-default-ssp \
		--with-newlib --without-headers \
		--enable-languages=c,c++ \
		--disable-werror CFLAGS="-O3 -fno-stack-protector -Wno-format-security" CXXFLAGS="-O3 -fno-stack-protector -Wno-format-security"

# --- Make Host Binutils
$(NLUKI_HOSTROOT)/host-binutils-install.sentinel: $(NLUKI_HOSTROOT)/host-binutils-build.sentinel
	mkdir -p $(NLUKI_HOST_CLASSIC_SYSROOTS)/hostsysroot
	mkdir -p $(NLUKI_HOST_SYSROOT_OVERLAYS)/libopcodes/lib
	cd $(NLUKI_HOST_BUILDROOT)/binutils; $(MAKE) install
	cp -rfv $(NLUKI_HOST_CLASSIC_SYSROOTS)/hostsysroot/lib/libopcodes-* $(NLUKI_HOST_SYSROOT_OVERLAYS)/libopcodes/lib
	touch $(NLUKI_HOSTROOT)/host-binutils-install.sentinel

$(NLUKI_HOSTROOT)/host-binutils-build.sentinel: $(NLUKI_HOST_BUILDROOT)/binutils/Makefile
	cd $(NLUKI_HOST_BUILDROOT)/binutils; $(MAKE)
	touch $(NLUKI_HOSTROOT)/host-binutils-build.sentinel

# --- Host Binutils Easy-Target
#host-binutils: $(NLUKI_HOST_SYSROOT_OVERLAYS)/binutils ;
#.PHONY: host-binutils

# --- Configure Host Binutils
$(NLUKI_HOST_BUILDROOT)/binutils/Makefile: $(DEPENDS_ON_BINUTILS) $(NLUKI_HOST_SYSROOTS)/binutils
	mkdir -p $(NLUKI_HOST_BUILDROOT)/binutils
	cd $(NLUKI_HOST_BUILDROOT)/binutils; \
	$(MKFILE_DIR)/Submodules/binutils/configure \
		$(NLUKI_BINUTILS_OPTIONS) \
		--prefix=$(NLUKI_HOST_CLASSIC_SYSROOTS)/hostsysroot \
		--disable-nls --enable-gprofng=no --enable-new-dtags \
		--enable-default-hash-style=gnu --enable-shared --disable-werror \
		--enable-64-bit-bfd CFLAGS="-O3" CXXFLAGS="-O3"

$(eval $(call NLUKI_MAKE_SYS_ROOT_HOST,binutils,,,))