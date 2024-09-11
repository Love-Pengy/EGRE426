.text
.globl main

main:
	la $s0, INPUT 
	lw $s1, INPUTSIZE
	subi $s1, $s1, 1 # one for index, one for loop 
	addi $t0, $zero, 1 # count variable
	
SORTOFTHEBUBVARIETY: beq $t0, $zero, PRINTLOOP
	add $t0, $zero, $zero 
	add $t1, $zero, $zero # i
	
SORTLOOP: beq $t1, $s1, CHECKCOUNT
		la $t2, 0($s0)
		mul $t3, $t1, 4
		add $t2, $t2, $t3
		lw $t3, 0($t2)
		
		addi $t5, $t2, 4
		
		lw $t4, 0($t5)
		
		bgt $t3, $t4, SWAP
		addi $t1, $t1, 1
		j SORTLOOP
		
CHECKCOUNT: 
		beq $t0, $zero, PRINTLOOP
		addi $t1, $t1, 1
		j SORTOFTHEBUBVARIETY
		
SWAP: 
	sw $t3, 0($t5)
	sw $t4, 0($t2)
	addi $t0, $t0, 1
	j SORTLOOP
		
PRINTLOOP: 
	lw $s1, INPUTSIZE
	add $t0, $zero, $zero
	la $s2, SPACE
	PRINT: beq $t0, $s1, END
		mul $t2, $t0, 4
		
		la $t3, 0($s0)
		add $t3, $t3, $t2
		
		lw $t2, 0($t3)
		
		li $v0, 1
		move $a0, $t2
		syscall
		
		li $v0, 4
		move $a0, $s2
		syscall 
		
		addi $t0, $t0, 1
	j PRINT
		
END: 

	li $v0, 10
	syscall


.data 


INPUT: .word 0, 10, 14, 2, -1
INPUTSIZE: .word 5
SPACE: .asciiz " "
.align 2
