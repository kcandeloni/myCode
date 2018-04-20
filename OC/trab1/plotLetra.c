#include<stdio.h>

int main(){
	//int matA[5][4]={0, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 1};
	int cont;
	
	int p, l=0, c=0, matA[5][4];

	// Ler arq
	FILE *fp1;
	fp1=fopen("input.txt","rt");
           
	if(fp1==NULL){
		printf("Erro na abertura do arquivo.\n");
		getchar();
	}
	while(fscanf(fp1,"%d",&p)==1){
		matA[l][c]= p;
		//printf("%d - %d - %d\n", matA[l][c], l, c);
		c++;
		if(c==4){
			c=0;
			l++;
		}
		if(l==5){	// getLetra
			l=0;
			cont=0;
	for(int i=0;i<5;i++){
		for(int j=0;j<4;j++){
			// 0, 1, 1, 0,
			// 1, 0, 0, 1,
			// 1, 1, 1, 1,
			// 1, 0, 0, 1,
			// 1, 0, 0, 1 A
			if(matA[i][j]){
				if(cont==0)matA[i][j]=1;
				else matA[i][j]= cont;
				cont=0;
			}
			if(j!=3){
				cont+=4;
			}
		}
		cont+=500;
	}
	printf("letra:	.word	");
	cont=0;
	for(int i=0;i<5;i++){
		for(int j=0;j<4;j++){
			if( matA[i][j] ){
				if(matA[i][j]==1)printf("0, ");
				else printf("%d, ", matA[i][j]);
				cont++;
			}
		}
	}
	while(cont!=13){
		if(cont==12)printf("0");
		else printf("0, ");
		cont++;
		}
	printf("\n");
	}//if
	}//while
	fclose(fp1);
}
