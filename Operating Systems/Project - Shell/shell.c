#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <readline/readline.h>
#include <readline/history.h>

#define min(a, b) (((a) < (b)) ? (a) : (b))

int executing = 0;

void clear()
{
    printf("\e[1;1H\e[2J\n");
}

int split(char *command, char ***argv)
{
    int argc = 0;
    int realloc_size = 4;
    *argv = (char **)malloc(realloc_size * sizeof(char *));

    char *token = strtok(command, " ");
    while (token != NULL)
    {
        (*argv)[argc++] = token;
        if (argc == realloc_size)
        {
            realloc_size *= 2;
            *argv = (char **)realloc(*argv, realloc_size * sizeof(char *) + 1);
        }
        token = strtok(NULL, " ");
    }

    (*argv)[argc] = NULL;
    return argc;
}

int hasPipe(char *command, char **pipe_split)
{
    //return values:
    //1 if pipe is found
    //0 otherwise
    //the function also splits the command

    for (int i = 0; i < 2; i++)
    {
        pipe_split[i] = strsep(&command, "|");
        if (!pipe_split[i])
            break;
    }
    if (!pipe_split[1])
        return 0;
    return 1;
}

int execute(char *command, int command_size)
{
    executing = 1; //mark start of execution

    char *copy = (char *)malloc(sizeof(char) * command_size + 1);
    strcpy(copy, command);

    char *pipe_split[2];
    if (hasPipe(command, pipe_split))
    {
        free(copy); //we only need it on else

        char **argvPipe1 = NULL;
        char **argvPipe2 = NULL;
        int argc1 = split(pipe_split[0], &argvPipe1);
        int argc2 = split(pipe_split[1], &argvPipe2);

        int pipefd[2];
        //pipe[0] - refers to the read end of the pipe
        //pipe[1] - refers to the write end of the pipe

        if (pipe(pipefd) == -1)
        {
            perror(NULL);
            return -1;
        }

        pid_t child1, child2;
        child1 = fork();

        if (child1 < 0)
        {
            perror(NULL);
            return -1;
        }
        if (child1 == 0) //child 1 writes
        {
            close(pipefd[0]);               //close unused read end
            dup2(pipefd[1], STDOUT_FILENO); //copy file descriptor 1 to stdout.
            close(pipefd[1]);
            if (execvp(argvPipe1[0], argvPipe1) == -1)
            {
                puts("Command failed");
                exit(EXIT_FAILURE); // kills process
            }
        }
        else
        {
            child2 = fork();
            if (child2 < 0)
            {
                perror(NULL);
                return -1;
            }
            if (child2 == 0)
            {
                close(pipefd[1]);              //close unused write end
                dup2(pipefd[0], STDIN_FILENO); //copy file descriptor 0 to stdin.
                close(pipefd[0]);
                if (execvp(argvPipe2[0], argvPipe2) == -1)
                {
                    puts("Command failed");
                    exit(EXIT_FAILURE); // kills process
                }
            }
            else
            {
                wait(NULL);
                wait(NULL);
                //the parent waits for his 2 children

                free(argvPipe1);
                free(argvPipe2);
            }
        }
    }
    else
    {
        char **argv = NULL;
        int argc = split(copy, &argv);

        //builtin cd
        if (!strcmp(argv[0], "cd"))
        {
            if (argc > 2)
            {
                puts("too many arguments");
                return -1;
            }
            if (argc < 2)
            {
                puts("not enough arguments");
                return -1;
            }
            chdir(argv[1]);
            free(copy);
            free(argv);
            return 0;
        }

        pid_t child = fork();
        if (child < 0)
        {
            perror(NULL);
            return -1;
        }
        if (child == 0)
        {
            if (execvp(argv[0], argv) == -1)
            {
                puts("Command failed");
                exit(EXIT_FAILURE); // kills process
            }
            //if execvp worked the process ends
        }
        else
        {
            wait(NULL);
            free(copy);
            free(argv);
        }
    }

    return 0;
}

void signal_handler()
{
    //if a subprogram is executing (ping for example), the executing variable is set to 1
    //and ctrl+c kills it
    //if not, we need to discard the written line and give the user a fresh new one
    if (!executing)
    {
        //when detecting ctrl+c, we need to discard the written line
        rl_backward_kill_line(1, 0);
        
        //then we need to print the prompt again
        puts("");
        rl_redraw_prompt_last_line();
    }
}

int main()
{
    signal(SIGINT, signal_handler); //signal_handler is called when ctrl+c is detected

    char *command = NULL;
    char cwd[4096];

    clear();

    while (1)
    {
        char *username = getenv("USER"); //get username

        getcwd(cwd, sizeof(cwd)); //get current working dir

        //build the prompt:
        char *prompt = (char *)malloc(sizeof(char) * (strlen(username) + strlen(cwd) + 4));
        strcpy(prompt, username);
        strcat(prompt, "~:");
        strcat(prompt, cwd);
        strcat(prompt, " \0");
        
        char *input = readline(prompt);
        
        free(prompt); //free the prompt when no longer needed

        if (strlen(input))
        {
            add_history(input);
            command = (char *)malloc(strlen(input) * sizeof(char) + 1);
            strcpy(command, input);
            free(input);
        }
        else
        {
            free(input);
            continue;
        }
        if (strcmp(command, "exit") == 0)
        {
            free(command);
            rl_clear_history();
            break;
        }

        execute(command, strlen(command)); //send command for execution
        executing = 0; //mark end of execution

        free(command);
    }
    return 0;
}
