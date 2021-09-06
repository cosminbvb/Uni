#include <unistd.h>
#include <stdio.h>
#include <sys/wait.h>
int main(){
    pid_t pid_copil1;
    pid_t pid_copil2;
    pid_t copil_care_a_terminat;
    puts("Inainte de fork");
    pid_copil1 = fork();
    //de acum executa si parintele si copilul aceleasi instructiuni
    if(pid_copil1 == -1){
        return -1;
    }
    puts("Dupa fork");
    if(pid_copil1 == 0){
        //executat doar de copil
        printf("Copil pid %d\n", getpid());
    }
    else{
        //executat doar de parinte
        printf("Parinte pid %d\n", getpid());
        pid_copil2 = fork();
        if(pid_copil2 == 0){
            //doar al doilea copil
            return 0;
        }
        else{
            //doar parintele
            copil_care_a_terminat = wait(NULL); //cand se da wait se asteapta 
            //terminarea oricarui copil
            if(copil_care_a_terminat == pid_copil1){
                puts("A terminat copilul 1");
            }
            else{
                puts("A terminat copilul 2");
            }
        }
    }
    return 0;
} 