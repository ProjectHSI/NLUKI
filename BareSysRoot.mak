# Copies some barebones sysroot to avoid sysroot contamination w/ libraries whilst still allowing you to run Configure scripts and the like
$(NLUKI_TARGET_SYSROOT_OVERLAYS)/bare_sysroot: /usr/bin/
	rm -rfv $(NLUKI_TARGET_SYSROOT_OVERLAYS)/bare_sysroot
	mkdir -p $(NLUKI_TARGET_SYSROOT_OVERLAYS)/bare_sysroot
	mkdir -p $(NLUKI_TARGET_SYSROOT_OVERLAYS)/bare_sysroot/usr/bin
	ln -fsv /usr/bin/* $(NLUKI_TARGET_SYSROOT_OVERLAYS)/bare_sysroot/usr/bin