// PostListItem derives its body (BBCode processing, preview URLs, validity
// scans) once per input and memoises it in a process-wide LRU. That is only
// safe if a change to any input is noticed: an edited post, a translation
// arriving or being cleared. These tests pump real PostListItems with no
// network and check what is on screen after each change.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/models/domain/site.dart';
import 'package:forumcopilot_sdk/models/entities/fc_post.dart';
import 'package:forumcopilot_flutter/controllers/post_controller.dart';
import 'package:forumcopilot_flutter/views/listitems/post_list_item.dart';

SiteContext _siteContext() => SiteContext(
      siteType: 'xenforo',
      site: Site(
        id: 1,
        name: 'Test',
        url: 'https://example.com',
        description: '',
        endpoint: 'forumcopilot.php',
        baseUrl: 'https://example.com',
        siteType: 'xenforo',
      ),
    );

FCPost _post(String content, {String id = '42', bool isLiked = false}) => FCPost(
      id: id,
      title: 'Thread',
      content: content,
      topicId: '7',
      authorId: '1',
      authorName: 'author',
      postNumber: 1,
      isLiked: isLiked,
    );

class _Host extends StatelessWidget {
  const _Host(this.post, this.siteContext, this.controller, {this.translated});
  final FCPost post;
  final SiteContext siteContext;
  final PostController controller;
  final String? translated;

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: PostListItem(
              // Same key across pumps so the State survives and
              // didUpdateWidget — not initState — is what runs.
              key: const ValueKey('item'),
              siteContext: siteContext,
              post: post,
              threadId: '7',
              topicTitle: 'Thread',
              postController: controller,
              translatedContent: translated,
            ),
          ),
        ),
      );
}

void main() {
  late SiteContext ctx;
  late PostController controller;

  setUp(() {
    ctx = _siteContext();
    controller = PostController();
  });

  testWidgets('an edited post shows its new content', (tester) async {
    await tester.pumpWidget(_Host(_post('alpha one'), ctx, controller));
    expect(find.textContaining('alpha one', findRichText: true), findsOneWidget);

    await tester.pumpWidget(_Host(_post('beta two'), ctx, controller));
    expect(find.textContaining('beta two', findRichText: true), findsOneWidget);
    expect(find.textContaining('alpha one', findRichText: true), findsNothing);
  });

  testWidgets('a change that is not a content input keeps the content',
      (tester) async {
    await tester.pumpWidget(_Host(_post('beta two'), ctx, controller));
    await tester.pumpWidget(
        _Host(_post('beta two', isLiked: true), ctx, controller));
    expect(find.textContaining('beta two', findRichText: true), findsOneWidget);
  });

  testWidgets('a translation replaces the body and clearing it restores it',
      (tester) async {
    await tester.pumpWidget(_Host(_post('beta two'), ctx, controller));
    await tester.pumpWidget(
        _Host(_post('beta two'), ctx, controller, translated: 'gamma three'));
    expect(find.textContaining('gamma three', findRichText: true), findsOneWidget);
    expect(find.textContaining('beta two', findRichText: true), findsNothing);

    await tester.pumpWidget(_Host(_post('beta two'), ctx, controller));
    expect(find.textContaining('beta two', findRichText: true), findsOneWidget);
    expect(find.textContaining('gamma three', findRichText: true), findsNothing);
  });

  testWidgets('content served again from the cache is the right content',
      (tester) async {
    await tester.pumpWidget(_Host(_post('alpha one'), ctx, controller));
    await tester.pumpWidget(_Host(_post('beta two'), ctx, controller));
    // Second time round 'alpha one' is a cache hit for this post id.
    await tester.pumpWidget(_Host(_post('alpha one'), ctx, controller));
    expect(find.textContaining('alpha one', findRichText: true), findsOneWidget);
    expect(find.textContaining('beta two', findRichText: true), findsNothing);
  });

  testWidgets('two posts with the same text do not share a stale body',
      (tester) async {
    await tester.pumpWidget(_Host(_post('same text', id: 'a'), ctx, controller));
    await tester.pumpWidget(_Host(_post('same text', id: 'b'), ctx, controller));
    expect(find.textContaining('same text', findRichText: true), findsOneWidget);
  });
}
