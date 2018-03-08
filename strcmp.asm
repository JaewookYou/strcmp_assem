
global main

SECTION .data
input_str1 : db "%d", 0, 0, 0, 0, 0, 0
input_str2 : db "%d", 0, 0, 0, 0, 0, 0

sysstr1 : db "Hello, Minivet! I'm ar9ang3.", 0xa, 0
ss1_len : equ $ - sysstr1
sysstr2 : db "If you input string message, I will compare that.", 0xa, 0
ss2_len : equ $ - sysstr2
sysstr3 : db "[*] Input 1st Compare Message : ", 0
ss3_len : equ $ - sysstr3
sysstr4 : db "[*] Input 2nd Compare Message : ", 0
ss4_len : equ $ - sysstr4
sysstr5 : db 0xa, " ###Compare Result : ", 0
ss5_len : equ $ - sysstr5

enter : db 0xa, 0

SECTION .bss
a resd 16
b resd 16

SECTION .text

main:
    mov rdi, 0x1
    mov rsi, enter
    mov rdx, 0x2
    mov rax, 0x1
    syscall             ; print \n

    mov rdi, 0x1
    mov rsi, sysstr1
    mov rdx, ss1_len
    mov rax, 0x1
    syscall             ; sys msg

    mov rdi, 0x1
    mov rsi, sysstr2
    mov rdx, ss2_len
    mov rax, 0x1
    syscall             ; sys msg

    mov rdi, 0x1
    mov rsi, sysstr3
    mov rdx, ss3_len
    mov rax, 0x1
    syscall             ; Get 1st input msg

    mov rdi, 0x0
    mov rsi, input_str1
    mov rdx, a
    mov rax, 0x0
    syscall             ; (read) 1st input

    mov r13, rax         ; r13 = 1st input len

    mov rdi, 0x1
    mov rsi, sysstr4
    mov rdx, ss4_len
    mov rax, 0x1
    syscall             ; Get 2nd input msg

    mov rdi, 0x0
    mov rsi, input_str2
    mov rdx, b
    mov rax, 0x0
    syscall             ; (read) 2nd input

    mov r14, rax        ; r14 = 2nd input len

    ; ---------------------------------------------------
    call strcmp         ; call strcmp!!!!@!@!!!!
    ; ---------------------------------------------------
   
    xor r8, r8
    mov r8, rax

    mov rdi, 0x1
    mov rsi, sysstr5
    mov rdx, ss5_len
    mov rax, 0x1
    syscall             ; print pre_result

    cmp r8, 0x0
    je Rsuc
    jl Rsmall
    jg Rbig

    ; if return is 1
    Rbig:
    sub rsp, 0x3
    push 0x0a31
    mov rdi, 0x1
    mov rsi, rsp
    mov rdx, 0x3
    mov rax, 0x1
    syscall             ; print compare result success "1"
    pop rax
    add rsp, 3
    ret

    ; if return is -1
    Rsmall:
    sub rsp, 0x4
    push 0x0a312d
    mov rdi, 0x1
    mov rsi, rsp
    mov rdx, 0x4
    mov rax, 0x1
    syscall             ; print compare result fail "-1"
    add rsp, 0x4
    jmp finish

    ; if return is 0
    Rsuc:
    sub rsp, 0x3
    push 0x0a30
    mov rdi, 0x1
    mov rsi, rsp
    mov rdx, 0x3
    mov rax, 0x1
    syscall
    add rsp, 0x3

    finish:
    pop rax
    ret

    ; ---------------------------------------------------

strcmp:
    cmp r13, r14         ; if len is different
    jg big               ; if str1_len > str2_len
    jl small             ; if str2_len > str1_len

    ; from here c lang example
    ; for(int i=0; i<str_len1; i++) {
    ;    if(input_str1[i]>input_str2[i])
    ;        return 1;
    ;    else(input_str1[i]<input_str2[i])
    ;        return -1;
    ; }

    ;mov rcx, 0x0
    ;and rcx, 0x0
    xor rcx, rcx        ; initializing rcx to use loop
    check:
    ;cmp rcx, r13
    xor rcx, r13
    je fin_check        ; end loop
    
    ;mov rax, [input_str1+rcx]
    ;shr rax, 7
    ;mov rbx, [input_str2+rcx]
    ;shr rbx, 7
    mov al, [input_str1+rcx]
    mov bl, [input_str2+rcx]
    cmp al, bl
    jg big
    jl small

    inc rcx
    jmp check

    fin_check:          ; if str1 == str2
    xor rax, rax
    jmp fin_cmp

    ; -------------------------------------------------

    big:                ; if str1_len > str2_len
    ;mov rax, 0x1
    and rax, 0x1        ; optimizer
    jmp fin_cmp

    small:              ; if str2_len > str1_len
    ;mov rax, -0x1
    and rax, -0x1       ; optimizer
    jmp fin_cmp
    

    fin_cmp:
    xor r14, r14
    xor r13, r13    ; free register
    ret

