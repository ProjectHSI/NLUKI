NLUKI_CPYTHON_ENV := export C_INCLUDE_PATH=/nonexistent; export CPLUS_INCLUDE_PATH=/nonexistent; $(NLUKI_AUTO_TARGET_PRIMARYSYSROOT_PATH); $(NLUKI_AUTO_TARGET_PRIMARYSYSROOT_LIBRARY_PATH); $(NLUKI_AUTO_TARGET_PRIMARYSYSROOT_CPATH) \
	$(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_LIBRARY_PATH,crosssysroot); $(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_CPATH,crosssysroot); $(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_PATH,crosssysroot); \
	$(call NLUKI_AUTO_HOST_CLASSIC_SYSROOT_PATH,hostsysroot); export CC=$(NLUKI_GCC_ARCH)-pc-linux-gcc; CXX=$(NLUKI_GCC_ARCH)-pc-linux-g++

$(NLUKI_BUILDROOT)/cpython-install.stamp: $(NLUKI_BUILDROOT)/cpython-build.stamp
	@mkdir -p $(NLUKI_PRIMARYSYSROOT)

	@echo -e \\t[NLUKI] TARGET_MAKE_INSTALL cpython
	@$(NLUKI_CPYTHON_ENV); cd $(NLUKI_TARGET_BUILDROOT)/cpython; $(MAKE) DESTDIR=$(NLUKI_PRIMARYSYSROOT) install
	@echo -e \\t[NLUKI] TOUCH $(NLUKI_TARGET_ARCH)/cpython
	@touch $(NLUKI_BUILDROOT)/cpython-install.stamp

$(NLUKI_PRIMARYSYSROOT): $(NLUKI_BUILDROOT)/cpython-install.stamp

cpython-install: $(NLUKI_BUILDROOT)/cpython-install.stamp
.PHONY : cpython-install

$(NLUKI_BUILDROOT)/cpython-build.stamp: $(NLUKI_TARGET_BUILDROOT)/cpython/Makefile
	@echo -e \\t[NLUKI] TARGET_MAKE cpython
	$(NLUKI_CPYTHON_ENV); cd $(NLUKI_TARGET_BUILDROOT)/cpython; $(MAKE)
	@echo -e \\t[NLUKI] TOUCH $(NLUKI_TARGET_ARCH)/cpython-build.stamp
	@touch $(NLUKI_BUILDROOT)/cpython-build.stamp

cpython-build: $(NLUKI_BUILDROOT)/cpython-build.stamp
.PHONY : cpython-build

$(NLUKI_TARGET_BUILDROOT)/cpython/Makefile: $(NLUKI_BUILDROOT)/linux_headers-install.stamp \
										$(NLUKI_BUILDROOT)/zlib-install.stamp \
										$(NLUKI_BUILDROOT)/readline-install.stamp \
										$(NLUKI_BUILDROOT)/bzip2-install.stamp \
										$(NLUKI_BUILDROOT)/zstd-install.stamp \
										$(NLUKI_BUILDROOT)/sqlite-install.stamp \
										$(NLUKI_BUILDROOT)/readline-install.stamp \
										$(NLUKI_BUILDROOT)/glibc-install.stamp $(NLUKI_BUILDROOT)/gcc-install.stamp $(NLUKI_BUILDROOT)/binutils-install.stamp
	@echo -e \\t[NLUKI] MKDIR $(NLUKI_TARGET_ARCH)/Build/cpython
	@mkdir -p $(NLUKI_TARGET_BUILDROOT)/cpython
	@echo -e \\t[NLUKI] TARGET_CONFIGURE cpython
#	Disabled optimisation for a time being, takes too long.
	@$(NLUKI_CPYTHON_ENV); cd $(NLUKI_TARGET_BUILDROOT)/cpython; $(MKFILE_DIR)/Submodules/cpython/configure \
		--with-build-python=$(NLUKI_HOST_CLASSIC_SYSROOTS)/hostsysroot/bin/python3.16 \
		CFLAGS="-O3" CXXFLAGS="-O3"