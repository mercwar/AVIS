#!/bin/sh
set -eu

CC="${CC:-cc}"
CFLAGS="${CFLAGS:--std=c11 -Wall -Wextra -O2}"
OUTPUT="${OUTPUT:-avis_parse}"

"$CC" $CFLAGS avis_parse.c -o "$OUTPUT"

echo "Built ./$OUTPUT"
