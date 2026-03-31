; IDENTITY: VERSION 4.46 // STACK-ALIGNED // HAHA!
section .data
    vault_path  db "fire-gem/artifacts/json/asm/", 0
    sh_bin      db "/bin/bash", 0
    mod_path    db "fire-gem/artifacts/sh/fire-mod.sh", 0
    comp_path   db "fire-gem/artifacts/sh/fire-compile.sh", 0
    run_path    db "fire-gem/artifacts/sh/fire-run.sh", 0

section .bss
    dir_buf     resb 4096
    child_pid   resq 1

section .text
    global _start
_start:
    mov rax, 2          ; sys_open
    mov rdi, vault_path
    xor rsi, rsi        
    syscall
    test rax, rax
    js exit_error       
    mov r8, rax         

    ; Sequence Strike
    mov rdi, mod_path
    call fork_and_exec_worker
    mov rdi, comp_path
    call fork_and_exec_worker
    mov rdi, run_path
    call fork_and_exec_worker

    mov rax, 60         ; sys_exit
    xor rdi, rdi
    syscall

fork_and_exec_worker:
    mov rax, 57         ; sys_fork
    syscall
    test rax, rax
    jz child_worker     
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
exit_error:
    mov rax, 60
    mov rdi, 1
    syscall
