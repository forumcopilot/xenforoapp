import 'dart:async';
import 'dart:convert';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/network/fc_call_result.dart';
import 'network/xenforo_client.dart';
import 'proxy/user_proxy.dart';

/// Base proxy class for XenForo API operations
/// Provides common functionality for all XenForo proxies
abstract class BaseXenForoProxy {
  final SiteContext siteContext;
  final XenForoClient _client = XenForoClient();

  // Mutex to serialize all API calls - ensures no parallel execution
  Future<void>? _apiCallMutex;

  // Completer to ensure only one relogin happens at a time
  Completer<void>? _reloginCompleter;

  // Methods that should not trigger login retry
  static const List<String> _loginRetryExcludedMethods = [
    'getConfig',
    'login',
    'logout',
    'getCurrentUser',
  ];

  BaseXenForoProxy(this.siteContext);

  /// Call ForumCopilot plugin API with method name and parameters
  /// This replaces all individual REST API calls
  /// All calls are serialized to prevent parallel execution
  Future<Map<String, dynamic>> callPluginApi(String method, Map<String, dynamic> params) async {
    // Wait for any previous API call to complete before starting this one
    if (_apiCallMutex != null) {
      await _apiCallMutex;
    }

    // Create a new mutex for this call
    final callCompleter = Completer<void>();
    _apiCallMutex = callCompleter.future;

    try {
      print('🔍 [BASE_PROXY] callPluginApi called:');
      print('   - method: "$method"');
      print('   - params keys: ${params.keys.toList()}');
      params.forEach((key, value) {
        if (value is String) {
          print('   - $key: "${value.length > 100 ? value.substring(0, 100) + "..." : value}" (length: ${value.length}, isEmpty: ${value.isEmpty})');
        } else if (value is List) {
          print('   - $key: List with ${value.length} items');
        } else {
          print('   - $key: $value');
        }
      });

      final requestData = {
        'method': method,
        'params': params,
      };

      print('🔍 [BASE_PROXY] Calling _client.forumcopilotApi...');
      var result = await _client.forumcopilotApi(siteContext, requestData);
      print('🔍 [BASE_PROXY] API call completed, statusCode: ${result.statusCode}');

      // When we see fc_is_login=false but have login data, confirm with getConfig before
      // updating state or relogin: a single request may have failed to send cookies.
      if (siteContext.allowLoginRetry &&
          !siteContext.passkeyLoginInProgress &&
          siteContext.loginDataOutput != null &&
          !result.fcIsLogin &&
          !_loginRetryExcludedMethods.contains(method)) {
        print('🔄 [BASE_PROXY] fc_is_login=false with login data - confirming with getConfig before relogin for method: $method');

        try {
          final confirmRequest = {'method': 'getConfig', 'params': <String, dynamic>{}};
          final confirmResult = await _client.forumcopilotApi(siteContext, confirmRequest);
          final sessionStillValid = confirmResult.statusCode >= 200 &&
              confirmResult.statusCode < 300 &&
              confirmResult.fcIsLogin;

          if (sessionStillValid) {
            print('🔄 [BASE_PROXY] getConfig confirms session valid - retrying original request without relogin');
            result = await _client.forumcopilotApi(siteContext, requestData);
            print('🔍 [BASE_PROXY] Retry API call completed, statusCode: ${result.statusCode}');
          } else {
            print('🔄 [BASE_PROXY] getConfig confirms logged out - attempting relogin for method: $method');
            await _doRelogin();

            print('🔄 [BASE_PROXY] Retrying original request after relogin...');
            result = await _client.forumcopilotApi(siteContext, requestData);
            print('🔍 [BASE_PROXY] Retry API call completed, statusCode: ${result.statusCode}');
          }
        } catch (e) {
          print('❌ [BASE_PROXY] Confirm/relogin failed: $e');
          // Continue with original result - let handleResponse handle the error
        }
      }

      print('🔍 [BASE_PROXY] Calling handleResponse...');
      final response = handleResponse(result);
      print('🔍 [BASE_PROXY] Response handled, keys: ${response.keys.toList()}');

      // Plugin returns data directly in FC format - return the parsed response
      return response;
    } finally {
      // Complete this call's mutex and clear it if it's the current one
      if (_apiCallMutex == callCompleter.future) {
        _apiCallMutex = null;
      }
      callCompleter.complete();
    }
  }

  /// Call plugin API and parse to a typed result using provided parser
  Future<T> callPluginApiTyped<T>(
    String method,
    Map<String, dynamic> params,
    T Function(Map<String, dynamic> json) parse,
  ) async {
    final response = await callPluginApi(method, params);
    return parse(response);
  }

  /// Handle API response and extract data
  Map<String, dynamic> handleResponse(FCCallResult result) {
    print('🔍 [BASE_PROXY] handleResponse called:');
    print('   - statusCode: ${result.statusCode}');
    print('   - body length: ${result.body.length}');
    print('   - fcIsLogin: ${result.fcIsLogin}');

    // Update site context with the response to track authentication state
    print('🔍 [BASE_PROXY] Setting last call response...');
    siteContext.setLastCallResponse(result);

    // Update login state from fc_is_login header
    // This ensures authentication state stays in sync with server
    print('🔍 [BASE_PROXY] Updating login state from header...');
    siteContext.updateLoginStateFromHeader(result.fcIsLogin);

    if (result.statusCode < 200 || result.statusCode >= 300) {
      print('❌ [BASE_PROXY] HTTP error status: ${result.statusCode}');
      // Try to parse error from response body
      try {
        print('🔍 [BASE_PROXY] Attempting to parse error from body...');
        final errorData = jsonDecode(result.body);
        print('❌ [BASE_PROXY] Error data: $errorData');
        throw Exception('API request failed: ${errorData['error'] ?? 'Unknown error'}');
      } catch (e) {
        print('❌ [BASE_PROXY] Failed to parse error, throwing generic exception');
        throw Exception('API request failed with status ${result.statusCode}: ${result.body}');
      }
    }

    try {
      print('🔍 [BASE_PROXY] Parsing response body as JSON...');
      print('🔍 [BASE_PROXY] Raw response body:');
      // Pretty print the raw JSON if it's valid JSON
      try {
        final encoder = JsonEncoder.withIndent('  ');
        final decodedForPrint = jsonDecode(result.body) as Map<String, dynamic>;
        print(encoder.convert(decodedForPrint));
      } catch (e) {
        print('   ${result.body}');
      }
      final decoded = jsonDecode(result.body) as Map<String, dynamic>;
      print('🔍 [BASE_PROXY] JSON decoded successfully, keys: ${decoded.keys.toList()}');
      return decoded;
    } catch (e, stackTrace) {
      print('❌ [BASE_PROXY] Failed to parse API response: $e');
      print('❌ [BASE_PROXY] Stack trace: $stackTrace');
      throw Exception('Failed to parse API response: $e');
    }
  }

  /// Build pagination parameters
  Map<String, String> buildPaginationParams({
    int? page,
    int? perPage,
    int? startNum,
    int? lastNum,
  }) {
    final params = <String, String>{};

    if (page != null) {
      params['page'] = page.toString();
    } else if (startNum != null && lastNum != null) {
      // Convert start/end to page-based pagination
      final perPageValue = perPage ?? 20;
      final startPage = (startNum / perPageValue).floor() + 1;
      params['page'] = startPage.toString();
    }

    if (perPage != null) {
      params['per_page'] = perPage.toString();
    }

    return params;
  }

  /// Build query parameters for filtering
  Map<String, String> buildFilterParams({
    String? order,
    String? direction,
    bool? unread,
    String? threadType,
    int? prefixId,
    int? starterId,
    int? lastDays,
  }) {
    final params = <String, String>{};

    if (order != null) {
      params['order'] = order;
    }

    if (direction != null) {
      params['direction'] = direction;
    }

    if (unread != null) {
      params['unread'] = unread.toString();
    }

    if (threadType != null) {
      params['thread_type'] = threadType;
    }

    if (prefixId != null) {
      params['prefix_id'] = prefixId.toString();
    }

    if (starterId != null) {
      params['starter_id'] = starterId.toString();
    }

    if (lastDays != null) {
      params['last_days'] = lastDays.toString();
    }

    return params;
  }

  /// Check if user is authenticated
  bool get isAuthenticated {
    return siteContext.isLoggedIn;
  }

  /// Get current user ID
  String? get currentUserId {
    return siteContext.currentUserId;
  }

  /// Get current username
  String? get currentUsername {
    return siteContext.currentUsername;
  }

  /// Log API call for debugging
  void logApiCall(String method, String endpoint, {Map<String, dynamic>? body}) {
    print('🔍 [XENFORO_API] $method $endpoint');
    if (body != null) {
      print('📤 [XENFORO_API] Body: $body');
    }
  }

  /// Log API response for debugging
  void logApiResponse(FCCallResult result) {
    print('📥 [XENFORO_API] Status: ${result.statusCode}');
    print('📥 [XENFORO_API] Success: ${result.statusCode >= 200 && result.statusCode < 300}');
    if (result.body.isNotEmpty) {
      print('📥 [XENFORO_API] Body: ${result.body}');
    }
  }

  /// Attempt to relogin when session expires
  /// This is called automatically when fc_is_login is false but we have login data
  /// Ensures only one relogin happens at a time - other calls wait for the relogin to complete
  Future<void> _doRelogin() async {
    // If a relogin is already in progress, wait for it to complete
    if (_reloginCompleter != null) {
      print('🔄 [BASE_PROXY] Relogin already in progress, waiting for completion...');
      try {
        await _reloginCompleter!.future;
        print('🔄 [BASE_PROXY] Relogin completed, continuing...');
        return;
      } catch (e) {
        print('❌ [BASE_PROXY] Previous relogin failed: $e');
        // If the previous relogin failed, we still return - each call will handle its own error
        return;
      }
    }

    // Create a new completer for this relogin
    _reloginCompleter = Completer<void>();

    try {
      print('🔄 [BASE_PROXY] _doRelogin called');

      // Prefer app-level relogin strategy when available.
      // This allows using the full automatic login flow (cookies, passkey, credentials).
      if (siteContext.reloginHandler != null) {
        print('🔄 [BASE_PROXY] Attempting relogin via siteContext.reloginHandler...');
        final handled = await siteContext.reloginHandler!(siteContext);
        if (handled) {
          print('✅ [BASE_PROXY] Relogin via handler successful');
          _reloginCompleter!.complete();
          return;
        }
        final error = Exception('Relogin failed via handler');
        _reloginCompleter!.completeError(error);
        throw error;
      }

      // Check if we have credentials
      if (siteContext.username == null || siteContext.password == null || siteContext.username!.isEmpty || siteContext.password!.isEmpty) {
        print('❌ [BASE_PROXY] Cannot relogin - no credentials available');
        final error = Exception('Cannot relogin: no credentials available');
        _reloginCompleter!.completeError(error);
        throw error;
      }

      print('🔄 [BASE_PROXY] Attempting relogin with saved credentials for user: ${siteContext.username}');

      final userProxy = XenForoUserProxy(siteContext);
      final loginResult = await userProxy.loginAsync(
        siteContext.username!,
        siteContext.password!,
        false, // not anonymous
        null, // no trust code
      );

      if (loginResult.result && loginResult.user != null) {
        print('✅ [BASE_PROXY] Relogin successful');
        // Login data is already set by loginAsync via siteContext.setLoginData
        _reloginCompleter!.complete();
      } else {
        // When server returns tfaRequired, there is no resultText; avoid empty "Relogin failed: "
        final message = loginResult.tfaRequired == true
            ? 'TFA required (use Sign in with passkey or complete TFA in app)'
            : (loginResult.resultText?.trim().isNotEmpty == true ? loginResult.resultText! : 'Unknown error');
        print('❌ [BASE_PROXY] Relogin failed: $message');
        final error = Exception('Relogin failed: $message');
        _reloginCompleter!.completeError(error);
        throw error;
      }
    } catch (e) {
      print('❌ [BASE_PROXY] Relogin error: $e');
      if (!_reloginCompleter!.isCompleted) {
        _reloginCompleter!.completeError(e);
      }
      rethrow;
    } finally {
      // Clear the completer so future calls can start a new relogin if needed
      _reloginCompleter = null;
    }
  }
}
