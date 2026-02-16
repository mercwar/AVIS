#!/bin/bash
/*******************************************************************************
 * TYPE: SERVICE | CLASS: MOD-ENGINE | NAME: fire-mod.sh
 * IDENTITY: VERSION 3 // FIRE-GEM SPECIALIZED // HAHA!
 * ROLE: Ingest JSON/ASM Vault and Seat Permissions for Background Services.
 *******************************************************************************/

# 1. DEFINE VAULT LOCATIONS
VAULT_JSON="fire-gem/artifacts/json/asm/"
CBORD_VAULT="fire-gem/artifacts/cbord/reg/"

# 2. SEAT CORE DIRECTORIES (Atomic Operation)
mkdir -p "$VAULT_JSON"
mkdir -p "$CBORD_VAULT"
mkdir -p "fire-gem/artifacts/json/reg/"

echo "[AVIS] MOD_SERVICE: Initializing Vault Permissions..."

# 3. SCAN ASM VAULT FOR TARGETS
# This identifies all .sh and .asm targets listed in the CJS Registry
for target in $(find "$VAULT_JSON" -name "*.json"); do
    echo "MOD: Parsing $target for Permission Seating..."
    
    # Extract file names from the CJS-JSON structure using JQ
    FILES=$(jq -r '.AVIS_COMM_OBJECT.REGISTRY[].FILES[].NAME' "$target" 2>/dev/null)
    
    for f in $FILES; do
        if [ -f "$f" ]; then
            chmod 755 "$f"
            echo "BASH: [ACK] WM_MACRO_ACK -> SEATED: $f"
        fi
    done
done

# 4. CHMOD THE WORKERS
# Ensure the compile and run scripts are also executable
chmod +x fire-gem/artifacts/sh/fire-compile.sh
chmod +x fire-gem/artifacts/sh/fire-run.sh

echo "FIRE-MOD: All robotic assets seated for background service. [EXIT]"
exit 0
