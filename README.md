# Forum App (Standalone XenForo Template)

This repository is an open-source Flutter template for building a **single-forum** mobile app for XenForo communities.

The app connects directly to one XenForo forum through the Forum Copilot add-on endpoint (for example `forumcopilot.php`) and does not require `forumcopilot.com` runtime APIs.

---

## What this template includes

- Single-forum startup flow (no forum chooser/search/explore screens)
- XenForo add-on API integration (`xenforo_core`)
- Optional push backend support (disabled by default)
- Android/iOS/macOS Firebase config files included as **placeholders** (no production keys)
- Platform identifiers set to generic template values (`com.example.forumapp`)

---

## Prerequisites

- Flutter SDK `^3.6.1`
- Dart SDK `^3.6.1`
- Xcode (for iOS/macOS builds)
- Android Studio / Android SDK (for Android builds)

---

## Development setup

### 1) Configure your forum

Edit:

- `lib/config/app_forum_config.dart`

Set at minimum:

```dart
static const String forumName = 'My XenForo Forum';
static const String forumBaseUrl = 'https://forum.example.com';
static const String pluginEndpoint = 'forumcopilot.php';
```

Optional:

- `pushApiBaseUrl` (leave empty to keep push backend disabled)
- `androidPackageName`
- `androidSha256CertFingerprint` (for Android passkey association checks)

---

### 2) Configure Firebase (optional, required for push)

This repository ships with sanitized Firebase template files:

- `android/app/google-services.json.example`
- `ios/Runner/GoogleService-Info.plist.example`
- `macos/Runner/GoogleService-Info.plist.example`

Before enabling push notifications, create the real files by copying the templates:

```bash
cp android/app/google-services.json.example android/app/google-services.json
cp ios/Runner/GoogleService-Info.plist.example ios/Runner/GoogleService-Info.plist
cp macos/Runner/GoogleService-Info.plist.example macos/Runner/GoogleService-Info.plist
```

---

### 3) Install dependencies

```bash
flutter pub get
```

---

### 4) Run the app

```bash
flutter run
```

The app will initialize the configured XenForo forum immediately at startup.

---

## Open-source safety checklist

Before publishing your own fork:

1. Confirm forum URL and branding values in `app_forum_config.dart`.
2. Confirm Firebase files are your own values (or keep placeholders if push is disabled).
3. Set your own bundle/application IDs for Android/iOS/macOS.
4. Set your Apple Development Team in Xcode project settings before signing.
5. Configure passkey association files (`assetlinks.json`, `apple-app-site-association`) with your package/team IDs and certificate fingerprints.

---

## Notes

- Translation and cloud media enrichment were intentionally removed in standalone mode.
- Twitter/YouTube rich cards degrade to normal links.
- Runtime forum discovery APIs are not used by this app template.

