/// XenForo Core - XenForo connector for ForumCopilot SDK
///
/// This package provides a complete XenForo forum connector that implements
/// the ForumCopilot SDK interfaces, enabling Flutter applications to interact
/// with XenForo forums using their REST API.

// Factory
export 'factory/xenforo_proxy_factory.dart';

// Core proxies
export 'src/proxy/config_proxy.dart';
export 'src/proxy/account_proxy.dart';
export 'src/proxy/user_proxy.dart';
export 'src/proxy/forum_proxy.dart';
export 'src/proxy/topic_proxy.dart';
export 'src/proxy/post_proxy.dart';

// Stub proxies
export 'src/proxy/attachment_proxy.dart';
export 'src/proxy/search_proxy.dart';
export 'src/proxy/social_proxy.dart';
export 'src/proxy/subscription_proxy.dart';
export 'src/proxy/moderation_proxy.dart';
export 'src/proxy/private_conversation_proxy.dart';
export 'src/proxy/private_message_proxy.dart';

// Network layer
export 'src/network/xenforo_client.dart';
export 'src/network/xenforo_auth_manager.dart';

// Context extensions
export 'src/context/xenforo_site_context_extension.dart';

// Plugin API - No longer uses REST API layer (converted to plugin-only)

// Base proxy
export 'src/base_xenforo_proxy.dart';

// Data models
export 'src/data/auth/oauth_token.dart';
export 'src/data/auth/auth_request.dart';
export 'src/data/auth/auth_response.dart';

// Converters
export 'src/converter/xenforo_user_converter.dart';
export 'src/converter/xenforo_forum_converter.dart';
export 'src/converter/xenforo_thread_converter.dart';
export 'src/converter/xenforo_post_converter.dart';
export 'src/converter/xenforo_attachment_converter.dart';
