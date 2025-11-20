# Configuring Hostinger Domains for HestiaCP Testing

This guide shows how to configure your Hostinger domains (`recallmate.pro` and `nextshines.com`) to point to your HestiaCP server.

## ⚠️ Important: Main Domain vs Subdomain

**If your main domains are already hosting websites (e.g., on Vercel):**
- **Use subdomains** for testing (see `SUBDOMAIN-TESTING.md`)
- Example: `test.recallmate.pro` instead of `recallmate.pro`
- This keeps your main sites working!

**If you want to fully migrate domains:**
- Follow instructions below for main domain setup

## Important: A Records vs CNAME

- **A Records** = Point domain directly to IP address (required for main domains)
- **CNAME Records** = Point to another domain name (used for subdomains)

For main domain hosting, you need **A Records**, not CNAME.

## Option 1: Test with Main Domains (Recommended)

### For `recallmate.pro`:

1. **Log into Hostinger** → Go to **Domains** → **Domain portfolio**

2. **Click "Manage"** next to `recallmate.pro`

3. **Go to DNS / Nameservers** section

4. **Add/Edit A Records:**
   - **A Record for @ (root domain):**
     - Name: `@` (or leave blank)
     - Value: `5.78.86.122`
     - TTL: `3600` (or Auto)
   
   - **A Record for www:**
     - Name: `www`
     - Value: `5.78.86.122`
     - TTL: `3600` (or Auto)

5. **Save changes**

6. **Wait 5-30 minutes** for DNS propagation

### For `nextshines.com`:

Repeat the same steps:
- Add A record: `@` → `5.78.86.122`
- Add A record: `www` → `5.78.86.122`

## Option 2: Test with Subdomains (Alternative)

If you want to keep your main domains pointing elsewhere, use subdomains:

### For `recallmate.pro`:

1. **Add CNAME Record:**
   - Name: `test` (or `hestia`, `hosting`, etc.)
   - Value: `recallmate.pro` (or use A record: `5.78.86.122`)
   - TTL: `3600`

   **OR use A Record for subdomain:**
   - Name: `test`
   - Value: `5.78.86.122`
   - TTL: `3600`

2. **Then test with:** `https://test.recallmate.pro`

### For `nextshines.com`:

Same process:
- Add A record: `test` → `5.78.86.122`
- Test with: `https://test.nextshines.com`

## Step-by-Step: Hostinger DNS Configuration

### Method 1: Via Hostinger DNS Manager

1. **Log into Hostinger**
2. **Go to:** Domains → Domain portfolio
3. **Click "Manage"** next to your domain
4. **Find "DNS Zone" or "DNS Management"** section
5. **Add these records:**

   **For recallmate.pro:**
   ```
   Type: A
   Name: @
   Value: 5.78.86.122
   TTL: 3600
   
   Type: A
   Name: www
   Value: 5.78.86.122
   TTL: 3600
   ```

   **For nextshines.com:**
   ```
   Type: A
   Name: @
   Value: 5.78.86.122
   TTL: 3600
   
   Type: A
   Name: www
   Value: 5.78.86.122
   TTL: 3600
   ```

6. **Save changes**

### Method 2: Via Hostinger hPanel

1. **Log into Hostinger hPanel**
2. **Go to:** Domains → Advanced → DNS Zone Editor
3. **Select your domain**
4. **Add A records** as shown above

## After DNS Configuration

### Step 1: Wait for DNS Propagation

Check if DNS is ready:
```bash
# On your server or local machine
dig recallmate.pro
dig nextshines.com

# Should return: 5.78.86.122
```

### Step 2: Add Domains in HestiaCP

**Option A: Via Web UI**

1. **Create user for recallmate.pro:**
   - User → Add User
   - Username: `recallmate`
   - Package: `ARCHON_BASIC`
   - Save

2. **Add domain:**
   - Web → Add Web Domain
   - Domain: `recallmate.pro`
   - User: `recallmate`
   - Enable SSL & Let's Encrypt
   - Save

3. **Repeat for nextshines.com:**
   - Create user: `nextshines`
   - Add domain: `nextshines.com`
   - Enable SSL

**Option B: Via Script (Faster)**

```bash
ssh root@5.78.86.122
cd ~/hestisCP-bootstrap-vps

# Add recallmate.pro
./scripts/add_client_domain.sh recallmate.pro recallmate

# Add nextshines.com
./scripts/add_client_domain.sh nextshines.com nextshines
```

Then enable SSL in HestiaCP panel for both domains.

### Step 3: Enable SSL

1. **In HestiaCP panel:**
   - Go to **Web** → Click on domain → **Edit**
   - Enable **SSL Support**
   - Enable **Let's Encrypt support**
   - Click **Save**

2. **Wait 1-2 minutes** for SSL certificate

### Step 4: Test Access

Visit:
- `https://recallmate.pro`
- `https://www.recallmate.pro`
- `https://nextshines.com`
- `https://www.nextshines.com`

All should show your HestiaCP default page or uploaded files.

## Testing Checklist

- [ ] DNS A records added in Hostinger
- [ ] DNS propagated (check with `dig` command)
- [ ] User created in HestiaCP
- [ ] Domain added to user
- [ ] SSL certificate issued
- [ ] Website accessible via HTTPS
- [ ] FTP access works
- [ ] Can upload files

## Quick Test Commands

```bash
# Check DNS propagation
dig recallmate.pro +short
dig nextshines.com +short

# Should return: 5.78.86.122

# Add domains via script
./scripts/add_client_domain.sh recallmate.pro recallmate
./scripts/add_client_domain.sh nextshines.com nextshines
```

## Important Notes

⚠️ **If domains are currently hosting websites:**
- Adding A records will point domains to HestiaCP server
- Current websites will stop working
- Use subdomains (test.recallmate.pro) if you want to keep main sites running

⚠️ **DNS Propagation:**
- Changes take 5-30 minutes typically
- Can take up to 48 hours in rare cases
- Check with `dig` command to verify

⚠️ **Email:**
- If you add mail domains, you'll also need MX, SPF, DKIM, DMARC records
- The script will show you these records after adding mail domain

## Troubleshooting

**Domain not resolving?**
- Check DNS records in Hostinger
- Wait longer for propagation
- Use `dig` command to check

**SSL not working?**
- Ensure DNS points to server IP
- Wait for DNS propagation
- Check SSL is enabled in HestiaCP

**Can't access website?**
- Verify DNS: `dig yourdomain.com` should return `5.78.86.122`
- Check firewall: ports 80 and 443 should be open
- Check domain is added in HestiaCP

## Next Steps After Testing

1. Upload test files via FTP
2. Verify websites work
3. Test email (if configured)
4. Document the process
5. Ready for real customers!

