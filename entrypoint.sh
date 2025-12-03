#!/bin/sh

set -e

ara-manage migrate

exec python3 -m gunicorn ara.server.wsgi
