#!/bin/sh

set -e

if [ "$ARA_MODE" = "server" ]; then
    curl -fsS http://127.0.0.1:8000/api/v1/ >/dev/null
elif [ "$ARA_MODE" = "prometheus" ]; then
    listen_port=$(netstat -tulnp | awk '$NF ~ /python/ {print $4}' | sed 's/.*://')
    curl -fsS http://127.0.0.1:${listen_port}/metrics >/dev/null
fi
