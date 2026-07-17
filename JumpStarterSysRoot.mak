NLUKI_JUMP_STARTER_SYSROOT_XZ_COMPRESSION_OPTIONS = 

$(NLUKI_BUILDROOT)/JumpStarterSysRoot.cpio.xz: $(NLUKI_BUILDROOT)/JumpStarterSysRoot.cpio
	xz --check=crc32 --lzma2=dict=1MiB -z --threads=0 $(NLUKI_BUILDROOT)/JumpStarterSysRoot.cpio -f $(NLUKI_JUMP_STARTER_SYSROOT_XZ_COMPRESSION_OPTIONS) -v -v -k

$(NLUKI_BUILDROOT)/JumpStarterSysRoot.cpio: $(NLUKI_BUILDROOT)/JumpStarterSysRoot
	cd $(NLUKI_BUILDROOT)/JumpStarterSysRoot; find . \
	| cpio -v --reproducible -o --format=newc --no-absolute-filenames --directory=$(NLUKI_BUILDROOT)/JumpStarterSysRoot > \
	$(NLUKI_BUILDROOT)/JumpStarterSysRoot.cpio

$(NLUKI_BUILDROOT)/JumpStarterSysRoot: $(NLUKI_TARGET_SYSROOT_OVERLAYS)/JumpStarter
	mkdir -p $(NLUKI_BUILDROOT)/JumpStarterSysRoot
	cp -rfv $(NLUKI_TARGET_SYSROOT_OVERLAYS)/JumpStarter/* $(NLUKI_BUILDROOT)/JumpStarterSysRoot
	ln -sfv /bin/jump_starter $(NLUKI_BUILDROOT)/JumpStarterSysRoot/init
	touch -m $(NLUKI_BUILDROOT)/JumpStarterSysRoot

NLUKI_PACKAGE_APPROACH ?= PRIMARY_IN_JUMPSTARTER

ifeq ($(NLUKI_PACKAGE_APPROACH),PRIMARY_IN_JUMPSTARTER)
$(NLUKI_BUILDROOT)/JumpStarterSysRoot.cpio: $(NLUKI_BUILDROOT)/JumpStarterSysRoot/jump-start.squashfs
# intentionally empty

$(NLUKI_BUILDROOT)/JumpStarterSysRoot/jump-start.squashfs: $(NLUKI_BUILDROOT)/JumpStarterSysRoot $(NLUKI_BUILDROOT)/PrimarySysRoot.squashfs
	cp -fv $(NLUKI_BUILDROOT)/PrimarySysRoot.squashfs $(NLUKI_BUILDROOT)/JumpStarterSysRoot/jump-start.squashfs
#	mv --debug -f $(NLUKI_BUILDROOT)/JumpStarterSysRoot/PrimarySysRoot.squashfs $(NLUKI_BUILDROOT)/JumpStarterSysRoot/jump-start.squashfs
endif