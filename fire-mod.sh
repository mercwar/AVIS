#!/bin/bash
# /*******************************************************************************
#  * TYPE: SERVICE | CLASS: MOD-ENGINE | NAME: fire-mod.sh
#  * IDENTITY: VERSION 3.1 // HEADER_FIXED // HAHA!
#  * ROLE: Ingest JSON/ASM Vault and Seat Permissions for Background Services.
#  *******************************************************************************/

# 1. DEFINE VAULT LOCATIONS
VAULT_JSON="fire-gem/artifacts/json/asm/"
CBORD_VAULT="fire-gem/artifacts/cbord/reg/"

# 2. SEAT CORE DIRECTORIES (Atomic Operation)
mkdir -p "$VAULT_JSON"
mkdir -p "$CBORD_VAULT"
mkdir -p "fire-gem/artifacts/json/reg/"

echo "[AVIS] MOD_SERVICE: Initializing Vault Permissions..."

# 3. SCAN ASM VAULT FOR TARGETS
# Added -type f to ensure we only target actual files
for target in $(find "$VAULT_JSON" -type f -name "*.json" 2>/dev/null); do
    echo "MOD: Parsing $target for Permission Seating..."
    
    # Extract file names from the CJS-JSON structure
    # Added || echo "" to handle empty/malformed JSON safely
    FILES=$(jq -r '.AVIS_COMM_OBJECT.REGISTRY[].FILES[].NAME' "$target" 2>/dev/null || echo "")
    
    for f in $FILES; do
        # Only attempt chmod if the filename is valid and exists
        if [ -n "$f" ] && [ "$f" != "null" ] && [ -f "$f" ]; then
            chmod 755 "$f"
            echo "BASH: [ACK] WM_MACRO_ACK -> SEATED: $f"
        fi
    done
done

# 4. CHMOD THE WORKERS
# Using -f to prevent errors if the files aren't created yet by the Forge
chmod +x fire-gem/artifacts/sh/fire-compile.sh 2>/dev/null
chmod +x fire-gem/artifacts/sh/fire-run.sh 2>/dev/null

echo "FIRE-MOD: All robotic assets seated for background service. [EXIT]"
exit 0
