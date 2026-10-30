import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';
import 'package:xenforo_core/xenforo_core.dart';

/// Offline tests for the main paths, through proxies built by
/// [XenForoProxyFactory] with a scripted client: sign-in, a thread, a reply,
/// conversations, and what happens on a redirect, a dead network, a hung
/// request, and a reply that arrives after the user signed out.

SiteContext _context({bool signedIn = true}) => SiteContext(
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
      loginDataOutput: signedIn
          ? FCLoginResult(result: true, resultText: '', user: FCUser(id: '2', username: 'alice'))
          : null,
      // These tests script the session themselves; no relogin round trips.
      allowLoginRetry: false,
    )..initializeAuth();

typedef _Reply = FutureOr<FCCallResult> Function(Map<String, dynamic> params);

/// Answers each API method with its scripted reply and records the requests.
class _ScriptedClient extends XenForoClient {
  _ScriptedClient(this.replies);

  final Map<String, _Reply> replies;
  final requests = <Map<String, dynamic>>[];

  @override
  Future<FCCallResult> forumcopilotApi(SiteContext context, Map<String, dynamic> requestData) async {
    requests.add(requestData);
    final method = requestData['method'] as String;
    final reply = replies[method];
    if (reply == null) fail('unscripted call: $method');
    return reply(Map<String, dynamic>.from(requestData['params'] as Map));
  }
}

/// A reply from the add-on: it always sends fc_is_login.
XenForoCallResult _ok(Map<String, dynamic> body, {bool signedIn = true}) => XenForoCallResult(
      statusCode: 200,
      body: jsonEncode(body),
      headers: {'fc_is_login': signedIn ? '1' : '0'},
      fcIsLogin: signedIn,
      decoded: body,
    );

/// What XenForoClient returns for a 3xx: it never follows it.
FCCallResult _redirect() => FCCallResult(
      statusCode: 301,
      body: jsonEncode({
        'error': 'The forum answered from a different address (https://www.forum.example.com/forumcopilot.php). '
            'Its address in the app may be out of date.',
        'result': false,
      }),
      headers: {'location': 'https://www.forum.example.com/forumcopilot.php'},
    );

/// What XenForoClient returns when the request never reached the forum.
FCCallResult _offline() => FCCallResult(
      statusCode: 0,
      body: jsonEncode({'error': 'Connection failed', 'type': 'DioExceptionType.connectionError'}),
    );

Map<String, dynamic> _thread() => {
      'result': true,
      'id': '7',
      'title': 'Welcome',
      'forumId': '3',
      'forumName': 'General',
      'authorId': '2',
      'authorName': 'alice',
      'authorUserType': 'normal',
      'timestamp': 1760000000,
      'totalPostNum': 2,
      'posts': [
        for (final (i, name) in [(1, 'alice'), (2, 'bob')])
          {
            'id': '${100 + i}',
            'title': '',
            'content': 'Post $i',
            'topicId': '7',
            'authorId': '$i',
            'authorName': name,
            'position': i,
          },
      ],
    };

void main() {
  group('the factory', () {
    test('every proxy it builds uses the injected client', () async {
      final client = _ScriptedClient({'getThread': (_) => _ok(_thread())});
      final factory = XenForoProxyFactory(client: client);

      final thread = await factory.createPostProxy(_context()).getThreadAsync('7', 0, 19, false);

      expect(thread.result, isTrue, reason: thread.resultText);
      expect(thread.posts.map((p) => p.authorName), ['alice', 'bob']);
      expect(thread.posts.first.postNumber, 1, reason: 'position is read as postNumber');
      expect(client.requests.single['params'], containsPair('topicId', '7'));
    });
  });

  group('sign-in', () {
    test('a successful login stores the member and signs the forum in', () async {
      final context = _context(signedIn: false);
      final client = _ScriptedClient({
        'login': (params) {
          expect(params['loginname'], 'alice');
          return _ok({
            'result': true,
            'user': {'id': 2, 'username': 'alice', 'userGroups': [2]},
          }, signedIn: false); // the login reply itself still says signed out
        },
      });

      final result = await XenForoProxyFactory(client: client)
          .createUserProxy(context)
          .loginAsync('alice', 'secret', false, null);

      expect(result.result, isTrue, reason: result.resultText);
      expect(context.currentUsername, 'alice');
      expect(context.isLoggedIn, isTrue);
    });

    test('a refused login is a failed result, not an exception', () async {
      final context = _context(signedIn: false);
      final client = _ScriptedClient({
        'login': (_) => _ok({'result': false, 'error': 'Incorrect password. Please try again.'}, signedIn: false),
      });

      final result = await XenForoProxyFactory(client: client)
          .createUserProxy(context)
          .loginAsync('alice', 'wrong', false, null);

      expect(result.result, isFalse);
      expect(context.isLoggedIn, isFalse);
    });
  });

  group('replying', () {
    test('the new post id comes back, and a moderated reply says so', () async {
      final client = _ScriptedClient({
        'replyPost': (params) {
          expect(params, containsPair('forumId', '3'));
          return _ok({'result': true, 'postId': 555, 'state': params['textBody'] == 'held' ? 1 : 0});
        },
      });
      final proxy = XenForoProxyFactory(client: client).createPostProxy(_context());

      final posted = await proxy.replyPostAsync('3', '7', '', 'hello', null, null, false);
      expect(posted.result, isTrue);
      expect(posted.postId, '555');
      expect(posted.state, 0);

      final held = await proxy.replyPostAsync('3', '7', '', 'held', null, null, false);
      expect(held.state, 1, reason: 'state 1 = waiting for moderator approval');
    });
  });

  group('conversations', () {
    test('the list parses, and unread counts come back', () async {
      final client = _ScriptedClient({
        'getConversations': (_) => _ok({
              'result': true,
              'conversationCount': 1,
              'unreadCount': 1,
              'list': [
                {
                  'id': 12,
                  'title': 'Hello',
                  'messageCount': 3,
                  'isUnread': true,
                  'participantCount': 2,
                  'startUserId': 3,
                  'startUsername': 'bob',
                  'startTime': 1760000000,
                  'lastMessageTime': 1760000500,
                },
              ],
            }),
        'getInboxStat': (_) => _ok({'result': true, 'unreadConversations': 4, 'unreadAlerts': 2}),
      });
      final proxy = XenForoProxyFactory(client: client).createPrivateConversationProxy(_context());

      final list = await proxy.getConversationsAsync(0, 19);
      expect(list.result, isTrue, reason: list.resultText);
      expect(list.list.single.convId, '12');
      expect(list.list.single.subject, 'Hello');
      expect(list.list.single.newPost, isTrue);

      final stat = await proxy.getInboxStatAsync();
      expect(stat.unreadConversations, 4);
    });
  });

  group('when the network misbehaves', () {
    test('a redirect is reported as an out-of-date address, never followed', () async {
      final client = _ScriptedClient({'getThread': (_) => _redirect()});

      final thread = await XenForoProxyFactory(client: client).createPostProxy(_context()).getThreadAsync('7', 0, 19, false);

      expect(thread.result, isFalse);
      expect(thread.resultText, contains('different address'));
      expect(client.requests, hasLength(1));
    });

    test('a dead network is a failed result, and does not sign the app out', () async {
      final context = _context()
        ..allowLoginRetry = true
        ..reloginHandler = (_) async => fail('no relogin over a dead network');
      // Only replyPost is scripted: a session-check getConfig would fail the test.
      final client = _ScriptedClient({'replyPost': (_) => _offline()});

      final posted = await XenForoProxyFactory(client: client)
          .createPostProxy(context)
          .replyPostAsync('3', '7', '', 'hello', null, null, false);

      expect(posted.result, isFalse);
      expect(posted.resultText, contains('Connection failed'));
      // It never reached the forum, so it says nothing about the session (it
      // used to read as "signed out" and flip the app to the guest view).
      expect(context.isLoggedIn, isTrue);
      expect(client.requests, hasLength(1), reason: 'and no relogin is attempted');
    });

    test('a hung request holds up nobody else', () async {
      final hang = Completer<FCCallResult>();
      final client = _ScriptedClient({
        'getThread': (_) => hang.future,
        'getInboxStat': (_) => _ok({'result': true, 'unreadConversations': 1, 'unreadAlerts': 0}),
      });
      final factory = XenForoProxyFactory(client: client);
      final context = _context();

      final hungThread = factory.createPostProxy(context).getThreadAsync('7', 0, 19, false);
      final stat = await factory
          .createPrivateConversationProxy(context)
          .getInboxStatAsync()
          .timeout(const Duration(seconds: 2));

      expect(stat.unreadConversations, 1);
      hang.complete(_ok(_thread()));
      expect((await hungThread).result, isTrue);
    });
  });

  group('replies from before a sign-in or sign-out', () {
    test('a late reply does not sign the app back in after sign-out', () async {
      final context = _context();
      final reply = Completer<FCCallResult>();
      final client = _ScriptedClient({'getThread': (_) => reply.future});

      // A request goes out while signed in...
      final pending = XenForoProxyFactory(client: client).createPostProxy(context).getThreadAsync('7', 0, 19, false);
      await Future<void>.delayed(Duration.zero);

      // ...the member signs out...
      context.resetOnLogout();
      context.updateLoginState();
      expect(context.isLoggedIn, isFalse);

      // ...and only then does its reply arrive, still saying "signed in".
      reply.complete(_ok(_thread(), signedIn: true));
      final thread = await pending;

      expect(thread.result, isTrue, reason: 'the caller still gets its data');
      expect(context.isLoggedIn, isFalse, reason: 'but the login state is left alone');
    });

    test('a late "signed out" does not sign out the new session', () async {
      final context = _context(signedIn: false);
      final reply = Completer<FCCallResult>();
      final client = _ScriptedClient({'getThread': (_) => reply.future});

      final pending = XenForoProxyFactory(client: client).createPostProxy(context).getThreadAsync('7', 0, 19, false);
      await Future<void>.delayed(Duration.zero);

      context.setLoginData(FCLoginResult(result: true, resultText: '', user: FCUser(id: '3', username: 'bob')));
      reply.complete(_ok(_thread(), signedIn: false));
      await pending;

      expect(context.isLoggedIn, isTrue);
      expect(context.currentUsername, 'bob');
    });

    test('replies to requests made in the current session still update it', () async {
      final context = _context();
      final client = _ScriptedClient({'getThread': (_) => _ok(_thread(), signedIn: false)});

      await XenForoProxyFactory(client: client).createPostProxy(context).getThreadAsync('7', 0, 19, false);

      expect(context.isLoggedIn, isFalse, reason: 'the forum says this session ended');
    });
  });

  group('paging and counts (SDK gaps)', () {
    test('conversations: the add-on gets a 1-based range, and hasMore comes from the total', () async {
      final client = _ScriptedClient({
        'getConversations': (params) => _ok({
              'result': true,
              'conversationCount': 45,
              'list': [
                for (var i = 0; i < 20; i++) {'id': i + 21, 'title': 'C${i + 21}', 'messageCount': 1},
              ],
            }),
      });
      final proxy = XenForoProxyFactory(client: client).createPrivateConversationProxy(_context());

      final second = await proxy.getConversationsAsync(20, 39);

      // ceil(21 / 20) = 2 on the add-on side; 20 used to give page 1 again.
      expect(client.requests.single['params'], {'startNum': 21, 'lastNum': 40});
      expect(second.hasMore, isTrue, reason: '20 + 20 < 45');
      final third = await proxy.getConversationsAsync(40, 59);
      expect(third.hasMore, isFalse, reason: '40 + 20 >= 45');
    });

    test('unread alerts come with the inbox counts', () async {
      final client = _ScriptedClient({
        'getInboxStat': (_) => _ok({'result': true, 'unreadConversations': 2, 'unreadAlerts': 7}),
      });
      final stat = await XenForoProxyFactory(client: client).createPrivateConversationProxy(_context()).getInboxStatAsync();
      expect(stat.unreadAlerts, 7);
    });

    test('alerts and search say whether another page follows', () async {
      final client = _ScriptedClient({
        'getAlert': (_) => _ok({'result': true, 'total': 30, 'items': []}),
        'searchTopic': (params) => _ok({'result': true, 'totalTopicNum': params['startNum'] == 0 ? 50 : 20, 'topics': []}),
      });
      final factory = XenForoProxyFactory(client: client);
      final alerts = await factory.createSocialProxy(_context()).getAlertAsync(1, 20, false);
      expect(alerts.hasMore, isTrue, reason: '1 x 20 < 30');
      final lastAlerts = await factory.createSocialProxy(_context()).getAlertAsync(2, 20, false);
      expect(lastAlerts.hasMore, isFalse);
      final first = await factory.createSearchProxy(_context()).searchTopicAsync('x', 0, 19, null);
      expect(first.hasMore, isTrue, reason: '0 < 50 results');
      final end = await factory.createSearchProxy(_context()).searchTopicAsync('x', 20, 39, null);
      expect(end.hasMore, isFalse, reason: 'the total (20) is reached');
    });
  });

  group("the forum's colours (getConfig style)", () {
    test('light and dark schemes come through, with the logo', () async {
      final client = _ScriptedClient({
        'getConfig': (_) => _ok({
              'result': true,
              'style': {
                'styleId': 1,
                'light': {
                  'headerBackground': '#0F578A',
                  'headerText': '#a3d4f5',
                  'link': '#1474b8',
                  'page': 'darken(#fff, 8%)', // not resolved: dropped
                  'logo': 'https://forum.example.com/styles/default/xenforo/xenforo-logo.svg',
                  'logoWidth': 100,
                  'logoHeight': '36',
                },
                'dark': {'headerBackground': '#0a1c29', 'link': '#5ca5d6'},
              },
            }),
      });
      final config = await XenForoProxyFactory(client: client)
          .createConfigProxy(_context())
          .getConfig('https://forum.example.com');
      final style = config.style!;
      expect(style.light!.headerBackground, '#0f578a');
      expect(style.light!.link, '#1474b8');
      expect(style.light!.page, isNull);
      expect(style.light!.logo, endsWith('xenforo-logo.svg'));
      expect(style.light!.logoWidth, 100);
      expect(style.light!.logoHeight, 36);
      expect(style.dark!.headerBackground, '#0a1c29');
    });

    test('an older add-on, or one that could not read the style, sends none', () async {
      for (final style in [null, <String, dynamic>{'light': null, 'dark': null}, 'oops']) {
        final client = _ScriptedClient({
          'getConfig': (_) => _ok({'result': true, if (style != null) 'style': style}),
        });
        final config = await XenForoProxyFactory(client: client)
            .createConfigProxy(_context())
            .getConfig('https://forum.example.com');
        expect(config.style, isNull, reason: '$style');
      }
    });
  });

  group('deleting the account', () {
    test('the forum says whether members can; older add-ons say nothing', () async {
      for (final (sent, expected) in [(true, true), (false, false), (null, null)]) {
        final client = _ScriptedClient({
          'getConfig': (_) => _ok({'result': true, if (sent != null) 'accountDeletion': sent}),
        });
        final config = await XenForoProxyFactory(client: client).createConfigProxy(_context()).getConfig('https://forum.example.com');
        expect(config.accountDeletion, expected);
      }
    });

    test('a refused delete keeps the session; a done one ends it', () async {
      final refused = _ScriptedClient({
        'deleteAccount': (_) => _ok({'result': false, 'resultText': 'Your password is incorrect.'}),
      });
      final context = _context();
      final proxy = XenForoProxyFactory(client: refused).createAccountProxy(context) as IFCAccountDeletion;
      final no = await proxy.deleteAccount(password: 'wrong');
      expect((no.result, no.resultText), (false, 'Your password is incorrect.'));
      expect(context.isLoggedIn, isTrue);
      expect(refused.requests.single['params'], {'password': 'wrong'});

      final done = _ScriptedClient({'deleteAccount': (_) => _ok({'result': true}, signedIn: false)});
      final context2 = _context();
      final yes = await (XenForoProxyFactory(client: done).createAccountProxy(context2) as IFCAccountDeletion)
          .deleteAccount(username: 'alice');
      expect(yes.result, isTrue);
      expect(context2.isLoggedIn, isFalse);
      expect(done.requests.single['params'], {'username': 'alice'});
    });
  });

  group("drafts (the forum's own, shared with the web editor)", () {
    test('save sends the message and extras under the key; load and list read them back', () async {
      final client = _ScriptedClient({
        'saveDraft': (_) => _ok({'result': true}),
        'getDraft': (p) => _ok({
              'result': true,
              'draft': p['draftKey'] == 'thread-4'
                  ? {'draftKey': 'thread-4', 'message': 'Half a [b]reply[/b]', 'extra': {}, 'lastUpdate': 1760000000}
                  : null,
            }),
        'getDrafts': (_) => _ok({
              'result': true,
              'total': 2,
              'drafts': [
                {'draftKey': 'forum-2', 'message': 'Body', 'extra': {'title': 'A new thread', 'prefix_id': '3'}, 'lastUpdate': 1760000100},
                {'draftKey': 'thread-4', 'message': 'Half', 'extra': {}, 'lastUpdate': 1760000000},
              ],
            }),
      });
      final drafts = XenForoProxyFactory(client: client).createDraftProxy(_context());

      final saved = await drafts.saveDraftAsync(
        draftKey: XenForoDraftProxy.newThreadKey('2'),
        data: {'reply': 'Body', 'title': 'A new thread', 'prefixId': 3},
      );
      expect(saved.result, isTrue);
      expect(client.requests.last['params'], {
        'draftKey': 'forum-2',
        'message': 'Body',
        'extra': {'title': 'A new thread', 'prefix_id': '3'},
      });

      final loaded = await drafts.loadDraftAsync(XenForoDraftProxy.replyKey('4'));
      expect(loaded.draft!.reply, 'Half a [b]reply[/b]');
      expect(loaded.draft!.topicId, 4);
      expect(loaded.draft!.updatedAt, DateTime.fromMillisecondsSinceEpoch(1760000000 * 1000));
      expect((await drafts.loadDraftAsync('thread-5')).draft, isNull);

      final list = await drafts.getMyDraftsAsync();
      expect(list.total, 2);
      expect(list.items.first.topicTitle, 'A new thread');
      expect(list.items.first.data['prefixId'], '3');
    });
  });

  group("signing in through the forum's website", () {
    test('the code and verifier sign the forum in; a refusal does not', () async {
      final client = _ScriptedClient({
        'completeBrowserLogin': (p) => p['verifier'] == 'right'
            ? _ok({'result': true, 'user': {'id': '7', 'username': 'carol'}})
            : _ok({'result': false, 'resultText': 'The sign-in has expired. Please try again.'}, signedIn: false),
        'getConfig': (_) => _ok({'result': true, 'browserLoginSchemes': ['forumcopilot']}),
      });
      final factory = XenForoProxyFactory(client: client);

      final config = await factory.createConfigProxy(_context(signedIn: false)).getConfig('https://forum.example.com');
      expect(config.browserLoginSchemes, ['forumcopilot']);

      final refusedContext = _context(signedIn: false);
      final refused = await (factory.createUserProxy(refusedContext) as IFCBrowserLogin)
          .completeBrowserLoginAsync(code: 'c', verifier: 'wrong');
      expect(refused.result, isFalse);
      expect(refusedContext.isLoggedIn, isFalse);

      final context = _context(signedIn: false);
      final result = await (factory.createUserProxy(context) as IFCBrowserLogin)
          .completeBrowserLoginAsync(code: 'c', verifier: 'right');
      expect(result.result, isTrue);
      expect(result.user!.username, 'carol');
      expect(context.isLoggedIn, isTrue);
      expect(client.requests.last['params'], {'code': 'c', 'verifier': 'right'});
    });
  });

  group('add-on 1.11.0', () {
    test('sign-out passes the device for push, only when the app has one', () async {
      final client = _ScriptedClient({'logout': (_) => _ok({'result': true}, signedIn: false)});
      final factory = XenForoProxyFactory(client: client);

      await factory.createUserProxy(_context()).logoutUserAsync(deviceId: 'dev-1', fcmToken: 'tok-1');
      await factory.createUserProxy(_context()).logoutUserAsync();

      expect(client.requests[0]['params'], {'deviceId': 'dev-1', 'fcmToken': 'tok-1'});
      expect(client.requests[1]['params'], isEmpty, reason: 'apps on hosted push send nothing');
    });

    test('a password change keeps this device registered when it says which it is', () async {
      final client = _ScriptedClient({'updatePassword': (_) => _ok({'result': true})});
      final proxy = XenForoProxyFactory(client: client).createAccountProxy(_context());

      final changed = await proxy.updatePassword('old', 'new', deviceId: 'dev-1');

      expect(changed.result, isTrue);
      expect(client.requests.single['params'], {'oldPassword': 'old', 'newPassword': 'new', 'deviceId': 'dev-1'});
    });

    test('ignoring: the list, the calls, and posts by ignored members', () async {
      final client = _ScriptedClient({
        'getIgnoredUsers': (_) => _ok({
              'result': true,
              'total': 1,
              'list': [
                {'id': '6', 'username': 'dan', 'iconUrl': ''},
              ],
            }),
        'ignoreUser': (_) => _ok({'result': true, 'isIgnored': true}),
        'unignoreUser': (_) => _ok({'result': true, 'isIgnored': false}),
        'getUserInfo': (_) => _ok({'result': true, 'id': '6', 'username': 'dan', 'canIgnore': true, 'isIgnored': true}),
        'getThread': (_) => _ok({
              ..._thread(),
              'posts': [
                for (final p in _thread()['posts'] as List) {...p as Map<String, dynamic>, 'isIgnored': p['authorId'] == '2'},
              ],
            }),
      });
      final factory = XenForoProxyFactory(client: client);
      final users = factory.createUserProxy(_context());

      final list = await users.getIgnoredUsersAsync(1, 100);
      expect(list.list.single.username, 'dan');
      expect(list.list.single.iconUrl, isNull, reason: 'no avatar');
      expect((await users.ignoreUserAsync('6', 1)).result, isTrue);
      expect((await users.ignoreUserAsync('6', 0)).result, isTrue);
      expect(client.requests.skip(1).take(2).map((r) => r['method']), ['ignoreUser', 'unignoreUser']);
      final info = await users.getUserInfoAsync(null, '6');
      expect((info.canIgnore, info.isIgnored), (true, true));
      final thread = await factory.createPostProxy(_context()).getThreadAsync('7', 0, 19, false);
      expect(thread.posts.map((p) => p.isIgnored), [false, true]);
    });

    test('older add-ons: nobody can be ignored and no post is', () async {
      final client = _ScriptedClient({
        'getUserInfo': (_) => _ok({'result': true, 'id': '6', 'username': 'dan'}),
        'getThread': (_) => _ok(_thread()),
      });
      final factory = XenForoProxyFactory(client: client);
      final info = await factory.createUserProxy(_context()).getUserInfoAsync(null, '6');
      expect((info.canIgnore, info.isIgnored), (false, false));
      final thread = await factory.createPostProxy(_context()).getThreadAsync('7', 0, 19, false);
      expect(thread.posts.every((p) => !p.isIgnored), isTrue);
    });

    test('moderation calls reach the add-on, and a refusal keeps its reason', () async {
      final client = _ScriptedClient({
        for (final m in ['stickTopic', 'unstickTopic', 'undeleteTopic', 'undeletePost', 'moveTopic', 'renameTopic', 'approveTopic', 'approvePost'])
          m: (params) => params['topicId'] == '0'
              ? _ok({'result': false, 'resultText': 'The requested thread could not be found.', 'errorCode': 'not_found'})
              : _ok({'result': true}),
      });
      final mod = XenForoProxyFactory(client: client).createModerationProxy(_context());

      expect((await mod.stickTopicAsync('7')).result, isTrue);
      expect((await mod.unstickTopicAsync('7')).result, isTrue);
      expect((await mod.undeleteTopicAsync('7', 'r')).result, isTrue);
      expect((await mod.undeletePostAsync('101', 'r')).result, isTrue);
      expect((await mod.moveTopicAsync('7', '4', true)).result, isTrue);
      expect((await mod.renameTopicAsync('7', 'New title')).result, isTrue);
      expect((await mod.approveTopicAsync('7')).result, isTrue);
      expect((await mod.approvePostAsync('101')).result, isTrue);
      final refused = await mod.renameTopicAsync('0', 'x');
      expect((refused.result, refused.resultText), (false, 'The requested thread could not be found.'));

      expect(client.requests[4]['params'], {'topicId': '7', 'forumId': '4', 'redirect': true});
      expect(client.requests[5]['params'], {'topicId': '7', 'title': 'New title'});
    });

    test('alerts: read state comes through, and marking read is sent only when asked', () async {
      final client = _ScriptedClient({
        'getAlert': (_) => _ok({
              'result': true,
              'total': 2,
              'items': [
                {'id': 9, 'type': 'post', 'message': 'A reply', 'timestamp': 1760000000000, 'isRead': true, 'isUnread': true},
                {'id': 8, 'type': 'post', 'message': 'Older', 'timestamp': 1750000000000, 'isRead': true, 'isUnread': false},
              ],
            }),
      });
      final social = XenForoProxyFactory(client: client).createSocialProxy(_context());

      final alerts = await social.getAlertAsync(1, 20, true);
      expect(alerts.items.map((a) => (a.alertId, a.isRead, a.isUnread)), [(9, true, true), (8, true, false)]);
      await social.getAlertAsync(1, 1, false, markReadIds: [9], skipMarkRead: true);
      await social.getAlertAsync(1, 20, true, markAllRead: true);

      expect(client.requests[0]['params'], {'page': 1, 'perpage': 20, 'forceRefresh': true}, reason: 'as before');
      expect(client.requests[1]['params'], containsPair('markReadIds', [9]));
      expect(client.requests[1]['params'], containsPair('skipMarkRead', true));
      expect(client.requests[2]['params'], containsPair('markAllRead', true));
      expect(client.requests[2]['params'], isNot(contains('skipMarkRead')));
    });

    test('alerts from an older add-on have no read state', () async {
      final client = _ScriptedClient({
        'getAlert': (_) => _ok({
              'result': true,
              'total': 1,
              'items': [
                {'id': 9, 'type': 'post', 'message': 'A reply', 'timestamp': 1760000000000, 'isRead': false},
              ],
            }),
      });
      final alerts = await XenForoProxyFactory(client: client).createSocialProxy(_context()).getAlertAsync(1, 20, true);
      expect((alerts.items.single.isRead, alerts.items.single.isUnread), (false, null));
    });

    test('question and suggestion threads: type, solved, score; the solution post', () async {
      final client = _ScriptedClient({
        'getTopic': (_) => _ok({
              'result': true,
              'totalTopicNum': 2,
              'topics': [
                {..._thread(), 'id': '7', 'posts': null, 'threadType': 'question', 'isSolved': true, 'solutionPostId': 102},
                {..._thread(), 'id': '8', 'posts': null, 'threadType': 'suggestion', 'voteScore': 5, 'voteCount': 7, 'canVote': true},
              ],
            }),
        'getThread': (_) => _ok({
              ..._thread(),
              'threadType': 'question',
              'solutionPostId': 102,
              'posts': [
                for (final p in _thread()['posts'] as List)
                  {...p as Map<String, dynamic>, 'isSolution': p['id'] == '102', 'signature': p['id'] == '101' ? 'Ann' : null},
              ],
            }),
      });
      final factory = XenForoProxyFactory(client: client);

      final topics = await factory.createTopicProxy(_context()).getTopicAsync('3', 0, 19);
      expect(topics.topics.map((t) => (t.threadType, t.isSolved, t.voteScore)),
          [('question', true, null), ('suggestion', false, 5)]);
      expect((topics.topics[1].voteCount, topics.topics[1].canVote), (7, true));
      final thread = await factory.createPostProxy(_context()).getThreadAsync('7', 0, 19, false);
      expect(thread.threadType, 'question');
      expect(thread.posts.map((p) => p.isSolution), [false, true]);
      expect(thread.posts.map((p) => p.signature), ['Ann', null], reason: 'none, or hidden by the member');
    });

    test("the forum's notices, pages and policy state; closing a notice", () async {
      final client = _ScriptedClient({
        'getConfig': (params) => params.containsKey('dismissNoticeId')
            ? _ok({'result': true})
            : _ok({
                'result': true,
                'ignoreUser': true,
                'notices': [
                  {'id': 3, 'type': 'block', 'title': 'Welcome', 'message': 'Read the rules.', 'dismissible': true},
                  {'id': 4, 'type': 'floating', 'title': '', 'message': '   '},
                ],
                'tosUrl': 'https://forum.example.com/help/terms/',
                'privacyPolicyUrl': '',
                'contactUrl': 'https://forum.example.com/misc/contact',
                'helpPages': [
                  {'id': 'smilies', 'title': 'Smilies', 'url': 'https://forum.example.com/help/smilies/'},
                ],
                'policyAcceptance': {'required': true, 'termsRequired': true, 'privacyRequired': false, 'acceptUrl': 'https://forum.example.com/misc/accept-terms'},
                'boardInactiveMessage': '',
              }),
      });
      final proxy = XenForoProxyFactory(client: client).createConfigProxy(_context());

      final config = await proxy.getConfig('https://forum.example.com');
      expect(config.notices!.map((n) => (n.id, n.title, n.message, n.dismissible)), [(3, 'Welcome', 'Read the rules.', true)],
          reason: 'a notice without text is left out');
      expect((config.tosUrl, config.privacyPolicyUrl, config.contactUrl),
          ('https://forum.example.com/help/terms/', null, 'https://forum.example.com/misc/contact'));
      expect(config.helpPages!.single.title, 'Smilies');
      expect((config.policyAcceptance!.termsRequired, config.policyAcceptance!.acceptUrl),
          (true, 'https://forum.example.com/misc/accept-terms'));
      expect(config.boardInactiveMessage, isNull, reason: 'the board is open');
      expect(config.ignoreUser, isTrue);

      expect(await (proxy as IFCNoticeDismissal).dismissNoticeAsync(3), isTrue);
      expect(client.requests.last['params'], {'dismissNoticeId': 3});
    });

    test('an older add-on sends none of these, and no ignoring', () async {
      final client = _ScriptedClient({'getConfig': (_) => _ok({'result': true})});
      final config = await XenForoProxyFactory(client: client).createConfigProxy(_context()).getConfig('https://forum.example.com');
      expect((config.notices, config.tosUrl, config.helpPages, config.policyAcceptance), (null, null, null, null));
      expect(config.ignoreUser, isFalse);
    });

    test('forums: the watch as the forum has it, and watching with options', () async {
      final client = _ScriptedClient({
        'getForum': (_) => _ok({
              'result': true,
              'forums': [
                {'id': 4, 'name': 'News', 'threadCount': 3, 'isSubscribed': true, 'canSubscribe': true, 'notifyOn': 'message',
                  'sendAlert': true, 'sendEmail': false, 'allowedWatchNotifications': 'all'},
                {'id': 5, 'name': 'Old', 'threadCount': 3},
              ],
            }),
        'subscribeForum': (_) => _ok({'result': true}),
      });
      final factory = XenForoProxyFactory(client: client);

      final forums = (await factory.createForumProxy(_context()).getForumAsync(true, '', true)).forums;
      expect(forums.map((f) => (f.isSubscribed, f.notifyOn, f.sendAlert, f.sendEmail, f.allowedWatchNotifications)),
          [(true, 'message', true, false, 'all'), (false, null, null, null, null)]);
      final subscriptions = factory.createSubscriptionProxy(_context());
      await subscriptions.subscribeForumAsync('4', 0, notifyOn: 'thread', sendAlert: true, sendEmail: false);
      await subscriptions.subscribeForumAsync('5', 1);
      expect(client.requests[1]['params'], {'forumId': '4', 'subscribeMode': 0, 'notifyOn': 'thread', 'sendAlert': true, 'sendEmail': false});
      expect(client.requests[2]['params'], {'forumId': '5', 'subscribeMode': 1}, reason: 'as before');
    });

    test("threads: the watch's email option, sent only when chosen, and read back", () async {
      final client = _ScriptedClient({
        'subscribeTopic': (params) => _ok({'result': true, 'isSubscribed': true, 'emailSubscribe': params['emailSubscribe'] ?? true}),
        'getTopic': (_) => _ok({
              'result': true,
              'totalTopicNum': 1,
              'topics': [
                {..._thread(), 'posts': null, 'isSubscribed': true, 'emailSubscribe': true},
              ],
            }),
      });
      final factory = XenForoProxyFactory(client: client);
      final subscriptions = factory.createSubscriptionProxy(_context());

      final current = await subscriptions.subscribeTopicAsync('7', 0);
      final changed = await subscriptions.subscribeTopicAsync('7', 0, emailSubscribe: false);
      expect(client.requests[0]['params'], {'topicId': '7', 'subscribeMode': 0}, reason: 'leaves a watch as it is');
      expect(client.requests[1]['params'], {'topicId': '7', 'subscribeMode': 0, 'emailSubscribe': false});
      expect((current.isSubscribed, current.emailSubscribe), (true, true));
      expect(changed.emailSubscribe, isFalse);
      final topics = await factory.createTopicProxy(_context()).getTopicAsync('3', 0, 19);
      expect(topics.topics.single.emailSubscribe, isTrue);
    });

    test("a forum's threads sorted and filtered, with the forum's sort options", () async {
      final client = _ScriptedClient({
        'getTopic': (params) => _ok({
              'result': true,
              'totalTopicNum': 0,
              'topics': [],
              'prefixes': [
                {'id': '2', 'title': 'Closed', 'group': 'Status'},
              ],
              'sortOptions': [
                {'key': 'last_post_date', 'title': 'Last message'},
                {'key': 'title', 'title': 'Title'},
              ],
              'defaultOrder': 'last_post_date',
              'defaultDirection': 'desc',
              'dateLimitDays': 0,
              'dateLimitOptions': [-1, 7, 30],
            }),
      });
      final topics = XenForoProxyFactory(client: client).createTopicProxy(_context());

      final plain = await topics.getTopicAsync('9', 0, 19);
      await topics.getTopicAsync('9', 0, 19,
          filters: const FCTopicFilters(order: 'title', direction: 'asc', prefixId: 2, starterName: ' ann ', lastDays: 30));
      expect(client.requests[0]['params'], {'forumId': '9', 'startNum': 0, 'lastNum': 19}, reason: 'as before');
      expect(client.requests[1]['params'], {
        'forumId': '9', 'startNum': 0, 'lastNum': 19,
        'order': 'title', 'direction': 'asc', 'prefixId': 2, 'starterName': 'ann', 'lastDays': 30,
      });
      expect(plain.sortOptions!.map((o) => (o.key, o.title)), [('last_post_date', 'Last message'), ('title', 'Title')]);
      expect((plain.defaultOrder, plain.defaultDirection, plain.dateLimitDays), ('last_post_date', 'desc', 0));
      expect(plain.dateLimitOptions, [-1, 7, 30]);
      expect(plain.prefixes.single.group, 'Status');
    });

    test('the filters the forum applied, without its own order and date limit', () async {
      final client = _ScriptedClient({
        'getTopic': (_) => _ok({
              'result': true,
              'totalTopicNum': 0,
              'topics': [],
              'appliedFilters': {'prefixId': 2, 'lastDays': 30, 'order': 'last_post_date', 'direction': 'desc'},
              'defaultOrder': 'last_post_date',
              'defaultDirection': 'desc',
              'dateLimitDays': 0,
            }),
      });
      final result = await XenForoProxyFactory(client: client)
          .createTopicProxy(_context())
          .getTopicAsync('9', 0, 19, filters: const FCTopicFilters(prefixId: 2, starterName: 'ghost', lastDays: 30));
      final applied = FCTopicFilters.fromApplied(result.appliedFilters!,
          defaultOrder: result.defaultOrder, defaultDirection: result.defaultDirection, dateLimitDays: result.dateLimitDays!);
      expect((applied.prefixId, applied.starterName, applied.lastDays, applied.order, applied.direction), (2, null, 30, null, null),
          reason: 'the unknown member was ignored; the forum order is no filter');
    });

    test('an older add-on: no sort options, so the app offers none', () async {
      final client = _ScriptedClient({'getTopic': (_) => _ok({'result': true, 'totalTopicNum': 0, 'topics': []})});
      final result = await XenForoProxyFactory(client: client).createTopicProxy(_context()).getTopicAsync('9', 0, 19);
      expect((result.sortOptions, result.dateLimitOptions), (null, null));
    });

    test("posting a thread: the forum's options, and tags, fields, type and poll sent", () async {
      final client = _ScriptedClient({
        'getForum': (_) => _ok({
              'result': true,
              'forums': [
                {
                  'id': 9, 'name': 'Bugs', 'threadCount': 1, 'canPost': true,
                  'forumType': 'discussion', 'canTag': true, 'minTags': 1, 'canCreatePoll': true,
                  'threadTypes': [
                    {'type': 'discussion', 'title': 'Discussion'},
                    {'type': 'poll', 'title': 'Poll'},
                  ],
                  'defaultThreadType': 'discussion',
                  'threadFields': [
                    {'id': 'os', 'title': 'OS', 'description': 'Which system', 'type': 'select', 'required': true,
                      'choices': [{'value': 'ios', 'title': 'iOS'}, {'value': 'android', 'title': 'Android'}], 'group': 'before', 'maxLength': 0},
                    {'id': 'areas', 'title': 'Areas', 'type': 'checkbox', 'choices': [{'value': 'ui', 'title': 'UI'}]},
                  ],
                },
                {'id': 5, 'name': 'Old', 'threadCount': 1},
              ],
            }),
        'newTopic': (_) => _ok({'result': true, 'topicId': '77', 'state': 0}),
      });
      final factory = XenForoProxyFactory(client: client);

      final forums = (await factory.createForumProxy(_context()).getForumAsync(true, '', true)).forums;
      final options = forums.first.postingOptions!;
      expect((options.canTag, options.minTags, options.canCreatePoll, options.defaultThreadType), (true, 1, true, 'discussion'));
      expect(options.threadTypes.map((t) => t.title), ['Discussion', 'Poll']);
      expect(options.threadFields.map((f) => (f.id, f.type, f.required, f.isMultiple)), [('os', 'select', true, false), ('areas', 'checkbox', false, true)]);
      expect(options.threadFields.first.choices.map((c) => c.title), ['iOS', 'Android']);
      expect(forums[1].postingOptions, isNull, reason: 'an older add-on');

      final posted = await factory.createTopicProxy(_context()).newTopic('9', 'Crash', 'It crashes',
          tags: ['crash', 'ios'], customFields: {'os': 'ios', 'areas': ['ui']}, threadType: 'poll',
          poll: const FCNewPoll(question: 'Seen it?', responses: ['Yes', 'No'], maxVotes: 0, closeDays: 7));
      expect(posted.topicId, '77');
      final sent = client.requests.last['params'] as Map;
      expect(sent['tags'], ['crash', 'ios']);
      expect(sent['customFields'], {'os': 'ios', 'areas': ['ui']});
      expect((sent['threadType'], sent['isPoll'], sent['pollQuestion'], sent['pollMaxVotes'], sent['pollCloseDays']), ('poll', true, 'Seen it?', 0, 7));
      expect(sent['pollOptions'], ['Yes', 'No']);

      await factory.createTopicProxy(_context()).newTopic('5', 'Plain', 'Text');
      expect((client.requests.last['params'] as Map).keys, isNot(contains('tags')), reason: 'nothing new sent unless used');
    });

    test('threads list the posts the viewer may see but others cannot', () async {
      final client = _ScriptedClient({
        'getThread': (_) => _ok({
              ..._thread(),
              'posts': [
                for (final p in _thread()['posts'] as List) p,
                {'id': '103', 'title': '', 'content': 'Hidden', 'topicId': '7', 'authorId': '3', 'authorName': 'cy', 'position': 2,
                  'isDeleted': true, 'canUndelete': true},
              ],
            }),
      });
      final thread = await XenForoProxyFactory(client: client).createPostProxy(_context()).getThreadAsync('7', 0, 19, false);
      expect(client.requests.single['params'], containsPair('includeHidden', true));
      expect(thread.posts.map((p) => (p.id, p.postNumber, p.isDeleted, p.canUndelete)),
          [('101', 1, false, false), ('102', 2, false, false), ('103', 2, true, true)]);
    });

    test('posts and messages come with the HTML the forum renders, asked for', () async {
      const html = '<blockquote data-quote-name="ann" data-quote-type="post" data-quote-id="14">Hi</blockquote>Yes <img class="smilie" data-smilie="1" alt=":)" src="https://x/1f642.png" />';
      final client = _ScriptedClient({
        'getThread': (_) => _ok({
              ..._thread(),
              'posts': [
                {...(_thread()['posts'] as List).first as Map<String, dynamic>, 'contentHtml': html, 'signatureHtml': '<b>Ann</b>'},
                (_thread()['posts'] as List).last,
              ],
            }),
        'getConversation': (_) => _ok({
              'result': true,
              'convId': '5',
              'convTitle': 'Hello',
              'totalMessageNum': 1,
              'participants': [],
              'messages': [
                {'messageId': '9', 'userId': '2', 'username': 'alice', 'messageContent': '[B]Hi[/B]', 'contentHtml': '<b>Hi</b>', 'timestamp': 1760000000000},
              ],
            }),
      });
      final factory = XenForoProxyFactory(client: client);

      final thread = await factory.createPostProxy(_context()).getThreadAsync('7', 0, 19, false);
      expect(client.requests.last['params'], containsPair('contentHtml', true));
      expect((thread.posts.first.contentHtml, thread.posts.first.signatureHtml), (html, '<b>Ann</b>'));
      expect(thread.posts.last.contentHtml, isNull, reason: 'none sent: the app draws the BBCode');

      final conversation = await factory.createPrivateConversationProxy(_context()).getConversationAsync('5', 0, 19, false);
      expect(client.requests.last['params'], containsPair('contentHtml', true));
      expect(conversation.messages.single.contentHtml, '<b>Hi</b>');
      expect(conversation.messages.single.textBody, '[B]Hi[/B]', reason: 'the BBCode stays for quoting and editing');
    });

    test('a ban sends its exact end as endTime, beside endDate for older add-ons', () async {
      final client = _ScriptedClient({'banUser': (_) => _ok({'result': true})});
      final mod = XenForoProxyFactory(client: client).createModerationProxy(_context());

      expect((await mod.banUserAsync('dan', 'spam', 1793423835, 0, 0)).result, isTrue);
      expect((await mod.banUserAsync('dan', 'spam', 0, 0, 0)).result, isTrue);

      expect(client.requests[0]['params'], containsPair('endTime', '1793423835'));
      expect(client.requests[0]['params'], contains('endDate'));
      expect(client.requests[1]['params'], isNot(contains('endTime')), reason: 'a permanent ban has no end');
    });
  });
}
