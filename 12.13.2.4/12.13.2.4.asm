section     .data
SYS_exit        equ 60
EXIT_SUCCESS    equ 0

lst1        dd  4,  8,  7,  3,  5,  6,  1,  9,  2,  0
lst2        dd  2,  1,  3,  8,  9,  6,  5,  7,  4,  0
lst3        dd  4,  1,  6,  2,  0,  9,  8,  5,  7,  3
n           dd  10

section     .bss
ave         resq    1
sum         resq    1
min         resq    1
med1        resq    1
med2        resq    1
max         resq    1


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

;call stats2(lst, n, min, med1, med2, max sum, ave)
    push ave
    push sum
    lea r9, [max]
    lea r8, [med2]
    lea rcx, [med1]
    lea rdx, [min]
    mov esi, dword [n]
    lea rdi, [lst1]
    call stats2
    add rsp, 16

last:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall



;Selection Sort Function
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


;Stats Function
global stats2
stats2:
    push rbp
    mov rbp, rsp
    push r12

;Get min and max
    mov eax, dword [rdi]
    mov dword [rdx], eax

    mov r12, rsi
    dec r12
    mov eax, dword [rdi + r12*4]
    mov dword [r9], eax

;Get medians
    mov rax, rsi
    mov rdx, 0
    mov r12, 2
    div r12

    cmp rdx, 0
    je evenLength

    mov r12d, dword [rdi + rax*4]
    mov dword [rcx], r12d
    mov dword [r8], r12d
    jmp medDone

evenLength:
    mov r12d, dword [rdi + rax*4]
    mov dword [r8], r12d
    dec rax
    mov r12d, dword [rdi + rax*4]
    mov dword [rcx], r12d
medDone:

;Find sum
    mov r12, 0
    mov rax, 0

sumLoop2:
    add eax, dword [rdi + r12*4]
    inc r12
    cmp r12, rsi
    jl sumLoop2

    mov r12, qword [rbp+16]
    mov dword [r12], eax

;Calculate average
    cdq
    idiv rsi
    mov r12, qword [rbp + 24]
    mov dword [r12], eax

    pop r12
    pop rbp
    ret
