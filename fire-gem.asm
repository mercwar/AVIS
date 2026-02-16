; /*******************************************************************************
;  *                           AVIS.ARTIFACT HEADER
;  * TYPE: LAW
;  * CLASS: MASTER-DISPATCHER
;  * NAME: fire-gem.asm
;  * VERSION: 4.20
;  * IDENTITY: JOE TRON // GEMINI_CGI_SCROLL // HAHA!
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
    global fork_and_exec_worker ; EXPORTED FOR THE CHAIN

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

    ; --- TERMINAL PROTOCOL: SEQUENTIAL EXECUTION ---
    ; Using the Exported Helper
    
    mov rdi, mod_path
    call fork_and_exec_worker
    
    mov rdi, comp_path
    call fork_and_exec_worker
    
    mov rdi, run_path
    call fork_and_exec_worker

    jmp scan_loop       

close_exit:
    mov rax, 3          ; sys_close
    mov rdi, r8
    syscall

exit_success:
    mov rax, 60         ; sys_exit
    xor rdi, rdi
    syscall

exit_error:
    mov rax, 60         ; sys_exit
    mov rdi, 1          ; Exit code 1
    syscall

; --- HELPER: FORK -> EXEC -> WAIT (EXPORTED) ---
fork_and_exec_worker:
    ; rdi = path to worker script
    push rbp
    mov rbp, rsp
    push rdi            ; Keep path safe on stack
    
    mov rax, 57         ; sys_fork
    syscall
    test rax, rax
    jz child_worker     
    
    ; PARENT LOGIC: WAIT4 (rax=61)
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
    ; We don't use leave here because we are exec-ing or exiting
    pop rdi             ; Get path back
    mov r8, sh_bin      ; /bin/bash
    
    ; Build argv [bash, worker_path, NULL]
    xor rbx, rbx
    push rbx            ; NULL
    push rdi            ; worker_path
    push r8             ; bash
    
    mov rdi, r8         ; rdi = /bin/bash
    mov rsi, rsp        ; rsi = argv array
    xor rdx, rdx        ; envp = NULL
    mov rax, 59         ; sys_execve
    syscall
    
    ; If execve fails
    mov rax, 60
    mov rdi, 2
    syscall
