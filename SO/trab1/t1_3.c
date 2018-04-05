// Trabalho 1.3(c/print do processo) SO - branch
#include<sys/types.h>
#include<sys/wait.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <errno.h>

int main(int argc, char **argv){
	
	pid_t idP;
	pid_t idRoot;
	int i=0, estado, h= atoi(argv[1]);
	idRoot= getpid();
	
	if(argc>2||h<1){	//testa argumentos
		printf("Erro 904\n\n");
		exit(1);
	}
	printf("-------------- Branch ---------------\n");
	printf("n=%d\tPID=%d (root)\n", i, getpid());
	for(i=0;i<h;i++){
		idP= fork();
		if(idP<0){	//testa fork
			printf("Erross 901\n\n");			
			exit(errno);
		}
		if(idP==0)printf("n= %d\tC[%d, %d]\n", i+1, getpid(), getppid());
		if(idP>0){
			wait(&estado);
			idP= fork();
			if(idP<0){	//testa fork
				printf("Erross 901\n\n");			
				exit(errno);
			}
			if(idP==0)printf("n= %d\tC[%d, %d]\n", i+1, getpid(), getppid());
			if(idP>0){
				wait(&estado);
				i= h;
			}
		}
	}
	printf("\tT[%d, %d]\n", getpid(), getppid());
	if(getpid()==idRoot)printf("\n\n----- Fim criacao por Branch -----\n");
	exit(0);
}
