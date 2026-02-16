#!/bin/bash
/*******************************************************************************
 * TYPE: ENGINE | CLASS: MOD-ENGINE | NAME: fire-mod.sh
 * IDENTITY: VERSION 1 // GEMINI_CGI_SCROLL // HAHA!
 *******************************************************************************/

# 1. READ RESOURCE LIST FROM CJS
JSON_FILE="fire-cjs.json"
echo "FIRE_MOD: Ingesting Registry for Permission Seating..."

# Pull every 'NAME' from the REGISTRY nest
TOTAL_FILES=$(jq -r '.AVIS_COMM_OBJECT.REGISTRY[].FILES[].NAME' $JSON_FILE)

for target in $TOTAL_FILES; do
    if [ -f "$target" ]; then
        # Grant executable status to all listed assets
        chmod +x "$target"
        echo "BASH: [ACK] MODDED: $target"
    else
        echo "BASH: [NACK] MISSING: $target"
    fi
done

exit 0
