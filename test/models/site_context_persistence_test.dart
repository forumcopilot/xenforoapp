// The SiteContext blob lives in plaintext SharedPreferences, so it must never
// carry the forum password: not as the top-level field older builds wrote,
// and not echoed inside the serialized login result (XenForo's loginAsync
// used to copy the submitted password into FCLoginResult.userpassword).
// A blob that still has either, written by an older build, is rewritten as
// soon as it is loaded rather than whenever the next save happens to occur.

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/models/domain/site.dart';
import 'package:forumcopilot_sdk/models/results/fc_user_result.dart';

const _password = 's3cret-pass';

Site _site() => Site(
      id: 1,
      name: 'Test',
      url: 'https://example.com',
      description: '',
      endpoint: 'forumcopilot.php',
      baseUrl: 'https://example.com',
      siteType: 'xenforo',
    );

String _prefsKey(Site site) => 'site_context_${site.pluginUrl}';

FCLoginResult _loginResult({String? userpassword}) => FCLoginResult(
      result: true,
      resultText: '',
      userpassword: userpassword,
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('saveToDevice writes the password nowhere', () async {
    SharedPreferences.setMockInitialValues({});
    final site = _site();
    final context = SiteContext(
      siteType: 'xenforo',
      site: site,
      username: 'alice',
      password: _password,
      loginDataOutput: _loginResult(userpassword: _password),
    );

    await context.saveToDevice();

    final prefs = await SharedPreferences.getInstance();
    final blob = prefs.getString(_prefsKey(site))!;
    expect(blob, isNot(contains(_password)));
    final decoded = json.decode(blob) as Map<String, dynamic>;
    expect(decoded.containsKey('password'), isFalse);
    expect(decoded['username'], 'alice');
    final loginData =
        json.decode(decoded['loginDataOutput'] as String) as Map<String, dynamic>;
    expect(loginData.containsKey('userpassword'), isFalse);
    expect(loginData['result'], isTrue, reason: 'the rest of the result stays');

    // Round trip: everything but the secret survives a reload.
    final reloaded = await SiteContext.loadFromDevice(site.pluginUrl);
    expect(reloaded, isNotNull);
    expect(reloaded!.username, 'alice');
    expect(reloaded.password, isNull);
    expect(reloaded.loginDataOutput?.result, isTrue);
    expect(reloaded.loginDataOutput?.userpassword, isNull);
  });

  test('a legacy blob loads with its password and is rewritten without it',
      () async {
    final site = _site();
    SharedPreferences.setMockInitialValues({
      _prefsKey(site): json.encode({
        'siteType': 'xenforo',
        'pluginUrl': site.pluginUrl,
        'username': 'alice',
        'password': _password,
        'site': site.toJson(),
        'loginDataOutput': _loginResult(userpassword: _password).toJson(),
      }),
    });

    final loaded = await SiteContext.loadFromDevice(site.pluginUrl);

    // This session keeps the password in memory: a relogin still needs it.
    expect(loaded, isNotNull);
    expect(loaded!.password, _password);
    expect(loaded.username, 'alice');

    // The stored copy is gone, from both places, without waiting for a save.
    final prefs = await SharedPreferences.getInstance();
    final blob = prefs.getString(_prefsKey(site))!;
    expect(blob, isNot(contains(_password)));
    final decoded = json.decode(blob) as Map<String, dynamic>;
    expect(decoded.containsKey('password'), isFalse);
    expect(decoded['username'], 'alice', reason: 'non-secret fields survive');
    final loginData =
        json.decode(decoded['loginDataOutput'] as String) as Map<String, dynamic>;
    expect(loginData.containsKey('userpassword'), isFalse);
    expect(loginData['result'], isTrue);
  });

  test('a blob with no secret in it is not rewritten on load', () async {
    final site = _site();
    final original = json.encode({
      'siteType': 'xenforo',
      'pluginUrl': site.pluginUrl,
      'username': 'alice',
      'site': site.toJson(),
      'loginDataOutput': _loginResult().toJson(),
    });
    SharedPreferences.setMockInitialValues({_prefsKey(site): original});

    final loaded = await SiteContext.loadFromDevice(site.pluginUrl);

    expect(loaded?.username, 'alice');
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString(_prefsKey(site)), original,
        reason: 'byte-identical: loadFromDevice must not have saved');
  });
}
