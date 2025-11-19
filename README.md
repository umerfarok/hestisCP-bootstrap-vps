# HestiaCP Bootstrap for Hetzner VPS

Minimal infrastructure repository for setting up a Hetzner VPS with HestiaCP for multi-client website and email hosting.

## Features

- ✅ Multi-client website hosting via HestiaCP
- ✅ Multi-domain email hosting (per-domain mailboxes)
- ✅ SSL automation (Let's Encrypt via Hestia)
- ✅ DNS configuration support (SPF, DKIM, DMARC)
- ✅ Basic server hardening
- ✅ Backup configuration (local Hestia backups)

## Two Types of Domains

**1. Server Domain** (for HestiaCP panel SSL)
- Your own domain for accessing the control panel (e.g., `server.yourdomain.com`)
- Optional but recommended for SSL on the panel
- Set up once after VPS installation
- See "Set Up Server Domain with SSL" section below

**2. Client Domains** (for hosting websites)
- Domains your clients want to host (e.g., `client1.com`, `client2.com`)
- Each client domain gets SSL automatically
- Set up per client using `add_client_domain.sh` script

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

**Option 1: Use IP Address (Works Immediately)**
1. Open your browser and go to: `https://5.78.86.122:8083`
2. Log in with the credentials from Step 2
3. Accept the self-signed certificate warning (click "Advanced" → "Proceed")

**Option 2: Use Domain with SSL (Recommended)**
- See "Set Up Server Domain with SSL" section below
- Requires client to point a domain to `5.78.86.122` first

**Note:** You can start with Option 1 and add a domain later if needed.

## Manual Steps After Installation

### 1. Change Admin Password

In HestiaCP panel:
- Go to **User** → **admin** → **Change Password**
- Set a strong password

### 2. Set Up Server Domain with SSL (Optional but Recommended)

If you want to access HestiaCP panel via a domain with SSL (instead of just IP:8083):

**Step 1: Point domain to VPS IP**
- Choose a domain for your server (e.g., `server.yourdomain.com` or `panel.yourdomain.com`)
- In your DNS provider, add A record: `server.yourdomain.com` → `your-vps-ip`
- Wait for DNS propagation (5-30 minutes)

**Step 2: Run the server domain setup script**

**Option A: Automatic SSL (if DNS is ready):**
```bash
cd /opt/archon-vps-hetzner
./scripts/setup-server-domain.sh server.yourdomain.com --auto-ssl
```

**Option B: Manual SSL (if DNS needs time):**
```bash
cd /opt/archon-vps-hetzner
./scripts/setup-server-domain.sh server.yourdomain.com
```
Then after DNS propagates, run:
```bash
./scripts/enable-panel-ssl.sh server.yourdomain.com
```

**Step 3: Access HestiaCP via domain**
- After SSL is issued, access panel at: `https://server.yourdomain.com:8083`

**Note:** This is optional. You can use the server with just IP:8083, but having SSL on a domain is more professional and secure.

## Adding Client Domains

### Quick Workflow

1. **Ask client to point domain to your VPS IP** (A record: `@` → `your-server-ip`)
2. **After client confirms**, run the script:
   ```bash
   cd /opt/archon-vps-hetzner
   ./scripts/add_client_domain.sh example.com clientuser
   ```
3. **Wait for DNS propagation** (5-30 minutes)
4. **Enable SSL in HestiaCP**: Web → domain → Enable SSL & Let's Encrypt → Save

The script will:
- Create HestiaCP user (if not exists)
- Add web domain
- Add mail domain
- Enable DKIM
- Print DNS records (MX, SPF, DKIM, DMARC) for email

**See [docs/client-onboarding.md](docs/client-onboarding.md) for complete client onboarding workflow and email templates.**

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
│   ├── add_client_domain.sh    # Helper to add client domains
│   ├── setup-server-domain.sh  # Setup domain for HestiaCP panel
│   └── enable-panel-ssl.sh     # Enable SSL for HestiaCP panel
├── docs/
│   ├── FIVERR-CLIENT-SETUP.md   # Instructions for Fiverr client
│   ├── client-onboarding.md     # Customer onboarding workflow
│   ├── how-to-add-domain.md     # Domain setup guide
│   ├── how-to-create-email.md  # Email account guide
│   └── how-ssl-works.md         # SSL automation guide
└── README.md                    # This file
```

## Support

For HestiaCP documentation: https://docs.hestiacp.com/
