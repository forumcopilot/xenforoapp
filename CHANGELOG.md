# Changelog

All notable changes to this project are documented in this file.

The format is inspired by [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html). Releases below 1.0 should not be assumed backward-compatible across minor bumps.

## [Unreleased]

## [0.9.0] - 2026-08-04

Multi-reaction support for posts and direct messages — tap-to-choose Like/Love/Haha/etc. instead of a like-only button — plus a hardened photo-upload path and a Google Play policy fix. Ships with bundled ForumCopilot addon v1.8.1 (up from v1.4.5), which brings private-conversation push and the server side of multi-reactions.

### Added
- Tap-to-choose reactions for posts and conversation (DM) messages. The reaction picker wraps and scrolls to fit any number of admin-defined reactions, shows which reaction you picked, and lists who reacted with what. Image-based custom reactions map to native emoji generically via XenForo's own "Emoji replacement" field — no per-forum hardcoding. Requires bundled addon v1.8.0+ for the server side; with older addons the like-only flow keeps working.

### Fixed
- Large phone photos no longer fail to upload with an opaque error on servers with a modest nginx `client_max_body_size`. Images are downscaled to a max longest edge and iteratively re-compressed to a hard byte ceiling before base64 upload — app-side only, no server change required.
- Direct-mode push device registration now triggers on login as well as app start, so a device that opens the app logged-out still registers for push once the user authenticates. Push logs are release-safe.
- Dropped the `READ_MEDIA_IMAGES` Android permission (the photo picker uses `ACTION_PICK_IMAGES` and never needed it), which otherwise triggers Google Play's Photo and Video Permissions policy review when publishing a fork to the Play Store.

### Bundled addon (v1.4.5 → v1.8.1)
- Private-conversation (DM) push notifications: XenForo creates no alert rows for PMs, so the addon now pushes them via its own conversation-message listener, in both hosted and BYO-direct dispatch modes.
- Server side of multi-reactions: `/getConfig` returns the forum's full reaction set, and reactions apply through XenForo's `ReactionRepository::reactToContent()`.
- Fixed: reacting to a DM no longer sends a spurious "new message" push to the reactor; XenForo's built-in sprite-sheet reactions (Like/Love/Haha/…) now map to native emoji instead of a placeholder icon.
- Full addon changelog: https://forumcopilot.com/addon-changelog

[0.9.0]: https://github.com/forumcopilot/xenforoapp/releases/tag/v0.9.0

## [0.8.0] - 2026-05-12

Online Users list now shows what each member is doing, matching the web `/online/` page. Plus a build-config fix that lets the signed APK install on older / non-mainstream Android devices.

### Added
- Each row in the Online Users list (Members tab → Online) now shows a human-readable activity string below the username — e.g. "Viewing thread Foo", "Using Forum Copilot Mobile App", "Viewing list of online members". Matches what XF's web `/online/` page renders. Falls back to user title (`displayText`) for older Forum Copilot addon versions that don't populate the field.
- New `currentActivityUrl` field on `FCUser` plumbed through the SDK and `XenForoUserProxy`. Present in the API response (ForumCopilot addon v1.4.4+) but not consumed by UI yet — there for future use (e.g. tappable activity rows).

### Fixed
- Android release APK now signs with v1 + v2 + v3 schemes (previously v2/v3 only). The APK was installable on modern Pixel/Samsung but rejected on older devices and some OEMs that still validate v1 (JAR) signatures, producing an opaque "App not installed" error. v1 + v2 + v3 covers the full installed base.

[0.8.0]: https://github.com/forumcopilot/xenforoapp/releases/tag/v0.8.0

## [0.7.0] - 2026-05-08

Adds first-class support for **BYO Firebase + direct dispatch** push notifications. White-label and self-hosted forks can now run push without standing up a separate dispatcher backend — the ForumCopilot xenForo addon (v1.3.4+) ships its own FCM HTTP v1 client and dispatches directly using a service-account JSON.

### Added
- New `IFCDeviceProxy` SDK interface and `XenForoDeviceProxy` implementation, exposing `registerDevice` / `unregisterDevice` / `updateDeviceToken` against the `forumcopilot.php` plugin endpoint. Used by direct-mode builds to register an FCM token with the customer's own XenForo server (writes to `xf_fc_device_token`).
- New `AppForumConfig.pushSource` constant gating which push registration path runs at app startup. `'forumcopilot'` (default) keeps the existing hosted-backend flow. `'direct'` activates the new direct-mode flow described above.
- `PushNotificationController` now performs direct-mode device registration on init when `pushSource == 'direct'`, watches login state to retry once the user authenticates, and re-registers on FCM token rotation. Calls `unregisterDirect()` cleanly on logout.
- `SiteProxyService.getDeviceProxy()` shortcut for direct-mode callers.

### Changed
- `PushNotificationService.registerDeviceForSite`, `updateDeviceToken`, and `testConnection` now short-circuit to a no-op when `pushApiBaseUrl` is empty. BYO-direct builds set the URL empty since there is no hosted backend, and the previous behavior was to spam logs probing a non-existent URL.
- `README.md` push-notifications section rewritten as three labelled setup paths (hosted / BYO direct / BYO custom backend) with a comparison table, replacing the previous two-option layout that pushed self-hosters toward running a custom backend they didn't actually need.

### Notes for forks
- This release is **backward compatible** for builds already configured with `pushApiBaseUrl` and the hosted ForumCopilot Push backend — `pushSource` defaults to `'forumcopilot'`, behavior is unchanged.
- To opt into direct mode: set `pushSource = 'direct'`, set `pushApiBaseUrl = ''`, and configure the addon's "Direct push" admin options with a Firebase service-account JSON path. See README.md "Path 2" for the full walkthrough.
- The XenForo addon must be at least version 1.3.4 for the direct-dispatch endpoint to exist on the server.

[0.7.0]: https://github.com/forumcopilot/xenforoapp/releases/tag/v0.7.0

## [0.6.1] - 2026-05-08

Quality-of-life patch release. Three forks-driven improvements moved upstream so anyone cloning the template gets a cleaner default build and a more fork-friendly compose signature.

### Fixed
- Thread action menu now shows proper "Subscribe" / "Unsubscribe" labels instead of lowercase "subscribe to" / "unsubscribe from" (the lowercase variants were designed for sentence interpolation like "Please login to subscribe to this thread" and read awkwardly as standalone menu items). New menu-label l10n entries added across all 11 supported locales; sentence-interpolation entries unchanged.
- Removed a stale `[Firebase Crashlytics] Upload dSYM` build phase from the iOS Xcode project. The phase referenced `${PODS_ROOT}/FirebaseCrashlytics/run`, but `firebase_crashlytics` was already dropped from `pubspec.yaml` in v0.6.0, so the script path no longer existed after `pod install` and iOS builds failed with "No such file or directory". Projects that want crash reporting can re-add the package and let pod install set up the build phase fresh.

### Changed
- The "Sent from Forum Copilot mobile app" signature in the message composer now reads `Sent from <AppForumConfig.forumName> mobile app`. White-label forks already edit `AppForumConfig.forumName` for branding; the signature now picks that up automatically. The hosted Forum Copilot multi-tenant app uses a different codebase and is unaffected.

[0.6.1]: https://github.com/forumcopilot/xenforoapp/releases/tag/v0.6.1


First public release of the standalone XenForo Flutter template — a fork-friendly, build-it-yourself mobile app for any XenForo community.

### Added
- Full-featured single-forum mobile client: browse forums and threads, search, post replies and new topics, vote in polls, upload image/file attachments, manage your member profile and settings.
- Push notifications via Firebase Cloud Messaging — bring your own Firebase project, or rely on the managed Forum Copilot Push backend (no FCM setup required).
- macOS desktop support with native file picker for attachment uploads.
- Catch-up of Dart-side improvements from the upstream `tapatalk_flutter` codebase (UI polish, performance refinements).

### Fixed
- Removed a phantom back arrow that briefly appeared in top-level tab app bars during navigation transitions.

### Changed
- Bumped macOS deployment target to 13.5 to match modern Flutter requirements.
- Removed `firebase_crashlytics` from default dependencies. Projects that want crash reporting can re-add the package and the corresponding Xcode build phase explicitly.

### Documentation
- Regenerated `README.md` with macOS build steps and a comprehensive features overview.
- Added `LICENSE` (MIT) and `CLAUDE.md` guidance for AI-assisted contributors.
- Documented Forum Copilot Push as a managed alternative to running your own FCM backend.

[Unreleased]: https://github.com/forumcopilot/xenforoapp/compare/v0.9.0...HEAD
[0.6.0]: https://github.com/forumcopilot/xenforoapp/releases/tag/v0.6.0
