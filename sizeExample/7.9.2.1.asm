section			.data
EXIT_SUCCESS	equ		0
SYS_exit		equ		60

wNum1		dw		50
wNum2		dw		30000
wNum3		dw		-32000
wAns1		dw		0

section		.text
global _start
_start:
	xor rax, rax

ADDING:
	mov ax, word [wNum3]
	add ax, word [wNum1]
	mov word [wAns1], ax

SUBBING:
	mov ax, word [wNum3]
	sub ax, word [wNum1]
	mov word [wAns1], ax
	
MULTING:
	mov ax, word [wNum3]
	imul word [wNum1]
	mov word [wAns1], ax

DIVING:
	xor rdx, rdx
	mov ax, word [wNum3]
	cwd
	idiv word [wNum1]
	mov word [wAns1], dx

last:
	mov rax, SYS_exit
	mov rdi, EXIT_SUCCESS
	syscall
