; IDENTITY: VERSION 2.0 // COORDINATE_MATERIALIZER_V2 // HAHA!
section .data
    v2_dir      db "fire-gem/artifacts/json/cbord/reg/v2/", 0
    target_file db "fire-gem/artifacts/json/cbord/reg/v2/AVIS.avis", 0
    content     db "/* AVIS.FVS VERSION 2 - COORDINATE SYSTEM SEATED */", 10, 0
    content_len equ $ - content
    ack_msg     db "[ACK] GEM-0003: SEATING VERSION 2 VAULT...", 10
    ack_len     equ 43

section .text
    global _start
_start:
    ; mkdir -p v2
    mov rax, 83
    mov rdi, v2_dir
    mov rsi, 0755o
    syscall
    ; create AVIS.avis
    mov rax, 2
    mov rdi, target_file
    mov rsi, 65
    mov rdx, 0644o
    syscall
    mov r8, rax
    ; write & exit
    mov rax, 1
    mov rdi, r8
    mov rsi, content
    mov rdx, content_len
    syscall
    mov rax, 60
    xor rdi, rdi
    syscall

