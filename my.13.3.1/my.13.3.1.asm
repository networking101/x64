; Print text to screen
section             .data

LF      equ     10
NULL    equ     0
TRUE    equ     1
FALSE   equ     0

EXIT_SUCCESS    equ     0

STDIN           equ     0
STDOUT          equ     1
STDERR          equ     2

SYS_read        equ     0
SYS_write       equ     1
SYS_open        equ     2
SYS_close       equ     3
SYS_exit        equ     60

ERR_write       db      "Error writing to file descriptor.", LF, 0
ERR_read        db      "Error reading from file descriptor.", LF, 0

message1        db      "Hello World!", LF, 0
message2        db      "Michael", LF, "Kowpak", LF, 0
newLine         db      LF, 0

section             .text
global _start
_start:

    lea rdi, [message1]
    call printString

    lea rdi, [newLine]
    call printString

    lea rdi, [message2]
    call printString

FIN:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall

global printString
printString:
    push rbp
    mov rbp, rsp

    lea rbx, [rdi]

    xor eax, eax
printing:
    cmp byte [rbx], 0
    je pSFIN
    mov rax, SYS_write
    mov rdi, STDOUT
    lea rsi, [rbx]
    mov rdx, 1
    syscall
    cmp rax, 0
    jl pSERR
    inc rbx
    jmp printing

pSFIN:
    mov rsp, rbp
    pop rbp
    ret

pSERR:
    mov rdi, rax
    mov rax, SYS_exit
    syscall
