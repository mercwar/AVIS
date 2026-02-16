; FILE: fire-gem.asm
; IDENTITY: VERSION 3 // MASTER DISPATCHER // HAHA!
; TARGET: x86_64 Linux System Calls

section .data
    vault_path  db "fire-gem/artifacts/json/asm/", 0
    mod_path    db "fire-gem/artifacts/sh/fire-mod.sh", 0
    comp_path   db "fire-gem/artifacts/sh/fire-compile.sh", 0
    run_path    db "fire-gem/artifacts/sh/fire-run.sh", 0
    sh_bin      db "/bin/bash", 0

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
    js .exit            ; NACK: Directory missing
    mov r8, rax         ; Save Vault File Descriptor

.scan_loop:
    ; 2. READ DIRECTORY ENTRIES (rax=217)
    mov rax, 217        ; sys_getdents64
    mov rdi, r8
    mov rsi, dir_buf
    mov rdx, 4096
    syscall
    test rax, rax
    jle .close_exit     ; Pulse Finished

    ; --- TERMINAL PROTOCOL: SEQUENTIAL EXECUTION ---

    ; STEP A: FIRE-MOD (rax=57 fork)
    call fork_and_exec_worker, mod_path
    
    ; STEP B: FIRE-COMPILE (rax=57 fork)
    call fork_and_exec_worker, comp_path
    
    ; STEP C: FIRE-RUN (rax=57 fork)
    call fork_and_exec_worker, run_path

    jmp .scan_loop      ; RESUME TO NEXT CJS BLOCK

.close_exit:
    mov rax, 3          ; sys_close
    mov rdi, r8
    syscall

.exit:
    mov rax, 60         ; sys_exit
    xor rdi, rdi
    syscall

; --- HELPER: FORK -> EXEC -> WAIT ---
fork_and_exec_worker:
    pop r9              ; Return address
    pop rdi             ; Worker path argument
    
    mov rax, 57         ; sys_fork
    syscall
    test rax, rax
    jz .child_worker    ; Child logic
    
    ; PARENT: WAIT4 (rax=61)
    mov [child_pid], rax
    mov rax, 61
    mov rdi, [child_pid]
    xor rsi, rsi        ; status = NULL
    xor rdx, rdx        ; options = 0
    xor r10, r10        ; rusage = NULL
    syscall             ; SLEEP UNTIL WORKER EXITS
    
    push r9             ; Restore return address
    ret

.child_worker:
    ; EXECVE: /bin/bash <worker_path>
    mov rax, 59         ; sys_execve
    mov rdi, sh_bin
    
    ; Build argv [bash, worker, NULL]
    push 0
    push rdi            ; worker path (from rdi)
    push sh_bin
    mov rsi, rsp
    xor rdx, rdx        ; envp = NULL
    syscall
    jmp .exit           ; Fail-safe
