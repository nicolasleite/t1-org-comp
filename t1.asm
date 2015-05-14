.data
	msg1: .asciiz "Please insert value (A > 0) : "
	msg2: .asciiz "Please insert the number system B you want to convert to (2<=B<=10):"
	msg3: .asciiz "\nResult : "

.text
.globl main #make main global

#$zero ==0

main:
	addi $s0,$zero,2 #s0 = 2
	addi $s1,$zero,10 #s1 = 10

getA:
	li $v0,4	#print
	la $a0,msg1 #msg
	syscall		#do
	li $v0,5	#read N
	syscall		#do
	blt $v0,$zero,getA #if N < 0, goto getA
	move $t0,$v0 #t0 = N

getB:
	li $v0,4	#print
	la $a0,msg2	#msg
	syscall		#do
	li $v0,5	#read B
	syscall		#do
	blt $v0,$s0,getB #if B < 2, goto getB
	bgt $v0,$s1,getB #if B > 10, goto getB
	add $t1,$zero,$v0 # t1 = B
	li $v0,4	#print
	la $a0,msg3	#msg
	syscall		#do
	add $a0,$zero,$t0 # a0 = N
	add $a1,$zero,$t1 # a1 = B
	jal convert #call
	li $v0,10	#exit
	syscall		#do

convert:
	#a0=A
	#a1=B
	###
	addi $sp,$sp,-16 # 4 words
	sw $s3,12($sp) # push1
	sw $s0,8($sp) # push2 
	sw $s1,4($sp) # push3 
	sw $ra,0($sp) # push4
	###
	###
	add $s0,$zero,$a0 #s0 = N
	add $s1,$zero,$a1 #s1 = B
	###
	beqz $s0,end #if==0. goto end
	div $t4,$s0,$s1 #t4= N/B
	rem $t3,$s0,$s1 #t3= N%B
	
	add $sp,$sp,-4 # 1 word 
	sw $t3,0($sp) #push5
	
	add $a0,$zero,$t4 #a0 = t4 
	###
	add $a1,$zero,$s1 #a1 = B garantia
	###
	###
	addi $s3,$s3,1	#done só uma vez... useless counter (add)?
	###
	jal convert        #call convert
	
end:
	lw $ra,0($sp) 
	lw $s1,4($sp) 
	lw $s0,8($sp) 
	lw $s3,12($sp) 
	beqz $s3,done #if==0. goto done. para ignorar o last 0 pushado
	lw $a0,16($sp) #load o t3 no a0 (pro v0 fazer os roles)
	li $v0,1	#print integer
	syscall		#do

done: 
	addi $sp,$sp,20 # inc sp
	jr $ra   #rts call
