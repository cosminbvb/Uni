#include <unistd.h>
#include <stdio.h>
#include <sys/wait.h>
int main(){
    pid_t copil = fork();
    if(copil==-1){
        return -1;
    }
    if(copil==0){
        printf("Al doilea proces:\nMy parent:\t%d\nMy pid:\t%d\n",getppid(),getpid());
        char* argv[] = {"date",NULL};
        char* envp[] = {NULL};
        execve("/bin/date", argv, envp);
        puts("NU va fi executat niciodata"); //chestia asta nu se mai executa
        //daca execve a reusit
    }
    else{
        wait(NULL);
        printf("Primul proces:\nMy parent:\t%d\nMy pid:\t%d\n",getppid(),getpid());
    }
    return 0;
}