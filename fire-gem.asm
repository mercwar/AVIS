; FILE: fire-gem.asm
; IDENTITY: VERSION 3 // MASTER DISPATCHER // HAHA!
; TARGET: x86_64 Linux

section .data
    path    db "fire-gem/artifacts/json/asm/", 0
    sh_path db "/bin/bash", 0
    sh_arg  db "./fire-start.sh", 0
    
section .bss
    dir_buf resb 4096

section .text
    global _start

_start:
    ; 1. OPEN DIRECTORY (rax=2)
    mov rax, 2
    mov rdi, path
    xor rsi, rsi
    syscall
    test rax, rax
    js .exit
    mov r8, rax         ; Save FD

.scan_loop:
    ; 2. READ ENTRIES (rax=217)
    mov rax, 217
    mov rdi, r8
    mov rsi, dir_buf
    mov rdx, 4096
    syscall
    test rax, rax
    jle .close_exit

    ; [STRAIGHT-LINE EXECUTION]
    ; For every file in the vault, we pulse fire-start.sh
    ; Note: Full implementation would parse filename here
    mov rax, 1          ; sys_write log pulse
    mov rdi, 1
    mov rsi, sh_arg
    mov rdx, 15
    syscall

.close_exit:
    mov rax, 3          ; sys_close
    mov rdi, r8
    syscall

.exit:
    mov rax, 60         ; sys_exit
    xor rdi, rdi
    syscall
