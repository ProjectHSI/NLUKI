let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-26.05";
  pkgs = import nixpkgs { config = {}; overlays = []; };
in

pkgs.mkShell {
	packages = with pkgs; [
    fakeroot
		gnumake
		gcc-unwrapped
		binutils
		gmp
		mpfr
		xz
		cpio
		squashfsTools
		texinfo
		elfutils
		podman
		perl
		bison
		flex
		pkg-config
		guile
		ncurses
		expat
		python314
		babeltrace
		libipt
		gettext
		gnused
		coreutils
		isl
		expect
		dejagnu
		findutils
		gnum4
		file
		diffutils
		gawk
		gnugrep
		gzip
		gnupatch
		gnutar
		cmake
		autoconf
		automake
		git
		gperf
		wget
		bc
		libopcodes
		openssl_4_0
		rsync
		hostname
    wget
	];

	NLUKI_INCLUDE_NIX_CPP_LIB = ''-isystem ${pkgs.gcc-unwrapped.out.outPath}/include/c++/15.2.0 -isystem ${pkgs.gcc-unwrapped.out.outPath}/include/c++/15.2.0/x86_64-unknown-linux-gnu/'';
	# ${pkgs.gcc-unwrapped.out.outPath}/include/c++/15.2.0:${pkgs.gcc-unwrapped.out.outPath}/include/c++/15.2.0/x86_64-unknown-linux-gnu/:
	CPATH = '''';
	C_INCLUDE_PATH = ''${pkgs.gcc-unwrapped.out.outPath}/lib/gcc/x86_64-unknown-linux-gnu/15.2.0/include:${pkgs.gcc-unwrapped.out.outPath}/include:${pkgs.gcc-unwrapped.out.outPath}/lib/gcc/x86_64-unknown-linux-gnu/15.2.0/include-fixed:${pkgs.ncurses.dev.outPath}/include:${pkgs.glibc.dev.outPath}/include:${pkgs.gmp.dev.outPath}/include:${pkgs.mpfr.dev.outPath}/include:${pkgs.elfutils.dev.outPath}/include:${pkgs.openssl_4_0.dev.outPath}/include'';
	CPLUS_INCLUDE_PATH = ''${pkgs.gcc-unwrapped.out.outPath}/include/c++/15.2.0:${pkgs.gcc-unwrapped.out.outPath}/include/c++/15.2.0/x86_64-unknown-linux-gnu/:${pkgs.gcc-unwrapped.out.outPath}/lib/gcc/x86_64-unknown-linux-gnu/15.2.0/include:${pkgs.gcc-unwrapped.out.outPath}/include:${pkgs.gcc-unwrapped.out.outPath}/lib/gcc/x86_64-unknown-linux-gnu/15.2.0/include-fixed:${pkgs.ncurses.dev.outPath}/include:${pkgs.glibc.dev.outPath}/include:${pkgs.gmp.dev.outPath}/include:${pkgs.mpfr.dev.outPath}/include:${pkgs.elfutils.dev.outPath}/include:${pkgs.openssl_4_0.dev.outPath}/include'';
	LIBRARY_PATH = ''${pkgs.gcc-unwrapped.lib.outPath}/lib/:${pkgs.gcc-unwrapped.out.outPath}/lib/:${pkgs.glibc.out.outPath}/lib:${pkgs.binutils-unwrapped.lib.outPath}/lib/:${pkgs.gmp.out.outPath}/lib:${pkgs.mpfr.out.outPath}/lib:${pkgs.elfutils.out.outPath}/lib:${pkgs.openssl_4_0.bin.outPath}/lib'';
	LD_LIBRARY_PATH = ''${pkgs.openssl_4_0.out.outPath}/lib'';
}