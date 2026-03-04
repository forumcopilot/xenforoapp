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
  static const String forumName = 'My XenForo Forum';

  /// Base forum URL (without trailing slash).
  /// Example: https://forum.example.com
  static const String forumBaseUrl = 'https://forum.example.com';

  /// Plugin endpoint path relative to [forumBaseUrl].
  /// Common values:
  /// - forumcopilot.php
  /// - forumcopilot/api
  static const String pluginEndpoint = 'forumcopilot.php';

  /// Optional branding metadata.
  static const String forumDescription = 'XenForo community';
  static const String? logoUrl = null;
  static const String? backgroundUrl = null;

  /// Optional push backend base URL (leave empty to disable app push backend).
  /// Example: https://push.example.com/api
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
