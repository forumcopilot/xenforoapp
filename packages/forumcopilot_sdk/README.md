# ForumCopilot SDK

A comprehensive Flutter SDK for building forum applications with support for multiple forum platforms. This SDK provides a clean abstraction layer that allows you to switch between different forum implementations without changing your application code.

## 🏗️ **SDK Architecture**

### ✅ **Core Design Principles**
- **Interface-based design** with `IFC*Proxy` contracts for all forum operations
- **Result objects** in `forumcopilot_sdk` with proper mapping and serialization
- **Factory pattern** for easy forum switching between different implementations
- **SiteContext** for centralized state and session management
- **Zero compilation errors** - fully functional SDK

### 🏗️ **Architecture Benefits**
- **Clean separation** between interfaces, results, and implementations
- **Dependency inversion** - main app only uses `FC*` classes
- **Factory pattern** for proxy creation based on site type
- **Result pattern** for consistent API responses
- **Context management** with `SiteContext` for session state

## 🏗️ **Clean Architecture Implementation**

The SDK follows **Clean Architecture** principles with clear separation of concerns:

```
forumcopilot_sdk/
├── models/                    # Data models
│   ├── domain/               # Domain models (business entities)
│   │   └── site.dart         # Site entity
│   ├── entities/             # Root objects (data entities)
│   │   ├── fc_topic.dart     # Topic entity
│   │   ├── fc_post.dart      # Post entity
│   │   ├── fc_user.dart      # User entity
│   │   └── ...               # Other entities
│   └── results/              # API response wrappers
│       ├── fc_topic_result.dart    # Topic API responses
│       ├── fc_post_result.dart     # Post API responses
│       ├── fc_user_result.dart     # User API responses
│       └── ...                     # Other result wrappers
├── interfaces/               # Abstract contracts
│   ├── i_fc_user_proxy.dart
│   ├── i_fc_forum_proxy.dart
│   └── ...                   # All proxy interfaces
├── context/                  # Global context and state
│   └── site_context.dart     # Site context management
├── factory/                  # Factory pattern implementations
│   └── site_proxy_factory.dart
├── network/                  # Networking infrastructure
│   ├── fc_call_result.dart
│   ├── fc_web_call.dart
│   └── interfaces/
└── services/                 # Business logic services
    ├── forumcopilot_api_service.dart
    └── fc_http_overrides.dart
```

## 📦 Core Components

### 🎯 Models

#### Domain Models (`models/domain/`)
- **`Site`**: Represents a forum site with metadata (name, URL, description, etc.)

#### Entity Models (`models/entities/`)
Root objects that represent actual data entities for UI consumption:
- **`FCTopic`**: Forum topic entity with moderation capabilities
- **`FCPost`**: Forum post entity with attachment support
- **`FCUser`**: User entity with profile information
- **`FCForum`**: Forum entity with subscription status
- **`FCAttachment`**: File attachment entity
- **`FCLike`**: Like/reaction entity
- **`FCThanks`**: Thanks entity

#### Result Models (`models/results/`)
API response wrappers that contain entities plus metadata:
- **`FCTopicDataResult`**: Contains `FCTopic` entities + pagination + status
- **`FCPostResult`**: Contains `FCPost` entities + pagination + status
- **`FCUserResult`**: Contains `FCUser` entities + pagination + status
- **`FCConfigResult`**: Configuration data response
- **`FCLoginResult`**: Authentication response
- **`FCForumResult`**: Forum data with statistics
- **`FCAttachmentResult`**: File upload/download results
- And many more...

### 🔌 Interfaces (`interfaces/`)

Abstract contracts that define the API for different forum operations:

- **`IFCUserProxy`**: User management operations
- **`IFCForumProxy`**: Forum browsing operations
- **`IFCTopicProxy`**: Topic management operations
- **`IFCPostProxy`**: Post management operations
- **`IFCAccountProxy`**: Account management operations
- **`IFCSubscriptionProxy`**: Subscription operations
- **`IFCModerationProxy`**: Moderation operations
- **`IFCSearchProxy`**: Search operations
- **`IFCSocialProxy`**: Social features (likes, follows, etc.)
- **`IFCPrivateConversationProxy`**: Direct messaging operations
- **`IFCPrivateMessageProxy`**: Private message operations
- **`IFCAttachmentProxy`**: File attachment operations
- **`IFCConfigProxy`**: Configuration operations

### 🏭 Factory Pattern (`factory/`)

- **`SiteProxyFactory`**: Abstract factory for creating proxy instances
- **`XenForoProxyFactory`**: Concrete implementation for XenForo forums
- Future implementations: `OtherForumProxyFactory`, etc.

### 🌐 Context (`context/`)

- **`SiteContext`**: Global context containing site information, session data, and configuration
  - Replaces `BaseForumInfo` with cleaner abstraction
  - Uses `Site` entity instead of `UserForumData`
  - Manages session state and authentication

### 🔗 Network (`network/`)

Generic networking infrastructure:

- **`FCCallResult`**: HTTP response wrapper
- **`FCWebCall`**: Generic HTTP client
- **`FCWebCallInfo`**: Request configuration
- **`FCApiException`**: Network exception handling
- **`FCJsonClient`**: JSON API client
- **`FCNetworkClient`**: Abstract network interface
- **`FCJsonNetworkClient`**: JSON implementation

### 🛠️ Services (`services/`)

Business logic services:

- **`ForumCopilotApiService`**: Legacy compatibility service (disabled in standalone mode)
- **`FCHttpClient`**: HTTP client with custom overrides
- **`FCCacheManager`**: Caching service
- **`FCDioClient`**: Shared Dio client with persistent cookies and headers

## 🚀 Usage

### 1. Initialize the SDK

```dart
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';
import 'package:xenforo_core/xenforo_core.dart';

// Create site context
final siteContext = SiteContext(
  siteType: 'tapatalk',
  site: Site(
    name: 'My Forum',
    url: 'https://example.com',
    description: 'A great forum',
  ),
);

// Initialize the factory
SiteProxyFactory.initialize(siteContext);

// Register concrete implementation
SiteProxyFactory.register('xenforo', XenForoProxyFactory());
```

### 2. Use Proxies

```dart
// Get proxy instances
final userProxy = SiteProxyFactory.getUserProxy();
final forumProxy = SiteProxyFactory.getForumProxy();
final topicProxy = SiteProxyFactory.getTopicProxy();

// Use the proxies
final loginResult = await userProxy.loginAsync(username, password);
final forums = await forumProxy.getForumAsync();
final topics = await topicProxy.getTopicAsync(forumId);
```

### 3. Handle Results

```dart
// Results contain both data and metadata
if (loginResult.result) {
  print('Login successful: ${loginResult.resultText}');
  // Access user data
  final user = loginResult.user;
} else {
  print('Login failed: ${loginResult.resultText}');
}

// Results with lists
if (topics.result) {
  print('Found ${topics.total} topics');
  for (final topic in topics.list) {
    print('Topic: ${topic.title}');
  }
}
```

## 🔄 Result Pattern

The SDK uses a consistent **Result Pattern** for all API responses:

```dart
class FCTopicDataResult {
  bool result;              // Operation success/failure
  String resultText;        // Status message
  int totalTopicNum;        // Total count (for pagination)
  List<FCTopic> topics;     // Actual data entities
  // ... other metadata
}
```

**Benefits:**
- ✅ **Consistent error handling**
- ✅ **Rich metadata** (pagination, status, etc.)
- ✅ **Type safety** with structured responses
- ✅ **Easy to extend** with additional fields
- ✅ **Separation of concerns** (entities vs results)

## 🏗️ Adding New Forum Support

To add support for a new forum platform:

1. **Create concrete proxies** implementing the interfaces
2. **Create a factory** extending `SiteProxyFactory`
3. **Register the factory** with the appropriate site type
4. **Update imports** in your application

```dart
class MyForumProxyFactory extends SiteProxyFactory {
  @override
  IFCUserProxy createUserProxy(SiteContext context) {
    return MyForumUserProxy(context);
  }
  
  // ... implement other proxies
}

// Register it
SiteProxyFactory.register('myforum', MyForumProxyFactory());
```

## 📁 Build Scripts

The SDK includes build scripts for easy compilation and analysis:

- **`build_forumcopilot_sdk.bat`**: Build and analyze ForumCopilot SDK
- **`buildlib.bat`**: Build all libraries with analysis

```bash
# Build and analyze ForumCopilot SDK
build_forumcopilot_sdk.bat

# Build all libraries
buildlib.bat
```

## 🎯 **Refactoring Summary**

### ✅ **Completed Refactoring**
- **11 Proxy Classes** refactored to implement `IFC*Proxy` interfaces
- **All Result Objects** moved to `forumcopilot_sdk` with proper mapping
- **Factory Pattern** implemented for easy forum switching
- **SiteContext** replaces `BaseForumInfo` for cleaner state management
- **Zero Compilation Errors** - fully functional SDK

### 📊 **Refactored Components**
1. ✅ **ConfigProxy** → `IFCConfigProxy` + `FCConfigResult`
2. ✅ **AttachmentProxy** → `IFCAttachmentProxy` + `FCAttachmentResult`
3. ✅ **ForumProxy** → `IFCForumProxy` + `FCForumResult`
4. ✅ **TopicProxy** → `IFCTopicProxy` + `FCTopicResult`
5. ✅ **PostProxy** → `IFCPostProxy` + `FCPostResult`
6. ✅ **AccountProxy** → `IFCAccountProxy` + `FCAccountResult`
7. ✅ **SubscriptionProxy** → `IFCSubscriptionProxy` + `FCSubscriptionResult`
8. ✅ **UserProxy** → `IFCUserProxy` + `FCUserResult`
9. ✅ **ModerationProxy** → `IFCModerationProxy` + `FCModerationResult`
10. ✅ **SearchProxy** → `IFCSearchProxy` + `FCSearchResult`
11. ✅ **SocialProxy** → `IFCSocialProxy` + `FCSocialResult`
12. ✅ **PrivateConversationProxy** → `IFCPrivateConversationProxy` + `FCPrivateConversationResult`
13. ✅ **PrivateMessageProxy** → `IFCPrivateMessageProxy` + `FCPrivateMessageResult`

### 🏗️ **Architecture Benefits**
- **Clean separation** between interfaces, results, and implementations
- **Dependency inversion** - main app only uses `FC*` classes
- **Easy forum switching** by changing factory registration
- **Consistent API** across all forum implementations
- **Type safety** with structured result objects

## 📱 Platform Support

- ✅ **Android** (API 21+)
- ✅ **iOS** (iOS 11+)
- ✅ **Web** (Chrome, Firefox, Safari, Edge)
- ✅ **Windows** (Windows 10+)
- ✅ **macOS** (macOS 10.14+)
- ✅ **Linux** (Ubuntu 18.04+)

## 🔧 Dependencies

- **`dart_mappable`**: Serialization/deserialization
- **`http`**: HTTP client
- **`crypto`**: Cryptographic functions
- **`flutter`**: Flutter framework

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## 📞 Support

For support and questions:
- 📧 Email: support@forumcopilot.com
- 🐛 Issues: [GitHub Issues](https://github.com/forumcopilot/forumcopilot_sdk/issues)
- 📖 Documentation: [Wiki](https://github.com/forumcopilot/forumcopilot_sdk/wiki)

---

**ForumCopilot SDK** - Building the future of forum applications 🚀
