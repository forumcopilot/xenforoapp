import 'package:flutter_test/flutter_test.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';
import 'package:xenforo_core/src/xf_debug.dart';
import 'package:xenforo_core/xenforo_core.dart';

/// Offline tests for BaseXenForoProxy: what it logs, and how it recovers an
/// expired session. The HTTP client is a scripted fake.

SiteContext _signedInContext() => SiteContext(
      siteType: 'xenforo',
      site: Site(
        id: 1,
        name: 'Test',
        url: 'https://forum.example.com',
        description: '',
        endpoint: 'forumcopilot.php',
        baseUrl: 'https://forum.example.com',
        siteType: 'xenforo',
      ),
      loginDataOutput: FCLoginResult(
          result: true, resultText: '', user: FCUser(id: '2', username: 'alice')),
    );

/// The forum's session expired: every call says signed out until a relogin.
class _ExpiredSessionClient extends XenForoClient {
  bool signedIn = false;
  final calls = <String>[];

  @override
  Future<FCCallResult> forumcopilotApi(
      SiteContext context, Map<String, dynamic> requestData) async {
    final method = requestData['method'] as String;
    calls.add(method);
    await Future<void>.delayed(const Duration(milliseconds: 5));
    return XenForoCallResult(
      statusCode: 200,
      body: '{"result":true}',
      fcIsLogin: signedIn,
      decoded: {'result': true, 'method': method},
    );
  }
}

class _Proxy extends BaseXenForoProxy {
  _Proxy(super.siteContext, XenForoClient client) : super(client: client);
}

void main() {
  group('logging', () {
    test('secrets are never logged', () {
      for (final key in ['password', 'passwordConfirm', 'tfaCode', 'webauthn_payload', 'token', 'apiKey']) {
        expect(xfLoggableParam(key, 'hunter2'), '<redacted>', reason: key);
      }
      expect(xfLoggableParam('username', 'alice'), '"alice"');
      expect(xfLoggableParam('attachmentIds', ['1', '2']), 'List with 2 items');
    });
  });

  group('expired session', () {
    test('parallel calls share one session check and one relogin', () async {
      final context = _signedInContext();
      final client = _ExpiredSessionClient();
      var relogins = 0;
      context.reloginHandler = (_) async {
        relogins++;
        await Future<void>.delayed(const Duration(milliseconds: 20));
        client.signedIn = true;
        return true;
      };

      // The factory builds a new proxy per call, so use three instances.
      final results = await Future.wait([
        for (var i = 0; i < 3; i++) _Proxy(context, client).callPluginApi('getThread', {'topicId': '$i'}),
      ]);

      expect(relogins, 1);
      expect(client.calls.where((m) => m == 'getConfig').length, 1);
      // Each call was retried once after the shared relogin.
      expect(client.calls.where((m) => m == 'getThread').length, 6);
      expect(results.every((r) => r['result'] == true), isTrue);
    });

    test('a failed relogin keeps the original reply', () async {
      final context = _signedInContext();
      final client = _ExpiredSessionClient();
      context.reloginHandler = (_) async => false;

      final result = await _Proxy(context, client).callPluginApi('getThread', {});

      expect(result['method'], 'getThread');
      expect(client.calls, ['getThread', 'getConfig']);
    });
  });
}
