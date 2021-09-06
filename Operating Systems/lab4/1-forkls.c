#include <unistd.h>
#include <stdio.h>
#include <sys/wait.h>
int main()
{
    pid_t copil;
    copil = fork();
    if(copil == -1)
    {
        return -1;
    }
    if(copil != 0)
    {
        //in parinte
        printf("My pid:\t%d\nChild pid:\t%d\n", getpid(), copil);
        wait(NULL);
        printf("Child %d finished\n", copil);
    }
    else
    {
        //in copil
        char *argv[] = {"/bin/ls",NULL};
        char *envp[] = {NULL};
        execve("/bin/ls", argv, envp);
    }
    return 0
}