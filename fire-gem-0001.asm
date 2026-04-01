; /*******************************************************************************
;  * TYPE: LAW | CLASS: MIRROR-INGESTOR | NAME: fire-gem-0001.asm
;  * IDENTITY: VERSION 4.8 // ERROR_PULSE_ENABLED // HAHA!
;  *******************************************************************************/

section .data
    in_dir      db "fire-gem/artifacts/json/reg/", 0
    ack_msg     db "[ACK] GEM-0001: THREAD ESCALATION INITIALIZED...", 10
    ack_len     equ 48
    err_msg     db "[NACK] GEM-0001: FATAL - VAULT PATH NOT FOUND", 10
    err_len     equ 44

section .bss
    dir_buf     resb 4096

section .text
    global _start

_start:
    ; 1. OPEN VAULT FIRST (Check existence before pulsing)
    mov rax, 2          ; sys_open
    mov rdi, in_dir
    xor rsi, rsi        ; O_RDONLY
    syscall
    test rax, rax
    js .fatal_error     ; If negative, the directory doesn't exist
    mov r8, rax         ; Save FD

    ; 2. SIGNAL SUCCESSFUL HANDSHAKE
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout
    mov rsi, ack_msg
    mov rdx, ack_len
    syscall

    ; 3. CRAWL & CLOSE
    ; (Placeholder for getdents logic)
    
    mov rax, 3          ; sys_close
    mov rdi, r8
    syscall
    
    mov rax, 60         ; sys_exit
    xor rdi, rdi
    syscall

.fatal_error:
    ; 4. SIGNAL ERROR (This fixes the empty log)
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout
    mov rsi, err_msg
    mov rdx, err_len
    syscall

    mov rax, 60         ; sys_exit
    mov rdi, 1
    syscall

