; /*******************************************************************************
;  * TYPE: LAW | CLASS: INGESTOR | NAME: fire-gem-0003.asm
;  * IDENTITY: VERSION 5.0 // DYNAMIC_TEACHER_OPEN // HAHA!
;  * ROLE: Open avis.AVIS, Read BNF Logic, and Teach Robot. No Hardcoding.
;  *******************************************************************************/

section .data
    source_file db "avis.AVIS", 0
    ack_msg     db "[ACK] GEM-0003: OPENING avis.AVIS FOR DYNAMIC TEACHING...", 10
    ack_len     equ 58
    err_msg     db "[NACK] GEM-0003: ERROR OPENING avis.AVIS", 10
    err_len     equ 41

section .bss
    fd_in       resq 1
    buffer      resb 4096    ; Buffer to hold the BNF logic read from file

section .text
    global _start

_start:
    ; 1. SIGNAL DYNAMIC START
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout
    mov rsi, ack_msg
    mov rdx, ack_len
    syscall

    ; 2. OPEN avis.AVIS (Existing File)
    ; This fulfills the requirement to NOT hardcode the grammar content.
    mov rax, 2          ; sys_open
    mov rdi, source_file
    mov rsi, 0          ; O_RDONLY (Read-Only)
    syscall
    test rax, rax
    js exit_error
    mov [fd_in], rax

    ; 3. READ BNF LOGIC FROM FILE
    mov rax, 0          ; sys_read
    mov rdi, [fd_in]
    mov rsi, buffer
    mov rdx, 4096
    syscall
    
    ; 4. TEACH ROBOT
    ; The buffer now contains the BNF rules loaded from ./avis.AVIS
    mov rdx, rax        ; Use actual number of bytes read
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout
    mov rsi, buffer
    syscall

    ; 5. CLOSE & EXIT
    mov rax, 3          ; sys_close
    mov rdi, [fd_in]
    syscall

    mov rax, 60         ; sys_exit
    xor rdi, rdi
    syscall

exit_error:
    mov rax, 1
    mov rdi, 1
    mov rsi, err_msg
    mov rdx, err_len
    syscall
    mov rax, 60
    mov rdi, 1
    syscall
