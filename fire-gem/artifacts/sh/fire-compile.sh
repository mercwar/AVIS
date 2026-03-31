#!/bin/bash
# /*******************************************************************************
#  * TYPE: ENGINE | CLASS: FORGE-ENGINE | NAME: fire-compile.sh
#  * IDENTITY: VERSION 4.1 // FORGE_SMITHY // HAHA!
#  *******************************************************************************/
mkdir -p ./avis/
echo "FIRE_COMPILE: Initializing Forge for ASM Targets..."
find . -maxdepth 1 -name "*.asm" | while read -r f; do
    BASE=$(basename "${f%.asm}")
    OUT="./avis/${BASE}.exe"
    echo "FORGE: [STRIKE] Compiling $f -> $OUT"
    nasm -f elf64 "$f" -o "${BASE}.o" && ld "${BASE}.o" -o "$OUT"
    if [ $? -eq 0 ]; then
        chmod +x "$OUT"
        rm -f "${BASE}.o"
        echo "BASH: [ACK] FORGED: $OUT"
    else
        echo "BASH: [NACK] COMPILE_ERROR: $f"
        rm -f "${BASE}.o"
    fi
done
