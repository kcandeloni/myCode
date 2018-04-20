.data
dm:	# memória do bitmap display
	.space  65536	# 128 * 128 * 4  largura x altura x bytes/pixel
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
theEnd:
	addi $v0, $zero, 17
	addi $a0, $zero, 0
	syscall