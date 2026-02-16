; FILE: fire-gem.asm
; IDENTITY: VERSION 3 // MASTER DISPATCHER // HAHA!
; ROLE: Scan /AVIS/fire-gem/artifacts/json/asm/ and process CJS in a straight line.

section .data
    path        db "/home/runner/work/AVIS/AVIS/fire-gem/artifacts/json/asm/", 0
    sh_cmd      db "./fire-start.sh", 0
    space       db " ", 0

section .bss
    dir_buf     resb 4096
    cmd_buf     resb 1024

section .text
    global _start

_start:
    ; 1. OPEN DIRECTORY
    mov rax, 2          ; sys_open
    mov rdi, path
    xor rsi, rsi        ; O_RDONLY
    syscall
    mov r8, rax         ; Save FD

.scan_loop:
    ; 2. GETDENTS (Scan for .json)
    mov rax, 217        ; sys_getdents64
    mov rdi, r8
    mov rsi, dir_buf
    mov rdx, 4096
    syscall
    test rax, rax
    jz .exit            ; End of dir

    ; 3. [SIMULATED DISPATCH]
    ; For each file found, we execute: ./fire-start.sh <json_path>
    ; In a straight line (No threads)
    mov rax, 1          ; sys_write (Log dispatch to Audit Surface)
    mov rdi, 1
    mov rsi, sh_cmd
    mov rdx, 15
    syscall

.exit:
    mov rax, 60         ; sys_exit
    xor rdi, rdi
    syscall
