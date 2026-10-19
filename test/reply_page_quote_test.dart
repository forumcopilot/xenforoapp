import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forumcopilot_flutter/l10n/generated/app_localizations.dart';
import 'package:forumcopilot_flutter/views/reply_page.dart';
import 'package:forumcopilot_flutter/views/widgets/quick_reply_bar.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Reply on a post in a thread: the full editor quoting it, on the
/// quick-reply bar's text, with the bar still on screen under it.

class _Posts implements IFCPostProxy {
  @override
  Future<FCQuotePostResult> getQuotePostAsync(String postId) async =>
      FCQuotePostResult(result: true, resultText: '', quoteContent: '[QUOTE="Ann, post: 9"]Hi[/QUOTE]');
  @override
  dynamic noSuchMethod(Invocation i) => throw UnimplementedError('${i.memberName}');
}

class _Attachments implements IFCAttachmentProxy {
  @override
  dynamic noSuchMethod(Invocation i) => throw UnimplementedError('${i.memberName}');
}

class _Factory extends SiteProxyFactory {
  @override
  IFCPostProxy createPostProxy(SiteContext context) => _Posts();
  @override
  IFCAttachmentProxy createAttachmentProxy(SiteContext context) => _Attachments();
  @override
  dynamic noSuchMethod(Invocation i) => throw UnimplementedError('${i.memberName}');
}

void main() {
  testWidgets('the quote goes after the bar\'s text, without an error from the bar under it', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final site = SiteContext(
      siteType: 'fake',
      site: Site(id: 1, name: 'T', url: 'https://example.com', description: '', endpoint: 'forumcopilot.php', baseUrl: 'https://example.com', siteType: 'fake'),
    );
    SiteProxyFactory.register('fake', _Factory());
    SiteProxyFactory.initialize(site);
    final barKey = GlobalKey<QuickReplyBarState>();
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) => Scaffold(
          body: Column(children: [
            const Spacer(),
            QuickReplyBar(key: barKey, draftKey: 'reply_draft:test:7', onSend: (_) async => true),
          ]),
        ),
      ),
    ));
    await tester.enterText(find.byType(TextField), 'I agree');
    final context = tester.element(find.byType(QuickReplyBar));
    var posted = true;
    final done = barKey.currentState!.openEditor((controller) async {
      await Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => ReplyPage(
          siteContext: site,
          threadId: '7',
          topicTitle: 'T',
          postId: '9',
          isQuote: true,
          contentController: controller,
        ),
      ));
      posted = false; // closed without posting
      return posted;
    });
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    final field = find.descendant(of: find.byType(ReplyPage), matching: find.byType(TextField));
    expect(tester.widget<TextField>(field.last).controller!.text, 'I agree\n\n[QUOTE="Ann, post: 9"]Hi[/QUOTE]\n');

    // Closed without posting: the bar keeps the text, quote included.
    Navigator.of(tester.element(find.byType(ReplyPage))).pop();
    await tester.pumpAndSettle();
    await done;
    expect(tester.takeException(), isNull);
    final barText = tester.widget<TextField>(find.descendant(of: find.byType(QuickReplyBar), matching: find.byType(TextField))).controller!.text;
    expect(barText, 'I agree\n\n[QUOTE="Ann, post: 9"]Hi[/QUOTE]\n');
  });
}
