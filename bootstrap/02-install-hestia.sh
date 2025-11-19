#!/usr/bin/env bash

set -euo pipefail

echo "=== Installing HestiaCP ==="

cd /root
wget https://raw.githubusercontent.com/hestiacp/hestiacp/release/install/hst-install.sh -O hst-install.sh
chmod +x hst-install.sh

bash hst-install.sh \
  --nginx yes \
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
  -y \
  --force

echo "=== HestiaCP installation completed ==="
echo "Check the installer output for the admin URL, username, and password."

