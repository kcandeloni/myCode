// Trabalho 1 SO - Kevin Willian Candeloni
#include<sys/types.h>
#include<sys/wait.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <errno.h>
#include <time.h>

void arvBranch(int h, pid_t idRoot){
	pid_t idP;
	int i;
	
	for(i=0;i<h;i++){
		idP= fork();
		if(idP<0){	//testa fork
			printf("Erross 901\n\n");			
			exit(errno);
		}
		if(idP==0)printf("n=%d\tC[%d, %d]\n", i+1, getpid(), getppid());
		else if(idP>0){	//se é o pai
			wait(NULL);
			idP= fork();
			if(idP<0){	//testa fork
				printf("Erross 901\n\n");			
				exit(errno);
			}
			if(idP==0)printf("n=%d\tC[%d, %d]\n", i+1, getpid(), getppid());
			else if(idP>0){
				wait(NULL);
				i= h;
			}
		}
	}
	printf("\tT[%d, %d]\n", getpid(), getppid());
	if(getpid()!=idRoot)exit(0);
	else return;
}

void arvLivre(int h, pid_t idRoot){
	pid_t idP;
	int i;

	for(i=0;i<h;i++){
		idP= fork();
		if(idP<0){	//testa fork
			printf("Erross 901\n\n");			
			exit(errno);
		}
		if(idP==0){printf("n=%d\tC[%d, %d]\n", i+1, getpid(), getppid());}
		else if(idP>0){	//se é o pai
			//wait(NULL);
			idP= fork();
			if(idP<0){	//testa fork
				printf("Erross 901\n\n");			
				exit(errno);
			}
			if(idP==0){printf("n=%d\tC[%d, %d]\n", i+1, getpid(), getppid());}
			else if(idP>0){
				//wait(NULL);
				i= h;
			}
		}
	}
	if(idP){//printf("n=%d\tEsperei[%d, %d]\n", i+1, getpid(), getppid());
		//processo filho não executa
		wait(NULL);
		wait(NULL);
	}
	printf("\tT[%d, %d]\n", getpid(), getppid());
	if(getpid()!=idRoot)exit(0);
	else return;
}

double difTempo(struct timespec t0, struct timespec t1){
	return ((double)t1.tv_sec - t0.tv_sec) + ((double)(t1.tv_nsec-t0.tv_nsec) * 1e-9);
}

int main(int argc, char **argv){
	
	pid_t idP;
	pid_t idRoot;

	struct timespec t0, t1, t2, t3;
	int i=0, estado, h= atoi(argv[1]);
	
	idRoot= getpid();
	
	if(argc>2||h<1){	//testa argumentos
		printf("Erro 904\n\n");
		exit(1);
	}
	printf("-------------- Branch ---------------\n");
	printf("n=%d\tPID=%d (root)\n", i, getpid());
	clock_gettime(CLOCK_MONOTONIC_RAW, &t0);	//comeca medir o tempo branch
	arvBranch(h, idRoot);
	clock_gettime(CLOCK_MONOTONIC_RAW, &t1);	//fim da medicao do tempo branch
	printf("----- Fim criacao por Branch -----\n\n");

	printf("-------------- Livre ---------------\n");
	printf("n=%d\tPID=%d (root)\n", i, getpid());
	clock_gettime(CLOCK_MONOTONIC_RAW, &t2);	//comeca medir o tempo Livre
	arvLivre(h, idRoot);
	clock_gettime(CLOCK_MONOTONIC_RAW, &t3);	//fim da medicao do tempo Livre
	printf("----- Fim criacao por Livre -----\n\n");

	printf("Tempo Execucao 'Branch': %f seg\n\n", (float)difTempo(t0, t1));
	printf("Tempo Execucao 'Livre': %f seg\n", (float)difTempo(t2, t3));
	// Escreve no arq o tempo do branch
	FILE *fp1;
	fp1=fopen("tempBranch.txt","at"); // "at" - cont de onde estava
    
	if(fp1==NULL){
    		printf("Erro na abertura do arquivo.\n");
    		getchar();
	}
        fprintf(fp1,"%f\n",(float)difTempo(t0, t1));

	fclose(fp1);

	// Escreve no arq livre
	FILE *fp2;
	fp2=fopen("tempLivre.txt","at"); // "at" - cont de onde estava
    
	if(fp2==NULL){
    	printf("Erro na abertura do arquivo 2.\n");
    	getchar();
	}
        fprintf(fp2,"%f\n",(float)difTempo(t2, t3));

	fclose(fp2);
	
	exit(0);
}
