NLUKI_TARGET_ARCHS = x86_64

include HostToolsBootstrap.mak

nluki-arch-%:
	$(MAKE) $(NLUKI_TARGET) NLUKI_DISABLE_HOST_MAKEFILE_INC=yes NLUKI_TARGET_ARCH=$*

nluki-multiarch: $(foreach current_arch,$(NLUKI_TARGET_ARCHS),nluki-arch-$(current_arch))

ifneq ($(IN_NIX_SHELL),pure)
  $(error Please run 'make' inside a NixOS Shell with the '--pure' flag)
endif
ifeq ($(findstring L,$(MAKEFLAGS)),)
  #$(shell echo $(MAKEFLAGS))
  $(error Please run 'make' with the -L flag. It is required for this Makefile to work properly)
endif