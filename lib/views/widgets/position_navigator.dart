import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../theme/design_tokens.dart';

/// The first and last item and where the reader is ("4 / 12", a tap to
/// jump to one), as a small pill floating at the bottom left of a
/// conversation or a thread, over the list and above its reply bar. Left,
/// because posts' and messages' actions (react, reply, quote) end their
/// footers on the right, where it covered them.
///
/// Put it in a [Stack] over the list with [place], inside [HiddenWhileTyping].
/// With fewer than two items there is nowhere to go, so it draws nothing.
class PositionNavigator extends StatelessWidget {
  const PositionNavigator({
    super.key,
    required this.position,
    required this.total,
    required this.positionLabel,
    required this.jumpHint,
    required this.firstHint,
    required this.lastHint,
    required this.onFirst,
    required this.onLast,
    required this.onJump,
  });

  /// 1-based.
  final int position;
  final int total;

  /// What a screen reader says for the position ("Post 4 of 12").
  final String positionLabel;

  /// Screen-reader hints: the position's tap, and the two arrows.
  final String jumpHint;
  final String firstHint;
  final String lastHint;

  final VoidCallback onFirst;
  final VoidCallback onLast;
  final VoidCallback onJump;

  /// [navigator] at the bottom left of the [Stack] it is in; [bottom] is
  /// the system bar's height where no reply bar sits under the list.
  static Widget place({required Widget navigator, double bottom = 0}) => Positioned(
        left: DesignTokens.spacingM,
        bottom: bottom + DesignTokens.spacingS,
        child: navigator,
      );

  /// The height the list leaves under its last item, so the pill never
  /// covers it.
  static const double clearance = kMinInteractiveDimension + 3 * DesignTokens.spacingS;

  @override
  Widget build(BuildContext context) {
    if (total < 2) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: colorScheme.surfaceContainerHigh,
      elevation: 2,
      shape: const StadiumBorder(),
      clipBehavior: Clip.antiAlias,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Semantics(
            label: l10n.goToTop,
            hint: firstHint,
            button: true,
            child: IconButton(
              icon: const Icon(Icons.arrow_upward),
              onPressed: onFirst,
              tooltip: l10n.goToTop,
            ),
          ),
          Semantics(
            label: positionLabel,
            hint: jumpHint,
            button: true,
            excludeSemantics: true,
            child: InkWell(
              onTap: onJump,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: kMinInteractiveDimension),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingXS),
                  child: Center(
                    widthFactor: 1,
                    child: Text('$position / $total', style: Theme.of(context).textTheme.bodyMedium),
                  ),
                ),
              ),
            ),
          ),
          Semantics(
            label: l10n.goToBottom,
            hint: lastHint,
            button: true,
            child: IconButton(
              icon: const Icon(Icons.arrow_downward),
              onPressed: onLast,
              tooltip: l10n.goToBottom,
            ),
          ),
        ],
      ),
    );
  }
}

/// [child], left out while the keyboard is up: the room is for the list and
/// the reply being written. A page's body cannot tell from its MediaQuery,
/// which its Scaffold takes the keyboard out of (the thread's navigator
/// stayed up over the keyboard), so this reads the window's own insets and
/// rebuilds, alone, as they change.
class HiddenWhileTyping extends StatefulWidget {
  const HiddenWhileTyping({super.key, required this.child});

  final Widget child;

  @override
  State<HiddenWhileTyping> createState() => _HiddenWhileTypingState();
}

class _HiddenWhileTypingState extends State<HiddenWhileTyping> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) => View.of(context).viewInsets.bottom > 0 ? const SizedBox.shrink() : widget.child;
}
