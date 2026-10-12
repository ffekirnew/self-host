#!/bin/bash
set -euo pipefail

# NordVPN service credentials (not your account login) are read from the repo-root .env by docker compose
env_file="$(dirname "$0")/../../.env"
[ -f "$env_file" ] || { echo "missing: .env (needs NORDVPN_USER, NORDVPN_PASSWORD)"; exit 1; }
for var in NORDVPN_USER NORDVPN_PASSWORD; do
  grep -q "^$var=." "$env_file" || { echo "missing: $var in .env"; exit 1; }
done

# seed a fresh NordVPN server list; the one built into the image is stale and most of its IPs no longer work
mkdir -p ~/home-server/gluetun
if [ ! -f ~/home-server/gluetun/servers.json ]; then
  echo "fetching NordVPN server list"
  docker run --rm -v ~/home-server/gluetun:/gluetun qmcgaw/gluetun:v3 update -enduser -providers nordvpn >/dev/null
fi
