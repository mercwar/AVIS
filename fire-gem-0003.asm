; IDENTITY: VERSION 5.1 // FLUSH_ENABLED_INGESTOR // HAHA!
section .data
    source_file db "avis.AVIS", 0
    ack_msg     db "[ACK] GEM-0003: DYNAMIC TEACHING ACTIVE", 10, 0
    ack_len     equ 42

section .bss
    fd_in       resq 1
    buffer      resb 4096

section .text
    global _start
_start:
    ; 1. ANNOUNCE WITH NEWLINE (Forces Line Flush)
    mov rax, 1
    mov rdi, 1
    mov rsi, ack_msg
    mov rdx, ack_len
    syscall

    ; 2. OPEN & READ
    mov rax, 2
    mov rdi, source_file
    mov rsi, 0
    syscall
    test rax, rax
    js exit_error
    mov [fd_in], rax

    mov rax, 0
    mov rdi, [fd_in]
    mov rsi, buffer
    mov rdx, 4096
    syscall

    ; 3. WRITE CONTENT TO LOG
    mov rdx, rax
    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    syscall

    ; 4. FSYNC (Forces OS to write to disk)
    mov rax, 74         ; sys_fsync
    mov rdi, 1          ; stdout
    syscall

    ; 5. EXIT
    mov rax, 60
    xor rdi, rdi
    syscall

exit_error:
    mov rax, 60
    mov rdi, 1
    syscall

