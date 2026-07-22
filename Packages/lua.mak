NLUKI_LUA_ENV := $(NLUKI_AUTO_TARGET_PRIMARYSYSROOT_PATH); $(NLUKI_AUTO_TARGET_PRIMARYSYSROOT_LIBRARY_PATH); $(NLUKI_AUTO_TARGET_PRIMARYSYSROOT_CPATH) \
	$(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_LIBRARY_PATH,crosssysroot); $(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_CPATH,crosssysroot); $(call NLUKI_AUTO_TARGET_CLASSIC_SYSROOT_PATH,crosssysroot); \
	$(call NLUKI_AUTO_HOST_CLASSIC_SYSROOT_PATH,hostsysroot)

$(NLUKI_BUILDROOT)/lua-install.stamp: $(NLUKI_BUILDROOT)/lua-build.stamp
	@mkdir -p $(NLUKI_PRIMARYSYSROOT)
	@mkdir -p $(NLUKI_PRIMARYSYSROOT)/usr/bin
	@mkdir -p $(NLUKI_PRIMARYSYSROOT)/usr/lib
	@mkdir -p $(NLUKI_PRIMARYSYSROOT)/usr/include/lua5.4/

# FIXME: When Nixpkgs updates their CMake, go to version 5.5.1
	@echo -e \\tCOPY Packages/lua/\* /
	@cp -rf $(MKFILE_DIR)/Packages/lua/* $(NLUKI_PRIMARYSYSROOT);
	@echo -e \\tINSTALL lua\(.elf\) /usr/bin/lua5.4
	@install -T $(NLUKI_TARGET_BUILDROOT)/lua/lua $(NLUKI_PRIMARYSYSROOT)/usr/bin/lua5.4
	@echo -e \\tINSTALL liblua.a /usr/lib/liblua5.4.a
	@install $(NLUKI_TARGET_BUILDROOT)/lua/liblua.a $(NLUKI_PRIMARYSYSROOT)/usr/lib/liblua5.4.a
	@echo -e \\tINSTALL Target/BuildRoot/lua.h Target/BuildRoot/luaconf.h Target/BuildRoot/lualib.h Target/BuildRoot/lauxlib.h /usr/include/lua5.4
	@install $(NLUKI_TARGET_BUILDROOT)/lua/lua.h $(NLUKI_TARGET_BUILDROOT)/lua/luaconf.h $(NLUKI_TARGET_BUILDROOT)/lua/lualib.h $(NLUKI_TARGET_BUILDROOT)/lua/lauxlib.h $(NLUKI_PRIMARYSYSROOT)/usr/include/lua5.4/
	@echo -e \\tTOUCH lua-install.stamp
	@touch $(NLUKI_BUILDROOT)/lua-install.stamp

$(NLUKI_PRIMARYSYSROOT): $(NLUKI_BUILDROOT)/lua-install.stamp

lua-install: $(NLUKI_BUILDROOT)/lua-install.stamp
.PHONY : lua-install

$(NLUKI_BUILDROOT)/lua-build.stamp: | $(NLUKI_TARGET_BUILDROOT)/lua
	@echo -e \\tDESCEND Target/BuildRoot/lua
	@$(NLUKI_LUA_ENV); cd $(NLUKI_TARGET_BUILDROOT)/lua; $(MAKE) CC=$(NLUKI_ALTERNATIVE_TARGET_ARCH)-pc-linux-gcc CXX=$(NLUKI_ALTERNATIVE_TARGET_ARCH)-pc-linux-g++ MYLIBS="-ltinfo -lreadline -lncurses -lhistory"
	@echo -e \\tTOUCH lua-build.stamp
	@touch $(NLUKI_BUILDROOT)/lua-build.stamp

lua-build: $(NLUKI_BUILDROOT)/lua-build.stamp
.PHONY : lua-build

$(NLUKI_TARGET_BUILDROOT)/lua: $(NLUKI_BUILDROOT)/readline-install.stamp $(MKFILE_DIR)/Submodules/lua
	@echo -e \\tCLEAN Target/BuildRoot/lua
	@rm -rf $(NLUKI_TARGET_BUILDROOT)/lua
	@echo -e \\tMKDIR Target/BuildRoot/lua
	@mkdir -p $(NLUKI_TARGET_BUILDROOT)/lua
	@echo -e \\tCOPY Submodules/lua/\* Target/BuildRoot/lua
	@cp -rf $(MKFILE_DIR)/Submodules/lua/* $(NLUKI_TARGET_BUILDROOT)/lua