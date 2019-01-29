#include <stdio.h>
#include <stdlib.h>

char input_buf[1024];
char *secret = "{{secret}}\n";

int main(){
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
