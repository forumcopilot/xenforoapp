import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The platform refused to read the store: typically the iOS Keychain around
/// a lock-state change (a push tapped on the lock screen). Not the same as an
/// empty read: the saved login is still there, and must not be treated as
/// signed out.
class CredentialReadRefused implements Exception {
  CredentialReadRefused(this.cause);

  final Object cause;

  @override
  String toString() => 'CredentialReadRefused: $cause';
}

/// Backing store for saved forum passwords, kept in the platform keystore
/// (Android Keystore, iOS/macOS Keychain, Windows Credential Manager,
/// libsecret on Linux) via `flutter_secure_storage`.
///
/// This replaces the legacy scheme that "encrypted" passwords with XOR using a
/// hardcoded key and persisted them in SharedPreferences. Since the key ships
/// in (public) source, XOR with it is equivalent to plaintext — passwords must
/// never be written outside this store.
///
/// Options, as in the Discourse app (discourse_secure_storage.dart):
/// - Android: EncryptedSharedPreferences instead of the library's legacy
///   scheme (an AES key wrapped by an RSA Keystore key, behind "signed out
///   after an update" reports). The plugin migrates existing entries on first
///   use. `resetOnError` lets a store it can't decrypt (a cloud-restored file
///   whose Keystore key didn't come with it) clear itself instead of failing
///   every read; the file is also excluded from backup and device transfer
///   (android/app/src/main/res/xml).
/// - iOS: `first_unlock` instead of the default `unlocked`, so a notification
///   tapped on the lock screen can read the password as the device unlocks.
///   Not `_this_device`, so iCloud/encrypted backups behave as before.
///   The plugin filters `readAll` and `delete` by class, so entries an older
///   build wrote are moved to the new class once ([_moveToCurrentAppleClass])
///   and deletes also go through the old class.
/// - macOS and the rest keep the library defaults.
class SecureCredentialStore {
  SecureCredentialStore._(this._storage, this._legacyAppleStorage, this._isIOS);

  static final SecureCredentialStore instance = SecureCredentialStore._(
    const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true, resetOnError: true),
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    ),
    // The class older builds wrote with (the library default). Only for
    // moving and deleting those entries; never written through.
    const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true, resetOnError: true),
    ),
    !kIsWeb && Platform.isIOS,
  );

  /// A store over [storage] for tests; [legacyAppleStorage] and [isIOS]
  /// exercise the iOS class move.
  @visibleForTesting
  factory SecureCredentialStore.forTesting(
    FlutterSecureStorage storage, {
    FlutterSecureStorage? legacyAppleStorage,
    bool isIOS = false,
    List<Duration> readRetryDelays = const [Duration.zero, Duration.zero, Duration.zero],
  }) =>
      SecureCredentialStore._(storage, legacyAppleStorage ?? storage, isIOS)..readRetryDelays = readRetryDelays;

  final FlutterSecureStorage _storage;
  final FlutterSecureStorage _legacyAppleStorage;
  final bool _isIOS;

  /// Pauses between attempts when the platform refuses a read. A refusal is
  /// usually the Keychain around a lock-state change, which settles in well
  /// under a second; the total stays short because site start-up waits on it.
  @visibleForTesting
  List<Duration> readRetryDelays = const [
    Duration(milliseconds: 250),
    Duration(milliseconds: 750),
    Duration(milliseconds: 1500),
  ];

  static const String _appleClassPrefKey = 'secure_credential_store_ios_class';
  static const String _appleClass = 'first_unlock';
  Future<void>? _appleClassMove;

  /// The saved value, or null when there is none. Throws
  /// [CredentialReadRefused] when the platform keeps refusing the read: the
  /// caller must not take that as "no saved login".
  Future<String?> read(String key) async {
    await _moveToCurrentAppleClass();
    return _retrying(() => _storage.read(key: key));
  }

  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  Future<void> delete(String key) async {
    await _storage.delete(key: key);
    if (_isIOS && !identical(_storage, _legacyAppleStorage)) {
      // An entry an older build wrote under the previous class, not moved yet.
      await _legacyAppleStorage.delete(key: key);
    }
  }

  /// All stored keys that start with [prefix].
  Future<Set<String>> keysWithPrefix(String prefix) async {
    await _moveToCurrentAppleClass();
    final all = await _retrying(() => _storage.readAll());
    return all.keys.where((key) => key.startsWith(prefix)).toSet();
  }

  /// Deletes every stored entry whose key starts with [prefix].
  Future<void> deleteWithPrefix(String prefix) async {
    for (final key in await keysWithPrefix(prefix)) {
      await delete(key);
    }
  }

  Future<T> _retrying<T>(Future<T> Function() op) async {
    for (var attempt = 0;; attempt++) {
      try {
        return await op();
      } catch (e) {
        if (attempt >= readRetryDelays.length) {
          debugPrint('SecureCredentialStore: read refused ${attempt + 1} times: $e');
          throw CredentialReadRefused(e);
        }
        await Future<void>.delayed(readRetryDelays[attempt]);
      }
    }
  }

  /// Once per install: rewrites the entries older builds stored under iOS's
  /// default class under [_appleClass]. The plugin's write replaces an entry
  /// of any class, so a rewrite is the whole move. A refused read leaves it
  /// for the next call; nothing is lost either way.
  Future<void> _moveToCurrentAppleClass() {
    if (!_isIOS) return Future<void>.value();
    return _appleClassMove ??= () async {
      try {
        final prefs = await SharedPreferences.getInstance();
        if (prefs.getString(_appleClassPrefKey) == _appleClass) return;
        final old = await _legacyAppleStorage.readAll();
        for (final entry in old.entries) {
          await _storage.write(key: entry.key, value: entry.value);
        }
        await prefs.setString(_appleClassPrefKey, _appleClass);
      } catch (e) {
        debugPrint('SecureCredentialStore: could not move entries to the new Keychain class yet: $e');
        _appleClassMove = null;
      }
    }();
  }
}
