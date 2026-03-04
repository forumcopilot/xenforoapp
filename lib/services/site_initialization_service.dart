import 'dart:async';
import 'package:forumcopilot_flutter/controllers/site_controller.dart';
import 'package:forumcopilot_flutter/controllers/login_controller.dart';
import 'package:forumcopilot_flutter/services/site_proxy_service.dart';
import 'package:forumcopilot_flutter/views/login_page.dart';
import 'package:forumcopilot_flutter/core/async/async_utils.dart';
import 'package:forumcopilot_flutter/core/logging/app_logger.dart';
import 'package:forumcopilot_flutter/models/site_visit_history.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/models/domain/site.dart';
import 'package:forumcopilot_sdk/models/results/fc_config_result.dart';
import 'package:get/get.dart';
import 'package:xenforo_core/xenforo_core.dart';

/// Result of site initialization
class SiteInitializationResult {
  final SiteContext? siteContext;
  final bool success;
  final String? errorMessage;

  SiteInitializationResult({
    this.siteContext,
    required this.success,
    this.errorMessage,
  });
}

/// Callback for progress updates during initialization
typedef ProgressCallback = void Function(String message);

/// Function to localize message keys
typedef LocalizeFunction = String Function(String key, [String? fallback]);

/// Centralized service for site initialization with progress tracking
class SiteInitializationService {
  /// Initialize a site with progress callbacks
  /// Returns SiteInitializationResult with success status and context or error
  static Future<SiteInitializationResult> initializeSite(
    Site site, {
    required ProgressCallback onProgress,
    LocalizeFunction? localize,
  }) async {
    try {
      AppLogger.info('SiteInitializationService: Starting initialization for ${site.name}');

      // Get domain name for progress message
      final domainName = Uri.tryParse(site.url)?.host ?? site.url;
      onProgress('Connecting to $domainName...');

      // Get SiteController
      if (!Get.isRegistered<SiteController>()) {
        throw Exception('SiteController not available');
      }
      final siteController = Get.find<SiteController>();

      // Create SiteContext
      final siteContext = SiteContext(siteType: site.siteType, site: site);

      SiteProxyService.initialize(siteContext);

      // Step 1: Get config with 10-second timeout
      // This MUST succeed - if it fails, we cannot proceed
      AppLogger.info('Fetching forum configuration...');
      var configProxy = SiteProxyService.getConfigProxy();
      FCConfigResult? configData;
      try {
        configData = await AsyncUtils.withTimeout(
          () => configProxy.getConfig(site.pluginUrl, forceRefresh: true),
          timeout: const Duration(seconds: 10),
          operationName: 'getConfig',
        );
        AppLogger.info('Forum configuration retrieved successfully');
      } on TimeoutException {
        AppLogger.error('getConfig timed out after 10 seconds');
        throw Exception('Failed to connect to forum: Connection timed out. Please check your internet connection and try again.');
      } catch (e) {
        AppLogger.error('Failed to get forum configuration: $e');
        throw Exception('Failed to connect to forum: Unable to retrieve configuration. Please check if the forum plugin is installed and the server is running.');
      }

      // CRITICAL: Verify configData was successfully retrieved
      if (configData == null) {
        AppLogger.error('getConfig returned null - this should never happen');
        throw Exception('Failed to connect to forum: Invalid configuration received (null).');
      }

      // Verify config data is valid
      if (configData.version.isEmpty && configData.systemVersion.isEmpty) {
        AppLogger.error('getConfig returned invalid config: version and systemVersion are both empty');
        throw Exception('Failed to connect to forum: Invalid configuration received.');
      }

      // Load or create site context
      var deviceSiteContext = await SiteContext.loadFromDevice(site.pluginUrl);
      if (deviceSiteContext != null) {
        AppLogger.info('Existing context loaded from device');
        deviceSiteContext.configDataOutput = configData;
        siteContext.configDataOutput = configData;
        // Copy other properties from device context
        siteContext.loginDataOutput = deviceSiteContext.loginDataOutput;
        siteContext.username = deviceSiteContext.username;
        siteContext.password = deviceSiteContext.password;
      } else {
        AppLogger.info('Creating new site context');
        siteContext.configDataOutput = configData;
      }

      // Verify that the plugin URL is properly set after initialization
      final pluginUrl = siteContext.site.pluginUrl;
      if (pluginUrl.isEmpty) {
        throw Exception('Plugin URL is empty after configuration - forum plugin may not be installed');
      }
      AppLogger.debug('Plugin URL set to: $pluginUrl');

      // Set currentSite BEFORE attempting login so attemptAutomaticLogin can access credentials
      siteController.currentSite.value = site;
      AppLogger.debug('🔍 [INIT_SERVICE] Set currentSite.value to: ${site.name} (ID: ${site.id})');

      // Step 2: Load credentials from SiteVisitTracker if not already in siteContext
      AppLogger.debug(
          '🔍 [INIT_SERVICE] Checking credentials in siteContext: username=${siteContext.username != null ? "[PRESENT]" : "[NULL]"}, password=${siteContext.password != null ? "[PRESENT]" : "[NULL]"}, loginDataOutput=${siteContext.loginDataOutput != null ? "[PRESENT]" : "[NULL]"}');

      if (siteContext.username == null || siteContext.password == null || siteContext.username!.isEmpty || siteContext.password!.isEmpty) {
        AppLogger.debug('🔍 [INIT_SERVICE] Credentials not in siteContext, loading from SiteVisitTracker...');
        try {
          final credentials = await SiteVisitTracker.instance.getCredentials(site);
          if (credentials != null && credentials['username'] != null && credentials['password'] != null) {
            siteContext.username = credentials['username'];
            siteContext.password = credentials['password'];
            AppLogger.debug('🔍 [INIT_SERVICE] ✅ Loaded credentials from SiteVisitTracker for user: ${siteContext.username}');
          } else {
            AppLogger.debug('🔍 [INIT_SERVICE] ❌ No credentials found in SiteVisitTracker for site: ${site.name} (ID: ${site.id})');
          }
        } catch (e) {
          AppLogger.debug('🔍 [INIT_SERVICE] ❌ Error loading credentials from SiteVisitTracker: $e');
        }
      } else {
        AppLogger.debug('🔍 [INIT_SERVICE] ✅ Credentials already present in siteContext');
      }

      // Step 3: Attempt automatic login if credentials are available
      final hasCredentials =
          (siteContext.username != null && siteContext.password != null && siteContext.username!.isNotEmpty && siteContext.password!.isNotEmpty) || siteContext.isLoginInformationAvailable;

      AppLogger.debug('🔍 [INIT_SERVICE] Login decision: hasCredentials=$hasCredentials, isLoginInformationAvailable=${siteContext.isLoginInformationAvailable}');

      if (hasCredentials) {
        AppLogger.info('🔍 [INIT_SERVICE] Attempting automatic login...');
        onProgress(localize?.call('loggingIn', 'Logging in...') ?? 'Logging in...');

        if (!Get.isRegistered<LoginController>()) {
          Get.put(LoginController());
        }
        final loginController = Get.find<LoginController>();
        final loginResult = await loginController.attemptAutomaticLogin(siteContext);

        if (loginResult.success) {
          AppLogger.info('🔍 [INIT_SERVICE] ✅ Automatic login successful');
        } else {
          AppLogger.info('🔍 [INIT_SERVICE] ❌ Automatic login failed: ${loginResult.errorMessage ?? "unknown error"}, hadCredentials=${loginResult.hadCredentials}');
          if (loginResult.hadCredentials && Get.currentRoute != '/LoginPage') {
            await Get.to(() => LoginPage(siteContext: siteContext));
          }
        }
      } else {
        AppLogger.info('🔍 [INIT_SERVICE] ⏭️  No credentials available - continuing with guest access');
      }

      // FINAL VALIDATION: Ensure configData is still valid before proceeding
      if (siteContext.configDataOutput == null) {
        AppLogger.error('CRITICAL: configDataOutput is null before completion - aborting');
        throw Exception('Failed to connect to forum: Configuration data is missing.');
      }
      if (siteContext.configDataOutput!.version.isEmpty && siteContext.configDataOutput!.systemVersion.isEmpty) {
        AppLogger.error('CRITICAL: configDataOutput is invalid before completion - aborting');
        throw Exception('Failed to connect to forum: Invalid configuration data.');
      }

      siteContext.updateLoginState();
      siteController.isInitialized.value = true;
      siteController.currentSiteContext.value = siteContext;
      siteController.attachReloginHandler(siteContext);

      // Record this visit in the history
      AppLogger.debug('Recording visit for site: ${site.name}');
      await SiteVisitTracker.instance.recordVisit(site);
      AppLogger.debug('Visit recorded successfully');

      AppLogger.info('SiteInitializationService: Site initialization completed successfully for ${site.name}');

      return SiteInitializationResult(
        siteContext: siteContext,
        success: true,
      );
    } catch (e) {
      AppLogger.error('SiteInitializationService: Error initializing site ${site.name}: $e');
      return SiteInitializationResult(
        success: false,
        errorMessage: e.toString(),
      );
    }
  }
}
