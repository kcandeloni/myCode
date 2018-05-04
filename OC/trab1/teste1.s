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
	# $a0 = arumento deslocamento (direçao)
	# $a1 = arumento tam da reta a ser setada (cont)
	# $a2 = arumento cor da reta
	# $a3 = EB (onde sera impresso )
##################################################################################
	la $s0, dm	# EB display
	add $a3, $zero, $s0	# salva para passar como argumento
	li $a2, 0x0000FF00   # cor verde
	#sw $a3, 0($a2)       # pixel(0,0) verde (desnecessário?)
# traça linas nos cantos da tela
	addi $a1, $zero, 127	# tam da lina (tela inteira)
	
	addi $a0, $zero, 512	# seta deslocamento para baixo
	jal setReta_test
	addi $a0, $zero, 4	# seta deslocamento para direita
	jal setReta_test
	addi $a0, $zero, -512	# seta deslocamrnto para cima
	jal setReta_test
	addi $a0, $zero, -4	# seta deslocamrnto para esquerda 
	jal setReta_test
	
setGallows:
# desenah forca	
	addi $a1, $zero, 58	# tam(linhas) da forca
	addi $a0, $zero, 512	# deslocamento para baixo
	addi $a3, $s0, 7800	# inicio da forca
	jal setReta_test
	
# escreve GAME
	addi $a3, $s0, 2700
	jal setG
	addi $a3, $s0, 2724
	jal setA
	addi $a3, $s0, 2748
	jal setM
	addi $a3, $s0, 2772
	jal setE
	
	j theEnd	# sai do programa	

setReta_test:
	# $a0 = arumento deslocamento (direçao)
	# $a1 = arumento tam da reta a ser setada (cont)
	# $a2 = arumento cor da reta
	# $a3 = EB (onde sera impresso )
################################################################################
# prólogo:
	addiu $sp, $sp, -8      # alteramos a pilha para receber um item
	sw $ra, 0($sp)       # armazenamos na pilha o endereço de retorno
	sw $s0, 4($sp)	# salva valor de $v0
# corpo do procedimento             
	add $s0, $zero, $a1	# salvamos o tam da reta para ser manipulado
setReta:
	jal putPixel 
	add $a3, $a3, $a0	# soma o deslocamento da reta (direçao )
	addi $s0, $s0, -1	# decrementa o cont 
	bne $s0, $zero, setReta	# verifica se ja cheou no final
# epílogo   
	lw $ra, 0($sp)      # recuperamos da pilha o endereço de retorno
	lw $s0, 4($sp)	# restaura valor de $s0
	addiu $sp, $sp, 8       # restauramos a pilha
	jr $ra	# retorna ao procedimento chamador
################################################################################	
	
	 
	###### testa letra
	#ori $v0, $zero, 32	#teste		# Syscall sleep
	#ori $a0, $zero, 60	#teste		# For this many miliseconds
	#syscall	#teste
	
	#lw $t0, 0xFFFF0004	#teste		# Load input value

testa_letra:	#teste
	#beq, $t0, 100, theEnd	#teste = d
	
	#beq $t0, 97, setA

putPixel:
	sw $a2, 0($a3)	# pixel no end cont em $a3 com a cor em $a2
	jr $ra
	
putLetra:
	# $a0 = EB do vetor da letra
	# $a2 = argumento cor da reta
	# $a3 = EB (onde sera impresso )
################################################################################
# prólogo:
	addiu $sp, $sp, -8      # alteramos a pilha para receber um item
	sw $ra, 0($sp)       # armazenamos na pilha o endereço de retorno
	sw $s0, 4($sp)	# salva valor de $s0
# corpo do procedimento             
	addi $s0, $zero, 14	# salvamos o tam da reta para ser manipulad
putLetra_r:
	lw $s1, ($a0)	# carrega o valor do deslocamento do proximo pixel da letra 
	add $a3, $a3, $s1	# calcula a posição do pixel da letra
	jal putPixel
	addi $a0, $a0, 4	# pega a prox posicao do verot
	addi $s0, $s0, -1	# decrementa o cont 
	bne $s0, $zero, putLetra_r	# verifica se ja cheou no final
# epílogo   
	lw $ra, 0($sp)      # recuperamos da pilha o endereço de retorno
	lw $s0, 4($sp)	# restaura valor de $s0
	addiu $sp, $sp, 8       # restauramos a pilha
	jr $ra	# retorna ao procedimento chamador
################################################################################

###	# carrega os vetores das letras
setA:
	la $a0, letraA	# $t0 <- endereço base do vetor a
	j putLetra
setB:
	la $a0, letraB	# $t0 <- endereço base do vetor b
	j putLetra
setC:
	la $a0, letraC	# $t0 <- endereço base do vetor c
	j putLetra
setD:
	la $a0, letraD	# $t0 <- endereço base do vetor d
	j putLetra
setE:
	la $a0, letraE	# $t0 <- endereço base do vetor e
	j putLetra
setF:
	la $a0, letraF	# $t0 <- endereço base do vetor f
	j putLetra
setG:
	la $a0, letraG	# $t0 <- endereço base do vetor g
	j putLetra
setH:
	la $a0, letraH	# $t0 <- endereço base do vetor h
	j putLetra
setI:
	la $a0, letraI	# $t0 <- endereço base do vetor i
	j putLetra
setJ:
	la $a0, letraJ	# $t0 <- endereço base do vetor j
	j putLetra
setK:
	la $a0, letraK	# $t0 <- endereço base do vetor k
	j putLetra
setL:
	la $a0, letraL	# $t0 <- endereço base do vetor l
	j putLetra
setM:
	la $a0, letraM	# $t0 <- endereço base do vetor m
	j putLetra
setN:
	la $a0, letraN	# $t0 <- endereço base do vetor n
	j putLetra
setO:
	la $a0, letraO	# $t0 <- endereço base do vetor o
	j putLetra
setP:
	la $a0, letraP	# $t0 <- endereço base do vetor p
	j putLetra
setQ:
	la $a0, letraQ	# $t0 <- endereço base do vetor q
	j putLetra
setR:
	la $a0, letraR	# $t0 <- endereço base do vetor r
	j putLetra
setS:
	la $a0, letraS	# $t0 <- endereço base do vetor s
	j putLetra
setT:
	la $a0, letraT	# $t0 <- endereço base do vetor t
	j putLetra
setU:
	la $a0, letraU	# $t0 <- endereço base do vetor u
	j putLetra
setV:
	la $a0, letraV	# $t0 <- endereço base do vetor v
	j putLetra
setW:
	la $a0, letraW	# $t0 <- endereço base do vetor w
	j putLetra
setX:
	la $a0, letraX	# $t0 <- endereço base do vetor x
	j putLetra
setY:
	la $a0, letraY	# $t0 <- endereço base do vetor y
	j putLetra
setZ:
	la $a0, letraZ	# $t0 <- endereço base do vetor z
	j putLetra
###	 
theEnd:
	addi $v0, $zero, 17
	addi $a0, $zero, 0
	syscall
