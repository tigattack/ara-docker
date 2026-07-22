# ARA Docker

Docker image for [ARA Records Ansible](https://ara.recordsansible.org/), supporting operation as either the default API server w/ web UI or Prometheus exporter.

Alpine-based, small size (~120MB), with added support for PostgreSQL and MySQL/MariaDB.

Supported architectures:

- `linux/amd64`
- `linux/arm64`

## Run

### Docker Compose

You can simply download the [compose.yml](compose.yml) file and run:

```bash
# Only API server w/ web UI:
docker compose up -d
# API server and Prometheus exporter:
docker compose --profile exporter up -d
```

### Docker Run API Server

This will run the API server with built-in web UI:

```bash
docker run \
  -p 8000:8000 \
  -v ara-data:/opt/ara \
  ghcr.io/tigattack/ara:latest
```

### Docker Run Prometheus Exporter

And this will run the Prometheus exporter:

```bash
docker run \
  -p 8001:8001 \
  -e "ARA_MODE=prometheus" \
  -e "ARA_API_SERVER=http://ara.example.org" \
  ghcr.io/tigattack/ara:latest
```

## Tags

- `latest`: Latest stable version of ARA
- `x.y.z`: Specific full version of ARA (e.g. `1.2.3`)
- `x.y`: Specific minor version of ARA (e.g. `1.2`)
- `x`: Specific major version of ARA (e.g. `1`)

The version tags align with the included version of ARA. Some examples:
- `1.2.3` will always refer to `1.2.3`
- `1.2` could refer to `1.2.0`, and later `1.2.1` when a newer patch version is released.
- `1` could refer to `1.0.0`, and later `1.0.1` or `1.1.0` when newer minor/patch versions are released.


## Build

```bash
docker build -t ara .
```

Then open http://localhost:8000

## Environment Variables

### ARA Configuration

- `ARA_MODE` - The mode in which to run ARA, must be one of `server` (default) or `prometheus`.
  - For more information on the Prometheus exporter functionality: <https://ara.readthedocs.io/en/latest/prometheus.html>
- `ARA_BASE_DIR` - Data directory, defaults to `/opt/ara`
- `ARA_API_CLIENT` - Only relevant when `ARA_MODE=prometheus`. Defaults to `http`.
- `ARA_API_SERVER` - Only relevant when `ARA_MODE=prometheus`. Defaults to `http://server:8000`.
- All standard [ARA environment variables](https://ara.readthedocs.io/en/latest/api-configuration.html) are supported
  - See for Prometheus environment variables: <https://ara.readthedocs.io/en/latest/cli.html#ara-prometheus>

### Gunicorn Configuration

- `GUNICORN_LOG_LEVEL` - Gunicorn log level, defaults to `info`
- `GUNICORN_WORKERS` - Gunicorn worker count, defaults to `4`
- `GUNICORN_THREADS` - Gunicorn thread count, defaults to `4`
- `GUNICORN_WORKER_CLASS` - Gunicorn worker class, defaults to `gthread`
- `GUNICORN_CMD_EXTRA_ARGS` - Extra Gunicorn command-line arguments appended to the generated command, defaults to empty

The image builds `GUNICORN_CMD_ARGS` from the variables above. Overriding `GUNICORN_CMD_ARGS` directly is no longer recommended; use `GUNICORN_CMD_EXTRA_ARGS` for additional flags.

See [Gunicorn settings documentation](https://docs.gunicorn.org/en/stable/settings.html) for the full list of supported options.

## What's Inside

- Python 3.14 Alpine
- ARA with server components
- Gunicorn WSGI server
- SQLite, PostgreSQL, and MySQL/MariaDB support
