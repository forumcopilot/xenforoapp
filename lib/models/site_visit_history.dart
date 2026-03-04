import 'package:forumcopilot_sdk/models/domain/site.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:forumcopilot_flutter/core/logging/app_logger.dart';

class SiteVisitHistory {
  final Site site;
  final DateTime visitTime;
  // Historical name; now also true for passkey-only "My Forums" entries.
  final bool hasSavedCredentials;
  final String? username;
  final DateTime? lastLoginTime;

  SiteVisitHistory({
    required this.site,
    required this.visitTime,
    this.hasSavedCredentials = false,
    this.username,
    this.lastLoginTime,
  });

  Map<String, dynamic> toJson() => {
        'site': site.toJson(),
        'visitTime': visitTime.toIso8601String(),
        'hasSavedCredentials': hasSavedCredentials,
        'username': username,
        'lastLoginTime': lastLoginTime?.toIso8601String(),
      };

  factory SiteVisitHistory.fromJson(Map<String, dynamic> json) {
    return SiteVisitHistory(
      site: SiteMapper.fromJson(json['site']),
      visitTime: DateTime.parse(json['visitTime']),
      hasSavedCredentials: json['hasSavedCredentials'] ?? false,
      username: json['username'],
      lastLoginTime: json['lastLoginTime'] != null
          ? DateTime.parse(json['lastLoginTime'])
          : null,
    );
  }

  SiteVisitHistory copyWith({
    Site? site,
    DateTime? visitTime,
    bool? hasSavedCredentials,
    String? username,
    DateTime? lastLoginTime,
  }) {
    return SiteVisitHistory(
      site: site ?? this.site,
      visitTime: visitTime ?? this.visitTime,
      hasSavedCredentials: hasSavedCredentials ?? this.hasSavedCredentials,
      username: username ?? this.username,
      lastLoginTime: lastLoginTime ?? this.lastLoginTime,
    );
  }
}

class SiteVisitTracker {
  static const String _visitHistoryKey = 'site_visit_history';
  static const String _credentialsKey = 'site_credentials';
  static const String _usernamesKey = 'site_usernames';
  static const int _maxRecentVisits = 10;

  static SiteVisitTracker? _instance;
  static SiteVisitTracker get instance => _instance ??= SiteVisitTracker._();

  SiteVisitTracker._();

  List<SiteVisitHistory> _recentVisits = [];
  Map<String, String> _credentials = {}; // siteId -> encrypted password
  Map<String, String> _usernames = {}; // siteId -> username
  bool _loaded = false;

  // Simple XOR-based encryption for passwords (same as AccountContext)
  static String _encrypt(String plaintext) {
    const String key = 'ForumCopilotApp2024SecureKey';
    final keyBytes = key.codeUnits;
    final plaintextBytes = plaintext.codeUnits;
    final encrypted = <int>[];

    for (int i = 0; i < plaintextBytes.length; i++) {
      encrypted.add(plaintextBytes[i] ^ keyBytes[i % keyBytes.length]);
    }

    return String.fromCharCodes(encrypted);
  }

  static String _decrypt(String encryptedText) {
    const String key = 'ForumCopilotApp2024SecureKey';
    final keyBytes = key.codeUnits;
    final encryptedBytes = encryptedText.codeUnits;
    final decrypted = <int>[];

    for (int i = 0; i < encryptedBytes.length; i++) {
      decrypted.add(encryptedBytes[i] ^ keyBytes[i % keyBytes.length]);
    }

    return String.fromCharCodes(decrypted);
  }

  Future<void> loadFromDevice() async {
    if (_loaded) {
      AppLogger.debug(
          '🔍 [LOAD_DEBUG] Already loaded, skipping loadFromDevice');
      return;
    }

    try {
      AppLogger.debug('🔍 [LOAD_DEBUG] Loading from SharedPreferences...');
      final prefs = await SharedPreferences.getInstance();

      // Load recent visits
      final visitHistoryJson = prefs.getString(_visitHistoryKey);
      AppLogger.debug(
          '🔍 [LOAD_DEBUG] Visit history JSON from storage: ${visitHistoryJson != null ? visitHistoryJson.length : 0} chars');

      if (visitHistoryJson != null) {
        final List<dynamic> visitList = json.decode(visitHistoryJson);
        _recentVisits =
            visitList.map((item) => SiteVisitHistory.fromJson(item)).toList();
        AppLogger.debug(
            '🔍 [LOAD_DEBUG] ✅ Loaded ${_recentVisits.length} recent visits from storage');
      } else {
        AppLogger.debug('🔍 [LOAD_DEBUG] No visit history found in storage');
        _recentVisits = [];
      }

      // Load credentials
      final credentialsJson = prefs.getString(_credentialsKey);
      AppLogger.debug(
          '🔍 [LOAD_DEBUG] Credentials JSON from storage: ${credentialsJson != null ? credentialsJson.length : 0} chars');

      if (credentialsJson != null) {
        final Map<String, dynamic> credentialsMap =
            json.decode(credentialsJson);
        _credentials = credentialsMap.cast<String, String>();
        AppLogger.debug(
            '🔍 [LOAD_DEBUG] ✅ Loaded ${_credentials.length} credentials from storage');
      } else {
        AppLogger.debug('🔍 [LOAD_DEBUG] No credentials found in storage');
        _credentials = {};
      }

      // Load usernames
      final usernamesJson = prefs.getString(_usernamesKey);
      if (usernamesJson != null) {
        final Map<String, dynamic> usernamesMap = json.decode(usernamesJson);
        _usernames = usernamesMap.cast<String, String>();
        AppLogger.debug(
            '🔍 [LOAD_DEBUG] ✅ Loaded ${_usernames.length} usernames from storage');
      } else {
        AppLogger.debug('🔍 [LOAD_DEBUG] No usernames found in storage');
        _usernames = {};
      }

      _loaded = true;
      AppLogger.debug('🔍 [LOAD_DEBUG] ✅ Load completed successfully');
    } catch (e) {
      AppLogger.debug('🔍 [LOAD_DEBUG] ❌ Error loading site visit history: $e');
      _loaded = false; // Reset loaded state on error
    }
  }

  Future<void> _saveToDevice() async {
    try {
      AppLogger.debug('🔍 [SAVE_DEBUG] _saveToDevice called');
      AppLogger.debug(
          '🔍 [SAVE_DEBUG] Saving ${_recentVisits.length} recent visits');
      AppLogger.debug(
          '🔍 [SAVE_DEBUG] Saving ${_credentials.length} credentials');

      final prefs = await SharedPreferences.getInstance();

      // Save recent visits
      final visitHistoryJson = json.encode(
        _recentVisits.map((visit) => visit.toJson()).toList(),
      );
      AppLogger.debug(
          '🔍 [SAVE_DEBUG] Visit history JSON length: ${visitHistoryJson.length}');
      await prefs.setString(_visitHistoryKey, visitHistoryJson);
      AppLogger.debug(
          '🔍 [SAVE_DEBUG] ✅ Recent visits saved to SharedPreferences');

      // Save credentials
      final credentialsJson = json.encode(_credentials);
      AppLogger.debug(
          '🔍 [SAVE_DEBUG] Credentials JSON length: ${credentialsJson.length}');
      await prefs.setString(_credentialsKey, credentialsJson);
      AppLogger.debug(
          '🔍 [SAVE_DEBUG] ✅ Credentials saved to SharedPreferences');

      // Save usernames
      final usernamesJson = json.encode(_usernames);
      await prefs.setString(_usernamesKey, usernamesJson);
      AppLogger.debug('🔍 [SAVE_DEBUG] ✅ Usernames saved to SharedPreferences');
    } catch (e) {
      AppLogger.debug('🔍 [SAVE_DEBUG] ❌ Error saving site visit history: $e');
    }
  }

  /// Unified method to record visit and optionally save credentials
  /// This is the ONLY method that should be called to record visits
  Future<void> recordVisit(
    Site site, {
    String? username,
    String? password,
    bool markAsMyForum = false,
  }) async {
    // Guard against invalid sites - must have Site ID
    if (site.id == null) {
      AppLogger.debug(
          '🔍 [RECENT_VISIT] ❌ Skipping visit record - site has no ID');
      return;
    }

    await loadFromDevice();

    final siteId = site.id.toString();
    final normalizedUsername = username?.trim();
    final hasNewUsername =
        normalizedUsername != null && normalizedUsername.isNotEmpty;
    final hasNewCredentials =
        hasNewUsername && password != null && password.isNotEmpty;

    // Save credentials if provided
    if (hasNewCredentials) {
      _credentials[siteId] = _encrypt(password);
      AppLogger.debug(
          '🔍 [RECENT_VISIT] Saved credentials for site: ${site.name}');
    }

    // Save username when available (supports passkey-only account entries).
    if (normalizedUsername != null && normalizedUsername.isNotEmpty) {
      _usernames[siteId] = normalizedUsername;
    }

    // Check if credentials already exist (even if not provided now)
    final hasExistingCredentials = _credentials.containsKey(siteId);
    final hasExistingUsername = (_usernames[siteId]?.isNotEmpty ?? false);
    final finalUsername =
        hasNewUsername ? normalizedUsername : _usernames[siteId];
    final hasCredentials = hasExistingCredentials ||
        hasNewCredentials ||
        hasExistingUsername ||
        markAsMyForum;
    final hasNewAccountSignal =
        hasNewCredentials || hasNewUsername || markAsMyForum;

    // Find existing visit entry
    final existingIndex = _recentVisits.indexWhere((v) => v.site.id == site.id);

    if (existingIndex >= 0) {
      // Update existing visit - move to front and update
      final existingVisit = _recentVisits.removeAt(existingIndex);
      _recentVisits.insert(
          0,
          SiteVisitHistory(
            site: site,
            visitTime: DateTime.now(), // Always update visit time
            hasSavedCredentials: hasCredentials,
            username: finalUsername,
            lastLoginTime: hasCredentials
                ? (hasNewAccountSignal
                    ? DateTime.now()
                    : existingVisit.lastLoginTime ?? DateTime.now())
                : null,
          ));
      AppLogger.debug(
          '🔍 [RECENT_VISIT] Updated existing visit for: ${site.name}, hasCredentials: $hasCredentials');
    } else {
      // Create new visit entry
      _recentVisits.insert(
          0,
          SiteVisitHistory(
            site: site,
            visitTime: DateTime.now(),
            hasSavedCredentials: hasCredentials,
            username: finalUsername,
            lastLoginTime: hasCredentials ? DateTime.now() : null,
          ));
      AppLogger.debug(
          '🔍 [RECENT_VISIT] Created new visit for: ${site.name}, hasCredentials: $hasCredentials');
    }

    // Keep only the most recent visits
    if (_recentVisits.length > _maxRecentVisits) {
      _recentVisits = _recentVisits.take(_maxRecentVisits).toList();
    }

    await _saveToDevice();
    AppLogger.debug('🔍 [RECENT_VISIT] ✅ Visit recorded successfully');
  }

  /// Get credentials - simple lookup from storage
  Future<Map<String, String>?> getCredentials(Site site) async {
    if (site.id == null) return null;

    await loadFromDevice();

    final siteId = site.id.toString();
    final encryptedPassword = _credentials[siteId];
    final username = _usernames[siteId];

    if (encryptedPassword == null || username == null) return null;

    return {
      'username': username,
      'password': _decrypt(encryptedPassword),
    };
  }

  /// Remove credentials - simple removal from storage
  Future<void> removeCredentials(Site site) async {
    if (site.id == null) return;

    await loadFromDevice();

    final siteId = site.id.toString();
    _credentials.remove(siteId);
    _usernames.remove(siteId);

    // Update visit entry to reflect removed credentials
    final index = _recentVisits.indexWhere((v) => v.site.id == site.id);
    if (index >= 0) {
      _recentVisits[index] = _recentVisits[index].copyWith(
        hasSavedCredentials: false,
        username: null,
        lastLoginTime: null,
      );
    }

    await _saveToDevice();
    AppLogger.debug('SiteVisitTracker: Removed credentials for ${site.name}');
  }

  Future<void> clearRecentVisits() async {
    await loadFromDevice();

    _recentVisits.clear();
    await _saveToDevice();
  }

  Future<void> removeFromRecentVisits(Site site) async {
    await loadFromDevice();

    // Guard against invalid sites - must have Site ID
    if (site.id == null) {
      return;
    }

    _recentVisits.removeWhere((visit) => visit.site.id == site.id);
    await _saveToDevice();
  }

  /// Get recent visits - no syncing needed because flag is always accurate
  Future<List<SiteVisitHistory>> getRecentVisits() async {
    await loadFromDevice();
    return List.from(_recentVisits);
  }

  /// Get sites with credentials - simple filter
  Future<List<Site>> getSitesWithCredentials() async {
    await loadFromDevice();
    return _recentVisits
        .where((visit) => visit.hasSavedCredentials)
        .map((visit) => visit.site)
        .toList();
  }

  Future<List<Site>> getAllVisitedSites() async {
    await loadFromDevice();

    final allSites = _recentVisits.map((visit) => visit.site).toList();

    AppLogger.debug(
        'SiteVisitTracker: Getting all visited sites. Total: ${allSites.length}');
    for (final site in allSites) {
      AppLogger.debug(
          'SiteVisitTracker: Visited site - ${site.name} (${site.url}) - ID: ${site.id}');
    }

    return allSites;
  }

  // Legacy method for compatibility
  Future<List<Site>> getMySites() async {
    return await getSitesWithCredentials();
  }

  Future<bool> isInMySites(Site site) async {
    await loadFromDevice();

    // Guard against invalid sites - must have Site ID
    if (site.id == null) {
      return false;
    }

    return _recentVisits
        .any((visit) => visit.site.id == site.id && visit.hasSavedCredentials);
  }

  /// In single-forum mode, site metadata is configured locally and does not
  /// need remote refresh from ForumCopilot APIs.
  Future<void> refreshSiteInformation() async {
    await loadFromDevice();
    AppLogger.debug(
      'SiteVisitTracker: refreshSiteInformation skipped in single-forum mode',
    );
  }
}
