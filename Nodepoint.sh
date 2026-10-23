#!/usr/bin/env bash
set -euo pipefail

USB_DIR="$(cd -- "$(dirname -- "$(readlink -f -- "$0")")" && pwd)"

export OLLAMA_MODELS="$USB_DIR/models"
export OLLAMA_HOST="127.0.0.1:11435"
export OLLAMA_NO_CLOUD=1

OLLAMA="$USB_DIR/runtime/bin/ollama"
MODEL="qwen2.5-coder:0.5b"

mkdir -p "$USB_DIR/models" "$USB_DIR/logs" "$USB_DIR/run"

if ! "$OLLAMA" list >/dev/null 2>&1; then
    echo "Starting Nodepoint's USB server..."

    nohup "$OLLAMA" serve >"$USB_DIR/logs/ollama.log" 2>&1 &
    echo $! > "$USB_DIR/run/ollama.pid"

    READY=0
    for i in {1..30}; do
        if "$OLLAMA" list >/dev/null 2>&1; then
            READY=1
            break
        fi
        sleep 1
    done

    if [[ "$READY" -ne 1 ]]; then
        echo "ERROR: Nodepoint server did not start."
        echo "Check: $USB_DIR/logs/ollama.log"
        exit 1
    fi
fi

if ! "$OLLAMA" list | awk 'NR > 1 {print $1}' | grep -Fxq "$MODEL"; then
    echo "ERROR: $MODEL is not available on Nodepoint's USB server."
    echo "Check the model files in: $OLLAMA_MODELS"
    exit 1
fi

echo "Starting Nodepoint with $MODEL"
exec "$OLLAMA" run "$MODEL"
