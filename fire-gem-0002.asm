; /*******************************************************************************
;  * TYPE: LAW | CLASS: PROCESSOR | NAME: fire-gem-0002.asm
;  * IDENTITY: VERSION 4.80 // JOE TRON // CVBGOD // HAHA!
;  * ROLE: Devour Materialized CBORD Mirror & Execute Terminal Language.
;  *******************************************************************************/

section .data
    cbord_dir   db "fire-gem/artifacts/cbord/reg/", 0
    ack_msg     db "[ACK] GEM-0002: DEVOURING MATERIALIZED DROP: ", 0
    ack_len     equ 45
    elf_magic   db 0x7f, 'E', 'L', 'F'

section .bss
    dir_buf     resb 4096
    fd_in       resq 1
    read_buf    resb 4      ; To verify the .ELF handshake

section .text
    global _start

_start:
    ; 1. OPEN CBORD VAULT (rax=2)
    mov rax, 2
    mov rdi, cbord_dir
    xor rsi, rsi        ; O_RDONLY
    syscall
    test rax, rax
    js exit_error
    mov r8, rax         ; Vault FD

scan_cbord:
    ; 2. CRAWL NAMESPACE (rax=217)
    mov rax, 217
    mov rdi, r8
    mov rsi, dir_buf
    mov rdx, 4096
    syscall
    test rax, rax
    jle close_exit      ; End of Vault

    ; [DEVOURING LOGIC]
    ; 0002 opens the materialized file with the EXACT DUPLICATE name.
    ; A. Log the Devour Signal
    mov rax, 1
    mov rdi, 1
    mov rsi, ack_msg
    mov rdx, ack_len
    syscall

    ; B. VERIFY ELF HANDSHAKE (7f 45 4c 46)
    ; (Logic to open current file from dir_buf and read first 4 bytes)
    
    ; C. EXECUTE CYHY-ASM-EVAL
    ; This is where the terminal language is parsed into Linux Syscalls.

    jmp scan_cbord

close_exit:
    mov rax, 3          ; sys_close
    mov rdi, r8
    syscall

exit_success:
    mov rax, 60
    xor rdi, rdi
    syscall

exit_error:
    mov rax, 60
    mov rdi, 1
    syscall
