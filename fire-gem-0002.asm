; /*******************************************************************************
;  * TYPE: LAW | CLASS: PROCESSOR | NAME: fire-gem-0002.asm
;  * IDENTITY: VERSION 4.81 // STABLE BRANCH // HAHA!
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
    read_buf    resb 4      

section .text
    global _start

_start:
    ; 1. OPEN CBORD VAULT
    mov rax, 2
    mov rdi, cbord_dir
    xor rsi, rsi        
    syscall
    test rax, rax
    js exit_error
    mov r8, rax         ; Vault FD

scan_cbord:
    ; 2. CRAWL NAMESPACE
    mov rax, 217
    mov rdi, r8
    mov rsi, dir_buf
    mov rdx, 4096
    syscall
    
    cmp rax, 0
    jle close_exit      

    ; [DEVOURING LOGIC]
    push rax            ; Save bytes read
    
    ; Log the Devour Signal
    mov rax, 1
    mov rdi, 1
    mov rsi, ack_msg
    mov rdx, ack_len
    syscall

    pop rax             ; Restore bytes read
    jmp scan_cbord

close_exit:
    mov rax, 3          
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
