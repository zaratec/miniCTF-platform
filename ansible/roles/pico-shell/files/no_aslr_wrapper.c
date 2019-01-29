#include <stdlib.h>
#include <sys/personality.h>

int main(int argc, char *argv[], char *envp[]) {
    personality(ADDR_NO_RANDOMIZE);
    argv[0] = BINARY_PATH;
    execve(argv[0], argv, envp);
}
