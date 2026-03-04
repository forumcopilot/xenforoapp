import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'services/fc_http_overrides.dart';

// Export the classes so they can be used by other packages
export 'services/fc_http_overrides.dart';
export 'services/fc_http_client.dart';
export 'services/fc_cache_manager.dart';

// Export interfaces and results
export 'interfaces/interfaces.dart';
export 'models/results/results.dart';

// Export context and factory
export 'context/site_context.dart';
export 'factory/site_proxy_factory.dart';

// Export network components
export 'network/fc_call_result.dart';
export 'network/fc_web_call.dart';
export 'network/fc_web_call_info.dart';
export 'network/fc_api_exception.dart';
export 'network/fc_json_client.dart';
export 'network/interfaces/fc_network_client.dart';
export 'network/implementations/fc_json_network_client.dart';

// Export models and services
export 'models/domain/domain.dart';
export 'models/entities/entities.dart';
export 'services/forumcopilot_api_service.dart';

final GlobalKey<NavigatorState> globalNavigatorKey = GlobalKey<NavigatorState>();

abstract class ForumcopilotSdk {
  static bool _initialized = false;
  static Future<void> ensureInitialized({String? userAgent, BuildContext? buildContext, VoidCallback? onCloudflareStart, VoidCallback? onCloudflareEnd}) async {
    if (_initialized) return;

    final resolvedUserAgent = await _resolveUserAgent(userAgent);

    FCDioClient(
      userAgent: resolvedUserAgent,
    );
    FCDioClient.instance.onCloudflareStart = onCloudflareStart;
    FCDioClient.instance.onCloudflareEnd = onCloudflareEnd;
    await FCDioClient.instance.initialize();
    if (buildContext != null) {
      await FCDioClient.instance.setContext(buildContext);
    }

    _initialized = true;
  }

  static Future<void> updateContext(BuildContext? context) async {
    await FCDioClient.instance.setContext(context);
  }

  static Future<String> _resolveUserAgent(String? userAgent) async {
    if (userAgent != null && userAgent.trim().isNotEmpty) {
      return userAgent.trim();
    }

    // Use the exact User-Agent from real Safari/browsers to pass Cloudflare validation
    if (Platform.isAndroid) {
      return 'Mozilla/5.0 (Linux; Android 14) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Mobile Safari/537.36';
    } else if (Platform.isIOS) {
      return 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Mobile/15E148 Safari/604.1';
    } else if (Platform.isMacOS) {
      return 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Safari/605.1.15';
    } else if (Platform.isWindows) {
      return 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36';
    } else if (Platform.isLinux) {
      return 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36';
    }

    return 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Mobile/15E148 Safari/604.1';
  }
}
