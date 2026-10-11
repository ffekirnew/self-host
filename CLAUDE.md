# self-host

Home server stack run with Docker Compose. Each service has its own folder with a `Dockerfile` (and usually a `setup.sh` that creates its host directories under `~/home-server/`). Services are exposed through a Cloudflare tunnel (`cloudflared`).

## Prerequisites

- `docker` with the Compose v2 plugin (`docker compose`, not `docker-compose`)
- `make`
- `bash` (for the `setup.sh` scripts)
- `.env` in the repo root with `CLOUDFLARE_TUNNEL_TOKEN` (gitignored)

## First-time setup

1. Create the external Docker network the stack attaches to. `docker-compose.yaml` declares `proxy` as `external: true`, so Compose fails with `network proxy declared as external, but could not be found` until it exists. `make check` (run automatically by `make up`) creates it; manually:

   ```sh
   docker network create proxy
   ```

2. Create host directories: run `./setup.sh` and each `<service>/setup.sh`.

## Commands

- `make check`: verify prerequisites and `.env`, create the `proxy` network if missing
- `make up`: run `check`, then build if needed and start all services (`docker compose up -d`)
- `make down`: stop services
- `make build`: rebuild images
- `make logs`: follow logs
- `make clean`: stop, **delete volumes**, and remove `jellyfin/data`

## Notes

- `nextcloud/` has its own `docker-compose.yaml` and isn't part of the root stack, so `make up` doesn't start it.
