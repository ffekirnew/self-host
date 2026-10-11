# Backups (plan, not implemented yet)

Nothing backs up `~/home-server` yet. This is the plan for when we get to it.

## What to back up

Sizes as of 2026-10-11.

| What | Size | Back up? |
| --- | --- | --- |
| `.config/*` (Sonarr, Radarr, Lidarr, Prowlarr, Bazarr, Seerr, qbittorrent) | 40 MB | Yes. All the app setup lives here. |
| `jellyfin/srv/jellyfin/config` | ~200 MB without `metadata/` | Yes. Exclude `metadata/` (882 MB) and `jellyfin/srv/jellyfin/cache`; Jellyfin re-downloads both. |
| `navidrome/data` | 140 MB | Yes. Play counts, playlists and users. |
| `.env` (repo root) | tiny | Yes. The restic repo is encrypted. |
| This repo | none | No, it's on GitHub. |
| `gluetun/`, `data/torrents` | none | No, both are disposable. |
| `data/media` | 245 GB | Undecided (see below). |

That makes about 400 MB of state.

## Approach

- **Tool: restic.** Encrypted, deduplicated snapshots, with built-in retention. It works the same with a local drive or B2.
- **Destinations:**
  - The external drive, for quick restores.
  - Backblaze B2, off-site. 400 MB fits in the free 10 GB.
- **Schedule:** nightly at 04:00 using a systemd timer. Retention: `--keep-daily 7 --keep-weekly 4 --keep-monthly 6`.
- **Consistency:** the apps use SQLite, and copying a database mid-write can give a corrupt backup. The script runs `docker compose stop`, then the backup (about 30 s), then `docker compose start`.
- **In the repo:**
  - a `backup/` folder holding the script and the systemd unit and timer
  - `make backup` and `make restore` targets
  - `RESTIC_PASSWORD` (plus the B2 keys) in `.env` and `.env.example`

  Keep a copy of the restic password outside the server. Without it, the backups can't be decrypted.

## Open decisions

1. **Media (245 GB).**
   - It fits on the external drive (250 GB free), but with no room to grow.
   - Off-site on B2 it costs about $1.50 a month, and the first upload is slow.
   - Leaning towards state only. Radarr and Sonarr keep the list of titles, so the library can be rebuilt by re-searching.
2. **Mounting the external drive.** It's exFAT and auto-mounted under `/run/media/...` only while logged into the desktop, so a 04:00 job would miss it. Add an `/etc/fstab` entry (needs sudo) that mounts it at a fixed path such as `/mnt/backup` with `nofail`.
3. **B2.** Create a bucket and an application key scoped to that bucket.
4. **Restore test.** After the first run, restore into a temp directory and check that an arr app starts from it.
