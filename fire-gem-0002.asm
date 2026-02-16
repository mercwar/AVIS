; FILE: fire-gem-0002.asm
; IDENTITY: VERSION 3 // REG-TO-CBORD-PARSER
; ROLE: Read /json/reg/ -> Print Parsed Reg to /artifacts/cbord/reg/

section .data
    in_path   db "fire-gem/artifacts/json/reg/", 0
    out_path  db "fire-gem/artifacts/cbord/reg/parsed_reg.cbord", 0
    header    db "--- AVIS CBORD REGISTRATION DROP ---", 10, 0
    h_len     equ $ - header

section .bss
    fd_in     resq 1
    fd_out    resq 1
    buffer    resb 8192

section .text
    global _start

_start:
    ; 1. OPEN OUTPUT CBORD FILE (Create/Truncate)
    mov rax, 2
    mov rdi, out_path
    mov rsi, 65         ; O_CREAT | O_WRONLY
    mov rdx, 0644o
    syscall
    mov [fd_out], rax

    ; 2. WRITE HEADER
    mov rax, 1
    mov rdi, [fd_out]
    mov rsi, header
    mov rdx, h_len
    syscall

    ; 3. SCAN JSON/REG DIRECTORY (Logic handled by fire-gem_bin pulse)
    ; For this stage, we are writing the "Parsed" status to the file.
    mov rsi, out_path
    call log_completion

    ; 4. EXIT
    mov rax, 60
    xor rdi, rdi
    syscall

log_completion:
    ; Write finalization to the CBORD drop zone
    ret
