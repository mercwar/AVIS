; FILE: fire-gem.asm
; IDENTITY: VERSION 3 // MASTER DISPATCHER // HAHA!
; ROLE: Terminal Protocol - Sequential JSON-to-Shell Pipeline.

section .data
    vault_path  db "fire-gem/artifacts/json/asm/", 0
    sh_path     db "/bin/bash", 0
    arg_sh      db "./fire-start.sh", 0

section .bss
    dir_buf     resb 4096
    pid         resq 1

section .text
    global _start

_start:
    ; 1. OPEN VAULT (rax=2)
    mov rax, 2
    mov rdi, vault_path
    xor rsi, rsi
    syscall
    mov r8, rax         ; Save Directory FD

.scan_loop:
    ; 2. GETDENTS (rax=217)
    mov rax, 217
    mov rdi, r8
    mov rsi, dir_buf
    mov rdx, 4096
    syscall
    test rax, rax
    jle .close_exit     ; End of Vault

    ; 3. FORK (rax=57) - Creating the Terminal Process
    mov rax, 57
    syscall
    test rax, rax
    jz .child_exec      ; Child handles the fire-start.sh call

    ; 4. PARENT: WAIT (rax=61) - Terminal Protocol Wait-State
    mov [pid], rax
    mov rax, 61         ; sys_wait4
    mov rdi, [pid]
    xor rsi, rsi
    xor rdx, rdx
    xor r10, r10
    syscall             ; PAUSE UNTIL fire-start EXITS
    
    jmp .scan_loop      ; RESUME TO NEXT JSON

.child_exec:
    ; 5. EXECVE (rax=59) - Passing JSON to the Interpreter
    ; This runs: ./fire-start.sh [current_json_from_dir_buf]
    mov rax, 59
    mov rdi, sh_path
    ; [Stack Frame for argv: bash, fire-start.sh, JSON_NAME, NULL]
    xor rsi, rsi
    push rsi            ; NULL
    ; (Simplified: In practice, extract filename from dir_buf here)
    lea rbx, [arg_sh]
    push rbx
    mov rsi, rsp        ; argv
    xor rdx, rdx        ; envp
    syscall

.close_exit:
    mov rax, 3
    mov rdi, r8
    syscall

.exit:
    mov rax, 60
    xor rdi, rdi
    syscall
