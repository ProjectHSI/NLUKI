# Make JumpStarter
$(NLUKI_TARGET_SYSROOT_OVERLAYS)/JumpStarter: $(NLUKI_TARGET_BUILDROOT)/JumpStarter/jump_starter
	rm -rfv $(NLUKI_TARGET_SYSROOT_OVERLAYS)/JumpStarter
	mkdir -p $(NLUKI_TARGET_SYSROOT_OVERLAYS)/JumpStarter/bin
	cp -fv $(NLUKI_TARGET_BUILDROOT)/JumpStarter/jump_starter $(NLUKI_TARGET_SYSROOT_OVERLAYS)/JumpStarter/bin

$(NLUKI_TARGET_BUILDROOT)/JumpStarter/jump_starter: $(NLUKI_BUILDROOT)/klibc-install.stamp $(NLUKI_BUILDROOT)/firstpass-gcc-install.stamp $(NLUKI_BUILDROOT)/binutils-install.stamp $(MKFILE_DIR)/JumpStarter/*.c
	mkdir -p $(NLUKI_TARGET_BUILDROOT)/JumpStarter
	mkdir -p $(NLUKI_TARGET_BUILDROOT)/JumpStarter
	$(call NLUKI_AUTO_SYSROOT_OVERLAY_CPATH,klibc); $(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_PATH,crosssysroot); \
	cd $(NLUKI_TARGET_BUILDROOT)/JumpStarter; \
	$(NLUKI_TARGET_ARCH)-pc-linux-gcc -static -o $(NLUKI_TARGET_BUILDROOT)/JumpStarter/jump_starter $(MKFILE_DIR)/JumpStarter/jump_starter.c -v \
	$(NLUKI_TARGET_SYSROOT_OVERLAYS)/klibc/usr/lib/klibc/lib/crt0.o $(NLUKI_TARGET_SYSROOT_OVERLAYS)/klibc/usr/lib/klibc/lib/libc.a \
	-Xlinker --no-dynamic-linker -D__KLIBC__ -nostdlib -nostdinc -fno-stack-protector

#$(NLUKI_TARGET_SYSROOTS)/JumpStarter: $(NLUKI_TARGET_SYSROOT_OVERLAYS)/klibc \
										$(NLUKI_TARGET_SYSROOT_OVERLAYS)/linux_headers
#	rm -rfv $(NLUKI_TARGET_SYSROOTS)/JumpStarter
#	mkdir -p $(NLUKI_TARGET_SYSROOTS)/JumpStarter
#	cp -rfv $(NLUKI_TARGET_SYSROOT_OVERLAYS)/klibc/* $(NLUKI_TARGET_SYSROOTS)/JumpStarter
#	cp -rfv $(NLUKI_TARGET_SYSROOT_OVERLAYS)/fp_gcc/* $(NLUKI_TARGET_SYSROOTS)/JumpStarter
#	cp -rfv $(NLUKI_TARGET_SYSROOT_OVERLAYS)/fp_binutils/* $(NLUKI_TARGET_SYSROOTS)/JumpStarter


JumpStarter: $(NLUKI_TARGET_SYSROOT_OVERLAYS)/JumpStarter ;
.PHONY : JumpStarter