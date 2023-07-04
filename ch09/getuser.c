#include <stdio.h>
#include <stdlib.h>

int main( void )
{
    // This has the potential to get hijacked 
    system("whoami");

    // This should not be possible to hijack
    system("/usr/bin/whoami");
    
    return 0;
}