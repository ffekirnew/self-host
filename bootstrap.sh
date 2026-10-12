#!/bin/bash
# Check prerequisites, create the shared docker network, then bootstrap each service.
set -euo pipefail
cd "$(dirname "$0")"

missing=0
for cmd in docker make bash; do
  command -v "$cmd" >/dev/null || { echo "missing: $cmd"; missing=1; }
done
docker compose version >/dev/null 2>&1 || { echo "missing: docker compose v2 plugin"; missing=1; }
[ "$missing" -eq 0 ] || exit 1

# the compose files attach every service to this external network
docker network inspect proxy >/dev/null 2>&1 || { echo "creating docker network: proxy"; docker network create proxy >/dev/null; }

# cloudflared/bootstrap.sh at the root, everything else under <group>/<service>/
for script in */bootstrap.sh */*/bootstrap.sh; do
  echo "bootstrapping $(dirname "$script")"
  bash "$script"
done
