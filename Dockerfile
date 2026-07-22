FROM python:3.14-alpine AS builder

ENV PIP_DISABLE_PIP_VERSION_CHECK=1

RUN --mount=type=cache,target=/var/cache/apk,sharing=locked \
    apk add libpq-dev mariadb-dev gcc musl-dev && \
    python -m venv /opt/venv

ENV PATH="/opt/venv/bin:$PATH"

RUN --mount=type=bind,source=requirements.txt,target=requirements.txt \
    --mount=type=cache,target=/root/.cache/pip,sharing=locked \
    pip install -r requirements.txt && \
    pip uninstall -y pip setuptools

FROM python:3.14-alpine

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PATH="/opt/venv/bin:$PATH" \
    ARA_BASE_DIR="/opt/ara" \
    ARA_MODE="server" \
    GUNICORN_LOG_LEVEL="info" \
    GUNICORN_WORKERS=4 \
    GUNICORN_THREADS=4 \
    GUNICORN_WORKER_CLASS="gthread" \
    GUNICORN_CMD_EXTRA_ARGS=""

ENV GUNICORN_CMD_ARGS="--bind 0.0.0.0:8000 --workers=${GUNICORN_WORKERS} --threads=${GUNICORN_THREADS} --worker-class ${GUNICORN_WORKER_CLASS} --log-level '${GUNICORN_LOG_LEVEL}' --access-logfile - ${GUNICORN_CMD_EXTRA_ARGS}"

COPY --chmod=+x entrypoint.sh healthcheck.sh /

RUN --mount=type=cache,target=/var/cache/apk,sharing=locked \
    apk add curl libpq mariadb-connector-c tini && \
    chmod +x /entrypoint.sh

COPY --from=builder /opt/venv /opt/venv

EXPOSE 8000
VOLUME ["/opt/ara"]

HEALTHCHECK \
    --interval=30s --timeout=10s --start-period=10s \
    CMD sh /healthcheck.sh

ENTRYPOINT ["/sbin/tini", "--", "/entrypoint.sh"]
