#!/bin/bash
/*******************************************************************************
 * TYPE: ENGINE | CLASS: MOD-ENGINE | NAME: fire-mod.sh
 * IDENTITY: VERSION 1 // GEMINI_CGI_SCROLL // HAHA!
 *******************************************************************************/

# 1. READ RESOURCE LIST FROM CJS
JSON_FILE="fire-cjs.json"

if [ ! -f "$JSON_FILE" ]; then
    echo "BASH: [NACK] $JSON_FILE NOT FOUND. MOD-ENGINE ABORTED."
    exit 1
fi

echo "FIRE_MOD: Ingesting Registry for Permission Seating..."

# 2. PULL EVERY 'NAME' FROM THE REGISTRY NEST
# This selects all files regardless of DIR_ID to ensure global seating
TOTAL_FILES=$(jq -r '.AVIS_CJS_OBJECT.REGISTRY[].FILES[].NAME' $JSON_FILE 2>/dev/null)

if [ -z "$TOTAL_FILES" ] || [ "$TOTAL_FILES" == "null" ]; then
    echo "BASH: [NACK] NO FILES FOUND IN REGISTRY NEST."
    exit 0
fi

# 3. ATOMIC CHMOD LOOP
for target in $TOTAL_FILES; do
    if [ -f "$target" ]; then
        # Grant executable status to all listed assets
        chmod +x "$target"
        echo "BASH: [ACK] MODDED: $target"
    else
        # Fallback check for compiled variants
        if [ -f "${target}_bin" ]; then
            chmod +x "${target}_bin"
            echo "BASH: [ACK] MODDED BINARY: ${target}_bin"
        else
            echo "BASH: [NACK] MISSING: $target"
        fi
    fi
done

echo "FIRE_MOD: Seating Complete. wm_macro_ack."
exit 0
