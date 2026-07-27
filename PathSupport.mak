NLUKI_PATH_BASE = $1/bin:$1/usr/bin:$1/usr/local/bin:$1/usr/share/bin
NLUKI_LIBRARY_PATH_BASE = $1/lib:$1/lib64:$1/usr/lib:$1/usr/lib64:$1/usr/local/lib:$1/usr/local/lib64:$1/usr/share/lib:$1/usr/share/lib64:$1/lib/gcc/$(NLUKI_GCC_ARCH)-pc-linux/17.0.0:$1/bin
NLUKI_CPATH_BASE = $1/include:$1/usr/include:$1/usr/local/include
NLUKI_EXTRA_TARGET_CPATH_BASE = $1/lib/gcc/$(NLUKI_GCC_ARCH)-pc-linux-gnu/17.0.0/include:$1/lib/gcc/$(NLUKI_GCC_ARCH)-pc-linux-gnu/17.0.0/include-fixed:$1/usr/lib/klibc/include:$1/usr/lib/klibc/include/bits$(NLUKI_TARGET_WORD_SIZE):$1/usr/lib/klibc/include/arch/$(NLUKI_KERNEL_ARCH)
NLUKI_EXTRA_HOST_CPATH_BASE = $1/lib/gcc/$(NLUKI_HOST_TRIPLET)/17.0.0/include:$1/lib/gcc/$(NLUKI_HOST_TRIPLET)/17.0.0/include-fixed
NLUKI_EXTRA_CPP_CPATH_BASE = $1/include/c++/17.0.0:$1/include/c++/17.0.0/backward
NLUKI_EXTRA_HOST_CPP_CPATH_BASE = $1/include/c++/17.0.0/$(NLUKI_HOST_TRIPLET)
NLUKI_EXTRA_TARGET_CPP_CPATH_BASE = $1/include/c++/17.0.0/$(NLUKI_GCC_ARCH)-pc-linux-gnu