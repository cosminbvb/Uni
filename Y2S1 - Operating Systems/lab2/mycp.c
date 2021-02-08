#include <stdio.h>
#include <unistd.h> //read+write
#include <sys/stat.h> //open + stat, fstat
#include <sys/types.h> //open
#include <errno.h>
#include <fcntl.h> //open
int main(int argc, char **argv)
{
	if(argc<3)
	{
		printf("Prea putine argumente\n");
		return -1;
	}
	if(argc>3)
	{
		printf("Prea multe argumente\n");
		return -1;
	}
	int fd1 = open(argv[1], O_RDONLY);
	if(fd1 == -1)
	{
		perror("Nu s-a putut deschide primul fisier\n");
		//return -1;
		return errno;
	}
	//acum vrem sa aflam marimea fisierului 1 si sa ii punem 
	//continutul intr-un buffer
	struct stat sb;
	if(fstat(fd1, &sb))
	{
		perror("Eroare fisier 1\n");
		return errno;
	}
	int size = sb.st_size;
	char buf[size];
	read(fd1,buf, size);
	int fd2 = open(argv[2], O_WRONLY | O_CREAT, S_IRUSR | S_IWUSR);
	//daca al doilea fisier nu exista il cream cu drepturi de r si w
	if(fd2 == -1)
	{
		perror("Nu s-a putut deschide al doilea fisier\n");
		//return -1;
		return errno;
	}
	//acum vrem sa scriem ce e in buffer in fisierul 2
	write(fd2,buf,size);
	//trebuie sa inchidem fisierele
	int ret_val = close(fd1);
	if(ret_val == -1)
	{
		perror("Eroare la inchiderea fisierului 1");
		return errno;
	}
	ret_val = close(fd2);
	if(ret_val == -1)
	{
		perror("Eroare la inchiderea fisierului 2");
		return errno;
	}
	return 0;
}
