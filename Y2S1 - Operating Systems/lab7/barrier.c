#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>
#include <errno.h>
#include <semaphore.h>

pthread_mutex_t mtx; //pentru ca numara cate threaduri au ajuns la bariera
sem_t sem;

int nr = 0;
int nr_threads;

void barrier_point(){
    
    pthread_mutex_lock(&mtx);
    nr++;
    if(nr<nr_threads){ //daca mai sunt thread uri de venit, asteapta
        pthread_mutex_unlock(&mtx);
        sem_wait(&sem);
    }
    else{
        pthread_mutex_unlock(&mtx);
        //daca au venit toate, le "trezim" pe toate si le lasam sa se execute
        for(int i=0; i<nr_threads; i++){
            sem_post(&sem);
        }
    }
    /*
    man:
       sem_wait()  decrements  (locks)  the semaphore pointed to by sem.  If the semaphore's value is
       greater than zero, then the decrement proceeds, and the function returns, immediately.  If the
       semaphore  currently has the value zero, then the call blocks until either it becomes possible
       to perform the decrement (i.e., the semaphore value rises above zero), or a signal handler in‐
       terrupts the call.

       sem_post()  increments  (unlocks)  the  semaphore pointed to by sem.  If the semaphore's value
       consequently becomes  greater  than  zero,  then  another  process  or  thread  blocked  in  a
       sem_wait(3) call will be woken up and proceed to lock the semaphore.
    */
}

void * tfun (void *v){

    int *tid = (int *)v;
    printf("%d reached the barrier\n", *tid);
    barrier_point();
    printf("%d passed the barrier\n", *tid);

    free(tid);
    return NULL;
}

int main(){

    srand(time(0)); //seed
    nr_threads = rand()%19 + 2; //random in range 2 - 20

    pthread_t* threads = (pthread_t *)malloc(sizeof(pthread_t)*nr_threads);

    if(pthread_mutex_init(&mtx, NULL)){
        perror(NULL);
        return errno;
    }
    if(sem_init(&sem, 0, 0)){ //initializam semaforul cu 0, pentru a opri toate thread urile
        perror(NULL);
        return errno;
    }

    for(int i=0;i<nr_threads;i++){
        int* nr = (int *)malloc(sizeof(int *));
        * nr = i;
        if(pthread_create(&threads[i], NULL, tfun, nr)){
            perror(NULL);
            return errno;
        }
    }
    
    for(int i=0; i<nr_threads;i++){
        if (pthread_join(threads[i], NULL)){
            perror(NULL);
            return errno;
        }
    }

    free(threads);

    pthread_mutex_destroy(&mtx);
    sem_destroy(&sem);

    
}