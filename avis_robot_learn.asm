; IDENTITY: VERSION 1 // ROBOT_LEARN // HAHA!
section .data
    msg db "AVIS_V2: ROBOT_LEARN_01 ONLINE [vbgod_dispatch]", 10
    len equ $ - msg
section .text
    global _start
_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, len
    syscall
    mov rax, 60
    xor rdi, rdi
    syscall
