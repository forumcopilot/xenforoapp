import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:get/get.dart';

import '../controllers/login_controller.dart';
import '../utils/app_navigation.dart';
import '../views/login_page.dart';
import 'browser_login.dart';

/// Where every "Sign in" goes. A forum that offers website sign-in
/// (BrowserLogin, add-on 1.9.0 and later) signs members in on its own
/// website, in the browser sheet, straight away: no page of the app's first
/// and no password form. The sheet has every way the member signs in there,
/// the browser's saved passwords, and the forum's own forgot-password page.
/// Forums with an older add-on, platforms without the sheet, and a phone
/// where the sheet won't open get the app's own sign-in page (LoginPage).
class SignIn {
  SignIn._();

  /// The website sign-in under way, so a second tap doesn't open a second
  /// sheet over it.
  static Future<BrowserLoginOutcome>? _onWebsite;

  /// Signs the member in to [siteContext]'s forum. True when signed in;
  /// false when they backed out or it failed (already said in a dialog).
  static Future<bool> start(SiteContext siteContext) async {
    if (BrowserLogin.isOffered(siteContext)) {
      final loginController = Get.isRegistered<LoginController>() ? Get.find<LoginController>() : Get.put(LoginController());
      final running = _onWebsite ??= loginController.browserLogin(siteContext: siteContext);
      final BrowserLoginOutcome outcome;
      try {
        outcome = await running;
      } finally {
        if (identical(_onWebsite, running)) _onWebsite = null;
      }
      if (outcome != BrowserLoginOutcome.unavailable) return outcome == BrowserLoginOutcome.signedIn;
    }
    return await AppNavigation.pushGlobal(LoginPage(siteContext: siteContext), name: '/LoginPage') == true;
  }
}
