# Instructions for Fiverr Client (Server Owner)

This guide is for **you to give to your Fiverr client** - the person who owns the VPS and will manage the HestiaCP server.

## Two Options for Accessing HestiaCP Panel

### Option 1: Use IP Address (Simplest - Works Immediately)

**Access the panel at:** `https://5.78.86.122:8083`

- ✅ Works immediately after setup
- ✅ No domain needed
- ⚠️ Browser will show a security warning (self-signed certificate)
- ⚠️ Less professional

**Steps:**
1. After server setup is complete, access: `https://5.78.86.122:8083`
2. Log in with admin credentials (provided after installation)
3. Accept the browser security warning (click "Advanced" → "Proceed")

**This is fine for getting started!** You can always add a domain later.

---

### Option 2: Use Domain with SSL (Recommended - More Professional)

**Access the panel at:** `https://server.yourdomain.com:8083` (or whatever domain you choose)

- ✅ Professional appearance
- ✅ Valid SSL certificate (no browser warnings)
- ✅ Easier to remember
- ⚠️ Requires a domain and DNS setup

**Steps:**

1. **Ask your Fiverr client:**
   - "Do you have a domain you'd like to use for accessing the HestiaCP control panel?"
   - "For example: `server.yourdomain.com` or `panel.yourdomain.com`"
   - "If yes, please point that domain's A record to: `5.78.86.122`"

2. **After client points domain to IP, run the setup script:**

   **Option A: Automatic SSL (if DNS is ready):**
   ```bash
   ssh root@5.78.86.122
   cd /opt/archon-vps-hetzner
   ./scripts/setup-server-domain.sh cpanel.archonsys.io --auto-ssl
   ```
   This will automatically enable SSL if DNS is ready.

   **Option B: Manual SSL (if DNS needs time):**
   ```bash
   ssh root@5.78.86.122
   cd /opt/archon-vps-hetzner
   ./scripts/setup-server-domain.sh cpanel.archonsys.io
   ```
   Then after DNS propagates (5-30 minutes), run:
   ```bash
   ./scripts/enable-panel-ssl.sh cpanel.archonsys.io
   ```

3. **Access panel via domain:**
   - `https://cpanel.archonsys.io:8083`

---

## What to Tell Your Fiverr Client

### If They Want to Use IP Only (Simplest):

> "You can access the HestiaCP control panel at: `https://5.78.86.122:8083`"
> 
> "Your browser may show a security warning - that's normal. Just click 'Advanced' → 'Proceed' to continue."
> 
> "If you want a domain with SSL later, we can set that up anytime."

### If They Want a Domain (Recommended):

> "Do you have a domain you'd like to use for the control panel? (e.g., `server.yourdomain.com`)"
> 
> "If yes, please point that domain's A record to: `5.78.86.122`"
> 
> "Once DNS is configured, I'll set up SSL so you can access it at `https://server.yourdomain.com:8083`"

---

## Summary

**For immediate access:** Use `https://5.78.86.122:8083` - no domain needed!

**For professional setup:** Ask client to point a domain to `5.78.86.122`, then run `setup-server-domain.sh` script.

**Important:** The domain for the HestiaCP panel is SEPARATE from customer domains. Customer domains are set up later using `add_client_domain.sh`.

