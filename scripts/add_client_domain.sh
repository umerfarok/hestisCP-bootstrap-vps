#!/usr/bin/env bash

set -euo pipefail

export PATH=$PATH:/usr/local/hestia/bin

# Check if HestiaCP is installed
if [ ! -f "/usr/local/hestia/bin/v-add-user" ]; then
  echo "Error: HestiaCP is not installed"
  echo "Please run bootstrap/02-install-hestia.sh first"
  exit 1
fi

# Ensure HestiaCP binaries are in PATH
export PATH="/usr/local/hestia/bin:$PATH"

if [ $# -lt 2 ]; then
  echo "Usage: $0 domain.com client_username"
  exit 1
fi

DOMAIN="$1"
CLIENT="$2"

echo "=== Adding client domain: $DOMAIN for user: $CLIENT ==="

# Create user if not exists
if ! id "$CLIENT" >/dev/null 2>&1; then
  if ! command -v openssl &> /dev/null; then
    echo "Error: openssl not found. Installing..."
    apt-get update && apt-get install -y openssl || {
      echo "Error: Cannot install openssl. Please install manually: apt install openssl"
      exit 1
    }
  fi
  PASSWORD=$(openssl rand -base64 12)
  CONTACT_EMAIL="admin@archonsys.io"

  echo "-> Creating Hestia user: $CLIENT"
  v-add-user "$CLIENT" "$CONTACT_EMAIL" "$PASSWORD" "ARCHON_BASIC" "Client User" || {
    echo "Failed to create user $CLIENT"
    exit 1
  }

  echo "User created:"
  echo "  Username: $CLIENT"
  echo "  Password: $PASSWORD"
fi

echo "-> Adding web domain"
v-add-domain "$CLIENT" "$DOMAIN" || true

echo "-> Adding mail domain"
v-add-mail-domain "$CLIENT" "$DOMAIN" || true

echo "-> Enabling DKIM"
v-add-mail-domain-dkim "$CLIENT" "$DOMAIN" || true

echo "-> Fetching DKIM value"
DKIM_LINE=$(v-list-mail-domain-dkim "$CLIENT" "$DOMAIN" plain 2>/dev/null | awk '/TXT/ {for (i=5; i<=NF; i++) printf $i " "; print ""}' || echo "")

echo
echo "=== DNS records to configure for $DOMAIN (Cloudflare / Hetzner DNS) ==="
echo "A      @                   [SERVER_IP]"
echo "A      www                 [SERVER_IP]"
echo "MX     @                   $DOMAIN.   (priority 10)"
echo "TXT    @                   \"v=spf1 mx ~all\""
echo "TXT    default._domainkey  \"$DKIM_LINE\""
echo "TXT    _dmarc              \"v=DMARC1; p=quarantine; rua=mailto:dmarc@$DOMAIN; fo=1\""
echo
echo "Replace [SERVER_IP] with: 5.78.86.122"
echo ""
echo "After DNS propagates (5-30 minutes), enable SSL in HestiaCP:"
echo "  Web → $DOMAIN → Edit → Enable SSL & Let's Encrypt → Save"
echo ""
echo "FTP Credentials for $CLIENT:"
echo "  Server: $DOMAIN (or 5.78.86.122)"
echo "  Username: $CLIENT"
echo "  Password: (check HestiaCP panel: User → $CLIENT → Change Password)"

