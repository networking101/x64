; Read user input and print to screen

section             .data
LF              equ     10
NULL            equ     0
TRUE            equ     1
FALSE           equ     0

EXIT_SUCCESS    equ     0

STDIN           equ     0
STDOUT          equ     1
STDERR          equ     2

SYS_read        equ     0
SYS_write       equ     1
SYS_exit        equ     60

STRLEN          equ     50

ERR_read        db      "Error reading from file descriptor", LF, NULL

pmpt            db      "Enter Text: ", NULL
newLine         db      LF, NULL


section             .bss
tempStr         resb    STRLEN+2
tempChar        resb    1

section             .text
global _start
_start:

    lea rdi, [pmpt]
    call printString

    lea rdi, [tempStr]
    call readInput

    lea rdi, [tempStr]
    call printString

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


global readInput
readInput:
    push rbp
    mov rbp, rsp

    lea rbx, [rdi]
    xor r12, r12

readLoop:
    mov rax, SYS_read
    mov rdi, STDIN
    lea rsi, [tempChar]
    mov rdx, 1
    syscall
    cmp rax, 0
    jl rIERR
    cmp byte [tempChar], LF
    je rIFIN
    cmp r12, STRLEN
    jge readLoop
    mov al, byte [tempChar]
    mov byte [rbx + r12], al
    inc r12
    jmp readLoop

rIFIN:
    mov byte [rbx + r12], LF
    inc r12
    mov byte [rbx + r12], 0

    mov rbp, rsp
    pop rbp
    ret

rIERR:
    mov r12, rax

    lea rdi, [ERR_read]
    call printString

    mov rax, SYS_exit
    mov rdi, r12
    syscall
