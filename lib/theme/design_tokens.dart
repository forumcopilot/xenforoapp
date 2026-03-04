import 'package:flutter/material.dart';

/// Centralized design tokens for consistent styling across the app.
/// These values can later be made configurable by forum admins.
class DesignTokens {
  // Private constructor to prevent instantiation
  DesignTokens._();

  // ============================================================================
  // SPACING SYSTEM (8px base unit)
  // ============================================================================
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 12.0;
  static const double spacingL = 16.0;
  static const double spacingXL = 24.0;
  static const double spacingXXL = 32.0;
  static const double spacingXXXL = 48.0;

  // ============================================================================
  // BORDER RADIUS
  // ============================================================================
  static const double radiusXS = 4.0;
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 20.0;
  static const double radiusExtendedButton = 28.0; // For extended-style buttons (matches FAB.extended)

  // ============================================================================
  // TYPOGRAPHY SCALE
  // ============================================================================
  static const double fontSizeXS = 12.0;
  static const double fontSizeS = 14.0;
  static const double fontSizeM = 16.0;
  static const double fontSizeL = 20.0;
  static const double fontSizeXL = 24.0;
  static const double fontSizeXXL = 28.0;
  static const double fontSizeXXXL = 32.0;

  // Specific use case font sizes
  static const double fontSizeTopicTitle = 16.0; // For topic titles and subforum names
  static const double fontSizeXXS = 10.0; // For badge text labels

  // Font weights
  static const FontWeight fontWeightNormal = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightSemiBold = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.w700;

  // Line heights
  static const double lineHeightTight = 1.2;
  static const double lineHeightNormal = 1.4;
  static const double lineHeightRelaxed = 1.5;
  static const double lineHeightLoose = 1.6;

  // Letter spacing
  static const double letterSpacingTight = -0.2;
  static const double letterSpacingNormal = 0.0;
  static const double letterSpacingMedium = 0.15;
  static const double letterSpacingWide = 0.4;

  // ============================================================================
  // COMMON PADDING/MARGIN EDGE INSETS
  // ============================================================================
  
  // All sides
  static const EdgeInsets paddingXS = EdgeInsets.all(spacingXS);
  static const EdgeInsets paddingS = EdgeInsets.all(spacingS);
  static const EdgeInsets paddingM = EdgeInsets.all(spacingM);
  static const EdgeInsets paddingL = EdgeInsets.all(spacingL);
  static const EdgeInsets paddingXL = EdgeInsets.all(spacingXL);
  static const EdgeInsets paddingXXL = EdgeInsets.all(spacingXXL);

  // Horizontal
  static const EdgeInsets paddingHorizontalS = EdgeInsets.symmetric(horizontal: spacingS);
  static const EdgeInsets paddingHorizontalM = EdgeInsets.symmetric(horizontal: spacingM);
  static const EdgeInsets paddingHorizontalL = EdgeInsets.symmetric(horizontal: spacingL);
  static const EdgeInsets paddingHorizontalXL = EdgeInsets.symmetric(horizontal: spacingXL);

  // Vertical
  static const EdgeInsets paddingVerticalS = EdgeInsets.symmetric(vertical: spacingS);
  static const EdgeInsets paddingVerticalM = EdgeInsets.symmetric(vertical: spacingM);
  static const EdgeInsets paddingVerticalL = EdgeInsets.symmetric(vertical: spacingL);
  static const EdgeInsets paddingVerticalXL = EdgeInsets.symmetric(vertical: spacingXL);

  // Specific combinations
  static const EdgeInsets paddingCard = EdgeInsets.all(spacingL);
  static const EdgeInsets paddingScreen = EdgeInsets.all(spacingXL);
  static const EdgeInsets paddingScreenHorizontal = EdgeInsets.symmetric(horizontal: spacingXL);
  static const EdgeInsets paddingInput = EdgeInsets.symmetric(horizontal: spacingL, vertical: spacingM);
  static const EdgeInsets paddingExtendedButton = EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0); // For extended-style buttons (matches FAB.extended)

  // ============================================================================
  // COMMON SIZES
  // ============================================================================
  static const double iconSizeXS = 12.0;
  static const double iconSizeS = 16.0;
  static const double iconSizeSMedium = 18.0;
  static const double iconSizeM = 20.0;
  static const double iconSizeMedium = 22.0;
  static const double iconSizeL = 24.0;
  static const double iconSizeXL = 32.0;
  static const double iconSizeXXL = 48.0;

  static const double avatarSizeS = 24.0;
  static const double avatarSizeM = 32.0;
  static const double avatarSizeL = 48.0;
  static const double avatarSizeXL = 64.0;
  static const double avatarRadiusM = 20.0; // Common avatar radius for list items
  static const double statusDotSize = 10.0; // Online status indicator dot size

  // ============================================================================
  // ELEVATION
  // ============================================================================
  static const double elevationNone = 0.0;
  static const double elevationLow = 1.0;
  static const double elevationMedium = 2.0;
  static const double elevationHigh = 4.0;
  static const double elevationVeryHigh = 8.0;

  // ============================================================================
  // OPACITY VALUES
  // ============================================================================
  static const double opacityDisabled = 0.38;
  static const double opacityLow = 0.3;
  static const double opacityMediumLow = 0.5;
  static const double opacityMedium = 0.6;
  static const double opacityHigh = 0.8;
  static const double opacityFull = 1.0;

  // ============================================================================
  // BORDER WIDTHS
  // ============================================================================
  static const double borderWidthNone = 0.0;
  static const double borderWidthThin = 1.0;
  static const double borderWidthThinMedium = 1.5;
  static const double borderWidthMedium = 2.0;
  static const double borderWidthThick = 3.0;

  // ============================================================================
  // QUOTE COLORS (for BBCode quotes)
  // ============================================================================
  // Light mode quote background colors (2 levels for nesting)
  static const List<Color> quoteColorsLight = [
    Color(0xFFE8EAED), // Level 0: light grey
    Color(0xFFD5D9DE), // Level 1: darker grey
  ];

  // Dark mode quote background colors (2 levels for nesting)
  static const List<Color> quoteColorsDark = [
    Color(0xFF2C3136), // Level 0: medium dark grey
    Color(0xFF363B40), // Level 1: lighter dark grey
  ];
}

