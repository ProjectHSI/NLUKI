NLUKI_JUMP_STARTER_SYSROOT_XZ_COMPRESSION_OPTIONS = 

$(NLUKI_BUILDROOT)/JumpStarterSysRoot.cpio.xz: $(NLUKI_BUILDROOT)/JumpStarterSysRoot.cpio
	xz --check=crc32 --lzma2=dict=1MiB -z --threads=0 $(NLUKI_BUILDROOT)/JumpStarterSysRoot.cpio -f $(NLUKI_JUMP_STARTER_SYSROOT_XZ_COMPRESSION_OPTIONS) -v -v -k

$(NLUKI_BUILDROOT)/JumpStarterSysRoot.cpio: $(NLUKI_BUILDROOT)/JumpStarterSysRoot
	fakeroot -i $(NLUKI_BUILDROOT)/JumpStarterSysRoot.fakeroot -s $(NLUKI_BUILDROOT)/JumpStarterSysRoot.fakeroot -- sh -c "cd $(NLUKI_BUILDROOT)/JumpStarterSysRoot; find . \
	| cpio -v --reproducible -o --format=newc --no-absolute-filenames --directory=$(NLUKI_BUILDROOT)/JumpStarterSysRoot > \
	$(NLUKI_BUILDROOT)/JumpStarterSysRoot.cpio"

$(NLUKI_BUILDROOT)/JumpStarterSysRoot: $(NLUKI_BUILDROOT)/JumpStarterSysRoot/init $(NLUKI_BUILDROOT)/JumpStarterSysRoot/dev/console
#	Directory is already gaurenteed to have been made by dependencies
	touch -m $(NLUKI_BUILDROOT)/JumpStarterSysRoot

$(NLUKI_BUILDROOT)/JumpStarterSysRoot/dev/console:
	mkdir -p $(NLUKI_BUILDROOT)/JumpStarterSysRoot/dev
	fakeroot -i $(NLUKI_BUILDROOT)/JumpStarterSysRoot.fakeroot -s $(NLUKI_BUILDROOT)/JumpStarterSysRoot.fakeroot -- mknod -m 600 $(NLUKI_BUILDROOT)/JumpStarterSysRoot/dev/console c 5 1 

$(NLUKI_BUILDROOT)/JumpStarterSysRoot/bin/jump_starter: $(NLUKI_TARGET_SYSROOT_OVERLAYS)/JumpStarter
	mkdir -p $(NLUKI_TARGET_SYSROOT_OVERLAYS)/JumpStarter/bin
	cp -rfv $(NLUKI_TARGET_SYSROOT_OVERLAYS)/JumpStarter/bin/jump_starter $(NLUKI_BUILDROOT)/JumpStarterSysRoot/bin/jump_starter

$(NLUKI_BUILDROOT)/JumpStarterSysRoot/init: $(NLUKI_BUILDROOT)/JumpStarterSysRoot/bin/jump_starter
	ln -sfv /bin/jump_starter $(NLUKI_BUILDROOT)/JumpStarterSysRoot/init

NLUKI_PACKAGE_APPROACH ?= PRIMARY_IN_JUMPSTARTER

ifeq ($(NLUKI_PACKAGE_APPROACH),PRIMARY_IN_JUMPSTARTER)
$(NLUKI_BUILDROOT)/JumpStarterSysRoot.cpio: $(NLUKI_BUILDROOT)/JumpStarterSysRoot/jump-start.squashfs
# intentionally empty

$(NLUKI_BUILDROOT)/JumpStarterSysRoot/jump-start.squashfs: $(NLUKI_BUILDROOT)/JumpStarterSysRoot $(NLUKI_BUILDROOT)/PrimarySysRoot.squashfs
	cp -fv $(NLUKI_BUILDROOT)/PrimarySysRoot.squashfs $(NLUKI_BUILDROOT)/JumpStarterSysRoot/jump-start.squashfs
#	mv --debug -f $(NLUKI_BUILDROOT)/JumpStarterSysRoot/PrimarySysRoot.squashfs $(NLUKI_BUILDROOT)/JumpStarterSysRoot/jump-start.squashfs
endif