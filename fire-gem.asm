; FILE: fire-gem.asm
; IDENTITY: VERSION 3.4 // MASTER DISPATCHER // HAHA!
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
    xor rsi, rsi        ; O_RDONLY
    syscall
    test rax, rax
    js exit_error       ; Jump to error if directory missing
    mov r8, rax         ; Save Vault File Descriptor (FD)

scan_loop:
    ; 2. READ DIRECTORY ENTRIES (rax=217)
    mov rax, 217        ; sys_getdents64
    mov rdi, r8
    mov rsi, dir_buf
    mov rdx, 4096
    syscall
    test rax, rax
    jle close_exit      ; End of Vault reached

    ; --- TERMINAL PROTOCOL: SEQUENTIAL EXECUTION ---
    ; STEP A: FIRE-MOD
    push mod_path
    call fork_and_exec_worker
    
    ; STEP B: FIRE-COMPILE
    push comp_path
    call fork_and_exec_worker
    
    ; STEP C: FIRE-RUN
    push run_path
    call fork_and_exec_worker

    jmp scan_loop       ; RESUME TO NEXT CJS BLOCK

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
    mov rdi, 1          ; error code 1
    syscall

; --- HELPER: FORK -> EXEC -> WAIT ---
fork_and_exec_worker:
    pop r12             ; Save return address in r12
    pop rdi             ; Get worker path from stack
    
    mov rax, 57         ; sys_fork
    syscall
    test rax, rax
    jz child_worker     ; If rax=0, we are in the child process
    
    ; PARENT LOGIC: WAIT4 (rax=61)
    mov [child_pid], rax
    mov rax, 61
    mov rdi, [child_pid]
    xor rsi, rsi        ; status = NULL
    xor rdx, rdx        ; options = 0
    xor r10, r10        ; rusage = NULL
    syscall             ; PAUSE UNTIL WORKER EXITS
    
    push r12            ; Restore return address
    ret

child_worker:
    ; EXECVE: /bin/bash <worker_path>
    mov rax, 59         ; sys_execve
    mov rdi, sh_bin
    
    ; Build argv [bash, worker_path, NULL]
    xor rax, rax
    push rax            ; NULL terminator
    push rdi            ; worker_path
    push sh_bin         ; "bash"
    mov rsi, rsp        ; rsi = argv pointer
    xor rdx, rdx        ; envp = NULL
    mov rax, 59         ; sys_execve
    syscall
    
    ; If execve fails
    mov rax, 60
    mov rdi, 2
    syscall
