import 'package:flutter/material.dart';

import '../theme/design_tokens.dart';

/// Shared helper for the project's three canonical snackbar styles —
/// error / info / success. Use these instead of building `SnackBar`
/// instances inline so the floating behaviour, margins, and theme
/// colours stay consistent across every screen.
///
/// All variants:
///   * float (`snackBarTheme` in `AppTheme`)
///   * replace whatever snackbar is showing or queued, so the newest
///     message is the one on screen
///   * dismiss themselves after a reading time that grows with the text
///
/// Don't give a snackbar a "Dismiss" [SnackBarAction]: since Flutter 3.38
/// a snackbar with an action persists (`SnackBar.persist` defaults to
/// `action != null`), so it never times out and every later message
/// queues unseen behind it. Errors get a close icon instead; pass an
/// [action] only for a real one ("Retry", "Undo"), which is then meant
/// to stay until used.
class SnackbarHelper {
  SnackbarHelper._();

  /// Surface a recoverable failure. Uses `colorScheme.errorContainer`
  /// with an error icon and a close button.
  static void showError(
    BuildContext context,
    String message, {
    SnackBarAction? action,
    Duration? duration,
  }) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;
    showErrorOn(messenger, Theme.of(context), message,
        action: action, duration: duration);
  }

  /// [showError] for a failure that can arrive after the screen that
  /// started the work has closed (a delete sent when an Undo timed out):
  /// [messenger] and [theme] are taken from that screen while it is still
  /// up. The app's ScaffoldMessenger outlives the page, so the reader still
  /// learns the work did not happen. Shows nothing once the messenger is
  /// gone too.
  static void showErrorOn(
    ScaffoldMessengerState messenger,
    ThemeData theme,
    String message, {
    SnackBarAction? action,
    Duration? duration,
    bool replace = true,
  }) {
    if (!messenger.mounted) return;
    _show(
      messenger,
      theme,
      message,
      backgroundColor: theme.colorScheme.errorContainer,
      foregroundColor: theme.colorScheme.onErrorContainer,
      icon: Icons.error_outline,
      showCloseIcon: true,
      action: action,
      duration: duration,
      replace: replace,
    );
  }

  /// Surface a neutral informational message. Uses
  /// `colorScheme.surfaceContainerHighest` to sit unobtrusively above the
  /// surface without competing with primary content.
  ///
  /// [persist] false keeps an [action] ("Undo" after a change already
  /// saved) on its timer instead of staying up until it is used.
  static void showInfo(
    BuildContext context,
    String message, {
    SnackBarAction? action,
    Duration? duration,
    bool? persist,
  }) =>
      _showIn(
        context,
        message,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
        action: action,
        duration: duration,
        persist: persist,
      );

  /// Surface a positive confirmation (e.g. "Saved", "Posted"). Uses
  /// `colorScheme.tertiaryContainer` so success reads visually
  /// distinct from both errors (errorContainer) and neutral info
  /// (surfaceVariant) on Material 3 themes.
  static void showSuccess(
    BuildContext context,
    String message, {
    SnackBarAction? action,
    Duration? duration,
  }) =>
      _showIn(
        context,
        message,
        backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
        action: action,
        duration: duration,
      );

  /// How long [message] stays up: 4 s for a short line, longer for a
  /// forum's validation message ("Title is too short (minimum is 15
  /// characters); Body is too short …"), at most 10 s.
  @visibleForTesting
  static Duration readingTime(String message) => Duration(
        milliseconds: (1500 + 65 * message.length).clamp(4000, 10000),
      );

  static void _showIn(
    BuildContext context,
    String message, {
    required Color backgroundColor,
    required Color foregroundColor,
    SnackBarAction? action,
    Duration? duration,
    bool? persist,
  }) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;
    _show(
      messenger,
      Theme.of(context),
      message,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      action: action,
      duration: duration,
      persist: persist,
    );
  }

  static void _show(
    ScaffoldMessengerState messenger,
    ThemeData theme,
    String message, {
    required Color backgroundColor,
    required Color foregroundColor,
    IconData? icon,
    bool showCloseIcon = false,
    SnackBarAction? action,
    Duration? duration,
    bool? persist,
    bool replace = true,
  }) {
    final text = Text(
      message,
      style: theme.textTheme.bodyMedium?.copyWith(color: foregroundColor),
    );
    // ScaffoldMessenger queues: a second failed submit used to wait,
    // unseen, behind the first message.
    if (replace) messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: icon == null
            ? text
            : Row(
                children: [
                  Icon(icon, color: foregroundColor),
                  const SizedBox(width: DesignTokens.spacingM),
                  Expanded(child: text),
                ],
              ),
        backgroundColor: backgroundColor,
        action: action,
        persist: persist,
        showCloseIcon: showCloseIcon,
        closeIconColor: foregroundColor,
        duration: duration ?? readingTime(message),
      ),
    );
  }
}
