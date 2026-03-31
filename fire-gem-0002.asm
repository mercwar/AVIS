; /*******************************************************************************
;  * TYPE: LAW | CLASS: PROCESSOR | NAME: fire-gem-0002.asm
;  * IDENTITY: VERSION 4.84 // PATH_ALIGNED // HAHA!
;  * ROLE: Devour Materialized CBORD Mirror & Execute Terminal Language.
;  *******************************************************************************/

section .data
    ; UPDATED PATH TO MATCH YOUR TARGET
    cbord_dir   db "fire-gem/artifacts/json/cbord/reg/", 0
    
    ack_msg     db "[ACK] GEM-0002: VAULT DETECTED. DEVOURING DROP...", 10
    ack_len     equ 48
    err_msg     db "[NACK] GEM-0002: VAULT NOT FOUND AT JSON/CBORD/REG/", 10
    err_len     equ 52

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
    js exit_error       
    
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

    ; --- FLUSH PROTOCOL (Ensures Log Visibility) ---
    mov rcx, 10         ; Reduced to 10 for cleaner logs now that it works
.flush:
    push rcx
    push rax            
    mov rax, 1          
    mov rdi, 1          
    mov rsi, ack_msg
    mov rdx, ack_len
    syscall
    pop rax
    pop rcx
    loop .flush         

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
    ; 3. ERROR LOGGING
    mov rcx, 10        
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
