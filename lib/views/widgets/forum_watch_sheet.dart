import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../theme/design_tokens.dart';
import '../../utils/snackbar_helper.dart';

/// What the member chose in the watch sheet: stop watching, or watch with
/// these options.
class ForumWatchChoice {
  const ForumWatchChoice.watch({required this.notifyOn, required this.sendAlert, required this.sendEmail}) : unwatch = false;
  const ForumWatchChoice.unwatch()
      : unwatch = true,
        notifyOn = '',
        sendAlert = false,
        sendEmail = false;

  final bool unwatch;
  final String notifyOn;
  final bool sendAlert;
  final bool sendEmail;
}

/// Subscribing to (watching) a forum. With XenForo add-on 1.11.0 the forum
/// says what a watch may notify of, and [change] asks as the website's
/// "Watch forum" form does: new threads or every message, by alert and by
/// email, or unsubscribe. Older add-ons keep the plain toggle they had.
class ForumWatch {
  ForumWatch._();

  /// Whether [forum] offers the website's watch options.
  static bool hasOptions(FCForum forum) => forum.allowedWatchNotifications != null;

  /// Subscribes, changes the options of, or unsubscribes [forum], and
  /// updates its fields. Returns whether it is watched now, or null when
  /// nothing changed (the sheet was closed, or the forum refused: its
  /// reason is shown).
  static Future<bool?> change(BuildContext context, FCForum forum) async {
    final proxy = SiteProxyFactory.getSubscriptionProxy();
    if (!hasOptions(forum)) {
      // As before: new threads, with emails.
      if (forum.isSubscribed) {
        await proxy.unsubscribeForumAsync(forum.id);
      } else {
        await proxy.subscribeForumAsync(forum.id, 1);
      }
      forum.isSubscribed = !forum.isSubscribed;
      return forum.isSubscribed;
    }

    final choice = await showModalBottomSheet<ForumWatchChoice>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => ForumWatchSheet(forum: forum),
    );
    if (choice == null || !context.mounted) return null;

    if (choice.unwatch) {
      final result = await proxy.unsubscribeForumAsync(forum.id);
      if (!result.result) {
        if (context.mounted) _refused(context, result.resultText);
        return null;
      }
      forum
        ..isSubscribed = false
        ..notifyOn = null
        ..sendAlert = null
        ..sendEmail = null;
      return false;
    }

    final result = await proxy.subscribeForumAsync(forum.id, choice.sendEmail ? 1 : 0,
        notifyOn: choice.notifyOn, sendAlert: choice.sendAlert, sendEmail: choice.sendEmail);
    if (!result.result) {
      if (context.mounted) _refused(context, result.resultText);
      return null;
    }
    forum
      ..isSubscribed = true
      ..notifyOn = choice.notifyOn
      ..sendAlert = choice.sendAlert
      ..sendEmail = choice.sendEmail;
    return true;
  }

  static void _refused(BuildContext context, String? reason) => SnackbarHelper.showError(
        context,
        reason?.trim().isNotEmpty == true ? reason!.trim() : AppLocalizations.of(context).somethingWentWrong,
      );
}

/// The website's "Watch forum" form as a sheet. Pops a [ForumWatchChoice],
/// or null when closed.
class ForumWatchSheet extends StatefulWidget {
  const ForumWatchSheet({super.key, required this.forum});

  final FCForum forum;

  @override
  State<ForumWatchSheet> createState() => _ForumWatchSheetState();
}

class _ForumWatchSheetState extends State<ForumWatchSheet> {
  late String _notifyOn;
  late bool _sendAlert;
  late bool _sendEmail;

  String get _allowed => widget.forum.allowedWatchNotifications ?? 'all';

  @override
  void initState() {
    super.initState();
    final forum = widget.forum;
    final watched = forum.isSubscribed;
    // A new watch starts as on the website: new threads, alerts, no emails.
    final current = watched ? forum.notifyOn : null;
    _notifyOn = switch (_allowed) {
      'none' => '',
      'thread' => 'thread',
      _ => (current == 'message' || current == 'thread') ? current! : 'thread',
    };
    _sendAlert = watched ? (forum.sendAlert ?? true) : true;
    _sendEmail = watched ? (forum.sendEmail ?? false) : false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final watched = widget.forum.isSubscribed;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(DesignTokens.spacingS, 0, DesignTokens.spacingS, DesignTokens.spacingM),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingL),
              child: Text(widget.forum.name, style: textTheme.titleLarge?.copyWith(color: colorScheme.onSurface)),
            ),
            if (_allowed != 'none') ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(DesignTokens.spacingL, DesignTokens.spacingM, DesignTokens.spacingL, 0),
                child: Text(l10n.notifyMeOf, style: textTheme.titleSmall?.copyWith(color: colorScheme.onSurfaceVariant)),
              ),
              RadioGroup<String>(
                groupValue: _notifyOn,
                onChanged: (value) {
                  if (value != null) setState(() => _notifyOn = value);
                },
                child: Column(
                  children: [
                    RadioListTile<String>(value: 'thread', title: Text(l10n.watchNewThreads)),
                    if (_allowed == 'all') RadioListTile<String>(value: 'message', title: Text(l10n.watchNewMessages)),
                  ],
                ),
              ),
            ],
            SwitchListTile(
              value: _sendAlert,
              title: Text(l10n.watchSendAlerts),
              onChanged: (value) => setState(() => _sendAlert = value),
            ),
            SwitchListTile(
              value: _sendEmail,
              title: Text(l10n.watchSendEmails),
              onChanged: (value) => setState(() => _sendEmail = value),
            ),
            const SizedBox(height: DesignTokens.spacingS),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingS),
              child: Row(
                children: [
                  if (watched)
                    TextButton(
                      style: TextButton.styleFrom(foregroundColor: colorScheme.error),
                      onPressed: () => Navigator.of(context).pop(const ForumWatchChoice.unwatch()),
                      child: Text(l10n.unsubscribe),
                    ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(l10n.cancel),
                  ),
                  const SizedBox(width: DesignTokens.spacingS),
                  FilledButton(
                    onPressed: () => Navigator.of(context).pop(ForumWatchChoice.watch(
                      notifyOn: _notifyOn,
                      sendAlert: _sendAlert,
                      sendEmail: _sendEmail,
                    )),
                    child: Text(watched ? l10n.save : l10n.subscribe),
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
