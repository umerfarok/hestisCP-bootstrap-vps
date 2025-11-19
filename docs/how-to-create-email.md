# How to Create Email Accounts for a Domain

1. Log in to the HestiaCP control panel as `admin` (or the client user).

2. Go to **Mail**.

3. Select the domain (for example `archonsys.io` or a client domain).

4. Click **Add Account**.

5. Enter:

   - Mailbox name (example: `info`)
   - Password

6. Save.

## IMAP/SMTP Settings

For email clients (Outlook, Apple Mail, etc.), use:

- **IMAP server:** `mail.yourdomain.com`
- **IMAP port:** 993 (SSL/TLS)
- **SMTP server:** `mail.yourdomain.com`
- **SMTP port:** 587 (STARTTLS)
- **Authentication:** required (use full email address + password)

