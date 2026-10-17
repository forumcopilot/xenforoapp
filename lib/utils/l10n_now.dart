import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../l10n/generated/app_localizations.dart';

/// The app's strings for code with no BuildContext at hand (controllers,
/// services, utils). Uses the app's Localizations while the app is on screen,
/// so a language picked in App Settings applies; otherwise looks up the
/// current locale, in English when the app has no translation for it.
AppLocalizations l10nNow() {
  BuildContext? context;
  try {
    context = Get.context;
  } catch (_) {
    // No Flutter binding yet: a background isolate, or a plain test.
  }
  if (context != null) {
    final l10n = Localizations.of<AppLocalizations>(context, AppLocalizations);
    if (l10n != null) return l10n;
  }
  final locale = Get.locale ?? PlatformDispatcher.instance.locale;
  try {
    return lookupAppLocalizations(locale);
  } catch (_) {
    return lookupAppLocalizations(const Locale('en'));
  }
}
