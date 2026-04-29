import 'dart:async';
import 'package:forumcopilot_sdk/network/fc_call_result.dart';
import 'package:forumcopilot_sdk/models/results/fc_config_result.dart';
import 'package:forumcopilot_sdk/models/results/fc_user_result.dart';
import 'package:forumcopilot_sdk/services/fc_cache.dart';
import 'package:forumcopilot_sdk/services/fc_http_overrides.dart';
import 'package:forumcopilot_sdk/models/domain/site.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

/// Site context containing all forum and session information
/// This replaces BaseForumInfo and provides a cleaner abstraction
/// Now includes authentication state management (replaces AuthController)
class SiteContext {
  static const String loginMethodPassword = 'password';
  static const String loginMethodPasskey = 'passkey';

  Site site;
  FCConfigResult? configDataOutput;
  FCLoginResult? loginDataOutput;
  bool allowLoginRetry = true;

  /// When true, relogin must not run (e.g. between getPasskeyChallenge and loginWithPasskey)
  /// so the session challenge is not overwritten by a password-based TFA challenge.
  bool passkeyLoginInProgress = false;

  String? lastCallRequest;
  FCCallResult? _lastCallResponse;
  /// Set synchronously by XenForo [getConfig] from the same response map as that call.
  /// Use this instead of [lastCallFcIsLogin] when validating session right after getConfig,
  /// because [lastCallFcIsLogin] reflects the last API call globally and races with concurrency.
  bool? lastGetConfigFcIsLogin;
  String? _dynamicToken;
  String? username;
  String? password;
  String? lastSuccessfulLoginMethod;
  Future<bool> Function(SiteContext context)? reloginHandler;

  /// Site type identifier (e.g., "tapatalk", "otherforum", etc.)
  String siteType;

  /// Authentication state management (replaces AuthController)
  final ValueNotifier<bool> _isLoggedIn = ValueNotifier<bool>(false);
  bool get isLoggedIn => _isLoggedIn.value;
  ValueNotifier<bool> get isLoggedInNotifier => _isLoggedIn;

  String get siteKey => md5.convert(utf8.encode(site.pluginUrl)).toString();

  SiteContext({
    required this.siteType,
    required this.site,
    this.configDataOutput,
    this.loginDataOutput,
    this.allowLoginRetry = true,
    this.lastCallRequest,
    this.username,
    this.password,
    this.lastSuccessfulLoginMethod,
    FCCallResult? lastCallResponse,
    String? dynamicToken,
  })  : _lastCallResponse = lastCallResponse,
        _dynamicToken = dynamicToken;

  /// Check if the forum is properly initialized with a valid URL
  bool get isInitialized {
    return (site.pluginUrl.isNotEmpty);
  }

  setLastCallResponse(FCCallResult? result) {
    _lastCallResponse = result;
  }

  /// Get the last call response (for testing purposes)
  FCCallResult? get lastCallResponse => _lastCallResponse;

  /// Get fc_is_login value from the last call response
  bool get lastCallFcIsLogin => _lastCallResponse?.fcIsLogin ?? false;

  resetOnLogin() {
    FCCache.clearSiteCache(siteKey);
  }

  resetOnLogout() {
    unawaited(
      FCDioClient.instance.clearCookiesForDomain(
        Uri.parse(site.pluginUrl),
        reason: 'site_context.resetOnLogout',
      ),
    );
    _lastCallResponse = null;
    lastGetConfigFcIsLogin = null;
    loginDataOutput = null;
    lastSuccessfulLoginMethod = null;
    FCCache.clearSiteCache(siteKey);
  }

  FCConfigResult get ConfigData => configDataOutput!;
  Site get SiteData => site;
  FCLoginResult get LoginData => loginDataOutput!;
  bool get isLoginInformationAvailable => loginDataOutput != null;

  String get lastCallMemoryUsage {
    if (_lastCallResponse?.headers.containsKey('PluginMemoryUsage') ?? false) {
      return _lastCallResponse?.headers['PluginMemoryUsage']?.toLowerCase() ??
          '';
    }
    return '';
  }

  String get lastCallTimeTaken {
    if (_lastCallResponse?.headers.containsKey('PluginTimeTaken') ?? false) {
      return _lastCallResponse?.headers['PluginTimeTaken']?.toLowerCase() ?? '';
    }
    return '';
  }

  String get lastCallCPUUsage {
    if (_lastCallResponse?.headers.containsKey('TapatalkCPUUsage') ?? false) {
      return _lastCallResponse?.headers['TapatalkCPUUsage']?.toLowerCase() ??
          '';
    }
    return '';
  }

  // Add these methods to the SiteContext class
  Map<String, dynamic> toJson() {
    return {
      'siteType': siteType,
      'pluginUrl': site.pluginUrl,
      'allowLoginRetry': allowLoginRetry,
      'lastCallRequest': lastCallRequest,
      '_dynamicToken': _dynamicToken,
      'username': username,
      'password': password,
      'lastSuccessfulLoginMethod': lastSuccessfulLoginMethod,
      // Serialize complex objects
      'site': site.toJson(),
      'configDataOutput': configDataOutput?.toJson(),
      'loginDataOutput': loginDataOutput?.toJson(),
    };
  }

  static SiteContext fromJson(Map<String, dynamic> json) {
    final SiteContext context = SiteContext(
      siteType: json['siteType'] ?? 'tapatalk',
      site: SiteMapper.fromJson(json['site']),
    );

    // Don't overwrite the correctly parsed site object
    context.allowLoginRetry = json['allowLoginRetry'] ?? true;
    context.lastCallRequest = json['lastCallRequest'];
    context._dynamicToken = json['_dynamicToken'];
    context.username = json['username'];
    context.password = json['password'];
    context.lastSuccessfulLoginMethod = json['lastSuccessfulLoginMethod'];

    // Site is already correctly parsed in the constructor above

    if (json['configDataOutput'] != null) {
      context.configDataOutput =
          FCConfigResultMapper.fromJson(json['configDataOutput']);
    }

    if (json['loginDataOutput'] != null) {
      context.loginDataOutput =
          FCLoginResultMapper.fromJson(json['loginDataOutput']);
    }

    return context;
  }

  // Helper method to convert the object to a JSON string
  String toJsonString() {
    return jsonEncode(toJson());
  }

  // Helper method to create an object from a JSON string
  static SiteContext fromJsonString(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return fromJson(json);
  }

  // ===== PERSISTENCE METHODS (moved from TapatalkContext) =====

  /// Save the SiteContext to device
  Future<void> saveToDevice() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String siteContextJson = jsonEncode(toJson());
      await prefs.setString('site_context_${site.pluginUrl}', siteContextJson);
      print('💾 [SITE_CONTEXT] Saved context for: ${site.pluginUrl}');
    } catch (e) {
      print('❌ [SITE_CONTEXT_ERROR] Error saving site context: $e');
    }
  }

  /// Load the SiteContext from device
  static Future<SiteContext?> loadFromDevice(String pluginUrl) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? siteContextJson =
          prefs.getString('site_context_$pluginUrl');

      if (siteContextJson != null) {
        final loadedContext = SiteContext.fromJson(jsonDecode(siteContextJson));

        print('✅ [SITE_CONTEXT] Loaded context for: $pluginUrl');
        return loadedContext;
      }
    } catch (e) {
      print('❌ [SITE_CONTEXT_ERROR] Error loading site context: $e');
    }
    return null;
  }

  /// Clear all saved data (call when user logs out)
  Future<void> clearSavedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('site_context_${site.pluginUrl}');
      resetOnLogout();
      print('🗑️ [SITE_CONTEXT] Cleared all saved data');
    } catch (e) {
      print('❌ [SITE_CONTEXT_ERROR] Error clearing saved data: $e');
    }
  }

  /// Clear data for a specific site URL
  Future<void> clearSiteData(String siteUrl) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'site_context_$siteUrl';
      await prefs.remove(key);
      print('🗑️ [SITE_CONTEXT] Cleared data for site: $siteUrl');

      // If this is the current site, reset the context
      if (site.pluginUrl == siteUrl) {
        resetOnLogout();
        print('🗑️ [SITE_CONTEXT] Reset current site context');
      }
    } catch (e) {
      print('❌ [SITE_CONTEXT_ERROR] Error clearing site data for $siteUrl: $e');
    }
  }

  // ===== AUTHENTICATION METHODS (replaces AuthController) =====

  /// Current user information (replaces AuthController properties)
  String? get currentUsername => loginDataOutput?.user?.username;
  String? get currentUserId => loginDataOutput?.user?.id;
  String? get currentAvatarUrl => loginDataOutput?.user?.iconUrl;

  /// Update login state based on current login information
  void updateLoginState() {
    print('🔒 [SITE_CONTEXT] updateLoginState() called');
    final newLoginState = isLoginInformationAvailable;
    _isLoggedIn.value = newLoginState;
    print('🔒 [SITE_CONTEXT] Login state updated: $newLoginState');
  }

  /// Update login state from fc_is_login header
  /// This is called after each API response to keep authentication state in sync
  void updateLoginStateFromHeader(bool fcIsLogin) {
    print(
        '🔒 [SITE_CONTEXT] updateLoginStateFromHeader called with fcIsLogin: $fcIsLogin');
    print('   - Current _isLoggedIn.value: ${_isLoggedIn.value}');
    print('   - Will update: ${fcIsLogin != _isLoggedIn.value}');
    if (fcIsLogin != _isLoggedIn.value) {
      final oldValue = _isLoggedIn.value;
      _isLoggedIn.value = fcIsLogin;
      print(
          '🔒 [SITE_CONTEXT] Login state updated from header: $oldValue -> $fcIsLogin');
      print('   - ValueNotifier listeners will be notified');
    } else {
      print('🔒 [SITE_CONTEXT] Login state unchanged, no update needed');
    }
  }

  /// Initialize authentication state (call this after setting loginDataOutput)
  void initializeAuth() {
    updateLoginState();
  }

  /// Set login data and update authentication state
  void setLoginData(FCLoginResult? loginData) {
    loginDataOutput = loginData;
    updateLoginState();
  }

  /// Clear login data and update authentication state
  void clearLoginData() {
    loginDataOutput = null;
    updateLoginState();
  }
}
