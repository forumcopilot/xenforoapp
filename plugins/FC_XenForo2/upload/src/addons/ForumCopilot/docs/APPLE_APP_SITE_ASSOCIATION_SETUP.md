# Apple App Site Association — Webserver Setup for Passkeys

This guide helps forum owners properly configure their webserver so that **Passkey authentication** works correctly in the Forum Copilot mobile app.

---

## Why This File Is Required for Passkeys

Passkeys (WebAuthn) use cryptographic keys instead of passwords. On Apple devices, passkeys are stored in **iCloud Keychain** and can be shared between:

1. **Your forum website** (where users register passkeys via Account → Security → Add Passkey)
2. **The Forum Copilot iOS app** (where users sign in with "Sign in with Passkey")

For this sharing to work, Apple needs to know that your website and the Forum Copilot app are **associated**. The `apple-app-site-association` file does exactly that: it tells Apple that your forum domain is linked to the Forum Copilot app, so passkeys created on the web can be used in the app and vice versa.

**Without this file configured correctly:**

- Users who register a passkey on your forum website **cannot** use it to sign in to the Forum Copilot app
- Users who create a passkey in the app **cannot** use it on the forum website
- Passkey-based login and passkey 2FA in the app will fail

---

## Privacy and Security

This process is **fully secure**. The `apple-app-site-association` file contains only public information: it states that your domain is linked to the Forum Copilot app for passkey sharing. It does **not** contain any secrets, credentials, or member data.

**Neither the Forum Copilot team nor anyone else can access your private or sensitive information** through this file. We have no ability to:

- Access your server, database, or file system
- View member usernames, passwords, emails, or other personal data
- Read or modify any content on your forum

Passkeys themselves are created and stored locally on each user's device (and in iCloud Keychain on Apple devices). They are never transmitted to our servers or anyone else—they stay under the user's control.

---

## How the File Is Installed

The **Forum Copilot** add-on does **not** modify your server files or the `.well-known` directory. You must install the file yourself (or have your host do it).

A template file is included in the add-on package for reference: look for `apple-app-site-association` in the add-on directory. Copy it to your server as described below.

### Manual File Creation

Create a file named `apple-app-site-association` (no extension) with this content:

```json
{
  "webcredentials": {
    "apps": [
      "3F2M6VD2P8.com.forumcopilot.mobile"
    ]
  }
}
```

Place it in the `.well-known` directory at your forum root (e.g. `upload/.well-known/apple-app-site-association` for a standard XenForo install).

---

## Forums in a Subdirectory (e.g. /forums/)

If your forum is **not** at the root of your domain—for example, it lives at `https://example.com/forums/` instead of `https://example.com/`—you must place the file at the domain root (see below), not under your forum path.

Apple requires the file at the **domain root**:

- ✅ Correct: `https://example.com/.well-known/apple-app-site-association`
- ❌ Incorrect: `https://example.com/forums/.well-known/apple-app-site-association`

For subdirectory installs, add the file at the root level of your server (e.g. `example.com/.well-known/`), not under the forum path (e.g. `example.com/forums/.well-known/`).

### What to do

1. Create the `apple-app-site-association` file with the JSON content from [Manual File Creation](#manual-file-creation-if-needed) above.
2. Create a `.well-known` directory at your **domain root** (the directory that contains your `forums/` folder or equivalent).
3. Place the file at: `{domain_root}/.well-known/apple-app-site-association`
4. Configure your webserver (Apache, nginx, etc.) so that `https://your-domain/.well-known/apple-app-site-association` serves this file with `Content-Type: application/json`.

You may need to involve your hosting provider if you do not have access to the domain root directory.

---

## Setting the Content-Type

Apple requires the file to be served with **`Content-Type: application/json`**. If it is served with the wrong type (e.g. `text/plain` or `application/octet-stream`), passkey association may fail.

### Apache

If you use Apache, add or edit a `.htaccess` file in `.well-known/` to set the header. This requires **mod_headers** to be enabled.

If the header is not set correctly, add or verify `.well-known/.htaccess` contains:

```apache
<Files "apple-app-site-association">
  Header set Content-Type "application/json"
</Files>
```

Or add this in your main `.htaccess` or virtual host:

```apache
<IfModule mod_headers.c>
  <FilesMatch "apple-app-site-association">
    Header set Content-Type "application/json"
  </FilesMatch>
</IfModule>
```

### Nginx

Nginx does not use `.htaccess`. Add this inside your `server` block:

```nginx
location = /.well-known/apple-app-site-association {
    default_type application/json;
}
```

If your forum root is different from the server root:

```nginx
location = /.well-known/apple-app-site-association {
    default_type application/json;
    alias /path/to/your/forum/.well-known/apple-app-site-association;
}
```

### Other Servers (Caddy, LiteSpeed, etc.)

Configure the server to serve `/.well-known/apple-app-site-association` with:

```
Content-Type: application/json
```

---

## Apple's Requirements

For the association to work, the file must meet these conditions:

| Requirement | Details |
|-------------|---------|
| **HTTPS** | Must be served over HTTPS. HTTP will not work. |
| **HTTP 200** | Must return status 200. No redirects (301, 302). |
| **Content-Type** | Must be `application/json`. |
| **Publicly accessible** | Must be reachable without authentication. |
| **No blocking** | Must not be blocked by `robots.txt` or firewall rules. |
| **Exact path** | Must be at `https://your-domain/.well-known/apple-app-site-association`. |

---

## Verifying Your Setup

### 1. Check the file is reachable

```bash
curl -I https://your-forum.com/.well-known/apple-app-site-association
```

You should see:

```
HTTP/2 200
content-type: application/json
```

### 2. Check the response body

```bash
curl https://your-forum.com/.well-known/apple-app-site-association
```

Expected output:

```json
{
  "webcredentials": {
    "apps": [
      "3F2M6VD2P8.com.forumcopilot.mobile"
    ]
  }
}
```

### 3. Use Apple's validator (optional)

Apple provides an [App Search Validation Tool](https://search.developer.apple.com/appsearch-validation-tool/) that can verify the file.

---

## Troubleshooting

| Problem | Possible cause | Solution |
|--------|----------------|---------|
| 404 Not Found | File not installed or wrong path | Reinstall the add-on or manually create the file in `.well-known/` |
| Forum at subdirectory (e.g. /forums/) | Apple needs file at domain root | Place the file at your domain root. See [Forums in a Subdirectory](#forums-in-a-subdirectory-eg-forums) |
| Wrong Content-Type | Server not setting `application/json` | Add Apache `.htaccess` or nginx `default_type` as shown above |
| 301/302 redirect | HTTPS redirect or trailing-slash redirect | Ensure the URL returns 200 directly; avoid redirects |
| Passkey still not working | Cache or propagation delay | Wait a few minutes; clear any CDN cache; retry in the app |

---

## Summary

1. **Why:** The `apple-app-site-association` file links your forum domain to the Forum Copilot app so passkeys can be shared between the website and the app.
2. **Security:** The file contains only public association data. No one—including the Forum Copilot team—can access your server or member information through it.
3. **Installation:** You must install the file yourself (the add-on does not modify `.well-known/`). Place it at your domain root (e.g. `https://your-domain/.well-known/apple-app-site-association`). If your forum is in a subdirectory (e.g. `/forums/`), the file still goes at the domain root.
4. **Content-Type:** Serve the file with `Content-Type: application/json` via Apache `.htaccess`, nginx `default_type`, or equivalent.
5. **Verify:** Use `curl` to confirm the file returns 200 and `application/json`.
