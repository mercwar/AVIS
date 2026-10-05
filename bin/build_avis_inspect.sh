#!/bin/sh
set -eu

CC="${CC:-cc}"
CFLAGS="${CFLAGS:--std=c11 -Wall -Wextra -O2}"
OUTPUT="${OUTPUT:-avis_inspect}"

"$CC" $CFLAGS avis_inspect.c -o "$OUTPUT"

echo "Built ./$OUTPUT"
