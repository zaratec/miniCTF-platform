#include <stdio.h>
#include <stdlib.h>

char input_buf[1024];
char *secret = "test\n";

void be_nice_to_people(){
    gid_t gid = getegid();
    setresgid(gid, gid, gid);
}

int main(){
    be_nice_to_people();
    puts("Welcome to my echo server!");
    fflush(stdout);
    while(fgets(input_buf, 1024, stdin) > 0){
        if (!strcmp(input_buf, secret)){
            puts("You found the secret input! Have a shell:");
            fflush(stdout);
            system("/bin/sh");
        }
        printf("%s", input_buf);
        fflush(stdout);
    }
}
