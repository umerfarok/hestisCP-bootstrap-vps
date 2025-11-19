# Ready-to-Use Customer Email Template

**Note:** This is for your **customers** (end users who will host websites), NOT the Fiverr client.

Copy and paste this email to send to your customers:

---

**Subject:** Domain Setup Instructions for [CLIENT_DOMAIN]

Hi [Client Name],

To complete the setup of your domain **[CLIENT_DOMAIN]**, please configure the following DNS records in your domain registrar (where you purchased the domain):

**Required DNS Records:**

1. **A Record** (for website):
   - Name: `@` (or leave blank)
   - Value: `5.78.86.122`
   - TTL: Auto (or 3600)

2. **A Record** (for www subdomain):
   - Name: `www`
   - Value: `5.78.86.122`
   - TTL: Auto (or 3600)

**Where to configure:**
- Log into your domain registrar (e.g., Cloudflare, Namecheap, GoDaddy, etc.)
- Find DNS management / DNS settings
- Add the two A records above

**After you configure DNS:**
- Please let us know once you've added the records
- DNS changes typically take 5-30 minutes to propagate
- Once DNS is configured, we'll set up SSL certificates automatically

**Questions?** Just reply to this email!

Thanks!

---

## What Information to Collect from Your Customer

**Before sending the email above, ask:**

1. **Domain name:** "What domain do you want to host?" (e.g., `example.com`)
2. **Username:** "What username would you prefer for your account?" (e.g., `clientname`)
3. **Email:** "What email should we use for account notifications?"

**Then send them the email above with their domain filled in.**

## After Client Confirms DNS is Configured

1. SSH into server: `ssh root@5.78.86.122`
2. Run: `cd /opt/archon-vps-hetzner && ./scripts/add_client_domain.sh [DOMAIN] [USERNAME]`
3. Wait 5-30 minutes for DNS propagation
4. Log into HestiaCP: `https://5.78.86.122:8083`
5. Enable SSL: Web → domain → SSL Support → Let's Encrypt → Save
6. Done!

