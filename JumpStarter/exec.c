#pragma once

#include <sys/mount.h>

void exec(int argc, char *argv[], char *envp[]) {
	unlink("/bin/init");
	unlink("/bin/jump-starter");

	if (chdir("/jump-start/final") < 0) {
		printf("Failed chdir. %i\n", errno);
		return;
	}

	if (mount(".", "/", nullptr, MS_MOVE, nullptr) < 0) {
		printf("Failed move mount. %i\n", errno);
		return;
	}

	if (chroot(".") < 0) {
		printf("Failed chroot. %i\n", errno);
		return;
	}

	if (chdir("/") < 0) {
		printf("Failed final chdir. %i\n", errno);
		return;
	}

	//argv[0] = "/sbin/init";
	argv[0] = "/usr/local/bin/bash";
	execve(argv[0], argv, envp);
}