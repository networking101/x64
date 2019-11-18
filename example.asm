; Simple example
; August 13, 2019

section		.data

EXIT_SUCCESS	equ	0
SYS_exit	equ	60

; Byte
bVar1		db	17
bVar2		db	9
bResult		db	0

; Word
wVar1		dw	17000
wVar2		dw	9000
wResult		dw	0

; Double-word
dVar1		dd	17000000
dVar2		dd	9000000
dResult		dd	0

; Quad-word
qVar1		dq	170000000
qVar2		dq	90000000
qResult		dq	0

; Code Section
section		.text
global _start
_start:

; bResult = bVar1 + bVar2
	mov  al, byte [bVar1]
	add  al, byte [bVar2]
	mov  byte [bResult], al

; wResult = wVar1 + wVar2
	mov  ax, word [wVar1]
	add  ax, word [wVar2]
	mov  word [wResult], ax

; qResult = qVar1 + qVar2
	mov  eax, dword [dVar1]
	add  eax, dword [dVar2]
	mov  dword [dResult], eax

; qResult = qVar1 + qVar2
	mov  rax, qword [qVar1]
	add  rax, qword [qVar2]
	mov  qword [qResult], rax

; Done
last:
	mov  rax, SYS_exit
	mov  rdi, EXIT_SUCCESS
	syscall
