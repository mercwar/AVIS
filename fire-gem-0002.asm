; /*******************************************************************************
;  * TYPE: LAW | CLASS: PROCESSOR | NAME: fire-gem-0002.asm
;  * IDENTITY: VERSION 4.85 // AUTO-MATERIALIZE // HAHA!
;  * ROLE: Devour Vault. If Vault is empty, Materialize target placeholder.
;  *******************************************************************************/

section .data
    cbord_dir   db "fire-gem/artifacts/json/cbord/reg/", 0
    test_file   db "fire-gem/artifacts/json/cbord/reg/materialized_001.exe", 0
    
    ack_msg     db "[ACK] GEM-0002: VAULT ACTIVE. DEVOURING...", 10
    ack_len     equ 45
    mat_msg     db "[ACK] GEM-0002: VAULT EMPTY. MATERIALIZING 001...", 10
    mat_len     equ 49
    elf_magic   db 0x7f, 'E', 'L', 'F'

section .bss
    dir_buf     resb 4096
    fd_out      resq 1

section .text
    global _start

_start:
    ; 1. OPEN VAULT
    mov rax, 2          ; sys_open
    mov rdi, cbord_dir
    xor rsi, rsi        ; O_RDONLY
    syscall
    test rax, rax
    js exit_error
    mov r8, rax         ; Vault FD

    ; 2. CRAWL NAMESPACE
    mov rax, 217        ; sys_getdents64
    mov rdi, r8
    mov rsi, dir_buf
    mov rdx, 4096
    syscall

    ; 3. CHECK IF EMPTY (nread <= 48 approx for . and ..)
    cmp rax, 48         
    jle materialize_target

    ; --- DEVOUR LOOP ---
    mov rcx, 5
.flush:
    push rcx
    mov rax, 1          ; sys_write
    mov rdi, 1
    mov rsi, ack_msg
    mov rdx, ack_len
    syscall
    pop rcx
    loop .flush
    jmp close_exit

materialize_target:
    ; 4. DROP FILE INTO EMPTY VAULT
    mov rax, 2          ; sys_open
    mov rdi, test_file
    mov rsi, 65         ; O_CREAT | O_WRONLY
    mov rdx, 0755o      ; Executable permissions
    syscall
    mov [fd_out], rax

    ; Seat ELF Handshake
    mov rax, 1
    mov rdi, [fd_out]
    mov rsi, elf_magic
    mov rdx, 4
    syscall

    ; Close Drop
    mov rax, 3
    mov rdi, [fd_out]
    syscall

    ; Log Materialization
    mov rax, 1
    mov rdi, 1
    mov rsi, mat_msg
    mov rdx, mat_len
    syscall

close_exit:
    mov rax, 3          ; close vault
    mov rdi, r8
    syscall
    mov rax, 60         ; exit
    xor rdi, rdi
    syscall

exit_error:
    mov rax, 60
    mov rdi, 1
    syscall
