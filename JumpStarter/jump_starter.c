#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <sys/mount.h>
#include <sys/stat.h>
#include <unistd.h>

#include "globals.h"

typedef enum {
	MOUNT_CPIO_IN_INITRAMFS = 1
} BOOT_METHOD;

#include "mount_cpio_in_initramfs_entrypoint.c"

BOOT_METHOD determineNlukiEntryPoint() {
	printf("Determining boot method...\n");
	BOOT_METHOD currentBootMethod = 0;

	if (isMountCpioInInitRamFsEntryPointApplicable()) {
		currentBootMethod = MOUNT_CPIO_IN_INITRAMFS;
	}
}

bool executeNlukiEntryPoint() {
	switch (determineNlukiEntryPoint()) {
		case MOUNT_CPIO_IN_INITRAMFS:
			printf("Booting from CPIO in initramfs...\n");
			doMountCpioInInitRamFsEntryPoint();
			return true;
		default:
			printf("Could not boot from any boot method.\n");
			return false;
	}
}

#include "rwsquashfs.c"
#include "exec.c"

int main(int argc, char *argv[], char *envp[]) {
	printf("[NLUKI Jump-Starter]\n\n");

	if (getpid() != 1) {
		printf("PID != 1, aborting.\n");
		return 0x1;
		//while(1);
	}

	int mkdirRes = mkdir("/jump-start/", 0xFFFF);
	if (mkdirRes < 0 && errno != 17) {
		printf("Unable to create scratch space. %i\n", errno);
		return 0x2;
		//while(1);
	}

	if (!executeNlukiEntryPoint()) return 0x4;
	if (!makeSquashFsRw()) return 0x8;

	exec(argc, argv, envp);

	return 0xF;
}