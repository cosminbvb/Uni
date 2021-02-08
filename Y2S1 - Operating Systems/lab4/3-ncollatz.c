#include <unistd.h>
#include <sys/wait.h>
#include <stdlib.h>
#include <stdio.h>
int main(int argc, char* argv[])
{
    printf("Starting parent %d\n",getpid());
    for(int i=1;i<argc;i++)
    {
        pid_t copil = fork(); //un copil care sa rezolve fiecare problema
        if(copil < 0)
        {
            perror("Eroare la fork");
            return -1;
        }
        else if(copil == 0)
        {
            //cod doar pt copil
            int n = atoi(argv[i]);
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
            printf("Done. Parent = %d, Me = %d\n", getppid(), getpid());
            exit(0); //normal process termination
            //trebuie sa terminam procesul pentru ca altfel continua in for
            /*
                Q:copilul vede doar in block-ul in care i s-a facut fork?
                A:Nu.Tot codul. E efectiv o copie a parintelui. Dupa fork executa
                fiecare instructiune care urmeaza, la fel ca parintele. Singura diferenta
                e ca daca intrebi copilul ce a returnat forkul de mai sus zice ca 0. Parintele
                o sa zica ca a returnat un nr diferit de 0, mai exact pid-ul copilului.
            */ 
        }
    }
    for(int i=1;i<argc;i++)
    {
        //parintele asteapta terminarea executiei fiecarui copil
        wait(NULL);
	//daca se apeleaza wait si nu exista copil de asteptat cred ca se returneaza -1
    }
    printf("Done. Parent = %d, Me = %d\n", getppid(), getpid());
    
    return 0;
}