import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';

/// Asks before a form with unsaved changes is closed, whichever way: its back
/// button, Android's back gesture or iOS's swipe. The composers used to close
/// on any of them without a word, and what had been typed was lost.
///
/// Adapted from the Discourse app's `DiscardChangesScope` (forum_kit), without
/// its draft options: Forum Copilot has no drafts yet. "Do you want to discard
/// your post?" for new writing, "Do you want to discard your changes?" for an
/// edit, with Cancel and Discard.
///
/// A form without changes closes at once and keeps Android's predictive back
/// animation. While [busy] (sending) it does not close at all. A successful
/// submit closes the form with `Navigator.pop`, which this scope never blocks.
class DiscardChangesScope extends StatefulWidget {
  const DiscardChangesScope({
    super.key,
    required this.listenable,
    required this.hasChanges,
    required this.child,
    this.isEdit = false,
    this.busy = false,
  });

  /// What [hasChanges] follows: the form's text controllers.
  final Listenable listenable;

  /// Whether closing now would lose something.
  final bool Function() hasChanges;

  /// An edit of something that exists, rather than new writing.
  final bool isEdit;

  /// Set while the form is sending: Back does nothing until it answers.
  final bool busy;

  final Widget child;

  @override
  State<DiscardChangesScope> createState() => _DiscardChangesScopeState();
}

class _DiscardChangesScopeState extends State<DiscardChangesScope> {
  bool _asking = false;

  Future<void> _ask() async {
    if (_asking || widget.busy) return;
    _asking = true;
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final discard = await showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        // When the buttons don't fit side by side they stack with the action
        // on top, as Material 3 stacks a dialog's buttons.
        actionsOverflowDirection: VerticalDirection.up,
        content: Text(widget.isEdit
            ? l10n.discardChangesQuestion
            : l10n.discardPostQuestion),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialog, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
            ),
            onPressed: () => Navigator.pop(dialog, true),
            child: Text(widget.isEdit
                ? l10n.discardChanges
                : l10n.discard),
          ),
        ],
      ),
    );
    _asking = false;
    if (discard != true || !mounted) return;
    final route = ModalRoute.of(context);
    // Navigator.pop closes the form regardless of this scope.
    if (route != null && route.isCurrent) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.listenable,
      builder: (context, child) => PopScope(
        canPop: !widget.busy && !widget.hasChanges(),
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) _ask();
        },
        child: child!,
      ),
      child: widget.child,
    );
  }
}
