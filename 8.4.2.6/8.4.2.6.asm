; bubble sort

section     .data
EXIT_SUCCESS    equ 0
SYS_exit        equ 60

lst         dd      9,  3,  0,  -8,  2,  6,  5,  7,  4,  1
len         dd      10
swapped     db      0
j           dd      0

section     .bss
tmp         dd      1


section     .text
global _start
_start:

;setup
    mov ecx, dword [len]
    dec ecx                         ;i = len-1

LOOP1:
    ;swapped = false
    mov byte [swapped], 0           ;swapped = false
    
    mov dword [j], 0                ;j = 0
    dec ecx                         ;i--
LOOP2
    ;for (j=0 to i-1)
    mov esi, dword [j]              ;esi = j
    cmp esi, ecx
    jg backLOOP1                   ;!(j < i-1)

    ;if (lst(j) > lst(j+1))
    mov eax, dword [lst + esi*4]    ;eax = lst[j]
    inc esi                         ;j++
    cmp eax, dword [lst + esi*4]
    jg PASSED                       ;lst[j] > lst[j+1]

FAILED:
    mov dword [j], esi
    jmp backLOOP2

PASSED:
    mov dword [j], esi              ;j = j+1
    mov eax, esi                    ;eax = j+1
    dec esi                         ;esi = j
    mov edx, dword [lst + esi*4]    ;edx = lst[j]
    mov dword [tmp], edx
    mov edx, dword [lst + eax*4]    ;edx = lst[j+1]
    mov dword [lst + esi*4], edx    ;lst[j] = lst[j+1]
    mov edx, dword [tmp]            ;edx = tmp
    mov dword [lst + eax*4], edx    ;lst[j+1] = tmp
    inc byte [swapped]              ;swapped = true

backLOOP2:
    jmp LOOP2

backLOOP1
    ; if (swapped = false) exit
    mov al, byte [swapped]         ;eax = swapped
    cmp al, 0
    jne LOOP1                       ;!(swapped = false)

last:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall
