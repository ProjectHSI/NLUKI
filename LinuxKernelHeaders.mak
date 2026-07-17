# Install Linux Kernel Headers
$(NLUKI_BUILDROOT)/linux_headers-install.stamp: $(NLUKI_BUILDROOT)/linux_headers-build.stamp
	mkdir -p $(NLUKI_BUILDROOT)/PrimarySysRoot/
	cd $(NLUKI_TARGET_BUILDROOT)/linux_headers/; $(MAKE) INSTALL_HDR_PATH=$(NLUKI_BUILDROOT)/PrimarySysRoot/usr headers_install
	touch $(NLUKI_BUILDROOT)/linux_headers-install.stamp

linux-headers-install: $(NLUKI_BUILDROOT)/linux_headers-install.stamp ;
.PHONY: linux-headers-install

# Make Linux Kernel Headers
$(NLUKI_BUILDROOT)/linux_headers-build.stamp:
	mkdir -p $(NLUKI_TARGET_BUILDROOT)/linux_headers/
	cd $(MKFILE_DIR)/Submodules/linux; $(MAKE) O=$(NLUKI_TARGET_BUILDROOT)/linux_headers/ ARCH=$(NLUKI_TARGET_ARCH) headers
	touch $(NLUKI_BUILDROOT)/linux_headers-build.stamp

linux-headers-build: $(NLUKI_BUILDROOT)/linux_headers-build.stamp ;
.PHONY: linux-headers-build