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
}
