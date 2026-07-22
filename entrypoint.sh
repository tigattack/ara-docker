#!/bin/sh

set -e

if [ "$ARA_MODE" = "server" ]; then
    echo "Running in API server mode"
    echo "Running migrations"
    ara-manage migrate
    echo "Starting Gunicorn"
    exec python3 -m gunicorn ara.server.wsgi

elif [ "$ARA_MODE" = "prometheus" ]; then
    export ARA_API_CLIENT=${ARA_API_CLIENT:-http}
    export ARA_API_SERVER=${ARA_API_SERVER:-http://server:8000}

    echo "Running in Prometheus exporter mode"
    exec ara prometheus "$@"

else
    echo "Unknown ARA_MODE: $ARA_MODE"
    exit 1
fi
