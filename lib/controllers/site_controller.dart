import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:forumcopilot_flutter/controllers/login_controller.dart';
import 'package:forumcopilot_flutter/views/login_page.dart';
import 'package:forumcopilot_flutter/services/site_proxy_service.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/models/domain/site.dart';
import 'package:forumcopilot_sdk/models/results/fc_config_result.dart';
import 'package:get/get.dart';
import 'package:forumcopilot_flutter/settings_context.dart';
import 'package:forumcopilot_flutter/core/errors/error_handling_mixins.dart';
import 'package:forumcopilot_flutter/core/errors/app_exceptions.dart';
import 'package:forumcopilot_flutter/core/logging/app_logger.dart';
import 'package:forumcopilot_flutter/core/async/async_utils.dart';
import 'global_loader_controller.dart';
import '../models/site_visit_history.dart';

/// SiteController manages site initialization with timeout support
class SiteController extends GlobalLoaderController with ErrorHandlingMixin {
  // Observable state to track initialization
  var isInitialized = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;
  var currentSite = Rxn<Site>(); // Make currentSite reactive

  var currentSiteContext = Rxn<SiteContext>();

  // Timeout configuration (in seconds)
  static const int _defaultTimeoutSeconds = 30;

  // Stream subscriptions for cleanup
  StreamSubscription? _settingsSubscription;

  SiteController() {
    // Don't auto-initialize, wait for user to select a site
  }

  @override
  void onInit() {
    super.onInit();
    // Defer the initialization until after the build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp();
    });
  }

  Future<void> _initializeApp() async {
    GlobalLoaderController.to.show();
    try {
      // Initialize settings first - run in background to avoid blocking UI
      AppLogger.info('Initializing settings...');
      await AsyncUtils.withTimeout(
        () async => await SettingsContext.instance.loadFromDevice(),
        timeout: const Duration(seconds: 10),
        operationName: 'Settings initialization',
      );
      AppLogger.info('Settings initialized with theme: ${SettingsContext.instance.themeMode.value}');

      // Initialize with no site selected - user must choose from chooser
      AppLogger.info('App initialized - waiting for site selection');
      isInitialized.value = false;
    } catch (e, stackTrace) {
      await handleError(e, stackTrace, context: 'SiteController._initializeApp');
      // On error, reset to uninitialized state
      isInitialized.value = false;
    } finally {
      GlobalLoaderController.to.hide();
    }
  }

  Future<SiteContext?> initializeCurrentSite() async {
    if (currentSite.value != null) {
      await initializeSite(currentSite.value!);
    }
    return currentSiteContext.value;
  }

  Future<SiteContext?> initializeSite(Site site, {bool showGlobalLoader = true}) async {
    AppLogger.info('initializeSite called with site: ${site.name} (${site.url})');
    AppLogger.debug('currentSite: ${currentSite.value?.name} (${currentSite.value?.url})');
    AppLogger.debug('isInitialized: ${isInitialized.value}');

    // Validate site input
    if (site.url.isEmpty) {
      await handleError(
        ValidationException.invalidInput('site URL'),
        StackTrace.current,
        context: 'SiteController.initializeSite',
      );
      hasError.value = true;
      errorMessage.value = 'Invalid site: URL is empty';
      return null;
    }

    // Compare Site IDs to avoid false positives
    // Also check if the site is actually successfully initialized
    // Must have Site ID for matching
    bool shouldInitialize = currentSite.value == null || (site.id != null && currentSite.value!.id != site.id) || (site.id == null) || !isInitialized.value;
    AppLogger.debug('Should initialize: $shouldInitialize (current: ${currentSite.value?.id}, new: ${site.id}, isInitialized: ${isInitialized.value})');

    if (shouldInitialize) {
      AppLogger.info('Proceeding with site initialization...');
      if (showGlobalLoader) {
        GlobalLoaderController.to.show();
      }
      currentSite.value = site;
      AppLogger.debug('Setting currentSite: ${site.name}, backgroundUrl: ${site.backgroundUrl}, logoUrl: ${site.logoUrl}');
      // Clear any previous errors
      hasError.value = false;
      errorMessage.value = '';

      // Always set to false when switching sites to ensure proper initialization
      isInitialized.value = false;

      // Site initialization will navigate to the site home page

      try {
        // Wrap the initialization process with timeout
        final siteContext = await _initializeSiteWithTimeout(site);
        currentSiteContext.value = siteContext;
      } catch (e, stackTrace) {
        // Force hide loader completely - call hide multiple times to ensure counter reaches 0
        // This is necessary because show() might have been called multiple times
        if (showGlobalLoader && Get.isRegistered<GlobalLoaderController>()) {
          GlobalLoaderController.to.forceHide();
        }

        // Log error but don't show dialog (we'll show our custom dialog instead)
        await handleError(e, stackTrace, context: 'SiteController.initializeSite', showToUser: false);
        // Set error state
        hasError.value = true;
        errorMessage.value = 'Failed to connect to ${site.name}';

        // Clear currentSite on failure to allow retries
        currentSite.value = null;
        currentSiteContext.value = null;

        // Site initialization failed
        isInitialized.value = false;

        // Show error dialog to user with proper message
        // Extract user-friendly error message
        String userFriendlyMessage = e.toString();
        if (userFriendlyMessage.contains('Failed to connect to forum:')) {
          // Extract the message after the colon
          final parts = userFriendlyMessage.split(':');
          if (parts.length > 1) {
            userFriendlyMessage = parts.sublist(1).join(':').trim();
          }
        }
        _showErrorDialog(site, userFriendlyMessage);
      } finally {
        // Ensure loader is hidden (safe to call even if already hidden)
        if (showGlobalLoader && Get.isRegistered<GlobalLoaderController>()) {
          GlobalLoaderController.to.forceHide();
        }
      }
    } else {
      AppLogger.info('Site already initialized, skipping initialization...');
      AppLogger.warning('Automatic login will NOT be attempted because site initialization is skipped!');
      _attachReloginHandler(currentSiteContext.value!);

      // Even if site is already initialized, we should still attempt automatic login
      // because the user might have restarted the app and needs to re-authenticate
      AppLogger.info('Attempting automatic login even though site is already initialized...');
      await _attemptAutomaticLoginForInitializedSite(currentSiteContext.value!);

      // Site is already initialized, no need to change state
    }
    return currentSiteContext.value;
  }

  /// Attach the app-level relogin handler so proxy relogin uses attemptAutomaticLogin.
  /// Uses silentRelogin so we only try cookies + password (no passkey UI) when session expires.
  void attachReloginHandler(SiteContext siteContext) {
    siteContext.reloginHandler = (context) async {
      if (!Get.isRegistered<LoginController>()) {
        Get.put(LoginController());
      }
      final loginController = Get.find<LoginController>();
      final result = await loginController.attemptAutomaticLogin(
        context,
        silentRelogin: true,
      );
      return result.success;
    };
  }

  void _attachReloginHandler(SiteContext siteContext) => attachReloginHandler(siteContext);

  /// Initialize site with timeout
  Future<SiteContext> _initializeSiteWithTimeout(Site site) async {
    AppLogger.info('Starting initialization for ${site.name} with ${_defaultTimeoutSeconds}s timeout');

    try {
      // Production code with timeout
      final siteContext = await Future.any([
        _performSiteInitialization(site),
        Future.delayed(Duration(seconds: _defaultTimeoutSeconds)).then((_) {
          throw NetworkException.timeout();
        }),
      ]);
      return siteContext;
    } catch (e, stackTrace) {
      // Log error but don't show dialog (dialog will be shown by initializeSite catch block)
      await handleError(e, stackTrace, context: 'SiteController._initializeSiteWithTimeout', showToUser: false);
      rethrow;
    }
  }

  /// Perform the actual site initialization
  Future<SiteContext> _performSiteInitialization(Site site) async {
    AppLogger.info('Starting site initialization for ${site.name}');
    AppLogger.debug('Site URL: ${site.url}');

    // Validate site URL before proceeding
    if (site.url.isEmpty) {
      throw ValidationException.invalidInput('site URL');
    }

    // Then initialize site
    AppLogger.info('Initializing site...');
    final String initialSiteUrl = site.pluginUrl;

    AppLogger.debug('Loading site context from device...');
    SiteContext siteContext;
    var deviceSiteContext = await SiteContext.loadFromDevice(initialSiteUrl);

    // Get config - this must succeed before proceeding
    AppLogger.info('Fetching forum configuration...');
    var configProxy = SiteProxyService.getConfigProxy();
    FCConfigResult configData;
    try {
      configData = await configProxy.getConfig(initialSiteUrl, forceRefresh: true);
      AppLogger.info('Forum configuration retrieved successfully');
    } catch (e) {
      AppLogger.error('Failed to get forum configuration: $e');
      throw Exception('Failed to connect to forum: Unable to retrieve configuration. Please check if the forum plugin is installed and the server is running.');
    }

    // Verify config data is valid (configData should never be null if getConfig succeeded)
    // But ensure we have essential config fields
    if (configData.version.isEmpty && configData.systemVersion.isEmpty) {
      throw Exception('Failed to connect to forum: Invalid configuration received.');
    }

    if (deviceSiteContext != null) {
      AppLogger.info('Existing context loaded from device');
      deviceSiteContext.configDataOutput = configData;
      siteContext = deviceSiteContext;
    } else {
      AppLogger.info('Creating new site context');
      siteContext = new SiteContext(siteType: site.siteType, site: site);
      siteContext.configDataOutput = configData;
    }
    _attachReloginHandler(siteContext);

    // Verify that the plugin URL is properly set after initialization
    final pluginUrl = siteContext.site.pluginUrl;
    if (pluginUrl.isEmpty) {
      throw Exception('Plugin URL is empty after configuration - forum plugin may not be installed');
    }
    AppLogger.debug('Plugin URL set to: $pluginUrl');

    // Attempt automatic login if credentials are available
    AppLogger.debug('Setting up LoginController...');
    if (!Get.isRegistered<LoginController>()) {
      Get.put(LoginController());
    }

    AppLogger.info('Attempting automatic login...');
    AppLogger.debug('Current login state before auto-login: ${siteContext.isLoginInformationAvailable}');
    AppLogger.debug('Username before auto-login: ${siteContext.username}');
    AppLogger.debug('Password before auto-login: ${siteContext.password != null ? "[PRESENT]" : "[NULL]"}');

    final loginController = Get.find<LoginController>();
    final loginResult = await loginController.attemptAutomaticLogin(siteContext);

    if (loginResult.success) {
      AppLogger.info('Automatic login successful');
    } else {
      AppLogger.info('Automatic login failed or no credentials available');

      if (loginResult.hadCredentials) {
        if (Get.context != null) {
          AppLogger.info('Showing login screen after auto-login failure');
          await Get.to(() => LoginPage(siteContext: siteContext));
        } else {
          AppLogger.warning('No context available to show login screen after auto-login failure');
        }
      }
    }
    AppLogger.debug('Final login state after auto-login: ${siteContext.isLoginInformationAvailable}');

    siteContext.updateLoginState();
    isInitialized.value = true;

    AppLogger.debug('Recording visit for site: ${site.name}');
    AppLogger.debug('Site details - ID: ${site.id}, URL: ${site.url}');

    // Record this visit in the history
    await SiteVisitTracker.instance.recordVisit(site);
    AppLogger.debug('Visit recorded successfully');

    // Note: Site is automatically tracked in visit history, no need for separate My Forums tracking
    AppLogger.debug('Site visit tracking completed');

    AppLogger.info('Site initialization completed successfully');
    return siteContext;
  }

  /// Attempt automatic login for already initialized sites
  Future<void> _attemptAutomaticLoginForInitializedSite(SiteContext siteContext) async {
    try {
      AppLogger.info('Setting up controllers for automatic login...');

      if (!Get.isRegistered<LoginController>()) {
        Get.put(LoginController());
      }

      AppLogger.debug('Current login state before auto-login: ${siteContext.isLoginInformationAvailable}');
      AppLogger.debug('Username before auto-login: ${siteContext.username}');
      AppLogger.debug('Password before auto-login: ${siteContext.password != null ? "[PRESENT]" : "[NULL]"}');

      final loginController = Get.find<LoginController>();
      final loginResult = await loginController.attemptAutomaticLogin(siteContext);

      if (loginResult.success) {
        AppLogger.info('Automatic login successful for initialized site');
      } else {
        AppLogger.info('Automatic login failed for initialized site');
        if (loginResult.hadCredentials) {
          if (Get.context != null) {
            AppLogger.info('Showing login screen after auto-login failure (initialized site)');
            await Get.to(() => LoginPage(siteContext: siteContext));
          } else {
            AppLogger.warning('No context available to show login screen after auto-login failure (initialized site)');
          }
        }
      }
      AppLogger.debug('Final login state after auto-login: ${siteContext.isLoginInformationAvailable}');
    } catch (e, stackTrace) {
      await handleError(e, stackTrace, context: 'SiteController._attemptAutomaticLoginForInitializedSite');
    }
  }

  void _showErrorDialog(Site site, String error) {
    // Force hide any active loader before showing error dialog
    try {
      if (Get.isRegistered<GlobalLoaderController>()) {
        // Call hide multiple times to ensure counter reaches 0
        int hideAttempts = 0;
        const maxHideAttempts = 10; // Safety limit
        while (GlobalLoaderController.to.isLoading && hideAttempts < maxHideAttempts) {
          GlobalLoaderController.to.hide();
          hideAttempts++;
        }
      }
    } catch (e) {
      // Ignore if GlobalLoaderController is not available
    }

    final context = Get.context;
    if (context != null) {
      // Determine if this is a timeout error
      final isTimeoutError = error.toLowerCase().contains('timeout') || error.toLowerCase().contains('timed out');
      final title = isTimeoutError ? 'Connection Timeout' : 'Connection Failed';
      final message = isTimeoutError ? 'The connection to ${site.name} timed out. Please check your internet connection and try again.' : 'Failed to connect to ${site.name}';

      // For non-timeout errors, only show detailed error in debug mode to avoid exposing technical details
      final showDetailedError = kDebugMode && !isTimeoutError;

      // Defer dialog presentation to avoid Navigator lock assertion during transitions
      // and ensure loader is hidden before showing dialog
      // Use a small delay to ensure the loader overlay has time to disappear
      Future.delayed(const Duration(milliseconds: 100), () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted) return;

          // Double-check loader is still hidden
          if (Get.isRegistered<GlobalLoaderController>() && GlobalLoaderController.to.isLoading) {
            int hideAttempts = 0;
            const maxHideAttempts = 10; // Safety limit
            while (GlobalLoaderController.to.isLoading && hideAttempts < maxHideAttempts) {
              GlobalLoaderController.to.hide();
              hideAttempts++;
            }
            // Wait one more frame if loader was still showing
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!context.mounted) return;
              _showDialog(context, title, message, showDetailedError, error);
            });
          } else {
            _showDialog(context, title, message, showDetailedError, error);
          }
        });
      });
    }
  }

  void _showDialog(BuildContext context, String title, String message, bool showDetailedError, String error) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        final colorScheme = Theme.of(dialogContext).colorScheme;
        final textTheme = Theme.of(dialogContext).textTheme;

        return AlertDialog(
          backgroundColor: colorScheme.surface,
          title: Text(
            title,
            style: textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message,
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              if (showDetailedError) ...[
                const SizedBox(height: 8),
                Text(
                  error,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                'OK',
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Clears error state and resets to uninitialized state
  void clearErrorAndReset() {
    hasError.value = false;
    errorMessage.value = '';
    isInitialized.value = false;
    currentSite.value = null;
  }

  @override
  void onClose() {
    // Cleanup resources to prevent memory leaks
    _settingsSubscription?.cancel();
    _settingsSubscription = null;

    // Clear reactive variables
    isInitialized.value = false;
    hasError.value = false;
    errorMessage.value = '';
    currentSite.value = null;
    currentSiteContext.value = null;

    super.onClose();
  }
}
