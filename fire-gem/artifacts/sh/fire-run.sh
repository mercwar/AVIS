#!/bin/bash
# IDENTITY: VERSION 4.4 // ZERO_BUFFER_PULSE // HAHA!
# ROLE: Force immediate log flushing for FireGem 3.

BIN_DIR="./avis"
LOG_DIR="./logs"
TARGET_TEACHER="avis.AVIS"

echo "[AVIS] RUN_SERVICE: Engaging Zero-Buffer Execution..."

# 1. VERIFY TEACHER EXISTENCE
if [ ! -f "$TARGET_TEACHER" ]; then
    echo "[NACK] RUN_ERROR: $TARGET_TEACHER NOT FOUND in root. Teaching will fail."
    exit 1
fi

# 2. DISPATCH WITH -o0 (UNBUFFERED)
mkdir -p "$LOG_DIR"
for binary in "$BIN_DIR"/*.exe; do
    [ -e "$binary" ] || continue
    BASE=$(basename "$binary")
    LOG_FILE="$LOG_DIR/run-${BASE}.log"

    echo "SIGNAL: Dispatching $BASE with Zero-Buffer..."
    
    # -o0 completely disables stdout buffering
    nohup stdbuf -o0 -e0 "$binary" > "$LOG_FILE" 2>&1 &
    
    echo "BASH: [ACK] THREAD_START: $BASE [PID: $!]"
done

echo "FIRE-RUN: All services seated. Check logs now. wm_macro_ack."
