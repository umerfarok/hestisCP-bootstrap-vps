#!/usr/bin/env bash

set -euo pipefail

export PATH=$PATH:/usr/local/hestia/bin

# Check if HestiaCP is installed
if ! command -v v-add-domain &> /dev/null; then
  echo "Error: HestiaCP is not installed or not in PATH"
  echo "Please run bootstrap/02-install-hestia.sh first"
  exit 1
fi

if [ $# -lt 1 ]; then
  echo "Usage: $0 server-domain.com [--auto-ssl]"
  echo "Example: $0 cpanel.archonsys.io --auto-ssl"
  echo ""
  echo "This sets up a domain for the HestiaCP panel itself (not a client domain)."
  echo "Before running:"
  echo "  1. Point the domain's A record to your VPS IP (5.78.86.122)"
  echo "  2. Wait for DNS propagation (5-30 minutes)"
  echo ""
  echo "Options:"
  echo "  --auto-ssl    Automatically enable SSL after DNS check (requires DNS to be ready)"
  exit 1
fi

DOMAIN="$1"
AUTO_SSL=false
ADMIN_USER="admin"
SERVER_IP="5.78.86.122"

if [ "$#" -eq 2 ] && [ "$2" == "--auto-ssl" ]; then
  AUTO_SSL=true
fi

echo "=== Setting up server domain: $DOMAIN ==="
echo ""
echo "This will configure $DOMAIN for the HestiaCP control panel."
echo "Make sure DNS A record points to $SERVER_IP first!"
echo ""

if [ "$AUTO_SSL" = false ]; then
  if [ -t 0 ]; then
    read -p "Press Enter to continue or Ctrl+C to cancel..."
  else
    echo "Running in non-interactive mode, continuing..."
  fi
fi

echo "-> Adding web domain for admin"
v-add-domain "$ADMIN_USER" "$DOMAIN" || {
  echo "Warning: Domain may already exist, continuing..."
}

echo "-> Setting server hostname"
v-change-sys-hostname "$DOMAIN" || true

if [ "$AUTO_SSL" = true ]; then
  echo ""
  echo "-> Checking DNS propagation..."
  
  # Check if domain resolves to server IP
  if ! command -v dig &> /dev/null; then
    echo "Warning: dig command not found. Installing dnsutils..."
    apt-get update && apt-get install -y dnsutils || {
      echo "Error: Cannot install dnsutils. Please install manually: apt install dnsutils"
      exit 1
    }
  fi
  RESOLVED_IP=$(dig +short "$DOMAIN" 2>/dev/null | tail -n1)
  
  if [ "$RESOLVED_IP" = "$SERVER_IP" ]; then
    echo "✓ DNS is pointing to $SERVER_IP"
    echo ""
    echo "-> Enabling SSL for HestiaCP panel..."
    v-add-letsencrypt-host || {
      echo "Warning: SSL setup may have failed. You can enable it manually later."
    }
    echo ""
    echo "✓ SSL setup initiated"
    echo ""
    echo "You can now access HestiaCP at: https://$DOMAIN:8083"
  else
    echo "⚠ DNS not ready yet (resolved to: $RESOLVED_IP, expected: $SERVER_IP)"
    echo ""
    echo "Please wait for DNS propagation, then run:"
    echo "  ./scripts/enable-panel-ssl.sh $DOMAIN"
  fi
else
  echo ""
  echo "=== Next Steps ==="
  echo ""
  echo "1. Wait for DNS to propagate (check with: dig $DOMAIN)"
  echo ""
  echo "2. Enable SSL automatically by running:"
  echo "   ./scripts/enable-panel-ssl.sh $DOMAIN"
  echo ""
  echo "   OR manually in HestiaCP panel:"
  echo "   - Go to: Web → $DOMAIN → Edit"
  echo "   - Enable 'SSL Support' and 'Let's Encrypt support'"
  echo "   - Save"
  echo ""
  echo "3. After SSL is issued, access HestiaCP at:"
  echo "   https://$DOMAIN:8083"
fi

echo ""
echo "=== Setup complete ==="

