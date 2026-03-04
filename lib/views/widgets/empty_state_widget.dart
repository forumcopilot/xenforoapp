import 'package:flutter/material.dart';
import '../../theme/design_tokens.dart';

/// A reusable empty state widget with icon, title, and description.
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? description;
  final double iconSize;

  const EmptyStateWidget({
    Key? key,
    required this.icon,
    required this.title,
    this.description,
    this.iconSize = DesignTokens.iconSizeXXL,
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
            color: colorScheme.onSurfaceVariant.withOpacity(DesignTokens.opacityMediumLow),
          ),
          SizedBox(height: DesignTokens.spacingL),
          Text(
            title,
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          if (description != null) ...[
            SizedBox(height: DesignTokens.spacingS),
            Padding(
              padding: DesignTokens.paddingHorizontalXL,
              child: Text(
                description!,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant.withOpacity(DesignTokens.opacityHigh),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }
}






