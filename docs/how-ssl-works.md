# SSL Automation (Let's Encrypt) in HestiaCP

HestiaCP supports automatic Let's Encrypt SSL certificates for each domain.

## Requirements

- The domain's A record points to the VPS IP.
- DNS is correctly configured and propagated.
- Port 80 (HTTP) is open and reachable.

## Issuing SSL for a Domain

1. Log in to HestiaCP.

2. Go to **Web**.

3. Edit the domain.

4. Enable:

   - **SSL Support**
   - **Let's Encrypt support**

5. Save.

Hestia will request and install a Let's Encrypt SSL certificate.

## Renewal

Let's Encrypt certificates are renewed automatically by Hestia as long as:

- The domain still points to the server.
- Port 80 is open.

