; AVIS-ARTIFACT
; FILE: AVIS/VERSION 2/fire-gem.asm
; PURPOSE: FIRE-GEM V2 FORGE CORE (self-contained)
; AUTHOR: Demon

        global  main
        extern  printf
        extern  system
        extern  opendir
        extern  readdir
        extern  closedir

        section .data
forge_dir:      db "AVIS/VERSION 2/FORGE",0
fmt_str:        db "[AVIS_V2] FORGE: %s",10,0
cmd_buf:        times 512 db 0

asm_ext:        db ".asm",0
o_ext:          db ".o",0
bin_ext:        db ".bin",0

        section .text

main:
        ; print header
        mov     rdi, fmt_str
        mov     rsi, forge_dir
        xor     rax, rax
        call    printf

        ; open directory
        mov     rdi, forge_dir
        call    opendir
        test    rax, rax
        jz      done
        mov     rbx, rax            ; DIR*

read_loop:
        mov     rdi, rbx
        call    readdir
        test    rax, rax
        jz      close_dir

        ; struct dirent* in rax
        ; filename at rax+19 on Linux/glibc
        mov     rsi, [rax+19]

        ; check extension ".asm"
        mov     rdi, asm_ext
        call    ends_with
        cmp     rax, 1
        jne     read_loop

        ; build command:
        ; nasm -f elf64 <file> -o <file.o> && ld <file.o> -o <file.bin> && ./<file.bin>

        ; cmd_buf = "nasm -f elf64 AVIS/VERSION 2/FORGE/<file> -o AVIS/VERSION 2/FORGE/<file>.o && ld ..."
        mov     rdi, cmd_buf
        mov     rsi, rsi            ; filename
        call    build_command

        ; print command
        mov     rdi, fmt_str
        mov     rsi, cmd_buf
        xor     rax, rax
        call    printf

        ; execute command
        mov     rdi, cmd_buf
        call    system

        jmp     read_loop

close_dir:
        mov     rdi, rbx
        call    closedir

done:
        xor     rax, rax
        ret


; ---------------------------------------------------------
; int ends_with(char* filename, char* ext)
; returns 1 if filename ends with ext
; ---------------------------------------------------------
ends_with:
        push    rdi
        push    rsi

        ; find lengths
        mov     rdi, rdi
        call    strlen
        mov     rcx, rax            ; len(filename)

        mov     rdi, rsi
        call    strlen
        mov     rdx, rax            ; len(ext)

        ; if ext longer → fail
        cmp     rcx, rdx
        jl      ew_fail

        ; compare tail
        mov     rdi, [rsp+16]       ; filename
        add     rdi, rcx
        sub     rdi, rdx

        mov     rsi, [rsp+8]        ; ext
        mov     rcx, rdx
        repe cmpsb
        jne     ew_fail

        mov     rax, 1
        jmp     ew_done

ew_fail:
        xor     rax, rax

ew_done:
        pop     rsi
        pop     rdi
        ret


; ---------------------------------------------------------
; build_command(cmd_buf, filename)
; ---------------------------------------------------------
build_command:
        ; rdi = cmd_buf
        ; rsi = filename

        ; Format:
        ; nasm -f elf64 AVIS/VERSION 2/FORGE/<file> -o AVIS/VERSION 2/FORGE/<file>.o && ld <file>.o -o <file>.bin && ./<file>.bin

        mov     rdx, rsi

        ; write command
        mov     rax, 0
        mov     rcx, 0

        ; nasm
        mov     rdi, cmd_buf
        mov     rsi, nasm_cmd
        call    strcpy

        ; append filename
        mov     rdi, cmd_buf
        call    strcat_filename

        ; append rest
        mov     rdi, cmd_buf
        mov     rsi, rest_cmd
        call    strcat

        ret


; ---------------------------------------------------------
; Helper strings
; ---------------------------------------------------------
section .data
nasm_cmd:   db "nasm -f elf64 'AVIS/VERSION 2/FORGE/",0
rest_cmd:   db "' -o 'AVIS/VERSION 2/FORGE/",0
