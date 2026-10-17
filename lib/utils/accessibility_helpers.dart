import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';

/// Accessibility helper utilities for consistent implementation across the app.
/// 
/// These helpers ensure that all interactive elements have proper accessibility
/// labels, hints, and meet minimum touch target requirements.
class AccessibilityHelpers {
  AccessibilityHelpers._();

  /// Wraps an icon button with proper accessibility semantics.
  /// 
  /// [icon] - The icon widget to wrap
  /// [onTap] - The tap handler
  /// [label] - The accessibility label (required)
  /// [hint] - Optional accessibility hint
  /// [isSelected] - Whether the button is in a selected state
  /// [context] - BuildContext for localization
  static Widget accessibleIconButton({
    required Widget icon,
    required VoidCallback? onTap,
    required String label,
    String? hint,
    bool isSelected = false,
    BuildContext? context,
    double? minSize,
    VoidCallback? onLongPress,
  }) {
    final effectiveMinSize = minSize ?? 48.0; // Minimum touch target size

    return Semantics(
      label: label,
      hint: hint,
      button: true,
      enabled: onTap != null,
      selected: isSelected,
      // InkResponse hit-tests the whole 48dp target and shows a ripple; the
      // GestureDetector over a colourless Container only answered on the
      // icon's own pixels, with no feedback.
      child: InkResponse(
        onTap: onTap,
        onLongPress: onLongPress,
        radius: effectiveMinSize / 2,
        child: Container(
          constraints: BoxConstraints(
            minWidth: effectiveMinSize,
            minHeight: effectiveMinSize,
          ),
          alignment: Alignment.center,
          child: icon,
        ),
      ),
    );
  }

  /// Creates an accessible image with semantic label.
  /// 
  /// [image] - The image widget
  /// [label] - The accessibility label describing the image
  /// [isDecorative] - Whether the image is purely decorative (excluded from semantics)
  static Widget accessibleImage({
    required Widget image,
    String? label,
    bool isDecorative = false,
  }) {
    if (isDecorative || label == null || label.isEmpty) {
      return Semantics(
        image: false,
        excludeSemantics: true,
        child: image,
      );
    }
    
    return Semantics(
      image: true,
      label: label,
      child: image,
    );
  }

  /// Wraps a text button with proper accessibility semantics.
  static Widget accessibleTextButton({
    required Widget child,
    required VoidCallback? onPressed,
    required String label,
    String? hint,
    BuildContext? context,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      button: true,
      enabled: onPressed != null,
      child: TextButton(
        onPressed: onPressed,
        child: child,
      ),
    );
  }

  /// Creates an accessibility label for like button.
  static String getLikeButtonLabel(BuildContext context, bool isLiked, int? count) {
    if (isLiked) {
      return AppLocalizations.of(context).unlikePost;
    } else {
      return AppLocalizations.of(context).likePost;
    }
  }

  /// Creates an accessibility label for quote button.
  static String getQuoteButtonLabel(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return localizations.quote;
  }

  /// Creates an accessibility label for reply button.
  static String getReplyButtonLabel(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return localizations.reply;
  }

  /// Creates an accessibility label for edit button.
  static String getEditButtonLabel(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return localizations.edit;
  }

  /// Creates an accessibility label for delete button.
  static String getDeleteButtonLabel(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return localizations.delete;
  }

  /// Creates an accessibility label for share button.
  static String getShareButtonLabel(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return localizations.share;
  }

  /// Creates an accessibility label for image with context.
  static String getImageLabel(BuildContext context, {String? altText, String? description}) {
    if (altText != null && altText.isNotEmpty) {
      return altText;
    }
    if (description != null && description.isNotEmpty) {
      return description;
    }
    final localizations = AppLocalizations.of(context);
    return localizations.image;
  }

  /// Creates an accessibility hint for showing likes.
  static String getShowLikesHint(BuildContext context, int count) {
    return 'Show $count likes';
  }

  /// Ensures minimum touch target size for interactive elements.
  /// 
  /// Returns a Container with minimum 48x48dp constraints.
  static Widget ensureMinimumTouchTarget({
    required Widget child,
    double minSize = 48.0,
  }) {
    return Container(
      constraints: BoxConstraints(
        minWidth: minSize,
        minHeight: minSize,
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}
