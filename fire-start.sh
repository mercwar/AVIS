#!/bin/bash
# IDENTITY: VERSION 2 // FIRE-START // MASTER-BRAIN
# ROLE: Automated Flow Orchestrator

JSON_FILE=".github/workflows/json/resource.json"

# 1. INITIALIZE & MOD
chmod +x fire-mod.sh
./fire-mod.sh

# 2. INGEST FLOW SCOPE
COUNT=$(jq '.AVIS_COMM_OBJECT.FLOW_SCOPE | length' $JSON_FILE)

for (( i=0; i<$COUNT; i++ )); do
    FILE=$(jq -r ".AVIS_COMM_OBJECT.FLOW_SCOPE[$i].FILE" $JSON_FILE)
    TYPE=$(jq -r ".AVIS_COMM_OBJECT.FLOW_SCOPE[$i].TYPE" $JSON_FILE)
    WAIT=$(jq -r ".AVIS_COMM_OBJECT.FLOW_SCOPE[$i].WAIT" $JSON_FILE)
    
    echo "AVIS_FLOW: Processing $FILE [$TYPE]"

    if [ "$TYPE" == "COMPILE" ]; then
        # SEQUENTIAL COMPILE (Wait for Acknowledge)
        chmod +x "./$FILE"
        ./"$FILE"
        if [ $? -eq 0 ]; then
            echo "wm_macro_ack: $FILE complete."
        else
            echo "wm_macro_nack: $FILE failed."
            exit 1
        fi
    elif [ "$TYPE" == "RUN" ]; then
        # ASYNC RUN (Fire and Forget)
        chmod +x "./$FILE"
        ./"$FILE" &
        echo "wm_macro_rack: $FILE running in background."
    fi
done

# 3. AUTO-SEAL (If fire-end isn't in JSON, we call it last anyway)
if [[ ! $(grep "fire-end.sh" $JSON_FILE) ]]; then
    chmod +x fire-end.sh
    ./fire-end.sh
fi
