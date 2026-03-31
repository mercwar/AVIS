#!/bin/bash
# /*******************************************************************************
#  * TYPE: SERVICE | CLASS: RUN-ENGINE | NAME: fire-run.sh
#  * IDENTITY: JOE TRON // VERSION 3.1 // HEADER_FIXED // HAHA!
#  * ROLE: Execute .exe binaries as background services with persistent logging.
#  *******************************************************************************/

VAULT_JSON="fire-gem/artifacts/json/asm/"

echo "[AVIS] RUN_SERVICE: Engaging Background Execution Vectors..."

# 1. SCAN ASM VAULT FOR RUN COMMANDS
# Using -type f to avoid directory collisions
for target_json in $(find "$VAULT_JSON" -type f -name "*.json" 2>/dev/null); do
    echo "RUN: Parsing $target_json for Execution Targets..."
    
    # Extract files marked as RUN or defined as TARGET binaries
    # Added || echo "" to prevent jq from crashing on malformed JSON
    RUN_FILES=$(jq -r '.AVIS_COMM_OBJECT.FLOW_SCOPE[] | select(.TYPE=="RUN") | .FILE' "$target_json" 2>/dev/null || echo "")
    
    for bin in $RUN_FILES; do
        # Cleanup: ignore null or empty results from jq
        [ -z "$bin" ] || [ "$bin" == "null" ] && continue

        # Support for both raw names and .exe extensions
        EXEC_TARGET=""
        if [ -f "./$bin" ]; then EXEC_TARGET="./$bin"
        elif [ -f "./${bin}.exe" ]; then EXEC_TARGET="./${bin}.exe"
        elif [ -f "./${bin}_bin" ]; then EXEC_TARGET="./${bin}_bin"
        fi

        if [ -n "$EXEC_TARGET" ]; then
            echo "SIGNAL: wm_macro_rack - Dispatching Service: $EXEC_TARGET"
            
            # 2. EXECUTE AS BACKGROUND SERVICE (&)
            # Ensure it is executable and run with nohup to survive shell exit
            chmod +x "$EXEC_TARGET"
            LOG_FILE="fire-run-$(basename "$EXEC_TARGET").log"
            
            # Use nohup to ensure the process persists after the Action finishes
            nohup "$EXEC_TARGET" > "$LOG_FILE" 2>&1 &
            
            PID=$!
            echo "BASH: [ACK] THREAD_START: $EXEC_TARGET seated at PID: $PID"
            echo "BASH: [LOG] Persistent output directed to $LOG_FILE"
        else
            echo "BASH: [NACK] RUN_ERROR: Target $bin NOT FOUND in root."
        fi
    done
done

echo "FIRE-RUN: All services dispatched to background. wm_macro_ack."
exit 0
