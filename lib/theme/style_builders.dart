import 'package:flutter/material.dart';
import 'design_tokens.dart';

/// Reusable style builders for common UI components.
/// These builders use DesignTokens for consistency and can be extended
/// to support admin customization in the future.
class StyleBuilders {
  // Private constructor to prevent instantiation
  StyleBuilders._();

  // ============================================================================
  // INPUT DECORATION BUILDER
  // ============================================================================

  /// Creates a standardized InputDecoration for text fields.
  /// 
  /// [colorScheme] - The color scheme to use for styling
  /// [labelText] - Optional label text
  /// [hintText] - Optional hint text
  /// [helperText] - Optional helper text
  /// [prefixIcon] - Optional prefix icon
  /// [suffixIcon] - Optional suffix icon
  /// [errorText] - Optional error text (automatically handled by TextFormField)
  /// [filled] - Whether to fill the background (default: true)
  /// [fillColor] - Custom fill color (defaults to surfaceContainerHighest with opacity)
  /// [borderRadius] - Custom border radius (defaults to DesignTokens.radiusL)
  static InputDecoration inputDecoration({
    required ColorScheme colorScheme,
    String? labelText,
    String? hintText,
    String? helperText,
    int? helperMaxLines,
    IconData? prefixIcon,
    Widget? suffixIcon,
    bool filled = true,
    Color? fillColor,
    double? borderRadius,
    EdgeInsetsGeometry? contentPadding,
  }) {
    final effectiveBorderRadius = borderRadius ?? DesignTokens.radiusL;
    final effectiveFillColor = fillColor ??
        colorScheme.surfaceContainerHighest.withValues(
          alpha: DesignTokens.opacityLow,
        );
    final effectiveContentPadding = contentPadding ?? DesignTokens.paddingInput;

    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      helperText: helperText,
      helperMaxLines: helperMaxLines,
      labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
      floatingLabelStyle: TextStyle(color: colorScheme.primary),
      hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
      helperStyle: TextStyle(color: colorScheme.onSurfaceVariant),
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, color: colorScheme.onSurfaceVariant)
          : null,
      suffixIcon: suffixIcon,
      filled: filled,
      fillColor: effectiveFillColor,
      contentPadding: effectiveContentPadding,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        borderSide: BorderSide(
          color: colorScheme.primary,
          width: DesignTokens.borderWidthMedium,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        borderSide: BorderSide(
          color: colorScheme.error,
          width: DesignTokens.borderWidthMedium,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        borderSide: BorderSide(
          color: colorScheme.error,
          width: DesignTokens.borderWidthMedium,
        ),
      ),
    );
  }

  /// Creates an InputDecoration without a label (for inline inputs).
  static InputDecoration inputDecorationWithoutLabel({
    required ColorScheme colorScheme,
    String? hintText,
    IconData? prefixIcon,
    Widget? suffixIcon,
    bool filled = true,
    Color? fillColor,
    double? borderRadius,
    EdgeInsetsGeometry? contentPadding,
  }) {
    return inputDecoration(
      colorScheme: colorScheme,
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: filled,
      fillColor: fillColor,
      borderRadius: borderRadius,
      contentPadding: contentPadding,
    );
  }

  // ============================================================================
  // CARD STYLE BUILDER
  // ============================================================================

  /// Creates a standardized CardThemeData for consistent card styling.
  static CardThemeData cardTheme({
    required ColorScheme colorScheme,
    double? elevation,
    double? borderRadius,
    EdgeInsetsGeometry? margin,
  }) {
    return CardThemeData(
      elevation: elevation ?? DesignTokens.elevationMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          borderRadius ?? DesignTokens.radiusM,
        ),
      ),
      margin: margin ?? EdgeInsets.zero,
      color: colorScheme.surface,
    );
  }

  /// Creates a BoxDecoration for custom card-like containers.
  static BoxDecoration cardDecoration({
    required ColorScheme colorScheme,
    Color? color,
    double? borderRadius,
    double? borderWidth,
    Color? borderColor,
    List<BoxShadow>? boxShadow,
  }) {
    return BoxDecoration(
      color: color ?? colorScheme.surface,
      borderRadius: BorderRadius.circular(
        borderRadius ?? DesignTokens.radiusM,
      ),
      border: borderWidth != null && borderWidth > 0
          ? Border.all(
              color: borderColor ?? colorScheme.outlineVariant,
              width: borderWidth,
            )
          : null,
      boxShadow: boxShadow,
    );
  }

  // ============================================================================
  // BUTTON STYLE BUILDERS
  // ============================================================================

  /// Creates a standardized ElevatedButton style.
  static ButtonStyle elevatedButtonStyle({
    required ColorScheme colorScheme,
    EdgeInsetsGeometry? padding,
    double? borderRadius,
    double? elevation,
  }) {
    return ElevatedButton.styleFrom(
      elevation: elevation ?? DesignTokens.elevationNone,
      padding: padding ??
          EdgeInsets.symmetric(
            horizontal: DesignTokens.spacingXL,
            vertical: DesignTokens.spacingM,
          ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          borderRadius ?? DesignTokens.radiusS,
        ),
      ),
    );
  }

  /// Creates a standardized TextButton style.
  static ButtonStyle textButtonStyle({
    required ColorScheme colorScheme,
    EdgeInsetsGeometry? padding,
    double? borderRadius,
  }) {
    return TextButton.styleFrom(
      padding: padding ??
          EdgeInsets.symmetric(
            horizontal: DesignTokens.spacingL,
            vertical: DesignTokens.spacingS,
          ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          borderRadius ?? DesignTokens.radiusS,
        ),
      ),
    );
  }

  /// Creates a standardized FilledButton style for extended buttons.
  /// Matches the style of FloatingActionButton.extended for consistency.
  /// Automatically adapts to light and dark mode through ColorScheme.
  static ButtonStyle extendedFilledButtonStyle({
    required ColorScheme colorScheme,
    EdgeInsetsGeometry? padding,
    double? borderRadius,
    double? elevation,
  }) {
    return FilledButton.styleFrom(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      padding: padding ?? DesignTokens.paddingExtendedButton,
      elevation: elevation ?? DesignTokens.elevationMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          borderRadius ?? DesignTokens.radiusExtendedButton,
        ),
      ),
    );
  }

  // ============================================================================
  // CONTAINER DECORATION BUILDERS
  // ============================================================================

  /// Creates a BoxDecoration for surface containers with optional border.
  static BoxDecoration surfaceContainerDecoration({
    required ColorScheme colorScheme,
    Color? color,
    double? borderRadius,
    bool showBorder = false,
    double? borderOpacity,
  }) {
    return BoxDecoration(
      color: color ?? colorScheme.surfaceVariant,
      borderRadius: BorderRadius.circular(
        borderRadius ?? DesignTokens.radiusXS,
      ),
      border: showBorder
          ? Border.all(
              color: colorScheme.outlineVariant.withOpacity(
                borderOpacity ?? DesignTokens.opacityLow,
              ),
              width: DesignTokens.borderWidthThin,
            )
          : null,
    );
  }

  // ============================================================================
  // TEXT STYLE HELPERS
  // ============================================================================

  /// Creates a TextStyle with consistent styling for body text.
  static TextStyle bodyTextStyle({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
  }) {
    return textTheme.bodyMedium?.copyWith(
          fontSize: fontSize ?? DesignTokens.fontSizeM,
          fontWeight: fontWeight ?? DesignTokens.fontWeightNormal,
          color: color ?? colorScheme.onSurface,
          height: height ?? DesignTokens.lineHeightNormal,
          letterSpacing: letterSpacing ?? DesignTokens.letterSpacingNormal,
        ) ??
        TextStyle(
          fontSize: fontSize ?? DesignTokens.fontSizeM,
          fontWeight: fontWeight ?? DesignTokens.fontWeightNormal,
          color: color ?? colorScheme.onSurface,
          height: height ?? DesignTokens.lineHeightNormal,
          letterSpacing: letterSpacing ?? DesignTokens.letterSpacingNormal,
        );
  }

  /// Creates a TextStyle for small/secondary text.
  static TextStyle smallTextStyle({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    Color? color,
    FontWeight? fontWeight,
  }) {
    return textTheme.bodySmall?.copyWith(
          fontSize: DesignTokens.fontSizeS,
          color: color ?? colorScheme.onSurfaceVariant,
          fontWeight: fontWeight ?? DesignTokens.fontWeightNormal,
        ) ??
        TextStyle(
          fontSize: DesignTokens.fontSizeS,
          color: color ?? colorScheme.onSurfaceVariant,
          fontWeight: fontWeight ?? DesignTokens.fontWeightNormal,
        );
  }

  /// Creates a TextStyle for title/heading text.
  static TextStyle titleTextStyle({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return textTheme.titleMedium?.copyWith(
          fontSize: fontSize ?? DesignTokens.fontSizeL,
          fontWeight: fontWeight ?? DesignTokens.fontWeightSemiBold,
          color: color ?? colorScheme.onSurface,
        ) ??
        TextStyle(
          fontSize: fontSize ?? DesignTokens.fontSizeL,
          fontWeight: fontWeight ?? DesignTokens.fontWeightSemiBold,
          color: color ?? colorScheme.onSurface,
        );
  }

  // ============================================================================
  // CARD WITH MARGIN BUILDER (common pattern for list items)
  // ============================================================================

  /// Creates a Card widget with standardized margin and styling.
  /// This is a common pattern for list items.
  static Widget cardWithMargin({
    required ColorScheme colorScheme,
    required Widget child,
    EdgeInsetsGeometry? margin,
    double? borderRadius,
    double? elevation,
    Color? color,
    BorderSide? borderSide,
    VoidCallback? onTap,
  }) {
    final effectiveMargin = margin ??
        EdgeInsets.symmetric(
          horizontal: DesignTokens.spacingM,
          vertical: DesignTokens.spacingM - DesignTokens.spacingXS,
        );
    final effectiveBorderRadius = borderRadius ?? DesignTokens.radiusL;
    final effectiveElevation = elevation ?? DesignTokens.elevationMedium;
    final effectiveColor = color ?? colorScheme.surfaceContainerLowest;
    final effectiveBorderSide = borderSide ??
        BorderSide(
          color: colorScheme.outlineVariant.withOpacity(DesignTokens.opacityLow),
          width: DesignTokens.borderWidthThin,
        );

    Widget cardContent = Card(
      margin: effectiveMargin,
      elevation: effectiveElevation,
      shadowColor: colorScheme.shadow.withOpacity(DesignTokens.opacityLow * 0.33),
      color: effectiveColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        side: effectiveBorderSide,
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        child: cardContent,
      );
    }

    return cardContent;
  }

  // ============================================================================
  // CONTAINER DECORATION FOR CARDS/LIST ITEMS
  // ============================================================================

  /// Creates a BoxDecoration for card-like containers with border.
  static BoxDecoration cardLikeDecoration({
    required ColorScheme colorScheme,
    Color? color,
    double? borderRadius,
    double? borderOpacity,
    double? borderWidth,
  }) {
    return BoxDecoration(
      color: color ?? colorScheme.surfaceVariant,
      borderRadius: BorderRadius.circular(
        borderRadius ?? DesignTokens.radiusS,
      ),
      border: Border.all(
        color: colorScheme.outlineVariant.withOpacity(
          borderOpacity ?? DesignTokens.opacityLow,
        ),
        width: borderWidth ?? DesignTokens.borderWidthThin,
      ),
    );
  }

  // ============================================================================
  // DIVIDER STYLE
  // ============================================================================

  /// Creates a Divider with standardized styling.
  static Divider divider({
    required ColorScheme colorScheme,
    double? height,
    double? thickness,
    double? indent,
    double? endIndent,
    double? opacity,
  }) {
    return Divider(
      height: height ?? DesignTokens.borderWidthThin,
      thickness: thickness ?? DesignTokens.borderWidthThin,
      color: colorScheme.outlineVariant.withOpacity(
        opacity ?? DesignTokens.opacityLow,
      ),
      indent: indent,
      endIndent: endIndent,
    );
  }

  // ============================================================================
  // BADGE/CHIP DECORATION
  // ============================================================================

  /// Creates a BoxDecoration for badges/chips.
  static BoxDecoration badgeDecoration({
    required ColorScheme colorScheme,
    Color? backgroundColor,
    double? borderRadius,
    EdgeInsetsGeometry? padding,
  }) {
    return BoxDecoration(
      color: backgroundColor ?? colorScheme.primaryContainer,
      borderRadius: BorderRadius.circular(
        borderRadius ?? DesignTokens.radiusM,
      ),
    );
  }

  /// Creates a TextStyle for badge text labels (e.g., BANNED, DELETED).
  static TextStyle badgeTextStyle({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    Color? color,
    FontWeight? fontWeight,
  }) {
    return textTheme.labelSmall?.copyWith(
          fontSize: DesignTokens.fontSizeXXS,
          color: color ?? colorScheme.onSurfaceVariant,
          fontWeight: fontWeight ?? DesignTokens.fontWeightBold,
        ) ??
        TextStyle(
          fontSize: DesignTokens.fontSizeXXS,
          color: color ?? colorScheme.onSurfaceVariant,
          fontWeight: fontWeight ?? DesignTokens.fontWeightBold,
        );
  }

  // ============================================================================
  // QUOTE COLOR HELPER
  // ============================================================================

  /// Gets the appropriate quote color based on theme and depth.
  /// Cycles through the available colors when depth exceeds the number of colors.
  static Color getQuoteColor(BuildContext context, int depth) {
    final brightness = Theme.of(context).brightness;
    final idx = depth % 2; // Cycle through the 2 available colors
    if (brightness == Brightness.dark) {
      return DesignTokens.quoteColorsDark[idx];
    } else {
      return DesignTokens.quoteColorsLight[idx];
    }
  }
}

