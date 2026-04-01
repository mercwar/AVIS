; /*******************************************************************************
;  * TYPE: LAW | CLASS: MIRROR-INGESTOR | NAME: fire-gem-0001.asm
;  * IDENTITY: VERSION 4.75 // RESTORED // HAHA!
;  *******************************************************************************/

section .data
    in_dir      db "fire-gem/artifacts/json/reg/", 0
    ack_msg     db "[ACK] GEM-0001: THREAD ESCALATION INITIALIZED...", 10
    ack_len     equ 48

section .bss
    dir_buf     resb 4096

section .text
    global _start

_start:
    ; 1. SIGNAL PULSE
    mov rax, 1
    mov rdi, 1
    mov rsi, ack_msg
    mov rdx, ack_len
    syscall

    ; 2. OPEN VAULT
    mov rax, 2
    mov rdi, in_dir
    xor rsi, rsi
    syscall
    test rax, rax
    js exit_error
    mov r8, rax

    ; 3. CRAWL & EXIT (Seals pulse to prevent loop)
    mov rax, 3
    mov rdi, r8
    syscall
    
    mov rax, 60
    xor rdi, rdi
    syscall

exit_error:
    mov rax, 60
    mov rdi, 1
    syscall
