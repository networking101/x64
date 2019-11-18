; Macro example, double list

%macro  doublel 2
    mov ecx, dword [%2]
    xor r12, r12
    lea rbx, [%1]
%%LOOP1:
    shl dword [rbx + r12*4], 1
    inc r12
    loop %%LOOP1
%endmacro


section     .data
EXIT_SUCCESS    equ 0
EXIT_EAGAIN     equ 11
SYS_exit        equ 60

list1   dd  4,  5,  2,  -3, 1
len1    dd  5

list2   dd  2,  6,  3,  -2, 1,  8,  19
len2    dd  7

section     .text
global _start
_start:

    doublel list1, len1
    doublel list2, len2

last:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall
