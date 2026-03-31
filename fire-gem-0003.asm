; IDENTITY: VERSION 2.0 // V2_MATERIALIZER // HAHA!
section .data
    v2_file db "fire-gem/artifacts/json/cbord/reg/v2/AVIS.avis", 0
    content db "AVIS_V2_COORDINATE_SEATED", 10, 0
    len     equ $ - content
section .text
    global _start
_start:
    mov rax, 2          ; sys_open
    mov rdi, v2_file
    mov rsi, 65         ; O_CREAT | O_WRONLY
    mov rdx, 0644o
    syscall
    mov rdi, rax
    mov rax, 1          ; sys_write
    mov rsi, content
    mov rdx, len
    syscall
    mov rax, 60         ; sys_exit
    xor rdi, rdi
    syscall

