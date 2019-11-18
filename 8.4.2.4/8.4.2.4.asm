section     .data
    EXIT_SUCCESS    equ 0
    SYS_exit        equ 60

    lst         dd  10, 501,    -8, 800,    -600,   1234
    n           dd  6
    sum         dd  0

    ddTwo       dd  2
    ddThree     dd  3

section     .bss
    min         dd  1
    middle      dd  1
    max         dd  1
    avg         dd  1


section     .text
global _start
_start:

;setup
    mov ecx, dword [n]
    xor rsi, rsi
    mov eax, [lst]
    mov dword [min], eax
    mov dword [max], eax

MIDDLE:
;check size
    xor edx, edx
    mov eax, dword [n]
    dec eax
    div dword [ddTwo]
    mov ebx, dword[lst + eax*4]
    add eax, edx
    add ebx, dword [lst + (eax)*4]
    mov eax, ebx
    cdq
    idiv dword [ddTwo]
    mov dword [middle], eax

LOOP1:
    mov eax, [lst+rsi*4]
    add dword [sum], eax
    cmp eax, dword [min]
    jge branchMIN
    mov dword [min], eax
    jmp branchMAX

branchMIN:
    cmp eax, dword [max]
    jle branchMAX
    mov dword [max], eax

branchMAX:
    inc rsi
    loop LOOP1
    
AVERAGE:
    mov eax, dword [sum]
    cdq
    idiv dword [n]
    mov dword [avg], eax 

last:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall
