#!/bin/bash
# FILE: fire-run.sh
# IDENTITY: VERSION 2 // FIRE-RUN // CVBGOD
# ROLE: Asynchronous Binary Execution and Macro Signaling

JSON_FILE=".github/workflows/json/resource.json"

echo "AVIS: Fire-Run Vector Engaged. Ingesting Background Tasks..."

# 1. EXTRACT RUN-TARGETS FROM FLOW_SCOPE
# This only pulls files where TYPE is exactly 'RUN'
RUN_TARGETS=$(jq -r '.AVIS_COMM_OBJECT.FLOW_SCOPE[] | select(.TYPE=="RUN") | .FILE' $JSON_FILE)

if [ -z "$RUN_TARGETS" ]; then
    echo "FIRE_RUN: No active RUN targets detected in FLOW_SCOPE."
    exit 0
fi

# 2. EXECUTION LOOP
for bin in $RUN_TARGETS; do
    # Check for direct file or compiled _bin variant
    TARGET_EXEC=""
    if [ -f "./$bin" ]; then
        TARGET_EXEC="./$bin"
    elif [ -f "./${bin}_bin" ]; then
        TARGET_EXEC="./${bin}_bin"
    fi

    if [ -n "$TARGET_EXEC" ]; then
        echo "SIGNAL: wm_macro_rack - Initializing $TARGET_EXEC"
        chmod +x "$TARGET_EXEC"
        
        # EXECUTE IN BACKGROUND (&)
        # Redirect output to a log for the Master OS Audit Surface
        $TARGET_EXEC > "fire-run-$(basename $TARGET_EXEC).log" 2>&1 &
        
        PID=$!
        echo "AVIS_RUN: $TARGET_EXEC seated at PID: $PID"
    else
        echo "wm_macro_nack: Execution target $bin NOT FOUND."
    fi
done

# 3. ACKNOWLEDGE TRIGGER COMPLETE
echo "FIRE_RUN: All background vectors dispatched. [wm_macro_ack]"
exit 0
