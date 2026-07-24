NLUKI_READLINE_ENV := $(NLUKI_AUTO_TARGET_PRIMARYSYSROOT_PATH); $(NLUKI_AUTO_TARGET_PRIMARYSYSROOT_LIBRARY_PATH); $(NLUKI_AUTO_TARGET_PRIMARYSYSROOT_CPATH) \
	$(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_LIBRARY_PATH,crosssysroot); $(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_CPATH,crosssysroot); $(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_PATH,crosssysroot); \
	$(call NLUKI_AUTO_HOST_CLASSIC_SYSROOT_PATH,hostsysroot); export CC=$(NLUKI_ALTERNATIVE_TARGET_ARCH)-pc-linux-gcc; CXX=$(NLUKI_ALTERNATIVE_TARGET_ARCH)-pc-linux-g++

$(NLUKI_BUILDROOT)/readline-install.stamp: $(NLUKI_BUILDROOT)/readline-build.stamp
	mkdir -p $(NLUKI_PRIMARYSYSROOT)
	$(NLUKI_READLINE_ENV); cd $(NLUKI_TARGET_BUILDROOT)/readline; $(MAKE) DESTDIR=$(NLUKI_PRIMARYSYSROOT) install
	touch $(NLUKI_BUILDROOT)/readline-install.stamp

$(NLUKI_PRIMARYSYSROOT): $(NLUKI_BUILDROOT)/readline-install.stamp

readline-install: $(NLUKI_BUILDROOT)/readline-install.stamp
.PHONY : readline-install

$(NLUKI_BUILDROOT)/readline-build.stamp: $(NLUKI_TARGET_BUILDROOT)/readline/Makefile
	$(NLUKI_READLINE_ENV); cd $(NLUKI_TARGET_BUILDROOT)/readline; $(MAKE)
	touch $(NLUKI_BUILDROOT)/readline-build.stamp

readline-build: $(NLUKI_BUILDROOT)/readline-build.stamp
.PHONY : readline-build

$(NLUKI_TARGET_BUILDROOT)/readline/Makefile: $(NLUKI_BUILDROOT)/ncurses-install.stamp \
										$(NLUKI_BUILDROOT)/glibc-install.stamp $(NLUKI_BUILDROOT)/gcc-install.stamp $(NLUKI_BUILDROOT)/binutils-install.stamp
	mkdir -p $(NLUKI_TARGET_BUILDROOT)/readline
	$(NLUKI_READLINE_ENV); cd $(NLUKI_TARGET_BUILDROOT)/readline; $(MKFILE_DIR)/Submodules/readline/configure \
		--prefix=/usr \
		--libdir=/usr/lib64 \
		--enable-year2038 --enable-multibyte --disable-install-examples --enable-shared --enable-static --with-curses \
		CFLAGS="-O3" CXXFLAGS="-O3"
