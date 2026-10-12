#!/bin/bash
set -euo pipefail

# the image runs as uid 1000, so the config dir must be owned by the host user
mkdir -p ~/home-server/.config/seerr
