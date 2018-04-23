.data
dm:	# memória do bitmap display
	.space  65536	# 128 * 128 * 4  largura x altura x bytes/pixel
letraA:	.word	4, 4, 504, 12, 500, 4, 4, 4, 500, 12, 500, 12, 0, 0
letraB:	.word	0, 4, 4, 504, 12, 500, 4, 4, 504, 12, 500, 4, 4, 0
letraC:	.word	0, 4, 4, 4, 500, 512, 512, 512, 4, 4, 4, 0, 0, 0
letraD:	.word	0, 4, 4, 504, 12, 500, 12, 500, 12, 500, 4, 4, 0, 0
letraE:	.word	0, 4, 4, 4, 500, 512, 4, 4, 4, 500, 512, 4, 4, 4
letraF:	.word	0, 4, 4, 4, 500, 512, 4, 4, 4, 500, 512, 0, 0, 0
letraG:	.word	0, 4, 4, 4, 500, 512, 8, 4, 500, 12, 500, 4, 4, 4
letraH:	.word	0, 12, 500, 12, 500, 4, 4, 4, 500, 12, 500, 12, 0, 0
letraI:	.word	0, 4, 4, 4, 504, 512, 512, 508, 4, 4, 4, 0, 0, 0
letraJ:	.word	0, 4, 4, 4, 508, 512, 504, 8, 504, 4, 4, 0, 0, 0
letraK:	.word	0, 12, 500, 8, 504, 4, 508, 8, 504, 12, 0, 0, 0, 0
letraL:	.word	0, 512, 512, 512, 512, 4, 4, 4, 0, 0, 0, 0, 0, 0
letraM:	.word	4, 4, 504, 4, 4, 4, 500, 4, 4, 4, 500, 12, 500, 12
letraN:	.word	0, 12, 500, 4, 8, 500, 8, 4, 500, 8, 4, 500, 12, 0
letraO:	.word	0, 4, 4, 4, 500, 12, 500, 12, 500, 12, 500, 4, 4, 4
letraP:	.word	0, 4, 4, 504, 12, 500, 4, 4, 504, 512, 0, 0, 0, 0
letraQ:	.word	0, 4, 4, 4, 500, 12, 500, 12, 500, 8, 504, 4, 8, 0
letraR:	.word	0, 4, 4, 504, 12, 500, 4, 4, 504, 8, 504, 12, 0, 0
letraS:	.word	0, 4, 4, 4, 500, 512, 4, 4, 4, 512, 500, 4, 4, 4
letraT:	.word	0, 4, 4, 4, 504, 512, 512, 512, 0, 0, 0, 0, 0, 0
letraU:	.word	0, 12, 500, 12, 500, 12, 500, 12, 500, 4, 4, 4, 0, 0
letraV:	.word	0, 12, 500, 12, 500, 12, 500, 12, 504, 4, 0, 0, 0, 0
letraW:	.word	0, 12, 500, 12, 500, 4, 4, 4, 500, 4, 4, 4, 504, 4
letraX:	.word	0, 12, 504, 4, 508, 4, 508, 4, 504, 12, 0, 0, 0, 0
letraY:	.word	0, 12, 504, 4, 508, 512, 512, 0, 0, 0, 0, 0, 0, 0
letraZ:	.word	0, 4, 4, 4, 500, 516, 516, 504, 4, 4, 4, 0, 0, 0

.text
main:
	la $s5, dm
	li $s1, 0x0000FF00   # cor verde
	sw $s1, 0($s5)       # pixel(0,0) verde (desnecessário?)

	addi $t1, $s5, 65024	# final deslc lateral esq
	addi $t2, $s5, 65532	# final deslc inferior
	addi $t3, $s5, 508	# final deslc lateral dir
	addi $s3, $zero, 512	# seta o deslocamento para uma linha(esq) vertical
	
iniCont:
	addi $s4, $zero, 127	# inicializa o contador com o n de linhas do display
	
setRight:
	add $s5, $s5, $s3	# deslocamento da reta EB= EB + deslLinha($t6)
	jal putPixiel
	subi $s4, $s4, 1	# cont--
	bne $s4, $zero, setRight	# continua preenchendo a linha até que cont($t4) == 0
	beq $s5, $t1, setDesc_4		# verifica se chegou no end 65024
	beq $s5, $t2, setDesc_n512	# verifica se chegou no end 65532
	beq $s5, $t3, setDesc_n4	# verifica se chegou no end 508
	###### testa letra
	la $s5, dm	# ini EB
	addi $s5, $s5, 2584	# seta ponto onde a letra vai começar a ser escrita
	j setA 
	la $s5, dm	# ini EB
	addi $s5, $s5, 2608	# seta ponto onde a prox*(teste) letra vai começar a ser escrita
	j setB
	j theEnd	# sai do programa
	
putPixiel:
	sw $s1, 0($s5)	# pixel no end cont em $s5 com a cor em $s1
	jr $ra
	
setDesc_4:
	addi $s3, $zero, 4 	# deslocamento para a linha inferior
	j iniCont
	
setDesc_n512:
	addi $s3, $zero, -512	# deslocamento para a linha lateral dir
	j iniCont
	
setDesc_n4:
	addi $s3, $zero, -4	# deslocamento para a linha superior
	j iniCont

setFim_letra:
	addi $t1, $t0, 56	# seta qual é fim do vetor(letra)
	j setLetra	# manda imprimir a letra que foi carregada em t0
setLetra:
	lw $t2, ($t0)	# carrega o valor do deslocamento do proximo pixiel da letra 
        add $s5, $s5, $t2	# calcula a posição do pixiel da letra
        jal putPixiel	# imprime o priel na tela
        addi $t0, $t0, 4	# pega o proximo prixiel da letra
	bne $t0, $t1, setLetra	# testa se já chegou ao fim da letra
	###
	la $s5, dm	# ini EB
	addi $s5, $s5, 2608	# seta ponto onde a prox*(teste) letra vai começar a ser escrita
	j setB	# teste
	j theEnd
###	# carrega os vetores das letras
setA:
	la $t0, letraA	# $t0 <- endereço base do vetor a
	j setFim_letra
	
setB:
	la $t0, letraB	# $t0 <- endereço base do vetor b
	j setFim_letra

setC:
	la $t0, letraC	# $t0 <- endereço base do vetor c
	j setFim_letra

setD:
	la $t0, letraD	# $t0 <- endereço base do vetor d
	j setFim_letra

setE:
	la $t0, letraE	# $t0 <- endereço base do vetor e
	j setFim_letra

setF:
	la $t0, letraF	# $t0 <- endereço base do vetor f
	j setFim_letra

setG:
	la $t0, letraG	# $t0 <- endereço base do vetor g
	j setFim_letra

setH:
	la $t0, letraH	# $t0 <- endereço base do vetor h
	j setFim_letra

setI:
	la $t0, letraI	# $t0 <- endereço base do vetor i
	j setFim_letra

setJ:
	la $t0, letraJ	# $t0 <- endereço base do vetor j
	j setFim_letra

setK:
	la $t0, letraK	# $t0 <- endereço base do vetor k
	j setFim_letra

setL:
	la $t0, letraL	# $t0 <- endereço base do vetor l
	j setFim_letra

setM:
	la $t0, letraM	# $t0 <- endereço base do vetor m
	j setFim_letra

setN:
	la $t0, letraN	# $t0 <- endereço base do vetor n
	j setFim_letra

setO:
	la $t0, letraO	# $t0 <- endereço base do vetor o
	j setFim_letra

setP:
	la $t0, letraP	# $t0 <- endereço base do vetor p
	j setFim_letra

setQ:
	la $t0, letraQ	# $t0 <- endereço base do vetor q
	j setFim_letra

setR:
	la $t0, letraR	# $t0 <- endereço base do vetor r
	j setFim_letra

setS:
	la $t0, letraS	# $t0 <- endereço base do vetor s
	j setFim_letra

setT:
	la $t0, letraT	# $t0 <- endereço base do vetor t
	j setFim_letra

setU:
	la $t0, letraU	# $t0 <- endereço base do vetor u
	j setFim_letra

setV:
	la $t0, letraV	# $t0 <- endereço base do vetor v
	j setFim_letra

setW:
	la $t0, letraW	# $t0 <- endereço base do vetor w
	j setFim_letra

setX:
	la $t0, letraX	# $t0 <- endereço base do vetor x
	j setFim_letra

setY:
	la $t0, letraY	# $t0 <- endereço base do vetor y
	j setFim_letra

setZ:
	la $t0, letraZ	# $t0 <- endereço base do vetor z
	j setFim_letra
###	 
theEnd:
	addi $v0, $zero, 17
	addi $a0, $zero, 0
	syscall
