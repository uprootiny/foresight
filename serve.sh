#!/usr/bin/env bash
# foresight/serve.sh — Start the compendium server
# Usage: ./serve.sh [port]
set -euo pipefail

PORT="${1:-8888}"
DIR="$(cd "$(dirname "$0")" && pwd)"

# Kill any existing foresight server on this port
existing=$(lsof -ti :"$PORT" 2>/dev/null || true)
if [ -n "$existing" ]; then
  echo "Stopping existing process on :$PORT (PID $existing)"
  kill "$existing" 2>/dev/null || true
  sleep 1
fi

echo "Serving foresight at http://0.0.0.0:$PORT/index.html"
cd "$DIR"
exec python3 -m http.server "$PORT" --bind 0.0.0.0
