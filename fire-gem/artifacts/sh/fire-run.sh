#!/bin/bash
# IDENTITY: VERSION 4.3 // PATH_EXPLICIT_RUN // HAHA!
# ROLE: Dispatch binaries specifically from the ./avis/ directory.
echo "FIRE_RUN: Dispatching Version 2 services from ./avis/..."

mkdir -p ./logs/

for binary in ./avis/*.exe; do
    [ -e "$binary" ] || continue
    BASE=$(basename "$binary")
    
    # Logs are seated in the root ./logs/ directory
    nohup stdbuf -oL -eL "$binary" > "./logs/run-${BASE}.log" 2>&1 &
    echo "BASH: [ACK] THREAD_START: ./avis/$BASE [PID: $!]"
done
