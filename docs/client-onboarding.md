# Client Onboarding Guide

**Important:** This guide is for onboarding **your customers** (the end users who will host their websites on your HestiaCP platform), NOT the Fiverr client who hired you to set up the server.

This guide explains what information to collect from your customers and the workflow for setting up their domains on your HestiaCP server.

## Information to Collect from Your Customer

Before setting up a customer domain, collect the following:

1. **Domain name** (e.g., `example.com`) - **This is the main thing you need!**
2. **Customer username** (for HestiaCP access, e.g., `clientname` or `examplecom`)
3. **Contact email** (for account notifications)

**Your Server IP:** `5.78.86.122`

**What to tell your customers:** "Please point your domain's A record to our server IP: `5.78.86.122`"

---

**Note:** 
- **Fiverr Client** = The person who hired you to set up this server (they own the VPS)
- **Your Customers** = The end users who will host websites on this HestiaCP platform (they need domains set up)

## Workflow

### Step 1: Collect Domain Information

**Ask your customer:**
- "What domain do you want to host with us?" (e.g., `example.com`)
- "We'll create an account for you. What username would you prefer?" (e.g., `clientname` or `examplecom`)
- "What email should we use for account notifications?"

**Then tell them:**
- "Please point your domain's A record to our server IP: `5.78.86.122`"
- "Once you've done that, let us know and we'll complete the setup"

### Step 2: Instructions to Send Your Customer

Send your customer these instructions:

---

**DNS Configuration Instructions**

To complete the setup of your domain `[DOMAIN]`, please configure the following DNS records in your domain registrar (e.g., Cloudflare, Namecheap, GoDaddy):

**Required DNS Records:**

1. **A Record** (for website):
   - Name: `@` (or leave blank)
   - Value: `5.78.86.122`
   - TTL: Auto (or 3600)

2. **A Record** (for www subdomain):
   - Name: `www`
   - Value: `5.78.86.122`
   - TTL: Auto (or 3600)

**Important:**
- After you configure these DNS records, please let us know
- DNS changes typically take 5-30 minutes to propagate
- Once DNS is configured, we'll set up SSL certificates automatically

---

### Step 3: Add Domain in HestiaCP (After Customer Confirms DNS)

Once your customer confirms they've pointed their domain to your VPS IP:

1. **SSH into your VPS:**
   ```bash
   ssh root@5.78.86.122
   cd /opt/archon-vps-hetzner
   ```

2. **Run the add domain script:**
   ```bash
   ./scripts/add_client_domain.sh example.com clientuser
   ```

   Replace:
   - `example.com` with the client's domain
   - `clientuser` with the client's username

3. **The script will output:**
   - HestiaCP user credentials (if new user was created)
   - Complete DNS records needed (A, MX, SPF, DKIM, DMARC)

4. **Send DNS records to your customer** (if they haven't configured email DNS yet):
   - Copy the DNS records from the script output
   - Send them to your customer with instructions to add:
     - MX record (for email)
     - SPF record (TXT)
     - DKIM record (TXT)
     - DMARC record (TXT)

### Step 4: Configure SSL (After DNS Propagates)

Wait 5-30 minutes for DNS to propagate, then:

1. **Log into HestiaCP panel:**
   - Go to `https://5.78.86.122:8083`
   - Log in as admin

2. **Enable SSL for the domain:**
   - Go to **Web** → select the domain
   - Enable **SSL Support**
   - Enable **Let's Encrypt support**
   - Click **Save**

3. **HestiaCP will automatically:**
   - Request SSL certificate from Let's Encrypt
   - Install the certificate
   - Configure automatic renewal

### Step 5: Set Server Hostname (Optional - First Domain Only)

If this is your first client domain and you want to use it as the server hostname:

1. In HestiaCP: **Server** → **Configure**
2. Set hostname to your domain (e.g., `server.example.com`)
3. Save

**Note:** This is optional. The server works fine with just the IP address.

## Complete Example Workflow

### Email to Your Customer (Before Setup)

```
Subject: Domain Setup Instructions for example.com

Hi [Client Name],

To complete the setup of your domain example.com, please configure the following DNS record:

A Record:
- Name: @ (or leave blank)
- Value: 5.78.86.122
- TTL: Auto

A Record (for www):
- Name: www
- Value: 5.78.86.122
- TTL: Auto

Please configure this in your domain registrar (where you purchased the domain).

Once you've configured the DNS, please let us know and we'll complete the setup on our end.

Thanks!
```

### After Customer Confirms DNS

1. Run: `./scripts/add_client_domain.sh example.com clientuser`
2. Note the user credentials if a new user was created
3. Send your customer their HestiaCP login credentials
4. Wait for DNS propagation (5-30 minutes)
5. Enable SSL in HestiaCP panel
6. Done! Domain is live with SSL

## What Happens Automatically

✅ **SSL Certificates**: Once DNS points to your server and you enable SSL in HestiaCP, certificates are issued automatically

✅ **SSL Renewal**: Let's Encrypt certificates renew automatically every 90 days

✅ **Email DNS**: The script generates SPF, DKIM, and DMARC records - just send them to your customer to add

## Quick Checklist

- [ ] Collect domain name and username from your customer
- [ ] Send DNS instructions to your customer (A records pointing to `5.78.86.122`)
- [ ] Wait for customer confirmation
- [ ] Run `./scripts/add_client_domain.sh` on server
- [ ] Send your customer their HestiaCP credentials
- [ ] Send your customer email DNS records (MX, SPF, DKIM, DMARC) if needed
- [ ] Wait for DNS propagation (5-30 minutes)
- [ ] Enable SSL in HestiaCP panel
- [ ] Verify domain is accessible via HTTPS

## Common Questions from Your Customers

**Q: How long does DNS take to propagate?**  
A: Usually 5-30 minutes, but can take up to 48 hours in rare cases.

**Q: Do I need to configure email DNS records?**  
A: Only if you want email hosting. We'll provide the exact records to add.

**Q: Will SSL work automatically?**  
A: Yes! Once DNS points to our server and we enable SSL in the panel, certificates are issued automatically.

**Q: Can I use Cloudflare?**  
A: Yes, but make sure Cloudflare DNS mode is set to "DNS Only" (not proxied) for the A records, or SSL validation may fail.

