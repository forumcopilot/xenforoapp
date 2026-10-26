import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';

/// Asks before a form with unsaved changes is closed, whichever way: its back
/// button, Android's back gesture or iOS's swipe. The composers used to close
/// on any of them without a word, and what had been typed was lost.
///
/// Adapted from the Discourse app's `DiscardChangesScope` (forum_kit). "Do you
/// want to discard your post?" for new writing, "Do you want to discard your
/// changes?" for an edit, with Cancel and Discard; a form that keeps a draft
/// also offers Save draft, which keeps it and closes.
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
    this.onSaveDraft,
    this.onDiscard,
  });

  /// What [hasChanges] follows: the form's text controllers.
  final Listenable listenable;

  /// Whether closing now would lose something.
  final bool Function() hasChanges;

  /// An edit of something that exists, rather than new writing.
  final bool isEdit;

  /// Set while the form is sending: Back does nothing until it answers.
  final bool busy;

  /// Keeps what was written for later, before closing. Offered as Save draft
  /// only when given.
  final Future<void> Function()? onSaveDraft;

  /// Throws away what was written (the draft too), before closing.
  final Future<void> Function()? onDiscard;

  final Widget child;

  @override
  State<DiscardChangesScope> createState() => _DiscardChangesScopeState();
}

enum _Choice { discard, saveDraft }

class _DiscardChangesScopeState extends State<DiscardChangesScope> {
  bool _asking = false;

  Future<void> _ask() async {
    if (_asking || widget.busy) return;
    _asking = true;
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final choice = await showDialog<_Choice>(
      context: context,
      builder: (dialog) => AlertDialog(
        // When the buttons don't fit side by side they stack with the action
        // on top and Cancel at the bottom, as Material 3 stacks a dialog's
        // buttons.
        actionsOverflowDirection: VerticalDirection.up,
        content: Text(widget.isEdit
            ? l10n.discardChangesQuestion
            : l10n.discardPostQuestion),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialog),
            child: Text(l10n.cancel),
          ),
          if (widget.onSaveDraft != null)
            TextButton(
              onPressed: () => Navigator.pop(dialog, _Choice.saveDraft),
              child: Text(l10n.saveDraft),
            ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
            ),
            onPressed: () => Navigator.pop(dialog, _Choice.discard),
            child: Text(widget.isEdit
                ? l10n.discardChanges
                : l10n.discard),
          ),
        ],
      ),
    );
    if (choice == null || !mounted) {
      _asking = false;
      return;
    }
    try {
      switch (choice) {
        case _Choice.saveDraft:
          await widget.onSaveDraft?.call();
        case _Choice.discard:
          await widget.onDiscard?.call();
      }
    } catch (e) {
      // Both are best effort (the forum's copy especially): closing still
      // does what was asked on this device.
      debugPrint('DiscardChangesScope: $choice failed: $e');
    }
    _asking = false;
    if (!mounted) return;
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
