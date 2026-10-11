#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."

# also covers tandoor-db's data dir
mkdir -p ~/home-server/tandoor/{postgres,mediafiles}

# generate secrets once; never echo them
touch .env
for var in TANDOOR_SECRET_KEY TANDOOR_DB_PASSWORD; do
  if ! grep -q "^${var}=." .env; then
    sed -i "/^${var}=\$/d" .env
    echo "${var}=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 64)" >> .env
    echo "generated ${var} in .env"
  fi
done
