#!/bin/bash
# IDENTITY: VERSION 3 // FIRE-START // MASTER-PULSE // CVBGOD

CJS_FILE="fire-cjs.json"

# --- WIN43 / CJS FUNCTIONS ---
register_class() {
    local src=$1
    local name=$2
    echo "WIN43: Registering Class $name from $src..."
    nasm -f elf64 "$src" -o temp.o && ld temp.o -o "${src%.asm}_bin"
    rm temp.o
    echo "BASH: [ACK] WM_CLASS_REGISTERED: $name"
}

create_proc_threads() {
    local id=$1
    local idx=$2
    echo "WIN43: WM_CREATE_PROC for $id"
    (
        T_COUNT=$(jq ".AVIS_CJS_OBJECT.PROGRAM_STACK[$idx].THREADS | length" $CJS_FILE)
        for (( j=0; j<$T_COUNT; j++ )); do
            T_FILE=$(jq -r ".AVIS_CJS_OBJECT.PROGRAM_STACK[$idx].THREADS[$j].FUNCTION" $CJS_FILE)
            if [ -f "$T_FILE" ]; then
                chmod +x "$T_FILE"
                ./"$T_FILE" &
                echo "THREAD_ACK: $T_FILE running [PID: $!]"
            fi
        done
        wait
    ) &
}

# --- MAIN CJS LOOP ---
IDX=0
while true; do
    CODE=$(jq -r ".AVIS_CJS_OBJECT.PROGRAM_STACK[$IDX].CODE" $CJS_FILE)
    if [ "$CODE" == "null" ] || [ "$CODE" == "EXIT" ]; then break; fi

    case $CODE in
        "WM_REGISTER_CLASS")
            SRC=$(jq -r ".AVIS_CJS_OBJECT.PROGRAM_STACK[$IDX].SOURCE" $CJS_FILE)
            CLS=$(jq -r ".AVIS_CJS_OBJECT.PROGRAM_STACK[$IDX].CLASS_NAME" $CJS_FILE)
            register_class "$SRC" "$CLS"
            ;;
        "WM_CREATE_PROC")
            ID=$(jq -r ".AVIS_CJS_OBJECT.PROGRAM_STACK[$IDX].ID" $CJS_FILE)
            create_proc_threads "$ID" "$IDX"
            ;;
    esac
    IDX=$((IDX + 1))
done

# Seal and Dispatch
chmod +x fire-end.sh
./fire-end.sh
