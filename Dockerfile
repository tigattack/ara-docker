FROM python:3.14-alpine AS builder

ENV PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

RUN --mount=type=cache,target=/var/cache/apk,sharing=locked \
    apk add libpq-dev mariadb-dev gcc musl-dev && \
    python -m venv /opt/venv

ENV PATH="/opt/venv/bin:$PATH"

RUN --mount=type=bind,source=requirements.txt,target=requirements.txt \
    pip install -r requirements.txt && \
    pip uninstall -y pip setuptools

FROM python:3.14-alpine

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PATH="/opt/venv/bin:$PATH" \
    ARA_BASE_DIR=/opt/ara

COPY entrypoint.sh /entrypoint.sh

RUN --mount=type=cache,target=/var/cache/apk,sharing=locked \
    apk add libpq mariadb-connector-c tini && \
    chmod +x /entrypoint.sh

COPY --from=builder /opt/venv /opt/venv

EXPOSE 8000
VOLUME ["/opt/ara"]

ENTRYPOINT ["/sbin/tini", "--", "/entrypoint.sh"]
