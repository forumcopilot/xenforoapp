import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';
import 'package:xenforo_core/xenforo_core.dart';
import 'package:forumcopilot_flutter/core/errors/error_handling_mixins.dart';

/// Service for managing forum operations
/// This service provides a clean interface for forum operations
/// and handles the initialization of the SiteProxyFactory
class SiteProxyService with ServiceErrorHandlingMixin {
  static bool _initialized = false;

  /// Initialize the forum service with a site context
  static void initialize(SiteContext context) {
    // Register XenForo implementation
    SiteProxyFactory.register('xenforo', XenForoProxyFactory());

    // Initialize the factory
    SiteProxyFactory.initialize(context);

    _initialized = true;
  }

  /// Check if the service is initialized
  static bool get isInitialized => _initialized;

  /// Get user proxy
  static IFCUserProxy getUserProxy() {
    if (!_initialized) throw Exception('SiteProxyService not initialized');
    return SiteProxyFactory.getUserProxy();
  }

  /// Get forum proxy
  static IFCForumProxy getForumProxy() {
    if (!_initialized) throw Exception('SiteProxyService not initialized');
    return SiteProxyFactory.getForumProxy();
  }

  /// Get topic proxy
  static IFCTopicProxy getTopicProxy() {
    if (!_initialized) throw Exception('SiteProxyService not initialized');
    return SiteProxyFactory.getTopicProxy();
  }

  /// Get post proxy
  static IFCPostProxy getPostProxy() {
    if (!_initialized) throw Exception('SiteProxyService not initialized');
    return SiteProxyFactory.getPostProxy();
  }

  /// Get account proxy
  static IFCAccountProxy getAccountProxy() {
    if (!_initialized) throw Exception('SiteProxyService not initialized');
    return SiteProxyFactory.getAccountProxy();
  }

  /// Get subscription proxy
  static IFCSubscriptionProxy getSubscriptionProxy() {
    if (!_initialized) throw Exception('SiteProxyService not initialized');
    return SiteProxyFactory.getSubscriptionProxy();
  }

  /// Get moderation proxy
  static IFCModerationProxy getModerationProxy() {
    if (!_initialized) throw Exception('SiteProxyService not initialized');
    return SiteProxyFactory.getModerationProxy();
  }

  /// Get search proxy
  static IFCSearchProxy getSearchProxy() {
    if (!_initialized) throw Exception('SiteProxyService not initialized');
    return SiteProxyFactory.getSearchProxy();
  }

  /// Get social proxy
  static IFCSocialProxy getSocialProxy() {
    if (!_initialized) throw Exception('SiteProxyService not initialized');
    return SiteProxyFactory.getSocialProxy();
  }

  /// Get private conversation proxy
  static IFCPrivateConversationProxy getPrivateConversationProxy() {
    if (!_initialized) throw Exception('SiteProxyService not initialized');
    return SiteProxyFactory.getPrivateConversationProxy();
  }

  /// Get private message proxy
  static IFCPrivateMessageProxy getPrivateMessageProxy() {
    if (!_initialized) throw Exception('SiteProxyService not initialized');
    return SiteProxyFactory.getPrivateMessageProxy();
  }

  /// Get attachment proxy
  static IFCAttachmentProxy getAttachmentProxy() {
    if (!_initialized) throw Exception('SiteProxyService not initialized');
    return SiteProxyFactory.getAttachmentProxy();
  }

  /// Get config proxy
  static IFCConfigProxy getConfigProxy() {
    if (!_initialized) throw Exception('SiteProxyService not initialized');
    return SiteProxyFactory.getConfigProxy();
  }

  /// Get device proxy (BYO/direct push device registration on the customer's XF server).
  static IFCDeviceProxy getDeviceProxy() {
    if (!_initialized) throw Exception('SiteProxyService not initialized');
    return SiteProxyFactory.getDeviceProxy();
  }
}
