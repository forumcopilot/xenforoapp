import 'package:forumcopilot_sdk/factory/site_proxy_factory.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/interfaces/interfaces.dart';

import '../src/proxy/config_proxy.dart';
import '../src/proxy/account_proxy.dart';
import '../src/proxy/user_proxy.dart';
import '../src/proxy/forum_proxy.dart';
import '../src/proxy/topic_proxy.dart';
import '../src/proxy/post_proxy.dart';
import '../src/proxy/attachment_proxy.dart';
import '../src/proxy/search_proxy.dart';
import '../src/proxy/social_proxy.dart';
import '../src/proxy/subscription_proxy.dart';
import '../src/proxy/moderation_proxy.dart';
import '../src/proxy/private_conversation_proxy.dart';
import '../src/proxy/private_message_proxy.dart';
import '../src/proxy/device_proxy.dart';
import '../src/network/xenforo_client.dart';

/// XenForo proxy factory implementation
/// Creates XenForo-specific proxy instances for the ForumCopilot SDK
class XenForoProxyFactory extends SiteProxyFactory {
  /// [client] is for tests: every proxy this factory builds uses it instead
  /// of a real [XenForoClient], so whole flows can run against scripted replies.
  XenForoProxyFactory({XenForoClient? client}) : _client = client;

  final XenForoClient? _client;

  IFCConfigProxy createConfigProxy(SiteContext context) {
    return XenForoConfigProxy(context, client: _client);
  }

  IFCAccountProxy createAccountProxy(SiteContext context) {
    return XenForoAccountProxy(context, client: _client);
  }

  IFCUserProxy createUserProxy(SiteContext context) {
    return XenForoUserProxy(context, client: _client);
  }

  IFCForumProxy createForumProxy(SiteContext context) {
    return XenForoForumProxy(context, client: _client);
  }

  IFCTopicProxy createTopicProxy(SiteContext context) {
    return XenForoTopicProxy(context, client: _client);
  }

  IFCPostProxy createPostProxy(SiteContext context) {
    return XenForoPostProxy(context, client: _client);
  }

  IFCAttachmentProxy createAttachmentProxy(SiteContext context) {
    return XenForoAttachmentProxy(context, client: _client);
  }

  IFCSearchProxy createSearchProxy(SiteContext context) {
    return XenForoSearchProxy(context, client: _client);
  }

  IFCSocialProxy createSocialProxy(SiteContext context) {
    return XenForoSocialProxy(context, client: _client);
  }

  IFCSubscriptionProxy createSubscriptionProxy(SiteContext context) {
    return XenForoSubscriptionProxy(context, client: _client);
  }

  IFCModerationProxy createModerationProxy(SiteContext context) {
    return XenForoModerationProxy(context, client: _client);
  }

  IFCPrivateConversationProxy createPrivateConversationProxy(SiteContext context) {
    return XenForoPrivateConversationProxy(context, client: _client);
  }

  IFCPrivateMessageProxy createPrivateMessageProxy(SiteContext context) {
    return XenForoPrivateMessageProxy(context, client: _client);
  }

  IFCDeviceProxy createDeviceProxy(SiteContext context) {
    return XenForoDeviceProxy(context, client: _client);
  }
}
