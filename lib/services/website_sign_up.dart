import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:get/get.dart';

import '../controllers/global_loader_controller.dart';
import '../controllers/login_controller.dart';
import '../core/logging/app_logger.dart';
import '../l10n/generated/app_localizations.dart';
import '../utils/forum_links.dart';
import '../views/site_home_page.dart';
import 'browser_login.dart';
import 'sign_in.dart';
import 'site_proxy_service.dart';

/// Signing up happens on the forum's own register page, in the system
/// browser sheet. That page has everything the forum asks for: every kind of
/// profile field, its captcha, its terms, Google and Facebook, and whatever
/// its add-ons add. The app's own form could not keep up with it
/// (docs/development/REGISTRATION_REVIEW.md).
///
/// Where the forum offers website sign-in (add-on 1.9.0 and later), the new
/// account comes back to the app as a website sign-in: at once where the
/// forum hands it on, otherwise after the member taps Continue, which is one
/// tap since the browser is now signed in. Forums with an older add-on have
/// no way back to the app, so the member then signs in with the user name
/// and password they chose.
class WebsiteSignUp {
  WebsiteSignUp._();

  static Future<void> start(BuildContext context, SiteContext siteContext) async {
    final closed = await _registrationClosed();
    if (!context.mounted) return;
    if (closed) {
      await _showClosed(context);
      return;
    }

    final loginController =
        Get.isRegistered<LoginController>() ? Get.find<LoginController>() : Get.put(LoginController());
    if (BrowserLogin.isOffered(siteContext)) {
      var outcome = await loginController.browserLogin(siteContext: siteContext, signUp: true);
      if (outcome == BrowserLoginOutcome.closed && context.mounted) {
        final l10n = AppLocalizations.of(context);
        if (await _askFinished(context, l10n.signUpFinishedContinue, l10n.continueButton)) {
          outcome = await loginController.browserLogin(siteContext: siteContext);
        }
      }
      if (outcome == BrowserLoginOutcome.signedIn) Get.offAll(() => const SiteHomePage());
      // Where the sheet won't open, the register page opens in the browser.
      if (outcome != BrowserLoginOutcome.unavailable) return;
    }

    final root = ForumLinks.rootOf(siteContext.site);
    if (root == null) return;
    await BrowserLogin.openPage(BrowserLogin.signUpUrl(root));
    if (!context.mounted) return;
    final l10n = AppLocalizations.of(context);
    if (await _askFinished(context, l10n.signUpFinishedSignIn, l10n.loginButton)) {
      SignIn.start(siteContext);
    }
  }

  /// Whether the forum says registration is closed. The add-on has said so
  /// since its first release (1.2.1); when it can't be asked, the register
  /// page opens and the forum says it there.
  static Future<bool> _registrationClosed() async {
    final loader = Get.isRegistered<GlobalLoaderController>() ? GlobalLoaderController.to : null;
    loader?.show();
    try {
      final prefetch = await SiteProxyService.getAccountProxy().prefetchAccount();
      return prefetch != null && prefetch.result == true && !prefetch.registrationOpen;
    } catch (e) {
      AppLogger.debug('[WebsiteSignUp] prefetchAccount failed: $e');
      return false;
    } finally {
      loader?.hide();
    }
  }

  /// "Created your account?" with [message], and [action] to go on.
  static Future<bool> _askFinished(BuildContext context, String message, String action) async {
    final l10n = AppLocalizations.of(context);
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.signUpFinishedTitle),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.notNow),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(action),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  static Future<void> _showClosed(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.registrationNotAvailable),
        content: Text(l10n.registrationNotAvailableMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.okButton),
          ),
        ],
      ),
    );
  }
}
