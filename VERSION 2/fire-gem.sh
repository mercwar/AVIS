#!/usr/bin/env bash
# AVIS-ARTIFACT
# FILE: AVIS/VERSION 2/fire-gem.sh
# PURPOSE: Execute FIRE-GEM V2 ASM drops
# AUTHOR: Demon

set -e

ASM_FILE="$1"

echo "[AVIS] FIRE-GEM V2: Processing ASM Drop"
echo "[AVIS] FILE: $ASM_FILE"

OUT_DIR="AVIS/VERSION 2/ASM/FIRE-GEM/OUT"
mkdir -p "$OUT_DIR"

BASE=$(basename "$ASM_FILE" .asm)

OBJ="$OUT_DIR/$BASE.o"
BIN="$OUT_DIR/$BASE.exe"

echo "[AVIS] ASSEMBLING → $OBJ"
as "$ASM_FILE" -o "$OBJ"

echo "[AVIS] LINKING → $BIN"
gcc "$OBJ" -o "$BIN"

echo "[AVIS] EXECUTING → $BIN"
"$BIN"

echo "[AVIS] DROP COMPLETE"
