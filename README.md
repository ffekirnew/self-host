# self-host.

Home server stack run with Docker Compose, exposed through a Cloudflare tunnel.

## Prerequisites

- `docker` with the Compose v2 plugin (`docker compose`)
- `make`
- `bash`
- `.env` in the repo root (`cp .env.example .env` and fill in) containing:
  ```
  CLOUDFLARE_TUNNEL_TOKEN=<token>
  NORDVPN_USER=<service username>
  NORDVPN_PASSWORD=<service password>
  ```
  The NordVPN values are the *service credentials* from Nord Account → NordVPN → Manual setup, not your login.

## Usage

```sh
make up   # runs ./bootstrap.sh, then starts everything
```

`./bootstrap.sh` checks the prerequisites above, creates the `proxy` Docker network if it doesn't exist yet, and runs each service's `<service>/bootstrap.sh`, which creates that service's host directories and checks its config. It's safe to re-run.

## Access

Public services go through the Cloudflare tunnel only and publish no host ports. qbittorrent (`:9090`) and jackett (`:9117`) are bound to `127.0.0.1`. From another machine, use `ssh -L 9090:localhost:9090 -L 9117:localhost:9117 <server>`.

qbittorrent shares gluetun's network namespace, so all of its traffic goes through NordVPN. If the VPN drops, it has no network.
