#    Name: Demitre Lester
#    NSHE ID: 2002641576
#    Section: 1001
#    Assignment: 8
#    Description: Second MIPS program testing on SSC and recursion


.data
nArray:    .word 5, 6, 7, 8
rArray:    .word 2, 3, 3, 2
len:       .word 4

combination:.space 16

msgChoose: .asciiz " choose "
msgEqual:  .asciiz " = "
newline:    .asciiz "\n"
 
.text
.globl main

main:

# load arrays into registers
la $s0, nArray
la $s1, rArray


# create variables
li $t0, 0   # count, i = 0
lw $t1, len # t1 = length


loop:
    bge $t0, $t1, endLoop # jump to end of loop if i >= length

    ### find value of n[i] and r[i]

    # n[i]
    
    # use t9 as address index
    mul $t9, $t0, 4 
    add $t9, $s0
 
    # s2 = n[i]
    lw $s2, 0($t9) 

    # r[i]

    # use t9 as address index
    mul $t9, $t0, 4 
    add $t9, $s1

    # s3 = r[i]
    lw $s3, 0($t9)

    ### find n[i]! and r[i]!

    # find n[i]!
    move $a0, $s2 
    jal factorial
    move $s4, $v0  # make s4 hold n[i]!

    # find r[i]!
    move $a0, $s3
    jal factorial
    move $s5, $v0  # make s5 hold r[i]!
    
    ### find denominator: (n[i] - r[i])! * r[i]!

    # (n[i] - r[i])!
    sub $t9, $s2, $s3  # t9 = n[i] - r[i]
    move $a0, $t9      # load argument for factorial
    jal factorial      # call factorial function
    move $t9, $v0      # make t9 = (n[i] - r[i])!

    # s6 = denominator
    mul $s6, $t9, $s5 # multiply (n[i] - r[i])! by r[i]! 

endLoop:
   

exit:
    li $v0, 10
    syscall




# $a0 = n
factorial:

addi $sp, $sp, -8 # make space on the stack
sw $ra, 4($sp)    # save return address
sw $a0, 0($sp)    # save n being used

# base case if n <= 1
li $t4, 1
ble $a0, $t4, base

# call recursion
addi $a0, $a0, -1 # --n
jal factorial     # call factorial

# get n back
lw $t5, 0($sp)

# calculate n!
mul $v0, $t5, $v0

j endFactorial

base:

li $v0, 1        # make return value = 1

endFactorial:

lw $ra, 4($sp)   # load the saved return address
addi $sp, $sp, 8 # add 8 back to stack

# return

jr $ra



