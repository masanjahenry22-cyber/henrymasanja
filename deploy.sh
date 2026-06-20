#!/usr/bin/env bash
#
# deploy.sh — run this ON your Oracle Cloud VM to publish the latest version.
# It pulls the newest code from GitHub and serves it. No build step needed.
#
# One-time setup on the server (see README.md), then to publish updates:
#   1) On your PC:   git add -A && git commit -m "update" && git push
#   2) On the VM:    ./deploy.sh        (or: ssh in and run it)
#
set -euo pipefail

SITE_DIR="/var/www/henry"

echo "==> Pulling latest from GitHub..."
cd "$SITE_DIR"
sudo git pull --ff-only

echo "==> Reloading Caddy..."
sudo systemctl reload caddy

echo "==> Done. Live at https://henrymashenmasanja.com"
