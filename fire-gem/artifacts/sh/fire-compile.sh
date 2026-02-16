#!/bin/bash
/*******************************************************************************
 * TYPE: SERVICE | CLASS: FORGE-ENGINE | NAME: fire-compile.sh
 * IDENTITY: VERSION 3 // FIRE-GEM SPECIALIZED // HAHA!
 * ROLE: Forge .asm targets into .exe binaries for straight-line execution.
 *******************************************************************************/

VAULT_JSON="fire-gem/artifacts/json/asm/"

echo "[AVIS] FORGE_SERVICE: Initializing ASM-to-EXE Smithy..."

# 1. SCAN ASM VAULT FOR COMPLIANT SOURCE FILES
for target_json in $(find "$VAULT_JSON" -name "*.json"); do
    echo "FORGE: Ingesting $target_json for Forge Targets..."
    
    # Extract ASM source filenames from the Registry
    ASM_SOURCES=$(jq -r '.AVIS_COMM_OBJECT.REGISTRY[] | select(.DIR_ID=="ROOT_ASM") | .FILES[].NAME' "$target_json" 2>/dev/null)
    
    for src in $ASM_SOURCES; do
        if [ -f "$src" ]; then
            # Define output as .exe for the Joe Tron engine
            EXE_NAME="${src%.asm}.exe"
            OBJ_NAME="${src%.asm}.o"
            
            echo "FORGE: [STRIKE] Compiling $src -> $EXE_NAME"

            # 2. X86_64 NASM ASSEMBLE (ELF64)
            nasm -f elf64 "$src" -o "$OBJ_NAME"
            
            if [ -f "$OBJ_NAME" ]; then
                # 3. LD LINKER (Building the EXE)
                ld "$OBJ_NAME" -o "$EXE_NAME"
                rm "$OBJ_NAME" # Clean object to prevent collision
                chmod +x "$EXE_NAME"
                echo "BASH: [ACK] FORGED_EXE: $EXE_NAME seated."
            else
                echo "BASH: [NACK] FORGE_ERROR: $src failed assembly."
            fi
        else
            echo "BASH: [NACK] MISSING_SOURCE: $src"
        fi
    done
done

echo "FIRE-COMPILE: All forge cycles complete. wm_macro_ack."
exit 0
