; /*******************************************************************************
;  * TYPE: LAW | CLASS: PROCESSOR | NAME: fire-gem-0002.asm
;  * IDENTITY: VERSION 4.86 // LOOP_BREAK_PROTOCOL // HAHA!
;  *******************************************************************************/

section .data
    cbord_dir   db "fire-gem/artifacts/json/cbord/reg/", 0
    ack_msg     db "[ACK] GEM-0002: VAULT DETECTED. SCANNING...", 10
    ack_len     equ 44
    fin_msg     db "[ACK] GEM-0002: SCAN COMPLETE. RELEASING THREAD.", 10
    fin_len     equ 48

section .bss
    dir_buf     resb 4096

section .text
    global _start

_start:
    ; 1. SIGNAL START
    mov rax, 1
    mov rdi, 1
    mov rsi, ack_msg
    mov rdx, ack_len
    syscall

    ; 2. OPEN & SCAN (Single pass)
    mov rax, 2
    mov rdi, cbord_dir
    xor rsi, rsi        
    syscall
    test rax, rax
    js exit_error
    mov r8, rax

    mov rax, 217        ; sys_getdents64
    mov rdi, r8
    mov rsi, dir_buf
    mov rdx, 4096
    syscall

    ; 3. CLOSE & SIGNAL FINISH
    mov rax, 3
    mov rdi, r8
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, fin_msg
    mov rdx, fin_len
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

exit_error:
    mov rax, 60
    mov rdi, 1
    syscall
