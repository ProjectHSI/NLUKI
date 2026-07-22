NLUKI_ZSTD_ENV := $(NLUKI_AUTO_TARGET_PRIMARYSYSROOT_PATH); $(NLUKI_AUTO_TARGET_PRIMARYSYSROOT_LIBRARY_PATH); $(NLUKI_AUTO_TARGET_PRIMARYSYSROOT_CPATH) \
	$(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_LIBRARY_PATH,crosssysroot); $(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_CPATH,crosssysroot); $(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_PATH,crosssysroot); \
	$(call NLUKI_AUTO_HOST_CLASSIC_SYSROOT_PATH,hostsysroot); export NLUKI_SYSROOT=$(NLUKI_PRIMARYSYSROOT); export CC=$(NLUKI_ALTERNATIVE_TARGET_ARCH)-pc-linux-gcc; CXX=$(NLUKI_ALTERNATIVE_TARGET_ARCH)-pc-linux-g++

$(NLUKI_BUILDROOT)/zstd-install.stamp: $(NLUKI_BUILDROOT)/zstd-build.stamp
	@mkdir -p $(NLUKI_PRIMARYSYSROOT)
	@echo -e \\t[NLUKI] TARGET_CMAKE_INSTALL zstd -> Primary
	@$(NLUKI_ZSTD_ENV); export NLUKI_SYSROOT=$(NLUKI_PRIMARYSYSROOT); cmake --install $(NLUKI_TARGET_BUILDROOT)/zstd --prefix $(NLUKI_PRIMARYSYSROOT)/usr
	@echo -e \\[NLUKI] TOUCH zstd-install.stamp
	@touch $(NLUKI_BUILDROOT)/zstd-install.stamp

$(NLUKI_PRIMARYSYSROOT): $(NLUKI_BUILDROOT)/zstd-install.stamp

zstd-install: $(NLUKI_BUILDROOT)/zstd-install.stamp
.PHONY : zstd-install

$(NLUKI_BUILDROOT)/zstd-build.stamp: $(NLUKI_BUILDROOT)/zstd-configure.stamp
	@echo -e \\t[NLUKI] TARGET_CMAKE_BUILD zstd
	@+$(NLUKI_ZSTD_ENV); export NLUKI_SYSROOT=$(NLUKI_PRIMARYSYSROOT); cd $(NLUKI_TARGET_BUILDROOT)/zstd; cmake --build .
	@echo -e \\t[NLUKI] TOUCH zstd-build.stamp
	@touch $(NLUKI_BUILDROOT)/zstd-build.stamp

zstd-build: $(NLUKI_BUILDROOT)/zstd-build.stamp
.PHONY : zstd-build

$(NLUKI_BUILDROOT)/zstd-configure.stamp: $(MKFILE_DIR)/Submodules/zstd \
										$(NLUKI_BUILDROOT)/glibc-install.stamp $(NLUKI_BUILDROOT)/gcc-install.stamp $(NLUKI_BUILDROOT)/binutils-install.stamp
	@mkdir -p $(NLUKI_TARGET_BUILDROOT)/zstd
	@echo -e \\t[NLUKI] TARGET_CMAKE_CONFIGURE zstd
	@$(NLUKI_ZSTD_ENV); cmake -B $(NLUKI_TARGET_BUILDROOT)/zstd --debug-find -S $(MKFILE_DIR)/Submodules/zstd \
		--toolchain $(MKFILE_DIR)/CrossToolchain.cmake
	@echo -e \\t[NLUKI] TOUCH zstd-configure.stamp
	@touch $(NLUKI_BUILDROOT)/zstd-configure.stamp