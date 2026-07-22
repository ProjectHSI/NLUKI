NLUKI_BASH_ENV := $(NLUKI_AUTO_TARGET_PRIMARYSYSROOT_PATH); $(NLUKI_AUTO_TARGET_PRIMARYSYSROOT_LIBRARY_PATH); $(NLUKI_AUTO_TARGET_PRIMARYSYSROOT_CPATH) \
	$(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_LIBRARY_PATH,crosssysroot); $(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_CPATH,crosssysroot); $(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_PATH,crosssysroot); \
	$(call NLUKI_AUTO_HOST_CLASSIC_SYSROOT_PATH,hostsysroot); export CC=$(NLUKI_ALTERNATIVE_TARGET_ARCH)-pc-linux-gcc; CXX=$(NLUKI_ALTERNATIVE_TARGET_ARCH)-pc-linux-g++

$(NLUKI_BUILDROOT)/bash-install.stamp: $(NLUKI_BUILDROOT)/bash-build.stamp
	mkdir -p $(NLUKI_PRIMARYSYSROOT)
	$(NLUKI_BASH_ENV); cd $(NLUKI_TARGET_BUILDROOT)/bash; $(MAKE) DESTDIR=$(NLUKI_PRIMARYSYSROOT) install
	touch $(NLUKI_BUILDROOT)/bash-install.stamp

$(NLUKI_PRIMARYSYSROOT): $(NLUKI_BUILDROOT)/bash-install.stamp

bash-install: $(NLUKI_BUILDROOT)/bash-install.stamp
.PHONY : bash-install

$(NLUKI_BUILDROOT)/bash-build.stamp: $(NLUKI_TARGET_BUILDROOT)/bash/Makefile
	$(NLUKI_BASH_ENV); cd $(NLUKI_TARGET_BUILDROOT)/bash; $(MAKE)
	touch $(NLUKI_BUILDROOT)/bash-build.stamp

bash-build: $(NLUKI_BUILDROOT)/bash-build.stamp
.PHONY : bash-build

$(NLUKI_TARGET_BUILDROOT)/bash/Makefile: $(NLUKI_BUILDROOT)/ncurses-install.stamp \
										$(NLUKI_BUILDROOT)/glibc-install.stamp $(NLUKI_BUILDROOT)/gcc-install.stamp $(NLUKI_BUILDROOT)/binutils-install.stamp
	mkdir -p $(NLUKI_TARGET_BUILDROOT)/bash
	$(NLUKI_BASH_ENV); cd $(NLUKI_TARGET_BUILDROOT)/bash; $(MKFILE_DIR)/Submodules/bash/configure \
		--enable-alias --enable-arith-for-command --enable-array-variables --enable-bang-history --enable-brace-expansion \
		--enable-casemod-attributes --enable-casemod-expansions --enable-command-timing --enable-cond-command \
		--enable-cond-regexp --enable-coprocesses --enable-dparen-arithmetic --enable-extended-glob --enable-help-builtin \
		--enable-history --enable-job-control --enable-multibyte --enable-net-redirections --enable-process-substitution \
		--enable-progcomp -enable-prompt-string-decoding --enable-readline --enable-restricted --enable-translatable-strings --enable-year2038 \
		CFLAGS="-O3" CXXFLAGS="-O3"