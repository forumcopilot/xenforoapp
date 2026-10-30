import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../theme/design_tokens.dart';
import '../../utils/snackbar_helper.dart';

/// A thread's watch, as it is after [ThreadWatch.change].
typedef ThreadWatchState = ({bool watched, bool? emailSubscribe});

/// What the member chose in the sheet: unwatch (null), or watch with or
/// without emails.
typedef _ThreadWatchChoice = ({bool unwatch, bool emailSubscribe});

/// Watching a thread. With XenForo add-on 1.11.0 [change] asks as the
/// website's "Watch thread" form does: watch (alerts for new replies) and
/// optionally emails, or unwatch. Older add-ons keep the plain toggle, which
/// watched with emails.
class ThreadWatch {
  ThreadWatch._();

  /// Watches, re-sets or unwatches thread [topicId]. [hasOptions]: the forum
  /// takes the website's options (add-on 1.11.0+). [emailSubscribe]: whether
  /// the current watch sends emails, when known. Returns the watch as it is
  /// now, or null when nothing changed (the sheet was closed, or the forum
  /// refused: its reason is shown).
  static Future<ThreadWatchState?> change(
    BuildContext context, {
    required String topicId,
    required String title,
    required bool isWatched,
    required bool hasOptions,
    bool? emailSubscribe,
  }) async {
    final proxy = SiteProxyFactory.getSubscriptionProxy();
    final l10n = AppLocalizations.of(context);

    if (!hasOptions) {
      // As before: watch with emails, or unwatch.
      final (ok, reason) = isWatched
          ? await proxy.unsubscribeTopicAsync(topicId).then((r) => (r.result, r.resultText))
          : await proxy.subscribeTopicAsync(topicId, 1).then((r) => (r.result, r.resultText));
      if (!ok) {
        if (context.mounted) _refused(context, reason, isWatched ? l10n.failedToUnwatchThread : l10n.failedToWatchThread);
        return null;
      }
      return (watched: !isWatched, emailSubscribe: null);
    }

    // A thread already watched: ask the forum how. Without emailSubscribe the
    // watch is left as it is and the reply says whether it sends emails.
    var emails = emailSubscribe;
    if (isWatched && emails == null) {
      final current = await proxy.subscribeTopicAsync(topicId, 0);
      if (current.result) emails = current.emailSubscribe;
    }
    if (!context.mounted) return null;

    final choice = await showModalBottomSheet<_ThreadWatchChoice>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => ThreadWatchSheet(title: title, isWatched: isWatched, emailSubscribe: emails ?? false),
    );
    if (choice == null || !context.mounted) return null;

    if (choice.unwatch) {
      final result = await proxy.unsubscribeTopicAsync(topicId);
      if (!result.result) {
        if (context.mounted) _refused(context, result.resultText, l10n.failedToUnwatchThread);
        return null;
      }
      return (watched: false, emailSubscribe: null);
    }

    final result = await proxy.subscribeTopicAsync(topicId, choice.emailSubscribe ? 1 : 0, emailSubscribe: choice.emailSubscribe);
    if (!result.result) {
      if (context.mounted) _refused(context, result.resultText, l10n.failedToWatchThread);
      return null;
    }
    return (watched: true, emailSubscribe: result.emailSubscribe ?? choice.emailSubscribe);
  }

  static void _refused(BuildContext context, String? reason, String fallback) =>
      SnackbarHelper.showError(context, reason?.trim().isNotEmpty == true ? reason!.trim() : fallback);
}

/// The website's "Watch thread" form as a sheet. Pops a choice, or null when
/// closed.
class ThreadWatchSheet extends StatefulWidget {
  const ThreadWatchSheet({super.key, required this.title, required this.isWatched, required this.emailSubscribe});

  final String title;
  final bool isWatched;
  final bool emailSubscribe;

  @override
  State<ThreadWatchSheet> createState() => _ThreadWatchSheetState();
}

class _ThreadWatchSheetState extends State<ThreadWatchSheet> {
  late bool _emails = widget.emailSubscribe;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(DesignTokens.spacingS, 0, DesignTokens.spacingS, DesignTokens.spacingM),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingL),
              child: Text(
                widget.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleLarge?.copyWith(color: colorScheme.onSurface),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(DesignTokens.spacingL, DesignTokens.spacingS, DesignTokens.spacingL, 0),
              child: Text(l10n.watchThreadAlertsNote, style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
            ),
            SwitchListTile(
              value: _emails,
              title: Text(l10n.watchSendEmails),
              onChanged: (value) => setState(() => _emails = value),
            ),
            const SizedBox(height: DesignTokens.spacingS),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingS),
              child: Row(
                children: [
                  if (widget.isWatched)
                    TextButton(
                      style: TextButton.styleFrom(foregroundColor: colorScheme.error),
                      onPressed: () => Navigator.of(context).pop<_ThreadWatchChoice>((unwatch: true, emailSubscribe: false)),
                      child: Text(l10n.unsubscribe),
                    ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(l10n.cancel),
                  ),
                  const SizedBox(width: DesignTokens.spacingS),
                  FilledButton(
                    onPressed: () => Navigator.of(context).pop<_ThreadWatchChoice>((unwatch: false, emailSubscribe: _emails)),
                    child: Text(widget.isWatched ? l10n.save : l10n.subscribe),
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
