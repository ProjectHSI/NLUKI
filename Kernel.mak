# Default value is for QT config (if changing, make sure there's no space after the variable!)
NLUKI_KERNEL_CONFIG_PREFIX ?= x

# not including hostsysroot since I just can't get libopcodes to be loaded wo/ wrecking everything else.
NLUKI_KERNEL_ENV := \
	$(call NLUKI_AUTO_HOST_CLASSIC_SYSROOT_LIBRARY_PATH,hostsysroot); $(call NLUKI_AUTO_HOST_CLASSIC_SYSROOT_CPATH,hostsysroot); $(call NLUKI_AUTO_HOST_CLASSIC_SYSROOT_PATH,hostsysroot); \
	$(call NLUKI_AUTO_HOST_SYSROOT_OVERLAYS_LD_LIBRARY_PATH,libopcodes); \
	$(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_LIBRARY_PATH,crosssysroot); $(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_CPATH,crosssysroot); $(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_PATH,crosssysroot); \
	$(NLUKI_AUTO_TARGET_PRIMARYSYSROOT_PATH); $(NLUKI_AUTO_TARGET_PRIMARYSYSROOT_LIBRARY_PATH); $(NLUKI_AUTO_TARGET_PRIMARYSYSROOT_CPATH)

configure-kernel: $(NLUKI_TARGET_BUILDROOT)/linux
	cd $(NLUKI_TARGET_BUILDROOT)/linux; $(MAKE) ARCH=$(NLUKI_TARGET_ARCH) $(NLUKI_KERNEL_CONFIG_PREFIX)config
.PHONY: configure-kernel

$(NLUKI_BUILDROOT)/VMLinux-pre.efi $(NLUKI_BUILDROOT)/linux-install-kernel.stamp: $(NLUKI_BUILDROOT)/linux-build-kernel.stamp
	mkdir -p $(NLUKI_BUILDROOT)/VMLinuZ
#	$(NLUKI_KERNEL_ENV); cd $(NLUKI_TARGET_BUILDROOT)/linux; $(MAKE) ARCH=$(NLUKI_TARGET_ARCH) INSTALL_PATH="$(NLUKI_BUILDROOT)/VMLinuZ" install
	cp -fv $(NLUKI_TARGET_BUILDROOT)/linux/arch/x86/boot/bzImage $(NLUKI_BUILDROOT)/VMLinux-pre.efi
	touch $(NLUKI_BUILDROOT)/linux-install-kernel.stamp

linux-install-kernel: $(NLUKI_BUILDROOT)/linux-install-kernel.stamp
.PHONY: linux-install-kernel

$(NLUKI_BUILDROOT)/linux-build-kernel.stamp: $(NLUKI_BUILDROOT)/linux-early-build-kernel.stamp $(NLUKI_BUILDROOT)/linux-install-modules.stamp $(NLUKI_BUILDROOT)/linux-configure-kernel.stamp $(NLUKI_BUILDROOT)/JumpStarterSysRoot.cpio.xz $(NLUKI_BUILDROOT)/gcc-install.stamp $(NLUKI_BUILDROOT)/binutils-install.stamp $(NLUKI_BUILDROOT)/glibc-install.stamp | $(NLUKI_TARGET_BUILDROOT)/linux
	cd $(NLUKI_TARGET_BUILDROOT)/linux; $(MKFILE_DIR)/Submodules/linux/scripts/config --set-str INITRAMFS_SOURCE "$(NLUKI_BUILDROOT)/JumpStarterSysRoot.cpio.xz"
	$(NLUKI_KERNEL_ENV); cd $(NLUKI_TARGET_BUILDROOT)/linux; $(MAKE) ARCH=$(NLUKI_TARGET_ARCH) bzImage
	touch $(NLUKI_BUILDROOT)/linux-build-kernel.stamp

linux-build-kernel: $(NLUKI_BUILDROOT)/linux-build-kernel.stamp
.PHONY: linux-build-kernel

$(NLUKI_BUILDROOT)/linux-configure-kernel.stamp: | $(NLUKI_TARGET_BUILDROOT)/linux
	touch $(NLUKI_BUILDROOT)/linux-configure-kernel.stamp

linux-setup-config: $(NLUKI_BUILDROOT)/linux-configure-kernel.stamp
.PHONY: linux-setup-config

$(NLUKI_BUILDROOT)/linux-install-modules.stamp: $(NLUKI_BUILDROOT)/linux-build-modules.stamp
	mkdir -p $(NLUKI_BUILDROOT)/PrimarySysRoot
	$(NLUKI_KERNEL_ENV); cd $(NLUKI_TARGET_BUILDROOT)/linux; $(MAKE) ARCH=$(NLUKI_TARGET_ARCH) INSTALL_MOD_PATH="$(NLUKI_BUILDROOT)/PrimarySysRoot/usr" modules_install
	touch $(NLUKI_BUILDROOT)/linux-install-modules.stamp

$(NLUKI_PRIMARYSYSROOT): $(NLUKI_BUILDROOT)/linux-install-modules.stamp

linux-install-modules: $(NLUKI_BUILDROOT)/linux-install-modules.stamp
.PHONY: linux-install-modules

$(NLUKI_BUILDROOT)/linux-build-modules.stamp: $(NLUKI_BUILDROOT)/linux-early-build-kernel.stamp $(NLUKI_BUILDROOT)/linux-configure-kernel.stamp $(NLUKI_BUILDROOT)/gcc-install.stamp $(NLUKI_BUILDROOT)/binutils-install.stamp $(NLUKI_BUILDROOT)/glibc-install.stamp | $(NLUKI_TARGET_BUILDROOT)/linux 
	$(NLUKI_KERNEL_ENV); cd $(NLUKI_TARGET_BUILDROOT)/linux; $(MAKE) ARCH=$(NLUKI_TARGET_ARCH) modules
	touch $(NLUKI_BUILDROOT)/linux-build-modules.stamp

linux-build-modules: $(NLUKI_BUILDROOT)/linux-build-modules.stamp
.PHONY: linux-build-modules

$(NLUKI_BUILDROOT)/linux-early-build-kernel.stamp: $(NLUKI_BUILDROOT)/linux-configure-kernel.stamp $(NLUKI_BUILDROOT)/gcc-install.stamp $(NLUKI_BUILDROOT)/binutils-install.stamp $(NLUKI_BUILDROOT)/glibc-install.stamp | $(NLUKI_TARGET_BUILDROOT)/linux
	#	TODO: Make comment for this
	cd $(NLUKI_TARGET_BUILDROOT)/linux; $(MKFILE_DIR)/Submodules/linux/scripts/config --set-str INITRAMFS_SOURCE ""
	@echo -e \\t[NLUKI] TARGET_MAKE vmlinux
	@$(NLUKI_KERNEL_ENV); cd $(NLUKI_TARGET_BUILDROOT)/linux; $(MAKE) ARCH=$(NLUKI_TARGET_ARCH) vmlinux
	@echo -e \\t[NLUKI] TOUCH linux-early-build-kernel.stamp
	@touch $(NLUKI_BUILDROOT)/linux-early-build-kernel.stamp

$(NLUKI_TARGET_BUILDROOT)/linux: $(MKFILE_DIR)/KernelConfigs/$(NLUKI_TARGET_ARCH).config | $(MKFILE_DIR)/Submodules/linux
	mkdir -p $(NLUKI_TARGET_BUILDROOT)/linux
	cd $(MKFILE_DIR)/Submodules/linux; $(MAKE) O=$(NLUKI_TARGET_BUILDROOT)/linux ARCH=$(NLUKI_TARGET_ARCH) defconfig
	cp -fv $(MKFILE_DIR)/KernelConfigs/$(NLUKI_TARGET_ARCH).config $(NLUKI_TARGET_BUILDROOT)/linux/.config
