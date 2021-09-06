#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>
#include <errno.h>

#define MAX_RESOURCES 5

int available_resources = MAX_RESOURCES;

pthread_mutex_t mtx;

int decrease_count(int count){

    pthread_mutex_lock(&mtx);
    if(available_resources < count){
        pthread_mutex_unlock(&mtx);
        return -1;
    }
    else{
        available_resources -= count;
        printf("Got %d resources %d remaining\n", count, available_resources);
    }
    pthread_mutex_unlock(&mtx);
        
    return 1;

}

int increase_count(int count){
    
    pthread_mutex_lock(&mtx);
    available_resources += count;
    printf("Released %d resources %d remaining\n", count, available_resources);
    pthread_mutex_unlock(&mtx);

    return 0;
}

void* f(void* v){

    int * res = (int *)v;
    int ret_val = decrease_count(*res);
    //increase_count(res); 
    //daca lasam doar asa e posibil ca in decrease_count sa nu se faca
    //decrease cu numarul de resurse pentru ca e prea mare
    //dar indiferent de ce se intampla acolo se da increase in increase_count
    //si la final am termina cu un numar de resurse mai mare decat 5
    //deci ar trebui dam increase doar daca s-a dat decrease in decrease_count
    if(ret_val == 1)
        increase_count(*res);
    free(res);
    return NULL;

}

int main(){

    if(pthread_mutex_init(&mtx, NULL)){
        perror(NULL);
        return errno;
    }

    srand(time(0)); //seed
    int nr_threads = rand()%20 + 1; //random in range 1 - 20

    pthread_t* threads = (pthread_t *)malloc(sizeof(pthread_t)*nr_threads);

    for(int i=0;i<nr_threads;i++){
        //fiecarui thread ii dam un nr random (< max) de resurse (>0)
        int random = rand() % MAX_RESOURCES + 1;
        int* res = (int *)malloc(sizeof(int *));
        * res = random;
        if(pthread_create(&threads[i], NULL, f, res)){
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

    return 0;
}