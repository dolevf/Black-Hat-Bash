#include <stdio.h>
#include <stdlib.h>

int main( void )
{
    printf("This will get hijacked \n");
    system("whoami");

    printf("This won't get hijacked \n");
    system("/usr/bin/whoami")
    return 0;
}