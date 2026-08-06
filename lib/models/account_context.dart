import 'package:forumcopilot_sdk/models/domain/site.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:get/get.dart';
import '../utils/site_utils.dart';
import '../controllers/site_controller.dart';
import 'package:forumcopilot_flutter/core/logging/app_logger.dart';
import 'secure_credential_store.dart';

// Decrypts values written by the OLD XOR-with-hardcoded-key scheme.
// The key is public (this repo is public), so this was never real encryption.
// Kept ONLY to migrate previously stored passwords into the platform
// keystore (SecureCredentialStore); nothing may write in this format.
class _LegacyXorMigration {
  static const String _key = 'ForumCopilotApp2024SecureKey';

  static String decrypt(String encryptedText) {
    try {
      final keyBytes = utf8.encode(_key);
      final encryptedBytes = base64.decode(encryptedText);
      final decrypted = <int>[];

      for (int i = 0; i < encryptedBytes.length; i++) {
        decrypted.add(encryptedBytes[i] ^ keyBytes[i % keyBytes.length]);
      }

      return utf8.decode(decrypted);
    } catch (e) {
      // Return empty string if decryption fails
      return '';
    }
  }
}

class SiteAccount {
  final Site site;
  final String username;
  final DateTime lastLoginTime;

  SiteAccount({
    required this.site,
    required this.username,
    required this.lastLoginTime,
  });

  Map<String, dynamic> toJson() => {
        'site': site.toJson(),
        'username': username,
        'lastLoginTime': lastLoginTime.toIso8601String(),
      };

  factory SiteAccount.fromJson(Map<String, dynamic> json) {
    return SiteAccount(
      site: SiteMapper.fromJson(json['site']),
      username: json['username'],
      lastLoginTime: DateTime.parse(json['lastLoginTime']),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SiteAccount && (site.id != null && other.site.id == site.id);
  }

  @override
  int get hashCode => site.id?.hashCode ?? 0;
}

class AccountContext {
  static const String _accountsKey = 'site_accounts';
  // Legacy SharedPreferences key holding XOR-"encrypted" passwords.
  // Only read once, to migrate into SecureCredentialStore, then removed.
  static const String _legacyPasswordsKey = 'site_passwords';
  // Keystore key prefix; full key is '$_securePasswordPrefix<host>'.
  static const String _securePasswordPrefix = 'site_password.';

  static AccountContext? _instance;
  static AccountContext get instance => _instance ??= AccountContext._();

  AccountContext._();

  List<SiteAccount> _accounts = [];
  // Hosts that have a password stored in SecureCredentialStore. Passwords
  // themselves are never cached here; they are read on demand.
  Set<String> _passwordHosts = {};
  bool _loaded = false;

  // Add a lock to prevent concurrent modifications
  bool _saving = false;

  String _getPasswordMapKey(String siteUrl) {
    return Uri.parse(siteUrl).host;
  }

  String _secureKeyForHost(String host) => '$_securePasswordPrefix$host';

  Future<void> loadFromDevice() async {
    if (_loaded) return;

    try {
      final prefs = await SharedPreferences.getInstance();

      // Load account information
      final accountsJson = prefs.getString(_accountsKey);
      if (accountsJson != null) {
        final List<dynamic> accountList = json.decode(accountsJson);
        _accounts = accountList
            .map((item) {
              try {
                return SiteAccount.fromJson(item);
              } catch (e) {
                AppLogger.debug('Error parsing site account: $e, item: $item');
                return null;
              }
            })
            .where((account) => account != null)
            .cast<SiteAccount>()
            .toList();
      }

      // One-time migration of legacy XOR-stored passwords into the keystore.
      await _migrateLegacyPasswords(prefs);

      // Index which hosts have passwords in the keystore.
      final secureKeys = await SecureCredentialStore.instance
          .keysWithPrefix(_securePasswordPrefix);
      _passwordHosts = secureKeys
          .map((key) => key.substring(_securePasswordPrefix.length))
          .toSet();

      _loaded = true;
    } catch (e) {
      AppLogger.debug('Error loading site accounts: $e');
      // Don't mark as loaded if there was an error
      _loaded = false;
      rethrow;
    }
  }

  /// Moves passwords written by the old XOR/SharedPreferences scheme into the
  /// platform keystore, then deletes the plaintext-equivalent copies. The
  /// legacy prefs entry is only removed after every password has been written
  /// to the keystore, so a failed migration retries on next launch.
  Future<void> _migrateLegacyPasswords(SharedPreferences prefs) async {
    final legacyJson = prefs.getString(_legacyPasswordsKey);
    // Clean up temp keys a crashed legacy save may have left behind.
    await prefs.remove('${_legacyPasswordsKey}_temp');

    if (legacyJson == null) return;

    try {
      final Map<String, dynamic> legacyMap = json.decode(legacyJson);
      for (final entry in legacyMap.cast<String, String>().entries) {
        final password = _LegacyXorMigration.decrypt(entry.value);
        if (password.isEmpty) continue;
        // Don't clobber a password already saved via the new path.
        final existing =
            await SecureCredentialStore.instance.read(_secureKeyForHost(entry.key));
        if (existing == null) {
          await SecureCredentialStore.instance
              .write(_secureKeyForHost(entry.key), password);
        }
      }
      await prefs.remove(_legacyPasswordsKey);
      AppLogger.debug(
          'AccountContext: migrated ${legacyMap.length} legacy password(s) to secure storage');
    } catch (e) {
      AppLogger.debug('AccountContext: legacy password migration failed: $e');
      // Leave the legacy entry in place so migration is retried next launch.
    }
  }

  Future<void> _saveToDevice() async {
    // Prevent concurrent saves
    if (_saving) {
      // Wait for current save to complete, then return since data will be up to date
      while (_saving) {
        await Future.delayed(const Duration(milliseconds: 10));
      }
      return;
    }

    _saving = true;
    try {
      final prefs = await SharedPreferences.getInstance();

      // Save account information (passwords live in SecureCredentialStore
      // and are written at the call sites, never through SharedPreferences)
      final accountsJson = json.encode(
        _accounts.map((account) => account.toJson()).toList(),
      );

      // Use a transaction-like approach: first write to a temp key, then rename
      const tempAccountsKey = '${_accountsKey}_temp';

      await prefs.setString(tempAccountsKey, accountsJson);

      // Verify the temp data was written correctly
      final verifyAccounts = prefs.getString(tempAccountsKey);

      if (verifyAccounts != accountsJson) {
        throw Exception('Failed to verify written data');
      }

      // Now atomically replace the main key
      await prefs.setString(_accountsKey, accountsJson);
      await prefs.remove(tempAccountsKey);
    } catch (e) {
      AppLogger.debug('Error saving site accounts: $e');
      rethrow;
    } finally {
      _saving = false;
    }
  }

  Future<void> saveAccount({
    required Site site,
    required String username,
    required String password,
  }) async {
    await loadFromDevice();

    // Create backup of current state for rollback
    final originalAccounts = List<SiteAccount>.from(_accounts);
    final originalPasswordHosts = Set<String>.from(_passwordHosts);
    if (site.id == null) {
      throw StateError('Site ID is required to save account');
    }
    final passwordMapKey = _getPasswordMapKey(site.url);
    final secureKey = _secureKeyForHost(passwordMapKey);
    final previousPassword = await SecureCredentialStore.instance.read(secureKey);

    try {
      // Remove existing account for this site using ID only
      _accounts.removeWhere((account) => account.site.id == site.id);

      // Add new site site account
      final newAccount = SiteAccount(
        site: site,
        username: username,
        lastLoginTime: DateTime.now(),
      );
      _accounts.add(newAccount);

      // Store password in the platform keystore
      await SecureCredentialStore.instance.write(secureKey, password);
      _passwordHosts.add(passwordMapKey);

      // Save all data
      await _saveToDevice();
    } catch (e) {
      AppLogger.debug('Error saving account for site site ${site.url}: $e');

      // Rollback on error
      _accounts = originalAccounts;
      _passwordHosts = originalPasswordHosts;
      try {
        if (previousPassword != null) {
          await SecureCredentialStore.instance.write(secureKey, previousPassword);
        } else {
          await SecureCredentialStore.instance.delete(secureKey);
        }
      } catch (rollbackError) {
        AppLogger.debug('Error rolling back secure password: $rollbackError');
      }

      rethrow;
    }
  }

  Future<String?> getPassword(String siteUrl) async {
    await loadFromDevice();

    try {
      AppLogger.debug('🔑 [GET_PASSWORD] Site URL: $siteUrl');
      AppLogger.debug('🔑 [GET_PASSWORD] Hosts with stored passwords: ${_passwordHosts.toList()}');

      // First, try to get the site ID from the current site context
      try {
        final siteController = Get.find<SiteController>();
        final currentSite = siteController.currentSite.value;

        if (currentSite?.id != null) {
          final siteId = currentSite!.id!;
          AppLogger.debug('🔑 [GET_PASSWORD] Using site ID from current context: $siteId');

          // Try to find password by site ID
          for (final account in _accounts) {
            if (account.site.id == siteId) {
              final accountPasswordKey = _getPasswordMapKey(account.site.url);
              final password = await SecureCredentialStore.instance
                  .read(_secureKeyForHost(accountPasswordKey));

              if (password != null && password.isNotEmpty) {
                AppLogger.debug('🔑 [GET_PASSWORD] ✅ Found password by site ID: $siteId');
                return password;
              }
            }
          }
          AppLogger.debug('🔑 [GET_PASSWORD] ❌ No password found for site ID: $siteId');
        } else {
          AppLogger.debug('🔑 [GET_PASSWORD] ⚠️  No site ID available in current context, falling back to URL matching');
        }
      } catch (e) {
        AppLogger.debug('🔑 [GET_PASSWORD] ⚠️  Error getting site ID from context: $e, falling back to URL matching');
      }

      // Fallback to URL-based matching
      AppLogger.debug('🔑 [GET_PASSWORD] Falling back to URL-based password lookup...');
      final passwordMapKey = _getPasswordMapKey(siteUrl);
      AppLogger.debug('🔑 [GET_PASSWORD] Password map key: $passwordMapKey');

      // Try the primary key first
      var password =
          await SecureCredentialStore.instance.read(_secureKeyForHost(passwordMapKey));
      AppLogger.debug('🔑 [GET_PASSWORD] Primary key match: ${password != null}');

      // If no match, try to find by hostname
      if (password == null) {
        final hostname = _getHostname(siteUrl);
        AppLogger.debug('🔑 [GET_PASSWORD] Trying hostname fallback: $hostname');

        for (final host in _passwordHosts) {
          if (_getHostname(host) == hostname) {
            password =
                await SecureCredentialStore.instance.read(_secureKeyForHost(host));
            AppLogger.debug('🔑 [GET_PASSWORD] Found password with hostname match: $host');
            break;
          }
        }
      }

      if (password == null || password.isEmpty) {
        AppLogger.debug('🔑 [GET_PASSWORD] ❌ No stored password found for key: $passwordMapKey');
        return null;
      }

      return password;
    } catch (e) {
      AppLogger.debug('🔑 [GET_PASSWORD] ❌ Error reading password for $siteUrl: $e');
      return null;
    }
  }

  Future<String?> getPasswordBySiteId(int siteId) async {
    await loadFromDevice();

    try {
      // Find the account by ID to map to its stored URL password key
      for (final account in _accounts) {
        if (account.site.id == siteId) {
          final accountPasswordKey = _getPasswordMapKey(account.site.url);
          final password = await SecureCredentialStore.instance
              .read(_secureKeyForHost(accountPasswordKey));
          if (password != null && password.isNotEmpty) {
            return password;
          }
        }
      }
      return null;
    } catch (e) {
      AppLogger.debug('🔑 [GET_PASSWORD_BY_ID] ❌ Error reading password for siteId=$siteId: $e');
      return null;
    }
  }

  Future<SiteAccount?> getAccount(String siteUrl) async {
    await loadFromDevice();

    AppLogger.debug('🔍 [GET_ACCOUNT] Looking for account with URL: $siteUrl');
    AppLogger.debug('🔍 [GET_ACCOUNT] Total accounts available: ${_accounts.length}');

    // First, try to get the site ID from the current site context
    try {
      final siteController = Get.find<SiteController>();
      final currentSite = siteController.currentSite.value;

      if (currentSite?.id != null) {
        final siteId = currentSite!.id!;
        AppLogger.debug('🔍 [GET_ACCOUNT] Using site ID from current context: $siteId');

        for (final account in _accounts) {
          AppLogger.debug('🔍 [GET_ACCOUNT] Checking account: ${account.site.name}');
          AppLogger.debug('🔍 [GET_ACCOUNT]   - Account ID: ${account.site.id}');
          AppLogger.debug('🔍 [GET_ACCOUNT]   - Account URL: ${account.site.url}');
          AppLogger.debug('🔍 [GET_ACCOUNT]   - Looking for ID: $siteId');

          if (account.site.id == siteId) {
            AppLogger.debug('🔍 [GET_ACCOUNT] ✅ Found matching account by ID: ${account.site.name}');
            return account;
          }
        }
        AppLogger.debug('🔍 [GET_ACCOUNT] ❌ No account found with ID: $siteId');
      } else {
        AppLogger.debug('🔍 [GET_ACCOUNT] ⚠️  No site ID available in current context, falling back to URL matching');
      }
    } catch (e) {
      AppLogger.debug('🔍 [GET_ACCOUNT] ⚠️  Error getting site ID from context: $e, falling back to URL matching');
    }

    // Fallback to URL matching if ID matching fails
    AppLogger.debug('🔍 [GET_ACCOUNT] Falling back to URL matching...');
    final normalizedInputUrl = siteUrl.trim().toLowerCase();
    AppLogger.debug('🔍 [GET_ACCOUNT] Normalized input URL: $normalizedInputUrl');

    for (final account in _accounts) {
      AppLogger.debug('🔍 [GET_ACCOUNT] Checking account: ${account.site.name}');
      AppLogger.debug('🔍 [GET_ACCOUNT]   - Account ID: ${account.site.id}');
      AppLogger.debug('🔍 [GET_ACCOUNT]   - Account URL: ${account.site.url}');

      // Normalize the stored URL
      final normalizedStoredUrl = account.site.url.trim().toLowerCase();
      AppLogger.debug('🔍 [GET_ACCOUNT]   - Normalized stored URL: $normalizedStoredUrl');

      // Try exact URL match
      final exactUrlMatch = account.site.url == siteUrl;

      // Try normalized URL match
      final normalizedUrlMatch = normalizedStoredUrl == normalizedInputUrl;

      // Try hostname match as fallback
      final hostnameMatch = _getHostname(account.site.url) == _getHostname(siteUrl);

      AppLogger.debug('🔍 [GET_ACCOUNT]   - Exact URL match: $exactUrlMatch');
      AppLogger.debug('🔍 [GET_ACCOUNT]   - Normalized URL match: $normalizedUrlMatch');
      AppLogger.debug('🔍 [GET_ACCOUNT]   - Hostname match: $hostnameMatch');

      if (exactUrlMatch || normalizedUrlMatch || hostnameMatch) {
        AppLogger.debug('🔍 [GET_ACCOUNT] ✅ Found matching account by URL: ${account.site.name}');
        return account;
      }
    }

    AppLogger.debug('🔍 [GET_ACCOUNT] ❌ No matching account found');
    return null;
  }

  Future<SiteAccount?> getAccountBySiteId(int siteId) async {
    await loadFromDevice();

    for (final account in _accounts) {
      if (account.site.id == siteId) {
        return account;
      }
    }
    return null;
  }

  String _getHostname(String url) {
    try {
      return Uri.parse(url).host.toLowerCase();
    } catch (e) {
      return url.toLowerCase();
    }
  }

  Future<Map<String, String>?> getCredentials(String siteUrl) async {
    await loadFromDevice();

    final account = await getAccount(siteUrl);
    if (account == null) return null;

    final password = await getPassword(siteUrl);
    if (password == null) return null;

    return {
      'username': account.username,
      'password': password,
    };
  }

  Future<Map<String, String>?> getCredentialsBySiteId(int siteId) async {
    await loadFromDevice();

    final account = await getAccountBySiteId(siteId);
    if (account == null) return null;

    final password = await getPasswordBySiteId(siteId);
    if (password == null) return null;

    return {
      'username': account.username,
      'password': password,
    };
  }

  Future<void> removeAccount(String siteUrl) async {
    // For backward compatibility, accept a string but require it to be an integer ID
    final int? siteId = int.tryParse(siteUrl);
    if (siteId == null) {
      throw StateError('Site ID is required to remove account');
    }
    await removeAccountBySiteId(siteId);
  }

  Future<void> removeAccountBySiteId(int siteId) async {
    await loadFromDevice();

    // Create backup for rollback
    final originalAccounts = List<SiteAccount>.from(_accounts);
    final originalPasswordHosts = Set<String>.from(_passwordHosts);

    try {
      // Get account info before removing for push notification cleanup
      final accountToRemove = _accounts.firstWhere(
        (account) => account.site.id == siteId,
        orElse: () => throw StateError('Account not found'),
      );

      // Remove account information using ID only
      _accounts.removeWhere((account) => account.site.id == siteId);

      // Remove password using URL-derived key of the located account
      final passwordMapKey = _getPasswordMapKey(accountToRemove.site.url);
      await SecureCredentialStore.instance.delete(_secureKeyForHost(passwordMapKey));
      _passwordHosts.remove(passwordMapKey);

      // Save updated data
      await _saveToDevice();

      // Unregister from push notifications
      await _unregisterFromPushNotifications(accountToRemove);
    } catch (e) {
      AppLogger.debug('Error removing account for siteId=$siteId: $e');

      // Rollback on error
      _accounts = originalAccounts;
      _passwordHosts = originalPasswordHosts;

      rethrow;
    }
  }

  Future<void> updateLastLoginTime(String siteUrl) async {
    await loadFromDevice();

    final accountIndex = _accounts.indexWhere(
      (account) => account.site.url == siteUrl,
    );

    if (accountIndex != -1) {
      // Create backup for rollback
      final originalAccount = _accounts[accountIndex];

      try {
        final account = _accounts[accountIndex];
        _accounts[accountIndex] = SiteAccount(
          site: account.site,
          username: account.username,
          lastLoginTime: DateTime.now(),
        );

        await _saveToDevice();
      } catch (e) {
        AppLogger.debug('Error updating last login time for $siteUrl: $e');

        // Rollback on error
        _accounts[accountIndex] = originalAccount;
        rethrow;
      }
    }
  }

  Future<List<SiteAccount>> getAllAccounts() async {
    await loadFromDevice();
    return List.from(_accounts);
  }

  Future<List<Site>> getAllAccountedSites() async {
    await loadFromDevice();
    return _accounts.map((account) => account.site).toList();
  }

  Future<bool> hasAccount(String siteUrl) async {
    await loadFromDevice();
    return _accounts.any((account) => account.site.url == siteUrl);
  }

  Future<void> clearAllAccounts() async {
    await loadFromDevice();

    // Create backup for rollback
    final originalAccounts = List<SiteAccount>.from(_accounts);
    final originalPasswordHosts = Set<String>.from(_passwordHosts);

    try {
      // Clear all data
      _accounts.clear();
      await SecureCredentialStore.instance.deleteWithPrefix(_securePasswordPrefix);
      _passwordHosts.clear();

      // Save empty data
      await _saveToDevice();
    } catch (e) {
      AppLogger.debug('Error clearing all accounts: $e');

      // Rollback on error
      _accounts = originalAccounts;
      _passwordHosts = originalPasswordHosts;

      rethrow;
    }
  }

  Future<void> changePassword({
    required String siteUrl,
    required String newPassword,
  }) async {
    await loadFromDevice();

    // Check if account exists
    if (!await hasAccount(siteUrl)) {
      throw Exception('No account found for site: $siteUrl');
    }

    final passwordMapKey = _getPasswordMapKey(siteUrl);
    final secureKey = _secureKeyForHost(passwordMapKey);
    final originalPassword = await SecureCredentialStore.instance.read(secureKey);

    try {
      // Update password in the platform keystore
      await SecureCredentialStore.instance.write(secureKey, newPassword);
      _passwordHosts.add(passwordMapKey);

      // Update last login time
      await updateLastLoginTime(siteUrl);
    } catch (e) {
      AppLogger.debug('Error changing password for $siteUrl: $e');

      // Rollback password on error
      try {
        if (originalPassword != null) {
          await SecureCredentialStore.instance.write(secureKey, originalPassword);
        } else {
          await SecureCredentialStore.instance.delete(secureKey);
          _passwordHosts.remove(passwordMapKey);
        }
      } catch (rollbackError) {
        AppLogger.debug('Error rolling back secure password: $rollbackError');
      }

      rethrow;
    }
  }

  /// Force reload accounts from device storage
  /// This can be useful after app crashes or when you want to ensure fresh data
  Future<void> forceReload() async {
    _loaded = false;
    _accounts.clear();
    _passwordHosts.clear();
    await loadFromDevice();
  }

  /// Clear corrupted account data and start fresh
  /// This can be used when there are persistent type errors
  Future<void> clearCorruptedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_accountsKey);
      await prefs.remove(_legacyPasswordsKey);
      await SecureCredentialStore.instance.deleteWithPrefix(_securePasswordPrefix);
      _loaded = false;
      _accounts.clear();
      _passwordHosts.clear();
      AppLogger.debug('AccountContext: Cleared corrupted account data');
    } catch (e) {
      AppLogger.debug('AccountContext: Error clearing corrupted data: $e');
    }
  }

  /// Verify storage consistency by checking if all accounts have corresponding passwords
  Future<Map<String, bool>> verifyStorageConsistency() async {
    await loadFromDevice();

    final consistencyReport = <String, bool>{};

    for (final account in _accounts) {
      final passwordMapKey = _getPasswordMapKey(account.site.url);
      final hasPassword = _passwordHosts.contains(passwordMapKey);
      consistencyReport[account.site.url] = hasPassword;
    }

    return consistencyReport;
  }

  /// In single-forum mode, site metadata is configured locally and does not
  /// need remote refresh from ForumCopilot APIs.
  Future<void> refreshSiteInformation() async {
    await loadFromDevice();
    AppLogger.debug(
      'AccountContext: refreshSiteInformation skipped in single-forum mode',
    );
  }

  /// Unregister from push notifications when removing account
  Future<void> _unregisterFromPushNotifications(SiteAccount account) async {
    try {
      AppLogger.debug('🔔 [ACCOUNT_CONTEXT] Starting push notification cleanup for site: ${account.site.name}');

      // Get site identifier for deregistration
      String? siteId;
      if (account.site.id != null) {
        siteId = account.site.id.toString();
      } else {
        // Use URL host as fallback
        try {
          final uri = Uri.parse(account.site.url);
          siteId = uri.host;
        } catch (e) {
          AppLogger.debug('🔔 [ACCOUNT_CONTEXT] Could not parse site URL: $e');
        }
      }

      if (siteId != null) {
        // Note: Push notification deregistration is primarily handled by LoginController during logout
        // This method serves as a backup cleanup mechanism
        AppLogger.debug('🔔 [ACCOUNT_CONTEXT] Site removed: ${account.site.name} (ID: $siteId)');
        AppLogger.debug('🔔 [ACCOUNT_CONTEXT] Push notification cleanup should be handled by LoginController during logout flow');
        AppLogger.debug('🔔 [ACCOUNT_CONTEXT] If this is called outside logout, manual cleanup may be needed');
      } else {
        AppLogger.debug('🔔 [ACCOUNT_CONTEXT] No site ID available for push notification cleanup');
      }
    } catch (e) {
      AppLogger.debug('🔔 [ACCOUNT_CONTEXT] Error during push notification cleanup: $e');
    }
  }
}
