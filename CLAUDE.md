# self-host

Home server stack run with Docker Compose. Each service has its own folder with a `Dockerfile` and a `bootstrap.sh`. Services are exposed through a Cloudflare tunnel (`cloudflared`).

## Prerequisites

- `docker` with the Compose v2 plugin (`docker compose`, not `docker-compose`)
- `make`
- `bash` (for the `bootstrap.sh` scripts)
- `.env` in the repo root with `CLOUDFLARE_TUNNEL_TOKEN`, `NORDVPN_USER`, `NORDVPN_PASSWORD` (gitignored; never print it)

## Bootstrap

- `./bootstrap.sh` (root) checks the CLI prerequisites, creates the external `proxy` Docker network (`docker-compose.yaml` declares it `external: true`, so Compose fails with `network proxy declared as external, but could not be found` without it), then runs every `*/bootstrap.sh`.
- `<service>/bootstrap.sh` creates the host directories that service mounts in `docker-compose.yaml` and checks anything else it needs (e.g. `cloudflared` checks `.env`). When adding or changing a service's volumes, update its `bootstrap.sh` to match. Every service folder has one, even if it does nothing.
- Scripts must be idempotent; `make up` runs bootstrap every time.

## Adding or removing services

- Run `make down` **before** adding a service to or removing one from `docker-compose.yaml`. If you remove a service from the file while it is still running, Compose no longer manages it, and its container is left behind as an orphan. Make the change, then run `make up`.

## Networking

- Services reach each other by container name on the `proxy` network. cloudflared routes public traffic by name, so services don't need host `ports:`. Don't add them unless something on the host needs one, and bind it to `127.0.0.1`.
- `qbittorrent` uses `network_mode: service:gluetun` (NordVPN kill switch). Its ports are published on the `gluetun` service, and other containers reach it at `gluetun:9090`.
- Media pipeline: Seerr → Sonarr/Radarr/Lidarr → qbittorrent (`gluetun:9090`) → `data/torrents/<category>` → hardlinked into `data/media` → Jellyfin/Navidrome. Prowlarr pushes indexers to the arrs; indexers behind Cloudflare need the `flaresolverr` tag.
- Anything that touches downloads *and* the library mounts `~/home-server/data:/data` (one mount, so hardlinks work). Don't split it into separate downloads/media mounts.
- linuxserver images run with `PUID=1000`/`PGID=1000` so files on the host are owned by the user.
- If gluetun can't connect (TLS handshake timeouts, connection resets), suspect a stale server list before blaming the network. Delete `~/home-server/gluetun/servers.json` and re-run `make up` to fetch a fresh one.

## Commands

- `make bootstrap`: run `./bootstrap.sh`
- `make up`: run `bootstrap`, then build if needed and start all services (`docker compose up -d`)
- `make down`: stop services
- `make build`: rebuild images
- `make logs`: follow logs
- `make clean`: stop, **delete volumes**, and remove `jellyfin/data`
