import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forumcopilot_flutter/controllers/post_controller.dart';
import 'package:forumcopilot_flutter/l10n/generated/app_localizations.dart';
import 'package:forumcopilot_flutter/views/listitems/post_list_item.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A post's signature (XenForo add-on 1.11.0+) shows under it, as on the
/// website; the add-on sends none when the member hides signatures.
void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  final site = SiteContext(
    siteType: 'xenforo',
    site: Site(id: 1, name: 'T', url: 'https://example.com', description: '', endpoint: 'forumcopilot.php', baseUrl: 'https://example.com', siteType: 'xenforo'),
    configDataOutput: FCConfigResult(),
  );

  Future<void> pumpPost(WidgetTester tester, String? signature) => tester.pumpWidget(MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: PostListItem(
              siteContext: site,
              post: FCPost(
                id: '42',
                title: '',
                content: 'The post itself.',
                topicId: '7',
                authorId: '1',
                authorName: 'author',
                postNumber: 3,
                signature: signature,
              ),
              threadId: '7',
              topicTitle: 'Thread',
              postController: PostController(),
            ),
          ),
        ),
      ));

  String allText(WidgetTester tester) =>
      tester.widgetList<RichText>(find.byType(RichText)).map((t) => t.text.toPlainText()).join('\n');

  testWidgets('a signature shows under the post, links kept and other BBCode dropped', (tester) async {
    await pumpPost(tester, '[b]Ann[/b] - [url=https://ann.example]my site[/url]');
    final text = allText(tester);
    expect(text, contains('Ann - my site'));
    expect(text, isNot(contains('[b]')));
    expect(find.byWidgetPredicate((w) => w.runtimeType.toString() == '_PostSignature'), findsOneWidget);
  });

  testWidgets('no signature, or an empty one, shows nothing', (tester) async {
    for (final signature in [null, '   ']) {
      await pumpPost(tester, signature);
      expect(find.byWidgetPredicate((w) => w.runtimeType.toString() == '_PostSignature'), findsNothing, reason: '$signature');
    }
  });
}
