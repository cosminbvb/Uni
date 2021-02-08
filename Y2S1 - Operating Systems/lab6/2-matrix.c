#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <errno.h>

int n1, m1, n2, m2;
int **matrix1;
int **matrix2;

struct line_col{
    int line, col;
};

void* multiply(void* v){
    struct line_col* arg = v;
    int sum = 0;
    for(int i=0; i<m1; i++){
        sum+=matrix1[arg->line][i]*matrix2[i][arg->col];
    }
    free(arg);
    int* ret = (int*)malloc(sizeof(int));
    *ret = sum;
    return ret;
}

int main(){

    #pragma region read

    //read matrix1
    printf("Enter rownum & colnum for matrix 1: \n");
    scanf("%d %d", &n1, &m1);
    matrix1 = (int**)malloc(sizeof(int *)*n1);
    printf("Enter matrix 1: \n");
    for(int i=0;i<n1;i++){
        matrix1[i] = (int*)malloc(sizeof(int)*m1);
        for(int j=0;j<m1;j++){
            scanf("%d", &matrix1[i][j]);
        }
    }

    printf("\n");

    //read matrix2
    printf("Enter rownum & colnum for matrix 2: \n");
    scanf("%d %d", &n2, &m2);
    matrix2 = (int**)malloc(sizeof(int *)*n2);
    printf("Enter matrix 2: \n");
    for(int i=0;i<n2;i++){
        matrix2[i] = (int*)malloc(sizeof(int)*m2);
        for(int j=0;j<m2;j++){
            scanf("%d", &matrix2[i][j]);
        }
    }

    #pragma endregion

    if(m1 != n2){
        printf("Not matching \n");
        return -1;
    }

    int** rez = (int**)malloc(sizeof(int*)*n1); //alocam matricea rezultata
    pthread_t* threads = (pthread_t* )malloc(sizeof(pthread_t)*n1*m2+1); //array de thread uri
    int nr = 0; //counter pt threads
    
    for(int i=0; i<n1; i++){
        rez[i] = (int*)malloc(sizeof(int)*m2);
        for(int j=0; j<m2; j++){
            //pentru fiecare element din rez cream un thread
            struct line_col *arg = (struct line_col*)malloc(sizeof(struct line_col));
            arg->line = i;
            arg->col = j;
            if(pthread_create(&threads[nr], NULL, multiply, arg)){
                perror(NULL);
                return errno;
            }
            nr++;
        }
    }
    
    nr = 0;
    for(int i=0; i<n1; i++){
        for(int j=0;j<m2;j++){
            void* adress_returned;
            if (pthread_join(threads[nr], &adress_returned)){
                perror(NULL);
                return errno;
            }
            nr++;
            rez[i][j] = *((int*)adress_returned);
            free(adress_returned);
        }
    }
    
    printf("\n");
    for(int i=0; i<n1;i++){
        for(int j=0;j<m2;j++){
            printf("%d ", rez[i][j]);
        }
        printf("\n");
    }
    
    #pragma region Free

    for(int i=0; i<n1; i++){
        free(matrix1[i]);
        free(rez[i]);
    }
    free(matrix1);
    free(rez);

    for(int i=0; i<n2; i++){
        free(matrix2[i]);
    }
    free(matrix2);

    free(threads); 

    #pragma endregion

    // valgrind --leak-check=full --show-leak-kinds=all --error-exitcode=1 -q ./a.out

    return 0;
    
}

/*
ex
3 2 
4 6  
2 0
5 7
2 3
3 2 4
5 1 0

42 14 16 
6 4 8 
50 17 20 
*/
