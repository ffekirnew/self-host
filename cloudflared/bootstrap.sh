#!/bin/bash
set -euo pipefail

# the tunnel token is read from the repo-root .env by docker compose
env_file="$(dirname "$0")/../.env"
[ -f "$env_file" ] || { echo "missing: .env (needs CLOUDFLARE_TUNNEL_TOKEN)"; exit 1; }
grep -q '^CLOUDFLARE_TUNNEL_TOKEN=.' "$env_file" || { echo "missing: CLOUDFLARE_TUNNEL_TOKEN in .env"; exit 1; }
