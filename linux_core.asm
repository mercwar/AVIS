; FILE: linux_core.asm
; IDENTITY: VERSION 1 // LINUX CORE // HAHA!
; ROLE: Established System Handshake

section .data
    core_msg db "AVIS_CORE: Linux Environment Seated. Identity: VERSION 1", 10
    core_len equ $ - core_msg

section .text
    global _start

_start:
    ; 1. ANNOUNCE SEATING
    mov rax, 1
    mov rdi, 1
    mov rsi, core_msg
    mov rdx, core_len
    syscall

    ; 2. YIELD TO DISPATCHER (Exit to return control to fire-gem_bin)
    mov rax, 60
    xor rdi, rdi
    syscall
