; palindrome example
section     .data
EXIT_SUCCESS    equ 0
SYS_exit        equ 60

string      db      "A man, a plan, a canal - Panama!",   0x0
final       db      1

section     .text
global _start
_start:
;setup
    xor rsi, rsi

;push
LOOP1:
    mov al, byte [string + rsi]
    inc rsi
    cmp al, 0
    je NEXT
;check if caps
CHECK1:
    cmp al, 65
    jl LOOP1
    cmp al, 90
    jg CHECK2
    add al, 32
    jmp PUSH1

;check if non caps
CHECK2:
    cmp al, 97
    jl LOOP1
    cmp al, 122
    jg LOOP1
    
PUSH1:
    push rax
    jmp LOOP1

NEXT:
;pop
    xor rsi, rsi
LOOP2:
    mov al, byte [string + rsi]
    inc rsi
    cmp al, 0
    je last

;check if caps
CHECK3:
    cmp al, 65
    jl LOOP2
    cmp al, 90
    jg CHECK4
    add al, 32
    jmp POP1

CHECK4:
    cmp al, 97
    jl LOOP2
    cmp al, 122
    jg LOOP1

POP1:
    pop rbx
    cmp al, bl
    jne NOTPAL
    jmp LOOP2


NOTPAL:
    mov byte [final], 0

last:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall
