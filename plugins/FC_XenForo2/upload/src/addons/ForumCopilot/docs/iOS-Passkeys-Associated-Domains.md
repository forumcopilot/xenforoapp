# iOS Passkeys: Associated Domains (apple-app-site-association)

For passkey login on iOS, the app must be associated with your forum domain via **Associated Domains**. iOS fetches `https://your-domain/.well-known/apple-app-site-association` and **requires** it to be served with `Content-Type: application/json`. If the server sends a different type (e.g. `application/octet-stream` or no type), you may see:

> Unable to verify webcredentials association of *TEAM_ID.com.example.forumapp* with domain *your-domain*.

## 1. Set Content-Type in the web server (recommended)

Serve the existing file with the correct type so no redirect/rewrite is needed.

### Nginx

Add inside your `server` block (before other `location` blocks that might catch the path):

```nginx
location = /.well-known/apple-app-site-association {
    default_type application/json;
    alias /path/to/xenforo/.well-known/apple-app-site-association;
}
```

Replace `/path/to/xenforo` with your XenForo root (e.g. `/var/www/html` or the path that contains `forumcopilot.php`).

### Apache (.htaccess in site root or in .well-known)

If your XenForo root is the document root, in the root `.htaccess`:

```apache
<Files "apple-app-site-association">
    ForceType application/json
</Files>
```

Or inside `.well-known/.htaccess`:

```apache
<Files "apple-app-site-association">
    ForceType application/json
</Files>
```

## 2. Rewrite to forumcopilot.php (alternative)

If you cannot set Content-Type for the static file, you can serve AASA through the plugin so it always sends `Content-Type: application/json`.

### Nginx

```nginx
location = /.well-known/apple-app-site-association {
    rewrite ^ /forumcopilot.php?aasa=1 last;
}
```

Ensure the `location` that handles `forumcopilot.php` uses `fastcgi_pass` (or equivalent) so the request is executed as PHP.

### Apache

In the XenForo root `.htaccess` (before or after other rules):

```apache
RewriteRule ^\.well-known/apple-app-site-association$ forumcopilot.php?aasa=1 [L,QSA]
```

After changing the server config, reload nginx or restart Apache. Apple caches AASA; changes can take up to a few hours to propagate, but the correct Content-Type often fixes verification immediately on retry.
