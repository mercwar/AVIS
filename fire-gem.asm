; FILE: fire-gem.asm
; IDENTITY: VERSION 3.55 // MASTER DISPATCHER // HAHA!
; ROLE: Sequential Terminal Protocol - JSON-to-Shell Pipeline.

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
    ; 1. OPEN VAULT DIRECTORY (rax=2)
    mov rax, 2          
    mov rdi, vault_path
    xor rsi, rsi        
    syscall
    test rax, rax
    js exit_error       
    mov r8, rax         

scan_loop:
    ; 2. READ DIRECTORY (rax=217)
    mov rax, 217        
    mov rdi, r8
    mov rsi, dir_buf
    mov rdx, 4096
    syscall
    test rax, rax
    jle close_exit      

    ; --- TERMINAL PROTOCOL: SEQUENTIAL EXECUTION ---
    ; FIX: Push address to stack before calling the worker
    
    mov rdi, mod_path
    call fork_and_exec_worker
    
    mov rdi, comp_path
    call fork_and_exec_worker
    
    mov rdi, run_path
    call fork_and_exec_worker

    jmp scan_loop       

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

; --- HELPER: FORK -> EXEC -> WAIT ---
fork_and_exec_worker:
    ; rdi contains the path to the worker script
    push rdi            ; Save path
    
    mov rax, 57         ; sys_fork
    syscall
    test rax, rax
    jz child_worker     
    
    ; PARENT: WAIT
    pop rdi             ; Clean stack
    mov [child_pid], rax
    mov rax, 61
    mov rdi, [child_pid]
    xor rsi, rsi        
    xor rdx, rdx        
    xor r10, r10        
    syscall             
    ret

child_worker:
    pop rdi             ; Get path from stack
    mov rax, 59         ; sys_execve
    mov r8, sh_bin      ; Load /bin/bash
    
    ; Build argv [bash, worker_path, NULL]
    xor rbx, rbx
    push rbx            ; NULL
    push rdi            ; worker_path
    push r8             ; /bin/bash
    
    mov rdi, r8         ; rdi = /bin/bash
    mov rsi, rsp        ; rsi = argv
    xor rdx, rdx        ; rdx = envp = NULL
    syscall
    
    ; If execve fails, exit child
    mov rax, 60
    mov rdi, 2
    syscall
