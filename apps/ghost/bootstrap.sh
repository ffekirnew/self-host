#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/../.."

# also covers ghost-db's data dir
mkdir -p ~/home-server/ghost/{content,mysql}

# generate secrets once; never echo them
touch .env
for var in GHOST_DB_PASSWORD GHOST_DB_ROOT_PASSWORD; do
  if ! grep -q "^${var}=." .env; then
    sed -i "/^${var}=\$/d" .env
    echo "${var}=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 64)" >> .env
    echo "generated ${var} in .env"
  fi
done
