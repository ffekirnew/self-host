#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/../.."

# also covers adventurelog-db's data dir
mkdir -p ~/home-server/adventurelog/{postgres,media}

# generate secrets once; never echo them
touch .env
for var in ADVENTURELOG_SECRET_KEY ADVENTURELOG_DB_PASSWORD ADVENTURELOG_ADMIN_PASSWORD; do
  if ! grep -q "^${var}=." .env; then
    sed -i "/^${var}=\$/d" .env
    echo "${var}=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 64)" >> .env
    echo "generated ${var} in .env"
  fi
done
