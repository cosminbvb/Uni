#include <pthread.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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
    if(argc!=2){
        printf("Nr invalid de arg\n");
        return -1;
    }
    void * result; //aici vine rezultatul de la functia invers
    //e de tip void* pentru ca primeam warning la char*
    pthread_t thread;
    //initializam thread cu noul fir de executie lansat prin apelarea functiei invers
    if (pthread_create(&thread, NULL, invers, argv[1])){
        perror(NULL);
        return errno;
    }
    if (pthread_join(thread, &result)){
        perror(NULL);
        return errno;
    }
    printf("%s\n", (char *)result); //afisam rezultatul
    free(result); //memoria e alocata pe heap deci ramane sa o eliberam noi
    return 0;
}
//trebuie link uit lib ul pt thread uri => gcc ceva.c -o ceva -pthread