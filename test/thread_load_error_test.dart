import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forumcopilot_flutter/controllers/global_loader_controller.dart';
import 'package:forumcopilot_flutter/l10n/generated/app_localizations.dart';
import 'package:forumcopilot_flutter/services/site_proxy_service.dart';
import 'package:forumcopilot_flutter/views/lists/posts_list.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A thread as the XenForo proxy reports it: the proxies never throw, a
/// refusal or a failed request is `result: false` with the reason.
FCThreadResult _thread({bool ok = true, String? text}) => FCThreadResult(
      result: ok,
      resultText: text,
      posts: [],
      totalPostNum: 0,
      id: '7',
      title: 'Seven',
      forumId: '2',
      forumName: 'Two',
      authorId: '1',
      authorName: 'Ann',
      authorUserType: '',
      timestamp: DateTime(2026, 10, 30),
    );

FCThreadByUnreadResult _unread({bool ok = true, String? text}) => FCThreadByUnreadResult(
      result: ok,
      resultText: text,
      posts: [],
      totalPostNum: 0,
      position: 0,
      id: '7',
      title: 'Seven',
      forumId: '2',
      forumName: 'Two',
      authorId: '1',
      authorName: 'Ann',
      authorUserType: '',
      timestamp: DateTime(2026, 10, 30),
    );

class _Posts implements IFCPostProxy {
  _Posts({required this.thread, this.unread});

  /// What getThread answers next; null never answers.
  FCThreadResult? Function() thread;
  FCThreadByUnreadResult Function()? unread;
  final calls = <String>[];

  @override
  Future<FCThreadResult> getThreadAsync(String topicId, int startNum, int lastNum, bool returnHtml) {
    calls.add('getThread');
    final answer = thread();
    return answer == null ? Completer<FCThreadResult>().future : Future.value(answer);
  }

  @override
  Future<FCThreadByUnreadResult> getThreadByUnreadAsync(String topicId, int postsPerRequest, bool returnHtml) async {
    calls.add('getThreadByUnread');
    return unread!();
  }

  @override
  dynamic noSuchMethod(Invocation i) => throw UnimplementedError('${i.memberName}');
}

class _Factory extends SiteProxyFactory {
  _Factory(this.posts);
  final IFCPostProxy posts;

  @override
  IFCPostProxy createPostProxy(SiteContext context) => posts;
  @override
  dynamic noSuchMethod(Invocation i) => throw UnimplementedError('${i.memberName}');
}

SiteContext _site() => SiteContext(
      siteType: 'xenforo',
      site: Site(id: 1, name: 'T', url: 'https://example.com', description: '', endpoint: 'forumcopilot.php', baseUrl: 'https://example.com', siteType: 'xenforo'),
      configDataOutput: FCConfigResult(),
    );

Future<void> _open(WidgetTester tester, _Posts posts, PostsListMode mode) async {
  final site = _site();
  SiteProxyService.initialize(site);
  SiteProxyFactory.register('xenforo', _Factory(posts));
  Get.put(GlobalLoaderController());
  await tester.pumpWidget(GetMaterialApp(
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: PostsList(siteContext: site, topicId: '7', topicTitle: 'Seven', mode: mode)),
  ));
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  tearDown(Get.reset);

  testWidgets('a first-unread open the forum refuses opens at the first page instead', (tester) async {
    final posts = _Posts(
      unread: () => _unread(ok: false, text: 'You must be logged-in to do that.'),
      thread: () => _thread(),
    );
    await _open(tester, posts, PostsListMode.first_unread);
    await tester.pumpAndSettle();

    expect(posts.calls, ['getThreadByUnread', 'getThread']);
    expect(find.text("Couldn't load this thread"), findsNothing);
    expect(find.text('End of the discussion'), findsOneWidget);
  });

  testWidgets('a thread that does not load says why, and Retry loads it', (tester) async {
    var refuse = true;
    final posts = _Posts(thread: () => refuse ? _thread(ok: false, text: 'The requested thread could not be found.') : _thread());
    await _open(tester, posts, PostsListMode.normal);
    await tester.pumpAndSettle();

    expect(find.text("Couldn't load this thread"), findsOneWidget);
    expect(find.text('The requested thread could not be found.'), findsOneWidget);

    refuse = false;
    await tester.tap(find.widgetWithText(FilledButton, 'Retry'));
    await tester.pumpAndSettle();
    expect(posts.calls, ['getThread', 'getThread']);
    expect(find.text("Couldn't load this thread"), findsNothing);
    expect(find.text('End of the discussion'), findsOneWidget);
  });

  testWidgets('a forum that never answers gets a time-out with Retry, not placeholders for good', (tester) async {
    final posts = _Posts(thread: () => null);
    await _open(tester, posts, PostsListMode.normal);
    await tester.pump();
    expect(find.text("Couldn't load this thread"), findsNothing, reason: 'still loading');

    await tester.pump(const Duration(seconds: 31));
    await tester.pump();
    expect(find.text("Couldn't load this thread"), findsOneWidget);
    expect(find.text("The forum didn't answer in time."), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Retry'), findsOneWidget);
  });
}
