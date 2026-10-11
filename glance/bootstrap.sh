#!/bin/bash
set -euo pipefail

# config is mounted from the repo, not created here
[ -f "$(dirname "$0")/config/glance.yml" ] || { echo "missing: glance/config/glance.yml"; exit 1; }
