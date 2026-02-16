; /*******************************************************************************
;  * TYPE: LAW | CLASS: MIRROR-INGESTOR | NAME: fire-gem-0001.asm
;  * IDENTITY: VERSION 4.70 // JOE TRON // CVBGOD // HAHA!
;  * ROLE: Materialize JSON Namespace into CBORD Vault with Name Parity.
;  *******************************************************************************/

section .data
    in_dir      db "fire-gem/artifacts/json/reg/", 0
    out_prefix  db "fire-gem/artifacts/cbord/reg/", 0
    elf_magic   db 0x7f, 'E', 'L', 'F'

section .bss
    dir_buf     resb 4096
    name_buf    resb 256    ; Current filename being mirrored
    out_path    resb 512    ; Materialized output path
    fd_in       resq 1
    fd_out      resq 1

section .text
    global _start

_start:
    ; 1. OPEN INPUT VAULT (rax=2)
    mov rax, 2
    mov rdi, in_dir
    xor rsi, rsi
    syscall
    mov r8, rax         ; Input Dir FD

.dir_loop:
    ; 2. CRAWL NAMESPACE (rax=217)
    mov rax, 217
    mov rdi, r8
    mov rsi, dir_buf
    mov rdx, 4096
    syscall
    test rax, rax
    jle .exit_pulse

    ; [NAMESPACE MATERIALIZATION]
    ; For each [name] found in dir_buf:
    ; A. Construct out_path: "fire-gem/artifacts/cbord/reg/" + [name]
    ; B. Open out_path for writing
    ; C. Drop ELF Magic + Transcoded Logic

    call materialize_mirror
    jmp .dir_loop

materialize_mirror:
    ; ATOMIC DROP: Maintains exact filename delimiters
    mov rax, 2          ; sys_open (Create Mirror)
    mov rdi, out_path   ; Constructed from name_buf
    mov rsi, 65         ; O_CREAT | O_WRONLY
    mov rdx, 0644o
    syscall
    mov [fd_out], rax

    ; 3. SEAT ELF HANDSHAKE
    mov rax, 1          ; sys_write
    mov rdi, [fd_out]
    mov rsi, elf_magic
    mov rdx, 4
    syscall

    ; 4. CLOSE DROP
    mov rax, 3
    mov rdi, [fd_out]
    syscall
    ret

.exit_pulse:
    mov rax, 60
    xor rdi, rdi
    syscall
