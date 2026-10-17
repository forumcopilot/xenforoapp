import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/logging/app_logger.dart';
import '../l10n/generated/app_localizations.dart';
import '../services/notification_permission.dart';
import '../theme/design_tokens.dart';
import '../utils/app_navigation.dart';

/// Asks for notification permission after sign-in, once, as the Discourse
/// app does. The app used to ask at first launch, before anyone had signed
/// in, which spent iOS's one-time prompt on guests who get no notifications,
/// and nothing read the answer afterwards.
///
/// It shows what arrives (two sample notifications under the forum's name)
/// before anything is asked; after a refusal it says notifications are off
/// and offers the system settings, the only way back.
class EnableNotificationsPage extends StatefulWidget {
  const EnableNotificationsPage({super.key, required this.siteContext});

  final SiteContext siteContext;

  static const String _shownKey = 'notification_permission_prompt_shown';

  /// Shows the page once per install, when a signed-in member hasn't been
  /// asked yet (the permission is still undecided).
  static Future<void> maybeShow(BuildContext context, SiteContext siteContext) async {
    if (!siteContext.isLoggedIn) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool(_shownKey) ?? false) return;
      if (await NotificationPermission.status() != NotificationPermissionState.notDetermined) return;
      await prefs.setBool(_shownKey, true);
    } catch (e) {
      AppLogger.debug('EnableNotificationsPage: skipped: $e');
      return;
    }
    if (!context.mounted) return;
    await AppNavigation.push<void>(context, EnableNotificationsPage(siteContext: siteContext));
  }

  @override
  State<EnableNotificationsPage> createState() => _EnableNotificationsPageState();
}

class _EnableNotificationsPageState extends State<EnableNotificationsPage> with WidgetsBindingObserver {
  // null while the first check runs, so the banner doesn't flash.
  NotificationPermissionState? _permission;
  bool _asking = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refresh();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Back from the system settings: a banner the member just fixed goes away.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _refresh();
  }

  Future<void> _refresh() async {
    final status = await NotificationPermission.status();
    if (mounted) setState(() => _permission = status);
  }

  Future<void> _turnOn() async {
    setState(() => _asking = true);
    final status = await NotificationPermission.request();
    if (!mounted) return;
    setState(() {
      _asking = false;
      _permission = status;
    });
    if (status == NotificationPermissionState.granted) Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final forumName = widget.siteContext.site.name;
    final denied = _permission == NotificationPermissionState.denied;

    return Scaffold(
      appBar: AppBar(title: Text(l10n?.turnOnNotifications ?? 'Turn on notifications')),
      // The explanation scrolls and the buttons stay at the bottom, so a large
      // text size or a short phone never overflows.
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(DesignTokens.spacingL, DesignTokens.spacingS, DesignTokens.spacingL, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _NotificationPreview(
                      forumName: forumName,
                      samples: [
                        (l10n?.notificationPreviewNow ?? 'now', l10n?.notificationPreviewReply ?? 'Jane replied to you: Welcome aboard! Glad you found us.'),
                        (l10n?.notificationPreviewEarlier ?? '5m ago', l10n?.notificationPreviewMessage ?? 'Sam sent you a message: Are you coming on Friday?'),
                      ],
                    ),
                    const SizedBox(height: DesignTokens.spacingXL),
                    Text(
                      l10n?.neverMissAReplyOn(forumName) ?? 'Never miss a reply on $forumName',
                      style: textTheme.headlineSmall?.copyWith(color: colorScheme.onSurface),
                    ),
                    const SizedBox(height: DesignTokens.spacingS),
                    Text(
                      l10n?.notificationsPitchForum ?? 'Replies, mentions and direct messages, on your lock screen as they happen.',
                      style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                    if (denied) ...[
                      const SizedBox(height: DesignTokens.spacingXL),
                      _OffBanner(l10n: l10n),
                    ],
                    const SizedBox(height: DesignTokens.spacingL),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(DesignTokens.spacingL, DesignTokens.spacingS, DesignTokens.spacingL, DesignTokens.spacingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!denied)
                    FilledButton(
                      onPressed: _asking || _permission == null ? null : _turnOn,
                      child: Text(l10n?.turnOnNotifications ?? 'Turn on notifications'),
                    ),
                  TextButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    child: Text(l10n?.notNow ?? 'Not now'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Two notifications as they will look, under the forum's name.
class _NotificationPreview extends StatelessWidget {
  const _NotificationPreview({required this.forumName, required this.samples});

  final String forumName;
  final List<(String, String)> samples;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    // White cards in light mode, as notifications are; raised grey in dark.
    final card = theme.brightness == Brightness.light ? colorScheme.surfaceContainerLowest : colorScheme.surfaceContainerHighest;
    final initial = forumName.trim().isEmpty ? '?' : forumName.trim()[0].toUpperCase();

    return ExcludeSemantics(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingM, vertical: DesignTokens.spacingL),
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          children: [
            for (final (index, (age, text)) in samples.indexed) ...[
              if (index > 0) const SizedBox(height: DesignTokens.spacingS),
              Opacity(
                opacity: index == 0 ? 1 : 0.7,
                child: Container(
                  padding: const EdgeInsets.all(DesignTokens.spacingM),
                  decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(18)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        child: Text(initial),
                      ),
                      const SizedBox(width: DesignTokens.spacingM),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$forumName · $age',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              text,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// After a refusal: notifications are off, and the system settings are the
/// only way to turn them on.
class _OffBanner extends StatelessWidget {
  const _OffBanner({required this.l10n});

  final AppLocalizations? l10n;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: DesignTokens.paddingM,
      decoration: BoxDecoration(
        color: colorScheme.errorContainer.withValues(alpha: DesignTokens.opacityLow),
        borderRadius: BorderRadius.circular(DesignTokens.radiusM),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.error_outline, color: colorScheme.error, size: 20),
              const SizedBox(width: DesignTokens.spacingS),
              Expanded(
                child: Text(
                  l10n?.notificationsAreTurnedOffForThisApp ?? 'Notifications are turned off for this app',
                  style: textTheme.titleSmall?.copyWith(color: colorScheme.onSurface),
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingXS),
          Text(
            l10n?.deviceWillNotShowAlertsUntilAllowedInSettings ?? 'Your device will not show alerts until you allow notifications in Settings.',
            style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          if (NotificationPermission.canOpenSettings) ...[
            const SizedBox(height: DesignTokens.spacingS),
            FilledButton.tonal(
              onPressed: NotificationPermission.openSettings,
              child: Text(l10n?.openSettings ?? 'Open Settings'),
            ),
          ],
        ],
      ),
    );
  }
}
