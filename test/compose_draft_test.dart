import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forumcopilot_flutter/l10n/generated/app_localizations.dart';
import 'package:forumcopilot_flutter/views/widgets/message_compose_page.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/models/domain/site.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A direct-message reply keeps a local draft: typed text survives closing
/// the composer and comes back when it opens again.
void main() {
  const key = 'dm_reply_draft:test:42';
  final site = SiteContext(
    siteType: 'xenforo',
    site: Site(name: 'Test Forum', url: 'https://forum.test', description: '', siteType: 'xenforo'),
  );

  Future<void> openComposer(WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('en'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: MessageComposePage(
        siteContext: site,
        title: 'Reply',
        showTitleField: false,
        draftKey: key,
        onSubmit: (_, __) async => true,
      ),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('typed text is saved and restored', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await openComposer(tester);
    await tester.enterText(find.byType(TextField).last, 'half a reply');
    await tester.pump(const Duration(seconds: 3)); // the 2 s debounce
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString(key), 'half a reply');

    await tester.pumpWidget(const SizedBox()); // closed
    await openComposer(tester);
    expect(find.text('half a reply'), findsOneWidget);
  });

  testWidgets('an untouched composer saves nothing', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await openComposer(tester);
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString(key), isNull);
  });
}
