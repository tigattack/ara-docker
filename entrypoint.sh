#!/bin/sh

set -e

ara-manage migrate

exec python3 -m gunicorn \
  --workers=4 \
  --access-logfile - \
  --log-level "$GUNICORN_LOG_LEVEL" \
  --bind 0.0.0.0:8000 \
  ara.server.wsgi
