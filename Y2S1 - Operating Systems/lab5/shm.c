#include <stdio.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
int main()
{
    int shm_fd = -1;
    char* adresa_fisier;
    shm_fd = shm_open("lab5", O_CREAT | O_RDWR, S_IRUSR | S_IWUSR);
    //creeaza o mem partajata (sau deschide) cu numele "lab5"
    if(shm_fd == -1)
    { 
        puts("nu merge");
        return -1;
    }
    puts("Am creeat/deja exista memoria partajata");
    int ret;
    ret = ftruncate(shm_fd, 8);
    if(ret == -1)
    {
        printf("ftruncate: %d\n", errno);
        return -1;
    }
    /*
    ret = write(shm_fd, "1234567\0", 8);
    if(ret == -1)
    {
        printf("write: %d\n", errno);
        return -1;
    }
    */

    //int a = getpagesize(); //4096

    adresa_fisier = mmap(NULL, 8, PROT_WRITE, MAP_SHARED, shm_fd, 0);
    memcpy(adresa_fisier, "1234567\0", 8);
    munmap(adresa_fisier, 8);

    return 0;
}