#!/bin/sh
set -eu

CC="${CC:-cc}"
CFLAGS="${CFLAGS:--std=c11 -Wall -Wextra -O2}"
OUTPUT="${OUTPUT:-avis-validate}"

echo "Building ${OUTPUT}..."

$CC $CFLAGS avis_validate.c -o "$OUTPUT"

echo "Build complete: ./${OUTPUT}"
