import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Backing store for saved forum passwords, kept in the platform keystore
/// (Android Keystore, iOS/macOS Keychain, Windows Credential Manager,
/// libsecret on Linux) via `flutter_secure_storage`.
///
/// This replaces the legacy scheme that "encrypted" passwords with XOR using a
/// hardcoded key and persisted them in SharedPreferences. Since the key ships
/// in (public) source, XOR with it is equivalent to plaintext — passwords must
/// never be written outside this store.
class SecureCredentialStore {
  SecureCredentialStore._();

  static final SecureCredentialStore instance = SecureCredentialStore._();

  // Same construction as the canonical discourse_core usage of
  // flutter_secure_storage ^9.2.4.
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<String?> read(String key) => _storage.read(key: key);

  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  Future<void> delete(String key) => _storage.delete(key: key);

  /// All stored keys that start with [prefix].
  Future<Set<String>> keysWithPrefix(String prefix) async {
    final all = await _storage.readAll();
    return all.keys.where((key) => key.startsWith(prefix)).toSet();
  }

  /// Deletes every stored entry whose key starts with [prefix].
  Future<void> deleteWithPrefix(String prefix) async {
    for (final key in await keysWithPrefix(prefix)) {
      await _storage.delete(key: key);
    }
  }
}
