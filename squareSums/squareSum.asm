section		.data
SUCCESS		equ	0
SYS_exit	equ	60

n		dd	10
sumOfSquares	dq	0

section		.text
global _start
_start:
	mov rcx, [n]

LOOP1:
	mov rax, rcx
	mul rax
	add [sumOfSquares], rax
	loop LOOP1


last:
	mov rax, SYS_exit
	mov rdi, SUCCESS
	syscall
