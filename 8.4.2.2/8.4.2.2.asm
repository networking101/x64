section     .data
EXIT_SUCCESS    equ 0
SYS_exit        equ 60

section     .data
    lst     dd      1002, 1004, 1006, 1008, 10010
    len     dd      5
    sum     dd      0
    max     dd      0
    min     dd      0
    avg     dd      0

section     .text
global _start
_start:

; Summation loop
    mov ecx, dword [len]
    mov rsi, 0

; Initialize min and max to first value in list
    mov eax, dword [lst]
    mov dword [min], eax
    mov dword [max], eax

sumLoop:
    mov eax, dword [lst + (rsi*4)]
    add dword [sum], eax

minCheck:
    cmp eax, dword [min]
    jae maxCheck
    mov dword [min], eax
    jmp FIN

maxCheck:
    cmp eax, dword [max]
    jbe FIN
    mov dword [max], eax

FIN:
    inc rsi
    loop sumLoop

average:
    mov eax, dword [sum]
    xor edx, edx
    div dword [len]
    mov dword [avg], eax

last:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall
