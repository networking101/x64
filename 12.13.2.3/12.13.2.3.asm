section     .data
SYS_exit        equ 60
EXIT_SUCCESS    equ 0

lst1        dd  4,  8,  7,  3,  5,  6,  1,  9,  2,  0
lst2        dd  2,  1,  3,  8,  9,  6,  5,  7,  4,  0
lst3        dd  4,  1,  6,  2,  0,  9,  8,  5,  7,  3
n           dd  10


section     .text
global _start
_start:

    lea rdi, [lst1]
    mov esi, dword [n]
    call selectSort

    lea rdi, [lst2]
    mov esi, dword [n]
    call selectSort

    lea rdi, [lst3]
    mov esi, dword [n]
    call selectSort

last:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall


global selectSort
selectSort:
    push rbp
    mov rbp, rsp
    sub rsp, 16
    ;rdi      = &lst
    ;rsi      = n
    ;ebp - 16 = i
    ;ebp - 12 = small
    ;ebp - 8  = index
    ;ebp - 4  = j

;first loop
    mov dword [rbp - 16], 0             ;i = 0
LOOP1:
    cmp dword [rbp - 16], esi           ;if (i >= len)
    jge FIN                             ;jump FIN

    mov ecx, [rbp - 16]                 ;ecx = i
    mov eax, dword [rdi + rcx*4]        ;eax = arr[i]
    mov edx, eax                        ;save arr[i] to edx
    mov dword [rbp - 12], eax           ;small = arr[i]
    mov dword [rbp - 8], ecx            ;index = i

;second loop
    mov dword [rbp - 4], ecx            ;j = i
LOOP2:
    cmp dword [rbp - 4], esi            ;if (j >= len)
    jge backLOOP1                       ;jump backLOOP1

;if (arr[j] < small)
    mov ecx, [rbp - 4]                  ;ecx = j
    mov eax, dword [rdi + rcx*4]        ;eax = arr[j]
    cmp dword [rbp - 12], eax           ;if (small <= arr[j]
    jle backLOOP2                       ;jump backLOOP2

    mov dword [rbp - 12], eax           ;small = arr[j]
    mov dword [rbp - 8], ecx            ;index = j

backLOOP2:
;reloop 2
    inc dword [rbp - 4]                 ;j++
    jmp LOOP2

backLOOP1:
    mov ecx, [rbp - 8]                  ;ecx = i
    mov dword [rdi + rcx*4], edx        ;arr[index] = arr[i]
    mov ebx, dword [rbp - 12]           ;ebx = small
    mov ecx, dword [rbp - 16]           ;ecx = i
    mov dword [rdi + rcx*4], ebx        ;arr[i] = small
    
;reloop 1
    inc dword [rbp - 16]                ;i++
    jmp LOOP1

FIN:
    mov rsp, rbp
    pop rbp
    ret
