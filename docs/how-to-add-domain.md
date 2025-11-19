# How to Add a New Client Domain

You can add new client domains via the helper script on the VPS.

## Steps

1. SSH into the VPS as root.

2. Go to the repo folder, for example:

   ```bash
   cd /opt/archon-vps-hetzner
   ```

3. Run the script:

   ```bash
   sudo ./scripts/add_client_domain.sh client-domain.com clientuser
   ```

The script will:

- Create the HestiaCP user (if it does not exist)
- Add the web domain
- Add the mail domain
- Enable DKIM
- Print DNS records for:
  - A
  - MX
  - SPF
  - DKIM
  - DMARC

Copy those DNS records into your external DNS provider (Cloudflare or Hetzner DNS).

Once DNS propagates, HestiaCP can issue Let's Encrypt SSL certificates automatically for the domain.

