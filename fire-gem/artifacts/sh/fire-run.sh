#!/bin/bash
# IDENTITY: VERSION 5.1 // DROP_RUN_FLUSH // HAHA!
# ROLE: Execute the 000x binaries with Zero-Buffer logging.

BIN_DIR="./avis"
LOG_DIR="./logs"
mkdir -p "$LOG_DIR"

echo "[AVIS] RUN: Engaging Detected Drops..."

# Execute any .bin files created by the Forge
for binary in "$BIN_DIR"/*.bin; do
    [ -e "$binary" ] || continue
    BASE=$(basename "$binary")
    LOG_FILE="$LOG_DIR/run-${BASE}.log"
    
    echo "SIGNAL: Dispatching $BASE..."
    
    # -o0 forces the Robot Learning output to hit the log file INSTANTLY.
    nohup stdbuf -o0 -e0 "$binary" > "$LOG_FILE" 2>&1 &
    
    echo "BASH: [ACK] THREAD_START: $BASE [PID: $!]"
done
