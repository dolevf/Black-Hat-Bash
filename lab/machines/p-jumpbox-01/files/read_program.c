#include <stdio.h>
#include <stdlib.h>
#include <string.h>
 
// Driver code  
int main( int argc, char *argv[] )
{

    printf("This program reads file from the filesystem!\n");

    if( argc != 2 ) {
      printf("Please provide a path to a file you want to read.\n");
      exit(1);
    }
    
    FILE* ptr;
    char ch;
 
    ptr = fopen(argv[1], "r");
 
    if (NULL == ptr) {
        printf("file can't be opened \n");
        exit(1);
    }
 
    do {
        ch = fgetc(ptr);
        printf("%c", ch);
 
    } while (ch != EOF);
 
    fclose(ptr);
    return 0;
}