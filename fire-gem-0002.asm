; /*******************************************************************************
;  * TYPE: LAW | CLASS: PROCESSOR | NAME: fire-gem-0002.asm
;  * IDENTITY: VERSION 4.82 // VERBOSE_ERROR // HAHA!
;  * ROLE: Devour Materialized CBORD Mirror & Execute Terminal Language.
;  *******************************************************************************/

section .data
    cbord_dir   db "fire-gem/artifacts/cbord/reg/", 0
    ack_msg     db "[ACK] GEM-0002: DEVOURING MATERIALIZED DROP...", 10
    ack_len     equ 47
    err_msg     db "[NACK] GEM-0002: VAULT NOT FOUND OR ACCESS DENIED.", 10
    err_len     equ 51

section .bss
    dir_buf     resb 4096
    fd_in       resq 1

section .text
    global _start

_start:
    ; 1. OPEN CBORD VAULT (rax=2)
    mov rax, 2
    mov rdi, cbord_dir
    xor rsi, rsi        ; O_RDONLY
    syscall
    
    ; Check if FD is negative (Error)
    test rax, rax
    js exit_error
    
    mov r8, rax         ; Vault FD seated in r8

scan_cbord:
    ; 2. CRAWL NAMESPACE (rax=217)
    mov rax, 217
    mov rdi, r8
    mov rsi, dir_buf
    mov rdx, 4096
    syscall
    
    cmp rax, 0
    jle close_exit      ; End of vault reached

    ; [DEVOURING LOGIC]
    push rax            ; Save bytes read for loop safety
    
    ; Log the Devour Signal to fire-run-fire-gem-0002_bin.log
    mov rax, 1
    mov rdi, 1          ; STDOUT
    mov rsi, ack_msg
    mov rdx, ack_len
    syscall

    pop rax             ; Restore bytes read
    jmp scan_cbord

close_exit:
    ; 3. CLOSE VAULT
    mov rax, 3          
    mov rdi, r8
    syscall

exit_success:
    mov rax, 60
    xor rdi, rdi
    syscall

exit_error:
    ; 4. ERROR LOGGING (Fixes the "Empty Log" issue)
    mov rax, 1          ; sys_write
    mov rdi, 1          ; STDOUT
    mov rsi, err_msg
    mov rdx, err_len
    syscall

    mov rax, 60         ; sys_exit
    mov rdi, 1          ; Exit code 1
    syscall
