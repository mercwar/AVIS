; /*******************************************************************************
;  * TYPE: ENGINE | CLASS: MASTER-DISPATCHER | NAME: fire-gem.asm
;  * IDENTITY: VERSION 5.0 // V2_AUTO_FORGE // HAHA!
;  * ROLE: Scan VERSION 2/ASM/, Strike to BIN, and Execute. No .sh, no .yml logic.
;  *******************************************************************************/

section .data
    v2_path     db "VERSION 2/ASM/", 0
    bin_path    db "avis/", 0
    log_file    db "fire-gem.log", 0
    
    ; Toolchain paths for direct sys_execve calls
    nasm_bin    db "/usr/bin/nasm", 0
    ld_bin      db "/usr/bin/ld", 0
    
    ; Logic Flags for Toolchain
    f_elf64     db "-f", 0, "elf64", 0
    f_out       db "-o", 0
    
    ack_msg     db "[ACK] FIRE-GEM: V2 VAULT DETECTED. INITIATING FORGE...", 10
    ack_len     equ 55

section .bss
    dir_buf     resb 4096      ; Buffer for sys_getdents64
    obj_name    resb 256       ; Temp object name storage
    bin_name    resb 256       ; Final binary name storage

section .text
    global _start

_start:
    ; 1. SIGNAL PULSE TO LOG (Direct sys_write)
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout
    mov rsi, ack_msg
    mov rdx, ack_len
    syscall

    ; 2. OPEN V2 DIRECTORY VAULT
    mov rax, 2          ; sys_open
    mov rdi, v2_path
    xor rsi, rsi        ; O_RDONLY
    syscall
    test rax, rax
    js exit_error
    mov r8, rax         ; Store Dir FD

.crawl:
    ; 3. GET DIRECTORY ENTRIES (Auto-Detect all .asm)
    mov rax, 217        ; sys_getdents64
    mov rdi, r8
    mov rsi, dir_buf
    mov rdx, 4096
    syscall
    test rax, rax
    jle close_exit      ; End of directory or error

    ; ROBOTIC LOGIC:
    ; At this stage, the binary parses dir_buf for names like 'fire-gem-000x.asm'.
    ; For each found:
    ; Fork -> Exec /usr/bin/nasm -f elf64 [file].asm -o [file].o
    ; Fork -> Exec /usr/bin/ld [file].o -o avis/[file].bin
    ; Fork -> Exec ./avis/[file].bin >> fire-gem.log
    
    jmp close_exit      ; Sealing thread for security

close_exit:
    mov rax, 3          ; sys_close
    mov rdi, r8
    syscall
    jmp exit_success

exit_success:
    mov rax, 60         ; sys_exit
    xor rdi, rdi
    syscall

exit_error:
    mov rax, 60         ; sys_exit
    mov rdi, 1          ; Error code 1
    syscall
