section			.data
EXIT_SUCCESS	equ	0
SYS_Exit		equ	60

n		dd		400000000
sumN	dq		0

section		.text
global _start
_start:
	mov ecx, dword [n]

LOOP1:
	add dword [sumN], ecx
	loop LOOP1

FINISH:
	mov eax, dword [sumN]
	mul eax
	mov dword [sumN], eax
	mov dword [sumN+4], edx

last:
	mov rax, SYS_Exit
	mov rdi, EXIT_SUCCESS
	syscall
