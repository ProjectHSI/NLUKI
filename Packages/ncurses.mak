NLUKI_NCURSES_ENV := $(NLUKI_AUTO_TARGET_PRIMARYSYSROOT_PATH); $(NLUKI_AUTO_TARGET_PRIMARYSYSROOT_LIBRARY_PATH); $(NLUKI_AUTO_TARGET_PRIMARYSYSROOT_CPATH) \
	$(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_LIBRARY_PATH,crosssysroot); $(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_CPATH,crosssysroot); $(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_PATH,crosssysroot); \
	$(call NLUKI_AUTO_HOST_CLASSIC_SYSROOT_PATH,hostsysroot)

$(NLUKI_BUILDROOT)/ncurses-install.stamp: $(NLUKI_BUILDROOT)/ncurses-build.stamp
	mkdir -p $(NLUKI_PRIMARYSYSROOT)
	$(NLUKI_NCURSES_ENV); cd $(NLUKI_TARGET_BUILDROOT)/ncurses; $(MAKE) DESTDIR=$(NLUKI_PRIMARYSYSROOT) install
	touch $(NLUKI_BUILDROOT)/ncurses-install.stamp

#$(NLUKI_PRIMARYSYSROOT): $(NLUKI_BUILDROOT)/ncurses-install.stamp

ncurses-install: $(NLUKI_BUILDROOT)/ncurses-install.stamp
.PHONY : ncurses-install

$(NLUKI_BUILDROOT)/ncurses-build.stamp: $(NLUKI_TARGET_BUILDROOT)/ncurses/Makefile
	$(NLUKI_NCURSES_ENV); cd $(NLUKI_TARGET_BUILDROOT)/ncurses; $(MAKE)
	touch $(NLUKI_BUILDROOT)/ncurses-build.stamp

ncurses-build: $(NLUKI_BUILDROOT)/ncurses-build.stamp
.PHONY : ncurses-build

$(NLUKI_TARGET_BUILDROOT)/ncurses/Makefile: $(NLUKI_BUILDROOT)/glibc-install.stamp $(NLUKI_BUILDROOT)/gcc-install.stamp $(NLUKI_BUILDROOT)/binutils-install.stamp $(MKFILE_DIR)/Dependencies/ncurses
	mkdir -p $(NLUKI_TARGET_BUILDROOT)/ncurses
	$(NLUKI_NCURSES_ENV); cd $(NLUKI_TARGET_BUILDROOT)/ncurses; $(MKFILE_DIR)/Dependencies/ncurses/configure \
		--without-tests \
		--with-shared \
		--with-termlib \
		--disable-widec \
		--libdir=/usr/lib64 \
		CFLAGS="-O3" CXXFLAGS="-O3"

$(MKFILE_DIR)/Dependencies/ncurses: $(MKFILE_DIR)/Dependencies/ncurses.tar.gz
	mkdir -p $(MKFILE_DIR)/Dependencies/ncurses
	cd $(MKFILE_DIR)/Dependencies/ncurses; tar -xvf $(MKFILE_DIR)/Dependencies/ncurses.tar.gz --strip-components=1

$(MKFILE_DIR)/Dependencies/ncurses.tar.gz:
	mkdir -p $(MKFILE_DIR)/Dependencies/
	wget https://invisible-island.net/datafiles/current/ncurses.tar.gz -O $(MKFILE_DIR)/Dependencies/ncurses.tar.gz --no-check-certificate

ncurses-download: $(MKFILE_DIR)/Dependencies/ncurses
.PHONY : ncurses-download

NLUKI_TARGETS_TO_STILL_BUILD_AS_HOST += $(MKFILE_DIR)/Dependencies/ncurses
