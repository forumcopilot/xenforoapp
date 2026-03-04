# Connector Development Guide

This guide walks a new developer through creating a **forum connector** that plugs into the [ForumCopilot SDK](../README.md). A *connector* is a concrete implementation of the SDK’s abstract proxy interfaces that talks to a specific forum platform (e.g. XenForo, Discourse, NodeBB). The SDK is intentionally **interface‑driven** and uses a *factory* pattern to create the appropriate proxy at runtime.

> **Prerequisite** – Familiarity with Dart/Flutter, basic HTTP concepts and JSON handling.

---

## 1️⃣ SDK Architecture Recap

```
forumcopilot_sdk/
├── interfaces/          # Abstract contracts (IFC*Proxy)
├── factory/             # SiteProxyFactory & concrete factories
├── context/              # Global site/session state (SiteContext)
└── services/            # Core networking & business logic
```

* **Proxies** – One per feature set (users, forums, posts, etc.).  Each proxy implements an `IFC*Proxy` interface.
* **Factory** – `SiteProxyFactory` reads the current `SiteContext.siteType` and delegates to a concrete factory (e.g. `XenForoProxyFactory`).
* **Context** – Holds authentication tokens, site metadata and is passed to all proxies.

When you add a new connector:
1. Implement the required proxy classes.
2. Create a factory that returns those proxies.
3. Register the factory with `SiteProxyFactory`.

---

## 2️⃣ Step‑by‑Step: Building a New Connector

Below is an end‑to‑end example of creating a connector called **`MyForum`**.

### 2.1 – Define the Concrete Proxy Classes

Each proxy must implement its corresponding `IFC*Proxy` interface.

```dart
// lib/src/proxies/myforum_user_proxy.dart
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';

class MyForumUserProxy implements IFCUserProxy {
  final SiteContext _context;

  MyForumUserProxy(this._context);

  @override
  Future<FCLoginResult> loginAsync(String username, String password) async {
    // 1. Build request payload
    final payload = {
      'username': username,
      'password': password,
    };

    // 2. Call the forum API (using the SDK's HttpClient helper)
    final response = await _context.httpClient.post(
      '/api/login',
      body: payload,
    );

    // 3. Map response to FCLoginResult
    return FCLoginResult.fromJson(response.data);
  }

  // Implement other IFCUserProxy methods here…
}
```

> **Tip** – Keep the logic *pure*; do not manipulate UI state inside the proxy.

Do this for each interface you need: `IFCForumProxy`, `IFCTopicProxy`, `IFCPostProxy`, etc.  The SDK provides a **result** class for every operation (e.g. `FCGetPostResult`).  Use the constructor or a factory method like `fromJson`.

### 2.2 – Create the Factory

The factory is responsible for creating an instance of each proxy.

```dart
// lib/src/factory/myforum_factory.dart
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';
import '../proxies/myforum_user_proxy.dart';

class MyForumProxyFactory extends SiteProxyFactory {
  @override
  IFCUserProxy createUserProxy(SiteContext context) => MyForumUserProxy(context);

  @override
  IFCForumProxy createForumProxy(SiteContext context) => MyForumForumProxy(context);

  @override
  IFCTopicProxy createTopicProxy(SiteContext context) => MyForumTopicProxy(context);

  @override
  IFCPostProxy createPostProxy(SiteContext context) => MyForumPostProxy(context);

  // Implement remaining proxies if required
}
```

> **Note** – The factory extends `SiteProxyFactory` and must override *all* abstract methods.

### 2.3 – Register the Factory

When your app starts, register the new factory with `SiteProxyFactory`.

```dart
// lib/main.dart (or a dedicated bootstrap file)
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';
import 'src/factory/myforum_factory.dart';

void main() {
  // ... GetX setup, routing, etc.

  // Initialise the global context (replace with real values)
  final siteContext = SiteContext(
    siteType: 'myforum',
    site: Site(name: 'My Forum', url: 'https://example.com'),
  );

  // Register the factory for this site type
  SiteProxyFactory.register('myforum', MyForumProxyFactory());

  // Optionally, initialise the SDK with the context
  SiteProxyFactory.initialize(siteContext);
}
```

After registration, any call to `SiteProxyFactory.getUserProxy()` will return an instance of `MyForumUserProxy`.

---

## 3️⃣ Testing Your Connector

1. **Unit tests** – Test each proxy method in isolation using a mock HTTP client.
2. **Widget tests** – Verify that UI components react to the proxy results as expected.
3. **Integration tests** – Run against a staging instance of your forum to ensure real‑world compatibility.

```dart
// Example unit test for login
import 'package:flutter_test/flutter_test.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';

void main() {
  test('loginAsync returns success', () async {
    final context = SiteContext(
      siteType: 'myforum',
      site: Site(name: 'Test', url: 'https://test.com'),
    );

    // Inject a mock HttpClient that returns a predefined response
    context.httpClient = MockHttpClient((url, body) {
      return Future.value(
        HttpResponse(statusCode: 200, data: {'result': true, 'user': {...}}),
      );
    });

    final proxy = MyForumUserProxy(context);
    final result = await proxy.loginAsync('alice', 'secret');

    expect(result.result, isTrue);
  });
}
```

---

## 4️⃣ Build & Publish

The SDK includes a **build script** that compiles the package and runs static analysis:

```bash
# From the project root
build_forumcopilot_sdk.bat   # Windows
./scripts/build_forumcopilot_sdk.sh  # macOS/Linux (create if missing)
```

After successful build, publish to `pub.dev` or share the `.dart` files directly with other Flutter projects.

---

## 5️⃣ Contribution Guidelines

If you develop a connector for an open‑source forum platform, consider contributing back:
1. Fork the `forumcopilot_sdk` repository.
2. Add your connector under a new folder (e.g., `src/factories/discourse/`).
3. Update the README to reference your connector.
4. Submit a pull request and include unit tests.

The maintainers will review the code, run integration tests against a public forum instance, and merge if it meets quality standards.

---

## 6️⃣ Resources & Further Reading

| Topic | Link |
|-------|------|
| SDK Architecture | [Architecture Diagram](../architecture.png) *(placeholder)* |
| HTTP Client | `forumcopilot_sdk/src/services/http_client.dart` |
| Result Pattern | [Result Pattern Guide](../docs/result_pattern.md) |
| GetX Integration | `lib/controllers/` examples |

---

> **Pro Tip** – When adding a new proxy, keep the method signatures identical to the interface. This ensures that any consumer of the SDK can swap connectors without code changes.

Happy coding!