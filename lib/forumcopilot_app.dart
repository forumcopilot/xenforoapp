import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/generated/app_localizations.dart';
import 'package:forumcopilot_flutter/utils/error_dialog.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';
import 'package:get/get.dart';
import 'package:forumcopilot_flutter/controllers/site_controller.dart';
import 'package:forumcopilot_flutter/controllers/global_loader_controller.dart';
import 'package:forumcopilot_flutter/theme/app_theme.dart';
import 'package:forumcopilot_flutter/views/single_forum_bootstrap_page.dart';
import 'package:forumcopilot_flutter/views/widgets/user_state_banner.dart';
import 'package:forumcopilot_flutter/settings_context.dart';

void setupErrorHandling() {
  FlutterError.onError = (FlutterErrorDetails details) async {
    // Ignore known Flutter Windows keyboard assertion error
    // This is a known issue in Flutter on Windows and doesn't affect functionality
    if (details.exception is AssertionError && details.exception.toString().contains('KeyDownEvent') && details.exception.toString().contains('physical key is already pressed')) {
      // This is a known Flutter Windows bug, ignore it
      return;
    }

    FlutterError.presentError(details);
    final context = globalNavigatorKey.currentContext;
    if (context != null) {
      await handleAppError(context, details.exception, details.stack);
    }
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    final context = globalNavigatorKey.currentContext;
    if (context != null) {
      handleAppError(context, error, stack);
    }
    return true;
  };
}

Future<void> handleAppError(BuildContext context, Object error, [StackTrace? stack]) async {
  // Only show error dialog in debug mode
  if (kDebugMode) {
    showErrorDialog(error.toString());
  }
}

class ForumCopilotApp extends StatefulWidget {
  const ForumCopilotApp({super.key});

  @override
  State<ForumCopilotApp> createState() => _ForumCopilotAppState();
}

class _ForumCopilotAppState extends State<ForumCopilotApp> {
  @override
  void initState() {
    super.initState();
    // Initialize controllers
    Get.put(GlobalLoaderController());
    setupErrorHandling();
    // Load settings including locale
    SettingsContext.instance.loadFromDevice();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(SiteController());

    return Obx(() {
      // Get locale from settings, or use null for system default
      final selectedLocale = SettingsContext.instance.locale.value;

      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: globalNavigatorKey,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: selectedLocale, // null = use system locale
        localeResolutionCallback: (locale, supportedLocales) {
          // If locale is null, return null to use system locale
          if (locale == null) {
            return null;
          }

          // Check if the exact locale is supported
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode) {
              // Return the supported locale even if not all delegates support it
              // Flutter will use fallbacks for unsupported delegates
              return supportedLocale;
            }
          }

          // Default to English if no match found
          return const Locale('en');
        },
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: AppTheme.themeMode.value,
        builder: (context, child) {
          return Column(
            children: [
              UserStateBanner(),
              Expanded(
                child: Stack(
                  children: [
                    child ?? const SizedBox.shrink(),
                    Obx(() {
                      return GlobalLoaderController.to.isLoading
                          ? Container(
                              color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            )
                          : const SizedBox.shrink();
                    }),
                  ],
                ),
              ),
            ],
          );
        },
        home: const SingleForumBootstrapPage(),
      );
    });
  }
}
