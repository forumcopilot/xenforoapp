# Forum Copilot Interfaces

This directory contains forum proxy interfaces used across connector implementations. These interfaces allow swapping forum backends without changing application logic.

## Overview

The interfaces follow the naming convention `FC{ModuleName}` where:
- `FC` stands for "Forum Copilot"
- `{ModuleName}` corresponds to the original proxy class name

## Available Interfaces

### Core Interfaces

1. **FCAttachment** - Handles file uploads, avatar management, and attachment operations
2. **FCAccount** - Manages user registration, authentication, and profile updates
3. **FCConfig** - Retrieves forum configuration and settings
4. **FCForum** - Manages forum structure, navigation, and forum-related functions
5. **FCModeration** - Provides moderation tools for topics, posts, and users
6. **FCPost** - Handles post creation, editing, quoting, and thread management
7. **FCPrivateMessage** - Traditional private messaging system
8. **FCPrivateConversation** - Modern conversational private messaging
9. **FCSearch** - Search functionality for topics and posts
10. **FCSocial** - Social features like likes, follows, and activity streams
11. **FCSubscription** - Forum and topic subscription management
12. **FCTopic** - Topic creation, retrieval, and management
13. **FCUser** - User authentication, profiles, and user-related operations

## Usage

To use these interfaces, import them from the main interfaces file:

```dart
import 'package:forumcopilot_sdk/interfaces/interfaces.dart';
```

## Implementation Strategy

Concrete proxy classes should implement these interfaces:

```dart
class AttachmentProxy extends BaseProxy implements FCAttachment {
  // Implementation remains the same
}
```

This allows for:

1. **Easy Testing** - Mock implementations can be created for unit testing
2. **Forum System Swapping** - Different forum systems can be implemented by creating new classes that implement these interfaces
3. **Clean Architecture** - Clear separation between interface contracts and implementations
4. **Future Extensibility** - New forum systems can be added without changing existing code

## Next Steps

1. Refactor existing proxy classes to implement these interfaces
2. Create factory classes or dependency injection to manage interface implementations
3. Implement alternative forum system providers (e.g., phpBB, XenForo, etc.)
4. Add comprehensive unit tests using mock implementations

## Benefits

- **Maintainability**: Clear contracts make the codebase easier to maintain
- **Flexibility**: Easy to swap forum implementations
- **Testability**: Interfaces enable better unit testing
- **Scalability**: New forum systems can be added without breaking existing code
- **Documentation**: Interfaces serve as living documentation of the API
