#!/bin/bash
# IDENTITY: VERSION 5.1 // DROP_DETECTION_FORGE // HAHA!
# ROLE: Detect JSON drops for 0001/0002/0003 and strike them.

VAULT_JSON="fire-gem/artifacts/json/asm/"
mkdir -p ./avis/

echo "[AVIS] FORGE: Scanning Vault for New Drops..."

# 1. Find every JSON in the vault (0001.json, 0002.json, etc.)
find "$VAULT_JSON" -maxdepth 2 -name "*.json" | while read -r target_json; do
    # 2. Extract the ASM source name from the drop
    ASM_SOURCES=$(jq -r '.AVIS_COMM_OBJECT.REGISTRY[].FILES[].NAME' "$target_json" 2>/dev/null)
    
    for src in $ASM_SOURCES; do
        if [ -f "$src" ]; then
            BASE=$(basename "${src%.asm}")
            OBJ="${BASE}.o"
            BIN="./avis/${BASE}.bin"
            
            echo "FORGE: [STRIKE] Drop Detected: $src -> $BIN"
            
            # STRIKE: No 'rm' here. We keep the .o file for the audit.
            nasm -f elf64 "$src" -o "$OBJ"
            ld "$OBJ" -o "$BIN"
            chmod +x "$BIN"
            
            echo "BASH: [ACK] IDENTITY_SEATED: $OBJ and $BIN"
        fi
    done
done
