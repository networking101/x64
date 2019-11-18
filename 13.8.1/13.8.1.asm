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

newLine         db      LF, NULL
header          db      LF, "File Write Example."
                db      LF, LF, NULL
fileName        db      "/tmp/url.txt", NULL
url             db      "http://www.google.com"
                db      LF, NULL
len             dq      $-url-1

writeDone       db      "Write Completed.", LF, NULL
fileDesc        dq      0
errMsgOpen      db      "Error opening file.", LF, NULL
errMsgWrite     db      "Error writing to file.", LF, NULL


section         .text
global _start
_start:

    mov rdi, header
    call printString

openInputFile:
    mov rax, SYS_creat
    lea rdi, [fileName]
    mov rsi, S_IRUSR | S_IWUSR
    syscall

    cmp rax, 0
    jl errorOnOpen

    mov qword [fileDesc], rax

fileWrite:
    mov rax, SYS_write
    mov rdi, qword [fileDesc]
    lea rsi, [url]
    mov rdx, qword [len]
    syscall

    cmp rax, 0
    jl errorOnWrite

    mov rdi, writeDone
    call printString

fileClose:
    mov rax, SYS_close
    mov rdi, qword [fileDesc]
    syscall

    jmp last

errorOnOpen:
    mov rdi, errMsgOpen
    call printString
    jmp last

errorOnWrite:
    mov rdi, errMsgWrite
    call printString

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
