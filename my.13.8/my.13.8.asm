; read data from /tmp/test.txt and write it to /tmp/out_test.txt
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
SYS_open        equ     2
SYS_close       equ     3
SYS_exit        equ     60
SYS_creat       equ     85

O_CREAT         equ     0x40
O_TRUNC         equ     0x200
O_APPEND        equ     0x400

O_RDONLY        equ     000000q
O_WRONLY        equ     000001q
O_RDWR          equ     000002q

S_IRUSR         equ     00400q
S_IWUSR         equ     00200q
S_IXUSR         equ     00100q

newLine         db      LF, NULL
header         db      "File Read and Write", LF, LF, NULL

rfileName       db      "/tmp/test.txt", NULL
wfileName       db      "/tmp/out_test.txt", NULL

errMsgOpen      db      "Error opening file.", LF, NULL
errMsgCreate    db      "Error creating file.", LF, NULL
errMsgRead      db      "Error reading from file descriptor.", LF, NULL
errMsgWrite     db      "Error writing to file descriptor.", LF, NULL
errMsgClose     db      "Error closing file descriptor.", LF, NULL


section             .bss
tempChar        resb    1


section             .text
global _start
_start:

    lea rdi, [header]
    call printString

    ;open file /tmp/test.txt
    mov rax, SYS_open
    lea rdi, [rfileName]
    mov rsi, O_RDONLY
    syscall
    cmp rax, 0
    jl openERR
    push rax

    ;create file /tmp/out_test.txt
    mov rax, SYS_creat
    lea rdi, [wfileName]
    mov rsi, S_IRUSR | S_IWUSR
    syscall
    cmp rax, 0
    jl createERR
    push rax

RWloop:
    ;read 1 char from file
    mov rax, SYS_read
    mov rdi, [rsp + 8]
    lea rsi, [tempChar]
    mov rdx, 1
    syscall

    ;if end of file, break loop
    cmp rax, 0
    je REOF

    ;print char to stdout
    mov rax, SYS_write
    mov rdi, STDOUT
    lea rsi, [tempChar]
    mov rdx, 1
    syscall

    ;write char to /tmp/out_test.txt
    mov rax, SYS_write
    mov rdi, [rsp]
    lea rsi, [tempChar]
    mov rdx, 1
    syscall

    jmp RWloop

REOF:
    ;close /tmp/out_test.txt
    mov rax, SYS_close
    pop rdi
    syscall

    ;close /tmp/test.txt
    mov rax, SYS_close
    pop rdi
    syscall

FIN:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall

openERR:
    lea rdi, [errMsgOpen]
    call printString

    mov rdi, rax
    mov rax, SYS_exit
    syscall

createERR:
    lea rdi, [errMsgCreate]
    call printString

    mov rdi, rax
    mov rax, SYS_exit
    syscall

readERR:
    lea rdi, [errMsgRead]
    call printString

    mov rdi, rax
    mov rax, SYS_exit
    syscall

writeERR:
    lea rdi, [errMsgWrite]
    call printString

    mov rdi, rax
    mov rax, SYS_exit
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
