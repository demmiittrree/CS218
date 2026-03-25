; *****************************************************************
; Name:Demitre Lester
; NSHE_ID:2002641576
; Section:1001
; Assignment:4
; Description: Macro Assignment and conversion assignment. We will be converting unvegisemal numbers
; *****************************************************************

; YOUR MACROS HERE
; tried using standard calling convention but probably used it wrong
%macro convertUnv 1
    ; 1 is the string with base 21 being converted to decimal
    mov rax, 0  ; use to keep track of final total
    mov rdi, 0  ; use for i count
    mov rsi, 0  ; use for string[i]
    mov rdx, 21 ; use as base 21
    
    %%startUnvConversion:
        mov sil, byte [%1 + rdi] ; rsi = string[i]
        cmp sil, 0               ; check if at the end of string
        je %%endUnvConversion

        ; check if number
        cmp sil, '9'             ; check if string[i] is a letter
        jle %%isNumber

        ; check if uppercase
        cmp sil, 'Z'             ; check if string[i] is an uppercase letter
        jle %%isUppercase

        ; assume its a lowercase now
        %%isLowercase:
            sub sil, 'a'         ; get value as a digit
            add sil, 10          ; add ten to even out from 0-9 actual numbers
            jmp %%unvConvert
        
        ; deal with number
        %%isNumber
            sub sil, '0'         ; get value as a digit
            jmp %%unvConvert

        ; with with uppercase
        %%isUppercase
            sub sil, 'A'         ; get value as a digit
            add sil, 10          ; add ten to even out from 0-9 actual numbers

        %%unvConvert:
            imul rax, rdx        ; multiply current total by base 21
            add rax, rsi         ; add numeric value of string[i]
        ; rax holds the total
    
        inc rdi                  ; increment i
        jmp %%startUnvConversion ; jump to top
    %%endUnvConversion:
%endmacro

; tried using standard calling convention here too
%macro findStringLength 1
    ; 1 is the string being entered
    mov rax, 0 ; rax = length
    mov rdi, 0 ; use for i count
    mov rsi, 0 ; use for string[i]
    %%lengthLoop:
        mov sil, byte [%1 + rdi] ; rsi = string[i]
        cmp sil, 0               ; check if at null terminator
        je %%endLengthLoop       ; jump to end if == 0

        ; if not the end of string
        inc rdi                  ; increment count
        jmp %%lengthLoop         ; jump back to the top

    %%endLengthLoop:
    ; after finishing length calculation
    mov rax, rdi                 ; make rax hold the final length
    inc rax                      ; increment rax one more time to include the terminator  
%endmacro

%macro printArray 3
    pushReg
        ; %1 -> array to print
        ; %2 -> address of length variable (byte)
        ; %3 -> address of endOfLineDecision maker
        mov r12, 1
        %%startArrayPrint:
            cmp r12b, byte[%2]
            jge %%endArrayPrint

            ; Used to check if the currenct check is divisible by 10
            ; If it is - print a new line
            mov rax, r12
            mov rdx, 0
            mov r11, 10
            div r11
            cmp rdx, 0
            je %%setNewLine

            ; if it is not - print a space
            mov qword[%3], 2
            jmp %%currNumberPrint

            %%setNewLine:
                mov qword[%3], 1

            %%currNumberPrint:
                printNumber qword[%1+r12*8-8], qword[%3]
            inc r12
            jmp %%startArrayPrint
        %%endArrayPrint:

        ; final line print
        endl

    popReg
%endmacro

%macro pushReg 0
    ; Pushing all registert to make it a globally compatible macro
    ; in macros we push all registers regardless of LCC
    ; This includes, arguments, return, preserve and non-preserved
    ; We do not push rsp or rip for obvious reasons
    push rax
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    push r14
    push r15
    push rbp
%endmacro

%macro popReg 0
    ; Popping all registert to make it a globally compatible macro
    pop rbp
    pop r15
    pop r14
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    pop rax
%endmacro

%macro printNumber 2
    ; Only Prints 64-bit Numbers (so sign/zero extend as needed)
    ; %1 -> number ot be printed
    ; %2 -> 0; if to print nothing after the number
    ;    -> 1; if to print new line after the number
    ;    -> 2; if to print space after the number
    pushReg
    mov rax, %1
    mov r10, 0      ; # of numbers converted
    mov r11, 10     ; base power
    mov r14, 8      ; Used to clear the stack
    mov r15, 0      ; negative flag
    mov rsi, -1     ; negative multiplicator (can be replaced with neg instead)

    %%startConversion:
        cmp rax, 0
        je %%printNumberInternal

        cmp rax, 0
        jl %%negativeDivision

            ; Transform an integer number into a string integer
            ; We only convert the remainder, the result will still be divided until we get 0
            mov rdx, 0
            div r11
            add rdx, 48
            push rdx
            inc r10
            jmp %%startConversion
        
        %%negativeDivision:
            ; Initial check to convert a negative number, into positive number
            mov r15, 1
            imul rsi
            jmp %%startConversion
    %%printNumberInternal:
        cmp r15, 0
        je %%noNegative
            ; cout for the negative sign, if it was a negative number
            mov rax, 1
            mov rdi, 1
            mov rsi, negSign
            mov rdx, 1
            syscall

        %%noNegative:
        cmp r10, 0
        jne %%printNumberInteral2

            ; For some reason this code requires a hard-coding of the cout
            ; of the number 0 - idk what I did wrong to need this, but I won't fix it now
            ; just understand that this will only run if the converted number is just the number 0.
            add r10, 48
            push r10

            mov rax, 1
            mov rdi, 1
            lea rsi, qword[rsp]
            mov rdx, 1
            syscall

            pop r10
            sub r10, 48
            jmp %%finalChecks

        %%printNumberInteral2:
        ; sets up initializer for how many digits have been printed
        mov r8, 0
        mov r13, r10 ; moved non-preserved into a preserved
        %%printTillEnd:
            ; cout the digit at the stop of the stack
            mov rax, 1
            mov rdi, 1
            lea rsi, qword[rsp+r8*8]
            mov rdx, 1
            syscall

            ; increment the check
            inc r8

            cmp r8, r13     ; once check == total number of pushes, be done.
            jl %%printTillEnd

        %%finalChecks:

        ; checks that will be done to determine if something needs to be printed or not
        ; 0 == nothing to be printed after number
        cmp %2, 0
        je %%noMorePrints

        ; 1 - to print a new line
        cmp %2, 1
        jne %%spacePrint
        endl
        jmp %%noMorePrints

        ; 2 - to print a space
        %%spacePrint:
        cmp %2, 2
        jne %%noMorePrints
        push r10
        ; prints the space and preserves the non-preserved
        ; register of 10
            mov rax, 1
            mov rdi, 1
            mov rsi, spaceMsg
            mov rdx, 1
            syscall
        pop r10

        %%noMorePrints:
            ; clears the stack
            mov rax, r10
            mul r14
            add rsp, rax
    %%endProgram_macro:
    popReg
%endmacro

%macro endl 0
    pushReg
        ; prints a new line of code
        mov rax, 1
        mov rdi, 1
        mov rsi, nlMessage
        mov rdx, 1
        syscall
    popReg
%endmacro

; Do not edit this macro - it needs to stay like this for the checks to work
%macro findLength 1
    mov rdx, 0
    %%startLoop2:
        ; find the lenght of the string
        cmp byte[%1+rdx], NULL
        je %%endLoop2
        inc rdx
        jmp %%startLoop2
    %%endLoop2:

%endmacro

%macro cout 2
    ; %1 -> message to be printed
    ; %2 -> 0; if to print nothing after the number
    ;    -> 1; if to print new line after the number
    ;    -> 2; if to print space after the number
    pushReg

    ; prints the passed in message
    mov rax, 1
    mov rdi, 1
    mov rsi, %1
    findLength %1
    syscall

    ; determines if something is to be printed after the message
    ; 0 == print nothing
    cmp %2, 0
    je %%noMorePrints

    ; 1 == print an endl
    cmp %2, 1
    jne %%spacePrint
        endl
        jmp %%noMorePrints

    ; 2 == print a space
    %%spacePrint:
        cmp %2, 2
        jne %%noMorePrints
            mov rax, 1
            mov rdi, 1
            mov rsi, spaceMsg
            mov rdx, 1
            syscall

        %%noMorePrints:

    popReg
%endmacro

; Data Declarations (provided).
section .data

; -----
; Define constants.
    NULL equ 0 ; end of string
    TRUE equ 1
    FALSE equ 0
    NEWLINE equ 10

    EXIT_SUCCESS equ 0 ; Successful operation
    SYS_exit equ 60 ; call code for terminate

    nlMessage db NEWLINE, NULL
    spaceMsg db " ", NULL
    negSign db "-", NULL
    numberMsg db "number = ", NULL
    number2Msg db "number2 = ", NULL
    lengthMsg db "length = ", NULL

    endOfLineNum db TRUE
    endOfLineStr db TRUE

    number db "A23KFG", NULL
    convertednum dq 0

    number2 db "bc8093i2", NULL
    convertednum2 dq 0

    length db 0     ; SAVE INTO THIS ONE

; -----
section .bss

section .text

global _start
_start:

    ; Code Here
    convertUnv number               ; stores value of number into rax
    mov qword [convertednum], rax   ; move rax into convertednum
    ;convertUnv number2              ; stores value of number2 into rax
    ;mov qword [convertednum2], rax  ; move rax into convertednum2
    ;findStringLength number         ; stores string length of number into rax
    ;mov byte [length], al           ; moves al (lower of rax) into length

    printsForCodeGrade: ;Do not edit - any edit here results in automatic 0
    ; *****************************************************************
        mov qword[endOfLineStr], FALSE
        cout numberMsg, qword[endOfLineStr]
        mov qword[endOfLineNum], TRUE
        printNumber qword[convertednum], qword[endOfLineNum]

        mov qword[endOfLineStr], FALSE
        cout number2Msg, qword[endOfLineStr]
        mov qword[endOfLineNum], TRUE
        printNumber qword[convertednum2], qword[endOfLineNum]

        mov qword[endOfLineStr], FALSE
        cout lengthMsg, qword[endOfLineStr]
        mov qword[endOfLineNum], TRUE
        movzx r10, byte[length]
        printNumber r10, qword[endOfLineNum]

    ; *****************************************************************
    ; Done, terminate program.

    last:
        mov rax, SYS_exit ; call code for exit (SYS_exit)
        mov rdi, EXIT_SUCCESS
        syscall
