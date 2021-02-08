#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>
#include <errno.h>

#define NR_THREADS 100
#define MAX_INCREMENT 10000

int count = 0;

pthread_mutex_t mtx;

void* tfun(void *v){
    int i=0;
    for(i=0; i<MAX_INCREMENT;i++){
        pthread_mutex_lock(&mtx);
        count++; //critical section
        pthread_mutex_unlock(&mtx);
    }
    return NULL;
}

int main(){
    
    pthread_t thr[NR_THREADS];

    if(pthread_mutex_init(&mtx, NULL)){
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

    pthread_mutex_destroy(&mtx);

    return 0;
}