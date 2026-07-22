NLUKI_LUAJIT_ENV := $(NLUKI_AUTO_TARGET_PRIMARYSYSROOT_PATH); $(NLUKI_AUTO_TARGET_PRIMARYSYSROOT_LIBRARY_PATH); $(NLUKI_AUTO_TARGET_PRIMARYSYSROOT_CPATH) \
	$(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_LIBRARY_PATH,crosssysroot); $(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_CPATH,crosssysroot); $(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_PATH,crosssysroot); \
	$(call NLUKI_AUTO_HOST_CLASSIC_SYSROOT_PATH,hostsysroot)

$(NLUKI_BUILDROOT)/luajit-install.stamp: $(NLUKI_BUILDROOT)/luajit-build.stamp
	mkdir -p $(NLUKI_PRIMARYSYSROOT)
	$(NLUKI_LUAJIT_ENV); cd $(NLUKI_TARGET_BUILDROOT)/luajit; $(MAKE) DESTDIR=$(NLUKI_PRIMARYSYSROOT) install
	touch $(NLUKI_BUILDROOT)/luajit-install.stamp

$(NLUKI_PRIMARYSYSROOT): $(NLUKI_BUILDROOT)/luajit-install.stamp

luajit-install: $(NLUKI_BUILDROOT)/luajit-install.stamp
.PHONY : luajit-install

$(NLUKI_BUILDROOT)/luajit-build.stamp: $(NLUKI_TARGET_BUILDROOT)/luajit/Makefile
	$(NLUKI_LUAJIT_ENV); cd $(NLUKI_TARGET_BUILDROOT)/luajit; $(MAKE)
	touch $(NLUKI_BUILDROOT)/luajit-build.stamp

luajit-build: $(NLUKI_BUILDROOT)/luajit-build.stamp
.PHONY : luajit-build