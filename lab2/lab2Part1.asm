# Check if a string is a Palindrome

.text
.globl main 

main: 
  li $v0, 4  # print MSG1
  la $a0, MSG1 
  syscall
	
  li $v0, 8 # get string
  la $a0, INPUT
  lw $a1, INPUTSIZE
  syscall
  
####### gets the length of a strnig INCLUDING THE NEW LINE
	move $s0, $a0 # input array 
	lw $t0, INPUTSIZE # max buffer size
	add $t1, $zero, $zero # current index
	

	STRLEN: 
		beq $t1, $t0, STRLENEND
			la $t2, 0($s0) # t2 is our arr pointer
			add $t2, $t2, $t1
			lb $t3, 0($t2)
			beq $t3, $zero, STRLENEND
			addi $t1, $t1, 1
		j STRLEN

##########################################################
	STRLENEND: 
		 subi $t1, $t1, 1
		 move $s1, $t1

CHECKPALINDOME: 
	move $t0, $t1 # t0 is our string length 
	subi $t0, $t0, 1
	add $t1, $zero, $zero # t1 is our index
	
	beq $t1, $t0, PALI
		# load the byte of the normal array 
		la $t2,0($s0)
		add $t2, $t2, $t1
		lb $t2, 0($t2)
		
		# load the byte of the "reverse" array
		la $t3, 0($s0)
		move $t4, $t0
		sub $t4, $t4, $t1
		add $t3, $t3, $t4
		lb $t4, 0($t3)
		
		bne $t4, $t2, NOTPALI 
		
	
PALI:
	  li $v0, 4
  	la $a0, YES 
  	syscall
  	j END
  
NOTPALI:
	  li $v0, 4
  	la $a0, NO 
  	syscall

END: 
	li $v0, 10
	syscall

 
  

  .data

  MSG1: .asciiz "Enter String: "
  YES: .asciiz "The String is a palindrome."
  NO: .asciiz "The String is not a palindrome."
  
  # a word boundary alignment 
  .align 2

  # reserve 1024 characters for input
  INPUT: .space 1025
  INPUTSIZE: .word 1024
  
