; Macro example

%macro  aver    3
    mov eax, 0
    mov ecx, dword [%2]
    mov r12, 0
    lea rbx, [%1]

%%sumLoop:
    add eax, dword [rbx + r12*4]
    inc r12
    loop %%sumLoop

    cdq
    idiv dword [%2]
    mov dword [%3], eax
%endmacro


%macro  maxl    3
    mov eax, dword [%1]
    mov ecx, dword [%2]
    xor r12, r12
    lea rbx, [%1]
%%maxLoop:
    inc r12d
    cmp r12d, ecx
    je %%FIN
    cmp dword [rbx + r12*4], eax
    jle %%maxLoop
    mov eax, dword [rbx + r12*4] 
    jmp %%maxLoop

%%FIN:
    mov dword [%3], eax
%endmacro


%macro  minl    3
    mov eax, dword [%1]
    mov ecx, dword [%2]
    xor r12, r12
    lea rbx, [%1]
%%minLoop:
    inc r12d
    cmp r12d, ecx
    je %%FIN
    cmp dword [rbx + r12*4], eax
    jge %%minLoop
    mov eax, dword [rbx + r12*4] 
    jmp %%minLoop

%%FIN:
    mov dword [%3], eax
%endmacro


section     .data
EXIT_SUCCESS    equ 0
SYS_exit        equ 60

list1   dd  4,  5,  2,  -3, 1
len1    dd  5
ave1    dd  0
max1    dd  0
min1    dd  0

list2   dd  2,  6,  3,  -2, 1,  8,  19
len2    dd  7
ave2    dd  0
max2    dd  0
min2    dd  0

section     .text
global _start
_start:

    aver list1, len1, ave1
    aver list2, len2, ave2
    maxl list1, len1, max1
    maxl list2, len2, max2
    minl list1, len1, min1
    minl list2, len2, min2

last:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall
