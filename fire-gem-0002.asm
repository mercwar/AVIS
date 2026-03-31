; /*******************************************************************************
;  * TYPE: LAW | CLASS: INGESTOR | NAME: fire-gem-0003.asm
;  * IDENTITY: VERSION 1.0 // THE GAUNTLET // HAHA!
;  * ROLE: Force-Write Registry & Seal Namespace.
;  *******************************************************************************/

section .data
    target_dir  db "fire-gem/artifacts/json/cbord/reg/", 0
    payload_out db "fire-gem/artifacts/json/cbord/reg/AVIS_003.exe", 0
    
    ack_msg     db "[ACK] GEM-0003: INGESTION INITIALIZED...", 10
    ack_len     equ 41
    seal_msg    db "[ACK] GEM-0003: REGISTRY SEALED. DISPATCH COMPLETE.", 10
    seal_len    equ 51
    elf_magic   db 0x7f, 'E', 'L', 'F'

section .bss
    fd_out      resq 1

section .text
    global _start

_start:
    ; 1. SIGNAL START
    mov rax, 1
    mov rdi, 1
    mov rsi, ack_msg
    mov rdx, ack_len
    syscall

    ; 2. FORCE MATERIALIZE AVIS_003.exe
    mov rax, 2          ; sys_open
    mov rdi, payload_out
    mov rsi, 65         ; O_CREAT | O_WRONLY
    mov rdx, 0755o      ; Read/Write/Execute
    syscall
    test rax, rax
    js exit_error
    mov [fd_out], rax

    ; 3. DROP ELF HANDSHAKE
    mov rax, 1
    mov rdi, [fd_out]
    mov rsi, elf_magic
    mov rdx, 4
    syscall

    ; 4. CLOSE AND SEAL
    mov rax, 3
    mov rdi, [fd_out]
    syscall

    ; 5. SIGNAL SUCCESS
    mov rax, 1
    mov rdi, 1
    mov rsi, seal_msg
    mov rdx, seal_len
    syscall

    ; 6. TERMINATE (CLEAN EXIT)
    mov rax, 60
    xor rdi, rdi
    syscall

exit_error:
    mov rax, 60
    mov rdi, 1
    syscall
