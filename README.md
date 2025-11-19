# HestiaCP Bootstrap for Hetzner VPS

Minimal infrastructure repository for setting up a Hetzner VPS with HestiaCP for multi-client website and email hosting.

## Features

- ✅ Multi-client website hosting via HestiaCP
- ✅ Multi-domain email hosting (per-domain mailboxes)
- ✅ SSL automation (Let's Encrypt via Hestia)
- ✅ DNS configuration support (SPF, DKIM, DMARC)
- ✅ Basic server hardening
- ✅ Backup configuration (local Hestia backups)

## Prerequisites

- Fresh Ubuntu 22.04 server on Hetzner VPS
- Root SSH access (preferably key-based authentication)
- Domain names pointing to your VPS IP (for DNS configuration)

## Quick Start

### 1. Initial Server Access

SSH into your Hetzner VPS as root:

```bash
ssh root@your-server-ip
```

### 2. Clone This Repository

```bash
cd /opt
git clone <your-repo-url> archon-vps-hetzner
cd archon-vps-hetzner
```

Or if you're uploading manually:

```bash
mkdir -p /opt/archon-vps-hetzner
# Upload all files to /opt/archon-vps-hetzner
cd /opt/archon-vps-hetzner
```

### 3. Make Scripts Executable

```bash
chmod +x bootstrap/*.sh scripts/*.sh
```

### 4. Run Bootstrap Scripts (in order)

**Step 1: Base System Setup**
```bash
./bootstrap/01-system-setup.sh
```

This will:
- Update and upgrade system packages
- Install basic tools (sudo, curl, wget, git, ufw, htop, jq)
- Configure basic SSH hardening
- Set up firewall (ports 22, 80, 443, 8083)

**Step 2: Install HestiaCP**
```bash
./bootstrap/02-install-hestia.sh
```

This will install HestiaCP with:
- Nginx + PHP-FPM
- MariaDB
- Exim + Dovecot + SpamAssassin + ClamAV
- Fail2ban
- Quotas

⚠️ **Important**: This step takes 10-20 minutes. The installer will output:
- Admin panel URL (usually `https://your-server-ip:8083`)
- Admin username (usually `admin`)
- Admin password (save this!)

**Step 3: Post-Install Configuration**
```bash
./bootstrap/03-post-hestia-setup.sh
```

This will:
- Create default hosting package `ARCHON_BASIC`
- Enable daily backups for admin user

### 5. Access HestiaCP Panel

1. Open your browser and go to: `https://your-server-ip:8083`
2. Log in with the credentials from Step 2
3. Accept the self-signed certificate warning (first time only)

## Manual Steps After Installation

### 1. Change Admin Password

In HestiaCP panel:
- Go to **User** → **admin** → **Change Password**
- Set a strong password

### 2. Configure Server Hostname

In HestiaCP panel:
- Go to **Server** → **Configure**
- Set hostname (e.g., `server.yourdomain.com`)

### 3. Set Up DNS for Your Server Domain

If you want to access HestiaCP via a domain name:
- Point your domain's A record to the server IP
- In HestiaCP: **Server** → **Configure** → set hostname to your domain

## Adding Client Domains

Use the helper script to add new client domains:

```bash
cd /opt/archon-vps-hetzner
./scripts/add_client_domain.sh example.com clientuser
```

This will:
- Create HestiaCP user (if not exists)
- Add web domain
- Add mail domain
- Enable DKIM
- Print DNS records you need to configure

**Then configure DNS** in your DNS provider (Cloudflare/Hetzner DNS):
- Copy the DNS records from the script output
- Replace `[SERVER_IP]` with your actual VPS IP
- Add all records (A, MX, SPF, DKIM, DMARC)

**After DNS propagates** (usually 5-30 minutes):
- Log into HestiaCP
- Go to **Web** → edit the domain
- Enable **SSL Support** and **Let's Encrypt support**
- Save

See [docs/how-to-add-domain.md](docs/how-to-add-domain.md) for detailed instructions.

## Creating Email Accounts

1. Log into HestiaCP
2. Go to **Mail**
3. Select the domain
4. Click **Add Account**
5. Enter mailbox name and password
6. Save

See [docs/how-to-create-email.md](docs/how-to-create-email.md) for IMAP/SMTP settings.

## SSL Certificates

HestiaCP automatically manages Let's Encrypt SSL certificates:
- Enable SSL in domain settings
- Certificates auto-renew

See [docs/how-ssl-works.md](docs/how-ssl-works.md) for details.

## Backup Configuration

Daily backups are enabled for the admin user. To configure backups for other users:
- In HestiaCP: **User** → select user → **Backups** → enable

## Troubleshooting

### Can't access HestiaCP panel?

- Check firewall: `ufw status`
- Verify port 8083 is open: `ufw allow 8083/tcp`
- Check if HestiaCP is running: `systemctl status hestia`

### DNS not working?

- Verify DNS records are correct
- Check DNS propagation: `dig example.com`
- Wait 5-30 minutes for DNS to propagate

### SSL certificate not issuing?

- Ensure domain A record points to server IP
- Verify port 80 is open (required for Let's Encrypt validation)
- Check DNS propagation is complete

## Repository Structure

```
.
├── bootstrap/
│   ├── 01-system-setup.sh      # Base system setup
│   ├── 02-install-hestia.sh    # HestiaCP installation
│   └── 03-post-hestia-setup.sh # Post-install configuration
├── scripts/
│   └── add_client_domain.sh    # Helper to add client domains
├── docs/
│   ├── how-to-add-domain.md    # Domain setup guide
│   ├── how-to-create-email.md  # Email account guide
│   └── how-ssl-works.md        # SSL automation guide
└── README.md                    # This file
```

## Support

For HestiaCP documentation: https://docs.hestiacp.com/
