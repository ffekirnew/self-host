# self-host.

Home server stack run with Docker Compose, exposed through a Cloudflare tunnel.

## Prerequisites

- `docker` with the Compose v2 plugin (`docker compose`)
- `make`
- `bash`
- `.env` in the repo root containing `CLOUDFLARE_TUNNEL_TOKEN=<token>`

## Usage

```sh
./setup.sh                                # create host directories
for s in */setup.sh; do bash "$s"; done   # per-service directories
make up                                   # checks prerequisites, then starts everything
```

`make check` checks that the prerequisites above are in place and creates the `proxy` Docker network if it doesn't exist yet. `make up` runs it automatically.
