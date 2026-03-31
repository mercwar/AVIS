; IDENTITY: VERSION 2.0 // COORDINATE_MATERIALIZER_V2 // HAHA!
; ROLE: Create V2 Vault and seat AVIS.avis coordinate.
section .data
    v2_dir      db "fire-gem/artifacts/json/cbord/reg/v2/", 0
    target_file db "fire-gem/artifacts/json/cbord/reg/v2/AVIS.avis", 0
    content     db "/* AVIS.FVS VERSION 2 - COORDINATE SYSTEM SEATED */", 10, 0
    content_len equ $ - content
    ack_msg     db "[ACK] GEM-0003: SEATING VERSION 2 VAULT...", 10
    ack_len     equ 43
section .bss
    fd_out      resq 1
section .text
    global _start
_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, ack_msg
    mov rdx, ack_len
    syscall
    ; MKDIR V2
    mov rax, 83
    mov rdi, v2_dir
    mov rsi, 0755o
    syscall
    ; CREATE AVIS.avis
    mov rax, 2
    mov rdi, target_file
    mov rsi, 65
    mov rdx, 0644o
    syscall
    mov [fd_out], rax
    ; WRITE CONTENT
    mov rax, 1
    mov rdi, [fd_out]
    mov rsi, content
    mov rdx, content_len
    syscall
    ; CLOSE & EXIT
    mov rax, 3
    mov rdi, [fd_out]
    syscall
    mov rax, 60
    xor rdi, rdi
    syscall
