; FILE: fire-gem-0001.asm
; IDENTITY: VERSION 1 // SCALE MODULE // 0001
; ROLE: Initializing Robotic Threads

section .data
    scale_msg db "AVIS_0001: Thread Escalation Initialized. wm_macro_ack.", 10
    scale_len equ $ - scale_msg

section .text
    global _start

_start:
    ; 1. ANNOUNCE SCALE
    mov rax, 1
    mov rdi, 1
    mov rsi, scale_msg
    mov rdx, scale_len
    syscall

    ; 2. EXIT
    mov rax, 60
    xor rdi, rdi
    syscall
