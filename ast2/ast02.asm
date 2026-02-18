; *****************************************************************
;  Name: Demitre Lester
;  NSHE_ID:2002641576
;  Section: 1001
;  Assignment: 2
;  Description: Assembly language arithmetic operations.
;		Formulas provided on assignment.
;		Focus on learning basic arithmetic operations
;		(add, subtract, multiply, and divide).
;		Ensure understanding of sign and unsigned operations.

; *****************************************************************
;  Data Declarations (provided).


section	.data

; -----
;  Define constants.

NULL		equ	0			; end of string

TRUE		equ	1
FALSE		equ	0

EXIT_SUCCESS	equ	0			; Successful operation

SYS_exit	equ	60			; call code for terminate

; -----
;  Assignment #3 data declarations

; byte data
bNum1		db	34
bNum2		db	21
bNum3		db	19
bNum4		db	15
bNum5		db	-46
bNum6		db	-69
bAns1		db	0
bAns2		db	0
bAns3		db	0
bAns4		db	0
bAns5		db	0
bAns6		db	0
bAns7		db	0
bAns8		db	0
bAns9		db	0
bAns10		db	0
wAns11		dw	0
wAns12		dw	0
wAns13		dw	0
wAns14		dw	0
wAns15		dw	0
bAns16		db	0
bAns17		db	0
bAns18		db	0
bRem18		db	0
bAns19		db	0
bAns20		db	0
bAns21		db	0
bRem21		db	0

; word data
wNum1		dw	2356
wNum2		dw	1953
wNum3		dw	821
wNum4		dw	319
wNum5		dw	-1753
wNum6		dw	-1276
wAns1		dw	0
wAns2		dw	0
wAns3		dw	0
wAns4		dw	0
wAns5		dw	0
wAns6		dw	0
wAns7		dw	0
wAns8		dw	0
wAns9		dw	0
wAns10		dw	0
dAns11		dd	0
dAns12		dd	0
dAns13		dd	0
dAns14		dd	0
dAns15		dd	0
wAns16		dw	0
wAns17		dw	0
wAns18		dw	0
wRem18		dw	0
wAns19		dw	0
wAns20		dw	0
wAns21		dw	0
wRem21		dw	0

; double-word data
dNum1		dd	4365870
dNum2		dd	132451
dNum3		dd	18671
dNum4		dd	8473
dNum5		dd	-217982
dNum6		dd	-215358
dAns1		dd	0
dAns2		dd	0
dAns3		dd	0
dAns4		dd	0
dAns5		dd	0
dAns6		dd	0
dAns7		dd	0
dAns8		dd	0
dAns9		dd	0
dAns10		dd	0
qAns11		dq	0
qAns12		dq	0
qAns13		dq	0
qAns14		dq	0
qAns15		dq	0
dAns16		dd	0
dAns17		dd	0
dAns18		dd	0
dRem18		dd	0
dAns19		dd	0
dAns20		dd	0
dAns21		dd	0
dRem21		dd	0

; quadword data
qNum1		dq	1204623
qNum2		dq	1043819
qNum3		dq	415331
qNum4		dq	251197
qNum5		dq	-921028
qNum6		dq	-281647
qAns1		dq	0
qAns2		dq	0
qAns3		dq	0
qAns4		dq	0
qAns5		dq	0
qAns6		dq	0
qAns7		dq	0
qAns8		dq	0
qAns9		dq	0
qAns10		dq	0
dqAns11		ddq	0
dqAns12		ddq	0
dqAns13		ddq	0
dqAns14		ddq	0
dqAns15		ddq	0
qAns16		dq	0
qAns17		dq	0
qAns18		dq	0
qRem18		dq	0
qAns19		dq	0
qAns20		dq	0
qAns21		dq	0
qRem21		dq	0

; *****************************************************************

section	.text
global _start
_start:

; ----------------------------------------------

;  BYTE Operations
; -----
;   byte additions
;	bAns4 = bNum6 + bNum4
	mov AL, byte [bNum6]   ; move value of bNum6 into AL
	add AL, byte [bNum4]   ; add value of bNum4 into AL
	mov byte [bAns4], AL   ; move value of AL into bAns4
;	bAns5 = bNum6 + bNum3
	mov AL, byte [bNum6]   ; move value of bNum6 into AL
	add AL, byte [bNum3]   ; add value of bNum3 into AL
	mov byte [bAns5], AL   ; move value of AL into bAns5
; -----
;   byte subtraction
;	bAns9 = bNum6 - bNum4
	mov AL, byte [bNum6]   ; move value of bNum6 into AL
	sub AL, byte [bNum4]   ; subtract value of bNum4 from AL
	mov byte [bAns9], AL   ; move value of AL into bAns9
;	bAns10 = bNum6 - bNum5
	mov AL, byte [bNum6]   ; move value of bNum6 into AL
	sub AL, byte [bNum5]   ; subtract value of bNum5 from AL
	mov byte [bAns10], AL  ; move value of AL into bAns10
; -----
;  unsigned byte multiplication
;	wAns11 = bNum1 * bNum3
	mov AL, byte [bNum1]   ; move bNum1 into AL
	mov BL, byte [bNum3]   ; move bNum3 into BL
	mul BL				   ; multiply AL by BL into AX
	mov word [wAns11], AX  ; mov AX into wAns11
;	wAns12 = bNum2 * bNum3
	mov AL, byte [bNum2]   ; move bNum2 into AL
	mov BL, byte [bNum3]   ; move bNum3 into BL
	mul BL				   ; multiply AL by BL into AX
	mov word [wAns12], AX  ; move AX into wAns12
; -----
;  signed byte multiplication
;	wAns14 = bNum5 * bNum2
	mov AL, byte [bNum5]   ; move bNum5 into AL
	mov BL, byte [bNum2]   ; move bNum2 into BL
	imul BL				   ; multiply AL by BL into AX
	mov word [wAns14], AX  ; move AX into wAns14
;	wAns15 = bNum6 * bNum3
	mov AL, byte [bNum6]   ; move bNum6 into AL
	mov BL, byte [bNum3]   ; move bNum3 into BL
	imul BL				   ; multiply AL by BL into AX
	mov word [wAns15], AX  ; move AX into wAns15
; -----
;  unsigned byte division
;	bAns16 = bNum1 / bNum2
	mov AH, 0			   ; move 0 into AH
	mov AL, byte [bNum1]   ; move bNum1 into AL
	mov BL, byte [bNum2]   ; move bNum2 into BL
	div BL				   ; divide AL by BL into AX 
	mov byte [bAns16], AL  ; move quotient into bAns16
;	bAns18 = wNum2 / bNum4 
	mov AX, word [wNum2]   ; move wNum2 into AX
	mov BL, byte [bNum4]   ; move bNum4 into Bl
	div BL 				   ; divide AX by BL
	mov byte [bAns18], AL  ; move quotient into bAns18
;	bRem18 = wNum2 % bNum4
	mov byte [bRem18], AH  ; move remainder into bRem18
; -----
;  signed byte division
;	bAns19 = bNum5 / bNum3
	mov AL, byte [bNum5]   ; move bNum5 into AL
	cbw					   ; convert byte to word
	mov BL, byte [bNum3]   ; move bNum3 into BL
	idiv BL				   ; divide AL by BL
	mov byte [bAns19], AL  ; move quotient into bAns19
;	bAns21 = wNum4 / bNum1
	mov AX, word [wNum4]   ; move wNum4 into AX
	mov BL, byte [bNum1]   ; move bNum1 into BL
	idiv BL				   ; divide AX by BL
	mov byte [bAns21], AL  ; move quotient into bAns21
;	bRem21 = wNum4 % bNum1
	mov byte [bRem21], AH  ; move remainder into bRem21

; *****************************************

;  WORD Operations
; -----
;  signed word additions
;	wAns4 = wNum5 + wNum3
	mov AX, word [wNum5]    ; move value of wNum5 into AX
	add AX, word [wNum3]    ; add value of wNum3 into AX
	mov word [wAns4], AX    ; move value of AX into wAns4
;	wAns5 = wNum6 + wNum1
	mov AX, word [wNum6]    ; move value of wNum6 into AX
	add AX, word [wNum1]    ; add value of wNum1 into AX
	mov word [wAns5], AX    ; move value of AX into wAns5
; -----
;  signed word subtraction
;	wAns9 = wNum5 - wNum2
	mov AX, word [wNum5]    ; move value of wNum5 into AX
	sub AX, word [wNum2]    ; subtract value of wNum2 from AX
	mov word [wAns9], AX    ; move value of AX into wAns9
;	wAns10 = wNum6 - wNum3
	mov AX, word [wNum6]    ; move value of wNum6 into AX
	sub AX, word [wNum3]    ; subtract value of wNum3 from AX
	mov word [wAns10], AX   ; move value of AX into wAns10
; -----
;  unsigned word multiplication
;	dAns11 = wNum1 * wNum2
	mov AX, word [wNum1]    ; move value of wNum1 into AX
	mov BX, word [wNum2]    ; move value of wNum2 into BX
	mul BX				    ; multiply AX by BX into AX:DX
	mov word [dAns11], AX   ; move AX into first half of dAns11
	mov word [dAns11+2], DX ; move DX into second half of dAns11
;	dAns12 = wNum2 * wNum3
	mov AX, word [wNum2]    ; move value of wNum2 into AX
	mov BX, word [wNum3]    ; move value of wNum3 into BX
	mul BX					; multiply AX by BX into AX:DX
	mov word [dAns11], AX   ; move AX into first half of dAns11
	mov word [dAns11+2], DX ; move DX into second half of dAns11
; -----
;  signed word multiplication
;	dAns14 = wNum5 * wNum1
	mov AX, word [wNum5]    ; move value of wNum5 into AX
	mov BX, word [wNum1]    ; move value of wNum1 into BX
	imul BX 				; multiple AX by BX into AX:DX
	mov word [dAns14], AX	; move AX into first half of dAns14
	mov word [dAns14+2], DX ; move DX into second half of dAns14
;	dAns15 = wNum6 * wNum2
	mov AX, word [wNum6]    ; move value of wNum6 into AX
	mov BX, word [wNum2]    ; move value of wNum2 into BX
	imul BX					; multiply AX by BX into AX:DX
	mov word [dAns15], AX   ; move AX into first half of dAns15
	mov word [dAns15+2], DX ; move DX into second half of dAns15
; -----
;  unsigned word division
;	wAns16 = wNum1 / wNum2
	mov DX, 0				; clear DX
	mov AX, word [wNum1]	; move wNum1 into AX
	mov BX, word [wNum2]	; move wNum2 into BX
	div BX					; divide AX:DX by BX
	mov word [wAns16], AX	; move quotient (AX) into wAns16
;	wAns18 = dNum3 / wNum4 
	mov AX, word [dNum3]	; move first half of dNum3 into AX
	mov DX, word [dNum3+2]	; move second half of dNum3 into DX
	mov BX, word [wNum4]	; move wNum4 into BX
	div BX					; divide AX:DX by BX
	mov word [wAns18], AX	; move quotient (AX) into wAns18
;	wRem18 = dNum3 % wNum4
	mov word [wRem18], DX	; move remainder (DX) into wRem18
; -----
;  signed word division
;	wAns19 = wNum5 / wNum3
	mov AX, word [wNum5]	; move wNum5 into AX
	cwd						; convert word to doubleword
	mov BX, word [wNum3]	; move wNum3 into BX
	idiv BX					; divide AX by BX
	mov word [wAns19], AX	; move quotient (AX) into wAns19
;	wAns21 = dNum1 / wNum2
	mov EAX, dword [dNum1]  ; move dNum21 into EAX
	mov BX, word [wNum2]    ; move wNum2 into BX
	idiv BX					; divide EAX by BX
	mov word [wAns21], AX	; move quotient (AX) into wAns21
;	wRem21 = dNum1 % wNum2
	mov word [wRem21], DX   ; move remainder (DX) into wRem21
; *****************************************

;  DOUBLEWORD Operations
; -----
;  signed double word additions
;	dAns4 = dNum5 + dNum3
	mov EAX, dword [dNum5]    ; move value of dNum5 into EAX
	add EAX, dword [dNum3]    ; add value of dNum3 into EAX
	mov dword [dAns4], EAX    ; move value of EAX into dAns4
;	dAns5 = dNum6 + dNum4
	mov EAX, dword [dNum6]    ; move value of dNum6 into EAX
	add EAX, dword [dNum4]    ; add value of dNum4 into EAX
	mov dword [dAns5], EAX    ; move value of EAX into dAns5
; -----
;  signed double word subtraction
;	dAns9 = dNum5 - dNum2
	mov EAX, dword [dNum5]    ; move value of dNum5 into EAX
	sub EAX, dword [dNum2]    ; subtract value of dNum2 from EAX
	mov dword [dAns9], EAX    ; move value of EAX into dAns9
;	dAns10 = dNum6 - dNum3 
	mov EAX, dword [dNum6]    ; move value of dNum6 into EAX
	sub EAX, dword [dNum3]    ; subtract value of dNum3 from EAX
	mov dword [dAns10], EAX   ; move value of EAX into dAns10
; -----
;  unsigned double word multiplication
;	qAns11 = dNum1 * dNum2
	mov EAX, dword [dNum1]    ; move value of dNum1 into EAX
	mov EBX, dword [dNum2]    ; move value of dNum2 into EBX
	mul EBX					  ; multiply EAX by EBX into EAX:EDX
	mov dword [qAns11], EAX   ; move EAX into first half of qAns11
	mov dword [qAns11+4], EDX ; move EDX into second half of qAns11
;	qAns12 = dNum2 * dNum3
	mov EAX, dword [dNum2]	  ; move value of dNum2 into EAX
	mov EBX, dword [dNum3]	  ; move value of dNum3 into EBX
	mul EBX				      ; multiply EAX by EBX into EAX;EDX
	mov dword [qAns12], EAX   ; move EAX into first half of qAns12
	mov dword [qAns12+4], EDX ; move EDX into second half of qAns12
; -----
;  signed double word multiplication
;	qAns14 = dNum5 * dNum1
	mov EAX, dword [dNum5]    ; move value of dNum5 into EAX
	mov EBX, dword [dNum1]	  ; move value of dNum1 into EBX
	imul EBX				  ; multiply EAX by EBX into EAX;EDX
	mov dword [qAns14], EAX   ; move EAX into first half of qAns14
	mov dword [qAns14+4], EDX ; move EDX into second half of qAns14
;	qAns15 = dNum6 * dNum2
	mov EAX, dword [dNum6]	  ; move value of dNum6 into EAX
	mov EBX, dword [dNum2]	  ; move value of dNum2 into EBX
	imul EBX				  ; multiply EAX by EBX
	mov dword [qAns15], EAX   ; move EAX into first half of qAns15
	mov dword [qAns15+4], EDX ; move EDX into second half of qAns15
; -----
;  unsigned double word division
;	dAns16 = dNum2 / dNum3				  
	mov EDX, 0				  ; clear EDX
	mov EAX, dword [dNum2]	  ; move dNum2 into EAX
	mov EBX, dword [dNum3]    ; move dNum3 into EBX
	div EBX					  ; divide EAX:EDX by EBX
	mov dword [qAns16], EAX   ; move quotient into qAns16
;	dAns18 = qAns12 / dNum4
	mov EAX, dword [qAns12]   ; move first half of qAns12 into EAX
	mov EDX, dword [qAns12+4] ; move second half of qAns12 into EDX
	mov EBX, dword [dNum4]	  ; move dNum4 into EBX
	div EBX					  ; divide EAX:EDX by EBX
	mov dword [dAns18], EAX   ; move quotient into dAns18
;	dRem18 = qAns12 % dNum4
	mov dword [dRem18], EDX	  ; move remainder into dRem18
; -----
;  signed double word division
;	dAns19 = dNum5 / dNum2
	mov EAX, dword [dNum5]    ; move dNum5 into EAX
	cdq						  ; convert double to quad
	mov EBX, dword [dNum2]	  ; move dNum2 into EBX
	idiv EBX				  ; divide EAX by EBX
	mov dword [dAns19], EAX	  ; move EAX into dAns19
;	dAns21 = qAns12 / dNum4
	mov RAX, qword [qAns12]	  ; move qAns12 into RAX
	cqo
	mov RBX, qword [dNum4]	  ; move dNum4 into EBX
	idiv EBX				  ; divide RAX by EBX
	mov qword [dAns21], RAX   ; move quotient (RAX) into dAns21
;	dRem21 = qAns12 % dNum4
	mov qword [dRem21], RDX   ; move remainder (RDX) into dRem21
; *****************************************
;  QUADWORD Operations

; -----
;  signed quadword additions
;	qAns4  = qNum5 + qNum1
	mov RAX, qword [qNum5] 		; move value of qNum5 into RAX
	add RAX, [qNum1] 		    ; add value of qNum1 into RAX
	mov qword [qAns4], RAX 		; move value of RAX into qAns4
;	qAns5  = qNum6 + qNum2
	mov RAX, qword [qNum6] 		; move value of qNum5 into RAX
	add RAX, qword [qNum2] 		; add value of qNum1 into RAX
	mov qword [qAns5], RAX 		; move value of RAX into qAns5
; -----
;  signed quadword subtraction
;	qAns9  = qNum5 - qNum3
	mov RAX, qword [qNum5] 		; move value of qNum5 into RAX
	sub RAX, qword [qNum3] 		; subtract value of qNum3 from RAX
	mov qword [qAns9], RAX 		; move value of RAX into qAns9
;	qAns10 = qNum6 - qNum4
	mov RAX, qword [qNum6]  	; move value of qNum6 into RAX
	sub RAX, qword [qNum4]  	; subtract value of qNum4 into RAX
	mov qword [qAns10], RAX 	; move value of RAX into qAns10
; -----
;  unsigned quadword multiplication
;	dqAns11  = qNum1 * qNum2
	mov RAX, qword [qNum1]		; move value of qNum1 into RAX
	mov RBX, qword [qNum2]		; move value of qNum2 into RBX
	mul RBX						; multiply RAX by RBX into RAX:RDX
	mov [dqAns11], RAX	; move value of RAX into first half of dqAns11
	mov [dqAns11+8], RDX  ; move value of RDX into second half of dqAns11
;	dqAns12  = qNum2 * qNum3
	mov RAX, qword [qNum2]		; move value of qNum2 into RAX
	mov RBX, qword [qNum3]		; move value of qNum3 into RBX
	mul RBX						; multiply RAX by RBX into RAX:RDX
	mov qword [dqAns12], RAX	; move value of RAX into first half of dqAns12
	mov qword [dqAns12+8], RDX  ; move value of RDX into second half of dqAns12
; -----
;  signed quadword multiplication
;	dqAns14  = qNum5 * qNum3
	mov RAX, qword [qNum5]		; move value of qNum5 into RAX
	mov RBX, qword [qNum3]		; move value of qNum3 into RBX
	imul RBX					; multiply RAX by RBX into RAX:RDX
	mov qword [dqAns14], RAX	; move RAX into first half of dqAns14
	mov qword [dqAns14+8], RDX  ; move RDX into second half of dqAns14
;	dqAns15  = qNum6 * qNum4
	mov RAX, qword [qNum6]		; move value of qNum6 into RAX
	mov RBX, qword [qNum4]		; move value of qNum4 into RBX
	imul RBX					; multiply RAX by RBX into RAX:RDX
	mov qword [dqAns15], RAX	; move RAX into first half of dqAns15
	mov qword [dqAns15+8], RDX	; move RDX into second half of dqAns15
; -----
;  unsigned quadword division
;	qAns16 = qNum1 / qNum2
	mov RDX, 0				   ; clear RDX
	mov RAX, qword [qNum1]	   ; move qNum1 into RAX
	mov RBX, qword [qNum2]	   ; move qNum2 into RBX
	div RBX					   ; divide RAX:RDX by RBX
	mov qword [qAns16], RAX    ; move quotient into qAns16
;	qAns18 = dqAns12 / qNum4
	mov RAX, qword [dqAns12]   ; move first half of dqAns12 into RAX
	mov RDX, qword [dqAns12+8] ; move second half of dqAns12 into RDX
	mov RBX, qword [qNum4]	   ; move qNum4 into RBX
	div RBX					   ; divide RAX:RDX by RBX
	mov qword [qAns18], RAX	   ; move quotient into qAns18
;	qRem18 = dqAns12 % qNum4
	mov qword [qRem18], RDX	   ; move remainder into qRem18
; -----
;  signed quadword division
;	qAns19 = qNum5 / qNum3
	mov RAX, qword [qNum5]	   ; move qNum5 into RAX
	cqo						   ; extend sign 
	mov RBX, qword [qNum3]	   ; move qNum3 into RBX
	idiv RBX				   ; divide RAX by RBX
	mov qword [qAns19], RAX	   ; move quotient (RAX) into qAns19
;	qAns21 = dqAns12 / qNum4
	mov RAX, qword [dqAns12]   ; move dqAns12 into RAX
	cqo                         
	mov RBX, qword [qNum4]	   ; move qNum4 into RBX
	idiv RBX				   ; divide RAX:RDX by RBX
	mov qword [qAns21], RAX    ; move RAX (quotient) into qAns21
;	qRem21 = dqAns12 % qNum4
	mov qword [qRem21], RDX	   ; move RDX (remainder) into qRem21
; *****************************************************************
;  Done, terminate program.

last:
	mov	rax, SYS_exit		; call code for exit (SYS_exit)
	mov	rdi, EXIT_SUCCESS
	syscall

