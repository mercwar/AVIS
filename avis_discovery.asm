; IDENTITY: VERSION 2 // DISCOVERY ANCHOR // HAHA!
section .data
    msg db "AVIS_DISCOVERY: Identity VERSION 2 Engaged", 10
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
