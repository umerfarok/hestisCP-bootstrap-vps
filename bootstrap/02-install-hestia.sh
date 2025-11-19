#!/usr/bin/env bash

set -euo pipefail

echo "=== Installing HestiaCP ==="

# Ensure we're in /root directory
cd /root || {
  echo "Error: Cannot access /root directory"
  exit 1
}

wget https://raw.githubusercontent.com/hestiacp/hestiacp/release/install/hst-install.sh -O hst-install.sh || {
  echo "Error: Failed to download HestiaCP installer"
  exit 1
}
chmod +x hst-install.sh

bash hst-install.sh \
  --apache no \
  --phpfpm yes \
  --multiphp no \
  --mysql yes \
  --postgresql no \
  --exim yes \
  --dovecot yes \
  --clamav yes \
  --spamassassin yes \
  --iptables yes \
  --fail2ban yes \
  --quota yes \
  --interactive no \
  --force

echo "=== HestiaCP installation completed ==="
echo "Check the installer output for the admin URL, username, and password."

