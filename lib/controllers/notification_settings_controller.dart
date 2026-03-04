import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/notification_preferences.dart';
import '../services/notification_preferences_service.dart';
import 'push_notification_controller.dart';
import 'package:forumcopilot_flutter/core/errors/error_handling_mixins.dart';
import 'package:forumcopilot_flutter/core/logging/app_logger.dart';

/// Controller for managing notification settings UI
class NotificationSettingsController extends GetxController with ErrorHandlingMixin {
  static NotificationSettingsController get to => Get.find();

  final NotificationPreferencesService _preferencesService = NotificationPreferencesService();
  
  /// Get push notification controller, returns null if not registered
  PushNotificationController? get _pushController {
    if (Get.isRegistered<PushNotificationController>()) {
      return Get.find<PushNotificationController>();
    }
    return null;
  }

  // UI state
  final RxBool _isLoading = false.obs;
  final RxString _selectedForumId = ''.obs;
  final RxMap<String, NotificationPreferences> _preferencesCache = <String, NotificationPreferences>{}.obs;

  // Getters
  bool get isLoading => _isLoading.value;
  String get selectedForumId => _selectedForumId.value;
  Map<String, NotificationPreferences> get preferencesCache => Map.from(_preferencesCache);

  @override
  void onInit() {
    super.onInit();
    _loadAllPreferences();
  }

  /// Load preferences for all forums
  Future<void> _loadAllPreferences() async {
    try {
      _isLoading.value = true;

      final allPreferences = await _preferencesService.getAllPreferences();
      _preferencesCache.clear();
      _preferencesCache.addAll(allPreferences);

      AppLogger.debug('Loaded preferences for ${allPreferences.length} forums');
    } catch (e) {
      AppLogger.debug('Error loading preferences: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  /// Get preferences for a specific forum
  NotificationPreferences getPreferences(String forumId) {
    return _preferencesCache[forumId] ?? NotificationPreferences.defaultPreferences;
  }

  /// Update a specific preference
  Future<void> updatePreference(
    String forumId,
    String preferenceType,
    bool value,
  ) async {
    try {
      _isLoading.value = true;

      // Update in service
      await _preferencesService.updatePreference(forumId, preferenceType, value);

      // Update local cache
      final currentPreferences = getPreferences(forumId);
      NotificationPreferences updatedPreferences;

      switch (preferenceType) {
        case 'isEnabled':
          updatedPreferences = currentPreferences.copyWith(isEnabled: value);
          break;
        case 'newPosts':
          updatedPreferences = currentPreferences.copyWith(newPosts: value);
          break;
        case 'replies':
          updatedPreferences = currentPreferences.copyWith(replies: value);
          break;
        case 'mentions':
          updatedPreferences = currentPreferences.copyWith(mentions: value);
          break;
        case 'quotes':
          updatedPreferences = currentPreferences.copyWith(quotes: value);
          break;
        case 'likes':
          updatedPreferences = currentPreferences.copyWith(likes: value);
          break;
        case 'subscriptions':
          updatedPreferences = currentPreferences.copyWith(subscriptions: value);
          break;
        case 'privateMessages':
          updatedPreferences = currentPreferences.copyWith(privateMessages: value);
          break;
        case 'systemNotifications':
          updatedPreferences = currentPreferences.copyWith(systemNotifications: value);
          break;
        default:
          AppLogger.debug('Unknown preference type: $preferenceType');
          return;
      }

      _preferencesCache[forumId] = updatedPreferences;

      // Update in push controller if available
      if (_pushController != null && _pushController!.isInitialized) {
        await _pushController!.updatePreferences(forumId, updatedPreferences);
        AppLogger.debug('Updated preferences in push controller for forum $forumId');
      } else {
        AppLogger.debug('Push controller not available, preferences saved locally only');
      }

      // Show success feedback
      _showSuccessMessage('Notification preference updated');

      AppLogger.debug('Updated preference $preferenceType to $value for forum $forumId');
    } catch (e) {
      AppLogger.debug('Error updating preference: $e');
      _showErrorMessage('Failed to update preference: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  /// Toggle global notifications for a forum
  Future<void> toggleGlobalNotifications(String forumId) async {
    try {
      final currentPreferences = getPreferences(forumId);
      final newValue = !currentPreferences.isEnabled;

      await updatePreference(forumId, 'isEnabled', newValue);

      if (newValue) {
        AppLogger.debug('Enabled global notifications for forum $forumId');
      } else {
        AppLogger.debug('Disabled global notifications for forum $forumId');
      }
    } catch (e) {
      AppLogger.debug('Error toggling global notifications: $e');
    }
  }

  /// Enable all notifications for a forum
  Future<void> enableAllNotifications(String forumId) async {
    try {
      _isLoading.value = true;

      await _preferencesService.enableAllNotifications(forumId);

      // Update cache
      final enabledPreferences = NotificationPreferences.defaultPreferences.enableAll();
      _preferencesCache[forumId] = enabledPreferences;

      // Update in push controller if available
      if (_pushController != null) {
        await _pushController!.updatePreferences(forumId, enabledPreferences);
      }

      AppLogger.debug('Enabled all notifications for forum $forumId');
    } catch (e) {
      AppLogger.debug('Error enabling all notifications: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  /// Disable all notifications for a forum
  Future<void> disableAllNotifications(String forumId) async {
    try {
      _isLoading.value = true;

      await _preferencesService.disableAllNotifications(forumId);

      // Update cache
      final disabledPreferences = NotificationPreferences.defaultPreferences.disableAll();
      _preferencesCache[forumId] = disabledPreferences;

      // Update in push controller if available
      if (_pushController != null) {
        await _pushController!.updatePreferences(forumId, disabledPreferences);
      }

      AppLogger.debug('Disabled all notifications for forum $forumId');
    } catch (e) {
      AppLogger.debug('Error disabling all notifications: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  /// Set selected forum for detailed settings
  void setSelectedForum(String forumId) {
    _selectedForumId.value = forumId;
  }

  /// Clear selected forum
  void clearSelectedForum() {
    _selectedForumId.value = '';
  }

  /// Get preferences for selected forum
  NotificationPreferences get selectedForumPreferences {
    if (_selectedForumId.value.isEmpty) {
      return NotificationPreferences.defaultPreferences;
    }
    return getPreferences(_selectedForumId.value);
  }

  /// Check if a preference is enabled for selected forum
  bool isPreferenceEnabled(String preferenceType) {
    final preferences = selectedForumPreferences;

    switch (preferenceType) {
      case 'isEnabled':
        return preferences.isEnabled;
      case 'newPosts':
        return preferences.newPosts;
      case 'replies':
        return preferences.replies;
      case 'mentions':
        return preferences.mentions;
      case 'quotes':
        return preferences.quotes;
      case 'likes':
        return preferences.likes;
      case 'subscriptions':
        return preferences.subscriptions;
      case 'privateMessages':
        return preferences.privateMessages;
      case 'systemNotifications':
        return preferences.systemNotifications;
      default:
        return false;
    }
  }

  /// Get count of enabled preferences for a forum
  int getEnabledCount(String forumId) {
    final preferences = getPreferences(forumId);
    return preferences.enabledCount;
  }

  /// Check if any notifications are enabled for a forum
  bool hasAnyEnabled(String forumId) {
    final preferences = getPreferences(forumId);
    return preferences.hasAnyEnabled;
  }

  /// Get list of enabled preference types for a forum
  List<String> getEnabledTypes(String forumId) {
    final preferences = getPreferences(forumId);
    return preferences.enabledTypes;
  }

  /// Refresh preferences from storage
  Future<void> refreshPreferences() async {
    await _loadAllPreferences();
  }

  /// Get preference display name
  String getPreferenceDisplayName(String preferenceType) {
    switch (preferenceType) {
      case 'isEnabled':
        return 'Enable Notifications';
      case 'newPosts':
        return 'New Posts';
      case 'replies':
        return 'Replies';
      case 'mentions':
        return 'Mentions';
      case 'quotes':
        return 'Quotes';
      case 'likes':
        return 'Likes';
      case 'subscriptions':
        return 'Subscriptions';
      case 'privateMessages':
        return 'Private Messages';
      case 'systemNotifications':
        return 'System Notifications';
      default:
        return preferenceType;
    }
  }

  /// Get preference description
  String getPreferenceDescription(String preferenceType) {
    switch (preferenceType) {
      case 'isEnabled':
        return 'Enable or disable all notifications for this forum';
      case 'newPosts':
        return 'Get notified about new posts in subscribed forums';
      case 'replies':
        return 'Get notified when someone replies to your posts';
      case 'mentions':
        return 'Get notified when someone mentions you';
      case 'quotes':
        return 'Get notified when someone quotes your posts';
      case 'likes':
        return 'Get notified when someone likes your posts';
      case 'subscriptions':
        return 'Get notified about updates to your subscriptions';
      case 'privateMessages':
        return 'Get notified about new private messages';
      case 'systemNotifications':
        return 'Get notified about system updates and announcements';
      default:
        return 'Notification preference';
    }
  }

  /// Show success message
  void _showSuccessMessage(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.colorScheme.primaryContainer,
      colorText: Get.theme.colorScheme.onPrimaryContainer,
      icon: Icon(
        Icons.check_circle_outline,
        color: Get.theme.colorScheme.onPrimaryContainer,
      ),
      duration: const Duration(seconds: 2),
    );
  }

  /// Show error message
  void _showErrorMessage(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.colorScheme.errorContainer,
      colorText: Get.theme.colorScheme.onErrorContainer,
      icon: Icon(
        Icons.error_outline,
        color: Get.theme.colorScheme.onErrorContainer,
      ),
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }

  /// Get summary for logging
  String getSummary() {
    return 'NotificationSettingsController(loading: $_isLoading, selectedForum: $_selectedForumId, cachedPreferences: ${_preferencesCache.length})';
  }
}
