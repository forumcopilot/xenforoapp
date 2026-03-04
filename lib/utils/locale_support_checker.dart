import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../l10n/generated/app_localizations.dart';

/// Utility class to check which localization delegates support which locales
class LocaleSupportChecker {
  /// Check if a locale is supported by a specific delegate
  static bool isLocaleSupportedByDelegate(
    Locale locale,
    String delegateName,
  ) {
    try {
      // Check support based on delegate name
      switch (delegateName) {
        case 'AppLocalizations':
          return AppLocalizations.delegate.isSupported(locale);
        case 'GlobalMaterialLocalizations':
          return GlobalMaterialLocalizations.delegate.isSupported(locale);
        case 'GlobalCupertinoLocalizations':
          return GlobalCupertinoLocalizations.delegate.isSupported(locale);
        case 'GlobalWidgetsLocalizations':
          return GlobalWidgetsLocalizations.delegate.isSupported(locale);
        default:
          return false;
      }
    } catch (e) {
      // If checking fails, assume not supported
      return false;
    }
  }

  /// Get a detailed report of which delegates support which locales
  static Map<String, Map<String, bool>> getSupportReport(
    List<Locale> locales,
  ) {
    final report = <String, Map<String, bool>>{};

    final delegates = {
      'AppLocalizations': AppLocalizations.delegate,
      'GlobalMaterialLocalizations': GlobalMaterialLocalizations.delegate,
      'GlobalCupertinoLocalizations': GlobalCupertinoLocalizations.delegate,
      'GlobalWidgetsLocalizations': GlobalWidgetsLocalizations.delegate,
    };

    for (final locale in locales) {
      final localeKey = locale.languageCode;
      report[localeKey] = {};

      for (final entry in delegates.entries) {
        final delegateName = entry.key;
        final isSupported = isLocaleSupportedByDelegate(locale, delegateName);
        report[localeKey]![delegateName] = isSupported;
      }
    }

    return report;
  }

  /// Get unsupported delegates for a specific locale
  static List<String> getUnsupportedDelegatesForLocale(Locale locale) {
    final unsupported = <String>[];
    
    final delegates = {
      'AppLocalizations': AppLocalizations.delegate,
      'GlobalMaterialLocalizations': GlobalMaterialLocalizations.delegate,
      'GlobalCupertinoLocalizations': GlobalCupertinoLocalizations.delegate,
      'GlobalWidgetsLocalizations': GlobalWidgetsLocalizations.delegate,
    };

    for (final entry in delegates.entries) {
      final delegateName = entry.key;
      final delegate = entry.value;
      if (!delegate.isSupported(locale)) {
        unsupported.add(delegateName);
      }
    }

    return unsupported;
  }

  /// Print a formatted report to console
  static void printSupportReport(List<Locale> locales) {
    final report = getSupportReport(locales);

    print('\n=== LOCALE SUPPORT REPORT ===\n');
    print('Locales checked: ${locales.map((l) => l.languageCode).join(", ")}\n');

    // Print header
    print('Locale | AppLocal | Material | Cupertino | Widgets');
    print('-------|----------|----------|-----------|--------');

    // Print each locale's support status
    for (final entry in report.entries) {
      final locale = entry.key;
      final supports = entry.value;

      final appLocal = supports['AppLocalizations'] == true ? '✓' : '✗';
      final material = supports['GlobalMaterialLocalizations'] == true ? '✓' : '✗';
      final cupertino = supports['GlobalCupertinoLocalizations'] == true ? '✓' : '✗';
      final widgets = supports['GlobalWidgetsLocalizations'] == true ? '✓' : '✗';

      print('$locale      |    $appLocal     |    $material     |     $cupertino      |   $widgets');
    }

    print('\n=== UNSUPPORTED LOCALES (Missing support in one or more delegates) ===\n');

    // Find locales not supported by all delegates
    for (final entry in report.entries) {
      final locale = entry.key;
      final supports = entry.value;

      final allSupported = supports.values.every((supported) => supported == true);
      if (!allSupported) {
        final unsupportedDelegates = getUnsupportedDelegatesForLocale(Locale(locale));
        print('Locale: $locale');
        print('  - AppLocalizations: ${supports['AppLocalizations'] == true ? "✓ Supported" : "✗ NOT SUPPORTED"}');
        print('  - GlobalMaterialLocalizations: ${supports['GlobalMaterialLocalizations'] == true ? "✓ Supported" : "✗ NOT SUPPORTED"}');
        print('  - GlobalCupertinoLocalizations: ${supports['GlobalCupertinoLocalizations'] == true ? "✓ Supported" : "✗ NOT SUPPORTED"}');
        print('  - GlobalWidgetsLocalizations: ${supports['GlobalWidgetsLocalizations'] == true ? "✓ Supported" : "✗ NOT SUPPORTED"}');
        print('  → Unsupported delegates: ${unsupportedDelegates.isEmpty ? "None" : unsupportedDelegates.join(", ")}');
        print('');
      }
    }

    print('\n=== WHAT HAPPENS WHEN A DELEGATE DOES NOT SUPPORT A LOCALE ===\n');
    print('1. Flutter shows a WARNING in the console (non-fatal)');
    print('2. The unsupported delegate falls back to English (or system default)');
    print('3. Your custom AppLocalizations still work correctly (if supported)');
    print('4. Material/Cupertino widgets may show English text');
    print('5. The app continues to function normally\n');
  }

  /// Print detailed information for a specific locale
  static void printLocaleDetails(Locale locale) {
    print('\n=== DETAILED LOCALE SUPPORT: ${locale.languageCode} ===\n');
    
    final unsupported = getUnsupportedDelegatesForLocale(locale);
    
    print('Locale: ${locale.languageCode}');
    print('');
    print('Delegate Support:');
    print('  - AppLocalizations: ${isLocaleSupportedByDelegate(locale, 'AppLocalizations') ? "✓ Supported" : "✗ NOT SUPPORTED"}');
    print('  - GlobalMaterialLocalizations: ${isLocaleSupportedByDelegate(locale, 'GlobalMaterialLocalizations') ? "✓ Supported" : "✗ NOT SUPPORTED"}');
    print('  - GlobalCupertinoLocalizations: ${isLocaleSupportedByDelegate(locale, 'GlobalCupertinoLocalizations') ? "✓ Supported" : "✗ NOT SUPPORTED"}');
    print('  - GlobalWidgetsLocalizations: ${isLocaleSupportedByDelegate(locale, 'GlobalWidgetsLocalizations') ? "✓ Supported" : "✗ NOT SUPPORTED"}');
    print('');
    
    if (unsupported.isNotEmpty) {
      print('⚠️  WARNING: The following delegates do NOT support this locale:');
      for (final delegate in unsupported) {
        print('     - $delegate');
      }
      print('');
      print('This will cause Flutter to show a warning and fallback to English for these delegates.');
    } else {
      print('✓ All delegates support this locale!');
    }
    print('');
  }
}
