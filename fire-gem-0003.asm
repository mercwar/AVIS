; /*******************************************************************************
;  * TYPE: LAW | CLASS: INGESTOR | NAME: fire-gem-0003.asm
;  * IDENTITY: VERSION 1.1 // COORDINATE_MATERIALIZER // HAHA!
;  * ROLE: Materialize AVIS.avis into the cbord/reg registry.
;  *******************************************************************************/

section .data
    target_file db "fire-gem/artifacts/json/cbord/reg/AVIS.avis", 0
    
    ; COORDINATE CONTENT BLOCK
    content     db "/* ", 10
                db "AVIS.FVS DO NOT REMOVE", 10
                db "AVIS.FVS FIRE BEGIN AVIS COORDINATE", 10
                db " * AVIS COORDINATE SYSTEM: https://mercwar.github.com/AVIS/AVIS.avis", 10
                db " * SOURCE_FILE_NAME: AVIS.avis", 10
                db " * SOURCE_FILE_PATH: fire-gem/artifacts/json/cbord/reg/", 10
                db "AVIS.FVS FIRE END", 10
                db "AVIS.FVS DO NOT REMOVE", 10
                db " */", 0
    content_len equ $ - content

    ack_msg     db "[ACK] GEM-0003: MATERIALIZING COORDINATE: AVIS.avis", 10
    ack_len     equ 53

section .bss
    fd_out      resq 1

section .text
    global _start

_start:
    ; 1. SIGNAL INGESTION START
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout
    mov rsi, ack_msg
    mov rdx, ack_len
    syscall

    ; 2. CREATE / OPEN AVIS.avis
    mov rax, 2          ; sys_open
    mov rdi, target_file
    mov rsi, 65         ; O_CREAT | O_WRONLY
    mov rdx, 0644o      ; Standard permissions
    syscall
    test rax, rax
    js exit_error
    mov [fd_out], rax

    ; 3. DROP COORDINATE DATA
    mov rax, 1          ; sys_write
    mov rdi, [fd_out]
    mov rsi, content
    mov rdx, content_len
    syscall

    ; 4. CLOSE AND SEAL
    mov rax, 3          ; sys_close
    mov rdi, [fd_out]
    syscall

    ; 5. TERMINATE (CLEAN EXIT)
    mov rax, 60         ; sys_exit
    xor rdi, rdi
    syscall

exit_error:
    mov rax, 60
    mov rdi, 1
    syscall
