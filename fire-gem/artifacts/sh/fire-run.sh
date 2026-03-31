#!/bin/bash
# IDENTITY: VERSION 4.5 // ZERO_BUFFER_FORCE // HAHA!
BIN_DIR="./avis"
LOG_DIR="./logs"

echo "[AVIS] RUN_SERVICE: Forcing Unbuffered Dispatch..."

mkdir -p "$LOG_DIR"
for binary in "$BIN_DIR"/*.exe; do
    [ -e "$binary" ] || continue
    BASE=$(basename "$binary")
    LOG_FILE="$LOG_DIR/run-${BASE}.log"

    # -o0 for absolute zero buffering
    nohup stdbuf -o0 -e0 "$binary" > "$LOG_FILE" 2>&1 &
    
    echo "BASH: [ACK] THREAD_START: $BASE [PID: $!]"
done
