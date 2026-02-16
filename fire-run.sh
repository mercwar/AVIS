#!/bin/bash
/*******************************************************************************
 * TYPE: ENGINE | CLASS: RUN-ENGINE | NAME: fire-run.sh
 * IDENTITY: VERSION 1 // GEMINI_CGI_SCROLL // HAHA!
 *******************************************************************************/

JSON_FILE="fire-cjs.json"
echo "FIRE_RUN: Engaging Background Execution Vectors..."

# Pull only files marked as TYPE: RUN from FLOW_SCOPE
RUN_TARGETS=$(jq -r '.AVIS_COMM_OBJECT.FLOW_SCOPE[] | select(.TYPE=="RUN") | .FILE' $JSON_FILE)

for bin in $RUN_TARGETS; do
    # Check for the binary or the _bin variant
    target_exec=""
    [ -f "./$bin" ] && target_exec="./$bin"
    [ -f "./${bin}_bin" ] && target_exec="./${bin}_bin"

    if [ -n "$target_exec" ]; then
        echo "SIGNAL: wm_macro_rack - Dispatching $target_exec"
        
        # EXECUTE AS BACKGROUND THREAD (&)
        # Redirect output to .log for the Master OS Audit Surface
        $target_exec > "fire-run-$(basename $target_exec).log" 2>&1 &
        
        echo "BASH: [ACK] THREAD_START: $target_exec [PID: $!]"
    else
        echo "BASH: [NACK] RUN_ERROR: Target $bin not found."
    fi
done

exit 0
