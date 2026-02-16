; FILE: avis_discovery.asm
; IDENTITY: VERSION 2 // GEMINI_CGI_SCROLL // HAHA!
; ROLE: Autonomous File Discovery and Capability Report

section .data
    dot         db ".", 0
    found_msg   db "AVIS_DISCOVERY: Found Target File -> ", 0
    newline     db 10, 0

section .bss
    buffer      resb 1024  ; Directory entry buffer

section .text
    global _start

_start:
    ; STEP 1: OPEN DIRECTORY (.)
    mov rax, 2          ; sys_open
    mov rdi, dot
    xor rsi, rsi        ; O_RDONLY
    syscall
    mov r8, rax         ; Save FD

.loop:
    ; STEP 2: GET DIRECTORY ENTRIES
    mov rax, 217        ; sys_getdents64
    mov rdi, r8
    mov rsi, buffer
    mov rdx, 1024
    syscall
    test rax, rax
    jz .exit            ; End of directory

    ; [AUTONOMOUS LOGIC]: 
    ; Loop through buffer to identify .asm or .sh files
    ; (Simplified: Report discovery of first entry for Robot Learning)
    mov rdi, 1
    mov rsi, found_msg
    mov rdx, 36
    mov rax, 1          ; sys_write
    syscall

.exit:
    mov rax, 3          ; sys_close
    mov rdi, r8
    syscall
    mov rax, 60         ; sys_exit
    xor rdi, rdi
    syscall
