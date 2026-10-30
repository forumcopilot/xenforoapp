import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forumcopilot_flutter/l10n/generated/app_localizations.dart';
import 'package:forumcopilot_flutter/services/site_proxy_service.dart';
import 'package:forumcopilot_flutter/views/widgets/forum_notices.dart';
import 'package:forumcopilot_flutter/views/widgets/forum_pages_section.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The forum's notices on Home and its own pages in Profile (XenForo add-on
/// 1.11.0+); older add-ons send none, and nothing shows.

class _Config implements IFCConfigProxy, IFCNoticeDismissal {
  final dismissed = <int>[];

  @override
  Future<bool> dismissNoticeAsync(int noticeId) async {
    dismissed.add(noticeId);
    return true;
  }

  @override
  dynamic noSuchMethod(Invocation i) => throw UnimplementedError('${i.memberName}');
}

class _Factory extends SiteProxyFactory {
  _Factory(this.config);
  final IFCConfigProxy config;

  @override
  IFCConfigProxy createConfigProxy(SiteContext context) => config;
  @override
  dynamic noSuchMethod(Invocation i) => throw UnimplementedError('${i.memberName}');
}

FCConfigResult _newAddOn() => FCConfigResult(
      notices: const [
        FCForumNotice(id: 3, title: 'Welcome', message: 'Read the rules first.', dismissible: true),
        FCForumNotice(id: 4, message: 'Maintenance on Sunday.'),
      ],
      tosUrl: 'https://forum.example.com/help/terms/',
      privacyPolicyUrl: 'https://forum.example.com/help/privacy-policy/',
      contactUrl: 'https://forum.example.com/misc/contact',
      helpPages: const [FCForumPage(title: 'Smilies', url: 'https://forum.example.com/help/smilies/')],
      policyAcceptance: const FCPolicyAcceptance(termsRequired: true, acceptUrl: 'https://forum.example.com/misc/accept-terms'),
    );

SiteContext _site(FCConfigResult config, {bool signedIn = true}) => SiteContext(
      siteType: 'xenforo',
      site: Site(id: 1, name: 'T', url: 'https://forum.example.com', description: '', endpoint: 'forumcopilot.php', baseUrl: 'https://forum.example.com', siteType: 'xenforo'),
      configDataOutput: config,
      loginDataOutput: signedIn ? FCLoginResult(result: true, resultText: '', user: FCUser(id: '2', username: 'alice')) : null,
    )..initializeAuth();

Future<_Config> _pump(WidgetTester tester, SiteContext site, Widget child) async {
  final config = _Config();
  SiteProxyService.initialize(site);
  SiteProxyFactory.register('xenforo', _Factory(config));
  await tester.pumpWidget(MaterialApp(
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: SingleChildScrollView(child: child)),
  ));
  return config;
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('notices on Home', () {
    testWidgets("a member sees the forum's notices and the updated terms, and closes one for good", (tester) async {
      final site = _site(_newAddOn());
      final config = await _pump(tester, site, ForumNotices(siteContext: site));

      expect(find.text('Welcome'), findsOneWidget);
      expect(find.text('Read the rules first.'), findsOneWidget);
      expect(find.text('Maintenance on Sunday.'), findsOneWidget);
      expect(find.text('Updated terms'), findsOneWidget);
      expect(find.text('Review'), findsOneWidget);
      expect(find.byTooltip('Close'), findsOneWidget, reason: 'only the dismissible notice');

      await tester.tap(find.byTooltip('Close'));
      await tester.pump();
      expect(find.text('Read the rules first.'), findsNothing);
      expect(config.dismissed, [3]);
    });

    testWidgets('a guest sees no terms card, and closing a notice stays on the phone', (tester) async {
      final site = _site(_newAddOn(), signedIn: false);
      final config = await _pump(tester, site, ForumNotices(siteContext: site));

      expect(find.text('Updated terms'), findsNothing);
      await tester.tap(find.byTooltip('Close'));
      await tester.pump();
      expect(find.text('Read the rules first.'), findsNothing);
      expect(config.dismissed, isEmpty);
    });

    testWidgets('a closed board says why', (tester) async {
      final site = _site(FCConfigResult(boardInactiveMessage: 'Back after the upgrade.'));
      await _pump(tester, site, ForumNotices(siteContext: site));
      expect(find.text('The forum is closed'), findsOneWidget);
      expect(find.text('Back after the upgrade.'), findsOneWidget);
    });

    testWidgets('an older add-on: nothing', (tester) async {
      final site = _site(FCConfigResult());
      await _pump(tester, site, ForumNotices(siteContext: site));
      expect(find.byType(Material), findsOneWidget, reason: "only the Scaffold's own");
    });
  });

  group("the forum's pages", () {
    testWidgets('listed under This forum', (tester) async {
      final site = _site(_newAddOn());
      await _pump(tester, site, ForumPagesSection(siteContext: site));
      expect(find.text('This forum'), findsOneWidget);
      for (final title in ['Terms and rules', 'Privacy Policy', 'Contact us', 'Smilies']) {
        expect(find.text(title), findsOneWidget, reason: title);
      }
    });

    testWidgets('as links for a guest, and not at all from an older add-on', (tester) async {
      final site = _site(_newAddOn(), signedIn: false);
      await _pump(tester, site, ForumPagesSection(siteContext: site, compact: true));
      expect(find.widgetWithText(TextButton, 'Terms and rules'), findsOneWidget);
      expect(find.text('This forum'), findsNothing);

      final old = _site(FCConfigResult());
      await _pump(tester, old, ForumPagesSection(siteContext: old));
      expect(find.text('This forum'), findsNothing);
    });
  });
}
