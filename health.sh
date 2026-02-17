#!/usr/bin/env bash
# foresight/health.sh — Quick health check
# Returns 0 if serving, 1 if not
set -euo pipefail

PORT="${1:-8888}"
HOST="localhost"

status=$(curl -s -o /dev/null -w "%{http_code}" "http://$HOST:$PORT/index.html" 2>/dev/null || echo "000")

if [ "$status" = "200" ]; then
  size=$(curl -s "http://$HOST:$PORT/index.html" | wc -c)
  echo "OK port=$PORT status=$status size=${size}B"
  exit 0
else
  echo "FAIL port=$PORT status=$status"
  exit 1
fi
