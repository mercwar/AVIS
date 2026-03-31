#!/bin/bash
# IDENTITY: VERSION 4.8 // OBJECT_PRESERVATION // HAHA!
mkdir -p ./avis/
echo "FIRE_COMPILE: Forging with Full Identity Trail..."
find . -maxdepth 1 -name "*.asm" | while read -r f; do
    BASE=$(basename "${f%.asm}")
    # Removed cleanup to keep .o files seated
    nasm -f elf64 "$f" -o "${BASE}.o" && ld "${BASE}.o" -o "./avis/${BASE}.exe"
    [ $? -eq 0 ] && chmod +x "./avis/${BASE}.exe"
done
