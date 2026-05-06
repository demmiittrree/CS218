#    Name: Demitre Lester
#    NSHE ID: 2002641576
#    Section: 1001
#    Assignment: 7
#    Description: First Mips program of the semester, used to see knowledge on instructions

.data
    aSides: .word -4829, 6832, -7601, 1234, 4492
            .word 2918, 1111, 0231, -5523, 1121
            .word 0020, -0341, 7811, 2031, -9421
            .word 1414, 0082, 4712, 1239, -0236
            .word 9956, -8268, -4167, 8744, 1050
            .word 4781, -5237, -2574, 4382, -7780
            .word -4823, 1590, 7248, -3112, 0667
            .word 8321, -9542, 0470, -2999, 1234
            .word -6754, 8881, -234, 4509, -1122
            .word 3901, -0789, 5643, -9998, 2710

    aMin:   .word   0
    aMax:   .word   0
    aSum:   .word   0
    aAvg:   .word   0

    maxMsg: .asciiz "Max = "
    minMsg: .asciiz "Min = "
    sumMsg: .asciiz "Sum = "
    avgMsg: .asciiz "Avg = "
    newLineMsg: .asciiz "\n"

    arrayPrinting: .ascii "    Printing Array \n"
                .asciiz "========================\n"

    cSides: .space 40

    cMin:   .word   0
    cMax:   .word   0
    cSum:   .word   0
    cAvg:   .word   0

    len:    .word  50

.text

.globl main
.ent main
main:
   
    # YOUR CODE HERE
    
    # array
    la $t0, aSides # load aSides array into t0
    
    # loop control
    lw $t1, len    # load length variable (word) into t1
    li $t2, 0      # load 0 into t2, use as i
    
    # variables
    li $t3, 0      # load 0 into t3, use as sum
    lw $t4, 0($t0) # load arr[0] into t4, use as min
    lw $t5, 0($t0) # load arr[0] into t5, use as max

    loop:
        beq $t2, $t1, endLoop   # if i == len, end loop
        
        mul $t6, $t2, 4         # compute index to traverse array (t6)
        add $t6, $t0, $t6       # make t6 hold current address of aSides[i]

        lw $t7, 0($t6)          # t7 = aSides[i]

        # update sum
        add $t3, $t3, $t7       # t3 = t3 + t7

        # update min
        slt $t8, $t7, $t4       # check if aSides[i] < min
        beq $t8, $zero, passMin # if not less than, skip updating min
        move $t4, $t7           # move aSides[i] into min

        passMin: 
        # update max
        slt $t8, $t5, $t7       # check if max < aSides[i]
        beq $t8, $zero, passMax # if not less than, skip updating max
        move $t5, $t7           # move aSides[i] into max


        passMax:
        # update i and jump
        addi $t2, $t2, 1        # increment i variable
        j loop

    endLoop:

    # find average and variables
    div $t3, $t1 # sum / length = average
    mflo $t9     # t9 = average (quotient)

    # store registers into memory
    sw $t4, aMin
    sw $t5, aMax
    sw $t3, aSum
    sw $t9, aAvg


    # CSIDES LOOP

    # just in case
    la $t0, aSides

    # using saved registers
    lw $s1, 0($t0) # load aSides[0] into MIN
    lw $s2, 0($t0) # load aSides[0] into MAX
    li $s3, 0      # load 0 into         SUM
    lw $s4, len    # load len into s4    LEN

    # use temp for other stuff
    li $t1, 0      # make t1 hold COUNT
    li $t2, 0      # make t2 hold INDEX
    li $t3, 0      # make t3 hold cSideSum
    li $t4, 0      # make t4 hold i
    la $t5, cSides # make t5 hold cSides address
    
    cLoop:
        bge $t4, $s4, endCLoop  # make sure i < len

        mul $t6, $t4, 4         # make t6 hold true i
        add $t6, $t6, $t0       # make t6 = addres of aSides[i]
        lw $t7, 0($t6)          # make t7 = aSides[i]

        # get sum
        add $s3, $s3, $t7       # sum += aSides[i]
        add $t3, $t3, $t7       # cSideSum += aSides[i]

        # increment count
        addi, $t1, $t1, 1       # ++count

        bne $t1, 5, skipUpdate  # if count != 5, skip updating cSides

        # if count == 5
        mul $t6, $t2, 4         # make t6 hold true index
        add $t6, $t6, $t5       # make t6 = address of cSides[index]
        
        sw $t3, 0($t6)          # make cSides[index] = cSideSum
    
        # check if cSides[index] (cSideSum) < min
        bge $t3, $s1, skipMin   # if cSideSum >= min, skip

        # if cSideSum < min
        move $s1, $t3           # min = cSideSum

        skipMin:
        
        #check if cSides[index] (cSideSum) > max
        ble $t3, $s2, skipMax   # if cSideSum <= max, skip

        # if cSideSum > max
        move $s2, $t3

        skipMax:
        
        li $t1, 0               # make count = 0 again
        li $t3, 0               # make cSideSum = 0 again

        addi $t2, $t2, 1        # increment index

        skipUpdate:

        addi $t4, $t4, 1        # increment i
        j cLoop                 # jump back to top of cLoop
        
    endCLoop:

    div $s3, $t2      # divide sum by index
    mflo $t9          # make t9 hold quotient

    # store registers into memory
    sw $s1, cMin
    sw $s2, cMax
    sw $s3, cSum
    sw $t9, cAvg


    # DANGER!!!!!!!! PRINTS - DO NOT EDIT

    la $a0, aMax
    la $a1, aMin
    la $a2, aSum
    la $a3, aAvg
    jal printStats

        li $v0, 4
        la $a0, newLineMsg
        syscall

        li $v0, 4
        la $a0, arrayPrinting
        syscall

    la $a0, cSides
    li $a1, 10
    jal printArrayFunc

        li $v0, 4
        la $a0, newLineMsg
        syscall
    la $a0, cMax
    la $a1, cMin
    la $a2, cSum
    la $a3, cAvg
    jal printStats

    li $v0, 10
    syscall

.end main

.globl printArrayFunc
.ent printArrayFunc
printArrayFunc:
    # preservering registers
    subu $sp, $sp, 20
    sw $s2, 12($sp)
    sw $s1, 8($sp)
    sw $s0, 4($sp)
    sw $ra, ($sp)

    # setting up values
    li $s0, 0
    move $s1, $a0

    printNums:
        bge $s0, $a1, endPrintNums2 # need more comments so students don't fail

        li $v0, 1
        lw $a0, ($s1)
        syscall # need more comments so students don't fail

        # printing spaces unless its the 8th one
        li $t1, 7
        rem $t0, $s0, 8
        beq $t0, $t1, newLinePrint 
            li $v0, 11
            li $a0, 32
            syscall # need more comments so students don't fail

            b nextIndex

        # printing new line
        newLinePrint:
            li $v0, 11
            li $a0, 10
            syscall # need more comments so students don't fail

        # next values
        nextIndex:
        addu $s0, $s0, 1
        addu $s1, $s1, 4
        b printNums # need more comments so students don't fail

    # restoring values
    endPrintNums2:
    lw $ra, ($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    addu $sp, $sp, 20 # need more comments so students don't fail
jr $ra
.end printArrayFunc

.globl printStats
.ent printStats
printStats:
    # preserving fp
    subu $sp, $sp, 4
    sw $fp, ($sp)
    move $fp, $sp

    # preserving all preserves
    subu $sp, $sp, 20
    sw $s3, 16($sp)
    sw $s2, 12($sp)
    sw $s1, 8($sp)
    sw $s0, 4($sp)
    sw $ra, ($sp) # try number 2 so students don't fail comment count

    # saving args into saved
    move $s0, $a0
    move $s1, $a1
    move $s2, $a2
    move $s3, $a3 # try number 2 so students don't fail comment count

    # printing max
    li $v0, 4
    la $a0, maxMsg
    syscall # try number 2 so students don't fail comment count

    li $v0, 1
    lw $a0, ($s0)
    syscall # try number 2 so students don't fail comment count

    li $v0, 4
    la $a0, newLineMsg
    syscall # try number 2 so students don't fail comment count

    # printing min
    li $v0, 4
    la $a0, minMsg
    syscall

    li $v0, 1
    lw $a0, ($s1)
    syscall # try number 2 so students don't fail comment count

    li $v0, 4
    la $a0, newLineMsg
    syscall # try number 2 so students don't fail comment count

    # printing sum
    li $v0, 4
    la $a0, sumMsg
    syscall

    li $v0, 1
    lw $a0, ($s2)
    syscall # try number 2 so students don't fail comment count

    li $v0, 4
    la $a0, newLineMsg
    syscall # try number 2 so students don't fail comment count 

    # printing avg
    li $v0, 4
    la $a0, avgMsg
    syscall # try number 2 so students don't fail comment count

    li $v0, 1
    lw $a0, ($s3)
    syscall # try number 2 so students don't fail comment count

    li $v0, 4
    la $a0, newLineMsg
    syscall # try number 2 so students don't fail comment count

    # restoring preserves
    lw $ra, ($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    lw $s3, 16($sp)
    addu $sp, $sp, 20 # try number 2 so students don't fail comment count

    # restoring fp
    lw $fp, ($sp)
    addu $sp, $sp, 4
jr $ra
.end printStats