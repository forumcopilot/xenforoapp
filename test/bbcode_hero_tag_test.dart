// Hero tags handed to BBCode images must be a pure function of the content,
// not of when it happened to be rendered.
//
// `Hero` pairs the two ends of a flight by tag, and post content is cached, so
// a tag that changes between renders of the same post breaks the tap-to-view
// transition and goes stale inside anything that stored it. The old scheme
// read a static counter (`image-${url.hashCode}-${_counter++}`) that was
// mutated during render, so every rebuild of any post renumbered every image.

import 'package:flutter/material.dart';
import 'package:flutter_bbcode/flutter_bbcode.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/models/domain/site.dart';
import 'package:forumcopilot_flutter/views/widgets/custom_bb_stylesheet.dart';

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

/// Renders [bbcode] as the post [contentId] and returns the Hero tags in tree
/// order.
Future<List<String>> _heroTags(
  WidgetTester tester,
  String bbcode, {
  required String contentId,
}) async {
  await tester.pumpWidget(MaterialApp(
    home: Scaffold(
      body: Builder(
        builder: (context) => BBCodeText(
          data: bbcode,
          stylesheet: CustomBBStylesheet(
            siteContext: _siteContext(),
            context: context,
            contentId: contentId,
          ),
        ),
      ),
    ),
  ));
  await tester.pump();
  return tester
      .widgetList<Hero>(find.byType(Hero))
      .map((h) => h.tag.toString())
      .toList();
}

void main() {
  const twoImages =
      '[img]https://example.com/a.png[/img] and [img]https://example.com/b.png[/img]';

  testWidgets('the same post renders the same tags every time', (tester) async {
    final first = await _heroTags(tester, twoImages, contentId: '12345');
    final second = await _heroTags(tester, twoImages, contentId: '12345');

    expect(first, hasLength(2));
    expect(second, first,
        reason: 'a second render of the same post must reuse the same tags');
  });

  testWidgets('two images in one post get different tags', (tester) async {
    final tags = await _heroTags(tester, twoImages, contentId: '12345');
    expect(tags.toSet(), hasLength(2));
  });

  testWidgets('the same URL twice in one post still gets distinct tags',
      (tester) async {
    const repeated =
        '[img]https://example.com/a.png[/img] [img]https://example.com/a.png[/img]';
    final tags = await _heroTags(tester, repeated, contentId: '12345');
    expect(tags, hasLength(2));
    expect(tags.toSet(), hasLength(2),
        reason: 'two Heroes sharing a tag in one subtree is an error');
  });

  testWidgets('two posts embedding the same image do not collide',
      (tester) async {
    const one = '[img]https://example.com/a.png[/img]';
    final inPostA = await _heroTags(tester, one, contentId: 'postA');
    final inPostB = await _heroTags(tester, one, contentId: 'postB');
    expect(inPostA.single, isNot(inPostB.single));
  });
}
