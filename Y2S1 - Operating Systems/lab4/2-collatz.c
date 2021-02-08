#include <unistd.h>
#include <sys/wait.h>
#include <stdlib.h>
#include <stdio.h>
int main(int argc, char* argv[])
{
    if(argc!=2)
    {
        printf("Numar incorect de argumente\n");
        return -1;
    }
    int n = atoi(argv[1]);
    pid_t pid = fork();
    if(pid < 0)
    {
        perror("Eroare la fork");
        return -1;
    }
    else if (pid == 0)
    {
        //cod copil
        printf("%d: ",n);
        while(n != 1)
        {
            printf("%d ",n);
            if(n%2)
            {
                n=3*n+1;
            }
            else
            {
                n/=2;
            }
            
        }
        printf("%d\n",n);
    }
    else
    {
        //cod parinte
        wait(NULL);
        printf("Child %d finished\n",pid);
    }
    return 0;
}