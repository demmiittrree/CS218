section .data
;Constants
WALL        equ 'x'
GOAL        equ 'o'
EMPTY       equ ' '
SEARCHED    equ '.'

DIGITS      db  "0123456789"

NULL        equ 0
LF          equ 10
global NEW_LINE
NEW_LINE    db  LF, LF

TRUE        equ 1
FALSE       equ 0

;Syscall constants for printing
SYS_WRITE   equ 1
STDOUT      equ 1

;First maze
LENGTH1 equ 5
HEIGHT1 equ 5
maze1   db  "xxxxx",
        db  "x xox",
        db  "x x x",
        db  "x   x",
        db  "xxxxx"
START_POS_X_1 equ   1
START_POS_Y_1 equ   1

;Second maze
LENGTH2 equ 8
HEIGHT2 equ 10
maze2   db  "xxxxxxxx",
        db  "     x  ",
        db  "xxxx x x",
        db  "x  x x x",
        db  "xo x x x",
        db  "x  x x x",
        db  "x  xxx x",
        db  "x      x",
        db  "x      x",
        db  "xxxxxxxx"

START_POS_X_2   equ 4
START_POS_Y_2   equ 5

;Third maze (not findable)
LENGTH3 equ 8
HEIGHT3 equ 10
maze3   db  "xxxxxxxx",
        db  "        ",
        db  "xxxx x x",
        db  "x  x x x",
        db  "xo x x x",
        db  "x  x x x",
        db  "xxxxxx x",
        db  "x      x",
        db  "x      x",
        db  "xxxxxxxx"

START_POS_X_3   equ 4
START_POS_Y_3   equ 5

;Exit syscall
SYS_exit equ 60
EXIT_SUCCESS equ 0

section .text

;Wraps an (x, y) position around the sides of the maze and to the other side
;%1 = x     [32-bit]
;%2 = y     [32-bit]
;%3 = width [32-bit]
;%4 = height[32-bit]
;Wrapped positions placed in x and y arguments, overwriting non-wrapped ones
;This is an optimized version that does not work if x <= -WIDTH or y <= -HEIGHT
%macro wrapAround 4
    ;Wrap around x
    mov eax, %1
    add eax, %3
    mov edx, 0
    div %3
    mov %1, edx

    ;Wrap around y
    mov eax, %2
    add eax, %4
    mov edx, 0
    div %4
    mov %2, edx
%endmacro

;Macro for the isGoalReachable function to see current position.
%macro debugSeeCurrentPos 0
    ;Print a message about the searching position
    mov rax, SYS_WRITE  ;Prepare to write
    mov rdi, STDOUT     ;Write to stdout (default is terminal)
    mov rsi, SEARCH_MSG   ;Move string reference to rsi
    mov rdx, SEARCH_MSG_LEN
    syscall

    ;Print x
    mov rdi, r12
    call printInteger

    mov rax, SYS_WRITE  ;Prepare to write
    mov rdi, STDOUT     ;Write to stdout (default is terminal)
    mov rsi, COMMA_SPACE;Move string reference to rsi
    mov rdx, COMMA_SPCAE_LEN
    syscall

    ;Print y
    mov rdi, r13
    call printInteger

    mov rax, SYS_WRITE  ;Prepare to write
    mov rdi, STDOUT     ;Write to stdout (default is terminal)
    mov rsi, PAREN_ENDL;Move string reference to rsi
    mov rdx, PAREN_ENDL_LEN
    syscall

%endmacro

;Prints a message with the character at the current spot in the array.
;Takes a single argument, the linearized index
%macro debugSeeCurrentChar 1
    push r12
    mov %1, r12

    mov rax, SYS_WRITE  ;Prepare to write
    mov rdi, STDOUT     ;Write to stdout (default is terminal)
    mov rsi, CHAR_MSG   ;Move string reference to rsi
    mov rdx, CHAR_MSG_LEN
    syscall

    mov rax, SYS_WRITE  ;Prepare to write
    mov rdi, STDOUT     ;Write to stdout (default is terminal)
    mov rsi, [rbx + r12] ;Move string reference to rsi
    mov rdx, 1
    syscall

    mov rax, SYS_WRITE  ;Prepare to write
    mov rdi, STDOUT     ;Write to stdout (default is terminal)
    mov rsi, NEW_LINE   ;Move string reference to rsi
    mov rdx, 1
    syscall

    pop r12
%endmacro

;Function labels
global _start
global isGoalReachable
global int2String
extern printInteger ;extern means it's in another file (you can still call it like normal)
extern printMaze 
extern solveMaze
extern convertToLinear

;----------------------- Program starts here -----------------------
_start:

;Please do not modify this main.

;******** Test int2String ********
mov edi, 4
call printInteger
mov rax, SYS_WRITE  ;Prepare to write
mov rdi, STDOUT     ;Write to stdout (default is terminal)
mov rsi, NEW_LINE
mov rdx, 1
syscall

mov edi, 10
call printInteger
mov rax, SYS_WRITE  ;Prepare to write
mov rdi, STDOUT     ;Write to stdout (default is terminal)
mov rsi, NEW_LINE
mov rdx, 1
syscall

mov edi, 368
call printInteger
mov rax, SYS_WRITE  ;Prepare to write
mov rdi, STDOUT     ;Write to stdout (default is terminal)
mov rsi, NEW_LINE
mov rdx, 2
syscall

afterInt2String:    ;Exists for debugging

;******** Test first maze ********
mov rdi, maze1
mov rsi, START_POS_X_1
mov rdx, START_POS_Y_1
mov rcx, LENGTH1
mov r8, HEIGHT1
call solveMaze

afterFirstMaze:     ;Exists for debugging

;******** Test second maze ********
mov rdi, maze2
mov rsi, START_POS_X_2
mov rdx, START_POS_Y_2
mov rcx, HEIGHT2
mov r8, LENGTH2
call solveMaze

afterSecondMaze:    ;Exists for debugging

;******** Test third maze ********
;######### TODO: Load the arguments for the third maze and call the solveMaze function in maze.asm

mov rdi, maze3
mov rsi, START_POS_X_3
mov rdx, START_POS_Y_3
mov rcx, HEIGHT3
mov r8, LENGTH3
call solveMaze
; finished loading third maze

afterThirdMaze:     ;Exists for debugging

;Exiting the program
last:
    mov eax, SYS_exit  ;Load the syscall code for terminating the program
    mov edi, EXIT_SUCCESS ;Load the exit value for the program into rdi
    syscall

;Converts the passed integer to a string
;void int2String(int n, string& str)
;edi = n (the integer to convert to a string)
;rsi = Reference to string to store result. Already allocated.
;edx = Length of the string

int2String:
    ;######### TODO: Write the code to convert an integer to a string in decimal
   
    ; move n into rax
    mov rax, rdi
    ; move 10 into r8d for dividing
    mov r8d, 10
    ; save length of string
    mov rcx, rdx

    digitsLoop:
        ; if n == 0
        cmp rax, 0                 ; compares n to 0
        je endDigitsLoop           ; jump to end if == 0

        ; if n != 0
        mov rdx, 0                 ; clear 
        div r8d                    ; divide rax by r8d
        
        add dl, '0'                ; make DL == ASCII char 0
        mov [rsi + rcx - 1], dl    ; move to the end of string, last digit
        dec rcx                    ; decrement length 

        jmp digitsLoop             ; jump back to the top
    endDigitsLoop:

    ret

;Determines if the maze can be solved starting from the given x, y position
;bool isGoalReachable(char maze[], int start_x, int start_y, int height, int width)
;rdi = Reference to maze. Maze is 2D, although it is linearized.
;esi = start_x
;edx = start_y
;ecx = height
;r8d = width
;rax = Did the position lead to the goal?
;See handout pdf for solution in C++
isGoalReachable:

    ;Prologue
    push rbx
    push r12
    push r13
    push r14
    push r15

    ;Preserve original arguments. Needed because other function calls may overwrite the registers they are in. 
    ;Saved registers *should* be the same before and after a functiona call by SCC.
    mov rbx, rdi ;Reference in rbx
    mov r12, rsi ;x in r15
    mov r13, rdx ;y in r12
    mov r14, rcx ;height in r14
    mov r15, r8  ;width in r15

    ;Wrap around any positions to the other side of the array
    wrapAround r12d, r13d, r15d, r14d

    ;debugSeeCurrentPos ;Uncomment this to see the current position being visited

    ;########## TODO: Finish the code to tell if the maze can be solved.

    ;C++ implementation for your reference. Intentionally verbose to help with translation to assembly.
    ;bool isGoalReachable(char maze[], int start_x, int start_y, int height, int width) {
    ;
    ;wrapAround(&start_x, &start_y, width, height); //Wrap around coordinates to other side of maze if applicable
    ;int linearizedIndex = convertToLinear(width, start_x, start_y);
    ;
    ;//Base case
    ;if(maze[linearizedIndex] == GOAL) //If goal, return true
    ;   return true;
    ;else if(maze[linearizedIndex == WALL) //If this is a wall, return to the last space and return false
    ;   return false;
    ;else if(maze[linearizedIndex == SEARCHED) //If this space has been searched already, return to last space and return false
    ;   return false;
    ;
    ;maze[linearizedIndex] = SEARCHED; //Mark this spot as searched
    ;
    ;//Otherwise, search adjacent spaces
    ;int nextX, nextY;
    ;nextX = start_x - 1; //Try left space
    ;nextY = start_y;
    ;bool foundGoal = isGoalReachable(nextX, nextY);
    ;if(foundGoal) return true;
    ;
    ;Proceed to do the other three directions
    ;
    ;return false; //Return false if all four directions did not yield a path to the goal
    ;
    ;}
    
    ;Epilogue (Please complete the proper epilogue to match the given prologue)

    ret
