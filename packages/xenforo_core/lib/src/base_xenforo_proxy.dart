import 'dart:async';
import 'dart:convert';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/network/fc_call_result.dart';
import 'network/xenforo_client.dart';
import 'proxy/user_proxy.dart';
import 'xf_debug.dart';

/// Base proxy class for XenForo API operations
/// Provides common functionality for all XenForo proxies
abstract class BaseXenForoProxy {
  final SiteContext siteContext;
  final XenForoClient _client;

  // Mutex to serialize all API calls - ensures no parallel execution
  Future<void>? _apiCallMutex;

  /// The session check (and relogin, if needed) running for each forum.
  /// Keyed by [SiteContext], not held per proxy: the factory builds a new
  /// proxy for every call, so a per-instance guard never saw the other calls,
  /// and N parallel requests on an expired session ran N password logins
  /// (and possibly N two-step prompts).
  static final Expando<Future<bool>> _sessionChecks = Expando('xenforoSessionCheck');

  // Methods that should not trigger login retry
  static const List<String> _loginRetryExcludedMethods = [
    'getConfig',
    'login',
    'logout',
    'getCurrentUser',
  ];

  /// [client] is for tests; the app always uses the real [XenForoClient].
  BaseXenForoProxy(this.siteContext, {XenForoClient? client})
      : _client = client ?? XenForoClient();

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
      xfDebug('🔍 [BASE_PROXY] callPluginApi called:');
      xfDebug('   - method: "$method"');
      xfDebug('   - params keys: ${params.keys.toList()}');
      params.forEach((key, value) => xfDebug('   - $key: ${xfLoggableParam(key, value)}'));

      final requestData = {
        'method': method,
        'params': params,
      };

      xfDebug('🔍 [BASE_PROXY] Calling _client.forumcopilotApi...');
      var generation = siteContext.sessionGeneration;
      var result = await _client.forumcopilotApi(siteContext, requestData);
      xfDebug('🔍 [BASE_PROXY] API call completed, statusCode: ${result.statusCode}');

      // When we see fc_is_login=false but have login data, confirm with getConfig before
      // updating state or relogin: a single request may have failed to send cookies.
      if (siteContext.allowLoginRetry &&
          !siteContext.passkeyLoginInProgress &&
          siteContext.loginDataOutput != null &&
          result.hasLoginHeader &&
          !result.fcIsLogin &&
          !_loginRetryExcludedMethods.contains(method)) {
        xfDebug('🔄 [BASE_PROXY] fc_is_login=false with login data - checking the session before retrying $method');
        if (await _checkSessionOrRelogin()) {
          xfDebug('🔄 [BASE_PROXY] Session usable again - retrying $method');
          generation = siteContext.sessionGeneration;
          result = await _client.forumcopilotApi(siteContext, requestData);
          xfDebug('🔍 [BASE_PROXY] Retry API call completed, statusCode: ${result.statusCode}');
        }
        // Otherwise keep the original result; handleResponse reports it.
      }

      xfDebug('🔍 [BASE_PROXY] Calling handleResponse...');
      final response = handleResponse(result, generation: generation);
      xfDebug('🔍 [BASE_PROXY] Response handled, keys: ${response.keys.toList()}');

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

  /// Handle API response and extract data. [generation] is the session
  /// generation the request started in; when the user has signed in or out
  /// since, the reply's login header no longer describes this session and
  /// leaves the login state alone (the reply itself is still returned).
  Map<String, dynamic> handleResponse(FCCallResult result, {int? generation}) {
    xfDebug('🔍 [BASE_PROXY] handleResponse called:');
    xfDebug('   - statusCode: ${result.statusCode}');
    xfDebug('   - body length: ${result.body.length}');
    xfDebug('   - fcIsLogin: ${result.fcIsLogin}');

    if (generation != null && !siteContext.isCurrentSession(generation)) {
      xfDebug('🔒 [BASE_PROXY] Reply to a request from before the last sign-in/out: login state left alone');
    } else if (!result.hasLoginHeader) {
      // Never reached the add-on (offline, timeout, an error page): no news
      // about the session, so don't sign the app out over it.
      xfDebug('🔒 [BASE_PROXY] Reply without fc_is_login (status ${result.statusCode}): login state left alone');
    } else {
      // Update site context with the response to track authentication state
      siteContext.setLastCallResponse(result);
      // Keep the login state in sync with the server's fc_is_login header.
      siteContext.updateLoginStateFromHeader(result.fcIsLogin);
    }

    if (result.statusCode < 200 || result.statusCode >= 300) {
      xfDebug('❌ [BASE_PROXY] HTTP error status: ${result.statusCode}');
      // Try to parse error from response body
      try {
        xfDebug('🔍 [BASE_PROXY] Attempting to parse error from body...');
        final errorData = jsonDecode(result.body);
        xfDebug('❌ [BASE_PROXY] Error data: $errorData');
        throw Exception('API request failed: ${errorData['error'] ?? 'Unknown error'}');
      } catch (e) {
        xfDebug('❌ [BASE_PROXY] Failed to parse error, throwing generic exception');
        throw Exception('API request failed with status ${result.statusCode}: ${result.body}');
      }
    }

    try {
      // XenForoClient already decoded the body once; reuse it rather than
      // decoding (and, before, pretty-printing) every response again.
      final decoded = (result is XenForoCallResult && result.decoded != null)
          ? Map<String, dynamic>.of(result.decoded!)
          : jsonDecode(result.body) as Map<String, dynamic>;
      // Thread fc_is_login from this HTTP response into the decoded map so callers
      // do not rely on SiteContext.lastCallFcIsLogin (which can be overwritten by a
      // concurrent API call from another BaseXenForoProxy instance).
      decoded['_fc_plugin_internal_fc_is_login'] = result.fcIsLogin;
      xfDebug('🔍 [BASE_PROXY] JSON decoded successfully, keys: ${decoded.keys.toList()}');
      return decoded;
    } catch (e, stackTrace) {
      xfDebug('❌ [BASE_PROXY] Failed to parse API response: $e');
      xfDebug('❌ [BASE_PROXY] Stack trace: $stackTrace');
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
    xfDebug('🔍 [XENFORO_API] $method $endpoint');
    if (body != null) {
      xfDebug('📤 [XENFORO_API] Body keys: ${body.keys.toList()}');
    }
  }

  /// Log API response for debugging
  void logApiResponse(FCCallResult result) {
    xfDebug('📥 [XENFORO_API] Status: ${result.statusCode}');
    xfDebug('📥 [XENFORO_API] Success: ${result.statusCode >= 200 && result.statusCode < 300}');
    xfDebug('📥 [XENFORO_API] Body: ${result.body.length} chars');
  }

  /// Confirm an apparently expired session with getConfig (one request may
  /// simply have lost its cookies) and relogin if it really expired. Returns
  /// whether the session is usable again. One check runs per forum at a time;
  /// calls that arrive while it runs share its outcome instead of starting
  /// their own getConfig and login.
  Future<bool> _checkSessionOrRelogin() {
    final running = _sessionChecks[siteContext];
    if (running != null) {
      xfDebug('🔄 [BASE_PROXY] Session check already running for this forum, waiting for it');
      return running;
    }
    final check = _runSessionCheck();
    _sessionChecks[siteContext] = check;
    check.whenComplete(() {
      if (identical(_sessionChecks[siteContext], check)) {
        _sessionChecks[siteContext] = null;
      }
    });
    return check;
  }

  Future<bool> _runSessionCheck() async {
    try {
      final confirm = await _client.forumcopilotApi(
          siteContext, {'method': 'getConfig', 'params': <String, dynamic>{}});
      if (confirm.statusCode >= 200 && confirm.statusCode < 300 && confirm.fcIsLogin) {
        xfDebug('🔄 [BASE_PROXY] getConfig confirms the session is still valid');
        return true;
      }
      if (!confirm.hasLoginHeader) {
        // The forum can't be reached: signing in again would fail the same way.
        xfDebug('🔄 [BASE_PROXY] getConfig did not reach the forum - no relogin');
        return false;
      }
      xfDebug('🔄 [BASE_PROXY] getConfig confirms signed out - attempting relogin');
      await _doRelogin();
      return true;
    } catch (e) {
      xfDebug('❌ [BASE_PROXY] Session check / relogin failed: $e');
      return false;
    }
  }

  /// Sign in again after the session expired. Throws when it can't. Only
  /// called through [_checkSessionOrRelogin], which keeps it to one at a time
  /// per forum.
  Future<void> _doRelogin() async {
    // Prefer the app's relogin strategy when available: the full automatic
    // login flow (cookies, passkey, credentials).
    if (siteContext.reloginHandler != null) {
      xfDebug('🔄 [BASE_PROXY] Attempting relogin via siteContext.reloginHandler...');
      if (await siteContext.reloginHandler!(siteContext)) {
        xfDebug('✅ [BASE_PROXY] Relogin via handler successful');
        return;
      }
      throw Exception('Relogin failed via handler');
    }

    if (siteContext.username == null ||
        siteContext.password == null ||
        siteContext.username!.isEmpty ||
        siteContext.password!.isEmpty) {
      throw Exception('Cannot relogin: no credentials available');
    }

    xfDebug('🔄 [BASE_PROXY] Attempting relogin with saved credentials');
    final loginResult = await XenForoUserProxy(siteContext).loginAsync(
      siteContext.username!,
      siteContext.password!,
      false, // not anonymous
      null, // no trust code
    );
    if (loginResult.result && loginResult.user != null) {
      xfDebug('✅ [BASE_PROXY] Relogin successful');
      return; // loginAsync already stored the login data on siteContext
    }
    // When the server asks for two-step verification there is no resultText.
    final message = loginResult.tfaRequired == true
        ? 'TFA required (use Sign in with passkey or complete TFA in app)'
        : (loginResult.resultText?.trim().isNotEmpty == true ? loginResult.resultText! : 'Unknown error');
    throw Exception('Relogin failed: $message');
  }
}
