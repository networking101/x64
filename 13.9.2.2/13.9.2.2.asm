;read string example
section         .data

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
SYS_open        equ     2
SYS_close       equ     3
SYS_fork        equ     57
SYS_exit        equ     60
SYS_creat       equ     85
SYS_time        equ     201

STRLEN          equ     50
BUFSIZE         equ     256

pmpt            db      "Enter Text: ", NULL
newLine         db      LF, NULL

section         .bss

buf             resb    BUFSIZE


section         .text
global _start
_start:
    lea rdi, [pmpt]
    call printString

    lea rdi, [buf]
    mov rsi, BUFSIZE
    call userInput

    lea rdi, [buf]
    call printString

last:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall


global printString
printString:
    push rbp

    mov rax, SYS_write
    mov rsi, rdi
    mov rdi, STDIN
    mov rdx, STRLEN
    syscall

    pop rbp
    ret


global userInput
userInput:
    push rbp
    mov rbp, rsp
    sub rsp, 8

    mov rbx, rdi
    mov r12, rsi
    sub r12, 2
LOOP1:
;get next character from user
    mov rax, SYS_read
    mov rdi, STDIN
    lea rsi, [rbp - 8]
    mov rdx, 1
    syscall
    mov al, byte [rbp - 8]

;if chaacter is new line, jump to FIN
    mov al, byte [rbp - 8]
    cmp al, LF
    je FIN

maxBuf:
;check if buf limit reached
    cmp rcx, 0
    je LOOP1

progress:
;save character and move to next buffer space
    mov byte [rbx], al
    inc rbx
    dec r12
    jmp LOOP1

FIN:
;append LF, NULL to end
    mov byte [rbx], al
    inc rbx
    mov byte [rbx], NULL
    sub r12, 256
    neg r12
    mov rax, r12
    add rsp, 8
    pop rbp
    ret
