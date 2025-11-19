# Quick Setup Guide: cpanel.archonsys.io

This is a quick reference for setting up `cpanel.archonsys.io` with SSL for the HestiaCP panel.

## Prerequisites

- Client has pointed `cpanel.archonsys.io` A record to `5.78.86.122`
- DNS has propagated (check with: `dig cpanel.archonsys.io`)

## Setup Steps

### Step 1: SSH into Server

```bash
ssh root@5.78.86.122
cd /opt/archon-vps-hetzner
```

### Step 2: Run Setup Script

**If DNS is ready (recommended):**
```bash
./scripts/setup-server-domain.sh cpanel.archonsys.io --auto-ssl
```

This will:
- Add domain to HestiaCP
- Set server hostname
- Check DNS propagation
- Automatically enable SSL if DNS is ready

**If DNS needs time:**
```bash
./scripts/setup-server-domain.sh cpanel.archonsys.io
```

Then after DNS propagates (wait 5-30 minutes), run:
```bash
./scripts/enable-panel-ssl.sh cpanel.archonsys.io
```

### Step 3: Verify Access

After SSL is enabled, access the panel at:
- `https://cpanel.archonsys.io:8083`

## Troubleshooting

**DNS not ready?**
- Check DNS: `dig cpanel.archonsys.io`
- Should resolve to: `5.78.86.122`
- Wait 5-30 minutes for propagation

**SSL failed?**
- Ensure port 80 is open: `ufw allow 80/tcp`
- Check DNS is pointing correctly
- Try running: `./scripts/enable-panel-ssl.sh cpanel.archonsys.io`

**Still can't access?**
- Check firewall: `ufw status`
- Verify HestiaCP is running: `systemctl status hestia`
- Check panel port: `netstat -tlnp | grep 8083`

## Summary

```bash
# One command setup (if DNS ready):
./scripts/setup-server-domain.sh cpanel.archonsys.io --auto-ssl

# Or two-step setup (if DNS needs time):
./scripts/setup-server-domain.sh cpanel.archonsys.io
# Wait for DNS...
./scripts/enable-panel-ssl.sh cpanel.archonsys.io
```

Done! Access at: `https://cpanel.archonsys.io:8083`

