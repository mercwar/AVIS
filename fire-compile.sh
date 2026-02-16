#!/bin/bash
/*******************************************************************************
 * TYPE: ENGINE | CLASS: FORGE-ENGINE | NAME: fire-compile.sh
 * IDENTITY: VERSION 1 // GEMINI_CGI_SCROLL // HAHA!
 *******************************************************************************/

echo "FIRE_COMPILE: Initializing Forge for ASM Targets..."

# Find all .asm files in root and VERSION 1/
ASM_FILES=$(find . -maxdepth 2 -name "*.asm")

for source in $ASM_FILES; do
    binary="${source%.asm}_bin"
    echo "FORGE: Compiling $source -> $binary"

    # X86_64 NASM ASSEMBLE -> LD LINK
    nasm -f elf64 "$source" -o temp.o && ld temp.o -o "$binary"
    
    if [ $? -eq 0 ]; then
        rm temp.o
        chmod +x "$binary"
        echo "BASH: [ACK] FORGED: $binary"
    else
        echo "BASH: [NACK] COMPILE_ERROR: $source"
    fi
done

exit 0
