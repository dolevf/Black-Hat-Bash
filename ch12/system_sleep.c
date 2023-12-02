#include <stdio.h>
#include <stdlib.h>

int main(int argc,char* argv[]){
    int status;
    status = system("sleep 100");
    return status;
}