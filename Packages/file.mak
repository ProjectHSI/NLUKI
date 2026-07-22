NLUKI_FILE_ENV := $(NLUKI_AUTO_TARGET_PRIMARYSYSROOT_PATH); $(NLUKI_AUTO_TARGET_PRIMARYSYSROOT_LIBRARY_PATH); $(NLUKI_AUTO_TARGET_PRIMARYSYSROOT_CPATH) \
	$(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_LIBRARY_PATH,crosssysroot); $(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_CPATH,crosssysroot); $(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_PATH,crosssysroot); \
	$(call NLUKI_AUTO_HOST_CLASSIC_SYSROOT_PATH,hostsysroot); export CC=$(NLUKI_ALTERNATIVE_TARGET_ARCH)-pc-linux-gcc; CXX=$(NLUKI_ALTERNATIVE_TARGET_ARCH)-pc-linux-g++

$(NLUKI_BUILDROOT)/file-install.stamp: $(NLUKI_BUILDROOT)/file-build.stamp
	@mkdir -p $(NLUKI_PRIMARYSYSROOT)

	@echo -e \\t[NLUKI] TARGET_MAKE_INSTALL file
	@$(NLUKI_FILE_ENV); cd $(NLUKI_TARGET_BUILDROOT)/file; $(MAKE) DESTDIR=$(NLUKI_PRIMARYSYSROOT) install
	@echo -e \\t[NLUKI] TOUCH $(NLUKI_TARGET_ARCH)/file
	@touch $(NLUKI_BUILDROOT)/file-install.stamp

$(NLUKI_PRIMARYSYSROOT): $(NLUKI_BUILDROOT)/file-install.stamp

file-install: $(NLUKI_BUILDROOT)/file-install.stamp
.PHONY : file-install

$(NLUKI_BUILDROOT)/file-build.stamp: $(NLUKI_TARGET_BUILDROOT)/file/Makefile
	@echo -e \\t[NLUKI] TARGET_MAKE file
	@$(NLUKI_FILE_ENV); cd $(NLUKI_TARGET_BUILDROOT)/file; $(MAKE)
	@echo -e \\t[NLUKI] TOUCH $(NLUKI_TARGET_ARCH)/file-build.stamp
	@touch $(NLUKI_BUILDROOT)/file-build.stamp

file-build: $(NLUKI_BUILDROOT)/file-build.stamp
.PHONY : file-build

$(NLUKI_TARGET_BUILDROOT)/file/Makefile: $(NLUKI_HOSTROOT)/file-autoconf.stamp \
										$(NLUKI_BUILDROOT)/glibc-install.stamp $(NLUKI_BUILDROOT)/gcc-install.stamp $(NLUKI_BUILDROOT)/binutils-install.stamp
	@echo -e \\t[NLUKI] MKDIR $(NLUKI_TARGET_ARCH)/Build/file
	@mkdir -p $(NLUKI_TARGET_BUILDROOT)/file
	@echo -e \\t[NLUKI] TARGET_CONFIGURE file
	@$(NLUKI_FILE_ENV); cd $(NLUKI_TARGET_BUILDROOT)/file; $(MKFILE_DIR)/Submodules/file/configure \
		CFLAGS="-O3" CXXFLAGS="-O3"

$(NLUKI_HOSTROOT)/file-autoconf.stamp: $(MKFILE_DIR)/Submodules/file
	@echo -e \\t[NLUKI] AUTORECONF file
	@cd $(MKFILE_DIR)/Submodules/file; autoreconf -f -i
	@echo -e \\t[NLUKI] TOUCH Host/file-autoreconf.stamp
	@touch $(NLUKI_HOSTROOT)/file-autoconf.stamp

file-autoconf: $(NLUKI_HOSTROOT)/file-autoconf.stamp
.PHONY : file-autoconf

NLUKI_TARGETS_TO_STILL_BUILD_AS_HOST += $(NLUKI_HOSTROOT)/file-autoconf.stamp