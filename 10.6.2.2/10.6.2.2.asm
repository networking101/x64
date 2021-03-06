section     .data
SYS_exit        equ     60
EXIT_SUCCESS    equ     0

NULL            equ     0
intNum          dd      -71498
negative        db      0
oneN            db      -1

section     .bss
strNum          resb    10


section     .text
global _start
_start:

;Part A
    mov eax, dword [intNum]
    mov rcx, 0
    mov ebx, 10

;check negative
CHECKN:
    cmp dword [intNum], 0
    jge divideLoop
    inc byte [negative]
    neg eax

divideLoop:
    xor rdx, rdx
    div ebx
    push rdx
    inc rcx
    cmp eax, 0
    jne divideLoop

;Part B
    mov rdi, 0

;add negative
ADDN:
    cmp byte [negative], 0
    je popLoop
    mov byte [strNum], '-'
    inc rdi

popLoop:
    pop rax
    add al, "0"
    mov byte [strNum + rdi], al
    inc rdi
    loop popLoop

;Null Terminate
    mov byte [strNum + rdi], NULL


last:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall
