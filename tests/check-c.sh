#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 || ! -f "$1" ]]; then
    echo "Usage: $0 source.c"
    exit 2
fi

SOURCE="$(realpath "$1")"
OUTPUT="$(mktemp /tmp/nodepoint-test.XXXXXX)"
trap 'rm -f "$OUTPUT"' EXIT

echo "Compiling: $SOURCE"

if gcc -std=c11 -Wall -Wextra -Werror "$SOURCE" -o "$OUTPUT"; then
    echo "Compilation successful."
    echo "Program output:"
    "$OUTPUT"
else
    echo "Compilation failed. Fix the code and try again."
    exit 1
fi
