# Changelog

All notable changes to this project are documented in this file.

The format is inspired by [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html). Releases below 1.0 should not be assumed backward-compatible across minor bumps.

## [Unreleased]

## [0.6.0] - 2026-04-29

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

[Unreleased]: https://github.com/forumcopilot/xenforoapp/compare/v0.6.0...HEAD
[0.6.0]: https://github.com/forumcopilot/xenforoapp/releases/tag/v0.6.0
