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
    GUNICORN_CMD_ARGS="--bind 0.0.0.0:8000 --workers=4 --log-level info --access-logfile -"

COPY entrypoint.sh /entrypoint.sh

RUN --mount=type=cache,target=/var/cache/apk,sharing=locked \
    apk add libpq mariadb-connector-c tini && \
    chmod +x /entrypoint.sh

COPY --from=builder /opt/venv /opt/venv

EXPOSE 8000
VOLUME ["/opt/ara"]

HEALTHCHECK \
    --interval=30s --timeout=10s --start-period=10s \
    CMD nc -z 127.0.0.1 8000 || exit 1

ENTRYPOINT ["/sbin/tini", "--", "/entrypoint.sh"]
