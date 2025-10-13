#!/bin/sh

set -e

ara-manage migrate

exec python3 -m gunicorn \
  --workers=4 \
  --access-logfile - \
  --bind 0.0.0.0:8000 \
  ara.server.wsgi
