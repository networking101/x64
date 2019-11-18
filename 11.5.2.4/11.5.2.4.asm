; Macro example, int to string

%macro itos     2
    mov eax, dword [%1]
    mov rcx, 0
    mov ebx, 10

divideLoop:
    mov edx, 0
    div ebx
    push rdx
    inc rcx
    cmp eax, 0
    jne divideLoop

;Part B
    mov rdi, 0

popLoop:
    pop rax
    add al, "0"
    mov byte [%2 + rdi], al
    inc rdi
    loop popLoop

;Null Terminate
    mov byte [strNum + rdi], 0x0


%endmacro

section     .data
SYS_exit        equ 60
EXIT_SUCCESS    equ 0

intNum      dd  12345


section     .bss
strNum      resb    10


section     .text
global _start
_start:

    itos intNum, strNum


last:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall
