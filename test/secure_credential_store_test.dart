import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forumcopilot_flutter/models/secure_credential_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A keystore in memory that can refuse reads the way the iOS Keychain does
/// around a lock-state change.
class _FakeStorage extends FlutterSecureStorage {
  _FakeStorage([Map<String, String>? initial]) : values = {...?initial};

  final Map<String, String> values;
  int refusals = 0;
  int reads = 0;
  int readAlls = 0;

  void _maybeRefuse() {
    if (refusals > 0) {
      refusals--;
      throw PlatformException(
        code: 'Unexpected security result code',
        message: 'Code: -25308, Message: User interaction is not allowed.',
      );
    }
  }

  @override
  Future<String?> read({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    reads++;
    _maybeRefuse();
    return values[key];
  }

  @override
  Future<Map<String, String>> readAll({
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    readAlls++;
    _maybeRefuse();
    return Map.of(values);
  }

  @override
  Future<void> write({
    required String key,
    required String? value,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    if (value == null) {
      values.remove(key);
    } else {
      values[key] = value;
    }
  }

  @override
  Future<void> delete({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    values.remove(key);
  }
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('a refused read is not an empty one', () {
    test('a brief refusal is retried and the password comes back', () async {
      final storage = _FakeStorage({'pw_1': 'secret'})..refusals = 2;
      final store = SecureCredentialStore.forTesting(storage);

      expect(await store.read('pw_1'), 'secret');
      expect(storage.reads, 3);
    });

    test('a refusal that persists throws, so the caller keeps the saved login', () async {
      final storage = _FakeStorage({'pw_1': 'secret'})..refusals = 99;
      final store = SecureCredentialStore.forTesting(storage);

      await expectLater(store.read('pw_1'), throwsA(isA<CredentialReadRefused>()));
      expect(storage.values, containsPair('pw_1', 'secret'), reason: 'nothing was deleted');
    });

    test('nothing saved reads as null', () async {
      final store = SecureCredentialStore.forTesting(_FakeStorage());
      expect(await store.read('pw_1'), isNull);
    });
  });

  group('iOS: entries move to the first_unlock class once', () {
    test('entries an older build wrote are rewritten under the new class', () async {
      final legacy = _FakeStorage({'pw_1': 'a', 'pw_2': 'b'});
      final current = _FakeStorage();
      final store = SecureCredentialStore.forTesting(current, legacyAppleStorage: legacy, isIOS: true);

      expect(await store.keysWithPrefix('pw_'), {'pw_1', 'pw_2'});
      expect(current.values, {'pw_1': 'a', 'pw_2': 'b'});

      // Done once per install, not on every read.
      await store.read('pw_1');
      final again = SecureCredentialStore.forTesting(current, legacyAppleStorage: legacy, isIOS: true);
      await again.read('pw_1');
      expect(legacy.readAlls, 1);
    });

    test('a refused move is tried again later, and reads still work meanwhile', () async {
      final legacy = _FakeStorage({'pw_1': 'a'})..refusals = 1;
      final current = _FakeStorage({'pw_1': 'a'});
      final store = SecureCredentialStore.forTesting(current, legacyAppleStorage: legacy, isIOS: true);

      expect(await store.read('pw_1'), 'a');
      expect(legacy.readAlls, 1);
      await store.read('pw_1');
      expect(legacy.readAlls, 2, reason: 'retried on the next use');
    });

    test('a delete reaches an entry still under the old class', () async {
      final legacy = _FakeStorage({'pw_1': 'a'})..refusals = 1; // move refused
      final current = _FakeStorage();
      final store = SecureCredentialStore.forTesting(current, legacyAppleStorage: legacy, isIOS: true);

      await store.delete('pw_1');
      expect(legacy.values, isEmpty);
    });

    test('other platforms never touch the old class', () async {
      final legacy = _FakeStorage({'pw_1': 'a'});
      final current = _FakeStorage();
      final store = SecureCredentialStore.forTesting(current, legacyAppleStorage: legacy);

      await store.keysWithPrefix('pw_');
      expect(legacy.readAlls, 0);
    });
  });
}
