; *****************************************************************
; Name:Demitre Lester
; NSHE_ID:2002641576
; Section:1001
; Assignment:3
; Description: Learning to use arithmetic instructions, control
;              instructions, compare instructions, and conditional
;              jump instructions(logical ops,de-referencing,arrays)
; *****************************************************************

%macro pushReg 0
    ; push all registers
    push rax
    push rdx
    push rbx
    push rcx
    push r10
    push r11
    push r12
    push r13
    push r14
    push r15
    push rdi
    push rsi
    push rbp
%endmacro

%macro popReg 0
    ; pop all registers in reverse order
    pop rbp
    pop rsi
    pop rdi
    pop r15
    pop r14
    pop r13
    pop r12
    pop r11
    pop r10
    pop rcx
    pop rbx
    pop rdx
    pop rax
%endmacro

%macro findLength 1
    ; initialize length counter to 0
    mov rdx, 0
    %%notNull:
        ; check if null, if it is return length via rdx
        cmp byte[%1+rdx], NULL
        je %%NullFound

        ; else, increment rdx
        inc rdx

        jmp %%notNull
    %%NullFound
%endmacro

%macro cout 1
    ; macro that will print to terminal
    pushReg
        mov rax, 1
        mov rdi, 1
        mov rsi, %1

        ; macro that finds the lenght of the string
        findLength %1
        syscall

        ; macro that will print a space after the cout
        mov rax, 1
        mov rdi, 1
        mov rsi, spaceMSG
        mov rdx, 1
        syscall
    popReg
%endmacro

%macro endl 0
    ; macro that will print a new line
    pushReg
        mov rax, 1
        mov rdi, 1
        mov rsi, endlMSG
        mov rdx, 1
        syscall
    popReg
%endmacro

%macro printNumber 1
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

            %%noMorePrints:
                ; clears the stack
                mov rax, r10
                mul r14
                add rsp, rax
        %%endProgram_macro:
    popReg
%endmacro

%macro printArray 4
    ; %1 => address of qword array
    ; %2 => addres of byte length
    ; %3 => # of values per line
    ; %4 => address of message to print in stars

    cout stars ; print stars message
    endl
    cout %4     ; prints passed in message
    endl
    cout stars  ; prints stars message
    endl
    endl

    mov rax, 1
    mov rbx, %3 ; sets registers to be used for line formatting
    %%arrayPrintingLoop:
        cmp al, byte[%2]
        jg %%arrayPrintingLoopDone

        lea r10, [%1+(rax*8)-8]
        printNumber qword[r10]
        cout spaceMSG

        push rax
        mov rdx, 0
        div rbx     ; fidnds the remainder of the index being checked
        pop rax
        cmp rdx, 0
        jne %%noNewLine ; if not 0, then not a new lines

            endl        ; else it is a new line

        %%noNewLine:
            inc rax
            mov rdx, 0
        jmp %%arrayPrintingLoop
    %%arrayPrintingLoopDone:
    endl
%endmacro

; Data Declarations (provided).
section .data

; -----
; Define constants.
    NULL equ 0 ; end of string
    TRUE equ 1  ; const int TRUE = 1;
    FALSE equ 0

    EXIT_SUCCESS equ 0 ; Successful operation
    SYS_exit equ 60 ; call code for terminate

    endlMSG db 10, NULL
    negSign db "-", NULL
    spaceMSG db " ", NULL
    maxMSG db "Max = ", NULL
    minMSG db "Min = ", NULL
    sumMSG db "Sum = ", NULL
    medianMSG db "Median = ", NULL
    averageMSG db "Average = ", NULL
    countMSG db "Count = ", NULL
    stars db "**********************************************",NULL
    allCheckMSG db "   Now checking stats for all!", NULL
    sevenCheckMSG db "   Now checking stats for divisible by 7", NULL
    twelveCheckMSG db "   Now checking stats for divisible by 12", NULL
    arrayAreasCheckMSG db "   Now Printing values of array cubeAreas", NULL
    arrayVolumeCheckMSG db "   Now Printing values of array cubeVolumes", NULL

    min dq 0
    max dq 0
    sum dq 0
    estMedian dq 0
    average dq 0

    countSeven dq 0
    sumSeven dq 0
    averageSeven dq 0

    countTwelve dq 0
    sumTwelve dq 0
    averageTwelve dq 0

    seven dw 7
    twelve dw 12
    two dw 2

    lst dd -13313, -4046, 15756, -22097, 29302, 29193, -24441, 2992, -6634,
        dd -12924, 2412, -8420, 2368, -31556, 2398, 19889, 2332, 4815,
        dd -23708, -21928, -213, 16347, -6039, 14866, -8356, -15818, 29261,
        dd -2103, 11324, -28971, 23778, 1740, -18859, -3834, 12848, -17334,
        dd 25488, 21708, -10079, 29675, 4499, 7254, -27277, -21072, -5307,
        dd 7305, 21812, -19875, 5384, -939, 18544, 16723, -2499, 24410,
        dd -5292, 11634, -32739, 19302, -32416, -17213, -10716, 25786, 10956,
        dd 19405, 11515, 14407, 1747, 24429,

    aSides dd 11478, 23131, 27238, -19188, 12141, -26202, -22333, 26180, 5780,
        dd -23593, 24253, 15018, -27513, -22110, -32469, -6759, 3822, 15299,
        dd 18097, -24444, 20548, 2756, 18118, -4858, -24506, -3210, -15724,
        dd 8537, 30062, -31589, 19087, 2206, -734, -20793, -4870, 29019,
        dd -32583, 3746, 1312, -14025, 135, 17226, -16267, 4482, 18182,
        dd -23310, -10146, 20192, -31881, 26377, 24496, -3096, -32220, -26413,
        dd 24822, -1755, -3810, -701, 30340, -21331, 18331, 2858, -26515,
        dd -27818, 14371, -8276, -25361, 29870,

    bSides dd -23338, 24092, 25145, -23970, 78, -6063, 28960, 27206, 27353,
        dd -2089, 31600, -20464, 18932, 20912, 25126, -31511, 24098, -16245,
        dd 31074, -21977, 15280, -12015, 9669, 2729, -10789, 5519, -5149,
        dd -30190, -25535, -29645, -20987, -29854, -22587, -24792, 5911, 16199,
        dd 20905, -29149, 22272, -31486, -14319, 4749, 5866, 2276, 12602,
        dd 19769, -825, 12757, 19831, 19721, -12417, -24495, -4579, -8403,
        dd -22995, -8318, 7783, -28927, 27757, -3805, -25305, -96, 18626,
        dd 30148, 4051, 24880, 3355, -20244,

    len db 68


; -----
section .bss
    cubeAreas resq 68      
    cubeVolumes resq 68     

section .text

global _start
_start:
    mov rdi, 0
    startInitLoop:
        cmp dil, byte[len]
        je endInitLoop
        
        mov qword[cubeAreas+rdi*8], 0
        mov dword[cubeVolumes+rdi*4], 0

        inc rdi
        jmp startInitLoop

    endInitLoop: 

    ; YOUR CODE HERE
    
    
    ; traverse array lst and get the:
    ; min, max, estMedian, sum, avg
    ; count, sum, avg for numbers divisble by 7
    ; count, sun, avg for numbers divisble by 12

    ; make for loop
    mov rbx, 0 ; sum = 0
    ; had to use r8 instead of rcx since i use it in later stuff
    mov r8, 0  ; i = 0

    ; set min and max to first value in array
    mov eax, dword [lst] ; eax = lst [0]
    cdqe                 ; convert eax to rax
    mov qword [min], rax ; min = lst [0]
    mov qword [max], rax ; max = lst [0]
    
    sumLoop: ; label to jump to
        mov eax, 0          ; clear EAX since i made it lst[0]
        mov al, byte [len]  ; move length into AL
        cmp r8, rax         ; check i against array length
        jge done            ; jump to "done" label if rax >= length

        ; minimum comparison
        mov eax, dword [lst + r8*4] ; make eax = lst[i]
        cmp eax, dword [min]        ; compare arr[i] to min
        jge finishMin               ; if arr[i] >= min, skip min instructions
        mov dword [min], eax        ; update min to arr[i]
        finishMin:

        ; maximum comparison
        mov eax, dword [lst + r8*4] ; make eax = lst [i]
        cdqe                        ; extend eax to rax
        cmp rax, qword [max]        ; compare arr[i] to max
        jle finishMax               ; if arr[i] <= max, skip max instructions
        mov qword [max], rax        ; update max to arr[i]
        finishMax:

        ; check if divisible by 7
        mov eax, dword [lst + r8*4]  ; eax = lst[i]
        cdq                          ; sign extend eax to eax:edx
        mov ecx, 7                   ; divisor is now 7
        idiv ecx                     ; divide eax:edx by ecx
        cmp edx, 0                   ; check if remainder = 0
        jne checkSeven               ; if remainder != 0

        ; if IS divisible by seven
        inc qword [countSeven]       ; increment countSeven
        mov eax, dword [lst + r8*4]  ; eax = lst[i]
        cdqe                         ; sign extend eax to rax
        add qword [sumSeven], rax    ; add lst[i] to sumSeven
        checkSeven:

        ; check if divisible by 12
        mov eax, dword [lst + r8*4] ; eax = lst[i]
        cdq                          ; sign extend eax to eax:edx
        mov ecx, 12                  ; divisor is now 12
        idiv ecx                     ; divide eax:edx by ecx
        cmp edx, 0                   ; check if remainder = 0
        jne checkTwelve              ; if remainder != 0

        ; if IS divisible by twelve
        inc qword [countTwelve]      ; increment countTwelve
        mov eax, dword [lst + r8*4]  ; eax = lst[i]
        cdqe                         ; sign extend eax to rax
        add qword [sumTwelve], rax   ; add lst[i] to sumTwelve
        checkTwelve:
        
        ; find sum
        mov eax, dword [lst + r8*4]  ; eax = lst[i]
        cdqe                         ; extend eax to rax
        add rbx, rax                 ; add arr[i] to sum

        ; increment value of i
        inc r8 ; i++

        ; jump back to top of loop
        jmp sumLoop
    done:

    ; set sum
    mov qword [sum], rbx     ; store rbx in sum
                                     
    ; find average
    mov rax, rbx             ; move rbx (sum) into rax so it can be divided
    cqo                      ; sign extend rax to rax:rdx
    mov ecx, [len]           ; move length into ecx
    idiv ecx                 ; divide eax / ecx
    mov qword [average], rax ; move eax into avg

    ; find estMedian
    ; since len = 68 & arrays are 0 indexed,
    ; middle values are 33, 34, and last is 67
    mov eax, dword [lst]        ; first value in array
    mov ecx, dword [lst + 33*4] ; first middle value
    add eax, ecx                ; add first value and first middle
    mov ecx, dword [lst + 34*4] ; second middle value
    add eax, ecx                ; add second middle value to other values
    mov ecx, dword [lst + 67*4] ; last value
    add eax, ecx                ; add last value to other values
    ; eax holds the sum of the 4 values
    cdq                         ; sign extend to eax:edx
    mov ecx, 4                  ; divisor is now 4
    idiv ecx                    ; divide eax:edx by 4
    mov dword [estMedian], eax  ; move quotient into median

    ; find 7 average
    mov rax, qword [sumSeven]     ; move sum of sevens into rax
    cqo                           ; extend rax to rax:rdx
    mov rcx, qword [countSeven]   ; move seven count into rbx
    idiv rcx                      ; divide rax:rdx by seven count
    mov qword [averageSeven], rax ; move quotient into averageSeven

    ; find 12 average
    mov rax, qword [sumTwelve]     ; move sum of twelves into rax
    cqo                            ; extend rax to rax:rdx
    mov rcx, qword [countTwelve]   ; move twelve count into rbx
    idiv rcx                       ; divide rax:rdx by twelve count
    mov qword [averageTwelve], rax ; move quotient into averageTwelve



; ***************************************************
;   NO EDITS HAPPEN HERE - THIS IS TO CHECK OUTPUT
; ***************************************************
    cout stars
    endl
    cout allCheckMSG
    endl
    cout stars
    endl
    endl

    cout maxMSG
    printNumber qword[max]  ; prints max
    endl

    cout minMSG
    printNumber qword[min]  ; prints min
    endl

    cout sumMSG
    printNumber qword[sum]  ; prints sum
    endl

    cout averageMSG
    printNumber qword[average]  ; pritns average
    endl

    cout medianMSG
    printNumber qword[estMedian]  ; prints EstMedian
    endl
    endl

    cout stars
    endl
    cout sevenCheckMSG      ; prints message for the seven divisible check
    endl
    cout stars
    endl
    endl

    cout countMSG
    printNumber qword[countSeven]   ; prits the count of seven
    endl

    cout sumMSG
    printNumber qword[sumSeven]     ; pritns the sum of seven
    endl

    cout averageMSG
    printNumber qword[averageSeven] ; pritns average of seven
    endl

    cout stars
    endl
    cout twelveCheckMSG     ; prints message for disible by 12
    endl
    cout stars
    endl
    endl

    cout countMSG
    printNumber qword[countTwelve]  ; prints count of 12
    endl

    cout sumMSG
    printNumber qword[sumTwelve]    ; prints sum of 12
    endl

    cout averageMSG
    printNumber qword[averageTwelve]    ; prints average of 12
    endl

    printArray cubeAreas, len, 10, arrayAreasCheckMSG
    printArray cubeVolumes, len, 10, arrayVolumeCheckMSG
; ***************************************************
;   in c++ this would be the return 0; part of main
; ***************************************************
    last:
        mov rax, SYS_exit ; call code for exit (SYS_exit)
        mov rdi, EXIT_SUCCESS
        syscall
