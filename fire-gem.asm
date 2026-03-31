; /*******************************************************************************
;  *                           AVIS.ARTIFACT HEADER
;  * TYPE: LAW | CLASS: MASTER-DISPATCHER | NAME: fire-gem.asm
;  * IDENTITY: VERSION 4.46 // STACK-ALIGNED // HAHA!
;  *******************************************************************************/

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
    ; 1. OPEN VAULT DIRECTORY
    mov rax, 2          
    mov rdi, vault_path
    xor rsi, rsi        
    syscall
    test rax, rax
    js exit_error       
    mov r8, rax         

    ; 2. SINGLE SCAN TRIGGER
    ; Instead of looping per-file (which triggers scripts multiple times),
    ; we trigger the sequence once the vault is confirmed accessible.
    mov rax, 217        
    mov rdi, r8
    mov rsi, dir_buf
    mov rdx, 4096
    syscall
    test rax, rax
    jle close_exit      

    ; --- NUMERIC PROTOCOL SEQUENCE ---
    mov rdi, mod_path
    call fork_and_exec_worker
    
    mov rdi, comp_path
    call fork_and_exec_worker
    
    mov rdi, run_path
    call fork_and_exec_worker

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
    mov rax, 60         
    mov rdi, 1          
    syscall

; --- HELPER: FORK -> EXEC -> WAIT ---
fork_and_exec_worker:
    push rbp
    mov rbp, rsp
    
    mov rax, 57         ; sys_fork
    syscall
    test rax, rax
    js .fork_fail       ; Jump if fork < 0
    jz child_worker     
    
    ; PARENT: WAIT4
    mov [child_pid], rax
    mov rax, 61
    mov rdi, [child_pid]
    xor rsi, rsi        
    xor rdx, rdx        
    xor r10, r10        
    syscall             
    
.fork_fail:
    leave
    ret

child_worker:
    ; Align stack and build argv: [bash, path, NULL]
    mov rdi, [rbp-8]    ; Retrieve path pushed in parent scope or passed
    mov r8, sh_bin
    
    xor rbx, rbx
    push rbx            ; NULL terminator
    push rdi            ; script path
    push r8             ; /bin/bash
    
    mov rdi, r8         ; filename: /bin/bash
    mov rsi, rsp        ; argv: pointer to the stack we just built
    xor rdx, rdx        ; envp: NULL
    mov rax, 59         ; sys_execve
    syscall
    
    ; If execve fails
    mov rax, 60
    mov rdi, 2
    syscall
