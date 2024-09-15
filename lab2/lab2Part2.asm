# Calculate Factorial 
.text
.globl main 


main: 
  li $v0, 4  # print MSG1
  la $a0, MSG1 
  syscall

  li $v0, 5 # get integer 1
  syscall
  
  la $t0, INPUT1
  sw $v0, 0($t0) # store integer in t5
  
	lw $a0, 0($t0)
	jal factorial
	
	move $t1, $v0
	
	
  li $v0, 4
  la $a0, MSG2
  syscall

  li $v0, 1
  move $a0, $t1
  syscall

	j END

factorial: addi $sp, $sp, -4
	blt $a0, $zero ERROR
	sw $a0, 0($sp)
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	add $t0, $zero, $zero
	addi $t1, $t1, 1
FACTLOOP: beq $a0, $zero, ENDFACT
		mul $t1, $t1, $a0
		subi $a0, $a0, 1
		j FACTLOOP
ENDFACT:
	add $v0, $t1, $zero 
	lw $t0, 0($sp)
	addi $sp, $sp, 4
	lw $a0, 0($sp)
	jr $ra

ERROR: 
	li $v0, 4
	la $a0, ERR
	syscall
END: 
	addi $v0, $zero, 10
	syscall

  .data

  MSG1: .asciiz "Enter Number: "
  MSG2: .asciiz "Answer: "
  ERR: .asciiz "ERROR FACT PASSED NEGATIVE NUMBER"
  # a word boundary alignment 
  .align 2

  # reserve a word space
  INPUT1: .space 4
  
