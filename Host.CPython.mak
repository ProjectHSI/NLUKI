NLUKI_HOST_CPYTHON_ENV := $(call NLUKI_AUTO_HOST_CLASSIC_SYSROOT_PATH,hostsysroot)

$(NLUKI_HOSTROOT)/host-cpython-install.stamp: $(NLUKI_HOSTROOT)/host-cpython-build.stamp
	@echo -e \\t[NLUKI] HOST_MAKE_INSTALL cpython
	@$(NLUKI_HOST_CPYTHON_ENV); cd $(NLUKI_HOST_BUILDROOT)/cpython; $(MAKE) install
	@echo -e \\t[NLUKI] TOUCH host-cpython-install.stamp
	@touch $(NLUKI_HOSTROOT)/host-cpython-install.stamp

host-cpython-install: $(NLUKI_HOSTROOT)/cpython-install.stamp
.PHONY : host-cpython-install

$(NLUKI_HOSTROOT)/host-cpython-build.stamp: $(NLUKI_HOST_BUILDROOT)/cpython/Makefile
	@echo -e \\t[NLUKI] HOST_MAKE cpython
	$(NLUKI_HOST_CPYTHON_ENV); cd $(NLUKI_HOST_BUILDROOT)/cpython; $(MAKE)
	@echo -e \\t[NLUKI] TOUCH host-cpython-build.stamp
	@touch $(NLUKI_HOSTROOT)/host-cpython-build.stamp

host-cpython-build: $(NLUKI_HOSTROOT)/cpython-build.stamp
.PHONY : host-cpython-build

$(NLUKI_HOST_BUILDROOT)/cpython/Makefile: $(NLUKI_HOSTROOT)/host-glibc-install.sentinel $(NLUKI_HOSTROOT)/host-gcc-install.sentinel $(NLUKI_HOSTROOT)/host-binutils-install.sentinel
	@echo -e \\t[NLUKI] MKDIR Host/Build/cpython
	@mkdir -p $(NLUKI_HOST_BUILDROOT)/cpython
	@echo -e \\t[NLUKI] HOST_CONFIGURE cpython
#	Disabled optimisation for a time being, takes too long.
	@$(NLUKI_HOST_CPYTHON_ENV); cd $(NLUKI_HOST_BUILDROOT)/cpython; $(MKFILE_DIR)/Submodules/cpython/configure \
		--prefix=$(NLUKI_HOST_CLASSIC_SYSROOTS)/hostsysroot \
		CFLAGS="-O3" CXXFLAGS="-O3"