#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>
#include <errno.h>
#include <semaphore.h>

#define NR_THREADS 100
#define MAX_INCREMENT 10000

int count = 0;

sem_t sem;

void* tfun(void *v){
    int i=0;
    for(i=0; i<MAX_INCREMENT;i++){
        if(sem_wait(&sem)){
            perror(NULL);
            return errno;
        }
        count++; //critical section
        if(sem_post(&sem)){
            perror(NULL);
            return errno;
        }
    }
    return NULL;
}

int main(){
    
    pthread_t thr[NR_THREADS];
    
    //OBS un mutex e un semafor cu s = 1

    int S = 1;
    if(sem_init(&sem, 0, S)){
        perror(NULL);
        return errno;
    }

    for(int i=0;i<NR_THREADS;i++){
        if(pthread_create(&thr[i], NULL, tfun, NULL)){
            perror(NULL);
            return errno;
        }
    }

    for(int i = 0; i< NR_THREADS;i++){
        if(pthread_join(thr[i],NULL)){
            perror(NULL);
            return errno;
        }
    }

    printf("Count este %d\n", count);

    sem_destroy(&sem);

    return 0;
}