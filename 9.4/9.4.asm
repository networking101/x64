;stack example

section     .data
EXIT_SUCCESS    equ 0
SYS_exit        equ 60

numbers         dq  121,    122,    123,    124,    125
len             dq  5

section     .text
global _start
_start:

; Loop to put number on stack
    mov rcx, qword [len]
    lea rbx, [numbers]
    mov r12, 0
    mov rax, 0

pushLoop:
    push qword [rbx + r12*8]
    inc r12
    loop pushLoop

    mov rcx, qword [len]
    lea rbx, [numbers]
    mov r12, 0

popLoop:
    pop rax
    mov qword [rbx + r12*8], rax
    inc r12
    loop popLoop

last:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall
