# --- Sysroot LSB-Compliance ---
# -- i{3,6}86 --
ifneq ($(NLUKI_TARGET_WORD_SIZE),32) 
$(NLUKI_PRIMARYSYSROOT)/lib/ld-lsb.so.3:
	mkdir -p $(NLUKI_PRIMARYSYSROOT)/lib/
	ln -sfv ld-linux.so.2 $(NLUKI_PRIMARYSYSROOT)/lib/ld-lsb.so.3

nluki-lsb := $(NLUKI_PRIMARYSYSROOT)/lib/ld-lsb.so.3
endif

# -- x86_64 --
ifeq ($(NLUKI_TARGET_WORD_SIZE),64)
$(NLUKI_PRIMARYSYSROOT)/usr/lib64/ld-linux-x86-64.so.2:
	mkdir -p $(NLUKI_PRIMARYSYSROOT)/usr/lib64/
	ln -sfv /usr/lib64/ld-linux-x86-64.so.2 $(NLUKI_PRIMARYSYSROOT)/usr/lib64
$(NLUKI_PRIMARYSYSROOT)/usr/lib64/ld-lsb-x86-64.so.3:
	mkdir -p $(NLUKI_PRIMARYSYSROOT)/usr/lib64/
	ln -sfv /usr/lib64/ld-linux-x86-64.so.2 $(NLUKI_PRIMARYSYSROOT)/usr/lib64/ld-lsb-x86-64.so.3

nluki-lsb := $(NLUKI_PRIMARYSYSROOT)/usr/lib64/ld-linux-x86-64.so.2 $(NLUKI_PRIMARYSYSROOT)/usr/lib64/ld-lsb-x86-64.so.3
endif