#!/usr/bin/env bash
# foresight/healthlog.sh — Cron-friendly health check with logging
# Appends status to logs/health.log, emits to stderr on failure
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
LOG_DIR="$DIR/logs"
LOG_FILE="$LOG_DIR/health.log"
PORT="${1:-8888}"

mkdir -p "$LOG_DIR"

ts=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
status=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 "http://localhost:$PORT/index.html" 2>/dev/null || echo "000")

if [ "$status" = "200" ]; then
  size=$(curl -s --max-time 5 "http://localhost:$PORT/index.html" 2>/dev/null | wc -c)
  echo "$ts OK port=$PORT status=$status size=${size}B" >> "$LOG_FILE"
else
  echo "$ts FAIL port=$PORT status=$status" >> "$LOG_FILE"
  echo "FORESIGHT HEALTH FAIL at $ts: port=$PORT status=$status" >&2
fi

# Keep log to last 1000 lines
if [ -f "$LOG_FILE" ] && [ "$(wc -l < "$LOG_FILE")" -gt 1000 ]; then
  tail -500 "$LOG_FILE" > "$LOG_FILE.tmp" && mv "$LOG_FILE.tmp" "$LOG_FILE"
fi
