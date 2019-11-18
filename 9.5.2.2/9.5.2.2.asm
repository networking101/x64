; palindrome example
section     .data
EXIT_SUCCESS    equ 0
SYS_exit        equ 60

string      db      "Hello!!olleH",   0x0
final       db      1

section     .text
global _start
_start:
;setup
    xor rsi, rsi

;push
LOOP1:
    mov al, byte [string + rsi]
    cmp al, 0
    je NEXT
    push rax
    inc rsi
    jmp LOOP1

NEXT:
;pop
    xor rsi, rsi
LOOP2:
    mov al, byte [string + rsi]
    cmp al, 0
    je last
    pop rbx
    cmp al, bl
    jne NOTPAL
    inc rsi
    jmp LOOP2


NOTPAL:
    mov byte [final], 0

last:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall
