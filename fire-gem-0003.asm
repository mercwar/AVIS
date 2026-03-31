; IDENTITY: VERSION 5.2 // VERIFIED_INGESTOR // HAHA!
section .data
    source_file db "avis.AVIS", 0
    ack_msg     db "[ACK] GEM-0003: avis.AVIS LOADED. STREAMING BNF...", 10, 0
    ack_len     equ 48
    err_msg     db "[NACK] GEM-0003: FATAL - avis.AVIS NOT FOUND", 10, 0
    err_len     equ 43

section .bss
    fd_in       resq 1
    buffer      resb 4096

section .text
    global _start
_start:
    ; 1. ATTEMPT OPEN
    mov rax, 2          ; sys_open
    mov rdi, source_file
    xor rsi, rsi        ; O_RDONLY
    syscall
    test rax, rax
    js .file_error      ; If RAX < 0, handle error
    mov [fd_in], rax

    ; 2. SIGNAL SUCCESSFUL LOAD
    mov rax, 1
    mov rdi, 1
    mov rsi, ack_msg
    mov rdx, ack_len
    syscall

    ; 3. READ & STREAM
    mov rax, 0          ; sys_read
    mov rdi, [fd_in]
    mov rsi, buffer
    mov rdx, 4096
    syscall
    
    mov rdx, rax        ; Bytes read
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout
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
