import 'package:flutter_test/flutter_test.dart';
import 'package:forumcopilot_flutter/services/browser_login.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/models/domain/site.dart';
import 'package:forumcopilot_sdk/models/results/fc_config_result.dart';

/// Signing in through the forum's website: the PKCE challenge, the page it
/// opens, and whether the forum offers it to this app.
void main() {
  test("the S256 challenge is RFC 7636's", () {
    // RFC 7636, appendix B.
    expect(BrowserLogin.challengeFor('dBjftJeZ4CVP-mB92K27uhbUJU1p1r_wW1gFWFOEjXk'),
        'E9Melhoa2OwvFrEMTJguCHaoeK1t8URWbuGJSstw-cM');
  });

  test("the forum's page, under its folder, with this app's scheme", () {
    final url = Uri.parse(BrowserLogin.signInUrl(Uri.parse('https://example.com/community/'),
        state: 'state-123456789012', challenge: 'E9Melhoa2OwvFrEMTJguCHaoeK1t8URWbuGJSstw-cM'));
    expect('${url.scheme}://${url.host}${url.path}', 'https://example.com/community/index.php');
    expect(url.query, startsWith('forumcopilot-app-login/&'));
    final params = Uri.splitQueryString(url.query.substring('forumcopilot-app-login/&'.length));
    expect(params, {
      'scheme': BrowserLogin.scheme,
      'state': 'state-123456789012',
      'challenge': 'E9Melhoa2OwvFrEMTJguCHaoeK1t8URWbuGJSstw-cM',
    });
  });

  test("signing up: the forum's register page, then the sign-in page", () {
    final signIn = BrowserLogin.signInUrl(Uri.parse('https://example.com/community/'),
        state: 'state-123456789012', challenge: 'E9Melhoa2OwvFrEMTJguCHaoeK1t8URWbuGJSstw-cM');
    final url = Uri.parse(BrowserLogin.signUpUrl(Uri.parse('https://example.com/community/'), then: signIn));
    expect('${url.scheme}://${url.host}${url.path}', 'https://example.com/community/index.php');
    expect(url.query, startsWith('register/&'));
    expect(Uri.splitQueryString(url.query.substring('register/&'.length)), {'_xfRedirect': signIn});

    // A forum whose add-on predates website sign-in: the page alone.
    expect(BrowserLogin.signUpUrl(Uri.parse('https://example.com/')), 'https://example.com/index.php?register/');
  });

  group('offered', () {
    SiteContext site(List<String>? schemes) => SiteContext(
          siteType: 'xenforo',
          site: const Site(name: 'A', url: 'https://a.example', description: '', siteType: 'xenforo'),
        )..configDataOutput = FCConfigResult(
            jsonSupport: true, systemVersion: '2.3', version: '1.9', hookVersion: '1', apiLevel: '4',
            releaseTimestamp: '0', pushSlug: 'xenforo', smartBannerInfo: '', browserLoginSchemes: schemes);

    tearDown(() => BrowserLogin.debugHasSystemSheet = null);

    test('only where the forum lists this app', () {
      BrowserLogin.debugHasSystemSheet = true;
      expect(BrowserLogin.isOffered(site([BrowserLogin.scheme])), isTrue);
      expect(BrowserLogin.isOffered(site(['someotherapp'])), isFalse);
      expect(BrowserLogin.isOffered(site([])), isFalse);
      // Add-ons before 1.9.0 send no list: the app's own sign-in.
      expect(BrowserLogin.isOffered(site(null)), isFalse);
    });

    test('not where the sheet cannot come back to the app (Windows, Linux, web)', () {
      BrowserLogin.debugHasSystemSheet = false;
      expect(BrowserLogin.isOffered(site([BrowserLogin.scheme])), isFalse);
    });
  });
}
