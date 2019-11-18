section     .data
EXIT_SUCCESS        equ 0
SYS_exit            equ 60

string      db      "-1 23M45", 0x0
ddTEN       dd      10
negative    db      0

section     .bss
final       dd      1


section     .text
global _start
_start:
;push string onto stack

    xor rax, rax
    xor ecx, ecx
    xor esi, esi

;check negative
CHECKN:
    dec ecx
    cmp byte [string], '-'
    jne LOOP1
    inc byte [negative]
    inc ecx

LOOP1:
    inc ecx
    mov al, [string + ecx]
    cmp al, 0
    je BUILD

;check bounds
CHECK1:
    cmp al, '0'
    jge CHECK2
    inc esi
    jmp LOOP1
    
CHECK2:
    cmp al, '9'
    jle SUCCESS
    inc esi
    jmp LOOP1

SUCCESS:
    push rax
    jmp LOOP1

;pop from stack to number
BUILD:
    mov edi, 1
    xor rbx, rbx
    sub ecx, esi

;check negative
ADDN:
    cmp byte [negative], 1
    jne LOOP2
    neg edi
    dec ecx

LOOP2:
    pop rax
    sub eax, "0"
    mul edi
    add dword [final], eax
    mov eax, edi
    mul dword [ddTEN]
    mov edi, eax
    loop LOOP2


last:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall
