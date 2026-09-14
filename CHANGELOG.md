# Changelog

All notable changes to this project are documented in this file.

The format is inspired by [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html). Releases below 1.0 should not be assumed backward-compatible across minor bumps.

## [Unreleased]

## [0.10.0] - 2026-09-14

Scroll-performance release, plus a security fix for how the app stores your forum password. The thread view no longer rebuilds every post on scroll, image memory drops by about 70% on photo-heavy threads, and the home feed is virtualised. Ships with bundled ForumCopilot addon v1.8.1 (unchanged). The hosted Forum Copilot app and Forum Copilot Push are now free.

### Added
- Build-time forum override. `forumName` and `forumBaseUrl` in `AppForumConfig` now read `--dart-define=FORUM_NAME=...` and `--dart-define=FORUM_BASE_URL=...`, falling back to the committed placeholders. Lets a benchmark, CI or preview build target a forum without editing or committing the config.
- Device scroll-performance harness (`integration_test/scroll_perf_test.dart` + `test_driver/perf_driver.dart`) that flings the topic list, a thread and the home feed on a connected phone and prints `FrameTiming` percentiles. How to run it, what the numbers can and cannot gate, and the measured baseline live in `docs/perf-benchmarking.md`; the audit that drove this release is `docs/perf-audit-2026-09.md`.
- Hermetic widget tests for the post-content cache, BBCode image Hero tags, vBulletin-import attachment ids and link-preview selection (`test/`). `flutter test` now covers them.

### Changed
- **Thread view scroll performance.** Scrolling no longer rebuilds the whole thread: the visible-post counter and first-post flag are `ValueNotifier`s, rows are keyed by post id, and the per-post `VisibilityDetector` is gone. Post content is derived once per input and memoised in a process-wide LRU cache; the BBCode body is parsed to spans once per widget State rather than on every build. On the pinned benchmark thread, build p99 fell from 27 ms to 12–13 ms and in-place republishes (page load, reaction, poll vote) no longer produce a single build frame over 16.7 ms. Leaked `TapGestureRecognizer`s from `flutter_bbcode` are now disposed.
- **Images decode at display size and are fetched once.** `CachedRedirectImage` honours `cacheWidth`/`cacheHeight` on its primary path and every call site now passes a size. Image-cache occupancy on a photo-heavy thread dropped from 25.9 MB to 7.8 MB with the same images loaded.
- **Home feed virtualised.** The landing tab's rows now live in a `SliverList` instead of one `Column`, and the four hidden filter lists no longer build a full `ListView` off-screen every frame. Feed build p50 went from about 10 ms to 1 ms and janky frames per benchmark run from several hundred to under twenty. The feed header drops its `IntrinsicHeight` and full-width `ColorFiltered`.
- One link-preview card per post, resolved from the in-memory caches on first build instead of after a rebuild.
- Per-thread `AvatarActions`, `ImageActions` and `PostActionsHandler` are allocated once per list instead of once per post per build; only the highlighted post carries an `AnimatedContainer`; per-render BBCode debug logging removed; the unused `RichTextContent` renderer deleted.
- `forumcopilot_sdk` and `xenforo_core` synced byte-identical with the canonical copies (additive optional model fields; XenForo behaviour unchanged). Picks up the canonical Cloudflare interceptor fixes: a dismissed challenge now rejects the request instead of hanging it, concurrent challenges share one solve, and HTTP init can no longer clear an already-attached interceptor.
- Hosted Forum Copilot app and Forum Copilot Push no longer cost anything; README and config comments updated accordingly.

### Fixed
- **Security:** forum passwords are stored in the OS keystore (iOS/macOS Keychain, Android Keystore via `flutter_secure_storage`) instead of XOR-obfuscated in `SharedPreferences`, where they were effectively plaintext in any device backup. Existing installs migrate on first read and the legacy blobs are deleted. Auto-login keeps working.
- Opening a thread anchored to a post (unread, or a specific post) no longer shows duplicate posts; posts are de-duplicated by id on merge and load-more stops when a page adds nothing new.
- The tap-to-view image transition now actually animates: openers pass the tapped image's Hero tag through instead of inventing one nothing on screen carried, and the attachment grid and carousel gained Heroes.
- `[ATTACH]` tags carrying the vBulletin-import `.vB` suffix now resolve to their attachment instead of a "0 B" placeholder card.
- The push backend row in Notification Settings no longer references an undefined getter (the analyzer error listed under "Known issues" in `CLAUDE.md`).
- The app-level smoke test (`test/widget_test.dart`) passes again. It used to end with the bootstrap's 10-second timeout timers still pending; it now lets them elapse under fake time, so `flutter test` is green with no network.

### Notes for forks
- No config changes are required. If you build with `--dart-define`, the two new keys are optional and default to whatever is committed in `app_forum_config.dart`.
- Add `flutter_secure_storage` to your platform setup if you had stripped it: macOS needs the Keychain entitlement it already ships with; nothing else is new.

[0.10.0]: https://github.com/forumcopilot/xenforoapp/releases/tag/v0.10.0

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

## [0.6.0] - 2026-05-08

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

[Unreleased]: https://github.com/forumcopilot/xenforoapp/compare/v0.10.0...HEAD
[0.6.0]: https://github.com/forumcopilot/xenforoapp/releases/tag/v0.6.0
