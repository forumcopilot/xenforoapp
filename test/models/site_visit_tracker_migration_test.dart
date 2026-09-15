// Passwords saved by builds before the keystore change sit in
// SharedPreferences under `site_credentials`, XOR-"encrypted" with a key that
// ships in source. On first use after the upgrade they must move into the
// platform keystore and the prefs copy must go away, without the user having
// to log in again.
//
// SiteVisitTracker is a process-wide singleton that loads once, so this file
// holds a single test; anything else belongs in its own file.

import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:forumcopilot_flutter/config/app_forum_config.dart';
import 'package:forumcopilot_flutter/models/site_visit_history.dart';

/// The exact scheme old builds used in SiteVisitTracker: XOR against the
/// hardcoded key over UTF-16 code units, stored as a raw string (no base64).
String _legacyXor(String plaintext) {
  const key = 'ForumCopilotApp2024SecureKey';
  return String.fromCharCodes([
    for (var i = 0; i < plaintext.length; i++)
      plaintext.codeUnitAt(i) ^ key.codeUnitAt(i % key.length),
  ]);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('legacy XOR credentials move to the keystore and leave prefs',
      () async {
    final site = AppForumConfig.buildSite();
    final siteId = site.id.toString();

    SharedPreferences.setMockInitialValues({
      'site_credentials': json.encode({siteId: _legacyXor('s3cret-pass')}),
      'site_usernames': json.encode({siteId: 'alice'}),
    });
    FlutterSecureStorage.setMockInitialValues({});

    // First read after the upgrade: the legacy blob is decoded one last time.
    final credentials = await SiteVisitTracker.instance.getCredentials(site);
    expect(credentials, {'username': 'alice', 'password': 's3cret-pass'});

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.containsKey('site_credentials'), isFalse,
        reason: 'the XOR blob must be deleted once migrated');
    expect(prefs.getString('site_usernames'), isNotNull,
        reason: 'usernames are not secret and stay in prefs');

    const storage = FlutterSecureStorage();
    expect(await storage.read(key: 'visit_password.$siteId'), 's3cret-pass');
    expect(await storage.readAll(), hasLength(1),
        reason: 'nothing else goes into the keystore');

    // Forgetting the credentials clears the keystore entry too.
    await SiteVisitTracker.instance.removeCredentials(site);
    expect(await storage.read(key: 'visit_password.$siteId'), isNull);
    expect(await SiteVisitTracker.instance.getCredentials(site), isNull);
  });
}
