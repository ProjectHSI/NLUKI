#pragma once

#include <sys/stat.h>
#include <sys/mount.h>
#include <unistd.h>
#include <errno.h>
#include <linux/loop.h>

#include "globals.h"

const char *jumpStartSquashFsFile = "/jump-start.squashfs";

/*int allocateLoop() {
	int loopControlFd = open("/dev/loop-control", O_RDWR); 
	if (loopControlFd < 0) {
		printf("Failed to open loop-control. %i\n", errno);
		return -1;
	}

	int newLoopNumber = ioctl(loopControlFd, LOOP_CTL_GET_FREE, nullptr);
	close(loopControlFd);

	// For errors after this, the Kernel will reboot anyway, so no need to cleanup.

	if (newLoopNumber < 0) {
		printf("Could not create new loop. %i", errno);
		return -1;
	}

	return newLoopNumber;
}*/

int initLoopDevice() {
	int fileFd = open(jumpStartSquashFsFile, O_RDONLY);
	if (fileFd < 0) {
		printf("Could not open jump-start file. %i\n", errno);
		return -1;
	}

	unlink("/squashfs-loop");
	if (mknod("/squashfs-loop", S_IFBLK | 0660, makedev(7, 15)) < 0 && errno != 17) {
		printf("Could not create loop device. %i\n", errno);
		return -1;
	}

	/*int loopNumber = allocateLoop();
	if (loopNumber < 0) {
		return -1;
	}

	char loopDevicePath[65];
	int snprintf_res = snprintf(loopDevicePath, sizeof(loopDevicePath), "/dev/loop%d", loopNumber);
	if (snprintf_res >= sizeof(loopDevicePath) - 1) {
		printf("Could not get created loop device. snprintf returned an unexpected value. %i/%i\n", snprintf_res, sizeof(loopDevicePath) - 1);
		close(fileFd);
		return false;
	}*/

	//int loopDevFd = open(loopDevicePath, O_RDONLY); 
	int loopDevFd = open("/squashfs-loop", O_RDONLY); 
	if (loopDevFd < 0) {
		printf("Failed to open loop device. %i\n", errno);
		close(fileFd);
		return -1;
	}

	if (ioctl(loopDevFd, LOOP_SET_FD, (void *)fileFd) < 0) {
		printf("Failed to set loop FD. %i\n", errno);
		close(loopDevFd);
		close(fileFd);
		return -1;
	}
	
	close(loopDevFd);
	close(fileFd);

	return 0x7F;
}

bool mountCpioInInitRamFs() {
	printf("Creating dir for mount...\n");
	int mkdir_res = mkdir("/jump-start/mount/", 0xFFFF);
	if (mkdir_res < 0 && errno != 17) {
		printf("Could not create mount point. %i\n", errno);
		return false;
	}

	int loopNumber = initLoopDevice();
	if (loopNumber < 0) {
		return false;
	}

	/*char loopDevicePath[65];
	int snprintf_res = snprintf(loopDevicePath, sizeof(loopDevicePath), "/dev/loop%d", loopNumber);
	if (snprintf_res >= sizeof(loopDevicePath) - 1) {
		printf("Could not get created loop device. snprintf returned an unexpected value. %i/%i\n", snprintf_res, sizeof(loopDevicePath) - 1);
		return false;
	}*/

	if (mount("/squashfs-loop", jumpStartMountPoint, "squashfs", MS_RDONLY, nullptr) < 0) {
		printf("Could not mount. %i\n", errno);
		return false;
	}

	return true;
}

void doMountCpioInInitRamFsEntryPoint() {
	mountCpioInInitRamFs();

	// 
}

bool isMountCpioInInitRamFsEntryPointApplicable() {
	printf("Checking if jump-start.squashfs exists...\n");
	struct stat temp_stat;
	return stat(jumpStartSquashFsFile, &temp_stat) >= 0;
}