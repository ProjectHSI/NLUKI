$(NLUKI_BUILDROOT)/PrimarySysRoot:
	touch -m $(NLUKI_BUILDROOT)/PrimarySysRoot

$(NLUKI_BUILDROOT)/PrimarySysRoot.squashfs: $(NLUKI_BUILDROOT)/PrimarySysRoot
	mksquashfs $(NLUKI_BUILDROOT)/PrimarySysRoot $(NLUKI_BUILDROOT)/PrimarySysRoot.squashfs -comp xz \
		-tailends -all-root -exit-on-error

#$(NLUKI_BUILDROOT)/PrimarySysRoot: glibc
#	mkdir -p $(NLUKI_BUILDROOT)/PrimarySysRoot
#	cp -rfv $(NLUKI_TARGET_SYSROOT_OVERLAYS)/glibc/* $(NLUKI_BUILDROOT)/PrimarySysRoot