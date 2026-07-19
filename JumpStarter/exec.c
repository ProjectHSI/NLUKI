#pragma once

#include <sys/mount.h>
#include <sys/types.h>
#include <dirent.h>

#define PERFORM_DIR_LIST_DIAGNOSTIC true

void performListDiag(const char *loc) {
	printf("[DIAG] reading dir...\n");
	DIR *dir = opendir(loc);
	struct dirent *currentReadDir = NULL;
	while (currentReadDir = readdir(dir)) {
		printf("%s\n", currentReadDir->d_name);
	}
	closedir(dir);
	printf("[DIAG] done...\n");
}

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

#if 0
	if (PERFORM_DIR_LIST_DIAGNOSTIC) {
		performListDiag("/");
		performListDiag("/usr");
		performListDiag("/usr/local");
		performListDiag("/usr/local/bin");
	}
#endif

	//argv[0] = "/sbin/init";
	argv[0] = "/usr/local/bin/bash";
	execve(argv[0], argv, envp);

	printf("Failed final exec. %i\n", errno);
}