import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/site_controller.dart';

/// Service to manage user state logic and provide UI information
class UserStateService extends GetxService {
  static UserStateService get to => Get.find<UserStateService>();

  // Observable to track dismissed banners (public so banner can observe it)
  final RxSet<String> dismissedBanners = <String>{}.obs;

  // Debug flag: Set to true to automatically clear dismissed banners on init (for testing)
  static const bool _debugAutoClearDismissed = true;

  /// Get the current user state from the active site
  String? getCurrentUserState() {
    final siteController = Get.find<SiteController>();
    final currentSiteContext = siteController.currentSiteContext.value;
    if (currentSiteContext == null) return null;

    return currentSiteContext.loginDataOutput?.user?.userState;
  }

  @override
  void onInit() {
    super.onInit();
    if (_debugAutoClearDismissed && kDebugMode) {
      // Debug mode: Clear dismissed banners for testing
      dismissedBanners.clear();
      _saveDismissedBanners();
    } else {
      _loadDismissedBanners();
    }
  }

  /// Load dismissed banners from SharedPreferences
  Future<void> _loadDismissedBanners() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dismissedList = prefs.getStringList('user_state_banner_dismissed') ?? [];
      dismissedBanners.clear();
      dismissedBanners.addAll(dismissedList);
    } catch (e) {
      // Silently fail - banner will show if we can't load dismissed state
    }
  }

  /// Save dismissed banners to SharedPreferences
  Future<void> _saveDismissedBanners() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('user_state_banner_dismissed', dismissedBanners.toList());
    } catch (e) {
      // Silently fail
    }
  }

  /// Get the key for a dismissed banner (user ID + user state)
  String _getDismissKey(String? userId, String? userState) {
    if (userState == null) return '';
    // Special case: logout state doesn't need userId
    if (userState == 'logout') {
      return 'logout';
    }
    if (userId == null) return '';
    return '${userId}_$userState';
  }

  /// Check if a banner is dismissed for the current user
  bool isBannerDismissed(String? userId, String? userState) {
    if (userState == null) return false;
    // Special case: logout state doesn't need userId
    if (userState == 'logout') {
      final key = _getDismissKey(null, userState);
      return dismissedBanners.contains(key);
    }
    if (userId == null) return false;
    final key = _getDismissKey(userId, userState);
    return dismissedBanners.contains(key);
  }

  /// Dismiss a banner for the current user
  Future<void> dismissBanner(String? userId, String? userState) async {
    if (userState == null) return;
    // Special case: logout state doesn't need userId
    if (userState == 'logout') {
      final key = _getDismissKey(null, userState);
      dismissedBanners.add(key);
      await _saveDismissedBanners();
      return;
    }
    if (userId == null) return;
    final key = _getDismissKey(userId, userState);
    dismissedBanners.add(key);
    await _saveDismissedBanners();
  }

  /// Clear all dismissed banners (useful for testing)
  Future<void> clearDismissedBanners() async {
    dismissedBanners.clear();
    await _saveDismissedBanners();
  }

  /// Clear dismissed banner for a specific user and state
  Future<void> clearDismissedBanner(String? userId, String? userState) async {
    if (userId == null || userState == null) return;
    final key = _getDismissKey(userId, userState);
    dismissedBanners.remove(key);
    await _saveDismissedBanners();
  }

  /// Check if banner should be shown for the current user state
  bool shouldShowBanner() {
    final siteController = Get.find<SiteController>();
    final currentSiteContext = siteController.currentSiteContext.value;
    if (currentSiteContext == null) return false;

    final userState = getCurrentUserState();
    if (userState == null) return false;

    // Don't show for valid state (no banner needed)
    if (userState == 'valid') return false;

    // Don't show if banner is dismissed
    final userId = currentSiteContext.loginDataOutput?.user?.id;
    if (isBannerDismissed(userId, userState)) {
      return false;
    }

    // Show banner for any non-valid state (moderated, email_confirm, disabled, rejected, etc.)
    return true;
  }

  /// Get the message to display for a given user state
  String getMessageForState(String? userState, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (userState) {
      case 'moderated':
        return l10n.accountPendingApproval;
      case 'email_confirm':
        return l10n.checkEmailToConfirm;
      case 'email_confirm_edit':
        return l10n.checkNewEmailToConfirm;
      case 'email_bounce':
        return l10n.emailAddressInvalid;
      case 'disabled':
        return l10n.accountDisabled;
      case 'rejected':
        return l10n.accountRegistrationRejected;
      case 'valid':
        return l10n.welcomeToForumCopilot;
      case 'logout':
        return l10n.successfullyLoggedOut;
      case null:
        return '';
      default:
        // Generic message for any other unknown non-valid state
        return l10n.accountStatusRequiresAttention;
    }
  }

  /// Get the icon to display for a given user state
  IconData getIconForState(String? userState) {
    switch (userState) {
      case 'moderated':
        return Icons.pending_actions_rounded;
      case 'email_confirm':
      case 'email_confirm_edit':
        return Icons.email_outlined;
      case 'email_bounce':
        return Icons.warning_amber_rounded;
      case 'disabled':
      case 'rejected':
        return Icons.block_rounded;
      case 'valid':
        return Icons.waving_hand_rounded;
      case 'logout':
        return Icons.check_circle_rounded;
      case null:
      default:
        return Icons.info_outline;
    }
  }

  /// Get the background color to use for a given user state (Material 3)
  Color getColorForState(String? userState, BuildContext context) {
    final theme = Theme.of(context);
    switch (userState) {
      case 'moderated':
        // Warning state - use tertiary container (Material 3 warning color)
        return theme.colorScheme.tertiaryContainer;
      case 'email_bounce':
      case 'disabled':
      case 'rejected':
        // Error states - use error container (Material 3 error color)
        return theme.colorScheme.errorContainer;
      case 'email_confirm':
      case 'email_confirm_edit':
        // Informational state - use primary container (Material 3 info color)
        return theme.colorScheme.primaryContainer;
      case 'valid':
        // Welcome message - use primary container (Material 3 primary color)
        return theme.colorScheme.primaryContainer;
      case 'logout':
        // Logout message - use primary container (Material 3 primary color)
        return theme.colorScheme.primaryContainer;
      case null:
      default:
        // Default for unknown states - use surface container
        return theme.colorScheme.surfaceContainerHighest;
    }
  }

  /// Get the text color to use for a given user state (Material 3)
  Color getTextColorForState(String? userState, BuildContext context) {
    final theme = Theme.of(context);
    switch (userState) {
      case 'moderated':
        // Warning state - use on tertiary container
        return theme.colorScheme.onTertiaryContainer;
      case 'email_bounce':
      case 'disabled':
      case 'rejected':
        // Error states - use on error container
        return theme.colorScheme.onErrorContainer;
      case 'email_confirm':
      case 'email_confirm_edit':
        // Informational state - use on primary container
        return theme.colorScheme.onPrimaryContainer;
      case 'valid':
        // Welcome message - use on primary container
        return theme.colorScheme.onPrimaryContainer;
      case 'logout':
        // Logout message - use on primary container
        return theme.colorScheme.onPrimaryContainer;
      case null:
      default:
        // Default for unknown states - use on surface
        return theme.colorScheme.onSurface;
    }
  }

  /// Check if the banner can be dismissed for a given state
  bool canDismissBanner(String? userState) {
    // Allow dismissing for email states, welcome message, and logout, but not for moderated, disabled, or rejected (more critical)
    return userState == 'valid' || userState == 'logout' || userState == 'email_confirm' || userState == 'email_confirm_edit' || userState == 'email_bounce';
  }

  /// Get action text for the banner (if any)
  String? getActionTextForState(String? userState, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (userState) {
      case 'email_bounce':
        return l10n.updateEmail;
      case 'email_confirm':
      case 'email_confirm_edit':
        return l10n.resend;
      default:
        return null;
    }
  }

  /// Handle action button press for a given state
  void handleAction(String? userState) {
    switch (userState) {
      case 'email_bounce':
        // Navigate to account settings to update email
        // TODO: Implement navigation to account settings
        break;
      case 'email_confirm':
      case 'email_confirm_edit':
        // TODO: Implement resend confirmation email
        break;
      default:
        break;
    }
  }
}
