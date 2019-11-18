;write file
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

O_CREAT         equ     0x40
O_TRUNC         equ     0x200
O_APPEND        equ     0x400

O_RDONLY        equ     0q
O_WRONLY        equ     1q
O_RDWD          equ     2q

S_IRUSR         equ     400q
S_IWUSR         equ     200q
S_IXUSR         equ     100q

BUFSIZE         equ     256

pmpt            db      "Enter Text: ", NULL
newLine         db      LF, NULL
fileName        db      "/tmp/pass.txt", NULL

writeDone       db      "Write Completed.", LF, NULL
fileDesc        dq      0
errMsgOpen      db      "Error opening file.", LF, NULL
errMsgWrite     db      "Error writing to file.", LF, NULL


section         .bss
buf             resb    BUFSIZE



section         .text
global _start
_start:

    lea rdi, [pmpt]
    mov rsi, BUFSIZE
    call printString

    lea rdi, [buf]
    mov rsi, BUFSIZE
    call userInput

    lea rdi, [buf]
    mov rsi, rax
    lea rdx, [fileName]
    call writeFile

last:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall


global printString
printString:
    push rbx

    mov rbx, rdi
    mov rdx, 0
strCountLoop:
    cmp byte [rbx], NULL
    je strCountDone
    inc rdx
    inc rbx
    jmp strCountLoop

strCountDone:
    cmp rdx, 0
    je prtDone

    mov rax, SYS_write
    mov rsi, rdi
    mov rdi, STDOUT
    syscall

prtDone:
    pop rbx
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

global writeFile
writeFile:
;lea rdi, [buf]
;mov rsi, rax [buf size]
;lea rdx, [fileName]
;call writeFile
    push rbp
    mov rbp, rsp
    sub rsp, 8

    mov r13, rsi
    lea r12, [rdi]

    mov rax, SYS_creat
    mov rdi, rdx
    mov rsi, S_IRUSR | S_IWUSR
    syscall
    mov [rbp - 8], rax

    mov rax, SYS_write
    mov rdi, [rbp - 8]
    lea rsi, [buf]
    mov rdx, r13
    syscall

writeFIN:
    mov rax, SYS_close
    mov rdi, r12
    syscall    

    mov rax, rdx
    mov rsp, rbp
    pop rbp
    ret
