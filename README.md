# ARA Docker

Minimal Docker image for [ARA Records Ansible](https://ara.recordsansible.org/).

## Run

```bash
docker run -p 8000:8000 -v ara-data:/opt/ara ghcr.io/tigattack/ara:latest
```

## Build

```bash
docker build -t ara .
```

Then open http://localhost:8000

## Environment Variables

- `ARA_BASE_DIR` - Data directory, defaults to `/opt/ara`

For more, see the [official documentation](https://ara.readthedocs.io/en/latest/api-configuration.html).

## What's Inside

- Python 3.14 Alpine
- ARA with server components
- Gunicorn WSGI server
- SQLite, PostgreSQL, and MySQL/MariaDB support
