# Calculate Factorial 
.text
.globl main 

main: 
  li $v0, 4  # print MSG1
  la $a0, MSG1 
  syscall

  li $v0, 5 # get integer 1
  syscall
  
  la $t5, INPUT1
  sw $v0, 0($t5) # store integer in t5
  
  lw $t4, 0($t5)
  addi $t3, $zero, 1 
  
LOOP: beq $t4, $zero, END 
  mul $t3, $t3, $t4
  subi $t4, $t4, 1
  j LOOP
END: 

  li $v0, 4
  la $a0, MSG2
  syscall

  li $v0, 1
  move $a0, $t3
  syscall
  

  .data

  MSG1: .asciiz "Enter Number: "
  MSG2: .asciiz "Answer: "
  
  # a word boundary alignment 
  .align 2

  # reserve a word space
  INPUT1: .space 4
  
