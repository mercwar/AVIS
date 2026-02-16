#!/bin/bash
# FILE: fire-compile.sh
# IDENTITY: VERSION 2 // FIRE-COMPILE // CVBGOD
# ROLE: Autonomous ASM Discovery and Forge Engine

echo "AVIS: Fire-Compile Engaged. Searching for ASM Targets..."

# 1. ENSURE TOOLCHAIN IS READY
# GitHub Runners usually have NASM, but we verify to avoid wm_macro_nack
if ! command -v nasm &> /dev/null; then
    echo "FIRE_COMPILE: NASM not found. Attempting emergency install..."
    sudo apt-get update && sudo apt-get install -y nasm binutils
fi

# 2. DISCOVERY LOOP
# Recursively find all .asm files using the 'find' command
ASM_FILES=$(find . -maxdepth 3 -name "*.asm")

if [ -z "$ASM_FILES" ]; then
    echo "wm_macro_nack: No ASM targets found in workspace."
    exit 0 # Non-critical failure for the chain
fi

for source in $ASM_FILES; do
    # Extract filename without extension for the output binary
    base_name=$(basename "$source" .asm)
    dir_name=$(dirname "$source")
    
    echo "FORGE: Processing $source -> ${base_name}_bin"

    # STEP A: ASSEMBLE (Object Code Creation)
    # Target: 64-bit ELF format
    nasm -f elf64 "$source" -o "$dir_name/${base_name}.o"
    
    if [ $? -eq 0 ]; then
        # STEP B: LINK (Executable Creation)
        # Link the object file into a standalone binary
        ld "$dir_name/${base_name}.o" -o "${base_name}_bin"
        
        # Clean up the object file to keep the workspace clean
        rm "$dir_name/${base_name}.o"
        
        echo "wm_macro_ack: ${base_name}_bin foraged and seated."
    else
        echo "wm_macro_nack: Assembly failed for $source"
    fi
done

echo "FIRE_COMPILE: All ASM targets synchronized. Handshake complete."
exit 0
