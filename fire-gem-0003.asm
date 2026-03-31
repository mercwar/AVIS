; /*******************************************************************************
;  * TYPE: LAW | CLASS: INGESTOR | NAME: fire-gem-0003.asm
;  * IDENTITY: VERSION 2.0 // COORDINATE_MATERIALIZER_V2 // HAHA!
;  * ROLE: Create Version 2 Vault and Materialize AVIS.avis.
;  *******************************************************************************/

section .data
    ; DIRECTORY PATHS
    v2_dir      db "fire-gem/artifacts/json/cbord/reg/v2/", 0
    target_file db "fire-gem/artifacts/json/cbord/reg/v2/AVIS.avis", 0
    
    ; COORDINATE CONTENT BLOCK
    content     db "/* ", 10
                db "AVIS.FVS VERSION 2 - DO NOT REMOVE", 10
                db "AVIS.FVS FIRE BEGIN AVIS COORDINATE", 10
                db " * AVIS COORDINATE SYSTEM: https://github.io", 10
                db " * SOURCE_FILE_NAME: AVIS.avis", 10
                db " * VAULT_PATH: fire-gem/artifacts/json/cbord/reg/v2/", 10
                db "AVIS.FVS FIRE END", 10
                db " */", 0
    content_len equ $ - content

    ack_msg     db "[ACK] GEM-0003: SEATING VERSION 2 VAULT...", 10
    ack_len     equ 43

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

    ; 2. CREATE VERSION 2 DIRECTORY (sys_mkdir)
    mov rax, 83         ; sys_mkdir
    mov rdi, v2_dir
    mov rsi, 0755o      ; rwxr-xr-x permissions
    syscall
    ; We ignore error if directory already exists (EEXIST)

    ; 3. CREATE / OPEN AVIS.avis IN V2 VAULT
    mov rax, 2          ; sys_open
    mov rdi, target_file
    mov rsi, 65         ; O_CREAT | O_WRONLY
    mov rdx, 0644o      ; rw-r--r-- permissions
    syscall
    test rax, rax
    js exit_error
    mov [fd_out], rax

    ; 4. DROP COORDINATE DATA
    mov rax, 1          ; sys_write
    mov rdi, [fd_out]
    mov rsi, content
    mov rdx, content_len
    syscall

    ; 5. CLOSE AND SEAL
    mov rax, 3          ; sys_close
    mov rdi, [fd_out]
    syscall

    ; 6. TERMINATE (CLEAN EXIT)
    mov rax, 60         ; sys_exit
    xor rdi, rdi
    syscall

exit_error:
    mov rax, 60
    mov rdi, 1
    syscall
