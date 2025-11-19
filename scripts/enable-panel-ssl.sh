#!/usr/bin/env bash

set -euo pipefail

export PATH=$PATH:/usr/local/hestia/bin

# Check if HestiaCP is installed
if ! command -v v-add-letsencrypt-host &> /dev/null; then
  echo "Error: HestiaCP is not installed or not in PATH"
  echo "Please run bootstrap/02-install-hestia.sh first"
  exit 1
fi

if [ $# -lt 1 ]; then
  echo "Usage: $0 server-domain.com"
  echo "Example: $0 cpanel.archonsys.io"
  echo ""
  echo "This enables SSL for the HestiaCP panel domain."
  exit 1
fi

DOMAIN="$1"
SERVER_IP="5.78.86.122"

echo "=== Enabling SSL for HestiaCP panel: $DOMAIN ==="
echo ""

echo "-> Checking DNS propagation..."
if ! command -v dig &> /dev/null; then
  echo "Warning: dig command not found. Installing dnsutils..."
  apt-get update && apt-get install -y dnsutils || {
    echo "Error: Cannot install dnsutils. Please install manually: apt install dnsutils"
    exit 1
  }
fi
RESOLVED_IP=$(dig +short "$DOMAIN" 2>/dev/null | tail -n1)

if [ "$RESOLVED_IP" != "$SERVER_IP" ]; then
  echo "⚠ Warning: DNS may not be ready yet"
  echo "   Resolved IP: $RESOLVED_IP"
  echo "   Expected IP: $SERVER_IP"
  echo ""
  if [ -t 0 ]; then
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      echo "Aborted. Please wait for DNS propagation."
      exit 1
    fi
  else
    echo "Running in non-interactive mode. Continuing..."
  fi
else
  echo "✓ DNS is pointing to $SERVER_IP"
fi

echo ""
echo "-> Enabling SSL for HestiaCP panel..."
v-add-letsencrypt-host || {
  echo ""
  echo "⚠ SSL setup failed. Possible reasons:"
  echo "   - DNS not fully propagated"
  echo "   - Port 80 not accessible"
  echo "   - Domain not added to HestiaCP"
  echo ""
  echo "You can try again later or enable SSL manually in HestiaCP panel."
  exit 1
}

echo ""
echo "✓ SSL certificate installed successfully!"
echo ""
echo "You can now access HestiaCP at: https://$DOMAIN:8083"
echo ""

