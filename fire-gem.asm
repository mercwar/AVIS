; AVIS-ARTIFACT
; FILE: AVIS/VERSION 2/fire-gem.asm
; PURPOSE: FIRE-GEM V2 FORGE CORE (self-contained)
; AUTHOR: Demon

; BUILD:
;   nasm -f elf64 "AVIS/VERSION 2/fire-gem.asm" -o fire-gem.o
;   gcc fire-gem.o -o fire-gem
;
; RUN:
;   ./fire-gem
;
; EFFECT:
;   Reads:  AVIS/VERSION 2/ASM/FORGE/OUT/*.bin
;   Copies: → AVIS/VERSION 2/ASM/FIRE-GEM/OUT/
;   Executes each .bin
;   Logs output to: AVIS/VERSION 2/ASM/fire-gem.log

        global  main
        extern  printf
        extern  system

section .data

msg_header: db "[AVIS_V2] FIRE-GEM FORGE CORE ONLINE",10,0

; This shell command does:
; 1. FORGE_OUT='AVIS/VERSION 2/ASM/FORGE/OUT'
; 2. GEM_OUT='AVIS/VERSION 2/ASM/FIRE-GEM/OUT'
; 3. LOG='AVIS/VERSION 2/ASM/fire-gem.log'
; 4. For each .bin in FORGE_OUT:
;       - Copy to GEM_OUT
;       - Run it
;       - Append output to fire-gem.log

cmd_str: db \
"FORGE_OUT='AVIS/VERSION 2/ASM/FORGE/OUT'; ", \
"GEM_OUT='AVIS/VERSION 2/ASM/FIRE-GEM/OUT'; ", \
"LOG='AVIS/VERSION 2/ASM/fire-gem.log'; ", \
"mkdir -p \"$GEM_OUT\"; ", \
"echo '[AVIS_V2] LOG START' > \"$LOG\"; ", \
"for f in \"$FORGE_OUT\"/*.bin; do ", \
"  [ -e \"$f\" ] || continue; ", \
"  base=$(basename \"$f\"); ", \
"  cp \"$f\" \"$GEM_OUT/$base\"; ", \
"  echo \"[AVIS_V2] EXEC: $base\" >> \"$LOG\"; ", \
"  \"$GEM_OUT/$base\" >> \"$LOG\" 2>&1; ", \
"done",0

section .text

main:
        ; print header
        mov     rdi, msg_header
        xor     eax, eax
        call    printf

        ; execute forge logic
        mov     rdi, cmd_str
        call    system

        xor     eax, eax
        ret
