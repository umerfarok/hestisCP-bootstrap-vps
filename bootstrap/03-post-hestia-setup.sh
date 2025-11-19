#!/usr/bin/env bash

set -euo pipefail

export PATH=$PATH:/usr/local/hestia/bin

ADMIN_USER="admin"

echo "=== Post-Hestia Setup ==="

echo "-> Creating default hosting package: ARCHON_BASIC"

# v-add-package user package web dns mail db shell cgi quota bw limit php
v-add-package "$ADMIN_USER" ARCHON_BASIC 50 0 50 50 yes yes 0 0 0 yes || true

echo "-> Enabling daily backups for admin"
v-add-user-backup "$ADMIN_USER" || true

echo "=== Post-Hestia setup complete ==="

