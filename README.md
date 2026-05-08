# Forum App (Standalone XenForo Template)

This repository is an open-source Flutter template for building a **single-forum** mobile app for XenForo communities.

The app connects directly to one XenForo forum through the Forum Copilot add-on endpoint (for example `forumcopilot.php`) and does not require `forumcopilot.com` runtime APIs.

---

## Features

This app provides a full-featured forum experience for a single XenForo site:

### Browsing & discovery
- **Forums** – Browse forum list and nodes; view subscribed forums.
- **Topics** – Latest, unread, subscribed, and participated topic lists with infinite scroll.
- **Search** – Forum-wide search (topics and posts).
- **Members** – Member list and member search.

### Reading & content
- **Thread view** – Read threads with post list, BBCode rendering, and rich content (tables, code, quotes).
- **Attachments** – View images and files; full-screen image viewer and attachment carousel.
- **Polls** – View and vote in thread polls.
- **Link previews** – Inline link preview cards (Twitter/YouTube degrade to normal links in standalone mode).

### Posting & participation
- **New topic** – Create threads with optional poll.
- **Reply** – Reply to threads with BBCode editor.
- **Edit post** – Edit your own posts.
- **Attachments** – Add images (camera/gallery) and files (e.g. PDFs) when composing; image compression and file picker (including native macOS file picker).

### Private messaging
- **Conversations** – Modern conversation-style private messages (when enabled by forum).
- **Traditional PM** – Inbox/sent style private messages.
- **Compose** – New conversation or PM, reply, edit; attachments and BBCode.

### Account & profile
- **Login / logout** – Session with optional “remember me”.
- **Registration** – Create account with custom registration fields when enabled.
- **Forgot password** – Password reset flow.
- **Profile** – View profile, avatar, recent posts, and custom profile fields.
- **Profile picture** – Change avatar from device or camera.
- **Passkeys** – Sign in with passkeys where supported (requires Android/iOS app and assetlinks/AASA configured).

### Notifications & alerts
- **Alerts** – In-app alerts list (when enabled by forum).
- **Push notifications** – Optional Firebase-based push (disabled by default; requires config).

### Settings & UX
- **Forum settings** – Per-category settings from XenForo (when provided by add-on).
- **Notification settings** – Control push and in-app notification behavior.
- **Localization** – Multi-language support (e.g. English, Spanish, Italian) via `gen-l10n`.
- **Theme** – Material Design with forum-aware styling.

### Technical
- **Single-forum** – No forum chooser; app is tied to one forum via config.
- **XenForo API** – Uses `xenforo_core` and Forum Copilot add-on API.
- **Platforms** – Android, iOS, macOS, web, Windows, Linux (Flutter).

---

## Prerequisites

- **Flutter SDK** `^3.6.1`
- **Dart SDK** `^3.6.1`
- **Xcode** (for iOS and macOS builds)
- **Android Studio / Android SDK** (for Android builds)

---

## Build and run on macOS

Follow these steps to build and start the app on macOS.

### 1. Install Flutter and Xcode

- Install the [Flutter SDK](https://docs.flutter.dev/get-started/install) and ensure `flutter` is on your `PATH`.
- Install **Xcode** from the Mac App Store and open it once to accept the license. Install the Xcode Command Line Tools if prompted:
  ```bash
  xcode-select --install
  ```
- Confirm Flutter sees your environment:
  ```bash
  flutter doctor
  ```
  Fix any reported issues (e.g. Xcode license, Android licenses) before continuing.

### 2. Clone and open the project

```bash
git clone https://github.com/forumcopilot/xenforoapp.git
cd xenforoapp
```

(Or open your existing clone in your editor.)

### 3. Configure your forum

Edit `lib/config/app_forum_config.dart` and set at least:

```dart
static const String forumName = 'My XenForo Forum';
static const String forumBaseUrl = 'https://forum.example.com';
static const String pluginEndpoint = 'forumcopilot.php';
```

Optionally set `forumDescription`, `logoUrl`, `backgroundUrl`, `pushApiBaseUrl`, `androidPackageName`, and `androidSha256CertFingerprint` as needed.

### 4. Install dependencies

From the project root:

```bash
flutter pub get
```

### 5. Generate SDK and localizations

The app uses local packages (`forumcopilot_sdk`, `xenforo_core`) and generated localizations. Run:

```bash
./buildlib.sh
```

This runs `build_runner` in `packages/forumcopilot_sdk` and then `flutter gen-l10n`. On Windows use the equivalent steps (e.g. run the SDK build and `flutter gen-l10n` manually).

### 6. Run the app on macOS

```bash
flutter run -d macos
```

If multiple devices are available, pick `macos` from the list. The app will start and connect to the forum configured in `app_forum_config.dart`.

### 7. (Optional) Build a release macOS app

```bash
flutter build macos
```

The built app is under `build/macos/Build/Products/Release/`. You can sign and distribute it according to Apple’s guidelines.

### macOS-specific notes

- **File picker** – For attachments (e.g. in reply or PM), the app uses the native file picker. macOS entitlements for file access are set in `macos/Runner/DebugProfile.entitlements` and `macos/Runner/Release.entitlements` (e.g. `com.apple.security.files.user-selected.read-write`). See `docs/guides/MACOS_FILE_PICKER_SETUP.md` for details.
- **Firebase (push)** – To enable push on macOS, add your `GoogleService-Info.plist` under `macos/Runner/` (see “Configure Firebase” below).

---

## Push notifications (optional)

Push notifications are **disabled by default**. The app needs two things to deliver them:

- A **Firebase project** that issues `GoogleService-Info.plist` (iOS/macOS) and `google-services.json` (Android), each registered with your app's bundle ID / package name.
- A **dispatcher** that takes alert events from the XenForo `forumcopilot.php` addon and turns them into FCM/APNs pushes.

You have three ways to set this up. Pick the one that matches your operational comfort:

| Path | Where Firebase lives | Where the dispatcher lives | Best for |
|---|---|---|---|
| **1. Hosted ForumCopilot Push** | ForumCopilot's project | ForumCopilot's backend | Anyone who doesn't want to manage Firebase or run a backend |
| **2. BYO Firebase + direct dispatch** | Your project | Inside the addon (no extra backend) | Self-hosters who own their stack but don't want to write a dispatcher |
| **3. BYO Firebase + your own dispatch backend** | Your project | Your own server | Advanced — you have a custom routing requirement that doesn't fit modes 1 or 2 |

### Path 1 — Hosted ForumCopilot Push (managed, easiest)

ForumCopilot Push is a managed service that handles the Firebase project AND the dispatcher for you. You provide your iOS bundle ID, Android package name, and an APNs auth key (`.p8`) generated in your Apple Developer account; ForumCopilot issues the `GoogleService-Info.plist` / `google-services.json` your build needs and gives you a push API endpoint.

Setup overview (see https://forumcopilot.com for full details and pricing):

1. Sign up at https://forumcopilot.com and register your forum.
2. Provide your iOS bundle ID, Android package name, and macOS bundle ID in the dashboard.
3. Upload an APNs auth key (`.p8`) and your Apple Team ID.
4. Download the issued config files and drop them into your project:
   ```bash
   # files come from your ForumCopilot dashboard
   cp ~/Downloads/google-services.json     android/app/google-services.json
   cp ~/Downloads/GoogleService-Info.plist  ios/Runner/GoogleService-Info.plist
   cp ~/Downloads/GoogleService-Info.plist  macos/Runner/GoogleService-Info.plist
   ```
5. In `lib/config/app_forum_config.dart`:
   - Set `pushApiBaseUrl` to the endpoint shown in your dashboard.
   - Leave `pushSource = 'forumcopilot'` (the default).
6. Install the ForumCopilot xenForo addon (under `plugins/FC_XenForo2/`) and paste your customer API key into its admin settings so the addon can talk to ForumCopilot Push.

### Path 2 — Bring your own Firebase + direct dispatch from the addon

The most self-hosted path that doesn't require running an extra service. The addon (v1.3.4 or newer) ships its own FCM HTTP v1 client and can dispatch notifications **directly** using your Firebase service-account JSON. No separate dispatcher process needed.

1. Create your own Firebase project. Register your iOS/macOS/Android apps in it (one entry per platform).
2. Download the resulting Firebase config files into your project:
   ```bash
   cp ~/Downloads/google-services.json     android/app/google-services.json
   cp ~/Downloads/GoogleService-Info.plist  ios/Runner/GoogleService-Info.plist
   cp ~/Downloads/GoogleService-Info.plist  macos/Runner/GoogleService-Info.plist
   ```
3. In **Firebase Console → Project Settings → Service accounts → Generate new private key**, download the service-account JSON and upload it to your XenForo server, *outside* the web root for security (e.g. `/var/secrets/firebase-sa.json`).
4. In `lib/config/app_forum_config.dart`:
   - Set `pushSource = 'direct'`.
   - Leave `pushApiBaseUrl = ''` (empty — there is no separate backend).
5. Install the ForumCopilot xenForo addon (`plugins/FC_XenForo2/`). In **Admin CP → Options → ForumCopilot Options**:
   - Enable the master push toggle.
   - Enable **"Direct push (your own white-label app + Firebase)"**.
   - Set **"Firebase service-account JSON path"** to the absolute path from step 3.

When users open the app, it registers their FCM token directly with your XenForo server via the `registerDevice` plugin API. When a notification fires, the addon's dispatch router reads the token from `xf_fc_device_token` and POSTs to FCM HTTP v1 using your service-account credentials.

### Path 3 — Bring your own Firebase + custom dispatch backend (advanced)

For unusual setups where you need a custom routing layer between the addon and FCM (e.g. multi-region routing, custom analytics, fan-out to non-FCM channels):

1. Same Firebase setup as Path 2.
2. In `lib/config/app_forum_config.dart`:
   - Set `pushApiBaseUrl` to your backend's base URL (e.g. `https://push.example.com/api`).
   - Leave `pushSource = 'forumcopilot'` (the controller will register tokens with your backend the same way the hosted backend would).
3. Stand up a push backend that:
   - accepts FCM token registrations from the app at `POST <pushApiBaseUrl>/...` endpoints
   - receives notification events from the `forumcopilot.php` addon and dispatches them via the FCM HTTP v1 API
4. Configure the `forumcopilot.php` addon's hosted-push admin options to point at your backend.

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

---

## License

This project is licensed under the MIT License — see [LICENSE](LICENSE) for the full text.

The `plugins/FC_XenForo2/` add-on is also released under MIT, but installing or running it on a XenForo forum still requires a valid XenForo license from XenForo Ltd.
