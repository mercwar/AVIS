#!/bin/sh
set -eu

CC="${CC:-cc}"
CFLAGS="${CFLAGS:--std=c11 -Wall -Wextra -O2}"
OUTPUT="${OUTPUT:-avis}"

echo "Building ${OUTPUT}..."

$CC $CFLAGS avis.c -o "$OUTPUT"

echo "Build complete: ./${OUTPUT}"
