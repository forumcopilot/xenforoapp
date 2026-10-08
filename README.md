# Forum App (Standalone XenForo Template)

This repository is an open-source Flutter template for building a **single-forum** mobile app for XenForo communities.

The app connects directly to one XenForo forum through the Forum Copilot add-on endpoint (for example `forumcopilot.php`) and does not require `forumcopilot.com` runtime APIs.

## Forum Copilot: the only full-featured mobile app built specifically for XenForo

[**forumcopilot.com**](https://forumcopilot.com) is the home of this project. Forum Copilot is not a generic forum reader with a XenForo adapter bolted on: it speaks XenForo's own API through a purpose-built add-on, so threads, reactions, polls, attachments, conversations, alerts, custom profile fields, passkeys and push notifications all work the way your members expect. There are two ways to give your community that experience:

| | Hosted Forum Copilot app | Build your own from this template |
|---|---|---|
| **Cost** | Free. The app is free on the [App Store](https://apps.apple.com/app/id6755660616) and [Google Play](https://play.google.com/store/apps/details?id=com.forumcopilot.mobile); hosted push is free too. | Free (MIT), plus your own Apple and Google developer accounts. |
| **Setup** | Install the add-on below; it registers your forum with [forumcopilot.com](https://forumcopilot.com) automatically. Then tell your members. | Install the add-on, edit one config file, build and publish the app yourself. |
| **Branding** | Forum Copilot branding; your forum appears alongside others. | Your name, icon and store listing. |
| **Best for** | Most forums. Try this first and confirm everything works before deciding to build. | Communities that want their own branded app in the stores. |

**Want a branded app without doing the build yourself?** The Forum Copilot team builds and publishes customised, fully branded apps for individual forums, including store listing, push setup and ongoing maintenance. See [forumcopilot.com/support](https://forumcopilot.com/support) or email [forumcopilot@gmail.com](mailto:forumcopilot@gmail.com?subject=Custom%20App%20Development) for a quote.

Project links:

- [CHANGELOG.md](CHANGELOG.md) — what changed in each app release
- [RELEASING.md](RELEASING.md) — how releases are cut and versioned
- [docs/](docs/README.md) — platform guides and the scroll-performance benchmark
- [Add-on changelog](https://forumcopilot.com/addon-changelog) — release notes for the XenForo add-on

---

## Install the XenForo add-on (required for both paths)

Whichever path you choose, your forum needs the **Forum Copilot Mobile App API** add-on. It exposes the `forumcopilot.php` endpoint the app talks to, handles device registration for push, and adds the smart banner that invites web visitors to open the app. The add-on is MIT licensed and its source ships in this repository under [`plugins/FC_XenForo2/`](plugins/FC_XenForo2/); the [add-on changelog](https://forumcopilot.com/addon-changelog) lists the latest version.

1. **Get the add-on.** The simplest way is to visit [forumcopilot.com/console](https://forumcopilot.com/console) and download the latest stable ZIP from there. Or take it directly from GitHub: the source is in [`plugins/FC_XenForo2/upload/`](plugins/FC_XenForo2/upload/); zip that `upload/` folder so the archive contains `upload/src/addons/ForumCopilot/` and `upload/js/ForumCopilot/`.
2. **Install it in XenForo.** In the Admin Control Panel go to **Add-ons**, click **Install/upgrade from archive**, and upload the ZIP. Upgrading an existing install works the same way. (XenForo 2.2 or newer is required, and you need a valid XenForo licence from XenForo Ltd.)
3. **Open the add-on's option page.** Go to **Options → ForumCopilot Options**. The first visit copies `forumcopilot.php` into your forum root, registers your forum with forumcopilot.com, and shows a success or error message plus a single-sign-on link to your forum's page on forumcopilot.com, where you can edit how it is listed in the hosted app (name, description, logo). Push and the smart banner are configured on this options page, not on forumcopilot.com.
4. **Check the endpoint.** It only accepts JSON over POST:
   ```bash
   curl -s -X POST -H 'Content-Type: application/json' -d '{"method":"getConfig"}' https://your.forum/forumcopilot.php
   ```
   should return JSON with `"result":true`, the add-on `version` and XenForo's `systemVersion`.
5. **Try it in the hosted app.** Install Forum Copilot from the App Store or Google Play; your forum is listed as soon as step 3 succeeds. Sign in with a forum account and use it end to end. Push notifications work out of the box on the hosted path.
6. **Then, if you want your own app,** continue with the build steps below and point `lib/config/app_forum_config.dart` at your forum.

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
- **Localization** – 11 languages (English, German, Spanish, French, Italian, Japanese, Korean, Dutch, Portuguese, Russian, Chinese) via `gen-l10n`.
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

### 2. Get your own copy

Click **[Use this template](https://github.com/forumcopilot/xenforoapp/generate)** → *Create a new repository*. You get a repository of your own — private if you like — that starts from a single commit. Clone it:

```bash
git clone https://github.com/<you>/<your-app>.git
cd <your-app>
```

(Or open your existing clone in your editor.)

A template copy shares no history with this repository, so later releases can't simply be merged into it. If you want to keep pulling them in, clone this repository instead, rename its remote with `git remote rename origin upstream`, and push to a repository of your own; `git pull upstream main` then brings in each release like any other merge.

### 3. Configure your forum

Edit `lib/config/app_forum_config.dart` and set at least:

```dart
static const String forumName = 'My XenForo Forum';
static const String forumBaseUrl = 'https://forum.example.com';
static const String pluginEndpoint = 'forumcopilot.php';
```

Optionally set `forumDescription`, `logoUrl`, `backgroundUrl`, `androidPackageName`, and `androidSha256CertFingerprint` as needed. Push has its own section: [Push notifications](#push-notifications-optional).

`forumName` and `forumBaseUrl` can also be overridden at build time without editing the file, which is handy for a CI build, a preview against a staging forum, or the benchmark harness:

```bash
flutter run -d macos \
  --dart-define=FORUM_NAME="My Forum" \
  --dart-define=FORUM_BASE_URL=https://forum.example.com
```

The values committed in `app_forum_config.dart` remain the defaults.

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

This runs `build_runner` in `packages/forumcopilot_sdk` and then `flutter gen-l10n`. On Windows run `buildlib.bat` instead. Re-run it whenever you change an ARB file or an annotated model in the SDK.

### 6. Set your signing team and Firebase files

A fresh clone does not build until two things are in place, even if you never turn on push:

- **Apple signing team.** Open `macos/Runner.xcworkspace` in Xcode, select the Runner target and choose your Team under **Signing & Capabilities**. The template's entitlements (push, associated domains) require one; without it the build stops with `Signing for "Runner" requires a development team`. Do the same in `ios/Runner.xcworkspace` before building for iOS.
- **Firebase config files.** The Xcode projects and the Android build expect `GoogleService-Info.plist` and `google-services.json` to exist, and the repository ships only `*.example` placeholders. Create your Firebase project and download the real files now ([Push notifications](#push-notifications-optional), steps 1 and 2); the rest of the push setup can wait.

### 7. Run the app on macOS

```bash
flutter run -d macos
```

If multiple devices are available, pick `macos` from the list. The app will start and connect to the forum configured in `app_forum_config.dart`.

### 8. (Optional) Build a release macOS app

```bash
flutter build macos
```

The built app is under `build/macos/Build/Products/Release/`. You can sign and distribute it according to Apple’s guidelines.

### macOS-specific notes

- **File picker** – For attachments (e.g. in reply or PM), the app uses the native file picker. macOS entitlements for file access are set in `macos/Runner/DebugProfile.entitlements` and `macos/Runner/Release.entitlements` (e.g. `com.apple.security.files.user-selected.read-write`). See `docs/guides/MACOS_FILE_PICKER_SETUP.md` for details.
- **Firebase (push)** – macOS reads `macos/Runner/GoogleService-Info.plist`; see [Push notifications](#push-notifications-optional).

---

## Push notifications (optional)

Push stays off until you connect the app to **your own Firebase project**. Your app has its own bundle ID and is signed with your own Apple and Google accounts, so its notifications have to go through a Firebase project you own. Forum Copilot's hosted push only serves the official Forum Copilot app; it cannot send to a branded build.

You don't run any extra server. The XenForo add-on sends notifications to Firebase itself, using a key from your Firebase project:

```
alert on your forum → add-on on your forum server → Firebase Cloud Messaging → Apple / Google → your app
```

You need:

- a Google account for the [Firebase console](https://console.firebase.google.com) (the free plan is enough);
- for iOS and macOS, your Apple Developer account, your Team ID, and an APNs auth key (`.p8`) with its Key ID;
- file access to your forum server, to put one key file on it.

Firebase and Apple rename their menus from time to time, so the labels below may drift slightly.

### 1. Settle your app identifiers

Firebase ties each app entry to an exact bundle ID or package name, so set yours before you register anything. All three platforms start as `com.example.forumapp`:

| Platform | Where to change it |
|---|---|
| iOS | Xcode, Runner target, **Signing & Capabilities**: Bundle Identifier and Team (for all build configurations). |
| macOS | `macos/Runner/Configs/AppInfo.xcconfig`, `PRODUCT_BUNDLE_IDENTIFIER`. Set the Team in Xcode as for iOS. |
| Android | `android/app/build.gradle`, `applicationId`. Leave `namespace` as it is: the manifest and `MainActivity.kt` depend on it. |

Also set `androidPackageName` in `lib/config/app_forum_config.dart` to your Android package name (passkeys use it).

Two Android traps:

- **Debug builds add `.xf` to the package name** (`applicationIdSuffix ".xf"` in `android/app/build.gradle`), so `flutter run` installs `your.package.xf`. Register that name in Firebase as a second Android app, or delete the suffix line. Otherwise the debug build fails with `No matching client found for package name`.
- Edit `android/app/build.gradle`. The `build.gradle.kts` next to it is a leftover that Gradle ignores when both files exist.

### 2. Create the Firebase project and register your apps

1. In the Firebase console, create a project.
2. Add an **Apple** app with your iOS bundle ID and download its `GoogleService-Info.plist`.
3. Add an **Android** app with your package name (and the `.xf` debug name if you kept the suffix). Download `google-services.json` after adding every Android app, because the file lists all of them.
4. macOS: if it uses the same bundle ID as iOS, reuse the iOS plist. If not, add it as another Apple app and download its own plist.
5. Copy the files into the project. They are gitignored, so they stay out of your commits:
   ```bash
   cp ~/Downloads/google-services.json     android/app/google-services.json
   cp ~/Downloads/GoogleService-Info.plist  ios/Runner/GoogleService-Info.plist
   cp ~/Downloads/GoogleService-Info.plist  macos/Runner/GoogleService-Info.plist
   ```

The Xcode projects already reference the plist at those paths, and the app reads these native files directly, so you don't need `flutterfire configure` or a `firebase_options.dart`.

### 3. Upload your APNs key to Firebase (iOS and macOS)

This is where the `.p8` goes. Firebase uses it to hand notifications to Apple.

1. If you don't have a key yet: Apple Developer, **Certificates, Identifiers & Profiles → Keys**, create a key with **Apple Push Notifications service (APNs)** enabled. Download the `.p8` (Apple lets you download it only once) and note its Key ID.
2. Firebase console, **Project settings → Cloud Messaging → Apple app configuration**. Under **APNs Authentication Key**, upload the `.p8` and enter its Key ID and your Team ID. Repeat for each Apple app you registered.

One key covers development and App Store builds. The template already carries the push entitlement (`aps-environment` in `ios/Runner/Runner.entitlements` and the macOS entitlements files) and the `remote-notification` background mode in `ios/Runner/Info.plist`. With automatic signing, Xcode enables Push Notifications on your App ID for you; with manual signing, enable it on the identifier in the Apple Developer portal.

### 4. Give the add-on your Firebase service-account key

1. Firebase console, **Project settings → Service accounts → Generate new private key**. This downloads a JSON file. Treat it like a password: whoever holds it can send notifications to your members.
2. Put it on your forum server **outside the web root**, owned by the user PHP runs as and readable only by it, for example `/var/secrets/firebase-sa.json` with `chmod 600`.
3. XenForo Admin CP, **Options → ForumCopilot Options**:
   - **Enable Push Notifications (master)**: on.
   - **Direct push (your own white-label app + Firebase)**: on.
   - **Firebase service-account JSON path**: the absolute path from step 2.

The two switches are on by default; filling in the path is what starts direct push. Leave **Hosted push (official Forum Copilot app)** on if some of your members also use the official Forum Copilot app: each device gets its notifications through whichever service it registered with. The add-on needs PHP's `openssl` and `curl` extensions, which XenForo hosts normally have. Use the current add-on release; private-conversation pushes need v1.8.1 or newer.

### 5. Check the app config and rebuild

In `lib/config/app_forum_config.dart`, `pushSource` must be `'direct'` and `pushApiBaseUrl` must be `''`. Both are the template defaults. Then do a full rebuild (stop the app and `flutter run` again; a hot restart does not pick up the Firebase files).

### 6. Test it

1. Install the app on a real phone, allow notifications, and **sign in** with a forum account. The device registers with your forum only once someone is signed in.
2. From a second account on the website, do something that alerts the first account (mention it, quote it, reply in a thread it watches) or send it a conversation message.
3. The notification should arrive within seconds.

If nothing arrives:

- Turn on **Diagnostic logging** in ForumCopilot Options (add-on v1.8.6 or newer), repeat the test, then read **Admin CP → Logs → Server error log**. A line saying none of the recipients `have logged into the app in the last 90 days` means the device never registered: sign out and back in on the phone and check `pushSource`. Turn the option off again afterwards; it is noisy.
- Problems with the key file (wrong path, unreadable, rejected by Google) are logged there even with diagnostic logging off.
- Android works but iOS doesn't: the APNs key is missing in Firebase, was uploaded under a different Team ID, or the bundle ID in `GoogleService-Info.plist` doesn't match the app's.

---

## Tests and benchmarks

Unit and widget tests run without a device or network access to a forum:

```bash
flutter test
```

The live API suite in `packages/xenforo_core` runs the SDK's proxy tests against a real forum with the add-on installed. It writes to that forum, so use a throwaway instance. Copy `test/config.json.example` to `test/config.json`, fill in the forum URL, a test account and a few content ids, then:

```bash
cd packages/xenforo_core && flutter test test/xenforo_basic_tests.dart
```

Scroll performance is measured on a real phone with `flutter drive --profile`. The harness, the recorded baseline, and the traps that produce misleading numbers are documented in [docs/perf-benchmarking.md](docs/perf-benchmarking.md). Run it before and after any change to the topic list, thread view or home feed.

For the full local setup, from a local XenForo with the add-on through ngrok to the app running on a phone, see [docs/guides/LOCAL_E2E_TESTING.md](docs/guides/LOCAL_E2E_TESTING.md).

---

## Contributing

Issues and pull requests are welcome at https://github.com/forumcopilot/xenforoapp. To contribute, **fork** the repository rather than using the template: a pull request needs the shared history that a template copy starts without.

- Run `flutter analyze` and `flutter test` before opening a pull request; both run in CI.
- Keep `lib/config/app_forum_config.dart` on the template placeholders. Point a build at a real forum with `--dart-define` instead.
- Commit messages follow the conventional `type(scope): summary` form used in the history; `RELEASING.md` explains how they roll up into release notes.
- Changes to the SDK or XenForo packages need their code generators re-run (see step 5 above and `CLAUDE.md`).

---

## Open-source safety checklist

Before publishing your app:

1. Confirm forum URL and branding values in `app_forum_config.dart`.
2. Confirm the Firebase files come from your own Firebase project, and keep them out of version control (they are gitignored).
3. Set your own bundle/application IDs for Android/iOS/macOS ([where](#1-settle-your-app-identifiers)).
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
