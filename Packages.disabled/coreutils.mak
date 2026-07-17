NLUKI_COREUTILS_ENV := $(NLUKI_AUTO_TARGET_PRIMARYSYSROOT_PATH); $(NLUKI_AUTO_TARGET_PRIMARYSYSROOT_LIBRARY_PATH); $(NLUKI_AUTO_TARGET_PRIMARYSYSROOT_CPATH) \
	$(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_LIBRARY_PATH,crosssysroot); $(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_CPATH,crosssysroot); $(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_PATH,crosssysroot); \
	$(call NLUKI_AUTO_HOST_CLASSIC_SYSROOT_PATH,hostsysroot)

$(NLUKI_BUILDROOT)/coreutils-install.stamp: $(NLUKI_BUILDROOT)/coreutils-build.stamp
	mkdir -p $(NLUKI_PRIMARYSYSROOT)
	$(NLUKI_COREUTILS_ENV); cd $(NLUKI_TARGET_BUILDROOT)/coreutils; $(MAKE) DESTDIR=$(NLUKI_PRIMARYSYSROOT) install
	touch $(NLUKI_BUILDROOT)/coreutils-install.stamp

$(NLUKI_PRIMARYSYSROOT): $(NLUKI_BUILDROOT)/coreutils-install.stamp

coreutils-install: $(NLUKI_BUILDROOT)/coreutils-install.stamp
.PHONY : coreutils-install

$(NLUKI_BUILDROOT)/coreutils-build.stamp: $(NLUKI_TARGET_BUILDROOT)/coreutils/Makefile
	$(NLUKI_COREUTILS_ENV); cd $(NLUKI_TARGET_BUILDROOT)/coreutils; $(MAKE)
	touch $(NLUKI_BUILDROOT)/coreutils-build.stamp

coreutils-build: $(NLUKI_BUILDROOT)/coreutils-build.stamp
.PHONY : coreutils-build

$(NLUKI_TARGET_BUILDROOT)/coreutils/Makefile: $(NLUKI_BUILDROOT)/glibc-install.stamp $(NLUKI_BUILDROOT)/gcc-install.stamp $(NLUKI_BUILDROOT)/binutils-install.stamp
	cd $(MKFILE_DIR)/Submodules/coreutils; ./bootstrap --gen
	mkdir -p $(NLUKI_TARGET_BUILDROOT)/coreutils
	$(NLUKI_COREUTILS_ENV); cd $(NLUKI_TARGET_BUILDROOT)/coreutils; $(MKFILE_DIR)/Submodules/coreutils/configure \
		--enable-threads=posix \
		--enable-systemd \
		--enable-year2038 \
		CFLAGS="-O3" CXXFLAGS="-O3"