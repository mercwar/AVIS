#!/bin/bash
# /*******************************************************************************
#  * TYPE: SERVICE | CLASS: FORGE-ENGINE | NAME: fire-compile.sh
#  * IDENTITY: VERSION 3.1 // HEADER_FIXED // HAHA!
#  * ROLE: Forge .asm targets into .exe binaries for straight-line execution.
#  *******************************************************************************/

VAULT_JSON="fire-gem/artifacts/json/asm/"

echo "[AVIS] FORGE_SERVICE: Initializing ASM-to-EXE Smithy..."

# 1. SCAN ASM VAULT FOR COMPLIANT SOURCE FILES
# Using -f to ensure we only target files
for target_json in $(find "$VAULT_JSON" -type f -name "*.json" 2>/dev/null); do
    echo "FORGE: Ingesting $target_json for Forge Targets..."
    
    # Extract ASM source filenames from the Registry
    # Added || echo "" to prevent jq from crashing on empty/malformed JSON
    ASM_SOURCES=$(jq -r '.AVIS_COMM_OBJECT.REGISTRY[] | select(.DIR_ID=="ROOT_ASM") | .FILES[].NAME' "$target_json" 2>/dev/null || echo "")
    
    for src in $ASM_SOURCES; do
        if [ -f "$src" ]; then
            # Define output as .exe for the Joe Tron engine
            EXE_NAME="${src%.asm}.exe"
            OBJ_NAME="${src%.asm}.o"
            
            # Safety: If a directory exists with the name, append _bin
            if [ -d "$EXE_NAME" ]; then
                EXE_NAME="${src%.asm}_bin.exe"
            fi

            echo "FORGE: [STRIKE] Compiling $src -> $EXE_NAME"

            # 2. X86_64 NASM ASSEMBLE (ELF64)
            nasm -f elf64 "$src" -o "$OBJ_NAME"
            
            if [ -f "$OBJ_NAME" ]; then
                # 3. LD LINKER (Building the EXE)
                ld "$OBJ_NAME" -o "$EXE_NAME"
                rm -f "$OBJ_NAME" 
                chmod +x "$EXE_NAME"
                echo "BASH: [ACK] FORGED_EXE: $EXE_NAME seated."
            else
                echo "BASH: [NACK] FORGE_ERROR: $src failed assembly."
            fi
        else
            # Only report missing if the string isn't empty
            if [ -n "$src" ] && [ "$src" != "null" ]; then
                echo "BASH: [NACK] MISSING_SOURCE: $src"
            fi
        fi
    done
done

echo "FIRE-COMPILE: All forge cycles complete. wm_macro_ack."
exit 0
