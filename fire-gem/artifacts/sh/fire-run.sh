#!/bin/bash
# IDENTITY: VERSION 4.6 // FOREGROUND_INGEST_FORCE // HAHA!
BIN_DIR="./avis"
LOG_DIR="./logs"
mkdir -p "$LOG_DIR"

echo "[AVIS] RUN_SERVICE: Initiating Foreground Teaching Pulse..."

# 1. TRIGGER THE TEACHER IN FOREGROUND (Ensures log capture)
TEACHER="./avis/fire-gem-0003.exe"
if [ -f "$TEACHER" ]; then
    echo "SIGNAL: Engaging $TEACHER..."
    # Running directly without nohup to force synchronous log flushing
    "$TEACHER" 2>&1 | tee "$LOG_DIR/run-fire-gem-0003.exe.log"
else
    echo "[NACK] RUN_ERROR: Teacher binary not found."
fi

# 2. DISPATCH REMAINING SERVICES IN BACKGROUND
for binary in "$BIN_DIR"/*.exe; do
    BASE=$(basename "$binary")
    [ "$BASE" == "fire-gem-0003.exe" ] && continue # Skip the teacher
    
    nohup stdbuf -o0 -e0 "$binary" > "$LOG_DIR/run-${BASE}.log" 2>&1 &
done

echo "FIRE-RUN: Teaching cycle complete. Dispatching background pulse."
