; FILE: fire-gem.asm
; IDENTITY: VERSION 3.3 // MEMORY-MAPPED DISPATCHER // HAHA!
; ROLE: Load JSON instructions into RAM for high-speed Linux Installation.

section .data
    vault_path  db "fire-gem/artifacts/json/asm/", 0
    mod_path    db "fire-gem/artifacts/sh/fire-mod.sh", 0
    comp_path   db "fire-gem/artifacts/sh/fire-compile.sh", 0
    run_path    db "fire-gem/artifacts/sh/fire-run.sh", 0
    sh_bin      db "/bin/bash", 0

section .bss
    dir_buf     resb 4096
    child_pid   resq 1
    mem_addr    resq 1      ; Address of the JSON in RAM

section .text
    global _start
    global FIRE_GEM_LOAD_MEM ; EXPORTED FOR 0001

_start:
    ; 1. OPEN VAULT DIRECTORY
    mov rax, 2          
    mov rdi, vault_path
    xor rsi, rsi
    syscall
    test rax, rax
    js .exit
    mov r8, rax         ; Save Vault FD

.scan_loop:
    mov rax, 217        ; sys_getdents64
    mov rdi, r8
    mov rsi, dir_buf
    mov rdx, 4096
    syscall
    test rax, rax
    jle .close_exit

    ; --- MEMORY MAPPING PHASE ---
    ; Here we would parse the filename and call LOAD_MEM
    ; call FIRE_GEM_LOAD_MEM, <filename>

    ; --- TERMINAL PROTOCOL: SEQUENTIAL EXECUTION ---
    push mod_path
    call fork_and_exec_worker
    
    push comp_path
    call fork_and_exec_worker
    
    push run_path
    call fork_and_exec_worker

    jmp .scan_loop

FIRE_GEM_LOAD_MEM:
    ; 2. MAP JSON TO MEMORY (rax=9: sys_mmap)
    ; This puts the JSON instructions in the heap for the ASM to devour
    mov rax, 9          ; sys_mmap
    xor rdi, rdi        ; addr = NULL
    mov rsi, 8192       ; len = 8KB
    mov rdx, 3          ; prot = PROT_READ | PROT_WRITE
    mov r10, 34         ; flags = MAP_PRIVATE | MAP_ANONYMOUS
    mov r8, -1          ; fd = -1
    xor r9, r9          ; offset = 0
    syscall
    mov [mem_addr], rax ; Seated in RAM
    ret

.close_exit:
    mov rax, 3
    mov rdi, r8
    syscall

.exit:
    mov rax, 60
    xor rdi, rdi
    syscall

fork_and_exec_worker:
    pop r9
    pop rdi             
    mov rax, 57         ; sys_fork
    syscall
    test rax, rax
    jz .child_worker
    mov [child_pid], rax
    mov rax, 61         ; sys_wait4
    mov rdi, [child_pid]
    xor rsi, rsi
    xor rdx, rdx
    xor r10, r10
    syscall
    push r9
    ret

.child_worker:
    mov rax, 59
    mov rdi, sh_bin
    push 0
    push rdi
    push sh_bin
    mov rsi, rsp
    xor rdx, rdx
    syscall
