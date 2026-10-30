import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forumcopilot_flutter/controllers/post_controller.dart';
import 'package:forumcopilot_flutter/l10n/generated/app_localizations.dart';
import 'package:forumcopilot_flutter/utils/forum_links.dart';
import 'package:forumcopilot_flutter/views/listitems/post_list_item.dart';
import 'package:forumcopilot_flutter/views/widgets/cached_redirect_image.dart';
import 'package:forumcopilot_flutter/utils/embed_links.dart';
import 'package:forumcopilot_flutter/views/widgets/code_block.dart';
import 'package:forumcopilot_flutter/views/widgets/custom_bb_stylesheet.dart';
import 'package:forumcopilot_flutter/views/widgets/embed_cards.dart';
import 'package:forumcopilot_flutter/views/widgets/link_preview_card.dart';
import 'package:forumcopilot_flutter/views/widgets/twitter_card.dart';
import 'package:forumcopilot_flutter/views/widgets/video_card.dart';
import 'package:forumcopilot_flutter/views/widgets/xenforo_content.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Posts drawn from the HTML XenForo renders (add-on 1.11.0's contentHtml),
/// as Flapp draws Flarum's. [_html] is the add-on's own output for a sample
/// post (quote, spoilers, mention, link, code, table, YouTube, attachment).
const _html = '''<b>Bold</b> and <img src="https://cdn.jsdelivr.net/joypixels/assets/8.0/png/unicode/64/1f642.png" class="smilie smilie--emoji" loading="lazy" width="64" height="64" alt=":)" title="Smile    :)"  data-smilie="1"data-shortname=":)" /> here<br />
<blockquote data-quote-name="WilliamThompson971" data-quote-type="post" data-quote-id="14" data-quote-member-id="2">Quoted <b>text</b></blockquote><details data-spoiler data-spoiler-title="Ending"><summary>Ending</summary>the secret part</details> and <span data-inline-spoiler>inline secret</span><br />
<a href="https://staging.forumcopilot.com/xenforo/members/2/" data-user-id="2">@WilliamThompson971</a> see <a href="https://example.com/page" target="_blank" class="link link--external" rel="nofollow ugc noopener">a link</a><br />
<pre class="xfBb-code" data-lang="php">echo 1;</pre> <code class="xfBb-icode">inline code</code><br />
<div class='xfBb-table'>
<table style='width: 100%'><tr><th>Head</th></tr><tr><td>Cell</td></tr></table>
</div><div data-media-site="youtube" data-media-key="dQw4w9WgXcQ" data-media-url="https://youtube.com/watch?v=dQw4w9WgXcQ"><a href="https://youtube.com/watch?v=dQw4w9WgXcQ">https://youtube.com/watch?v=dQw4w9WgXcQ</a></div><span data-attachment-id="5" data-attachment-full="1"><a href="https://staging.forumcopilot.com/xenforo/attachments/5/">View attachment 5</a></span>''';

final _site = SiteContext(
  siteType: 'xenforo',
  site: Site(id: 1, name: 'T', url: 'https://staging.forumcopilot.com/xenforo', description: '', endpoint: 'forumcopilot.php', baseUrl: 'https://staging.forumcopilot.com/xenforo', siteType: 'xenforo'),
  configDataOutput: FCConfigResult(),
);

String _allText(WidgetTester tester) => [
      for (final t in tester.widgetList<RichText>(find.byType(RichText))) t.text.toPlainText(),
      for (final t in tester.widgetList<Text>(find.byType(Text))) t.data ?? '',
    ].join('\n');

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<List<String>> pumpContent(WidgetTester tester) async {
    final taps = <String>[];
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Builder(
            builder: (context) => XenForoContent(
              html: _html,
              siteContext: _site,
              stylesheet: CustomBBStylesheet(
                siteContext: _site,
                context: context,
                contentId: '1',
                callbacks: BBCodeCallbacks(
                  onUrlTap: (url) => taps.add('url $url'),
                  onUserTap: (name, id) => taps.add('user $name $id'),
                  onImageTap: (url, _, __) => taps.add('image $url'),
                  attachments: [
                    FCAttachment(id: '5', filename: 'shot.png', fileSize: 1000, url: 'https://staging.forumcopilot.com/xenforo/attachments/5/', isImage: true, canViewUrl: true),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ));
    await tester.pump();
    return taps;
  }

  testWidgets('text, quote, code, table and smilie as the forum rendered them', (tester) async {
    await pumpContent(tester);
    final text = _allText(tester);
    expect(text, contains('Bold'));
    expect(text, contains('Quoted text'));
    expect(find.text('WilliamThompson971 said:'), findsOneWidget, reason: "the quote's header, in XenForo's words");
    expect(find.text('echo 1;'), findsOneWidget, reason: 'the code block');
    expect(text, contains('inline code'));
    expect(text, contains('Head'));
    expect(text, contains('Cell'));
    expect(find.byWidgetPredicate((w) => w is CachedRedirectImage && w.width != null && w.width! < 32), findsOneWidget,
        reason: 'the smilie, inline at the text size');
  });

  testWidgets('a spoiler opens on a tap; an inline one is blurred until tapped', (tester) async {
    await pumpContent(tester);
    expect(find.text('Spoiler: Ending'), findsOneWidget);
    expect(_allText(tester), isNot(contains('the secret part')));
    await tester.tap(find.text('Spoiler: Ending'));
    await tester.pump();
    expect(_allText(tester), contains('the secret part'));
    expect(find.byType(ImageFiltered), findsOneWidget);
  });

  testWidgets('mentions open the member, links go to the app, embeds and attachments are drawn', (tester) async {
    final taps = await pumpContent(tester);
    await tester.tapOnText(find.textRange.ofSubstring('@WilliamThompson971'));
    await tester.tapOnText(find.textRange.ofSubstring('a link'));
    expect(taps, ['user WilliamThompson971 2', 'url https://example.com/page']);
    // The quote's header opens the quoted post
    await tester.tap(find.text('WilliamThompson971 said:'));
    expect(taps.last, 'url ${ForumLinks.postUrl(_site.site, '14')}');
    expect(find.byWidgetPredicate((w) => w is EmbedVideoCard && w.link.youtubeId == 'dQw4w9WgXcQ'), findsOneWidget);
    expect(_allText(tester), isNot(contains('View attachment 5')), reason: "drawn by the app's attachment tag instead");
  });

  testWidgets("an attachment the post doesn't list keeps the forum's own link", (tester) async {
    final taps = <String>[];
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => XenForoContent(
            html: '<span data-attachment-id="9" data-attachment-full="0"><a href="https://x/attachments/9/">View attachment 9</a></span>',
            siteContext: _site,
            stylesheet: CustomBBStylesheet(siteContext: _site, context: context, callbacks: BBCodeCallbacks(onUrlTap: taps.add)),
          ),
        ),
      ),
    ));
    await tester.pump();
    expect(_allText(tester), contains('View attachment 9'));
    expect(_allText(tester), isNot(contains('[attach]')));
    await tester.tapOnText(find.textRange.ofSubstring('View attachment 9'));
    expect(taps, ['https://x/attachments/9/']);
  });

  testWidgets('videos get the video card, X the tweet card, other sites a preview or a row naming the site', (tester) async {
    final taps = <String>[];
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Builder(
            builder: (context) => XenForoContent(
              html: '<div data-media-site="vimeo" data-media-key="76979871" data-media-url="">Vimeo</div>'
                  '<div data-media-site="dailymotion" data-media-key="x8bhs6a" data-media-url="https://dailymotion.com/video/x8bhs6a">DM</div>'
                  '<div data-media-site="twitter" data-media-key="20" data-media-url="https://twitter.com/statuses/20">X</div>'
                  '<div data-media-site="instagram" data-media-key="C1abc" data-media-url="">Instagram</div>'
                  '<div data-media-site="spotify" data-media-key="track:1" data-media-url="">Spotify track</div>',
              siteContext: _site,
              stylesheet: CustomBBStylesheet(siteContext: _site, context: context, callbacks: BBCodeCallbacks(onUrlTap: taps.add)),
            ),
          ),
        ),
      ),
    ));
    expect(find.byWidgetPredicate((w) => w is EmbedVideoCard && w.link.url == 'https://vimeo.com/76979871'), findsOneWidget,
        reason: 'Vimeo has no address from the add-on: built from the key, drawn as a video');
    expect(
        find.byWidgetPredicate((w) =>
            w is EmbedVideoCard &&
            w.link.provider == EmbedLink.dailymotion &&
            w.link.thumbnailUrl == 'https://www.dailymotion.com/thumbnail/video/x8bhs6a'),
        findsOneWidget,
        reason: "Dailymotion's picture comes from the video's id");
    expect(find.byWidgetPredicate((w) => w is TwitterCard && w.url == 'https://x.com/i/status/20'), findsOneWidget,
        reason: "the add-on's twitter.com/statuses/{id} isn't a tweet address");
    expect(_allText(tester), contains('Spotify track'), reason: "a site without a known address keeps the add-on's text");

    // A page that offers no preview shows a row naming the site in its place.
    final preview = tester.widget<LinkPreviewCard>(find.byType(LinkPreviewCard));
    expect(preview.url, 'https://www.instagram.com/p/C1abc/');
    expect(preview.fallback, isA<EmbedRow>());
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: preview.fallback!)));
    expect(find.text('Instagram'), findsOneWidget);
    await tester.tap(find.text('instagram.com/p/C1abc/'));
    expect(taps, ['https://www.instagram.com/p/C1abc/']);
  });

  testWidgets('a video card names the site and opens the video', (tester) async {
    final opened = <String>[];
    final link = EmbedLink.fromUrl('https://vimeo.com/76979871', title: 'The New Vimeo Player')!;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: SizedBox(width: 360, child: EmbedVideoCard(link: link, onOpen: opened.add))),
    ));
    expect(find.text('The New Vimeo Player'), findsOneWidget);
    expect(find.text('Vimeo'), findsOneWidget, reason: 'the site, under the title');
    expect(tester.getSize(find.byType(AspectRatio)).aspectRatio, closeTo(16 / 9, 0.01));
    await tester.tap(find.byType(EmbedVideoCard));
    expect(opened, ['https://vimeo.com/76979871']);
  });

  test('embeds: which sites are videos, and the addresses the cards open', () {
    expect(EmbedLink.fromMediaSite('youtube', 'https://youtube.com/watch?v=dQw4w9WgXcQ').youtubeId, 'dQw4w9WgXcQ');
    expect(EmbedLink.fromMediaSite('youtube', 'https://youtube.com/shorts/dQw4w9WgXcQ').portrait, isTrue);
    expect(EmbedLink.fromMediaSite('vimeo', 'https://vimeo.com/76979871').provider.kind, EmbedKind.video);
    expect(EmbedLink.fromMediaSite('dailymotion', 'https://dailymotion.com/video/x8bhs6a').url, 'https://www.dailymotion.com/video/x8bhs6a');
    expect(EmbedLink.fromMediaSite('spotify', 'https://open.spotify.com/track/1').provider, EmbedLink.spotify);
    expect(EmbedLink.fromMediaSite('mysite', 'https://example.com/1').provider.name, 'mysite');
    expect(VideoCard.linkFor('dQw4w9WgXcQ')?.youtubeId, 'dQw4w9WgXcQ', reason: '[MEDIA=youtube] carries the bare id');
    expect(VideoCard.linkFor('https://example.com/page'), isNull);
  });

  test("inline styles: the background shorthand, and XenForo's fonts as the device has them", () {
    const box = '<div style="background: #e8f2fc; color: #0b3d63; border-left: 4px solid #1474b8">Tip</div>';
    expect(platformStyles(box, apple: false), contains('background-color: #e8f2fc; color: #0b3d63'));
    const fonts = '''<span style="font-family: 'Courier New'">a</span><span style="font-family: 'Georgia'">b</span><span style="font-family: 'Arial'">c</span>''';
    expect(platformStyles(fonts, apple: false),
        '''<span style="font-family: 'monospace'">a</span><span style="font-family: 'serif'">b</span><span style="font-family: 'Arial'">c</span>''');
    expect(platformStyles(fonts, apple: true), fonts, reason: 'iOS and macOS have these fonts');
    expect(platformStyles('<b>no styles</b>', apple: false), '<b>no styles</b>');
  });

  testWidgets('pictures in one post never share a Hero tag', (tester) async {
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Builder(
            builder: (context) => XenForoContent(
              html: '<span data-attachment-id="5" data-attachment-full="1"><a href="https://x/attachments/5/">5</a></span>'
                  '<span data-attachment-id="6" data-attachment-full="1"><a href="https://x/attachments/6/">6</a></span>',
              siteContext: _site,
              stylesheet: CustomBBStylesheet(
                siteContext: _site,
                context: context,
                contentId: '1892',
                callbacks: BBCodeCallbacks(
                  onImageTap: (_, __, ___) {},
                  attachments: [
                    for (final id in ['5', '6'])
                      FCAttachment(id: id, filename: '$id.png', fileSize: 1000, url: 'https://x/attachments/$id/', isImage: true, canViewUrl: true),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ));
    await tester.pump();
    final tags = tester.widgetList<Hero>(find.byType(Hero)).map((h) => h.tag).toList();
    expect(tags, hasLength(2));
    expect(tags.toSet(), hasLength(2), reason: 'each attachment is drawn by a renderer of its own; the tags must still differ');
  });

  testWidgets('a code block is coloured by its language and copies its text', (tester) async {
    final copied = <String>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
      if (call.method == 'Clipboard.setData') copied.add((call.arguments as Map)['text'] as String);
      return null;
    });
    const php = '<?php\necho "hi";';
    expect(CodeBlock.highlightSpans(php, 'php', const {}).length, greaterThan(1), reason: "XenForo's [CODE=php]");
    expect(CodeBlock.highlightSpans(php, '', const {}), hasLength(1), reason: 'no language: plain');
    expect(CodeBlock.highlightSpans(php, 'no-such-language', const {}), hasLength(1), reason: 'unknown: plain');

    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const Scaffold(body: CodeBlock(code: php, textStyle: TextStyle(fontSize: 14), language: 'php')),
    ));
    await tester.tap(find.byIcon(Icons.copy_rounded));
    await tester.pump();
    expect(copied, [php]);
    expect(find.text('Copied'), findsOneWidget);
  });

  testWidgets('a post draws its HTML, but a translation (of the BBCode) shows as before', (tester) async {
    Future<void> pumpPost(String? translated) => tester.pumpWidget(MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SingleChildScrollView(
              child: PostListItem(
                siteContext: _site,
                post: FCPost(
                  id: '42',
                  title: '',
                  content: '[B]From the BBCode[/B]',
                  contentHtml: '<b>From the HTML</b>',
                  topicId: '7',
                  authorId: '1',
                  authorName: 'author',
                  postNumber: 2,
                ),
                threadId: '7',
                topicTitle: 'Thread',
                postController: PostController(),
                translatedContent: translated,
              ),
            ),
          ),
        ));
    await pumpPost(null);
    expect(_allText(tester), contains('From the HTML'));
    expect(_allText(tester), isNot(contains('From the BBCode')));
    await pumpPost('Traduit');
    expect(_allText(tester), contains('Traduit'));
    expect(_allText(tester), isNot(contains('From the HTML')));
  });
}
