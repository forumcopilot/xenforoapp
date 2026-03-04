import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/user_state_service.dart';
import '../../controllers/site_controller.dart';
import '../../theme/design_tokens.dart';

/// Banner that shows at the top of the app when user account has a non-valid state or welcome message
class UserStateBanner extends StatefulWidget {
  const UserStateBanner({super.key});

  @override
  State<UserStateBanner> createState() => _UserStateBannerState();
}

class _UserStateBannerState extends State<UserStateBanner> {
  Timer? _welcomeTimer;

  @override
  void dispose() {
    _welcomeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<UserStateService>()) {
      return const SizedBox.shrink();
    }

    if (!Get.isRegistered<SiteController>()) {
      return const SizedBox.shrink();
    }

    final userStateService = Get.find<UserStateService>();
    final siteController = Get.find<SiteController>();

    return Obx(() {
      // Observe dismissed banners to react to dismissals
      final _ = userStateService.dismissedBanners.length;

      // Check if we have a current site context
      final currentSiteContext = siteController.currentSiteContext.value;
      if (currentSiteContext == null) {
        return const SizedBox.shrink();
      }

      // Use ValueListenableBuilder to react to login state changes
      return ValueListenableBuilder<bool>(
        valueListenable: currentSiteContext.isLoggedInNotifier,
        builder: (context, isLoggedIn, child) {
          // Get user state from the current site context
          final userState = currentSiteContext.loginDataOutput?.user?.userState;
          final userIdInt = currentSiteContext.loginDataOutput?.user?.id;

          // Only show when user is logged in
          if (!isLoggedIn || userState == null) {
            return const SizedBox.shrink();
          }

          // Handle welcome message for valid state - banner removed per user request
          if (userState == 'valid') {
            // Cancel welcome timer if it's running
            _welcomeTimer?.cancel();
            return const SizedBox.shrink();
          }

          // Use the service's shouldShowBanner() method to determine if banner should be shown
          // This will show banner for any non-valid state (moderated, email_confirm, disabled, rejected, etc.)
          if (!userStateService.shouldShowBanner()) {
            return const SizedBox.shrink();
          }

          // Check if banner is dismissed
          final isDismissed = userStateService.isBannerDismissed(userIdInt, userState);
          if (isDismissed) {
            return const SizedBox.shrink();
          }

          final message = userStateService.getMessageForState(userState, context);
          final icon = userStateService.getIconForState(userState);
          final backgroundColor = userStateService.getColorForState(userState, context);
          final textColor = userStateService.getTextColorForState(userState, context);
          final canDismiss = userStateService.canDismissBanner(userState);

          return Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: DesignTokens.spacingL,
              vertical: DesignTokens.spacingM,
            ),
            color: backgroundColor,
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: textColor,
                    size: DesignTokens.iconSizeM,
                  ),
                  SizedBox(width: DesignTokens.spacingM),
                  Expanded(
                    child: Text(
                      message,
                      style: TextStyle(
                        color: textColor,
                        fontSize: DesignTokens.fontSizeS,
                        fontWeight: DesignTokens.fontWeightMedium,
                      ),
                    ),
                  ),
                  if (canDismiss) ...[
                    SizedBox(width: DesignTokens.spacingS),
                    IconButton(
                      onPressed: () async {
                        await userStateService.dismissBanner(userIdInt, userState);
                        // The Obx will automatically rebuild when dismissedBanners changes
                        // because shouldShowBanner() checks the dismissed state
                      },
                      icon: Icon(
                        Icons.close,
                        color: textColor,
                        size: DesignTokens.iconSizeM,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
