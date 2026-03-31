#!/bin/bash
# /*******************************************************************************
#  * TYPE: ENGINE | CLASS: FORGE-ENGINE | NAME: fire-compile.sh
#  * IDENTITY: VERSION 1.1 // GEMINI_CGI_SCROLL // HEADER_FIXED // HAHA!
#  *******************************************************************************/

# EXPLICIT PATHING FOR GITHUB WORKSPACE
JSON_FILE="./fire-cjs.json"

echo "FIRE_COMPILE: Initializing Forge for ASM Targets..."

# 1. ATTEMPT JQ INGESTION FROM CJS REGISTRY
if [ -f "$JSON_FILE" ]; then
    echo "FIRE_COMPILE: Ingesting ASM Registry from $JSON_FILE..."
    # Extracts NAMES specifically from the ROOT_ASM DIR_ID
    ASM_FILES=$(jq -r '.AVIS_CJS_OBJECT.REGISTRY[] | select(.DIR_ID=="ROOT_ASM") | .FILES[].NAME' "$JSON_FILE" 2>/dev/null)
else
    echo "BASH: [NACK] $JSON_FILE NOT FOUND in $(pwd). Skipping JQ ingestion."
fi

# 2. AUTONOMOUS FALLBACK (If JSON fails, is empty, or missing)
if [ -z "$ASM_FILES" ] || [ "$ASM_FILES" == "null" ]; then
    echo "FIRE_COMPILE: Registry empty or JSON missing. Executing Autonomous Discovery..."
    ASM_FILES=$(find . -maxdepth 2 -name "*.asm")
fi

# 3. MASTER FORGE LOOP
for source in $ASM_FILES; do
    # Skip if file doesn't exist
    if [ ! -f "$source" ]; then continue; fi

    # Create binary name (e.g., avis.asm -> avis_bin)
    binary="${source%.asm}_bin"
    
    # Check if a directory with this name exists to avoid ld 403/Is a directory error
    if [ -d "$binary" ]; then
        binary="${binary}_out"
    fi

    echo "FORGE: Compiling $source -> $binary"

    # X86_64 NASM ASSEMBLE -> LD LINK
    nasm -f elf64 "$source" -o temp.o && ld temp.o -o "$binary"
    
    if [ $? -eq 0 ]; then
        rm -f temp.o
        chmod +x "$binary"
        echo "BASH: [ACK] FORGED: $binary"
    else
        echo "BASH: [NACK] COMPILE_ERROR: $source"
        rm -f temp.o
    fi
done

echo "FIRE_COMPILE: Forge cycle complete. wm_macro_ack."
exit 0
