# Testing Workflow via HestiaCP Web UI

This guide walks you through testing the complete workflow using the HestiaCP web interface.

## Prerequisites

- You have access to HestiaCP panel: `https://cpanel.archonsys.io:8083`
- You have a test domain ready (or use a subdomain)
- Test domain's A record points to: `5.78.86.122`

## Step 1: Create a Test User

1. **In HestiaCP panel**, go to **User** section (already there based on your screenshot)

2. **Click "Add User"** button (green button with + icon)

3. **Fill in the form:**
   - **Username:** `testuser1` (or any username you prefer)
   - **Contact Name:** `Test User 1`
   - **Email:** Your email (e.g., `umerfarooq.dev+test1@gmail.com`)
   - **Password:** Click the refresh icon to generate, or enter: `Temp@11223344`
   - **Language:** English (default)
   - **Role:** User (default)
   - **Package:** Select `ARCHON_BASIC` (or `default` if ARCHON_BASIC not visible)
   - **Email login credentials to:** Same email as above
   - **Checkbox:** "Send welcome email" (optional)

4. **Click "Save"** button (purple button at bottom right)

5. **Note the username and password** - you'll need these!

## Step 2: Add Domain for the User

### Option A: Via Web Interface

1. **Go to Web** section (click "WEB" in top navigation)

2. **Click "Add Web Domain"** button

3. **Fill in:**
   - **Domain:** `test1.yourdomain.com` (your test domain)
   - **User:** Select `testuser1` from dropdown
   - **Aliases:** Leave blank (or add `www.test1.yourdomain.com`)
   - **Document Root:** Leave default
   - **SSL Support:** Check this box
   - **Let's Encrypt:** Check this box (for automatic SSL)
   - **Proxy Support:** Leave unchecked (unless needed)
   - **CGI:** Check if needed
   - **FastCGI Cache:** Leave unchecked

4. **Click "Save"**

5. **Wait for SSL certificate** to be issued (may take 1-2 minutes)

### Option B: Via Script (Faster)

Alternatively, use the script we created:

```bash
ssh root@5.78.86.122
cd ~/hestisCP-bootstrap-vps
./scripts/add_client_domain.sh test1.yourdomain.com testuser1
```

Then enable SSL in the UI:
- Go to **Web** → Click on `test1.yourdomain.com` → **Edit**
- Enable **SSL Support** and **Let's Encrypt**
- Click **Save**

## Step 3: Add Mail Domain (Optional)

1. **Go to Mail** section

2. **Click "Add Mail Domain"**

3. **Fill in:**
   - **Domain:** `test1.yourdomain.com`
   - **User:** `testuser1`
   - **DKIM:** Check this box

4. **Click "Save"**

5. **Note the DNS records** shown - you'll need to add these to your DNS provider

## Step 4: Create Email Account (Optional)

1. **In Mail section**, select the domain `test1.yourdomain.com`

2. **Click "Add Account"**

3. **Fill in:**
   - **Account:** `info` (or any name)
   - **Password:** Generate or enter a password

4. **Click "Save"**

5. **Note the email credentials:**
   - Email: `info@test1.yourdomain.com`
   - IMAP: `mail.test1.yourdomain.com:993`
   - SMTP: `mail.test1.yourdomain.com:587`

## Step 5: Test Website Access

1. **Wait 5-30 minutes** for DNS to propagate (if you just added DNS records)

2. **Visit:** `https://test1.yourdomain.com`

3. **You should see:**
   - HestiaCP default page, OR
   - Your uploaded files (if you uploaded via FTP)

## Step 6: Test FTP Access

1. **Get FTP credentials:**
   - Go to **User** → `testuser1` → **Edit**
   - Note the FTP details shown

2. **Use FTP client** (FileZilla, WinSCP, etc.):
   - **Host:** `test1.yourdomain.com` (or `5.78.86.122`)
   - **Username:** `testuser1`
   - **Password:** (password you set)
   - **Port:** 21 (FTP) or 22 (SFTP)

3. **Upload a test file:**
   - Create `index.html` with content: `<h1>Test Website Works!</h1>`
   - Upload to `/home/testuser1/web/test1.yourdomain.com/public_html/`
   - Visit `https://test1.yourdomain.com` - you should see your test page

## Step 7: Test Email (If Configured)

1. **Configure email client** (Outlook, Apple Mail, Thunderbird):
   - **IMAP Server:** `mail.test1.yourdomain.com`
   - **IMAP Port:** 993 (SSL/TLS)
   - **SMTP Server:** `mail.test1.yourdomain.com`
   - **SMTP Port:** 587 (STARTTLS)
   - **Username:** `info@test1.yourdomain.com`
   - **Password:** (password you set)

2. **Send a test email** to verify it works

## Complete Testing Checklist

- [ ] User created successfully
- [ ] Domain added to user
- [ ] SSL certificate issued (green padlock in browser)
- [ ] Website accessible via HTTPS
- [ ] FTP access works
- [ ] Can upload files via FTP
- [ ] Uploaded files appear on website
- [ ] Mail domain added (if testing email)
- [ ] Email account created (if testing email)
- [ ] Email sending/receiving works (if testing email)

## Quick Test Summary

**For quick testing:**

1. **Create user:** User → Add User → Fill form → Save
2. **Add domain:** Web → Add Web Domain → Enter domain → Enable SSL → Save
3. **Test access:** Visit `https://yourdomain.com` in browser
4. **Test FTP:** Upload file via FTP client
5. **Verify:** Check website shows uploaded file

## Troubleshooting

**Domain not accessible?**
- Check DNS: `dig test1.yourdomain.com` should return `5.78.86.122`
- Wait 5-30 minutes for DNS propagation
- Check firewall: `ufw status` - ports 80 and 443 should be open

**SSL not working?**
- Ensure DNS points to server IP
- Wait for DNS propagation
- Check SSL in Web → Domain → Edit → SSL Support enabled

**FTP not working?**
- Check user has FTP access enabled
- Verify username/password
- Try SFTP (port 22) instead of FTP (port 21)

## Next Steps

Once testing is complete:
1. Delete test users/domains if not needed
2. Document the workflow for your Fiverr client
3. Ready to onboard real customers!

