#!/bin/bash
/*******************************************************************************
 * TYPE: SERVICE | CLASS: RUN-ENGINE | NAME: fire-run.sh
 * IDENTITY: JOE TRON // VERSION 3 // HAHA!
 * ROLE: Execute .exe binaries as background services with persistent logging.
 *******************************************************************************/

VAULT_JSON="fire-gem/artifacts/json/asm/"

echo "[AVIS] RUN_SERVICE: Engaging Background Execution Vectors..."

# 1. SCAN ASM VAULT FOR RUN COMMANDS
for target_json in $(find "$VAULT_JSON" -name "*.json"); do
    echo "RUN: Parsing $target_json for Execution Targets..."
    
    # Extract files marked as RUN or defined as TARGET binaries
    # We look for the "TARGET" field in your FLOW_SCOPE
    RUN_FILES=$(jq -r '.AVIS_COMM_OBJECT.FLOW_SCOPE[] | select(.TYPE=="RUN") | .FILE' "$target_json" 2>/dev/null)
    
    for bin in $RUN_FILES; do
        # Support for both raw names and .exe extensions
        EXEC_TARGET=""
        [ -f "./$bin" ] && EXEC_TARGET="./$bin"
        [ -f "./${bin}.exe" ] && EXEC_TARGET="./${bin}.exe"
        [ -f "./${bin}_bin" ] && EXEC_TARGET="./${bin}_bin"

        if [ -n "$EXEC_TARGET" ]; then
            echo "SIGNAL: wm_macro_rack - Dispatching Service: $EXEC_TARGET"
            
            # 2. EXECUTE AS BACKGROUND SERVICE (&)
            # Redirect STDOUT and STDERR to a unique log for the Audit Surface
            chmod +x "$EXEC_TARGET"
            nohup "$EXEC_TARGET" > "fire-run-$(basename "$EXEC_TARGET").log" 2>&1 &
            
            PID=$!
            echo "BASH: [ACK] THREAD_START: $EXEC_TARGET seated at PID: $PID"
        else
            echo "BASH: [NACK] RUN_ERROR: Target $bin NOT FOUND in root."
        fi
    done
done

echo "FIRE-RUN: All services dispatched to background. wm_macro_ack."
exit 0
