import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/interfaces/interfaces.dart';

/// Abstract factory for creating forum proxies
/// This allows for different forum implementations to be registered and used
abstract class SiteProxyFactory {
  static SiteContext? _context;
  static Map<String, SiteProxyFactory> _providers = {};

  /// Initialize the factory with a site context
  static void initialize(SiteContext context) {
    _context = context;
  }

  /// Register a provider for a specific site type
  static void register(String siteType, SiteProxyFactory factory) {
    _providers[siteType] = factory;
  }

  /// Get the current site context
  static SiteContext? get context => _context;

  /// Get user proxy
  static IFCUserProxy getUserProxy() {
    if (_context == null) throw Exception('SiteProxyFactory not initialized');

    final factory = _providers[_context!.siteType];
    if (factory == null) throw Exception('No provider registered for site type: ${_context!.siteType}');

    return factory.createUserProxy(_context!);
  }

  /// Get forum proxy
  static IFCForumProxy getForumProxy() {
    if (_context == null) throw Exception('SiteProxyFactory not initialized');

    final factory = _providers[_context!.siteType];
    if (factory == null) throw Exception('No provider registered for site type: ${_context!.siteType}');

    return factory.createForumProxy(_context!);
  }

  /// Get topic proxy
  static IFCTopicProxy getTopicProxy() {
    if (_context == null) throw Exception('SiteProxyFactory not initialized');

    final factory = _providers[_context!.siteType];
    if (factory == null) throw Exception('No provider registered for site type: ${_context!.siteType}');

    return factory.createTopicProxy(_context!);
  }

  /// Get post proxy
  static IFCPostProxy getPostProxy() {
    if (_context == null) throw Exception('SiteProxyFactory not initialized');

    final factory = _providers[_context!.siteType];
    if (factory == null) throw Exception('No provider registered for site type: ${_context!.siteType}');

    return factory.createPostProxy(_context!);
  }

  /// Get account proxy
  static IFCAccountProxy getAccountProxy() {
    if (_context == null) throw Exception('SiteProxyFactory not initialized');

    final factory = _providers[_context!.siteType];
    if (factory == null) throw Exception('No provider registered for site type: ${_context!.siteType}');

    return factory.createAccountProxy(_context!);
  }

  /// Get subscription proxy
  static IFCSubscriptionProxy getSubscriptionProxy() {
    if (_context == null) throw Exception('SiteProxyFactory not initialized');

    final factory = _providers[_context!.siteType];
    if (factory == null) throw Exception('No provider registered for site type: ${_context!.siteType}');

    return factory.createSubscriptionProxy(_context!);
  }

  /// Get moderation proxy
  static IFCModerationProxy getModerationProxy() {
    if (_context == null) throw Exception('SiteProxyFactory not initialized');

    final factory = _providers[_context!.siteType];
    if (factory == null) throw Exception('No provider registered for site type: ${_context!.siteType}');

    return factory.createModerationProxy(_context!);
  }

  /// Get search proxy
  static IFCSearchProxy getSearchProxy() {
    if (_context == null) throw Exception('SiteProxyFactory not initialized');

    final factory = _providers[_context!.siteType];
    if (factory == null) throw Exception('No provider registered for site type: ${_context!.siteType}');

    return factory.createSearchProxy(_context!);
  }

  /// Get social proxy
  static IFCSocialProxy getSocialProxy() {
    if (_context == null) throw Exception('SiteProxyFactory not initialized');

    final factory = _providers[_context!.siteType];
    if (factory == null) throw Exception('No provider registered for site type: ${_context!.siteType}');

    return factory.createSocialProxy(_context!);
  }

  /// Get private conversation proxy
  static IFCPrivateConversationProxy getPrivateConversationProxy() {
    if (_context == null) throw Exception('SiteProxyFactory not initialized');

    final factory = _providers[_context!.siteType];
    if (factory == null) throw Exception('No provider registered for site type: ${_context!.siteType}');

    return factory.createPrivateConversationProxy(_context!);
  }

  /// Get private message proxy
  static IFCPrivateMessageProxy getPrivateMessageProxy() {
    if (_context == null) throw Exception('SiteProxyFactory not initialized');

    final factory = _providers[_context!.siteType];
    if (factory == null) throw Exception('No provider registered for site type: ${_context!.siteType}');

    return factory.createPrivateMessageProxy(_context!);
  }

  /// Get attachment proxy
  static IFCAttachmentProxy getAttachmentProxy() {
    if (_context == null) throw Exception('SiteProxyFactory not initialized');

    final factory = _providers[_context!.siteType];
    if (factory == null) throw Exception('No provider registered for site type: ${_context!.siteType}');

    return factory.createAttachmentProxy(_context!);
  }

  /// Get config proxy
  static IFCConfigProxy getConfigProxy() {
    if (_context == null) throw Exception('SiteProxyFactory not initialized');

    final factory = _providers[_context!.siteType];
    if (factory == null) throw Exception('No provider registered for site type: ${_context!.siteType}');

    return factory.createConfigProxy(_context!);
  }

  /// Get device proxy (BYO/direct push device registration on the customer's XF server).
  static IFCDeviceProxy getDeviceProxy() {
    if (_context == null) throw Exception('SiteProxyFactory not initialized');

    final factory = _providers[_context!.siteType];
    if (factory == null) throw Exception('No provider registered for site type: ${_context!.siteType}');

    return factory.createDeviceProxy(_context!);
  }

  // Abstract methods that must be implemented by concrete factories
  IFCUserProxy createUserProxy(SiteContext context);
  IFCForumProxy createForumProxy(SiteContext context);
  IFCTopicProxy createTopicProxy(SiteContext context);
  IFCPostProxy createPostProxy(SiteContext context);
  IFCAccountProxy createAccountProxy(SiteContext context);
  IFCSubscriptionProxy createSubscriptionProxy(SiteContext context);
  IFCModerationProxy createModerationProxy(SiteContext context);
  IFCSearchProxy createSearchProxy(SiteContext context);
  IFCSocialProxy createSocialProxy(SiteContext context);
  IFCPrivateConversationProxy createPrivateConversationProxy(SiteContext context);
  IFCPrivateMessageProxy createPrivateMessageProxy(SiteContext context);
  IFCAttachmentProxy createAttachmentProxy(SiteContext context);
  IFCConfigProxy createConfigProxy(SiteContext context);
  IFCDeviceProxy createDeviceProxy(SiteContext context);
}
