; /*******************************************************************************
;  * TYPE: LAW | CLASS: MIRROR-INGESTOR | NAME: fire-gem-0001.asm
;  * IDENTITY: VERSION 4.71 // FIXED SCOPE // HAHA!
;  * ROLE: Materialize JSON Namespace into CBORD Vault with Name Parity.
;  *******************************************************************************/

section .data
    in_dir      db "fire-gem/artifacts/json/reg/", 0
    out_prefix  db "fire-gem/artifacts/cbord/reg/", 0
    elf_magic   db 0x7f, 'E', 'L', 'F'

section .bss
    dir_buf     resb 4096
    name_buf    resb 256    
    out_path    resb 512    
    fd_in       resq 1
    fd_out      resq 1

section .text
    global _start

_start:
    ; 1. OPEN INPUT VAULT
    mov rax, 2
    mov rdi, in_dir
    xor rsi, rsi
    syscall
    mov r8, rax         ; Input Dir FD

.dir_loop:
    ; 2. CRAWL NAMESPACE (getdents64)
    mov rax, 217
    mov rdi, r8
    mov rsi, dir_buf
    mov rdx, 4096
    syscall
    
    test rax, rax
    jle .exit_pulse     ; Jumps to the local label below

    call materialize_mirror
    jmp .dir_loop

.exit_pulse:            ; Correctly scoped under _start
    mov rax, 60
    xor rdi, rdi
    syscall

materialize_mirror:
    ; ATOMIC DROP
    mov rax, 2          
    mov rdi, out_path   
    mov rsi, 65         ; O_CREAT | O_WRONLY
    mov rdx, 0644o
    syscall
    mov [fd_out], rax

    ; 3. SEAT ELF HANDSHAKE
    mov rax, 1          
    mov rdi, [fd_out]
    mov rsi, elf_magic
    mov rdx, 4
    syscall

    ; 4. CLOSE DROP
    mov rax, 3
    mov rdi, [fd_out]
    syscall
    ret
