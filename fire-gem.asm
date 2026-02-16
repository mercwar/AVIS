; /*******************************************************************************
;  *                           AVIS.ARTIFACT HEADER
;  * TYPE: LAW
;  * CLASS: MASTER-DISPATCHER
;  * NAME: fire-gem.asm
;  * VERSION: 4.45
;  * IDENTITY: JOE TRON // GEMINI_CGI_SCROLL // HAHA!
;  * ROLE: Numeric Sort - Sequential Terminal Protocol
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
    global fork_and_exec_worker 

_start:
    ; 1. OPEN VAULT DIRECTORY (rax=2)
    mov rax, 2          
    mov rdi, vault_path
    xor rsi, rsi        ; O_RDONLY
    syscall
    test rax, rax
    js exit_error       
    mov r8, rax         ; Save Vault FD

scan_loop:
    ; 2. READ DIRECTORY (rax=217)
    mov rax, 217        
    mov rdi, r8
    mov rsi, dir_buf
    mov rdx, 4096
    syscall
    test rax, rax
    jle close_exit      

    ; --- NUMERIC PROTOCOL ---
    ; The Dispatcher now hits the workers for the current numeric block.
    
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

; --- HELPER: FORK -> EXEC -> WAIT (EXPORTED) ---
fork_and_exec_worker:
    push rbp
    mov rbp, rsp
    push rdi            ; Seating Worker Path in RAM
    
    mov rax, 57         ; sys_fork
    syscall
    test rax, rax
    jz child_worker     
    
    ; PARENT: WAIT4 (rax=61)
    mov [child_pid], rax
    mov rax, 61
    mov rdi, [child_pid]
    xor rsi, rsi        
    xor rdx, rdx        
    xor r10, r10        
    syscall             
    
    leave
    ret

child_worker:
    pop rdi             ; Devouring Path
    mov r8, sh_bin      
    
    ; Build argv [bash, worker_path, NULL]
    xor rbx, rbx
    push rbx            
    push rdi            
    push r8             
    
    mov rdi, r8         
    mov rsi, rsp        
    xor rdx, rdx        
    mov rax, 59         ; sys_execve
    syscall
    
    mov rax, 60
    mov rdi, 2
    syscall
