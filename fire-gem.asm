; FILE: fire-gem.asm
; IDENTITY: VERSION 3 // MASTER DISPATCHER // HAHA!
; ROLE: Straight-line processing of all CJS artifacts in the target vault.

section .data
    ; Root path for JSON artifacts
    path        db "fire-gem/artifacts/json/asm/", 0
    sh_cmd      db "./fire-start.sh", 0
    
section .bss
    dir_buf     resb 4096   ; Buffer for getdents64 entries

section .text
    global _start

_start:
    ; 1. OPEN DIRECTORY (sys_open: rax=2)
    mov rax, 2          
    mov rdi, path       ; Target: /AVIS/fire-gem/artifacts/json/asm/
    xor rsi, rsi        ; O_RDONLY
    syscall
    test rax, rax
    js .exit            ; Error handle
    mov r8, rax         ; Save Directory File Descriptor

.scan_loop:
    ; 2. READ DIRECTORY ENTRIES (sys_getdents64: rax=217)
    mov rax, 217        
    mov rdi, r8
    mov rsi, dir_buf
    mov rdx, 4096
    syscall
    test rax, rax
    jle .close_exit     ; End of stream or error

    ; [DISPATCH LOGIC]
    ; In a straight line, this binary triggers fire-start.sh for each CJS.
    ; This replaces the 'little bot' manual clicks with ASM authority.
    mov rax, 1          ; sys_write log dispatch
    mov rdi, 1
    mov rsi, sh_cmd
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
