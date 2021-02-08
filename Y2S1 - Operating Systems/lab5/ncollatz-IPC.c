#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <unistd.h>
#include <errno.h>
#include <sys/wait.h>
#include <string.h>
//ncollatz cu ipc (inter process communication) prin shared memory
//e nev de flag ul -lrt la compilare
int main(int argc, char* argv[])
{
    int shm_fd = -1;
    char* shm_name = "ncollatz";
    char* shm_ptr; //il vom folosi la mmap
    shm_fd = shm_open(shm_name, O_CREAT | O_RDWR, S_IRUSR | S_IWUSR);
    //creeaza o mem partajata (sau deschide) cu numele "ncollatz"
    if(shm_fd == -1)
    { 
        perror("Eroare la shm_open");
        return errno;
    }
    int page_size = getpagesize(); //pagesize = 4096 la mine 
    int total_size = argc*getpagesize();
    //vom aloca total_size memorie
    //deci fiecare copil are la dispozitie o pagina in care sa scrie rezultatul
    int ret;
    ret = ftruncate(shm_fd, total_size); 
    //definim dimensiunea memoriei partajate care va fi egala cu total_size
    if(ret == -1)
    {
        perror("Eroare la ftruncate");
        shm_unlink(shm_name); //stergem obiectul creat/deschis cu shm_open
        return errno;
    }
    printf("Sarting parent %d\n",getpid());
    for(int i=1;i<argc;i++) //pentru fiecare numar dat
    {
        pid_t copil = fork(); //facem un copil care sa rezolve fiecare problema
        if(copil < 0)
        {
            perror("Eroare la fork");
            return errno;
        }
        else if(copil == 0)
        {
            //cod doar pt copil
            //trebuie sa ii mapam procesului copil partea din memoria partajata
            //in care sa scrie rezultatul
            shm_ptr = mmap(NULL, page_size, PROT_WRITE, MAP_SHARED, shm_fd, (i-1)*page_size);
            //argumentele pt mmap explicate in pdf
            //inseamna ca daca avem copilul i, i se va da o memorie de dimensiunea page_size
            //si i se va mapa memoria de la (i-1)*page_size la i*page_size, sper ca am zis bine
            if(shm_ptr == MAP_FAILED)
            {
                perror("Eroare la mmap din copil");
                shm_unlink(shm_name);
                return errno;
            }
            int n = atoi(argv[i]);
            int car_scrise = sprintf(shm_ptr,"%d: ", n); //returneaza numarul de caractere scrise
            shm_ptr += car_scrise; //mutam pointerul
            while(n != 1)
            {
                car_scrise = sprintf(shm_ptr, "%d ", n);
                shm_ptr += car_scrise;
                if(n%2)
                {
                    n=3*n+1;
                }
                else
                {
                    n/=2;
                }
            }
            car_scrise = sprintf(shm_ptr, "%d\n ", n);
            shm_ptr += car_scrise;
            printf("Done. Parent = %d, Me = %d\n", getppid(), getpid());
            munmap(shm_ptr, page_size); 
            exit(0); //normal process termination
            //trebuie sa terminam procesul pentru ca altfel continua in for
        }
    }
    for(int i=1;i<argc;i++)
    {
        //parintele asteapta terminarea executiei fiecarui copil
        wait(NULL);
    }
    //acum trebuie sa incarcam memoria partajata in memoria virtuala a procesului
    //(sau spatiul procesului) cu functia mmap
    //trebuie sa facem asta pentru a citi usor rezultatul
    //incarcam pe rand "bucatile" fiecarui proces copil
    //facem "pe bucati" pentru ca daca incarcam cu totul, la scriere
    //se va opri dupa rezolvarea primului numar
    printf("\n");
    for(int i=1;i<argc;i++)
    {
        shm_ptr = mmap(NULL, page_size, PROT_READ, MAP_SHARED, shm_fd, (i-1)*page_size);
        if(shm_ptr == MAP_FAILED)
        {
            perror("Eroare la mmap din parinte");
            shm_unlink(shm_name);
            return errno;
        }
        printf("%s\n", shm_ptr);
        munmap(shm_ptr, page_size);
    }
    printf("Done. Parent = %d, Me = %d\n", getppid(), getpid());
    shm_unlink(shm_name);
    return 0;
}