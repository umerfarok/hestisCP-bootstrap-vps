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
echo ""
echo "NOTE: HestiaCP packages must be created via the web interface."
echo "Please create the package manually:"
echo ""
echo "1. Log into HestiaCP: https://cpanel.archonsys.io:8083"
echo "2. Go to: Packages → Add Package"
echo "3. Create package with name: ARCHON_BASIC"
echo "4. Set limits:"
echo "   - Web Domains: 50"
echo "   - DNS Zones: 0"
echo "   - Mail Domains: 50"
echo "   - Databases: 50"
echo "   - Shell Access: yes"
echo "   - CGI: yes"
echo "   - Quota: 0 (unlimited)"
echo "   - Bandwidth: 0 (unlimited)"
echo "   - PHP: yes"
echo ""
echo "=== Post-Hestia setup complete ==="
echo ""
echo "Next steps:"
echo "1. Access HestiaCP panel: https://cpanel.archonsys.io:8083"
echo "2. Create the ARCHON_BASIC package (see instructions above)"
echo "3. Change admin password: User → admin → Change Password"


