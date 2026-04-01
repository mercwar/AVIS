; IDENTITY: VERSION 4.9 // FORCE_FLUSH_INGESTOR // HAHA!
section .data
    in_dir      db "fire-gem/artifacts/json/reg/", 0
    ack_msg     db "[ACK] GEM-0001: VAULT OPEN. ESCALATING...", 10
    ack_len     equ 43
    err_msg     db "[NACK] GEM-0001: FATAL - PATH NOT FOUND", 10
    err_len     equ 40

section .bss
    dir_buf     resb 4096

section .text
    global _start

_start:
    ; 1. ATTEMPT OPEN
    mov rax, 2          ; sys_open
    mov rdi, in_dir
    xor rsi, rsi        ; O_RDONLY
    syscall
    test rax, rax
    js .fatal_error
    mov r8, rax         ; Save FD

    ; 2. SIGNAL SUCCESS
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout
    mov rsi, ack_msg
    mov rdx, ack_len
    syscall

    ; 3. EXIT CLEAN
    mov rax, 3          ; sys_close
    mov rdi, r8
    syscall
    mov rax, 60
    xor rdi, rdi
    syscall

.fatal_error:
    ; 4. SIGNAL FATAL (Forces output to log)
    mov rax, 1
    mov rdi, 1
    mov rsi, err_msg
    mov rdx, err_len
    syscall
    
    ; 5. SYNC (Hardware flush)
    mov rax, 74         ; sys_fsync
    mov rdi, 1
    syscall

    mov rax, 60
    mov rdi, 1
    syscall
