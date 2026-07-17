#pragma once

#include <errno.h>
#include <sys/mount.h>
#include <sys/stat.h>

const char *tmpFsDir = "/jump-start/tmpfs";
const char *upperMountDir = "/jump-start/tmpfs/upper";
const char *workMountDir = "/jump-start/tmpfs/work";
const char *finalMountDir = "/jump-start/final";

bool createTmpFs() {
	int mkdirRes = mkdir(tmpFsDir, 0xFFFF);
	if (mkdirRes < 0 && errno != 17) {
		printf("Unable to create tmpfs mountpoint. %i\n", errno);
		return false;
	}

	int mountRes = mount("tmpfs", tmpFsDir, "tmpfs", 0, "");
	if (mountRes < 0) {
		printf("Unable to create tmpfs. %i\n", errno);
		return false;
	}

	return true;
}

bool createOverlayFs() {
	int mkdirRes = mkdir(finalMountDir, 0xFFFF);
	if (mkdirRes < 0 && errno != 17) {
		printf("Unable to create overlayfs mountpoint. %i\n", errno);
		return false;
	}

	int mkdirUpperRes = mkdir(upperMountDir, 0xFFFF);
	if (mkdirUpperRes < 0 && errno != 17) {
		printf("Unable to create overlayfs upperdir. %i\n", errno);
		return false;
	}

	int mkdirWorkRes = mkdir(workMountDir, 0xFFFF);
	if (mkdirWorkRes < 0 && errno != 17) {
		printf("Unable to create overlayfs workdir. %i\n", errno);
		return false;
	}

	int mountRes = mount("overlay", finalMountDir, "overlay", 0, "lowerdir=/jump-start/mount,upperdir=/jump-start/tmpfs/upper,workdir=/jump-start/tmpfs/work");
	if (mountRes < 0) {
		printf("Unable to create overlayfs. %i\n", errno);
		return false;
	}

	return true;
}

bool makeSquashFsRw() {
	if (!createTmpFs()) {
		return false;
	}

	if (!createOverlayFs()) {
		return false;
	}

	return true;
}