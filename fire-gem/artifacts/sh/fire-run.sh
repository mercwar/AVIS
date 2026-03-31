#!/bin/bash
# /*******************************************************************************
#  * TYPE: ENGINE | CLASS: RUN-ENGINE | NAME: fire-run.sh
#  * IDENTITY: VERSION 4.0 // MASTER-PULSE // HAHA!
#  * ROLE: Execute binaries from the /avis/ vault with persistent logging.
#  *******************************************************************************/

BIN_DIR="./avis"
LOG_DIR="./logs"

mkdir -p "$LOG_DIR"

echo "FIRE_RUN: Engaging Background Execution Vectors from $BIN_DIR..."

# 1. EXECUTE ALL BINARIES IN VAULT
if [ -d "$BIN_DIR" ]; then
    for binary in "$BIN_DIR"/*.exe; do
        [ -e "$binary" ] || continue
        
        BASE=$(basename "$binary")
        LOG_FILE="$LOG_DIR/run-${BASE}.log"
        
        echo "SIGNAL: Dispatching Service: $BASE"
        
        # Use nohup and stdbuf to prevent the "Empty Log" buffering issue
        nohup stdbuf -oL -eL "$binary" > "$LOG_FILE" 2>&1 &
        
        echo "BASH: [ACK] THREAD_START: $BASE seated [PID: $!]"
    done
else
    echo "BASH: [NACK] VAULT $BIN_DIR NOT FOUND. NO TARGETS TO RUN."
fi

echo "FIRE-RUN: All services dispatched. wm_macro_ack."
