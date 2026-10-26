import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forumcopilot_flutter/l10n/generated/app_localizations.dart';
import 'package:forumcopilot_flutter/utils/app_navigation.dart';
import 'package:forumcopilot_flutter/views/reply_page.dart';
import 'package:forumcopilot_flutter/views/widgets/quick_reply_bar.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Closing the full Reply page opened from a thread's quick-reply bar (Reply
/// on a post, or the bar's expand button). ✕ asks what to do with what was
/// written: Discard empties the bar too, Save draft puts it back in the bar,
/// Cancel stays. Either way the thread comes back with the keyboard down: the
/// bar used to take focus back, with the keyboard over the thread.

class _Posts implements IFCPostProxy {
  Completer<FCQuotePostResult> quote = Completer<FCQuotePostResult>();

  @override
  Future<FCQuotePostResult> getQuotePostAsync(String postId) => quote.future;

  @override
  Future<FCReplyPostResult> replyPostAsync(String forumId, String topicId, String subject, String content,
          List<String>? attachmentIds, String? groupId, bool returnHtml) async =>
      FCReplyPostResult(result: true, resultText: '', postId: '10', state: 0);

  @override
  dynamic noSuchMethod(Invocation i) => throw UnimplementedError('${i.memberName}');
}

class _Attachments implements IFCAttachmentProxy {
  @override
  dynamic noSuchMethod(Invocation i) => throw UnimplementedError('${i.memberName}');
}

class _Factory extends SiteProxyFactory {
  _Factory(this.posts);
  final _Posts posts;
  @override
  IFCPostProxy createPostProxy(SiteContext context) => posts;
  @override
  IFCAttachmentProxy createAttachmentProxy(SiteContext context) => _Attachments();
  @override
  dynamic noSuchMethod(Invocation i) => throw UnimplementedError('${i.memberName}');
}

const _quote = '[QUOTE="Erwin P, post: 9"]Ik vind hem heel geslaagd[/QUOTE]';

void main() {
  late _Posts posts;
  late SiteContext site;
  late String draftKey;
  final barKey = GlobalKey<QuickReplyBarState>();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    posts = _Posts();
    site = SiteContext(
      siteType: 'fake',
      site: Site(id: 1, name: 'T', url: 'https://example.com', description: '', endpoint: 'forumcopilot.php', baseUrl: 'https://example.com', siteType: 'fake'),
    );
    SiteProxyFactory.register('fake', _Factory(posts));
    SiteProxyFactory.initialize(site);
    // The Reply page's own key for the thread's draft, which the bar shares.
    draftKey = 'reply_draft:${site.site.pluginUrl}:7';
  });

  /// iOS keeps its keyboard up until the app sends TextInput.hide: a field
  /// losing its connection does not put it away by itself.
  bool keyboardUp(WidgetTester tester) {
    var up = false;
    for (final call in tester.testTextInput.log) {
      if (call.method == 'TextInput.show') up = true;
      if (call.method == 'TextInput.hide') up = false;
    }
    return up;
  }

  TextField bar(WidgetTester tester) =>
      tester.widget<TextField>(find.descendant(of: find.byType(QuickReplyBar), matching: find.byType(TextField)));

  Finder editorField() => find.descendant(of: find.byType(ReplyPage), matching: find.byType(TextField));

  /// A thread with its quick-reply bar, typed in, then Reply on a post: the
  /// full editor quoting it, as the thread page opens it.
  Future<void> replyOnPost(WidgetTester tester, {bool quoteArrives = true}) async {
    // Made inside the test, where its fake clock delivers it (setUp's would not).
    posts.quote = Completer<FCQuotePostResult>();
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      theme: ThemeData(platform: TargetPlatform.iOS),
      home: Builder(
        builder: (context) => Scaffold(
          body: Column(children: [
            Expanded(
              child: TextButton(
                onPressed: () => barKey.currentState!.openEditor((controller) async {
                  final result = await Navigator.of(context).push<dynamic>(FormPageRoute(
                    builder: (_) => ReplyPage(
                      siteContext: site,
                      threadId: '7',
                      topicTitle: 'T',
                      postId: '9',
                      isQuote: true,
                      contentController: controller,
                    ),
                  ));
                  return result != null && result != false;
                }),
                child: const Text('Reply on post 9'),
              ),
            ),
            QuickReplyBar(key: barKey, draftKey: draftKey, onSend: (_) async => true),
          ]),
        ),
      ),
    ));
    await tester.pumpAndSettle();
    await tester.showKeyboard(find.byType(TextField));
    await tester.enterText(find.byType(TextField), 'Mooi');
    await tester.pump();
    expect(keyboardUp(tester), isTrue);

    await tester.tap(find.text('Reply on post 9'));
    // The quote's spinner turns until it arrives: wait out the editor's
    // rise (400 ms) and its autofocus (100 ms) instead of settling.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    if (quoteArrives) {
      posts.quote.complete(FCQuotePostResult(result: true, resultText: '', quoteContent: _quote));
      await tester.pumpAndSettle();
    }
  }

  Future<void> tapClose(WidgetTester tester) async {
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();
  }

  testWidgets('✕ asks: Discard, Save draft or Cancel', (tester) async {
    await replyOnPost(tester);
    await tapClose(tester);
    expect(find.text('Do you want to discard your post?'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Save draft'), findsOneWidget);
    expect(find.text('Discard'), findsOneWidget);

    // Cancel: still writing, nothing lost.
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.byType(ReplyPage), findsOneWidget);
    expect(tester.widget<TextField>(editorField().last).controller!.text, 'Mooi\n\n$_quote\n');
  });

  testWidgets('Discard: the thread comes back with an empty bar, no draft and the keyboard down', (tester) async {
    await replyOnPost(tester);
    await tapClose(tester);
    await tester.tap(find.text('Discard'));
    await tester.pumpAndSettle();

    expect(find.byType(ReplyPage), findsNothing);
    expect(bar(tester).controller!.text, isEmpty);
    expect(bar(tester).focusNode!.hasFocus, isFalse);
    expect(keyboardUp(tester), isFalse);
    await tester.pump(const Duration(seconds: 3)); // the drafts' debounce
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString(draftKey), isNull);

    // The bar still works: a tap focuses it again.
    await tester.tap(find.byType(TextField));
    await tester.pump();
    expect(bar(tester).focusNode!.hasFocus, isTrue);
  });

  testWidgets('Save draft: the text is back in the bar and kept, with the keyboard down', (tester) async {
    await replyOnPost(tester);
    await tapClose(tester);
    await tester.tap(find.text('Save draft'));
    await tester.pumpAndSettle();

    expect(find.byType(ReplyPage), findsNothing);
    expect(bar(tester).controller!.text, 'Mooi\n\n$_quote\n');
    expect(bar(tester).focusNode!.hasFocus, isFalse);
    expect(keyboardUp(tester), isFalse);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString(draftKey), 'Mooi\n\n$_quote\n');
  });

  testWidgets('posting from the editor leaves the bar empty and the keyboard down', (tester) async {
    await replyOnPost(tester);
    await tester.tap(find.descendant(of: find.byType(ReplyPage), matching: find.byIcon(Icons.send_rounded)));
    await tester.pumpAndSettle();

    expect(find.byType(ReplyPage), findsNothing);
    expect(bar(tester).controller!.text, isEmpty);
    expect(bar(tester).focusNode!.hasFocus, isFalse);
    expect(keyboardUp(tester), isFalse);
  });

  testWidgets('an editor with nothing in it closes at once', (tester) async {
    await replyOnPost(tester);
    await tester.enterText(editorField().last, '');
    await tester.pump();
    await tapClose(tester);
    expect(find.byType(AlertDialog), findsNothing);
    expect(find.byType(ReplyPage), findsNothing);
    expect(keyboardUp(tester), isFalse);
  });

  testWidgets('the editor keeps its field (and the keyboard) when the quote arrives', (tester) async {
    await replyOnPost(tester, quoteArrives: false);
    final before = tester.widget<TextField>(editorField().last).focusNode;
    expect(before!.hasFocus, isTrue);
    final shown = tester.testTextInput.log.where((c) => c.method == 'TextInput.show').length;

    posts.quote.complete(FCQuotePostResult(result: true, resultText: '', quoteContent: _quote));
    await tester.pumpAndSettle();

    final after = tester.widget<TextField>(editorField().last).focusNode;
    expect(identical(before, after), isTrue);
    expect(after!.hasFocus, isTrue);
    expect(tester.testTextInput.log.where((c) => c.method == 'TextInput.show').length, shown);
    expect(tester.widget<TextField>(editorField().last).controller!.text, 'Mooi\n\n$_quote\n');
  });
}
