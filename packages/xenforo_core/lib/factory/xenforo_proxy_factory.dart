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

/// XenForo proxy factory implementation
/// Creates XenForo-specific proxy instances for the ForumCopilot SDK
class XenForoProxyFactory extends SiteProxyFactory {
  IFCConfigProxy createConfigProxy(SiteContext context) {
    return XenForoConfigProxy(context);
  }

  IFCAccountProxy createAccountProxy(SiteContext context) {
    return XenForoAccountProxy(context);
  }

  IFCUserProxy createUserProxy(SiteContext context) {
    return XenForoUserProxy(context);
  }

  IFCForumProxy createForumProxy(SiteContext context) {
    return XenForoForumProxy(context);
  }

  IFCTopicProxy createTopicProxy(SiteContext context) {
    return XenForoTopicProxy(context);
  }

  IFCPostProxy createPostProxy(SiteContext context) {
    return XenForoPostProxy(context);
  }

  IFCAttachmentProxy createAttachmentProxy(SiteContext context) {
    return XenForoAttachmentProxy(context);
  }

  IFCSearchProxy createSearchProxy(SiteContext context) {
    return XenForoSearchProxy(context);
  }

  IFCSocialProxy createSocialProxy(SiteContext context) {
    return XenForoSocialProxy(context);
  }

  IFCSubscriptionProxy createSubscriptionProxy(SiteContext context) {
    return XenForoSubscriptionProxy(context);
  }

  IFCModerationProxy createModerationProxy(SiteContext context) {
    return XenForoModerationProxy(context);
  }

  IFCPrivateConversationProxy createPrivateConversationProxy(SiteContext context) {
    return XenForoPrivateConversationProxy(context);
  }

  IFCPrivateMessageProxy createPrivateMessageProxy(SiteContext context) {
    return XenForoPrivateMessageProxy(context);
  }

  IFCDeviceProxy createDeviceProxy(SiteContext context) {
    return XenForoDeviceProxy(context);
  }
}
