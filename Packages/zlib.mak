NLUKI_ZLIB_ENV := $(NLUKI_AUTO_TARGET_PRIMARYSYSROOT_PATH); $(NLUKI_AUTO_TARGET_PRIMARYSYSROOT_LIBRARY_PATH); $(NLUKI_AUTO_TARGET_PRIMARYSYSROOT_CPATH) \
	$(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_LIBRARY_PATH,crosssysroot); $(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_CPATH,crosssysroot); $(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_PATH,crosssysroot); \
	$(call NLUKI_AUTO_HOST_CLASSIC_SYSROOT_PATH,hostsysroot); export NLUKI_SYSROOT=$(NLUKI_PRIMARYSYSROOT); export CC=$(NLUKI_ALTERNATIVE_TARGET_ARCH)-pc-linux-gcc; CXX=$(NLUKI_ALTERNATIVE_TARGET_ARCH)-pc-linux-g++

$(NLUKI_BUILDROOT)/zlib-install.stamp: $(NLUKI_BUILDROOT)/zlib-build.stamp
	@mkdir -p $(NLUKI_PRIMARYSYSROOT)
	@echo -e \\t[NLUKI] TARGET_CMAKE_INSTALL zlib -> Primary
	@$(NLUKI_ZLIB_ENV); export NLUKI_SYSROOT=$(NLUKI_PRIMARYSYSROOT); cmake --install $(NLUKI_TARGET_BUILDROOT)/zlib --prefix $(NLUKI_PRIMARYSYSROOT)/usr
	@echo -e \\t[NLUKI] TOUCH zlib-install.stamp
	@touch $(NLUKI_BUILDROOT)/zlib-install.stamp

$(NLUKI_PRIMARYSYSROOT): $(NLUKI_BUILDROOT)/zlib-install.stamp

zlib-install: $(NLUKI_BUILDROOT)/zlib-install.stamp
.PHONY : zlib-install

$(NLUKI_BUILDROOT)/zlib-build.stamp: $(NLUKI_BUILDROOT)/zlib-configure.stamp
	@echo -e \\t[NLUKI] TARGET_CMAKE_BUILD zlib
	@+$(NLUKI_ZLIB_ENV); export NLUKI_SYSROOT=$(NLUKI_PRIMARYSYSROOT); cd $(NLUKI_TARGET_BUILDROOT)/zlib; cmake --build .
	@touch $(NLUKI_BUILDROOT)/zlib-build.stamp

zlib-build: $(NLUKI_BUILDROOT)/zlib-build.stamp
.PHONY : zlib-build

$(NLUKI_BUILDROOT)/zlib-configure.stamp: $(MKFILE_DIR)/Submodules/zlib \
										$(NLUKI_BUILDROOT)/glibc-install.stamp $(NLUKI_BUILDROOT)/gcc-install.stamp $(NLUKI_BUILDROOT)/binutils-install.stamp
	@mkdir -p $(NLUKI_TARGET_BUILDROOT)/zlib
	@echo -e \\t[NLUKI] TARGET_CMAKE_CONFIGURE zlib
	@$(NLUKI_ZLIB_ENV); cmake -B $(NLUKI_TARGET_BUILDROOT)/zlib --debug-find -S $(MKFILE_DIR)/Submodules/zlib \
		-DZLIB_BUILD_TESTING=OFF \
		-DZLIB_BUILD_TESTING=OFF \
		--toolchain $(MKFILE_DIR)/CrossToolchain.cmake
	@echo -e \\t[NLUKI] TOUCH zlib-configure.stamp
	@touch $(NLUKI_BUILDROOT)/zlib-configure.stamp

zlib-configure: $(NLUKI_BUILDROOT)/zlib-configure.stamp
.PHONY : zlib-configure
