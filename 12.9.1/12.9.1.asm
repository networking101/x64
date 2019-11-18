section     .data
SYS_exit        equ 60
EXIT_SUCCESS    equ 0

arr         dd      2,  4,  6,  8
len         dd      4

section     .bss
ave         resq    1
sum         resq    1

section     .text
global _start
_start:

;call stats1(arr, len, sum, ave)
    lea rcx, [ave]
    lea rdx, [sum]
    mov esi, dword [len]
    lea rdi, [arr]
    call stats1


last:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall

section     .text
global stats1
stats1:
    push r12

    mov r12, 0
    mov rax, 0
sumLoop:
    add eax, dword [rdi + r12*4]
    inc r12
    cmp r12,rsi
    jl sumLoop

    mov dword [rdx], eax

    cdq
    idiv esi
    mov dword [rcx], eax
   
    pop r12
    ret
