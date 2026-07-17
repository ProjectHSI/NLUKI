# --- Sysroot LSB-Compliance ---
# -- i{3,6}86 --
ifneq ($(filter $(NLUKI_TARGET_ARCH),i386 i686),) 
$(NLUKI_PRIMARYSYSROOT)/lib/ld-lsb.so.3:
	mkdir -p $(NLUKI_PRIMARYSYSROOT)/lib/
	ln -sfv ld-linux.so.2 $(NLUKI_PRIMARYSYSROOT)/lib/ld-lsb.so.3

nluki-lsb-i368 := $(NLUKI_PRIMARYSYSROOT)/lib/ld-lsb.so.3
nluki-lsb-i868 := $(NLUKI_PRIMARYSYSROOT)/lib/ld-lsb.so.3
endif

# -- x86_64 --
ifeq ($(NLUKI_TARGET_ARCH),x86_64)
$(NLUKI_PRIMARYSYSROOT)/lib64/ld-linux-x86-64.so.2:
	mkdir -p $(NLUKI_PRIMARYSYSROOT)/lib64/
	ln -sfv ../lib/ld-linux-x86-64.so.2 $(NLUKI_PRIMARYSYSROOT)/lib64
$(NLUKI_PRIMARYSYSROOT)/lib64/ld-lsb-x86-64.so.3:
	mkdir -p $(NLUKI_PRIMARYSYSROOT)/ib64/
	ln -sfv ../lib/ld-linux-x86-64.so.2 $(NLUKI_PRIMARYSYSROOT)/lib64/ld-lsb-x86-64.so.3

nluki-lsb-x86_64 = $(NLUKI_PRIMARYSYSROOT)/lib64/ld-linux-x86-64.so.2 $(NLUKI_PRIMARYSYSROOT)/lib64/ld-lsb-x86-64.so.3
endif