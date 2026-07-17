# --- Sysroot LSB-Compliance ---
# -- i{3,6}86 --
$(NLUKI_TARGET_CLASSIC_SYSROOTS)/sp/lib/ld-lsb.so.3:
	mkdir -p $(NLUKI_TARGET_CLASSIC_SYSROOTS)/sp/lib/
	ln -sfv ld-linux.so.2 $(NLUKI_TARGET_CLASSIC_SYSROOTS)/sp/lib/ld-lsb.so.3

nluki-lsb-i368 = $(NLUKI_TARGET_CLASSIC_SYSROOTS)/sp/lib/ld-lsb.so.3
nluki-lsb-i868 = $(NLUKI_TARGET_CLASSIC_SYSROOTS)/sp/lib/ld-lsb.so.3

# -- x86_64 --
$(NLUKI_TARGET_CLASSIC_SYSROOTS)/sp/lib64/ld-linux-x86-64.so.2:
	mkdir -p $(NLUKI_TARGET_CLASSIC_SYSROOTS)/sp/lib64/
	ln -sfv ../lib/ld-linux-x86-64.so.2 $(NLUKI_TARGET_CLASSIC_SYSROOTS)/sp/lib64
$(NLUKI_TARGET_CLASSIC_SYSROOTS)/sp/lib64/ld-lsb-x86-64.so.3:
	mkdir -p $(NLUKI_TARGET_CLASSIC_SYSROOTS)/sp/lib64/
	ln -sfv ../lib/ld-linux-x86-64.so.2 $(NLUKI_TARGET_CLASSIC_SYSROOTS)/sp/lib64/ld-lsb-x86-64.so.3

nluki-lsb-x86_64 = $(NLUKI_TARGET_CLASSIC_SYSROOTS)/sp/lib64/ld-linux-x86-64.so.2 $(NLUKI_TARGET_CLASSIC_SYSROOTS)/sp/lib64/ld-lsb-x86-64.so.3