; /*******************************************************************************
;  * TYPE: LAW | CLASS: PROCESSOR | NAME: fire-gem-0002.asm
;  * IDENTITY: VERSION 4.83 // FORCE_FLUSH_PROTOCOL // HAHA!
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
    ; 1. OPEN CBORD VAULT
    mov rax, 2
    mov rdi, cbord_dir
    xor rsi, rsi        
    syscall
    
    test rax, rax
    js exit_error       ; If folder missing, jump to error log
    
    mov r8, rax         ; Save FD

scan_cbord:
    ; 2. CRAWL NAMESPACE
    mov rax, 217
    mov rdi, r8
    mov rsi, dir_buf
    mov rdx, 4096
    syscall
    
    cmp rax, 0
    jle close_exit      

    ; --- FORCE FLUSH PROTOCOL ---
    ; We write the ACK 100 times to fill the 4KB buffer and force a disk write.
    mov rcx, 100        
.flush:
    push rcx
    push rax            ; Save bytes-read from getdents
    mov rax, 1          ; sys_write
    mov rdi, 1          ; STDOUT (Redirected to log)
    mov rsi, ack_msg
    mov rdx, ack_len
    syscall
    pop rax
    pop rcx
    loop .flush         ; Repeat until rcx is 0

    jmp scan_cbord

close_exit:
    mov rax, 3          
    mov rdi, r8
    syscall
    jmp exit_success

exit_success:
    mov rax, 60
    xor rdi, rdi
    syscall

exit_error:
    ; 3. ERROR LOGGING (Forces NACK into the log)
    mov rcx, 100        ; Flush the error too
.err_flush:
    push rcx
    mov rax, 1
    mov rdi, 1
    mov rsi, err_msg
    mov rdx, err_len
    syscall
    pop rcx
    loop .err_flush

    mov rax, 60
    mov rdi, 1
    syscall
