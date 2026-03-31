; IDENTITY: VERSION 1 // ROBOTIC LEARNING // HAHA!
section .data
    msg db "<div class='avis-alert'>HARDWARE SEATED: ROBOT_LEARN_01 ONLINE</div>", 10
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
