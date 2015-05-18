# Trabalho 1 de Org. de Computadores
# Profa. Sarita
# Danilo de Moraes Costa 8921972
# Nícolas Bassetto Leite 8937292
# Código em Assembly - MIPS

###############################################################################
############# mensagens que serao impressas e declaracao de vetor #############
###############################################################################
.data
	msg1:	.asciiz "Base do numero: "
	msg2:	.asciiz "\nNumero: "
	msg3:	.asciiz "Nova base: "
	msg4:	.asciiz "\nResultado: "
	msg5:	.asciiz	"\nInvalid Imput\nExecucao Interrompida\n"
	vector:	.space 32
	hexResult:	.space 8

.text
	.globl main	#main global

###############################################################################
############################## program principal ##############################
###############################################################################
main:
	li $v0, 4		#print
	la $a0, msg1	#"Base do numero: "
	syscall			
	li $v0, 12		#read character
	syscall
	beq $v0, 'B', readBin #if v0==B goto readBin
	beq $v0, 'D', readDec #if v0==D goto readDec
	beq $v0, 'H', readHex #if v0==H goto readHex
	beq $v0, 'O', readOct #if v0==O goto readOct
	#else invalidImput
invalidImput:		#mensagem de erro
	li $v0, 4		#print
	la $a0, msg5	#"\nInvalid Imput\nExecucao Interrompida\n"
	syscall
end:				#encerramento do programa
	li $v0,10		#exit
	syscall

###############################################################################
########################## leitura de numero binario ##########################
###############################################################################
readBin:
	li $v0, 4		#print
	la $a0, msg2	#"Numero: "
	syscall
	jal readString		#le string
	jal sizeOfString	#armazena tamanho em t2

	li $t1, 1
	li $t3, 1
	li $t5, 1
	li $t6, 2 

	firstCharValueBin:
		mul $t1, $t1, $t6	#t1*=2
		add $t3, $t3, $t5	#t3++
		bne $t2, $t3, firstCharValueBin	#if t2!=sizeOfString goto firstCharValueBin

	la $a0, vector
	li $t0, 0
	li $t3, 0
	li $t7, 48

	loopBin:				#loop que converte numero binario em decimal
		lbu $t4, ($a0)		#armazenar conteudo da posição atual do vetor em t4
		beqz $t4, endBin	#se posição estiver vazia, sair do loop
		sub $t4, $t4, $t7	#t4-=48 //transforma ascii em numero
		bltz $t4, invalidImput 		#if t4<0 goto invalidImput
		bgt $t4, $t5, invalidImput	#if t4>1 goto invalidImput
		mul $t4, $t4, $t1	#t4=t4*t1	(t1=2^n, onde n é a posição no vetor)
		add $t0, $t0, $t4	#t0+=t4
		div $t1, $t1, $t6	#t1/=2
		add $t3, $t3, $t5	#t3++
		add $a0, $a0, $t5	#incrementa posicao de vetor
		bne $t2, $t3, loopBin #if t2!=sizeOfString goto loopBin

	endBin:
		j getBase

###############################################################################
########################### leitura de numero octal ###########################
###############################################################################
readOct:
	li $v0, 4		#print
	la $a0, msg2	#"Numero: "
	syscall
	jal readString	#le string e armazena em a0
	jal sizeOfString

	li $t1, 1
	li $t3, 1
	li $t5, 1
	li $t6, 8 

	firstCharValueOct:
		mul $t1, $t1, $t6	#t1*=8
		add $t3, $t3, $t5	#t3++
		bne $t2, $t3, firstCharValueOct	#if t2!=sizeOfString goto firstCharValueOct

	la $a0, vector
	li $t0, 0
	li $t3, 0
	li $t5, 7
	li $t7, 48

	loopOct:				#loop que converte numero binario em decimal
		lbu $t4, ($a0)		#armazenar conteudo da posição atual do vetor em t4
		beqz $t4, endOct	#se posição estiver vazia, sair do loop
		sub $t4, $t4, $t7	#t4-=48 //transforma ascii em numero
		bltz $t4, invalidImput 		#if t4<0 goto invalidImput
		bgt $t4, $t5, invalidImput	#if t4>7 goto invalidImput
		mul $t4, $t4, $t1	#t4=t4*t1	(t1=8^n, onde n é a posição no vetor)
		add $t0, $t0, $t4	#t0+=t4
		div $t1, $t1, $t6	#t1/=8
		addi $t3, $t3, 1	#t3++
		addi $a0, $a0, 1	#incrementa posição no vetor
		bne $t2, $t3, loopOct #if t2!=sizeOfString goto loopOct	

	endOct:
		j getBase

###############################################################################
########################## leitura de numero decimal ##########################
###############################################################################
readDec:
	li $v0, 4		#print
	la $a0, msg2	#"Numero: "
	syscall
	li $v0, 5		#read int
	syscall
	blt $v0,$zero,readDec #if v0 < 0 goto readDec
	move $t0, $v0 	#t0 = v0
	j getBase		#goto getBase

###############################################################################
######################## leitura de numero hexadecimal ########################
###############################################################################
readHex:
	li $v0, 4		#print
	la $a0, msg2	#"Numero: "
	syscall
	jal readString
	jal sizeOfString

	li $t1, 1
	li $t3, 1
	li $t5, 1
	li $t6, 16

	firstCharValueHex:
		mul $t1, $t1, $t6	#t1*=16
		add $t3, $t3, $t5	#t3++
		bne $t2, $t3, firstCharValueHex	#if t2!=sizeOfString goto firstCharValueHex 

	la $a0, vector
	li $t0, 0
	li $t3, 0	
	li $t5, 70	#F em ascii
	li $t7, 48	#0 em ascii
	li $t8, 65	#A em ascii
	li $t9, 57	#9 em ascii

	loopHex:
#		addi $a0, $a0, 1	#incrementa posicao de vetor
		lbu $t4, ($a0)		#armazenar conteudo da posição atual do vetor em t4
		beqz $t4, endOct	#se posição estiver vazia, sair do loop
		blt $t4, $t7, invalidImput	#if t4<48 goto invalidImput
		bge $t4, $t8, caseLetter	#if t4>65 goto caseLetter
		jal caseNumber				#else goto caseNumber
	backToLoop:
		mul $t4, $t4, $t1	#t4=t4*t1	(t1 = 16^n, onde n é posiçao no vetor)
		add $t0, $t0, $t4	#t0+=t4
		div $t1, $t1, $t6	#t1/=16
		addi $t3, $t3, 1	#t3++
		addi $a0, $a0, 1	#incrementa posicao de vetor
		bne $t2, $t3, loopHex #if t2!=sizeOfString goto loopHex

	endHex:
		j getBase

caseNumber:
	bgt $t4, $t9, invalidImput	#if t4>57 (9 ascii) goto invalidImput
	sub $t4, $t4, $t7	#t4-=48
	jr $ra 				#return

caseLetter:
	bgt $t4, $t5, invalidImput	#if t4>70 (F ascii) goto invalidImput
	sub $t4, $t4, $t8	#t4-=65
	addi $t4, $t4, 10	#t4+=10
	j backToLoop		#return

###############################################################################
################## leitura da base para qual sera convertida ##################
###############################################################################
getBase:
	li $v0, 4		#print
	la $a0, msg3	#"Nova base: "
	syscall
	li $v0, 12		#read character
	syscall
	beq $v0, 'B', printBin #if v0==B goto printBin
	beq $v0, 'D', printDec #if v0==D goto printDec
	beq $v0, 'H', printHex #if v0==H goto printHex
	beq $v0, 'O', printOct #if v0==O goto printOct
	j invalidImput	#else goto invalidImput // encerra programa

###############################################################################
######################### impressao de numero binario #########################
###############################################################################
printBin:
	li $v0, 4		#print
	la $a0, msg4	#"\nResultado: "
	syscall

	move $a0, $t0	#a0 = t0
	li $a1, 2		#a1 = 2
	jal convert 	#chama conversor com argumentos ($t0, 2)
	j end			#goto end //encerra programa

###############################################################################
########################## impressao de numero octal ##########################
###############################################################################
printOct:
	li $v0, 4		#print
	la $a0, msg4	#"\nResultado: "
	syscall

	move $a0, $t0	#a0 = t0
	li $a1, 8		#a1 = 8
	jal convert 	#chama conversor com argumentos ($t0, 8)
	j end 			#goto end //encerra programa

###############################################################################
######################### impressao de numero decimal #########################
###############################################################################
printDec:
	li $v0, 4		#print
	la $a0, msg4	#"\nResultado: "
	syscall
	li $v0, 1		#print int
	move $a0, $t0 	#a0 = t0
	syscall
	j end			#goto end //encerra programa

###############################################################################
####################### impressao de numero hexadecimal #######################
###############################################################################
printHex:
	li $v0, 4		#print
	la $a0, msg4	#"\nResultado: "
	syscall
	
	li $t1, 8 			#contador de loop
	la $t3, hexResult	#vetor onde o resultado sera armazenado
	loopPrintHex:
 		beqz $t1, exitPrintHex 	#if contador=0 goto exitPrintHex
 		rol $t0, $t0, 4 		#rotate 4 bits para a esqueda /passa pros proximos 4 bits
 		and $t4, $t0, 0xf 		#t4 = t0 and 1111 /pega só 4bits = numero hex 
 		ble $t4, 9, soma 		#if t4<=9 (se for numero) goto soma 
 		addi $t4, $t4, 55 		#else (se for letra) {t4+=55 
 		b endPrintHex			#goto endPrintHex}
		soma: 
	 		addi $t4, $t4, 48		#t4+=48
	 	endPrintHex: 
	 		sb $t4, 0($t3) 			#armazena digito hex no resultado
	 		addi $t3, $t3, 1 		#incrementa posição no vetor
	 		subi $t1, $t1, 1 		#decrementa contador 
	 		j loopPrintHex			#continua loop

	exitPrintHex: 
	 	li $v0, 4 			#print
	 	la $a0, hexResult 	#string com resultado hexadecimal
	 	syscall 
		j end			#goto end //encerra programa

###############################################################################
############################## leitura de string ##############################
###############################################################################
readString:
	la $a0, vector
	li $a1, 32
	move $s0, $a0
	li $v0, 8
	syscall
	jr $ra 			#return

###############################################################################
########################## calculo tamanho da string ##########################
###############################################################################
sizeOfString:
	li $t2, 0 # $t2 armazenara o tamanho da string
	move $t1, $s0
	loopSize:
		lbu $t0, 0($t1)
		beqz $t0, endSize
		addi $t2, $t2, 1 # size ++
		addi $t1, $t1, 1 # i ++	
		j loopSize
	endSize:
		subi $t2, $t2, 1
		jr $ra 	#return

###############################################################################
############################# conversor recursivo #############################
###############################################################################
convert:
	#a0=A
	#a1=B

	addi $sp,$sp,-16

	sw $s3,12($sp)	#contador de loop
	sw $s0,8($sp)	#push A
	sw $s1,4($sp)	#push B
	sw $ra,0($sp)	#push ra (endereço de retorno da funçao)

	move $s0,$a0	#s0 = A
	move $s1,$a1	#s1 = B

	beqz $s0,endPrint 	#se A=0 goto endPrint

	div $t4,$s0,$s1 #t4=A/B
	rem $t3,$s0,$s1 #t3=A%B
	add $sp,$sp,-4
	sw $t3,0($sp) 	#save t3

	move $a0,$t4 	#pass A/B
	move $a1,$s1 	#pass B
	addi $s3,$s3,1	#contador++
	jal convert 	#call convert (recursão)

endPrint:

	lw $ra,0($sp)	#pop ra 
	lw $s1,4($sp)	#pop B
	lw $s0,8($sp)	#pop A
	lw $s3,12($sp)	#pop contador
	beqz $s3,done	#se contador = 0 goto done
	lw $a0,16($sp)	#a0 recebe numero de 1 digido a ser printado
	li $v0,1		#print int
	syscall
done: 
	addi $sp,$sp,20	#volta organização original da pilha
	jr $ra   		#returno da função
