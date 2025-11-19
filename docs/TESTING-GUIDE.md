# Testing Guide: Adding Test Domains

This guide shows how to add test domains to verify everything works.

## Architecture Overview

**This is NOT a SaaS platform** - it's an **admin-managed hosting control panel**.

### How It Works:

1. **Admin (You/Your Fiverr Client)** manages everything:
   - Creates user accounts for customers
   - Configures domains
   - Sets up email accounts
   - Manages all hosting resources

2. **End Users (Your Customers)**:
   - Do NOT access HestiaCP directly
   - Receive FTP/email credentials from admin
   - Upload files via FTP/SFTP
   - Access their website via their domain
   - Use email via email clients (Outlook, Apple Mail, etc.)

3. **Workflow**:
   ```
   Customer → Asks admin to host domain
   Admin → Creates account in HestiaCP
   Admin → Configures domain
   Admin → Gives customer FTP/email credentials
   Customer → Uploads website files via FTP
   Customer → Website is live!
   ```

## Testing: Adding Two Test Domains

### Prerequisites for Testing

For testing, you can use:
- **Subdomains** of domains you own (e.g., `test1.yourdomain.com`, `test2.yourdomain.com`)
- **Test domains** you've purchased
- **Local hosts file** (for local testing only)

### Step 1: Point Test Domains to Server IP

In your DNS provider, add A records:
- `test1.yourdomain.com` → `5.78.86.122`
- `test2.yourdomain.com` → `5.78.86.122`

Wait 5-30 minutes for DNS propagation.

### Step 2: Add First Test Domain

SSH into server:
```bash
ssh root@5.78.86.122
cd ~/hestisCP-bootstrap-vps
```

Run the script:
```bash
./scripts/add_client_domain.sh test1.yourdomain.com testuser1
```

This will:
- Create user `testuser1` (if doesn't exist)
- Add web domain `test1.yourdomain.com`
- Add mail domain
- Enable DKIM
- Print DNS records needed

**Save the user password** shown in the output!

### Step 3: Add Second Test Domain

```bash
./scripts/add_client_domain.sh test2.yourdomain.com testuser2
```

This creates a second user and domain.

### Step 4: Enable SSL for Test Domains

After DNS propagates (5-30 minutes):

1. Log into HestiaCP: `https://cpanel.archonsys.io:8083`
2. Go to **Web** → select `test1.yourdomain.com` → **Edit**
3. Enable **SSL Support** and **Let's Encrypt support**
4. Click **Save**
5. Repeat for `test2.yourdomain.com`

### Step 5: Test Website Access

After SSL is enabled:
- Visit: `https://test1.yourdomain.com`
- Visit: `https://test2.yourdomain.com`

Both should show HestiaCP default page or your uploaded files.

### Step 6: Test FTP Access

Use the credentials from Step 2:
- **FTP Server:** `test1.yourdomain.com` (or `5.78.86.122`)
- **Username:** `testuser1`
- **Password:** (from script output)
- **Port:** 21 (FTP) or 22 (SFTP)

Upload a test `index.html` file and verify it appears on the website.

## Real-World Workflow

### When a Real Customer Wants Hosting:

1. **Customer contacts admin** (you/your Fiverr client)
2. **Admin collects:**
   - Domain name
   - Customer contact email
   - Username preference

3. **Admin tells customer:**
   - "Point your domain's A record to: `5.78.86.122`"
   - "Let me know when DNS is configured"

4. **After DNS is ready:**
   - Admin runs: `./scripts/add_client_domain.sh customerdomain.com customeruser`
   - Admin enables SSL in HestiaCP panel
   - Admin sends customer their FTP/email credentials

5. **Customer:**
   - Uploads website files via FTP
   - Website goes live
   - Uses email via email clients

## Key Points

✅ **Admin manages everything** - customers don't access HestiaCP  
✅ **Customers get FTP/email credentials** - they upload files and use email  
✅ **This is managed hosting** - not self-service SaaS  
✅ **Admin creates all accounts** - customers don't sign up themselves  

## Quick Test Commands

```bash
# Add test domain 1
./scripts/add_client_domain.sh test1.yourdomain.com testuser1

# Add test domain 2  
./scripts/add_client_domain.sh test2.yourdomain.com testuser2

# Check domains in HestiaCP
# Log into panel → Web → see both domains listed
```

## Next Steps After Testing

1. Verify domains work
2. Test FTP upload
3. Test email (create email account in HestiaCP)
4. Test SSL certificates
5. Ready for real customers!

