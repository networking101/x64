section     .data
SYS_exit        equ 60
EXIT_SUCCESS    equ 0

arr         dd      2,  4,  6,  8
len         dd      4

section     .bss
ave         resq    1
sum         resq    1
min         resq    1
med1        resq    1
med2        resq    1
max         resq    1

section     .text
global _start
_start:

;call stats2(arr, len, min, med1, med2, max sum, ave)
    push ave
    push sum
    lea r9, [max]
    lea r8, [med2]
    lea rcx, [med1]
    lea rdx, [min]
    mov esi, dword [len]
    lea rdi, [arr]
    call stats2
    add rsp, 16


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

global stats2
stats2:
    push rbp
    mov rbp, rsp
    push r12

;Get min and max
    mov eax, dword [rdi]
    mov dword [rdx], eax

    mov r12, rsi
    dec r12
    mov eax, dword [rdi + r12*4]
    mov dword [r9], eax

;Get medians
    mov rax, rsi
    mov rdx, 0
    mov r12, 2
    div r12

    cmp rdx, 0
    je evenLength

    mov r12d, dword [rdi + rax*4]
    mov dword [rcx], r12d
    mov dword [r8], r12d
    jmp medDone

evenLength:
    mov r12d, dword [rdi + rax*4]
    mov dword [r8], r12d
    dec rax
    mov r12d, dword [rdi + rax*4]
    mov dword [rcx], r12d
medDone:

;Find sum
    mov r12, 0
    mov rax, 0

sumLoop2:
    add eax, dword [rdi + r12*4]
    inc r12
    cmp r12, rsi
    jl sumLoop2

    mov r12, qword [rbp+16]
    mov dword [r12], eax

;Calculate average
    cdq
    idiv rsi
    mov r12, qword [rbp + 24]
    mov dword [r12], eax

    pop r12
    pop rbp
    ret




