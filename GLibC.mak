#GLIBC_COMPILER_FLAGS = "-Wno-error=attributes -Wno-error=unused-result -Wno-error=infinite-recursion -Wno-error=cpp -U_FORTIFY_SOURCE -O3"
#CHECKED_GLIBC_COMPILER_FLAGS = "-Wno-error=attributes -Wno-error=unused-result -Wno-error=infinite-recursion -Wno-error=cpp -U_FORTIFY_SOURCE -O3"

ifeq (t,f)
# GLibC with tests
$(NLUKI_TARGET_SYSROOT_OVERLAYS)/checked-glibc: $(NLUKI_TARGET_BUILDROOT)/checked-glibc/Makefile
	$(call NLUKI_AUTO_SYSROOT_PATH,checked-glibc); cd $(NLUKI_TARGET_BUILDROOT)/checked-glibc; $(MAKE) -j1 CFLAGS=$(CHECKED_GLIBC_COMPILER_FLAGS) CXXFLAGS=$(CHECKED_GLIBC_COMPILER_FLAGS)
	$(call NLUKI_AUTO_SYSROOT_PATH,checked-glibc); cd $(NLUKI_TARGET_BUILDROOT)/checked-glibc; $(MAKE) -j1 CFLAGS=$(CHECKED_GLIBC_COMPILER_FLAGS) CXXFLAGS=$(CHECKED_GLIBC_COMPILER_FLAGS) check
	$(call NLUKI_AUTO_SYSROOT_PATH,checked-glibc); cd $(NLUKI_TARGET_BUILDROOT)/checked-glibc; $(MAKE) install

checked-glibc: $(NLUKI_TARGET_SYSROOT_OVERLAYS)/checked-glibc
.PHONY : checked-glibc

# Configure Checked GLibC
$(NLUKI_TARGET_BUILDROOT)/checked-glibc/Makefile: $(NLUKI_TARGET_SYSROOTS)/checked-glibc \
												 | $(NLUKI_TARGET_BUILDROOT)/checked-glibc/configparams
	mkdir -p $(NLUKI_TARGET_BUILDROOT)/checked-glibc
	mkdir -p $(NLUKI_TARGET_SYSROOT_OVERLAYS)/checked-glibc

	cd $(NLUKI_TARGET_BUILDROOT)/checked-glibc; \
	$(call NLUKI_AUTO_SYSROOT_PATH,checked-glibc); $(MKFILE_DIR)/Submodules/glibc/configure \
		--enable-kernel=7.0 \
		--with-build-sysroot=$(NLUKI_TARGET_SYSROOTS)/checked-glibc \
		--enable-stack-protector=strong \
		--host=$(NLUKI_TARGET_ARCH)-pc-linux \
		--build=$(shell $(MKFILE_DIR)/Submodules/glibc/scripts/config.guess) \
		--disable-nscd \
		--with-headers=$(NLUKI_TARGET_SYSROOTS)/checked-glibc/usr/include/ \
		libc_cv_slibdir=$(NLUKI_TARGET_SYSROOT_OVERLAYS)/checked-glibc/usr/lib \
		--prefix=$(NLUKI_TARGET_SYSROOT_OVERLAYS)/checked-glibc
		--disable-werror CFLAGS="-Wno-error=attributes -Wno-error=unused-result -Wno-error=infinite-recursion -Wno-error=cpp" CFLAGS=$(CHECKED_GLIBC_COMPILER_FLAGS) CXXFLAGS=$(CHECKED_GLIBC_COMPILER_FLAGS)

$(eval $(call NLUKI_MAKE_SYS_ROOT_TARGET,checked-glibc,linux_headers glibc gcc binutils,,binutils gcc))

$(NLUKI_TARGET_BUILDROOT)/checked-glibc/configparams:
	mkdir -p $(NLUKI_TARGET_BUILDROOT)/glibc
	cd $(NLUKI_TARGET_BUILDROOT)/glibc; echo "rootsbindir=/usr/sbin" > configparams
endif

$(NLUKI_BUILDROOT)/glibc-install.stamp: $(NLUKI_BUILDROOT)/glibc-build.stamp
	mkdir -p $(NLUKI_BUILDROOT)/PrimarySysRoot
	$(call NLUKI_AUTO_HOST_CLASSIC_SYSROOT_PATH,hostsysroot); cd $(NLUKI_TARGET_BUILDROOT)/glibc; $(MAKE) DESTDIR="$(NLUKI_BUILDROOT)/PrimarySysRoot" install
	touch $(NLUKI_BUILDROOT)/glibc-install.stamp

$(NLUKI_PRIMARYSYSROOT): $(NLUKI_BUILDROOT)/glibc-install.stamp

glibc-install: $(NLUKI_BUILDROOT)/glibc-install.stamp
.PHONY : glibc-install

# Make GLibC
$(NLUKI_BUILDROOT)/glibc-build.stamp: $(NLUKI_TARGET_BUILDROOT)/glibc/Makefile
	$(call NLUKI_AUTO_HOST_CLASSIC_SYSROOT_PATH,hostsysroot); cd $(NLUKI_TARGET_BUILDROOT)/glibc; $(MAKE) CFLAGS="-O3" CXXFLAGS="-O3"
	touch $(NLUKI_BUILDROOT)/glibc-build.stamp

glibc-build: $(NLUKI_BUILDROOT)/glibc-build.stamp
.PHONY : glibc-build

# Configure GLibC
$(NLUKI_TARGET_BUILDROOT)/glibc/Makefile: $(NLUKI_BUILDROOT)/linux_headers-install.stamp $(NLUKI_BUILDROOT)/binutils-install.stamp $(NLUKI_BUILDROOT)/firstpass-gcc-install.stamp \
									$(nluki-lsb-$(NLUKI_TARGET_ARCH)) \
									| $(NLUKI_TARGET_BUILDROOT)/glibc/configparams
	mkdir -p $(NLUKI_TARGET_BUILDROOT)/glibc
	cd $(NLUKI_TARGET_BUILDROOT)/glibc; \
	$(call NLUKI_AUTO_HOST_CLASSIC_SYSROOT_PATH,hostsysroot); $(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_PATH,fp); $(MKFILE_DIR)/Submodules/glibc/configure \
		--enable-kernel=7.0 \
		--with-build-sysroot=$(NLUKI_BUILDROOT)/PrimarySysRoot \
		--enable-stack-protector=strong \
		--host=$(NLUKI_TARGET_ARCH)-pc-linux \
		--build=$(shell $(MKFILE_DIR)/Submodules/glibc/scripts/config.guess) \
		--disable-nscd \
		--with-headers=$(NLUKI_BUILDROOT)/PrimarySysRoot/usr/include/ \
		libc_cv_slibdir=/usr/lib \
		--prefix=/usr/
		--disable-werror CFLAGS="-O3" CXXFLAGS="-O3"

#$(eval $(call NLUKI_MAKE_SYS_ROOT_TARGET,glibc,linux_headers fp_gcc fp_binutils,,gcc binutils))

$(NLUKI_TARGET_BUILDROOT)/glibc/configparams:
	mkdir -p $(NLUKI_TARGET_BUILDROOT)/glibc
	cd $(NLUKI_TARGET_BUILDROOT)/glibc; echo "rootsbindir=/usr/sbin" > configparams