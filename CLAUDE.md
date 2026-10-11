# self-host

Home server stack run with Docker Compose. Each service has its own folder with a `Dockerfile` and a `bootstrap.sh`. Services are exposed through a Cloudflare tunnel (`cloudflared`).

## Prerequisites

- `docker` with the Compose v2 plugin (`docker compose`, not `docker-compose`)
- `make`
- `bash` (for the `bootstrap.sh` scripts)
- `.env` in the repo root with `CLOUDFLARE_TUNNEL_TOKEN` (gitignored)

## Bootstrap

- `./bootstrap.sh` (root) checks the CLI prerequisites, creates the external `proxy` Docker network (`docker-compose.yaml` declares it `external: true`, so Compose fails with `network proxy declared as external, but could not be found` without it), then runs every `*/bootstrap.sh`.
- `<service>/bootstrap.sh` creates the host directories that service mounts in `docker-compose.yaml` and checks anything else it needs (e.g. `cloudflared` checks `.env`). When adding or changing a service's volumes, update its `bootstrap.sh` to match. Every service folder has one, even if it does nothing.
- Scripts must be idempotent; `make up` runs bootstrap every time.

## Adding or removing services

- Run `make down` **before** adding a service to or removing one from `docker-compose.yaml`. If you remove a service from the file while it is still running, Compose no longer manages it, and its container is left behind as an orphan. Make the change, then run `make up`.

## Commands

- `make bootstrap`: run `./bootstrap.sh`
- `make up`: run `bootstrap`, then build if needed and start all services (`docker compose up -d`)
- `make down`: stop services
- `make build`: rebuild images
- `make logs`: follow logs
- `make clean`: stop, **delete volumes**, and remove `jellyfin/data`
