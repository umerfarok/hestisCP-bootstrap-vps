# How to Upload Custom Welcome Page

This guide shows how to replace the default HestiaCP "Coming Soon" page with a custom welcome page.

## Step 1: Get the Welcome Page File

The welcome page is located at:
```
templates/client-welcome-page.html
```

## Step 2: Upload via FTP/SFTP

### Option A: Via FTP Client (FileZilla, WinSCP, etc.)

1. **Get FTP credentials:**
   - Log into HestiaCP: `https://cpanel.archonsys.io:8083`
   - Go to **User** → `recallmate` (or your test user) → **Edit**
   - Note FTP details shown

2. **Connect via FTP:**
   - **Host:** `test.recallmate.pro` (or `5.78.86.122`)
   - **Username:** `recallmate`
   - **Password:** (from HestiaCP)
   - **Port:** 22 (SFTP) or 21 (FTP)

3. **Navigate to website directory:**
   - Go to: `/home/recallmate/web/test.recallmate.pro/public_html/`

4. **Upload and rename:**
   - Upload `client-welcome-page.html`
   - Rename it to `index.html` (replace the existing one)

### Option B: Via SSH (Faster)

```bash
ssh root@5.78.86.122

# Copy the welcome page to the website directory
cd ~/hestisCP-bootstrap-vps
cp templates/client-welcome-page.html /home/recallmate/web/test.recallmate.pro/public_html/index.html

# Set correct permissions
chown recallmate:recallmate /home/recallmate/web/test.recallmate.pro/public_html/index.html
chmod 644 /home/recallmate/web/test.recallmate.pro/public_html/index.html
```

## Step 3: Verify

1. **Visit:** `https://test.recallmate.pro`
2. **You should see:** The new welcome page with client information

## Customizing the Welcome Page

You can edit `templates/client-welcome-page.html` to:
- Change colors/styling
- Update contact email
- Add your company logo
- Modify features list
- Change domain name dynamically

## For Multiple Domains

To use this welcome page for multiple domains:

```bash
# For each domain, copy the template:
cp templates/client-welcome-page.html /home/USERNAME/web/DOMAIN.com/public_html/index.html
chown USERNAME:USERNAME /home/USERNAME/web/DOMAIN.com/public_html/index.html
```

## Quick Command (SSH Method)

```bash
ssh root@5.78.86.122
cd ~/hestisCP-bootstrap-vps
cp templates/client-welcome-page.html /home/recallmate/web/test.recallmate.pro/public_html/index.html
chown recallmate:recallmate /home/recallmate/web/test.recallmate.pro/public_html/index.html
```

Then visit `https://test.recallmate.pro` to see the new welcome page!

