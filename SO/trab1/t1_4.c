// Trabalho 1.4(c/tempo) SO - branch
#include<sys/types.h>
#include<sys/wait.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <errno.h>
#include <time.h>

double difTempo(struct timespec t0, struct timespec t1){
  return ((double)t1.tv_sec - t0.tv_sec) + ((double)(t1.tv_nsec-t0.tv_nsec) * 1e-9);}

int main(int argc, char **argv){
	
	pid_t idP;
	pid_t idRoot;

	struct timespec t0, t1;
	int i=0, estado, h= atoi(argv[1]);
	
	idRoot= getpid();
	
	if(argc>2||h<1){	//testa argumentos
		printf("Erro 904\n\n");
		exit(1);
	}
	printf("-------------- Branch ---------------\n");
	printf("n=%d\tPID=%d (root)\n", i, getpid());
	clock_gettime(CLOCK_MONOTONIC_RAW, &t0);	//comeca medir o tempo branch
	for(i=0;i<h;i++){
		idP= fork();
		if(idP<0){	//testa fork
			printf("Erross 901\n\n");			
			exit(errno);
		}
		if(idP==0)printf("n=%d\tC[%d, %d]\n", i+1, getpid(), getppid());
		if(idP>0){
			wait(&estado);
			idP= fork();
			if(idP<0){	//testa fork
				printf("Erross 901\n\n");			
				exit(errno);
			}
			if(idP==0)printf("n=%d\tC[%d, %d]\n", i+1, getpid(), getppid());
			if(idP>0){
				wait(&estado);
				i= h;
			}
		}
	}
	printf("\tT[%d, %d]\n", getpid(), getppid());
	if(getpid()==idRoot){
		printf("----- Fim criacao por Branch -----\n\n");
   		clock_gettime(CLOCK_MONOTONIC_RAW, &t1);	//fim da medicao do tempo branch
		printf("Tempo Execucao 'Branch': %f seg\n", (float)difTempo(t0, t1));
	}
	exit(0);
}
