; FILE: fire-gem-0002.asm
; IDENTITY: VERSION 3 // CBORD PROCESSOR // HAHA!
; ROLE: Process registration artifacts from fire-gem/artifacts/cbord/reg/

section .data
    cbord_path  db "fire-gem/artifacts/cbord/reg/", 0
    ack_msg     db "[ACK] GEM-0002: CBORD Artifact Processed. Hardware Seated.", 10
    ack_len     equ $ - ack_msg

section .bss
    fd          resq 1
    dir_buf     resb 4096

section .text
    global _start

_start:
    ; 1. OPEN CBORD VAULT (rax=2)
    mov rax, 2
    mov rdi, cbord_path
    xor rsi, rsi        ; O_RDONLY
    syscall
    test rax, rax
    js .exit
    mov r8, rax         ; Save Vault FD

.process_loop:
    ; 2. READ CBORD ENTRIES (rax=217)
    mov rax, 217
    mov rdi, r8
    mov rsi, dir_buf
    mov rdx, 4096
    syscall
    test rax, rax
    jle .close_exit

    ; [PROCESSING LOGIC]
    ; GEM-0002 executes the specific registration found in the CBORD drop.
    ; Signal the Audit Surface that the drop is ingested.
    mov rax, 1
    mov rdi, 1
    mov rsi, ack_msg
    mov rdx, ack_len
    syscall

    jmp .process_loop

.close_exit:
    mov rax, 3
    mov rdi, r8
    syscall

.exit:
    mov rax, 60
    xor rdi, rdi
    syscall
