#!/bin/bash
# IDENTITY: VERSION 4.9 // FORGE_FIX // HAHA!
mkdir -p ./avis/
find . -maxdepth 1 -name "*.asm" | while read -r f; do
    BASE=$(basename "${f%.asm}")
    nasm -f elf64 "$f" -o "${BASE}.o"
    ld "${BASE}.o" -o "./avis/${BASE}.bin"
    chmod +x "./avis/${BASE}.bin"
    echo "FORGE: [ACK] ${BASE}.bin and ${BASE}.o preserved."
done
