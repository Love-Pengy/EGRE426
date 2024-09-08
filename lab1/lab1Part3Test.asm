
.text
.globl main 

# lets try to print an array 
main: 
la $s0, inputArr
la $s1, outputArr
lw $t0, inputArrSize 
sub $t0, $t0, 1
# $t1 our temp variable for the offset
# $t2 is our input value
# $t3 is our input array temp
# $t4 is our temp output array

li $v0, 4
la $a0, MSG2
syscall
  
PRINTLOOP: beq $t0, -1, END

	##################
	#     INPUT      #
	##################
	sll $t1, $t0, 2 # multiply by 4
	la $t3, 0($s0) 
	add $t3, $t3, $t1 # add offset to arr
	
	
	##################
	#     OUTPUT     #
	##################
	lw $t1, inputArrSize
	sub $t1, $t1, $t0 # calculate output index
	sll $t1, $t1, 2 # multiply by 4
	
	la $t4, 0($s1) # load output array 
	add $t4, $t4, $t1 # offset to calculated index
	
	lw $t4, 0($t3)
	
	li $v0, 1
	move $a0, $t4
	syscall
		
	subi $t0, $t0, 1
  j PRINTLOOP
END: 

  .data

  MSG1: .asciiz "Enter Number: "
  MSG2: .asciiz "Answer: "
  inputArr: .word -1, 1, 2, 3, 4
  outputArr: .word 5
  inputArrSize: .word 5

  # a word boundary alignment 
  .align 2

  # reserve a word space
  INPUT1: .space 4
  


