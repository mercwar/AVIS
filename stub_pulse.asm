; FILE: stub_pulse.asm
; IDENTITY: VERSION 2 // STUB TEST
section .data
    msg db "AVIS_STUB: CVBGOD, I HAVE CONTACTED MYSELF. [wm_macro_ack]", 10
    len equ $ - msg

section .text
    global _start

_start:
    ; Write to stdout (which fire-run.sh redirects to the log)
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout
    mov rsi, msg
    mov rdx, len
    syscall

    ; Exit
    mov rax, 60         ; sys_exit
    xor rdi, rdi
    syscall
