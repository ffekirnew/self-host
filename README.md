# self-host.

Home server stack run with Docker Compose, exposed through a Cloudflare tunnel.

## Prerequisites

- `docker` with the Compose v2 plugin (`docker compose`)
- `make`
- `bash`
- `.env` in the repo root containing `CLOUDFLARE_TUNNEL_TOKEN=<token>`

## Usage

```sh
make up   # runs ./bootstrap.sh, then starts everything
```

`./bootstrap.sh` checks the prerequisites above, creates the `proxy` Docker network if it doesn't exist yet, and runs each service's `<service>/bootstrap.sh`, which creates that service's host directories and checks its config. It's safe to re-run.
