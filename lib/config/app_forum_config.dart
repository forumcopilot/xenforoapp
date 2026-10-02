import 'package:forumcopilot_sdk/models/domain/site.dart';

/// Single-forum application configuration.
///
/// Developers only need to update values in this file to point the app to
/// their XenForo forum with the Forum Copilot add-on endpoint enabled.
class AppForumConfig {
  const AppForumConfig._();

  /// Stable local site identifier used by persistence layers.
  static const int siteId = 1;

  /// Human-readable forum name shown in app UI.
  ///
  /// Overridable at build time (`--dart-define=FORUM_NAME=...`) so the scroll
  /// benchmark can target a forum without that target ever being committed.
  static const String forumName =
      String.fromEnvironment('FORUM_NAME', defaultValue: 'My XenForo Forum');

  /// Base forum URL (without trailing slash).
  /// Example: https://forum.example.com
  ///
  /// Overridable at build time. The scroll benchmark
  /// (docs/perf-benchmarking.md) passes
  /// `--dart-define=FORUM_BASE_URL=https://<benchmark-forum>` and pins
  /// content on it through further `PERF_*` defines. Nothing about the
  /// benchmark, or about any particular forum, lives in this file.
  static const String forumBaseUrl = String.fromEnvironment('FORUM_BASE_URL',
      defaultValue: 'https://forum.example.com');

  /// Plugin endpoint path relative to [forumBaseUrl].
  /// Common values:
  /// - forumcopilot.php
  /// - forumcopilot/api
  static const String pluginEndpoint = 'forumcopilot.php';

  /// Optional branding metadata.
  static const String forumDescription = 'XenForo community';
  static const String? logoUrl = null;
  static const String? backgroundUrl = null;

  /// Push notification dispatch source: how this build registers devices
  /// with the XenForo server. The add-on's `DispatchRouter` uses it to pick
  /// the dispatcher.
  ///
  ///   - 'direct'       — your own Firebase project (the default, and the
  ///                      only mode documented for this template). The app
  ///                      registers its FCM token with your forum, and the
  ///                      add-on sends to FCM HTTP v1 using the service-account
  ///                      JSON set in its admin options. Keep
  ///                      `pushApiBaseUrl = ''`. Setup: README.md, "Push
  ///                      notifications".
  ///   - 'forumcopilot' — registers with the push relay at `pushApiBaseUrl`
  ///                      instead. Forum Copilot's hosted relay only serves
  ///                      the official Forum Copilot app, so a fork would need
  ///                      to run its own relay.
  static const String pushSource = 'direct';

  /// Base URL of a push relay, used only with `pushSource = 'forumcopilot'`.
  /// Leave empty for direct mode.
  static const String pushApiBaseUrl = '';

  /// Android package name used for passkey assetlinks validation.
  static const String androidPackageName = 'com.example.forumapp';

  /// SHA256 certificate fingerprint used for passkey validation.
  /// Leave empty until you configure your own signing certificate.
  static const String androidSha256CertFingerprint = '';

  static Site buildSite() {
    final trimmedName = forumName.trim();
    final trimmedBaseUrl = forumBaseUrl.trim();
    final trimmedEndpoint = pluginEndpoint.trim();

    if (trimmedName.isEmpty) {
      throw StateError('AppForumConfig.forumName must not be empty.');
    }
    if (trimmedBaseUrl.isEmpty) {
      throw StateError('AppForumConfig.forumBaseUrl must not be empty.');
    }
    if (trimmedEndpoint.isEmpty) {
      throw StateError('AppForumConfig.pluginEndpoint must not be empty.');
    }

    final parsedBaseUrl = Uri.tryParse(trimmedBaseUrl);
    if (parsedBaseUrl == null ||
        !parsedBaseUrl.hasScheme ||
        parsedBaseUrl.host.isEmpty) {
      throw StateError(
        'AppForumConfig.forumBaseUrl is invalid. Expected absolute URL.',
      );
    }

    final normalizedBaseUrl = trimmedBaseUrl.endsWith('/')
        ? trimmedBaseUrl.substring(0, trimmedBaseUrl.length - 1)
        : trimmedBaseUrl;
    final normalizedEndpoint =
        trimmedEndpoint.startsWith('/') ? trimmedEndpoint.substring(1) : trimmedEndpoint;

    return Site(
      id: siteId,
      name: trimmedName,
      url: normalizedBaseUrl,
      description: forumDescription,
      logoUrl: logoUrl,
      backgroundUrl: backgroundUrl,
      endpoint: normalizedEndpoint,
      baseUrl: normalizedBaseUrl,
      siteType: 'xenforo',
    );
  }

  static bool get isPushBackendEnabled => pushApiBaseUrl.trim().isNotEmpty;
}
