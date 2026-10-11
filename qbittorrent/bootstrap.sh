#!/bin/bash
set -euo pipefail

mkdir -p ~/home-server/.config/qbittorrent
# downloads land in data/torrents/<category>; same filesystem as data/media so the *arrs can hardlink
mkdir -p ~/home-server/data/torrents/{tv,movies,music}
