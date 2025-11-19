#!/usr/bin/env bash

set -euo pipefail

echo "=== Archon VPS Base System Setup ==="

# Update & upgrade
apt update && apt upgrade -y

# Basic tools
apt install -y sudo curl wget git ufw htop jq

# Basic SSH hardening (assumes key-based auth is used)
SSHD_CONFIG="/etc/ssh/sshd_config"
if [ -f "$SSHD_CONFIG" ]; then
  sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' "$SSHD_CONFIG"
  # Allow root login with keys only
  sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin prohibit-password/' "$SSHD_CONFIG"
  systemctl reload sshd || true
else
  echo "Warning: SSH config not found (skipping SSH hardening - expected in Docker)"
fi

# Firewall
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 8083/tcp   # Hestia panel
ufw --force enable

echo "=== Base system setup complete ==="
echo "You can now run: ./bootstrap/02-install-hestia.sh"

