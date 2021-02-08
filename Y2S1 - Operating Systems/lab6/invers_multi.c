#include <pthread.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
//vrem sa facem acelasi lucru ca la 1-invers dar pentru mai multe cuvinte
//si vom da ficare cuvant cate unui thread

void * invers(void *v){
    char *sir = (char *)v; //cast
    char *sir_inv = (char *)malloc(strlen(sir)+1); //alocam sirul in care vom scrie invers
    for(int i=0;i<strlen(sir);i++){
        sir_inv[strlen(sir)-1-i] = sir[i];
    }
    sir_inv[strlen(sir)]='\0';
    return sir_inv;
}

int main(int argc, char **argv){
    if(argc == 1){
        printf("At least 1 arg");
        return -1;
    }
    pthread_t* thread_list = (pthread_t*)malloc(argc*sizeof(pthread_t));
    for(int i=1; i<argc; i++){
        if (pthread_create(&thread_list[i-1], NULL, invers, argv[i])){
            perror(NULL);
            return errno;
        }
    }
    for(int i=0; i<argc-1; i++){
        void* result;
        if (pthread_join(thread_list[i], &result)){
            perror(NULL);
            return errno;
        }
        printf("%s\n", (char *)result); //afisam rezultatul
        free(result);
    }
    free(thread_list);
    return 0;
}
/*
ex:
./invers_multi ceva idk habarnam hello
avec
kdi
manrabah
olleh
*/
