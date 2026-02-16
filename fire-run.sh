#!/bin/bash
/*******************************************************************************
 * TYPE: ENGINE | CLASS: RUN-ENGINE | NAME: fire-run.sh
 * IDENTITY: VERSION 1 // GEMINI_CGI_SCROLL // HAHA!
 *******************************************************************************/

JSON_FILE="fire-cjs.json"

if [ ! -f "$JSON_FILE" ]; then
    echo "BASH: [NACK] $JSON_FILE MISSING. RUN-ENGINE ABORTED."
    exit 1
fi

echo "FIRE_RUN: Engaging Background Execution Vectors..."

# 1. PULL 'RUN' TARGETS FROM FLOW_SCOPE NEST
# This searches for all objects in FLOW_SCOPE where TYPE is RUN
RUN_TARGETS=$(jq -r '.AVIS_CJS_OBJECT.FLOW_SCOPE[] | select(.TYPE=="RUN") | .FILE' $JSON_FILE 2>/dev/null)

if [ -z "$RUN_TARGETS" ] || [ "$RUN_TARGETS" == "null" ]; then
    echo "BASH: [ACK] NO RUN TARGETS DEFINED IN FLOW_SCOPE."
    exit 0
fi

# 2. EXECUTION LOOP
for bin in $RUN_TARGETS; do
    # Check for direct file or the compiled _bin variant
    target_exec=""
    [ -f "./$bin" ] && target_exec="./$bin"
    [ -f "./${bin}_bin" ] && target_exec="./${bin}_bin"

    if [ -n "$target_exec" ]; then
        echo "SIGNAL: wm_macro_rack - Dispatching $target_exec"
        
        # 3. EXECUTE AS BACKGROUND THREAD (&)
        # Piped to log files for the Master OS Audit Surface
        chmod +x "$target_exec"
        $target_exec > "fire-run-$(basename $target_exec).log" 2>&1 &
        
        echo "BASH: [ACK] THREAD_START: $target_exec [PID: $!]"
    else
        echo "BASH: [NACK] RUN_ERROR: Target $bin NOT FOUND in workspace."
    fi
done

echo "FIRE_RUN: All background vectors dispatched. wm_macro_ack."
exit 0

