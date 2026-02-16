#!/bin/bash
# FILE: fire-mod.sh
# IDENTITY: VERSION 2 // FIRE-MOD // CVBGOD
# ROLE: Centralized Permission Ingestion & Overwrite Logic

JSON_FILE=".github/workflows/json/resource.json"

# 1. VALIDATE RESOURCE PRESENCE
if [ ! -f "$JSON_FILE" ]; then
    echo "wm_macro_nack: RESOURCE.JSON MISSING AT $JSON_PATH"
    exit 1
fi

# 2. EXTRACT WRAPPER GUID
GUID=$(jq -r '.AVIS_COMM_OBJECT.WRAPPER_GUID' $JSON_FILE)
echo "FIRE_MOD: Ingesting $GUID Stack..."

# 3. BULK CHMOD VIA REGISTRY NEST
# This dives into every DIR_ID (ROOT_SH, ROOT_ASM, etc.) 
# and pulls the 'NAME' field for every file.
TOTAL_FILES=$(jq -r '.AVIS_COMM_OBJECT.REGISTRY[].FILES[].NAME' $JSON_FILE)

echo "FIRE_MOD: Seating Hardware..."

for target in $TOTAL_FILES; do
    if [ -f "$target" ]; then
        chmod +x "$target"
        echo "SEATED: $target [wm_macro_ack]"
    else
        # Search for compiled bin variants if the source is missing
        if [ -f "${target}_bin" ]; then
            chmod +x "${target}_bin"
            echo "SEATED BINARY: ${target}_bin"
        else
            echo "FIRE_MOD_WARNING: Target $target not found. Skipping."
        fi
    fi
done

# 4. OVERWRITE LOGIC
# If multiple objects exist, fire-mod forces the 'MOST_RECENT' status
OVERWRITE=$(jq -r '.AVIS_COMM_OBJECT.OVERWRITE_TARGET' $JSON_FILE)
echo "FIRE_MOD: Identity status set to $OVERWRITE."

exit 0
