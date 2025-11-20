# Testing with Subdomain (Keep Main Domain on Vercel)

This guide shows how to test HestiaCP with a subdomain while keeping your main domains (`recallmate.pro` and `nextshines.com`) pointing to Vercel.

## Why Use Subdomain?

✅ **Main domain stays on Vercel** - no disruption  
✅ **Easy to test** - just add one DNS record  
✅ **Easy to remove** - delete DNS record when done  
✅ **No risk** - main website continues working  

## Choose a Subdomain

Pick one of these options:
- `test.recallmate.pro` (or `test.nextshines.com`)
- `hosting.recallmate.pro`
- `hestia.recallmate.pro`
- `server.recallmate.pro`

**Recommendation:** Use `test.recallmate.pro` or `test.nextshines.com`

## Step 1: Add DNS Record in Hostinger

### For `test.recallmate.pro`:

1. **Log into Hostinger** → Domains → Domain portfolio
2. **Click "Manage"** next to `recallmate.pro`
3. **Go to DNS Zone Editor** or **DNS Management**
4. **Add A Record:**
   ```
   Type: A
   Name: test
   Value: 5.78.86.122
   TTL: 3600 (or Auto)
   ```
   
   **OR use CNAME (if Hostinger supports it):**
   ```
   Type: CNAME
   Name: test
   Value: cpanel.archonsys.io
   TTL: 3600
   ```
   
   **Note:** A record is more reliable for hosting. Use CNAME only if A record doesn't work.

5. **Save changes**

### For `test.nextshines.com`:

Same process:
- Add A record: `test` → `5.78.86.122`

## Step 2: Wait for DNS Propagation

Check if DNS is ready:
```bash
# On your computer or server
dig test.recallmate.pro
# Should return: 5.78.86.122

# Or check online:
# https://www.whatsmydns.net/#A/test.recallmate.pro
```

Wait 5-30 minutes for DNS to propagate.

## Step 3: Add Domain in HestiaCP

### Option A: Via Script (Recommended)

```bash
ssh root@5.78.86.122
cd ~/hestisCP-bootstrap-vps

# Add test subdomain
./scripts/add_client_domain.sh test.recallmate.pro testuser

# Or for nextshines.com:
./scripts/add_client_domain.sh test.nextshines.com testuser2
```

### Option B: Via Web UI

1. **Create user:**
   - User → Add User
   - Username: `testuser`
   - Package: `ARCHON_BASIC`
   - Save

2. **Add domain:**
   - Web → Add Web Domain
   - Domain: `test.recallmate.pro`
   - User: `testuser`
   - Enable SSL & Let's Encrypt
   - Save

## Step 4: Enable SSL

1. **In HestiaCP panel:**
   - Go to **Web** → Click on `test.recallmate.pro` → **Edit**
   - Enable **SSL Support**
   - Enable **Let's Encrypt support**
   - Click **Save**

2. **Wait 1-2 minutes** for SSL certificate

## Step 5: Test Access

Visit:
- `https://test.recallmate.pro`
- `https://test.nextshines.com` (if you set it up)

You should see:
- HestiaCP default page, OR
- Your uploaded files (if you uploaded via FTP)

## Step 6: Test FTP Upload

1. **Get FTP credentials:**
   - Go to User → `testuser` → Edit
   - Note FTP details

2. **Use FTP client:**
   - Host: `test.recallmate.pro` (or `5.78.86.122`)
   - Username: `testuser`
   - Password: (from HestiaCP)
   - Port: 22 (SFTP)

3. **Upload test file:**
   - Create `index.html`: `<h1>HestiaCP Test Works!</h1>`
   - Upload to: `/home/testuser/web/test.recallmate.pro/public_html/`
   - Visit `https://test.recallmate.pro` - see your page!

## Complete Example: test.recallmate.pro

### DNS Setup (Hostinger):
```
Type: A
Name: test
Value: 5.78.86.122
TTL: 3600
```

### HestiaCP Setup:
```bash
./scripts/add_client_domain.sh test.recallmate.pro testuser
```

### Enable SSL:
- Web → test.recallmate.pro → Edit → SSL → Save

### Test:
- Visit: `https://test.recallmate.pro`
- Upload files via FTP
- Verify website works

## Quick Commands

```bash
# Check DNS
dig test.recallmate.pro +short
# Should return: 5.78.86.122

# Add domain
./scripts/add_client_domain.sh test.recallmate.pro testuser

# Check domain in HestiaCP
# Log into panel → Web → see test.recallmate.pro listed
```

## Important Notes

✅ **Main domain unaffected** - `recallmate.pro` still points to Vercel  
✅ **Subdomain independent** - `test.recallmate.pro` points to HestiaCP  
✅ **Easy cleanup** - Delete DNS record when done testing  
✅ **No SSL issues** - Let's Encrypt works fine with subdomains  

## When Done Testing

To remove the test setup:

1. **Delete DNS record** in Hostinger (optional - can leave it)
2. **Delete domain** in HestiaCP: Web → test.recallmate.pro → Delete
3. **Delete user** (optional): User → testuser → Delete

## Troubleshooting

**Subdomain not resolving?**
- Check DNS record in Hostinger
- Wait longer for propagation (can take up to 30 minutes)
- Verify with: `dig test.recallmate.pro`

**SSL not working?**
- Ensure DNS points to server IP
- Wait for DNS propagation
- Check SSL is enabled in HestiaCP

**Main domain affected?**
- Should NOT be affected - subdomain is separate
- If main domain stops working, check DNS records didn't accidentally change

## Summary

**Quick Setup:**
1. Add A record: `test` → `5.78.86.122` in Hostinger
2. Run: `./scripts/add_client_domain.sh test.recallmate.pro testuser`
3. Enable SSL in HestiaCP panel
4. Test: `https://test.recallmate.pro`

**Main domain stays on Vercel - no disruption!** 🎉

