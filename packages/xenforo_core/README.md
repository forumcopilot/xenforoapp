# XenForo Core

A Flutter package that provides XenForo forum integration for the ForumCopilot SDK. This package implements the ForumCopilot SDK interfaces to enable Flutter applications to interact with XenForo forums using their REST API.

## Features

- **Dual Authentication Support**: API Key for guest access and OAuth2 for user authentication
- **Complete Forum Integration**: Browse forums, view threads, read posts, and more
- **User Management**: User profiles, authentication, and account management
- **Content Creation**: Create threads, reply to posts, and manage content
- **Social Features**: Likes, follows, bookmarks, and activity streams
- **Moderation Tools**: Admin and moderation operations
- **Private Messaging**: Conversations and private messages
- **Search Functionality**: Search forums, threads, posts, and users
- **File Attachments**: Upload and manage file attachments

## Installation

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  xenforo_core:
    path: packages/xenforo_core
```

## Usage

### Basic Setup

```dart
import 'package:xenforo_core/xenforo_core.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';

// Register the XenForo factory
SiteProxyFactory.register('xenforo', XenForoProxyFactory());

// Create site context
final siteContext = SiteContext(
  siteType: 'xenforo',
  site: Site(
    pluginUrl: 'https://your-forum.com',
    siteName: 'Your Forum',
  ),
);

// Set guest API key for unauthenticated access
siteContext.setGuestApiKey('your-guest-api-key');

// Initialize the factory
SiteProxyFactory.initialize(siteContext);
```

### Authentication

#### Guest Access (API Key)

```dart
// Set guest API key
siteContext.setGuestApiKey('your-guest-api-key');

// Now you can browse forums and view content
final configProxy = SiteProxyFactory.getConfigProxy();
final config = await configProxy.getConfig('https://your-forum.com');
```

#### User Authentication (OAuth2)

```dart
// OAuth2 authentication (to be implemented)
// This will be available in future versions
```

### Forum Operations

```dart
// Get forum configuration
final configProxy = SiteProxyFactory.getConfigProxy();
final config = await configProxy.getConfig('https://your-forum.com');

// Get forum list
final forumProxy = SiteProxyFactory.getForumProxy();
final forums = await forumProxy.getForumAsync(true, '0', false);

// Get topics in a forum
final topicProxy = SiteProxyFactory.getTopicProxy();
final topics = await topicProxy.getTopicAsync('forum-id', 0, 20);

// Get posts in a thread
final postProxy = SiteProxyFactory.getPostProxy();
final posts = await postProxy.getThreadAsync('thread-id', 0, 20, true);
```

## API Reference

### Proxies

- **ConfigProxy**: Forum configuration and settings
- **AccountProxy**: User registration and authentication
- **UserProxy**: User operations and profile management
- **ForumProxy**: Forum structure and navigation
- **TopicProxy**: Thread/topic operations
- **PostProxy**: Post creation, editing, and retrieval
- **AttachmentProxy**: File upload and attachment management
- **SearchProxy**: Search functionality
- **SocialProxy**: Social features (likes, follows, etc.)
- **SubscriptionProxy**: Forum and topic subscriptions
- **ModerationProxy**: Moderation operations
- **PrivateConversationProxy**: Private conversations
- **PrivateMessageProxy**: Private messages

### Data Converters

- **XenForoUserConverter**: Convert XenForo user data to FC models
- **XenForoForumConverter**: Convert XenForo forum data to FC models
- **XenForoThreadConverter**: Convert XenForo thread data to FC models
- **XenForoPostConverter**: Convert XenForo post data to FC models
- **XenForoAttachmentConverter**: Convert XenForo attachment data to FC models

## Configuration

### XenForo Forum Setup

1. Enable the REST API in your XenForo admin panel
2. Create an API key for guest access
3. Configure OAuth2 settings for user authentication (optional)

### Test Forum

For testing purposes, you can use the provided test forum:
- URL: `https://plugini.com/xf2a`
- Guest API Key: `2M0tckGs0tdiKuq4owsncr3ohlDwCXKl`

### Running Integration Tests (REST)

The REST layer has live integration tests that exercise read-only endpoints against a public XenForo test forum.

Run tests:

```bash
flutter test packages/xenforo_core/test/rest -r compact
```

Override target forum or API key via environment variables:

```bash
XF_BASE_URL=https://plugini.com/xf2 \
XF_API_KEY=2M0tckGs0tdiKuq4owsncr3ohlDwCXKl \
flutter test packages/xenforo_core/test/rest -r compact
```

## Error Handling

The package includes comprehensive error handling for XenForo API responses:

```dart
try {
  final result = await proxy.someMethod();
  // Handle success
} catch (e) {
  if (e is XenForoApiException) {
    // Handle XenForo-specific errors
    print('XenForo Error: ${e.message}');
  } else {
    // Handle other errors
    print('Error: $e');
  }
}
```

## Limitations

- OAuth2 authentication is not yet implemented (planned for future versions)
- Some advanced features may not be available depending on XenForo configuration
- Guest access is limited to viewing content only

## Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues for bugs and feature requests.

## License

This package is part of the ForumCopilot project and follows the same licensing terms.

## Support

For support and questions, please refer to the ForumCopilot documentation or open an issue in the project repository.
