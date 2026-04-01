; IDENTITY: VERSION 4.50 // ERROR_PULSE_ENABLED // HAHA!
section .data
    vault_path  db "fire-gem/artifacts/json/asm/", 0
    sh_bin      db "/bin/bash", 0
    mod_path    db "./fire-gem/artifacts/sh/fire-mod.sh", 0
    comp_path   db "./fire-gem/artifacts/sh/fire-compile.sh", 0
    run_path    db "./fire-gem/artifacts/sh/fire-run.sh", 0
    
    err_msg     db "[NACK] MASTER_DISPATCH: FATAL - VAULT OR SH MISSING", 10
    err_len     equ 51

section .bss
    dir_buf     resb 4096
    child_pid   resq 1

section .text
    global _start
_start:
    ; 1. OPEN VAULT
    mov rax, 2          
    mov rdi, vault_path
    xor rsi, rsi        
    syscall
    test rax, rax
    js exit_error       
    mov r8, rax         

    ; 2. SEQUENCE STRIKE
    mov rdi, mod_path
    call fork_and_exec_worker
    mov rdi, comp_path
    call fork_and_exec_worker
    mov rdi, run_path
    call fork_and_exec_worker

    mov rax, 60         
    xor rdi, rdi
    syscall

exit_error:
    ; 3. SIGNAL FATAL (Fixes the Empty Log)
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout
    mov rsi, err_msg
    mov rdx, err_len
    syscall

    mov rax, 60         
    mov rdi, 1          
    syscall

fork_and_exec_worker:
    mov rax, 57         ; sys_fork
    syscall
    test rax, rax
    jz child_worker     
    
    ; PARENT: WAIT
    mov rax, 61         ; sys_wait4
    mov rdi, -1
    xor rsi, rsi
    xor rdx, rdx
    xor r10, r10
    syscall
    ret

child_worker:
    mov r8, sh_bin
    push 0
    push rdi
    push r8
    mov rdi, r8
    mov rsi, rsp
    xor rdx, rdx
    mov rax, 59         ; sys_execve
    syscall
    jmp exit_error
