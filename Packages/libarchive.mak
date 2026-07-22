NLUKI_LIBARCHIVE_ENV := $(NLUKI_AUTO_TARGET_PRIMARYSYSROOT_PATH); $(NLUKI_AUTO_TARGET_PRIMARYSYSROOT_LIBRARY_PATH); $(NLUKI_AUTO_TARGET_PRIMARYSYSROOT_CPATH) \
	$(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_LIBRARY_PATH,crosssysroot); $(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_CPATH,crosssysroot); $(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_PATH,crosssysroot); \
	$(call NLUKI_AUTO_HOST_CLASSIC_SYSROOT_PATH,hostsysroot); export NLUKI_SYSROOT=$(NLUKI_PRIMARYSYSROOT); export CC=$(NLUKI_ALTERNATIVE_TARGET_ARCH)-pc-linux-gcc; CXX=$(NLUKI_ALTERNATIVE_TARGET_ARCH)-pc-linux-g++

$(NLUKI_BUILDROOT)/libarchive-install.stamp: $(NLUKI_BUILDROOT)/libarchive-build.stamp
	@mkdir -p $(NLUKI_PRIMARYSYSROOT)
	@echo -e \\t[NLUKI] TARGET_CMAKE_INSTALL libarchive -> Primary
	@$(NLUKI_LIBARCHIVE_ENV); export NLUKI_SYSROOT=$(NLUKI_PRIMARYSYSROOT); cmake --install $(NLUKI_TARGET_BUILDROOT)/libarchive --prefix $(NLUKI_PRIMARYSYSROOT)/usr
	@echo -e \\t[NLUKI] TOUCH libarchive-install.stamp
	@touch $(NLUKI_BUILDROOT)/libarchive-install.stamp

$(NLUKI_PRIMARYSYSROOT): $(NLUKI_BUILDROOT)/libarchive-install.stamp

libarchive-install: $(NLUKI_BUILDROOT)/libarchive-install.stamp
.PHONY : libarchive-install

$(NLUKI_BUILDROOT)/libarchive-build.stamp: $(NLUKI_BUILDROOT)/libarchive-configure.stamp
	@echo -e \\t[NLUKI] TARGET_CMAKE_BUILD libarchive
	@+$(NLUKI_LIBARCHIVE_ENV); export NLUKI_SYSROOT=$(NLUKI_PRIMARYSYSROOT); cd $(NLUKI_TARGET_BUILDROOT)/libarchive; cmake --build .
	@echo -e \\t[NLUKI] TOUCH libarchive-build.stamp
	@touch $(NLUKI_BUILDROOT)/libarchive-build.stamp

libarchive-build: $(NLUKI_BUILDROOT)/libarchive-build.stamp
.PHONY : libarchive-build

$(NLUKI_BUILDROOT)/libarchive-configure.stamp: $(MKFILE_DIR)/Submodules/libarchive \
										$(NLUKI_BUILDROOT)/glibc-install.stamp $(NLUKI_BUILDROOT)/gcc-install.stamp $(NLUKI_BUILDROOT)/binutils-install.stamp
	@mkdir -p $(NLUKI_TARGET_BUILDROOT)/libarchive
	@echo -e \\t[NLUKI] TARGET_CMAKE_CONFIGURE libarchive
	@$(NLUKI_LIBARCHIVE_ENV); cmake -B $(NLUKI_TARGET_BUILDROOT)/libarchive -S $(MKFILE_DIR)/Submodules/libarchive \
		-DCMAKE_BUILD_TYPE=Release -DENABLE_TEST=OFF \
		-DCMAKE_POSITION_INDEPENDENT_CODE=YES
		--toolchain $(MKFILE_DIR)/CrossToolchain.cmake
	@echo -e \\t[NLUKI] TOUCH libarchive-configure.stamp
	@touch $(NLUKI_BUILDROOT)/libarchive-configure.stamp