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
	addi $s4, $zero, 127	# inicializa o contador
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
	sw $s1, 0($s5)	# pixel
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
setA:
	la $t0, letraA	# $t0 <- endereço base do vetor a
	addi $t1, $t0, 52
	j setLetra
setB:
	la $t0, letraB	# $t0 <- endereço base do vetor a
	addi $t1, $t0, 56
	j setLetra	
setLetra:
	lw $t2, ($t0)
        add $s5, $s5, $t2
        jal putPixiel
        addi $t0, $t0, 4
	bne $t0, $t1, setLetra
	la $s5, dm	# ini EB
	addi $s5, $s5, 2608	# seta ponto onde a prox*(teste) letra vai começar a ser escrita
	j setB	# teste
	j theEnd 
theEnd:
	addi $v0, $zero, 17
	addi $a0, $zero, 0
	syscall