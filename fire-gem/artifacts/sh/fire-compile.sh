#!/bin/bash
# IDENTITY: VERSION 4.3 // PATH_EXPLICIT_FORGE // HAHA!
# ROLE: Strike root .asm into the ./avis/ vault.
echo "FORGE: Initializing Version 2 Rebuild in ./avis/..."

mkdir -p ./avis/

# Find only root-level .asm to prevent V1/V2 source collision
find . -maxdepth 1 -name "*.asm" | while read -r f; do
    BASE=$(basename "${f%.asm}")
    OUT="./avis/${BASE}.exe"
    
    echo "FORGE: [STRIKE] Compiling $f -> $OUT"
    nasm -f elf64 "$f" -o "${BASE}.o" && ld "${BASE}.o" -o "$OUT"
    
    if [ $? -eq 0 ]; then
        chmod +x "$OUT"
        rm -f "${BASE}.o"
        echo "BASH: [ACK] FORGED: $OUT"
    fi
done
