#!/bin/bash
# IDENTITY: VERSION 4.7 // OBJECT_PRESERVATION // HAHA!
echo "FIRE_COMPILE: Forging with Full Identity Trail..."

find . -maxdepth 1 -name "*.asm" | while read -r f; do
    BASE=$(basename "${f%.asm}")
    # Preserve the .o for the AVIS Audit
    nasm -f elf64 "$f" -o "${BASE}.o" && ld "${BASE}.o" -o "./avis/${BASE}.exe"
    if [ $? -eq 0 ]; then
        chmod +x "./avis/${BASE}.exe"
        echo "BASH: [ACK] FORGED: ${BASE}.exe and ${BASE}.o seated."
    fi
done
