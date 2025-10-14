# ARA Docker

Docker image for [ARA Records Ansible](https://ara.recordsansible.org/).

Alpine-based, small size (~120MB), with added support for PostgreSQL and MySQL/MariaDB.

Supported architectures:

- `linux/amd64`
- `linux/arm64`
- `linux/arm/v7`

## Run

```bash
docker run \
  -p 8000:8000 \
  -v ara-data:/opt/ara \
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

- `ARA_BASE_DIR` - Data directory, defaults to `/opt/ara`

For more, see the [official documentation](https://ara.readthedocs.io/en/latest/api-configuration.html).

## What's Inside

- Python 3.14 Alpine
- ARA with server components
- Gunicorn WSGI server
- SQLite, PostgreSQL, and MySQL/MariaDB support
