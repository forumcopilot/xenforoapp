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
- A **push backend** that stores the FCM device tokens registered by the app and relays notification events from the XenForo `forumcopilot.php` plugin to FCM/APNs.

You have two ways to set this up.

### Option 1 — Use ForumCopilot Push (hosted, recommended for most forks)

If you want to ship a forum app without standing up your own Firebase project or push server, **ForumCopilot Push** is a managed service that handles both halves for you. You provide your iOS bundle ID, Android package name, and an APNs auth key (`.p8`) generated in your Apple Developer account; ForumCopilot issues the `GoogleService-Info.plist` / `google-services.json` your build needs and gives you a push API endpoint to point the app at.

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
5. Set `pushApiBaseUrl` in `lib/config/app_forum_config.dart` to the endpoint shown in your dashboard.
6. Install the XenForo `forumcopilot.php` plugin (under `plugins/FC_XenForo2/`) and paste your customer API key into its admin settings so the plugin can talk to ForumCopilot Push.

### Option 2 — Run your own Firebase project + push backend

If you'd rather host everything yourself:

1. Create your own Firebase project and register your iOS/macOS/Android apps in it.
2. Copy the example configs into place and replace with your own:
   ```bash
   cp android/app/google-services.json.example android/app/google-services.json
   cp ios/Runner/GoogleService-Info.plist.example ios/Runner/GoogleService-Info.plist
   cp macos/Runner/GoogleService-Info.plist.example macos/Runner/GoogleService-Info.plist
   ```
3. Stand up a push backend that:
   - accepts FCM token registrations from the app at `POST <pushApiBaseUrl>/...` endpoints
   - receives notification events from the `forumcopilot.php` plugin and dispatches them via the FCM HTTP v1 API
4. Set `pushApiBaseUrl` in `lib/config/app_forum_config.dart` to your backend's base URL (e.g. `https://push.example.com/api`).
5. Configure the `forumcopilot.php` plugin to send events to your backend.

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
