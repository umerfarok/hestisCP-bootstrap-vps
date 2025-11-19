#!/usr/bin/env bash

set -euo pipefail

export PATH=$PATH:/usr/local/hestia/bin

# Check if HestiaCP is installed by checking if binary exists
if [ ! -f "/usr/local/hestia/bin/v-add-package" ]; then
  echo "Error: HestiaCP is not installed"
  echo "Please run bootstrap/02-install-hestia.sh first"
  exit 1
fi

# Verify command is accessible
if ! command -v v-add-package &> /dev/null; then
  # Try to source HestiaCP environment if it exists
  if [ -f "/usr/local/hestia/bin/v-add-package" ]; then
    export PATH="/usr/local/hestia/bin:$PATH"
  else
    echo "Error: Cannot find HestiaCP binaries"
    exit 1
  fi
fi

ADMIN_USER="admin"

echo "=== Post-Hestia Setup ==="

echo "-> Creating default hosting package: ARCHON_BASIC"

# v-add-package user package web dns mail db shell cgi quota bw limit php
v-add-package "$ADMIN_USER" ARCHON_BASIC 50 0 50 50 yes yes 0 0 0 yes || true

echo "-> Enabling daily backups for admin"
v-add-user-backup "$ADMIN_USER" || true

echo "=== Post-Hestia setup complete ==="


