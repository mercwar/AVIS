#!/usr/bin/env bash
# AVIS-ARTIFACT
# FILE: AVIS/VERSION 2/fire-gem.sh
# PURPOSE: Execute FIRE-GEM V2 ASM drops
# AUTHOR: Demon

set -e

ASM_FILE="$1"
ASM_DIR="AVIS/VERSION 2/ASM/FIRE-GEM"
OUT_DIR="$ASM_DIR/OUT"

mkdir -p "$OUT_DIR"

BASE=$(basename "$ASM_FILE" .asm)
OBJ="$OUT_DIR/$BASE.o"
BIN="$OUT_DIR/$BASE.bin"

echo "[AVIS_V2] FIRE-GEM: Processing ASM Drop"
echo "[AVIS_V2] FILE: $ASM_FILE"

echo "[AVIS_V2] ASSEMBLING → $OBJ"
nasm -f elf64 "$ASM_FILE" -o "$OBJ"

echo "[AVIS_V2] LINKING → $BIN"
ld "$OBJ" -o "$BIN"
chmod +x "$BIN"

echo "[AVIS_V2] EXECUTING → $BIN"
"$BIN"

echo "[AVIS_V2] DROP COMPLETE"
