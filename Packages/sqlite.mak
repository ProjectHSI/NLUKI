NLUKI_SQLITE_ENV := $(NLUKI_AUTO_TARGET_PRIMARYSYSROOT_PATH); $(NLUKI_AUTO_TARGET_PRIMARYSYSROOT_LIBRARY_PATH); $(NLUKI_AUTO_TARGET_PRIMARYSYSROOT_CPATH) \
	$(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_LIBRARY_PATH,crosssysroot); $(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_CPATH,crosssysroot); $(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_PATH,crosssysroot); \
	$(call NLUKI_AUTO_HOST_CLASSIC_SYSROOT_PATH,hostsysroot); export CC=$(NLUKI_ALTERNATIVE_TARGET_ARCH)-pc-linux-gcc; CXX=$(NLUKI_ALTERNATIVE_TARGET_ARCH)-pc-linux-g++

$(NLUKI_BUILDROOT)/sqlite-install.stamp: $(NLUKI_BUILDROOT)/sqlite-build.stamp
	@mkdir -p $(NLUKI_PRIMARYSYSROOT)

	@echo -e \\t[NLUKI] TARGET_MAKE_INSTALL sqlite
	@$(NLUKI_SQLITE_ENV); cd $(NLUKI_TARGET_BUILDROOT)/sqlite; $(MAKE) DESTDIR=$(NLUKI_PRIMARYSYSROOT) install
	@echo -e \\t[NLUKI] TOUCH $(NLUKI_TARGET_ARCH)/sqlite
	@touch $(NLUKI_BUILDROOT)/sqlite-install.stamp

$(NLUKI_PRIMARYSYSROOT): $(NLUKI_BUILDROOT)/sqlite-install.stamp

sqlite-install: $(NLUKI_BUILDROOT)/sqlite-install.stamp
.PHONY : sqlite-install

$(NLUKI_BUILDROOT)/sqlite-build.stamp: $(NLUKI_TARGET_BUILDROOT)/sqlite/Makefile
	@echo -e \\t[NLUKI] TARGET_MAKE sqlite
	@$(NLUKI_SQLITE_ENV); cd $(NLUKI_TARGET_BUILDROOT)/sqlite; $(MAKE)
	@echo -e \\t[NLUKI] TOUCH $(NLUKI_TARGET_ARCH)/sqlite-build.stamp
	@touch $(NLUKI_BUILDROOT)/sqlite-build.stamp

sqlite-build: $(NLUKI_BUILDROOT)/sqlite-build.stamp
.PHONY : sqlite-build

$(NLUKI_TARGET_BUILDROOT)/sqlite/Makefile: $(NLUKI_BUILDROOT)/readline-install.stamp \
										$(NLUKI_BUILDROOT)/glibc-install.stamp $(NLUKI_BUILDROOT)/gcc-install.stamp $(NLUKI_BUILDROOT)/binutils-install.stamp
	@echo -e \\t[NLUKI] MKDIR $(NLUKI_TARGET_ARCH)/Build/sqlite
	@mkdir -p $(NLUKI_TARGET_BUILDROOT)/sqlite
	@echo -e \\t[NLUKI] TARGET_CONFIGURE sqlite
	@$(NLUKI_SQLITE_ENV); cd $(NLUKI_TARGET_BUILDROOT)/sqlite; $(MKFILE_DIR)/Submodules/sqlite/configure \
		--all \
		--update-limit \
		--linemacros \
		CFLAGS="-O3" CXXFLAGS="-O3"