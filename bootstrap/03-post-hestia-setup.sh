#!/usr/bin/env bash

set -euo pipefail

export PATH=$PATH:/usr/local/hestia/bin

# Check if HestiaCP is installed
if [ ! -d "/usr/local/hestia/bin" ]; then
  echo "Error: HestiaCP is not installed"
  echo "Please run bootstrap/02-install-hestia.sh first"
  exit 1
fi

ADMIN_USER="admin"

echo "=== Post-Hestia Setup ==="

echo "-> Enabling daily backups for admin"
if [ -f "/usr/local/hestia/bin/v-add-user-backup" ]; then
  /usr/local/hestia/bin/v-add-user-backup "$ADMIN_USER" 2>/dev/null || {
    echo "Note: Backups may already be enabled or need manual configuration"
    echo "You can check/enable backups in HestiaCP panel: User → admin → Backups"
  }
else
  echo "Note: v-add-user-backup command not found"
  echo "You can enable backups manually in HestiaCP panel: User → admin → Backups"
fi

echo ""
echo "-> Creating hosting package: ARCHON_BASIC"

PACKAGE_DIR="/usr/local/hestia/data/packages"
PACKAGE_FILE="$PACKAGE_DIR/ARCHON_BASIC.pkg"

if [ ! -d "$PACKAGE_DIR" ]; then
  echo "Warning: Package directory not found: $PACKAGE_DIR"
  echo "Package will need to be created manually via web interface"
else
  # Create ARCHON_BASIC package file
  cat > "$PACKAGE_FILE" << 'EOF'
WEB_TEMPLATE='default'
PROXY_TEMPLATE='default'
BACKEND_TEMPLATE='default'
DNS_TEMPLATE='default'
WEB_DOMAINS='50'
WEB_ALIASES='unlimited'
DNS_DOMAINS='0'
DNS_RECORDS='unlimited'
MAIL_DOMAINS='50'
MAIL_ACCOUNTS='unlimited'
RATE_LIMIT='200'
DATABASES='50'
CRON_JOBS='unlimited'
DISK_QUOTA='0'
CPU_QUOTA='unlimited'
CPU_QUOTA_PERIOD='unlimited'
MEMORY_LIMIT='unlimited'
SWAP_LIMIT='unlimited'
BANDWIDTH='0'
NS='ns1.archonsys.io,ns2.archonsys.io'
SHELL='bash'
BACKUPS='1'
BACKUPS_INCREMENTAL='no'
TIME='18:00:00'
DATE='2025-11-19'
EOF

  if [ -f "$PACKAGE_FILE" ]; then
    echo "✓ Package ARCHON_BASIC created successfully"
    echo "  Location: $PACKAGE_FILE"
  else
    echo "Warning: Failed to create package file"
    echo "Package will need to be created manually via web interface"
  fi
fi

echo ""
echo "=== Post-Hestia setup complete ==="
echo ""
echo "Next steps:"
echo "1. Access HestiaCP panel: https://cpanel.archonsys.io:8083"
echo "2. Change admin password: User → admin → Change Password"
echo "3. Verify ARCHON_BASIC package exists: Packages → ARCHON_BASIC"


