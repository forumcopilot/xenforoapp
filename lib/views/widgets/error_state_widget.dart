import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../theme/design_tokens.dart';

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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: iconSize,
            color: colorScheme.error,
          ),
          SizedBox(height: DesignTokens.spacingL),
          Text(
            title ?? (AppLocalizations.of(context)?.errorTitle ?? 'Error'),
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.error,
            ),
          ),
          SizedBox(height: DesignTokens.spacingS),
          Padding(
            padding: DesignTokens.paddingHorizontalXL,
            child: Text(
              message,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}






