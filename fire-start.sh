#!/bin/bash
# IDENTITY: VERSION 3.9 // CJS-STACK-COMPLIANT // HAHA!
# ROLE: Execute AVIS_CJS_OBJECT Program Stack from fire-cjs.json

CJS_FILE="fire-cjs.json"

# --- CORE LOGIC ---
echo "[AVIS] PULSE: Ingesting CJS Program Stack..."

IDX=0
while true; do
    # Capture current command code
    CODE=$(jq -r ".AVIS_CJS_OBJECT.PROGRAM_STACK[$IDX].CODE // \"null\"" "$CJS_FILE")
    
    # Exit if we hit the end of the stack
    if [ "$CODE" == "null" ] || [ "$CODE" == "EXIT" ]; then 
        echo "[AVIS] wm_macro_ack: Stack reached EXIT sentinel."
        break 
    fi

    case $CODE in
        "WM_REGISTER_CLASS")
            SRC=$(jq -r ".AVIS_CJS_OBJECT.PROGRAM_STACK[$IDX].SOURCE" "$CJS_FILE")
            CLS=$(jq -r ".AVIS_CJS_OBJECT.PROGRAM_STACK[$IDX].CLASS_NAME" "$CJS_FILE")
            echo "WIN43: Registering Class $CLS from $SRC..."
            
            # ASM FORGE: Smith to the /avis/ vault
            nasm -f elf64 "$SRC" -o temp.o && ld temp.o -o "avis/${SRC%.asm}.exe"
            rm -f temp.o
            echo "BASH: [ACK] $CLS Seated in /avis/"
            ;;

        "WM_CREATE_PROC")
            ID=$(jq -r ".AVIS_CJS_OBJECT.PROGRAM_STACK[$IDX].ID" "$CJS_FILE")
            echo "WIN43: Initializing $ID"
            
            # Spawning the "Threads" (Shell Scripts defined in the JSON)
            T_COUNT=$(jq ".AVIS_CJS_OBJECT.PROGRAM_STACK[$IDX].THREADS | length" "$CJS_FILE" 2>/dev/null || echo 0)
            for (( j=0; j<$T_COUNT; j++ )); do
                FUNC=$(jq -r ".AVIS_CJS_OBJECT.PROGRAM_STACK[$IDX].THREADS[$j].FUNCTION" "$CJS_FILE")
                
                if [ -f "./$FUNC" ]; then
                    chmod +x "./$FUNC"
                    # Execution with real-time log flush
                    nohup stdbuf -oL -eL "./$FUNC" > "logs/thread-$FUNC.log" 2>&1 &
                    echo "THREAD_ACK: $FUNC running [PID: $!]"
                fi
            done
            ;;
    esac
    IDX=$((IDX + 1))
done

# Seal the Pulse
[ -f "./fire-end.sh" ] && chmod +x fire-end.sh && ./fire-end.sh
