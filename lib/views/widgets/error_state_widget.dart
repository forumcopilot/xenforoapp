import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../theme/design_tokens.dart';
import 'empty_state_view.dart';

/// A reusable error state widget with icon, title, and formatted message.
class ErrorStateWidget extends StatelessWidget {
  final String? title;
  final String message;
  final IconData icon;
  final double iconSize;

  const ErrorStateWidget({
    Key? key,
    this.title,
    required this.message,
    this.icon = Icons.error_outline_rounded,
    this.iconSize = DesignTokens.iconSizeXL,
  }) : super(key: key);

  // The shared EmptyStateView's error form, so errors look the same on
  // every screen. [iconSize] is kept for callers and unused.
  @override
  Widget build(BuildContext context) {
    return EmptyStateView.error(
      icon: icon,
      message: title ?? AppLocalizations.of(context).errorTitle,
      hint: message,
    );
  }
}






