NLUKI_RPM_ENV := $(NLUKI_AUTO_TARGET_PRIMARYSYSROOT_PATH); $(NLUKI_AUTO_TARGET_PRIMARYSYSROOT_LIBRARY_PATH); $(NLUKI_AUTO_TARGET_PRIMARYSYSROOT_CPATH) \
	$(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_LIBRARY_PATH,crosssysroot); $(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_CPATH,crosssysroot); $(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_PATH,crosssysroot); \
	$(call NLUKI_AUTO_HOST_CLASSIC_SYSROOT_PATH,hostsysroot); export NLUKI_SYSROOT=$(NLUKI_PRIMARYSYSROOT); export CC=$(NLUKI_ALTERNATIVE_TARGET_ARCH)-pc-linux-gcc; CXX=$(NLUKI_ALTERNATIVE_TARGET_ARCH)-pc-linux-g++

$(NLUKI_BUILDROOT)/rpm-install.stamp: $(NLUKI_BUILDROOT)/rpm-build.stamp
	@mkdir -p $(NLUKI_PRIMARYSYSROOT)
	@echo -e \\tCMAKE_INSTALL rpm -> Primary
	@$(NLUKI_RPM_ENV); export NLUKI_SYSROOT=$(NLUKI_PRIMARYSYSROOT); cmake --install $(NLUKI_TARGET_BUILDROOT)/rpm --prefix $(NLUKI_PRIMARYSYSROOT)/usr
	@echo -e \\t[NLUKI] TOUCH rpm-install.stamp
	@touch $(NLUKI_BUILDROOT)/rpm-install.stamp

#$(NLUKI_PRIMARYSYSROOT): $(NLUKI_BUILDROOT)/rpm-install.stamp

rpm-install: $(NLUKI_BUILDROOT)/rpm-install.stamp
.PHONY : rpm-install

$(NLUKI_BUILDROOT)/rpm-build.stamp: $(NLUKI_BUILDROOT)/rpm-configure.stamp
	@echo -e \\tCMAKE_BUILD rpm
	@+$(NLUKI_RPM_ENV); export NLUKI_SYSROOT=$(NLUKI_PRIMARYSYSROOT); cd $(NLUKI_TARGET_BUILDROOT)/rpm; cmake --build .
	@echo -e \\t[NLUKI] TOUCH rpm-build.stamp
	@touch $(NLUKI_BUILDROOT)/rpm-build.stamp

rpm-build: $(NLUKI_BUILDROOT)/rpm-build.stamp
.PHONY : rpm-build

$(NLUKI_BUILDROOT)/rpm-configure.stamp: $(MKFILE_DIR)/Submodules/rpm \
										$(NLUKI_BUILDROOT)/lua-install.stamp \
										$(NLUKI_BUILDROOT)/zlib-install.stamp \
										$(NLUKI_BUILDROOT)/popt-install.stamp \
										$(NLUKI_BUILDROOT)/readline-install.stamp \
										$(NLUKI_BUILDROOT)/zstd-install.stamp \
										$(NLUKI_BUILDROOT)/libarchive-install.stamp \
										$(NLUKI_BUILDROOT)/glibc-install.stamp $(NLUKI_BUILDROOT)/gcc-install.stamp $(NLUKI_BUILDROOT)/binutils-install.stamp
	@mkdir -p $(NLUKI_TARGET_BUILDROOT)/rpm
	@echo -e \\tCMAKE_CONFIGURE rpm
	@$(NLUKI_RPM_ENV); cmake -B $(NLUKI_TARGET_BUILDROOT)/rpm -S $(MKFILE_DIR)/Submodules/rpm \
		-DENABLE_SQLITE=YES \
		--toolchain $(MKFILE_DIR)/CrossToolchain.cmake
	@echo -e \\t[NLUKI] TOUCH rpm-configure.stamp
	@touch $(NLUKI_BUILDROOT)/rpm-configure.stamp

rpm-configure: $(NLUKI_BUILDROOT)/rpm-configure.stamp
.PHONY : rpm-configure
