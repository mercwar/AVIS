; AVIS-ARTIFACT
; FILE: AVIS/VERSION 2/fire-gem.asm
; PURPOSE: FIRE-GEM V2 FORGE CORE (self-contained, no .sh)
; AUTHOR: Demon

; TARGET: x86_64 Linux ELF
; BUILD:
;   nasm -f elf64 "AVIS/VERSION 2/fire-gem.asm" -o fire-gem.o
;   gcc fire-gem.o -o fire-gem
;
; RUN:
;   ./fire-gem
;
; EFFECT:
;   Scans:  AVIS/VERSION 2/FORGE/*.asm
;   For each:
;     - Assembles → OUT/<name>.o
;     - Links     → OUT/<name>.bin
;     - chmod +x  → OUT/<name>.bin
;     - Executes  → OUT/<name>.bin
;   All logic is inside this EXE via system().

        global  main
        extern  printf
        extern  system

section .data

msg_header: db "[AVIS_V2] FORGE: FIRE-GEM V2 CORE ONLINE", 10, 0

; We let /bin/sh handle all directory scanning and forging.
; This single command string is executed by system().
;
; NOTE: This is a single long shell one-liner:
;   - FORGE_DIR='AVIS/VERSION 2/FORGE'
;   - OUT_DIR='AVIS/VERSION 2/FORGE/OUT'
;   - for f in "$FORGE_DIR"/*.asm; do
;       [ -e "$f" ] || continue
;       base=$(basename "$f" .asm)
;       obj="$OUT_DIR/$base.o"
;       bin="$OUT_DIR/$base.bin"
;       echo "[AVIS_V2] STRIKE: $f -> $bin"
;       nasm -f elf64 "$f" -o "$obj"
;       ld "$obj" -o "$bin"
;       chmod +x "$bin"
;       echo "[AVIS_V2] EXEC: $bin"
;       "$bin"
;     done

cmd_str: db "FORGE_DIR='AVIS/VERSION 2/FORGE'; ", \
           "OUT_DIR='AVIS/VERSION 2/FORGE/OUT'; ", \
           "mkdir -p ""$OUT_DIR""; ", \
           "for f in ""$FORGE_DIR""/*.asm; do ", \
             "[ -e ""$f"" ] || continue; ", \
             "base=$(basename ""$f"" .asm); ", \
             "obj=""$OUT_DIR/$base.o""; ", \
             "bin=""$OUT_DIR/$base.bin""; ", \
             "echo ""[AVIS_V2] STRIKE: $f -> $bin""; ", \
             "nasm -f elf64 ""$f"" -o ""$obj""; ", \
             "ld ""$obj"" -o ""$bin""; ", \
             "chmod +x ""$bin""; ", \
             "echo ""[AVIS_V2] EXEC: $bin""; ", \
             """$bin""; ", \
           "done", 0

section .text

main:
        ; print header
        mov     rdi, msg_header
        xor     eax, eax
        call    printf

        ; execute forge command
        mov     rdi, cmd_str
        call    system

        xor     eax, eax
        ret

; ---------------------------------------------------------
; Helper strings
; ---------------------------------------------------------
section .data
nasm_cmd:   db "nasm -f elf64 'AVIS/VERSION 2/FORGE/",0
rest_cmd:   db "' -o 'AVIS/VERSION 2/FORGE/",0
