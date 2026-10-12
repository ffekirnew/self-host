#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."

mkdir -p ~/home-server/.config/open-webui

# generate the session secret once; never echo it
touch .env
if ! grep -q "^WEBUI_SECRET_KEY=." .env; then
  sed -i "/^WEBUI_SECRET_KEY=\$/d" .env
  echo "WEBUI_SECRET_KEY=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 64)" >> .env
  echo "generated WEBUI_SECRET_KEY in .env"
fi
