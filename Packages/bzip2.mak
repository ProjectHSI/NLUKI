NLUKI_BZIP2_ENV := $(NLUKI_AUTO_TARGET_PRIMARYSYSROOT_PATH); $(NLUKI_AUTO_TARGET_PRIMARYSYSROOT_LIBRARY_PATH); $(NLUKI_AUTO_TARGET_PRIMARYSYSROOT_CPATH) \
	$(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_LIBRARY_PATH,crosssysroot); $(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_CPATH,crosssysroot); $(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_PATH,crosssysroot); \
	$(call NLUKI_AUTO_HOST_CLASSIC_SYSROOT_PATH,hostsysroot)

$(NLUKI_BUILDROOT)/bzip2-install.stamp: $(NLUKI_BUILDROOT)/bzip2-build.stamp
	@mkdir -p $(NLUKI_PRIMARYSYSROOT)/usr
	@echo -e \\t[NLUKI] TARGET_MAKE_INSTALL bzip2
	@$(NLUKI_BZIP2_ENV); cd $(NLUKI_TARGET_BUILDROOT)/bzip2; $(MAKE) CC=$(NLUKI_ALTERNATIVE_TARGET_ARCH)-pc-linux-gcc CXX=$(NLUKI_ALTERNATIVE_TARGET_ARCH)-pc-linux-g++ PREFIX=$(NLUKI_PRIMARYSYSROOT)/usr install
	@echo -e \\tTOUCH bzip2-install.stamp
	@touch $(NLUKI_BUILDROOT)/bzip2-install.stamp

$(NLUKI_PRIMARYSYSROOT): $(NLUKI_BUILDROOT)/bzip2-install.stamp

bzip2-install: $(NLUKI_BUILDROOT)/bzip2-install.stamp
.PHONY : bzip2-install

$(NLUKI_BUILDROOT)/bzip2-build.stamp: | $(NLUKI_TARGET_BUILDROOT)/bzip2
	@echo -e \\tDESCEND Target/BuildRoot/bzip2
	@$(NLUKI_BZIP2_ENV); cd $(NLUKI_TARGET_BUILDROOT)/bzip2; $(MAKE) \
		CFLAGS="-O3 -fPIC -D_FILE_OFFSET_BITS=64" \
		CC=$(NLUKI_ALTERNATIVE_TARGET_ARCH)-pc-linux-gcc CXX=$(NLUKI_ALTERNATIVE_TARGET_ARCH)-pc-linux-g++
	@echo -e \\tTOUCH bzip2-build.stamp
	@touch $(NLUKI_BUILDROOT)/bzip2-build.stamp

bzip2-build: $(NLUKI_BUILDROOT)/bzip2-build.stamp
.PHONY : bzip2-build

$(NLUKI_TARGET_BUILDROOT)/bzip2: $(MKFILE_DIR)/Submodules/bzip2
	@echo -e \\tCLEAN Target/BuildRoot/bzip2
	@rm -rf $(NLUKI_TARGET_BUILDROOT)/bzip2

	@echo -e \\tMKDIR Target/BuildRoot/bzip2
	@mkdir -p $(NLUKI_TARGET_BUILDROOT)/bzip2

	@echo -e \\tCOPY Submodules/bzip2/\* Target/BuildRoot/bzip2
	@cp -rf $(MKFILE_DIR)/Submodules/bzip2/* $(NLUKI_TARGET_BUILDROOT)/bzip2