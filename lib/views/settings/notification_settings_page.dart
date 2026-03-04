import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controllers/push_notification_controller.dart';
import '../../controllers/notification_settings_controller.dart';
import '../../models/site_notification_state.dart';
import '../../theme/design_tokens.dart';
import '../../services/push_notification_service.dart';
import '../../l10n/generated/app_localizations.dart';

/// Main page for configuring notification settings
class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Check if controllers are registered before using them
    if (!Get.isRegistered<PushNotificationController>()) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Notification Settings',
            style: textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: DesignTokens.fontWeightSemiBold,
              fontSize: DesignTokens.fontSizeL,
            ),
          ),
          backgroundColor: colorScheme.surface,
          elevation: DesignTokens.elevationMedium,
          shadowColor: colorScheme.shadow.withOpacity(DesignTokens.opacityLow),
          surfaceTintColor: colorScheme.surfaceTint,
        ),
        body: Center(
          child: Padding(
            padding: DesignTokens.paddingScreenHorizontal,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: DesignTokens.iconSizeXXL,
                  color: colorScheme.error,
                ),
                SizedBox(height: DesignTokens.spacingL),
                Text(
                  'Notification system not initialized',
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: DesignTokens.fontWeightSemiBold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: DesignTokens.spacingM),
                Text(
                  'Please restart the app to initialize the notification system.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notification Settings',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: DesignTokens.fontWeightSemiBold,
            fontSize: DesignTokens.fontSizeL,
          ),
        ),
        backgroundColor: colorScheme.surface,
        elevation: DesignTokens.elevationMedium,
        shadowColor: colorScheme.shadow.withOpacity(DesignTokens.opacityLow),
        surfaceTintColor: colorScheme.surfaceTint,
      ),
      body: GetBuilder<PushNotificationController>(
        builder: (pushController) {
          if (!pushController.isInitialized) {
            return Center(
              child: CircularProgressIndicator(
                color: colorScheme.primary,
              ),
            );
          }

          final registeredSites = pushController.registeredSites;

          return Column(
            children: [
              // Debug info banner
              _buildDebugBanner(pushController, registeredSites, colorScheme, textTheme),

              // Global error banner
              if (pushController.lastError != null) _buildErrorBanner(pushController, colorScheme, textTheme),

              // Main content
              Expanded(
                child: registeredSites.isEmpty ? _buildEmptyState(context, colorScheme, textTheme) : _buildSitesList(registeredSites),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Build debug info banner
  Widget _buildDebugBanner(
    PushNotificationController pushController,
    List<SiteNotificationState> registeredSites,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(DesignTokens.spacingM),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.5),
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withOpacity(DesignTokens.opacityLow),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: DesignTokens.iconSizeM,
                color: colorScheme.primary,
              ),
              SizedBox(width: DesignTokens.spacingS),
              SelectableText(
                'Debug Info',
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: DesignTokens.fontWeightSemiBold,
                  fontSize: DesignTokens.fontSizeS,
                ),
                enableInteractiveSelection: false,
              ),
            ],
          ),
          SizedBox(height: DesignTokens.spacingS),
          _buildDebugInfoRow(
            'Device ID',
            pushController.deviceId ?? 'N/A',
            colorScheme,
            textTheme,
          ),
          SizedBox(height: DesignTokens.spacingXS),
          _buildDebugInfoRow(
            'FCM Token',
            pushController.fcmToken != null ? '${pushController.fcmToken!.substring(0, 20)}...' : 'N/A',
            colorScheme,
            textTheme,
          ),
          SizedBox(height: DesignTokens.spacingXS),
          _buildDebugInfoRow(
            'API Base URL',
            PushNotificationService.baseUrl,
            colorScheme,
            textTheme,
          ),
          if (registeredSites.isNotEmpty) ...[
            SizedBox(height: DesignTokens.spacingXS),
            _buildDebugInfoRow(
              'Registered Sites',
              '${registeredSites.length} site(s)',
              colorScheme,
              textTheme,
            ),
            ...registeredSites.map((site) => Padding(
                  padding: EdgeInsets.only(
                    left: DesignTokens.spacingL,
                    top: DesignTokens.spacingXS,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDebugInfoRow(
                        '  Site ID',
                        site.siteId,
                        colorScheme,
                        textTheme,
                        fontSize: DesignTokens.fontSizeXS,
                      ),
                      SizedBox(height: DesignTokens.spacingXS / 2),
                      _buildDebugInfoRow(
                        '  User ID',
                        site.userId,
                        colorScheme,
                        textTheme,
                        fontSize: DesignTokens.fontSizeXS,
                      ),
                    ],
                  ),
                )),
          ],
        ],
      ),
    );
  }

  /// Build a single debug info row
  Widget _buildDebugInfoRow(
    String label,
    String value,
    ColorScheme colorScheme,
    TextTheme textTheme, {
    double? fontSize,
  }) {
    return InkWell(
      onTap: () {
        Clipboard.setData(ClipboardData(text: value));
        Get.snackbar(
          'Copied',
          '$label copied to clipboard',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 1),
          backgroundColor: colorScheme.primaryContainer,
          colorText: colorScheme.onPrimaryContainer,
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: SelectableText(
              label,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: fontSize ?? DesignTokens.fontSizeS,
                fontWeight: DesignTokens.fontWeightMedium,
              ),
              enableInteractiveSelection: false,
            ),
          ),
          Expanded(
            child: SelectableText(
              value,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface,
                fontSize: fontSize ?? DesignTokens.fontSizeS,
                fontFamily: 'monospace',
              ),
            ),
          ),
          SizedBox(width: DesignTokens.spacingXS),
          Icon(
            Icons.copy_rounded,
            size: DesignTokens.iconSizeS,
            color: colorScheme.onSurfaceVariant.withOpacity(0.6),
          ),
        ],
      ),
    );
  }

  /// Build global error banner
  Widget _buildErrorBanner(
    PushNotificationController controller,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final isNetworkError = controller.hasNetworkError;
    final errorColor = isNetworkError ? colorScheme.errorContainer : colorScheme.errorContainer;
    final onErrorColor = isNetworkError ? colorScheme.onErrorContainer : colorScheme.onErrorContainer;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(DesignTokens.spacingL),
      padding: DesignTokens.paddingM,
      decoration: BoxDecoration(
        color: errorColor,
        border: Border.all(
          color: colorScheme.error,
          width: DesignTokens.borderWidthThin,
        ),
        borderRadius: BorderRadius.circular(DesignTokens.radiusM),
      ),
      child: Row(
        children: [
          Icon(
            isNetworkError ? Icons.wifi_off_rounded : Icons.error_outline_rounded,
            color: onErrorColor,
            size: DesignTokens.iconSizeM,
          ),
          SizedBox(width: DesignTokens.spacingM),
          Expanded(
            child: SelectableText(
              isNetworkError ? 'Connection error. Check your internet connection.' : 'System error: ${controller.lastError}',
              style: textTheme.bodySmall?.copyWith(
                color: onErrorColor,
                fontSize: DesignTokens.fontSizeS,
              ),
              enableInteractiveSelection: false,
            ),
          ),
          IconButton(
            onPressed: () => controller.clearError(),
            icon: Icon(
              Icons.close_rounded,
              size: DesignTokens.iconSizeS,
            ),
            color: onErrorColor,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  /// Build empty state when no sites are registered
  Widget _buildEmptyState(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    return Center(
      child: Padding(
        padding: DesignTokens.paddingScreenHorizontal,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: DesignTokens.iconSizeXXL * 1.5,
              height: DesignTokens.iconSizeXXL * 1.5,
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant.withOpacity(DesignTokens.opacityLow),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_off_outlined,
                size: DesignTokens.iconSizeXXL,
                color: colorScheme.onSurfaceVariant.withOpacity(DesignTokens.opacityMedium),
              ),
            ),
            SizedBox(height: DesignTokens.spacingXL),
            Text(
              'No Forums Registered',
              style: textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: DesignTokens.fontWeightSemiBold,
                fontSize: DesignTokens.fontSizeXL,
              ),
            ),
            SizedBox(height: DesignTokens.spacingM),
            Text(
              'Login to forums to configure notifications',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: DesignTokens.fontSizeM,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: DesignTokens.spacingXXL),
            ElevatedButton.icon(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.login_rounded),
              label: Text(AppLocalizations.of(context)?.goToForums ?? 'Go to Forums'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacingXL,
                  vertical: DesignTokens.spacingM,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build list of registered sites
  Widget _buildSitesList(List<SiteNotificationState> sites) {
    return ListView.builder(
      padding: EdgeInsets.all(DesignTokens.spacingL),
      itemCount: sites.length,
      itemBuilder: (context, index) {
        final site = sites[index];
        return Padding(
          padding: EdgeInsets.only(bottom: DesignTokens.spacingL),
          child: SiteNotificationCard(siteState: site),
        );
      },
    );
  }
}

/// Card widget for each site's notification settings
class SiteNotificationCard extends StatelessWidget {
  final SiteNotificationState siteState;

  const SiteNotificationCard({
    Key? key,
    required this.siteState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: DesignTokens.elevationLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusM),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: colorScheme.outline.withOpacity(DesignTokens.opacityLow),
        ),
        child: ExpansionTile(
          tilePadding: DesignTokens.paddingL,
          childrenPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            radius: DesignTokens.avatarRadiusM / 2,
            backgroundColor: colorScheme.primaryContainer,
            child: Text(
              siteState.siteName.isNotEmpty ? siteState.siteName[0].toUpperCase() : 'F',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onPrimaryContainer,
                fontWeight: DesignTokens.fontWeightSemiBold,
                fontSize: DesignTokens.fontSizeM,
              ),
            ),
          ),
          title: Text(
            siteState.siteName,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: DesignTokens.fontWeightSemiBold,
              fontSize: DesignTokens.fontSizeM,
            ),
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(top: DesignTokens.spacingXS),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'User: ${siteState.username}',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: DesignTokens.fontSizeS,
                  ),
                ),
                SizedBox(height: DesignTokens.spacingXS),
                Row(
                  children: [
                    Icon(
                      siteState.isRegistered ? Icons.check_circle_rounded : Icons.error_rounded,
                      size: DesignTokens.iconSizeS,
                      color: siteState.isRegistered ? colorScheme.primary : colorScheme.error,
                    ),
                    SizedBox(width: DesignTokens.spacingXS),
                    Text(
                      siteState.statusDescription,
                      style: textTheme.bodySmall?.copyWith(
                        color: siteState.isRegistered ? colorScheme.primary : colorScheme.error,
                        fontWeight: DesignTokens.fontWeightMedium,
                        fontSize: DesignTokens.fontSizeS,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          children: [
            if (siteState.isRegistered) ...[
              _buildGlobalToggle(context),
              if (siteState.preferences.isEnabled) ...[
                Divider(height: 1),
                _buildPreferenceToggles(context),
              ],
            ] else ...[
              _buildErrorState(context),
            ],
          ],
        ),
      ),
    );
  }

  /// Build global enable/disable toggle
  Widget _buildGlobalToggle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (!Get.isRegistered<NotificationSettingsController>()) {
      return Padding(
        padding: DesignTokens.paddingL,
        child: Text(
          'Settings controller not available',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.error,
          ),
        ),
      );
    }

    return GetBuilder<NotificationSettingsController>(
      builder: (settingsController) {
        return Padding(
          padding: DesignTokens.paddingL,
          child: SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              'Enable Notifications',
              style: textTheme.titleSmall?.copyWith(
                fontWeight: DesignTokens.fontWeightMedium,
                fontSize: DesignTokens.fontSizeM,
              ),
            ),
            subtitle: Padding(
              padding: EdgeInsets.only(top: DesignTokens.spacingXS),
              child: Text(
                'Turn on/off all notifications for this forum',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: DesignTokens.fontSizeS,
                ),
              ),
            ),
            value: siteState.preferences.isEnabled,
            onChanged: (value) {
              settingsController.updatePreference(
                siteState.siteId,
                'isEnabled',
                value,
              );
            },
            secondary: Container(
              width: DesignTokens.iconSizeXL,
              height: DesignTokens.iconSizeXL,
              decoration: BoxDecoration(
                color: siteState.preferences.isEnabled ? colorScheme.primaryContainer : colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(DesignTokens.radiusS),
              ),
              child: Icon(
                siteState.preferences.isEnabled ? Icons.notifications_active_rounded : Icons.notifications_off_rounded,
                color: siteState.preferences.isEnabled ? colorScheme.onPrimaryContainer : colorScheme.onSurfaceVariant,
                size: DesignTokens.iconSizeM,
              ),
            ),
          ),
        );
      },
    );
  }

  /// Build individual preference toggles
  Widget _buildPreferenceToggles(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (!Get.isRegistered<NotificationSettingsController>()) {
      return Padding(
        padding: DesignTokens.paddingL,
        child: Text(
          'Settings controller not available',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.error,
          ),
        ),
      );
    }

    final preferences = [
      ('newPosts', 'New Posts', 'Get notified about new posts', Icons.article_rounded),
      ('replies', 'Replies', 'Get notified when someone replies to your posts', Icons.reply_rounded),
      ('mentions', 'Mentions', 'Get notified when someone mentions you', Icons.alternate_email_rounded),
      ('quotes', 'Quotes', 'Get notified when someone quotes your posts', Icons.format_quote_rounded),
      ('likes', 'Likes', 'Get notified when someone likes your posts', Icons.favorite_rounded),
      ('subscriptions', 'Subscriptions', 'Get notified about subscription updates', Icons.subscriptions_rounded),
      ('privateMessages', 'Private Messages', 'Get notified about new private messages', Icons.mail_rounded),
      ('systemNotifications', 'System Notifications', 'Get notified about system updates', Icons.info_rounded),
    ];

    return GetBuilder<NotificationSettingsController>(
      builder: (settingsController) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: DesignTokens.spacingL,
            vertical: DesignTokens.spacingM,
          ),
          child: Column(
            children: preferences.map((pref) {
              final (key, title, description, icon) = pref;
              final isEnabled = _getPreferenceValue(key);

              return Padding(
                padding: EdgeInsets.only(bottom: DesignTokens.spacingS),
                child: SwitchListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacingS,
                    vertical: DesignTokens.spacingXS,
                  ),
                  dense: true,
                  title: Row(
                    children: [
                      Icon(
                        icon,
                        size: DesignTokens.iconSizeSMedium,
                        color: isEnabled ? colorScheme.primary : colorScheme.onSurfaceVariant,
                      ),
                      SizedBox(width: DesignTokens.spacingM),
                      Expanded(
                        child: Text(
                          title,
                          style: textTheme.bodyLarge?.copyWith(
                            fontWeight: DesignTokens.fontWeightNormal,
                            fontSize: DesignTokens.fontSizeM,
                          ),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: EdgeInsets.only(
                      left: DesignTokens.iconSizeSMedium + DesignTokens.spacingM,
                      top: DesignTokens.spacingXS / 2,
                    ),
                    child: Text(
                      description,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: DesignTokens.fontSizeS,
                      ),
                    ),
                  ),
                  value: isEnabled,
                  onChanged: (value) {
                    settingsController.updatePreference(
                      siteState.siteId,
                      key,
                      value,
                    );
                  },
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  /// Build error state for unregistered sites
  Widget _buildErrorState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final isNetworkError = siteState.errorMessage?.toLowerCase().contains('network') == true ||
        siteState.errorMessage?.toLowerCase().contains('connection') == true ||
        siteState.errorMessage?.toLowerCase().contains('timeout') == true;

    return Padding(
      padding: DesignTokens.paddingL,
      child: Column(
        children: [
          Container(
            width: DesignTokens.iconSizeXXL,
            height: DesignTokens.iconSizeXXL,
            decoration: BoxDecoration(
              color: (isNetworkError ? colorScheme.errorContainer : colorScheme.errorContainer).withOpacity(DesignTokens.opacityLow),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isNetworkError ? Icons.wifi_off_rounded : Icons.error_outline_rounded,
              color: isNetworkError ? colorScheme.error : colorScheme.error,
              size: DesignTokens.iconSizeXL,
            ),
          ),
          SizedBox(height: DesignTokens.spacingM),
          Text(
            isNetworkError ? 'Connection Error' : 'Registration Failed',
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.error,
              fontWeight: DesignTokens.fontWeightSemiBold,
              fontSize: DesignTokens.fontSizeM,
            ),
          ),
          SizedBox(height: DesignTokens.spacingXS),
          Text(
            isNetworkError ? 'Check your internet connection and try again' : siteState.errorMessage ?? 'Unknown error occurred',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontSize: DesignTokens.fontSizeS,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: DesignTokens.spacingL),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    if (Get.isRegistered<PushNotificationController>()) {
                      Get.find<PushNotificationController>().retryFailedRegistrations();
                    }
                  },
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(AppLocalizations.of(context)?.retry ?? 'Retry'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: DesignTokens.spacingM),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                    ),
                  ),
                ),
              ),
              SizedBox(width: DesignTokens.spacingM),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    if (Get.isRegistered<PushNotificationController>()) {
                      Get.find<PushNotificationController>().unregisterSite(siteState.siteId);
                    }
                  },
                  icon: const Icon(Icons.remove_circle_outline_rounded),
                  label: Text(AppLocalizations.of(context)?.remove ?? 'Remove'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: DesignTokens.spacingM),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Get preference value by key
  bool _getPreferenceValue(String key) {
    switch (key) {
      case 'newPosts':
        return siteState.preferences.newPosts;
      case 'replies':
        return siteState.preferences.replies;
      case 'mentions':
        return siteState.preferences.mentions;
      case 'quotes':
        return siteState.preferences.quotes;
      case 'likes':
        return siteState.preferences.likes;
      case 'subscriptions':
        return siteState.preferences.subscriptions;
      case 'privateMessages':
        return siteState.preferences.privateMessages;
      case 'systemNotifications':
        return siteState.preferences.systemNotifications;
      default:
        return false;
    }
  }
}
