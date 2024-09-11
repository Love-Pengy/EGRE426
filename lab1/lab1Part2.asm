.text 
.globl main



	
main:
  li $v0, 5 # get integer
  syscall
 	
 	la $t1, INPUT
 	sw $v0, 0($t1) # store input into t1
 	
 	lw $a0, 0($t1) # load input into argument 1
 	
	jal sum
	move $t0, $v0 
  li $v0, 1
  move $a0, $t0
  syscall
	j END

sum: 
	addi $sp, $sp, -8 # adjust stack for 2 items
	sw $ra, 4($sp) # save return address
	sw $a0, 0($sp) # save argument
	
	bne $a0, $zero, L1
	addi $v0, $zero, 0 # if so, result is 0
	addi $sp, $sp, 8 # pop 2 items from stack
	jr $ra # and return
	
L1: addi $a0, $a0, -1 # else decrement n
	jal sum # recursive call
	
RT: lw $a0, 0($sp) # restore original n
	lw $ra, 4($sp) # and return address
	addi $sp, $sp, 8 # pop 2 items from stack
	add $v0, $a0, $v0 # add to get result
	jr $ra # and return
	
END: 


.data 

.align 2

INPUT: .space 4
