NLUKI_POPT_ENV := $(NLUKI_AUTO_TARGET_PRIMARYSYSROOT_PATH); $(NLUKI_AUTO_TARGET_PRIMARYSYSROOT_LIBRARY_PATH); $(NLUKI_AUTO_TARGET_PRIMARYSYSROOT_CPATH) \
	$(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_LIBRARY_PATH,crosssysroot); $(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_CPATH,crosssysroot); $(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_PATH,crosssysroot); \
	$(call NLUKI_AUTO_HOST_CLASSIC_SYSROOT_PATH,hostsysroot); export NLUKI_SYSROOT=$(NLUKI_PRIMARYSYSROOT); export CC=$(NLUKI_ALTERNATIVE_TARGET_ARCH)-pc-linux-gcc; CXX=$(NLUKI_ALTERNATIVE_TARGET_ARCH)-pc-linux-g++

$(NLUKI_BUILDROOT)/popt-install.stamp: $(NLUKI_BUILDROOT)/popt-build.stamp
	@mkdir -p $(NLUKI_PRIMARYSYSROOT)
	@echo -e \\t[NLUKI] TARGET_CMAKE_INSTALL popt -> Primary
	@$(NLUKI_POPT_ENV); export NLUKI_SYSROOT=$(NLUKI_PRIMARYSYSROOT); cmake --install $(NLUKI_TARGET_BUILDROOT)/popt --prefix $(NLUKI_PRIMARYSYSROOT)/usr
	@echo -e \\[NLUKI] TOUCH popt-install.stamp
	@touch $(NLUKI_BUILDROOT)/popt-install.stamp

$(NLUKI_PRIMARYSYSROOT): $(NLUKI_BUILDROOT)/popt-install.stamp

popt-install: $(NLUKI_BUILDROOT)/popt-install.stamp
.PHONY : popt-install

$(NLUKI_BUILDROOT)/popt-build.stamp: $(NLUKI_BUILDROOT)/popt-configure.stamp
	@echo -e \\t[NLUKI] TARGET_CMAKE_BUILD popt
	@+$(NLUKI_POPT_ENV); export NLUKI_SYSROOT=$(NLUKI_PRIMARYSYSROOT); cd $(NLUKI_TARGET_BUILDROOT)/popt; cmake --build .
	@echo -e \\t[NLUKI] TOUCH popt-build.stamp
	@touch $(NLUKI_BUILDROOT)/popt-build.stamp

popt-build: $(NLUKI_BUILDROOT)/popt-build.stamp
.PHONY : popt-build

$(NLUKI_BUILDROOT)/popt-configure.stamp: $(MKFILE_DIR)/Submodules/popt \
										$(NLUKI_BUILDROOT)/glibc-install.stamp $(NLUKI_BUILDROOT)/gcc-install.stamp $(NLUKI_BUILDROOT)/binutils-install.stamp
	@mkdir -p $(NLUKI_TARGET_BUILDROOT)/popt
	@echo -e \\t[NLUKI] TARGET_CMAKE_CONFIGURE popt
	@$(NLUKI_POPT_ENV); cmake -B $(NLUKI_TARGET_BUILDROOT)/popt -S $(MKFILE_DIR)/Submodules/popt \
		--toolchain $(MKFILE_DIR)/CrossToolchain.cmake
	@echo -e \\t[NLUKI] TOUCH popt-configure.stamp
	@touch $(NLUKI_BUILDROOT)/popt-configure.stamp