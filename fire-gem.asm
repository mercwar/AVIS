; AVIS-ARTIFACT
; FILE: fire-gem.asm
; PURPOSE: JOE TRON FORGE — FIRE-GEM V2 SELF-CONTAINED FORGE ENGINE
; AUTHOR: Demon

        global  main
        extern  printf
        extern  system

section .data

msg_header: db "[AVIS_V2] JOE TRON FORGE ONLINE",10,0

; --------------------------------------------------------------------
; This command does EVERYTHING:
;
; 1. FORGE_OUT='AVIS/VERSION 2/ASM/FORGE/OUT'
; 2. GEM_OUT='AVIS/VERSION 2/ASM/FIRE-GEM/OUT'
; 3. LOG='AVIS/VERSION 2/ASM/fire-gem.log'
; 4. mkdir -p GEM_OUT
; 5. echo header > LOG
; 6. For each .bin in FORGE_OUT:
;       - Copy to GEM_OUT
;       - Execute it
;       - Append output to LOG
; --------------------------------------------------------------------

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
        ; Print forge header
        mov     rdi, msg_header
        xor     eax, eax
        call    printf

        ; Execute the full forge pipeline
        mov     rdi, cmd_str
        call    system

        xor     eax, eax
        ret
