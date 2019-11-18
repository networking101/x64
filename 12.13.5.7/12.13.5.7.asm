; Function example, string to int
section     .data
SYS_exit        equ 60
EXIT_SUCCESS    equ 0

intNum      dd  0
strNum      db  "12345", 0x0


section     .text
global _start
_start:

    lea rdi, [strNum]
    call atoi


last:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall


global atoi
atoi:
    push rbp
    mov rbp, rsp

    mov esi, 1
    mov rcx, 0
    mov r9d, 10
    xor r10d, r10d
    xor rdx, rdx
LOOP1:
    xor ebx, ebx
    mov bl, byte [rdi + rcx]
    cmp bl, 0
    je FIN
    sub bl, '0'
    mov eax, esi
    mul ebx
    add r10d, eax
    mov eax, esi
    mul r9d
    mov esi, eax
    inc rcx
    jmp LOOP1

FIN:
    mov eax, r10d
    pop rbp
    ret

