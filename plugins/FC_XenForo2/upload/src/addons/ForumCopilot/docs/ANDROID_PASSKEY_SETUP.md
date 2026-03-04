# Android Passkey Setup — Digital Asset Links (assetlinks.json)

This guide helps forum owners enable **passkey credential sharing** between your forum website and the **Forum Copilot Android app**.

---

## Installation (manual)

The **Forum Copilot** add-on does **not** modify your server files or the `.well-known` directory. You must install the file yourself (or have your host do it).

A template file **assetlinks.json** is included in the add-on package for reference (in the add-on directory).

The template contains a **placeholder** SHA-256 fingerprint (`00:00:...`). Copy the file to your server and replace the placeholder with the real SHA-256 of the app’s signing certificate (see below).

**Target file location:**  
`{forum_root}/.well-known/assetlinks.json` (or at your domain root; see "Where the file must be served").

**URL:**  
`https://your-forum-domain/.well-known/assetlinks.json`

---

## Why this file is required on Android

On Android, passkeys use the **Credential Manager** API. For passkeys created on your **forum website** to be offered when signing in from the **Forum Copilot app**, Android needs the domain and the app to be linked via Digital Asset Links.

- **Without** a valid `assetlinks.json` (with the correct SHA-256), passkeys created only on the web may not be suggested in the app.
- **With** it correctly set up, users can use the same passkey for both the forum website and the app.

---

## App details for assetlinks.json

| Field | Value |
|-------|--------|
| **Android package name** | `com.example.forumapp` |
| **SHA-256 fingerprint** | Replace the placeholder in the installed file with the **release** signing key fingerprint (see below). |

---

## Replace the placeholder SHA-256

### Option A: Play App Signing (Play Store builds)

If Forum Copilot is distributed via Google Play, get the SHA-256 from:

1. **Play Console** → Your app → **Setup** → **App signing** → **App signing key certificate** → SHA-256 certificate fingerprint.
2. Or use the fingerprint provided by the Forum Copilot team for the released app.

### Option B: Your own release keystore

If you build and sign the app yourself:

```bash
keytool -list -v -keystore path/to/your-release.keystore -alias your-alias
```

Copy the **SHA256** line (format with colons is fine, e.g. `AB:CD:EF:...`).

### Option C: Debug builds (testing on device/emulator)

If you run the app from Android Studio or `flutter run`, it is signed with the **debug** keystore. Its SHA-256 is different from the release key. If `assetlinks.json` only lists the release fingerprint, you will see **"RP ID cannot be validated"** when using passkey login on a debug build.

To fix this, add the debug certificate fingerprint to `sha256_cert_fingerprints` (you can list multiple fingerprints in the same array):

```bash
# Default debug keystore (Windows)
keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android

# Default debug keystore (macOS/Linux)
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android
```

Copy the **SHA256** value and add it to the `sha256_cert_fingerprints` array in `assetlinks.json` on your server. Keep the release fingerprint if you already have it; both can coexist.

### Edit the file on the server

1. Open `{forum_root}/.well-known/assetlinks.json` on your server.
2. Ensure the file declares both targets:
   - `namespace: "web"` with your forum domain (for example `https://forum.example.com`)
   - `namespace: "android_app"` with package + signing fingerprints
3. Replace the placeholder fingerprint in `sha256_cert_fingerprints` with your real SHA-256. You can list multiple fingerprints (e.g. release and debug) in the array.
4. Save. Ensure the file is still valid JSON.

Example after edit:

```json
[
  {
    "relation": [
      "delegate_permission/common.get_login_creds",
      "delegate_permission/common.handle_all_urls"
    ],
    "target": {
      "namespace": "web",
      "site": "https://forum.example.com"
    }
  },
  {
    "relation": [
      "delegate_permission/common.get_login_creds",
      "delegate_permission/common.handle_all_urls"
    ],
    "target": {
      "namespace": "android_app",
      "package_name": "com.example.forumapp",
      "sha256_cert_fingerprints": [
        "AB:CD:EF:12:34:56:78:90:AB:CD:EF:12:34:56:78:90:AB:CD:EF:12:34:56:78:90:AB:CD:EF:12:34:56:78:90:AB:CD"
      ]
    }
  }
]
```

---

## Where the file must be served

- **URL:** `https://your-forum-domain/.well-known/assetlinks.json`
- Use the **same domain** as your forum’s board URL (the WebAuthn rpId).

If your forum is in a subdirectory (e.g. `https://example.com/forums/`), the file must still be at the **domain root**:

- Correct: `https://example.com/.well-known/assetlinks.json`
- Incorrect: `https://example.com/forums/.well-known/assetlinks.json`

For subdirectory installs you may need to place the file at the domain root (not under the forum path).

---

## Server requirements

- **Content-Type:** `application/json`
- **HTTPS** required
- **HTTP 200** response (no redirects)
- Publicly accessible

---

## Verification

1. Open `https://your-forum-domain/.well-known/assetlinks.json` in a browser and confirm valid JSON with your SHA-256.
2. Use Google’s [Digital Asset Links tester](https://developers.google.com/digital-asset-links/tools/generator) to validate.

---

## Summary

| Platform | File | Purpose |
|----------|------|---------|
| **iOS** | `apple-app-site-association` | Links domain to app for passkey sharing ([APPLE_APP_SITE_ASSOCIATION_SETUP.md](APPLE_APP_SITE_ASSOCIATION_SETUP.md)). |
| **Android** | `assetlinks.json` | Links domain to app for passkey credential sharing (this document). Manual install; replace the SHA-256 fingerprint in the template. |
