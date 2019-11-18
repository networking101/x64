section         .data
EXIT_SUCCESS    equ 0
SYS_exit        equ 60

n       dd      10
fin     dd      0

section     .text
global _start
_start:

    ;xor eax, eax
    ;mov ebx, 1
    mov ecx, dword [n]
    ;dec ecx

    xor eax, eax
    mov edx, 1

FIB:
    ;mov edx, ebx
    ;add ebx, eax
    ;mov eax, edx
    ;mov dword [fin], ebx
    ;loop FIB

    xadd eax, edx
    loop FIB

last:
    mov dword [fin], eax

    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall
