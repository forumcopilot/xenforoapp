import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forumcopilot_flutter/controllers/post_controller.dart';
import 'package:forumcopilot_flutter/l10n/generated/app_localizations.dart';
import 'package:forumcopilot_flutter/models/thread_view_data.dart';
import 'package:forumcopilot_flutter/services/site_proxy_service.dart';
import 'package:forumcopilot_flutter/views/listitems/post_list_item.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Posts the viewer may see but others can't (XenForo add-on 1.11.0's
/// includeHidden): moderated and deleted posts for moderators, a member's
/// own posts awaiting approval. They share the number of the visible post
/// before them, are badged, and moderators can approve or undelete them.

FCPost _post(String id, int number, {bool isApproved = true, bool isDeleted = false, bool canApprove = false, bool canUndelete = false}) => FCPost(
      id: id,
      title: '',
      content: 'Post $id',
      topicId: '7',
      authorId: '1',
      authorName: 'author',
      postNumber: number,
      isApproved: isApproved,
      isDeleted: isDeleted,
      canApprove: canApprove,
      canUndelete: canUndelete,
    );

class _Moderation implements IFCModerationProxy {
  final calls = <String>[];

  @override
  Future<FCApprovePostResult> approvePostAsync(String postId) async {
    calls.add('approve $postId');
    return FCApprovePostResult(result: true);
  }

  @override
  Future<FCUndeletePostResult> undeletePostAsync(String postId, String reason) async {
    calls.add('undelete $postId');
    return FCUndeletePostResult(result: true);
  }

  @override
  dynamic noSuchMethod(Invocation i) => throw UnimplementedError('${i.memberName}');
}

class _Factory extends SiteProxyFactory {
  _Factory(this.moderation);
  final IFCModerationProxy moderation;

  @override
  IFCModerationProxy createModerationProxy(SiteContext context) => moderation;
  @override
  dynamic noSuchMethod(Invocation i) => throw UnimplementedError('${i.memberName}');
}

SiteContext _moderator() => SiteContext(
      siteType: 'xenforo',
      site: Site(id: 1, name: 'T', url: 'https://example.com', description: '', endpoint: 'forumcopilot.php', baseUrl: 'https://example.com', siteType: 'xenforo'),
      configDataOutput: FCConfigResult(),
      loginDataOutput: FCLoginResult(result: true, resultText: '', user: FCUser(id: '1', username: 'mod')),
    )..initializeAuth();

Future<_Moderation> _pump(WidgetTester tester, FCPost post, {VoidCallback? onRefresh}) async {
  final site = _moderator();
  final moderation = _Moderation();
  SiteProxyService.initialize(site);
  SiteProxyFactory.register('xenforo', _Factory(moderation));
  await tester.pumpWidget(MaterialApp(
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: SingleChildScrollView(
        child: PostListItem(
          siteContext: site,
          post: post,
          threadId: '7',
          topicTitle: 'Thread',
          postController: PostController(),
          actions: PostActions(onRefresh: onRefresh),
        ),
      ),
    ),
  ));
  return moderation;
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('paging follows positions: a hidden post shares its neighbour\'s number', () {
    final data = ThreadViewData(
      topic: FCThreadResult(result: true, totalPostNum: 30, posts: [], id: '7', title: 'T', forumId: '1', forumName: 'F', authorId: '1', authorName: 'a', authorUserType: '2', timestamp: DateTime.utc(2026)),
      posts: [_post('1', 1), _post('2', 2), _post('2b', 2, isApproved: false), _post('3', 3)],
      currentStartNum: 0,
      position: 4,
    );
    expect(data.loadedCount, 4);
    expect(data.loadedEnd, 3, reason: 'three positions loaded, not four');
    expect(data.laterRange(20), {'startNum': 3, 'lastNum': 22});
  });

  testWidgets('a post awaiting approval is badged, and a moderator approves it', (tester) async {
    var refreshed = 0;
    final moderation = await _pump(tester, _post('9', 4, isApproved: false, canApprove: true), onRefresh: () => refreshed++);
    expect(find.text('AWAITING APPROVAL'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.more_vert_rounded).first);
    await tester.pumpAndSettle();
    expect(find.text('Undelete'), findsNothing);
    await tester.tap(find.text('Approve'));
    await tester.pumpAndSettle();
    expect(moderation.calls, ['approve 9']);
    expect(find.text('Post approved'), findsOneWidget);
    expect(refreshed, 1);
  });

  testWidgets('a deleted post can be undeleted where the forum allows it', (tester) async {
    final moderation = await _pump(tester, _post('8', 2, isDeleted: true, canUndelete: true));
    expect(find.text('DELETED'), findsOneWidget);
    expect(find.text('AWAITING APPROVAL'), findsNothing);
    await tester.tap(find.byIcon(Icons.more_vert_rounded).first);
    await tester.pumpAndSettle();
    expect(find.text('Approve'), findsNothing);
    await tester.tap(find.text('Undelete'));
    await tester.pumpAndSettle();
    expect(moderation.calls, ['undelete 8']);
  });

  testWidgets('without the permission, no Approve or Undelete', (tester) async {
    await _pump(tester, _post('8', 2, isDeleted: true));
    await tester.tap(find.byIcon(Icons.more_vert_rounded).first);
    await tester.pumpAndSettle();
    expect(find.text('Undelete'), findsNothing);
    expect(find.text('Approve'), findsNothing);
  });
}
