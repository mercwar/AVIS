#!/bin/bash
# /*******************************************************************************
#  * TYPE: ENGINE | CLASS: FORGE-ENGINE | NAME: fire-compile.sh
#  * IDENTITY: VERSION 4.0 // MODULAR_FORGE // HAHA!
#  * ROLE: Discover and Smith .asm targets into the /avis/ vault.
#  *******************************************************************************/

# 1. PREPARE THE VAULT
mkdir -p ./avis/
echo "FORGE: Seating /avis/ vault for binary ingestion..."

# 2. DISCOVER AND SMITH
# We search for .asm files and output directly to the avis/ directory
find . -maxdepth 2 -name "*.asm" | while read -r f; do
    # Strip path and extension for the binary name
    BASE=$(basename "${f%.asm}")
    OUT_NAME="./avis/${BASE}.exe"
    
    echo "FORGE: [STRIKE] Compiling $f -> $OUT_NAME"
    
    nasm -f elf64 "$f" -o "${BASE}.o"
    ld "${BASE}.o" -o "$OUT_NAME"
    
    if [ $? -eq 0 ]; then
        chmod +x "$OUT_NAME"
        rm -f "${BASE}.o"
        echo "BASH: [ACK] FORGED: $OUT_NAME"
    else
        echo "BASH: [NACK] COMPILE_ERROR: $f"
        rm -f "${BASE}.o"
    fi
done

echo "FIRE_COMPILE: Forge cycle complete. wm_macro_ack."
