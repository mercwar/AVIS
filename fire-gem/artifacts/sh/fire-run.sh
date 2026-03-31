#!/bin/bash
# IDENTITY: VERSION 4.0 // MASTER-PULSE // HAHA!
# ROLE: Background execution with real-time log flushing.
BIN_DIR="./avis"
LOG_DIR="./logs"
mkdir -p "$LOG_DIR"
echo "FIRE_RUN: Engaging Background Execution Vectors from $BIN_DIR..."
if [ -d "$BIN_DIR" ]; then
    for binary in "$BIN_DIR"/*.exe; do
        [ -e "$binary" ] || continue
        BASE=$(basename "$binary")
        LOG_FILE="$LOG_DIR/run-${BASE}.log"
        echo "SIGNAL: Dispatching Service: $BASE"
        # Real-time flush to prevent empty logs
        nohup stdbuf -oL -eL "$binary" > "$LOG_FILE" 2>&1 &
        echo "BASH: [ACK] THREAD_START: $BASE seated [PID: $!]"
    done
else
    echo "BASH: [NACK] VAULT $BIN_DIR NOT FOUND."
fi
echo "FIRE-RUN: All services dispatched. wm_macro_ack."


echo "FIRE-RUN: All services dispatched. wm_macro_ack."
