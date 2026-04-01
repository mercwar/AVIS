; /*******************************************************************************
;  * TYPE: LAW | CLASS: INGESTOR | NAME: fire-gem-0003.asm
;  * IDENTITY: VERSION 5.2 // VERIFIED_INGESTOR // HAHA!
;  *******************************************************************************/

section .data
    source_file db "avis.AVIS", 0
    ack_msg     db "[ACK] GEM-0003: avis.AVIS LOADED. STREAMING BNF...", 10
    ack_len     equ 48
    err_msg     db "[NACK] GEM-0003: FATAL - avis.AVIS NOT FOUND", 10
    err_len     equ 43

section .bss
    fd_in       resq 1
    buffer      resb 4096

section .text
    global _start

_start:
    ; 1. OPEN TEACHER FILE
    mov rax, 2
    mov rdi, source_file
    xor rsi, rsi
    syscall
    test rax, rax
    js .file_error
    mov [fd_in], rax

    ; 2. SIGNAL SUCCESS
    mov rax, 1
    mov rdi, 1
    mov rsi, ack_msg
    mov rdx, ack_len
    syscall

    ; 3. READ & STREAM TO STDOUT (Captured by Zero-Buffer Log)
    mov rax, 0
    mov rdi, [fd_in]
    mov rsi, buffer
    mov rdx, 4096
    syscall
    
    mov rdx, rax
    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    syscall

    jmp .exit_clean

.file_error:
    mov rax, 1
    mov rdi, 1
    mov rsi, err_msg
    mov rdx, err_len
    syscall

.exit_clean:
    mov rax, 60
    xor rdi, rdi
    syscall
