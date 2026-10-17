import 'package:flutter/material.dart';
import '../../theme/design_tokens.dart';
import 'empty_state_view.dart';

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

  // The shared EmptyStateView (from the Discourse app), so every empty
  // screen looks the same. [iconSize] is kept for callers and unused.
  @override
  Widget build(BuildContext context) {
    return EmptyStateView(icon: icon, message: title, hint: description);
  }
}






