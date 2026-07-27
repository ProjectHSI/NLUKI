#GLIBC_COMPILER_FLAGS = "-Wno-error=attributes -Wno-error=unused-result -Wno-error=infinite-recursion -Wno-error=cpp -U_FORTIFY_SOURCE -O3"
#CHECKED_GLIBC_COMPILER_FLAGS = "-Wno-error=attributes -Wno-error=unused-result -Wno-error=infinite-recursion -Wno-error=cpp -U_FORTIFY_SOURCE -O3"

GLIBC_ENV = export C_INCLUDE_PATH=""; export CPLUS_INCLUDE_PATH=""; \
	$(NLUKI_QUICK_TARGET_COMPILER_ENV); \
	$(call NLUKI_AUTO_HOST_CLASSIC_SYSROOT_PATH,hostsysroot); $(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_PATH,crosssysroot)

$(NLUKI_BUILDROOT)/glibc-install.stamp: $(NLUKI_BUILDROOT)/glibc-build.stamp
	mkdir -p $(NLUKI_BUILDROOT)/PrimarySysRoot
	$(GLIBC_ENV); cd $(NLUKI_TARGET_BUILDROOT)/glibc; $(MAKE) DESTDIR="$(NLUKI_BUILDROOT)/PrimarySysRoot" install
	touch $(NLUKI_BUILDROOT)/glibc-install.stamp

$(NLUKI_PRIMARYSYSROOT): $(NLUKI_BUILDROOT)/glibc-install.stamp

glibc-install: $(NLUKI_BUILDROOT)/glibc-install.stamp
.PHONY : glibc-install

# Make GLibC
$(NLUKI_BUILDROOT)/glibc-build.stamp: $(NLUKI_TARGET_BUILDROOT)/glibc/Makefile
	$(GLIBC_ENV); cd $(NLUKI_TARGET_BUILDROOT)/glibc; $(MAKE) V=0 CFLAGS="-O3" CXXFLAGS="-O3"
	touch $(NLUKI_BUILDROOT)/glibc-build.stamp

glibc-build: $(NLUKI_BUILDROOT)/glibc-build.stamp
.PHONY : glibc-build

# Configure GLibC
$(NLUKI_TARGET_BUILDROOT)/glibc/Makefile: $(NLUKI_BUILDROOT)/linux_headers-install.stamp $(NLUKI_BUILDROOT)/binutils-install.stamp $(NLUKI_BUILDROOT)/firstpass-gcc-install.stamp \
									| $(nluki-lsb) $(NLUKI_TARGET_BUILDROOT)/glibc/configparams
	mkdir -p $(NLUKI_TARGET_BUILDROOT)/glibc
	cd $(NLUKI_TARGET_BUILDROOT)/glibc; \
	$(GLIBC_ENV); $(MKFILE_DIR)/Submodules/glibc/configure \
		--enable-kernel=7.0 \
		--with-build-sysroot=$(NLUKI_BUILDROOT)/PrimarySysRoot \
		--enable-stack-protector=strong \
		--host=$(NLUKI_GCC_ARCH)-pc-linux \
		--build=$(shell $(MKFILE_DIR)/Submodules/glibc/scripts/config.guess) \
		--disable-nscd \
		--enable-silent-rules \
		--with-headers=$(NLUKI_BUILDROOT)/PrimarySysRoot/usr/include/ \
		--prefix=/usr/ \
		--disable-werror CFLAGS="-O3" CXXFLAGS="-O3"

#$(eval $(call NLUKI_MAKE_SYS_ROOT_TARGET,glibc,linux_headers fp_gcc fp_binutils,,gcc binutils))

$(NLUKI_TARGET_BUILDROOT)/glibc/configparams:
	mkdir -p $(NLUKI_TARGET_BUILDROOT)/glibc
	cd $(NLUKI_TARGET_BUILDROOT)/glibc; echo "rootsbindir=/usr/sbin" > configparams
