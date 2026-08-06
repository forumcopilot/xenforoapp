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
  static const String forumName = 'XF Dev Forum';

  /// Base forum URL (without trailing slash).
  /// Example: https://forum.example.com
  static const String forumBaseUrl = 'http://localhost:8091';

  /// Plugin endpoint path relative to [forumBaseUrl].
  /// Common values:
  /// - forumcopilot.php
  /// - forumcopilot/api
  static const String pluginEndpoint = 'forumcopilot.php';

  /// Optional branding metadata.
  static const String forumDescription = 'XenForo community';
  static const String? logoUrl = null;
  static const String? backgroundUrl = null;

  /// Push notification dispatch source. Identifies which mode this build of
  /// the app is registering against on the XenForo server. The server-side
  /// addon's `DispatchRouter` uses this to pick the right dispatcher.
  ///
  ///   - 'forumcopilot' — official Forum Copilot app build, OR any fork that
  ///                      uses the hosted ForumCopilot Push backend. Server
  ///                      dispatches via the hosted backend.
  ///   - 'direct'       — white-label / BYO Firebase build. Server dispatches
  ///                      via the customer's own Firebase project (the addon
  ///                      reads a service-account JSON path from its admin
  ///                      options and calls FCM HTTP v1 directly).
  ///                      Requires ForumCopilot xenForo addon v1.3.4+.
  ///                      Set `pushApiBaseUrl = ''` for this mode.
  static const String pushSource = 'forumcopilot';

  /// Optional push backend base URL (leave empty to disable hosted push backend).
  ///
  /// You have two ways to enable push notifications:
  ///
  ///   1. **Run your own push backend.** Set this to your server's base URL
  ///      (e.g. `https://push.example.com/api`) and provide your own Firebase
  ///      project. Your backend stores FCM tokens registered by the app and
  ///      relays notification events from the XenForo `forumcopilot.php`
  ///      plugin to FCM/APNs.
  ///
  ///   2. **Use ForumCopilot Push (hosted).** A managed service that does the
  ///      above for you — you skip running a backend and managing your own
  ///      Firebase project. You provide your iOS bundle ID, Android package
  ///      name, and an APNs auth key (`.p8`); ForumCopilot issues the
  ///      `GoogleService-Info.plist` / `google-services.json` your build
  ///      needs. Set this URL to the endpoint shown in your ForumCopilot
  ///      dashboard. See https://forumcopilot.com for sign-up and pricing.
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
