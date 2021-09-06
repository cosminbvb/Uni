#include <stdio.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <unistd.h>
#include <errno.h>
int main()
{
    int shm_fd = -1;
    int ret;
    char sir[8];
    char* adresa_fisier = NULL;
    shm_fd = shm_open("lab5", O_RDWR, 0);
    if(shm_fd==-1)
    { 
        puts("nu am putut deschide sau nu exista mem partajata 'lab5' ");
        return -1;
    }
    else
    {
        puts("am deschis mem partajata 'lab5'");
        /*
        ret = read(shm_fd, sir, 8);
        if (ret == -1)
        {
            printf("read: %d\n", errno);
        }
        else
        {
            printf("%s\n", sir);
        }
        */
        adresa_fisier = mmap(NULL, 8, PROT_READ, MAP_SHARED, shm_fd, 0);
        printf("%s\n", adresa_fisier);
        shm_unlink("lab5");
    }
    
    return 0;
}