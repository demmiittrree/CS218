; *****************************************************************
; Name: Demitre Lester
; NSHE_ID: 2002641576
; Section: 1001
; Assignment: 6
; Description: Testing description for values or something idk
; *****************************************************************

%macro findLength 1
    mov rdx, 0  ; set counter to 0
    %%obtainLength:
        ; increment counter until null is found
        cmp byte[%1+rdx], NULL
        je %%endLength
        inc rdx
        jmp %%obtainLength
    %%endLength:
    ; once null is found, finish the macro

%endmacro

%macro cout 1

    ; Prints out the provided string
    mov rax, SYS_write
    mov rdi, STDOUT
    mov rsi, %1

    ; finds the lenght based on the provided string
    findLength %1
    syscall

%endmacro

%macro endl 0
    ; Prints out a newline only
    mov rax, SYS_write
    mov rdi, STDOUT
    mov rsi, nlMessage
    mov rdx, 1
    syscall
%endmacro

%macro pushArgs 0
    push rdi
    push rsi
    push rdx
    push rcx
    push r8
    push r9
%endmacro

%macro popArgs 0
    pop r9
    pop r8
    pop rcx
    pop rdx
    pop rsi
    pop rdi
%endmacro

section .data
TRUE equ 1
FALSE equ 0
NULL equ 0
LF equ 10
NEWLINE equ 10

SYS_read	equ	0			; system call code for read
SYS_write	equ	1			; system call code for write
SYS_open	equ	2			; system call code for file open
SYS_close	equ	3			; system call code for file close
SYS_fork	equ	57			; system call code for fork
SYS_exit	equ	60			; system call code for terminate
SYS_creat	equ	85			; system call code for file open/create
SYS_time	equ	201			; system call code for get time

O_RDONLY	equ	000000q			; file permission - read only
O_WRONLY	equ	000001q			; file permission - write only
O_RDWR		equ	000002q			; file permission - read and write

STDIN		equ	0			; standard input
STDOUT		equ	1			; standard output
STDERR		equ	2			; standard error

O_CREAT		equ	0x40
O_TRUNC		equ	0x200
O_APPEND	equ	0x400

invalidArgumentCount db "You have given an invalid command line argument. Make sure it follows this format:",NEWLINE," ./main -f <fileName> -w <word>", NULL
invalidFArgument db "Your first argument is not -f.", NEWLINE ,NULL
invalidWArgument db "Your second argument is not -w.", NEWLINE, NULL
invalidFile db "You did not open a valid file. Try Again", NEWLINE, NULL
invalidWord db "Your word has exceded the limit of MAXWORDLENGTH", NEWLINE, NULL
nlMessage db NEWLINE, NULL

BUFFSIZE equ 300000
buffIndex dq BUFFSIZE
buffCurr dq BUFFSIZE
wasEOF db 0

section .bss

buffer resb BUFFSIZE

section .text

; rdi = int argc
; rsi = char* argv[]
; rdx = int MAXWORDLENGTH
; rcx = char[] wordSaved
; r8  = long long& fileDescriptor
global checkParams
checkParams:
    ; ARGUMENT CHECK
    
    cmp rdi, 5
    je argPassed
    
    ; if argument count != 5
    cout invalidArgumentCount ; cout that the argument was invalid
    jmp returnFalse           ; since invalid, return 0

    ; if argument count == 5
    argPassed:

    ; CHECK FOR "-f"
    
    mov r9, [rsi + 1*8] ; r9 = argument 1
    ; have to compare characters to - and f
    mov al, [r9]
    cmp al, '-'
    jne arg1Failed

    ; if first char is -, check for f
    mov al, [r9+1]
    cmp al, 'f'
    jne arg1Failed

    ; make sure next is null
    mov al, [r9+2]
    cmp al, 0
    jne arg1Failed

    ; if passed
    jmp arg1Passed

    arg1Failed:
    cout invalidFArgument ; since arg1 isnt "-f", failed
    jmp returnFalse       ; since invalid, return 0
    
    arg1Passed:

    ; FILENAME CHECK
  
    ; filename would be at argv[2]
    ; array of pointers so 8bytes each
    mov rdi, [rsi + 2*8] ; make rdi = filename
    
    ; save current rsi value
    mov r9, rsi

    ; overwrite rsi for syscall
    mov rsi, 0           ; make rsi = 0 for read only
    mov rax, 2           ; syscall 2 is open file
    syscall 

    ; put r9 back into rsi
    mov rsi, r9

    ; check if file opened successfully
    cmp rax, 0 ; if >= 0, opened, if less than 0, failed
    jge openPassed
    
    ; if did not open
    cout invalidFile     ; cout that file name was invalid
    jmp returnFalse      ; since invalid, return 0

    ; if file opened
    openPassed:

    ; CHECK FOR "-w"
    
    mov r9, [rsi + 3*8] ; r9 = argument 2
    ; have to compare characters to - and w
    mov al, [r9]
    cmp al, '-'
    jne arg2Failed

    ; if first char is -, check for f
    mov al, [r9+1]
    cmp al, 'w'
    jne arg2Failed

    ; check if next char is null
    mov al, [r9+2]
    cmp al, 0
    jne arg2Failed

    ; if passed 
    jmp arg2Passed

    arg2Failed:
    cout invalidWArgument ; since arg1 isnt "-f", failed
    jmp returnFalse       ; since invalid, return 0
    
    arg2Passed:


    ; RETURN FILE DESCRIPTOR
    mov [r8], rax        ; rax holds the descriptor after a successful file read
    
    
    ; CHECK WORD LENGTH AGAINST MAX
    
    ; since word would be at arr[4]
    mov r9, [rsi + 4*8] ; make r9 = [WORD]
    ; the findLength macro saves length in rdx, so save MAXLENGTH in r10
    mov r10, rdx
    ; find length of [WORD]
    findLength r9 ; find length of r9

    ; compare length to MAXLENGTH
    cmp rdx, r10
    jl lengthPassed

    ; if length is greater or equal to MAXLENGTH
    cout invalidWord      ; cout that word length was invalid
    jmp returnFalse       ; since invalid, return 0

    lengthPassed:

    ; RETURN THE WORD VIA REFERENCE
    
    ; need to update rcx to store the word
    ; r9 holds the word, rdx holds the length
    
    mov r11, 0 ; use as a counter
    updateWord:
        cmp r11, rdx  ; is count == length
        je updateDone ; if ==, done with loop
        ; if != to length
        mov al, byte [r9 + r11]
        mov [rcx + r11], al
        
        inc r11
        jmp updateWord
    updateDone:
    ; add the terminator to the end
    mov byte [rcx + rdx], 0
    
    ; since all tests were passed
    jmp returnTrue

    ; if false, return 0
    returnFalse:
        mov rax, 0
        ret
    ; if true, return 1
    returnTrue:
        mov rax, 1
        ret
ret

; rdi = char[] wordObtained
; rsi = int MAXWORDLENGTH
; rdx = bool& isValid
; rcx = long long& fileDescriptor
global getWord
; bool getWord(chae[] wordObtained, int MAXWORDLENGTH, booth& isValid)
getWord:
    ; push before using them
    push rbx
    push r12
    push r13
    push r14

    mov r12, buffer ; set buffer address
        
    ; sysread is (fileDescriptor, buffer, count)
    push rdi        ; have to save the wordObtained location
    push rsi        ; have to save MAXWORDLENGTH
    push rdx        ; save bool &isValid location

    mov rdi, [rcx]     ; move descriptor into rdi   
    mov rsi, r12       ; move buffer into rsi
    mov rdx, BUFFSIZE  ; move BUFFSIZE into rdx as count
    mov rax, 0         ; move 0 into rax for sys_read 
    syscall            ; call sysread
    
    pop rdx         ; make rdx == to bool &isValid
    pop rsi         ; make rsi == to MAXWORDLENGTH
    pop rdi         ; make rdi == to wordObtained location again
    
    ; after sysread finished
    cmp rax, 0      ; compare bytes read to 0
    jle noRead      ; if return state is less than or equal to 0, nothing to read

    mov r13, 0      ; use to index through buffer data
    mov r14, rax    ; use as a total byte count
    mov rbx, 0      ; use to index through given word
    
    ; check for end of word (space char or less in ASCII)
    checkSpace:
        cmp r13, r14             ; check count against total number of valid bytes
        jge finish               ; if valid bytes are read, jump to finish

        mov al, byte [r12 + r13] ; make al == buffer[i]
        
        cmp al, 32               ; compare buffer[i] to space in ASCII
        jg copyWord              ; if buffer[i] is greater than space in ASCII, word is starting
        inc r13                  ; move to next character
        jmp checkSpace           ; back to start of loop
    
    copyWord:
        cmp r13, r14             ; check count against total number of valid bytes
        jge finish               ; if valid bytes are read, jump to finish
        
        mov al, byte [r12 + r13] ; make al == buffer[i]
        
        cmp al, 32               ; check if al == 32 (space in ASCII)
        jle finish               ; if its less or equal, word is done
        
        cmp rbx, rsi             ; check if char count is greater than max chars
        jge tooLong              ; if its greater or equal, too long

        mov byte [rdi + rbx], al ; make wordObtained[i] = buffer[i]
        inc rbx                  ; increment word index
        inc r13                  ; increment buffer index
        jmp copyWord             ; back to start of loop

    ; word is finished without error
    finish:
        mov byte [rdi + rbx], 0  ; add null terminator to end of string
        mov byte [rdx], 1        ; make isValid true via reference
        mov rax, 1               ; return function as true
        jmp done                 

    ; word is too long
    tooLong:
        mov byte [rdi], 0        ; add null terminator to start since invalid
        mov byte [rdx], 0        ; make isValid false via reference
        mov rax, 0               ; return function as false
        jmp done

    ; if return failed or file is empty
    noRead:
        mov byte [rdx], 0        ; make isValid false via reference
        mov rax, 0               ; return function as false

    done:
        ; pop variables i pushed
        pop r14
        pop r13
        pop r12
        pop rbx
        ret
ret

; rdi = char[] wordObtained
; rsi = char[] wordToCheck
; rdx = int& totalWords
global checkWord
checkWord:
    mov r8, 0 ; use r8 as incrementer to go through words

    ; check if words match
    wordsLoop:
        mov al, [rdi + r8] ; get wordObtained[i]
        mov bl, [rsi + r8] ; get wordToCheck[i]

        cmp al, bl         ; compare obtained to check
        jne mismatch       ; if obtained != check, words arent the same

        cmp al, 0          ; compare wordObtained[i] to 0, check for end of word
        je wordsMatch      ; since al bl comparison passed, if one ended, so does the other, and they match

        inc r8
        jmp wordsLoop
    
    ; if the words don't match
    mismatch:
        mov rax, 0 ; return 0 for false
        ret

    ; if the words DO match
    wordsMatch:
        ; since passed by reference
        mov rax, [rdx]  ; make rax equal to the actual value of rdx
        inc rax         ; increment rax 
        mov [rdx], rax  ; put new incremented value into value of rdx

        mov rax, 1      ; return 1 for true
        ret
ret

; rdi = long long fileDescriptor
global closeFile
closeFile:
    mov rax, 3
    syscall
ret

global getLength
getLength:
        mov	rax, 0
    strCountLoop2:
        cmp	byte [rdi+rax], NULL
        je	strCountLoopDone2
        inc	rax
        jmp	strCountLoop2
    strCountLoopDone2:
ret

global	printString
printString:
    ; -----
    ;  Count characters to write.

        mov	rdx, 0
    strCountLoop:
        cmp	byte [rdi+rdx], NULL
        je	strCountLoopDone
        inc	rdx
        jmp	strCountLoop
    strCountLoopDone:
        cmp	rdx, 0
        je	printStringDone

    ; -----
    ;  Call OS to output string.

        mov	rax, SYS_write			; system code for write()
        mov	rsi, rdi			; address of characters to write
        mov	rdi, STDOUT			; file descriptor for standard in
                            ; rdx=count to write, set above
        syscall					; system call

    ; -----
    ;  String printed, return to calling routine.

    printStringDone:
ret