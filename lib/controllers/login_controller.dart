import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forumcopilot_flutter/services/site_proxy_service.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/network/fc_api_exception.dart';
import 'package:get/get.dart';
import 'package:forumcopilot_flutter/models/site_visit_history.dart';
import 'package:forumcopilot_flutter/controllers/site_controller.dart';
import 'package:forumcopilot_flutter/controllers/global_loader_controller.dart';
import 'package:forumcopilot_flutter/controllers/push_notification_controller.dart';
import 'package:forumcopilot_flutter/views/dialogs/tfa_input_dialog.dart';
import 'package:forumcopilot_sdk/models/domain/site.dart';
import 'package:forumcopilot_sdk/models/results/fc_user_result.dart';
import 'package:forumcopilot_sdk/interfaces/i_fc_user_proxy.dart';
import 'package:passkeys/authenticator.dart';
import 'package:passkeys/exceptions.dart';
import 'package:passkeys/types.dart';
import 'package:forumcopilot_flutter/core/errors/error_handling_mixins.dart';
import 'package:forumcopilot_flutter/core/errors/app_exceptions.dart';
import 'package:forumcopilot_flutter/core/logging/app_logger.dart';
import 'package:forumcopilot_sdk/services/fc_http_overrides.dart';
import 'package:forumcopilot_flutter/utils/passkey_platform_stub.dart'
    if (dart.library.io) 'package:forumcopilot_flutter/utils/passkey_platform_io.dart'
    as _passkey_platform;

/// Stable reason codes for push/login diagnostics.
abstract class PushLoginReasonCode {
  static const String sessionValid = 'session_valid';
  static const String noCookies = 'no_cookies';
  static const String cookiesInvalidSession = 'cookies_invalid_session';
  static const String noCredentials = 'no_credentials';
  static const String tfaRequired = 'tfa_required';
  static const String apiAuthInvalid = 'api_401_403';
  static const String transientError = 'transient_error';
  static const String loginOk = 'login_ok';
}

/// Result of automatic login attempt
class AutoLoginResult {
  final bool success;
  final String? errorMessage;
  final bool hadCredentials; // Whether credentials were attempted
  /// Stable reason code for diagnostics (e.g. no_cookies, tfa_required).
  final String reasonCode;

  AutoLoginResult({
    required this.success,
    this.errorMessage,
    required this.hadCredentials,
    required this.reasonCode,
  });
}

class LoginController extends GetxController with ErrorHandlingMixin {
  static LoginController get to => Get.find();

  /// True on iOS/Android where passkey APIs are available; false on web/desktop.
  static bool get isPasskeySupportedByPlatform =>
      _passkey_platform.isPasskeySupportedByPlatform;
  static bool get isIOSPlatform => _passkey_platform.isIOSPlatform;
  static bool get isAndroidPlatform => _passkey_platform.isAndroidPlatform;

  void _showLoginFailureSnackbar(String message) {
    Future.microtask(() {
      final context = Get.context;
      if (context != null && context.mounted) {
        Get.snackbar(
          'Login result',
          message,
          backgroundColor: Get.theme.colorScheme.primaryContainer,
          colorText: Get.theme.colorScheme.onPrimaryContainer,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(12),
          borderRadius: 8,
        );
      }
    });
  }

  /// Handles login process for both login page and profile tab
  /// Returns true if login was successful, false otherwise
  Future<bool> handleLogin({
    required SiteContext siteContext,
    required String username,
    required String password,
    bool showLoader = true,
    bool showSuccessMessage = false,
  }) async {
    if (showLoader) {
      GlobalLoaderController.to.show();
    }

    try {
      // Validate input
      if (username.trim().isEmpty) {
        throw ValidationException.requiredField('username');
      }
      if (password.trim().isEmpty) {
        throw ValidationException.requiredField('password');
      }

      final userProxy = SiteProxyService.getUserProxy();

      final loginResult = await userProxy.loginAsync(
        username.trim(),
        password,
        false, // not anonymous
        null, // no trust code
        remember: true,
      );
      final loginResultMessage =
          loginResult.resultText?.trim().isNotEmpty == true
              ? loginResult.resultText!
              : (loginResult.result ? 'Login succeeded' : 'Login failed');
      if (!loginResult.result) {
        _showLoginFailureSnackbar(loginResultMessage);
      }

      // Check if 2FA is required
      if (loginResult.tfaRequired == true) {
        // Hide loader before showing TFA dialog
        if (showLoader) {
          GlobalLoaderController.to.hide();
        }

        // Show TFA input dialog
        String? errorMessage;
        FCLoginResult? tfaLoginResult;

        while (tfaLoginResult == null ||
            (tfaLoginResult.result == false &&
                tfaLoginResult.tfaRequired == true)) {
          final tfaResult = await TFAInputDialog.show(
            providers: loginResult.providers,
            defaultProviderId: loginResult.providerId,
            errorMessage: errorMessage,
          );

          if (tfaResult == null) {
            // User cancelled TFA dialog
            return false;
          }

          // Show loader for TFA verification
          if (showLoader) {
            GlobalLoaderController.to.show();
          }

          try {
            if (tfaResult.usePasskey) {
              tfaLoginResult = await _loginWithPasskeyTfa(
                userProxy: userProxy,
                loginResult: loginResult,
                username: username.trim(),
                password: password,
              );
            } else {
              // Second login attempt with TFA code
              tfaLoginResult = await userProxy.loginAsync(
                username.trim(),
                password,
                false, // not anonymous
                null, // no trust code
                remember: true,
                tfaCode: tfaResult.code,
                tfaProvider: tfaResult.provider,
                trustDevice: true, // Always trust device when TFA is used
              );
            }
            final tfaResultMessage =
                tfaLoginResult.resultText?.trim().isNotEmpty == true
                    ? tfaLoginResult.resultText!
                    : (tfaLoginResult.result
                        ? 'Login succeeded'
                        : 'Login failed');
            if (!tfaLoginResult.result) {
              _showLoginFailureSnackbar(tfaResultMessage);
            }

            if (tfaLoginResult.result && tfaLoginResult.user != null) {
              // TFA verification successful, continue with normal success flow
              loginResult.user = tfaLoginResult.user;
              loginResult.result = true;
              loginResult.resultText = tfaLoginResult.resultText;
              loginResult.tfaRequired = false;
              // Copy other fields from successful TFA login
              loginResult.canWhosonline = tfaLoginResult.canWhosonline;
              loginResult.canProfile = tfaLoginResult.canProfile;
              loginResult.canUploadAvatar = tfaLoginResult.canUploadAvatar;
              loginResult.maxAttachment = tfaLoginResult.maxAttachment;
              loginResult.maxPngSize = tfaLoginResult.maxPngSize;
              loginResult.maxJpgSize = tfaLoginResult.maxJpgSize;
              loginResult.canUploadAttachment =
                  tfaLoginResult.canUploadAttachment;
              loginResult.canUploadConversationAttachment =
                  tfaLoginResult.canUploadConversationAttachment;
              loginResult.maxAttachmentSize = tfaLoginResult.maxAttachmentSize;
              loginResult.allowedFileExtensions =
                  tfaLoginResult.allowedFileExtensions;
              loginResult.maxImageWidth = tfaLoginResult.maxImageWidth;
              loginResult.maxImageHeight = tfaLoginResult.maxImageHeight;
              break; // Exit loop on success
            } else {
              // TFA verification failed, show error and allow retry
              errorMessage =
                  tfaLoginResult.resultText ?? 'Invalid authentication code';
              if (showLoader) {
                GlobalLoaderController.to.hide();
              }
              // Loop will continue to show dialog again with error message
            }
          } catch (e) {
            if (showLoader) {
              GlobalLoaderController.to.hide();
            }
            errorMessage =
                'An error occurred during verification. Please try again.';
            // Loop will continue to show dialog again with error message
          }
        }

        // If we reach here and still no success, return false
        // Note: tfaLoginResult cannot be null here due to loop condition, but check is kept for defensive programming
        // ignore: unnecessary_null_comparison
        if (tfaLoginResult == null || !tfaLoginResult.result) {
          return false;
        }
      }

      if (loginResult.result && loginResult.user != null) {
        // Update baseForumInfo with login data
        siteContext.loginDataOutput = loginResult;
        siteContext.lastSuccessfulLoginMethod = SiteContext.loginMethodPassword;

        // Save the updated baseForumInfo
        await siteContext.saveToDevice();

        // Record visit with credentials when login is successful
        await _recordVisitWithCredentials(username, password, siteContext);

        // Note: Site is automatically tracked in visit history with credentials

        // Update auth state - this will trigger the worker in site_home_page.dart
        siteContext.updateLoginState();

        // Show result_text as a popup dialog if not empty (e.g., warnings), otherwise show success toast
        // Hide loader before showing dialogs (forceHide in case show() was called more than hide())
        if (showLoader && Get.isRegistered<GlobalLoaderController>()) {
          GlobalLoaderController.to.forceHide();
        }

        // Register for push notifications asynchronously (don't await to avoid blocking navigation)
        // This happens after UI updates to prevent blocking the login page from closing
        // Toasts will be delayed to appear after login page closes
        Future.microtask(() async {
          AppLogger.debug(
              '🔔 [LOGIN] Attempting to register for push notifications...');
          final siteController = Get.find<SiteController>();
          if (siteController.currentSite.value != null) {
            AppLogger.debug(
                '🔔 [LOGIN] Current forum found: ${siteController.currentSite.value!.name}');
            await _registerForPushNotifications(
                siteController.currentSite.value!, loginResult);
          } else {
            AppLogger.debug(
                '🔔 [LOGIN] ❌ No current forum found, skipping push notification registration');
          }
        });

        if (loginResult.resultText != null &&
            loginResult.resultText!.trim().isNotEmpty) {
          await _showLoginInfoDialog(
              loginResult.resultText!, Get.theme.colorScheme);
        }

        return true;
      } else {
        // Handle login failure - hide loader first, then show API's resultText if available
        if (showLoader) {
          GlobalLoaderController.to.hide();
        }

        String errorMessage = 'Login failed';
        if (loginResult.resultText != null &&
            loginResult.resultText!.trim().isNotEmpty) {
          errorMessage = loginResult.resultText!;
        }
        await _showLoginErrorDialog(errorMessage, Get.theme.colorScheme);
        return false;
      }
    } on FCApiException catch (e) {
      if (showLoader) {
        GlobalLoaderController.to.hide();
      }
      await handleAuthError(e, context: 'LoginController.handleLogin');
      return false;
    } on ValidationException catch (e) {
      if (showLoader) {
        GlobalLoaderController.to.hide();
      }
      await handleAppException(e, context: 'LoginController.handleLogin');
      return false;
    } on AuthenticationException catch (e) {
      if (showLoader) {
        GlobalLoaderController.to.hide();
      }
      await handleAppException(e, context: 'LoginController.handleLogin');
      return false;
    } catch (e, stackTrace) {
      if (showLoader) {
        GlobalLoaderController.to.hide();
      }
      await handleError(e, stackTrace, context: 'LoginController.handleLogin');
      return false;
    } finally {
      // Hide loader if it's still showing (might have been hidden already in success/error handling)
      if (showLoader && GlobalLoaderController.to.isLoading) {
        GlobalLoaderController.to.hide();
      }
    }
  }

  /// Handles passkey-only login
  Future<bool> handlePasskeyLogin({
    required SiteContext siteContext,
    bool showLoader = true,
    bool showSuccessMessage = false,
  }) async {
    if (siteContext.siteType != 'xenforo') {
      throw PermissionException.featureNotAvailable('Passkeys');
    }

    if (showLoader) {
      GlobalLoaderController.to.show();
    }

    siteContext.passkeyLoginInProgress = true;
    try {
      final userProxy = SiteProxyService.getUserProxy();
      final challengeResult = await userProxy.getPasskeyChallengeAsync();

      if (!challengeResult.result ||
          challengeResult.challenge == null ||
          challengeResult.rpId == null) {
        if (showLoader) {
          GlobalLoaderController.to.hide();
        }
        final message = challengeResult.resultText?.trim().isNotEmpty == true
            ? challengeResult.resultText!
            : 'Passkey challenge could not be created';
        await _showLoginErrorDialog(message, Get.theme.colorScheme);
        return false;
      }

      final payload = await _authenticateWithPasskey(
        challenge: challengeResult.challenge!,
        rpId: challengeResult.rpId!,
        timeout: challengeResult.timeout,
      );

      final loginResult = await userProxy.loginWithPasskeyAsync(
        webauthnChallenge: challengeResult.challenge!,
        webauthnPayload: payload,
      );
      final loginResultMessage =
          loginResult.resultText?.trim().isNotEmpty == true
              ? loginResult.resultText!
              : (loginResult.result ? 'Login succeeded' : 'Login failed');
      if (!loginResult.result) {
        _showLoginFailureSnackbar(loginResultMessage);
      }

      if (loginResult.result && loginResult.user != null) {
        // Update baseForumInfo with login data
        siteContext.loginDataOutput = loginResult;
        siteContext.lastSuccessfulLoginMethod = SiteContext.loginMethodPasskey;
        if (loginResult.user!.username.trim().isNotEmpty) {
          siteContext.username = loginResult.user!.username;
        }

        // Save the updated baseForumInfo
        await siteContext.saveToDevice();

        // Record site as a My Forums entry for passkey-only accounts.
        await _recordVisitForPasskeyLogin(
          siteContext,
          username: loginResult.user!.username,
        );

        // Update auth state - this will trigger the worker in site_home_page.dart
        siteContext.updateLoginState();

        // Hide loader before showing dialogs
        if (showLoader) {
          GlobalLoaderController.to.hide();
        }

        // Register for push notifications asynchronously (don't await to avoid blocking navigation)
        Future.microtask(() async {
          AppLogger.debug(
              '🔔 [LOGIN] Attempting to register for push notifications (passkey)...');
          final siteController = Get.find<SiteController>();
          if (siteController.currentSite.value != null) {
            AppLogger.debug(
                '🔔 [LOGIN] Current forum found: ${siteController.currentSite.value!.name}');
            await _registerForPushNotifications(
                siteController.currentSite.value!, loginResult);
          } else {
            AppLogger.debug(
                '🔔 [LOGIN] ❌ No current forum found, skipping push notification registration');
          }
        });

        if (loginResult.resultText != null &&
            loginResult.resultText!.trim().isNotEmpty) {
          await _showLoginInfoDialog(
              loginResult.resultText!, Get.theme.colorScheme);
        }

        return true;
      } else {
        if (showLoader) {
          GlobalLoaderController.to.hide();
        }
        String errorMessage = 'Login failed';
        if (loginResult.resultText != null &&
            loginResult.resultText!.trim().isNotEmpty) {
          errorMessage = loginResult.resultText!;
        }
        await _showLoginErrorDialog(errorMessage, Get.theme.colorScheme);
        return false;
      }
    } on FCApiException catch (e) {
      if (showLoader) {
        GlobalLoaderController.to.hide();
      }
      await handleAuthError(e, context: 'LoginController.handlePasskeyLogin');
      return false;
    } on PermissionException catch (e) {
      if (showLoader) {
        GlobalLoaderController.to.hide();
      }
      await handleAppException(e,
          context: 'LoginController.handlePasskeyLogin');
      return false;
    } on AuthenticationException catch (e) {
      if (showLoader) {
        GlobalLoaderController.to.hide();
      }
      await handleAppException(e,
          context: 'LoginController.handlePasskeyLogin');
      return false;
    } on DomainNotAssociatedException catch (_) {
      if (showLoader) {
        GlobalLoaderController.to.hide();
      }
      await _showLoginErrorDialog(
        'This forum is not yet set up for passkey access on this app. Please sign in with your username and password.',
        Get.theme.colorScheme,
      );
      return false;
    } on NoCredentialsAvailableException catch (_) {
      if (showLoader) {
        GlobalLoaderController.to.hide();
      }
      await _showLoginErrorDialog(
        'No passkey found for this forum. Sign in with your password, or create a passkey on the forum website first.',
        Get.theme.colorScheme,
      );
      return false;
    } catch (e, stackTrace) {
      if (showLoader) {
        GlobalLoaderController.to.hide();
      }
      // iOS may report AASA/webcredentials failure as PlatformException with code "failed"
      if (e is PlatformException) {
        final msg = (e.message ?? '').toLowerCase();
        if (msg.contains('webcredentials') ||
            msg.contains('verify') && msg.contains('association')) {
          await _showLoginErrorDialog(
            'This forum is not yet set up for passkey access on this app. Please sign in with your username and password.',
            Get.theme.colorScheme,
          );
          return false;
        }
      }
      // Android reports domain/app association failure as "RP ID cannot be validated"
      // when assetlinks.json is missing or does not include this build's signing certificate
      final errStr = e.toString().toLowerCase();
      if (errStr.contains('rp id cannot be validated') ||
          errStr.contains('get_public_key_credential_dom_exception')) {
        await _showLoginErrorDialog(
          'This forum is not yet set up for passkey access on this app. Please sign in with your username and password.',
          Get.theme.colorScheme,
        );
        return false;
      }
      await handleError(e, stackTrace,
          context: 'LoginController.handlePasskeyLogin');
      return false;
    } finally {
      siteContext.passkeyLoginInProgress = false;
      if (showLoader && GlobalLoaderController.to.isLoading) {
        GlobalLoaderController.to.hide();
      }
    }
  }

  /// Attempts automatic login using saved credentials
  /// Returns AutoLoginResult with success status, error message (if failed), and whether credentials were attempted
  /// If credentials are invalid, removes them and demotes forum to guest access
  ///
  /// When [silentRelogin] is true (e.g. from proxy session-expired handler), only cookies and
  /// password are tried; passkey is never used so we don't show the system auth UI from background.
  Future<AutoLoginResult> attemptAutomaticLogin(
    SiteContext siteContext, {
    bool silentRelogin = false,
  }) async {
    try {
      // Step 1: Check if we have valid cookies and session first
      final pluginUrl = siteContext.site.pluginUrl;
      if (pluginUrl.isNotEmpty) {
        try {
          final uri = Uri.parse(pluginUrl);
          final initialCookieCount =
              await FCDioClient.instance.cookieCountForUrl(uri);
          AppLogger.debug(
              '🍪 [AUTO_LOGIN] Initial cookie count for ${uri.host}: $initialCookieCount');
          final hasCookies = await FCDioClient.instance.hasCookiesForUrl(uri);

          if (hasCookies) {
            AppLogger.debug(
                '🔐 [AUTO_LOGIN] Cookies found for domain, validating session...');

            // Make a network call to validate session using existing cookies.
            // forceRefresh: true is required so the proxy writes lastGetConfigFcIsLogin
            // onto the current SiteContext. With forceRefresh: false a cache hit can
            // return stale data from a previous SiteContext, leaving lastGetConfigFcIsLogin
            // null on the fresh context and causing the check below to silently fail.
            try {
              final configProxy = SiteProxyService.getConfigProxy();
              await configProxy.getConfig(pluginUrl, forceRefresh: true);

              // Prefer fc_is_login from this getConfig response. lastCallFcIsLogin reflects
              // the last API call on SiteContext and can race when other proxies run in parallel.
              final isLoggedIn =
                  siteContext.lastGetConfigFcIsLogin ?? siteContext.lastCallFcIsLogin;

              if (isLoggedIn) {
                AppLogger.info(
                    '🔐 [AUTO_LOGIN] ✅ Session is valid - already logged in via cookies');

                // Update login state from the header (this sets _isLoggedIn based on fc_is_login)
                siteContext.updateLoginStateFromHeader(isLoggedIn);

                // Session is valid via cookies, no need to login again
                // The loginDataOutput will be populated on the next API call that returns user data
                AppLogger.debug(
                    '🔐 [AUTO_LOGIN] Skipping login - using existing valid session');
                return AutoLoginResult(
                  success: true,
                  hadCredentials: false,
                  reasonCode: PushLoginReasonCode.sessionValid,
                );
              } else {
                AppLogger.debug(
                    '🔐 [AUTO_LOGIN] Cookies exist but session is not valid (fc_is_login=false)');
              }
            } catch (e) {
              // Network error (e.g. Cloudflare challenge) during session validation.
              // Do NOT fall through to password login: that would trigger a 2FA dialog
              // even though the user may have a perfectly valid session that just
              // couldn't be verified due to the transient network issue.
              AppLogger.warning(
                  '🔐 [AUTO_LOGIN] Network error validating session – aborting auto-login to avoid spurious 2FA: $e');
              return AutoLoginResult(
                success: false,
                hadCredentials: false,
                reasonCode: PushLoginReasonCode.transientError,
              );
            }
          } else {
            AppLogger.debug('🔐 [AUTO_LOGIN] No cookies found for domain');
          }
        } catch (e) {
          AppLogger.debug('🔐 [AUTO_LOGIN] Error checking cookies: $e');
          // Continue to login attempt below
        }
      }

      // Step 2: If no valid session, use the last successful login method.
      // When silentRelogin is true (proxy session-expired), skip passkey to avoid showing auth UI.
      final shouldUsePasskeyAutoLogin = !silentRelogin &&
          (siteContext.lastSuccessfulLoginMethod ==
                  SiteContext.loginMethodPasskey ||
              (siteContext.lastSuccessfulLoginMethod == null &&
                  siteContext.siteType == 'xenforo' &&
                  isPasskeySupportedByPlatform &&
                  (siteContext.password == null ||
                      siteContext.password!.isEmpty) &&
                  (siteContext.username?.isNotEmpty ?? false)));
      if (shouldUsePasskeyAutoLogin) {
        AppLogger.debug(
            '🔐 [AUTO_LOGIN] Using automatic passkey login based on previous auth state');
        return _attemptAutomaticPasskeyLogin(siteContext);
      }
      if (silentRelogin && siteContext.lastSuccessfulLoginMethod == SiteContext.loginMethodPasskey) {
        AppLogger.debug(
            '🔐 [AUTO_LOGIN] Silent relogin: skipping passkey, will try password if available');
      }

      // Step 3: If no valid session, attempt login with credentials
      // Check if we have stored credentials in SiteContext
      if (siteContext.username == null ||
          siteContext.password == null ||
          siteContext.username!.isEmpty ||
          siteContext.password!.isEmpty) {
        // Try to load credentials from SiteVisitTracker
        try {
          final siteController = Get.find<SiteController>();
          if (siteController.currentSite.value != null) {
            final credentials = await SiteVisitTracker.instance
                .getCredentials(siteController.currentSite.value!);
            if (credentials != null &&
                credentials['username'] != null &&
                credentials['password'] != null) {
              // Load credentials from SiteVisitTracker into SiteContext
              siteContext.username = credentials['username'];
              siteContext.password = credentials['password'];
              AppLogger.debug(
                  '🔐 [AUTO_LOGIN] Loaded credentials from SiteVisitTracker for user: ${siteContext.username}');
            } else {
              AppLogger.debug(
                  '🔐 [AUTO_LOGIN] No credentials found in SiteVisitTracker');
              siteContext.loginDataOutput = null;
              await siteContext.saveToDevice();
              siteContext.updateLoginState();
              return AutoLoginResult(
                success: false,
                hadCredentials: false,
                reasonCode: PushLoginReasonCode.noCredentials,
              );
            }
          } else {
            AppLogger.debug('🔐 [AUTO_LOGIN] No current site available');
            siteContext.loginDataOutput = null;
            await siteContext.saveToDevice();
            siteContext.updateLoginState();
            return AutoLoginResult(
              success: false,
              hadCredentials: false,
              reasonCode: PushLoginReasonCode.noCredentials,
            );
          }
        } catch (e) {
          AppLogger.debug(
              '🔐 [AUTO_LOGIN] Error loading credentials from SiteVisitTracker: $e');
          siteContext.loginDataOutput = null;
          await siteContext.saveToDevice();
          siteContext.updateLoginState();
          return AutoLoginResult(
            success: false,
            hadCredentials: false,
            reasonCode: PushLoginReasonCode.transientError,
          );
        }
      }

      AppLogger.debug('🔐 [AUTO_LOGIN] Attempting login with credentials...');
      final userProxy = SiteProxyService.getUserProxy();
      final loginResult = await userProxy.loginAsync(
        siteContext.username!,
        siteContext.password!,
        false, // not anonymous
        null, // no trust code
        remember: true,
      );
      final loginResultMessage =
          loginResult.resultText?.trim().isNotEmpty == true
              ? loginResult.resultText!
              : (loginResult.result ? 'Login succeeded' : 'Login failed');
      if (!loginResult.result) {
        _showLoginFailureSnackbar(loginResultMessage);
      }

      // Check if 2FA is required for auto-login
      if (loginResult.tfaRequired == true) {
        // Show TFA dialog for user to enter code
        String? errorMessage;
        FCLoginResult? tfaLoginResult;

        while (tfaLoginResult == null ||
            (tfaLoginResult.result == false &&
                tfaLoginResult.tfaRequired == true)) {
          if (Get.isRegistered<GlobalLoaderController>()) {
            GlobalLoaderController.to.forceHide();
          }
          final tfaResult = await TFAInputDialog.show(
            providers: loginResult.providers,
            defaultProviderId: loginResult.providerId,
            errorMessage: errorMessage,
          );

          if (tfaResult == null) {
            // User cancelled TFA dialog during auto-login
            return AutoLoginResult(
              success: false,
              errorMessage: 'TFA verification cancelled',
              hadCredentials: true,
              reasonCode: PushLoginReasonCode.tfaRequired,
            );
          }

          try {
            if (tfaResult.usePasskey) {
              tfaLoginResult = await _loginWithPasskeyTfa(
                userProxy: userProxy,
                loginResult: loginResult,
                username: siteContext.username!,
                password: siteContext.password!,
              );
            } else {
              // Second login attempt with TFA code
              tfaLoginResult = await userProxy.loginAsync(
                siteContext.username!,
                siteContext.password!,
                false, // not anonymous
                null, // no trust code
                remember: true,
                tfaCode: tfaResult.code,
                tfaProvider: tfaResult.provider,
                trustDevice: true, // Always trust device when TFA is used
              );
            }
            final tfaResultMessage =
                tfaLoginResult.resultText?.trim().isNotEmpty == true
                    ? tfaLoginResult.resultText!
                    : (tfaLoginResult.result
                        ? 'Login succeeded'
                        : 'Login failed');
            if (!tfaLoginResult.result) {
              _showLoginFailureSnackbar(tfaResultMessage);
            }

            if (tfaLoginResult.result && tfaLoginResult.user != null) {
              // TFA verification successful, continue with normal success flow
              loginResult.user = tfaLoginResult.user;
              loginResult.result = true;
              loginResult.resultText = tfaLoginResult.resultText;
              loginResult.tfaRequired = false;
              // Copy other fields from successful TFA login
              loginResult.canWhosonline = tfaLoginResult.canWhosonline;
              loginResult.canProfile = tfaLoginResult.canProfile;
              loginResult.canUploadAvatar = tfaLoginResult.canUploadAvatar;
              loginResult.maxAttachment = tfaLoginResult.maxAttachment;
              loginResult.maxPngSize = tfaLoginResult.maxPngSize;
              loginResult.maxJpgSize = tfaLoginResult.maxJpgSize;
              loginResult.canUploadAttachment =
                  tfaLoginResult.canUploadAttachment;
              loginResult.canUploadConversationAttachment =
                  tfaLoginResult.canUploadConversationAttachment;
              loginResult.maxAttachmentSize = tfaLoginResult.maxAttachmentSize;
              loginResult.allowedFileExtensions =
                  tfaLoginResult.allowedFileExtensions;
              loginResult.maxImageWidth = tfaLoginResult.maxImageWidth;
              loginResult.maxImageHeight = tfaLoginResult.maxImageHeight;
              break; // Exit loop on success
            } else {
              // TFA verification failed, show error and allow retry
              errorMessage =
                  tfaLoginResult.resultText ?? 'Invalid authentication code';
              // Loop will continue to show dialog again with error message
            }
          } catch (e) {
            errorMessage =
                'An error occurred during verification. Please try again.';
            // Loop will continue to show dialog again with error message
          }
        }

        // If we reach here and still no success, return failure
        // Note: tfaLoginResult cannot be null here due to loop condition, but check is kept for defensive programming
        // ignore: unnecessary_null_comparison
        if (tfaLoginResult == null || !tfaLoginResult.result) {
          return AutoLoginResult(
            success: false,
            errorMessage: errorMessage ?? 'TFA verification failed',
            hadCredentials: true,
            reasonCode: PushLoginReasonCode.tfaRequired,
          );
        }
      }

      if (loginResult.result && loginResult.user != null) {
        // Login successful - update login data
        siteContext.loginDataOutput = loginResult;
        siteContext.lastSuccessfulLoginMethod = SiteContext.loginMethodPassword;

        // Save the updated baseForumInfo
        await siteContext.saveToDevice();

        // Record visit with credentials to ensure they're saved
        try {
          final siteController = Get.find<SiteController>();
          if (siteController.currentSite.value != null) {
            await SiteVisitTracker.instance.recordVisit(
              siteController.currentSite.value!,
              username: siteContext.username!,
              password: siteContext.password!,
            );
            AppLogger.debug('🔐 [AUTO_LOGIN] Recorded visit with credentials');
          }
        } catch (e) {
          AppLogger.debug(
              '🔐 [AUTO_LOGIN] Error recording visit with credentials: $e');
        }

        // Update auth state
        siteContext.updateLoginState();
        final cookieCountAfterLogin = await FCDioClient.instance
            .cookieCountForUrl(Uri.parse(siteContext.site.pluginUrl));
        AppLogger.debug(
            '🍪 [AUTO_LOGIN] Cookie count after successful credential login: $cookieCountAfterLogin');

        // Register for push notifications
        try {
          final siteController = Get.find<SiteController>();
          if (siteController.currentSite.value != null) {
            await _registerForPushNotifications(
                siteController.currentSite.value!, loginResult);
          } else {}
        } catch (_) {
          AppLogger.debug(
              '🔔 [AUTO_LOGIN] ❌ Error during push notification registration');
        }

        return AutoLoginResult(
          success: true,
          hadCredentials: true,
          reasonCode: PushLoginReasonCode.loginOk,
        );
      } else {
        // Login failed - clear credentials only on explicit auth-invalid outcomes
        final errorMessage = loginResult.resultText?.trim().isNotEmpty == true
            ? loginResult.resultText!
            : 'Saved credentials are invalid';
        if (_isExplicitAuthInvalidError(errorMessage)) {
          await _handleInvalidCredentials(
            siteContext,
            reason: 'server_confirmed_invalid_credentials',
            detail: errorMessage,
          );
        } else {
          AppLogger.warning(
              '🔐 [AUTO_LOGIN] Keeping credentials after non-auth login failure: $errorMessage');
        }
        // Don't show toast here - let SiteController show dialog instead
        final reasonCode = _isExplicitAuthInvalidError(errorMessage)
            ? PushLoginReasonCode.apiAuthInvalid
            : PushLoginReasonCode.transientError;
        return AutoLoginResult(
          success: false,
          errorMessage: errorMessage,
          hadCredentials: true,
          reasonCode: reasonCode,
        );
      }
    } on AuthenticationException catch (e) {
      await _handleInvalidCredentials(
        siteContext,
        reason: 'authentication_exception',
        detail: e.toString(),
      );
      return AutoLoginResult(
        success: false,
        errorMessage: e.toString(),
        hadCredentials: true,
        reasonCode: PushLoginReasonCode.apiAuthInvalid,
      );
    } on FCApiException catch (e, stackTrace) {
      await handleError(
        e,
        stackTrace,
        context: 'LoginController.attemptAutomaticLogin',
        showToUser: false,
      );

      final apiMessage = e.message.trim().isNotEmpty ? e.message : e.toString();
      if (_isExplicitAuthInvalidError(apiMessage) ||
          e.statusCode == 401 ||
          e.statusCode == 403) {
        await _handleInvalidCredentials(
          siteContext,
          reason: 'api_auth_invalid',
          detail: apiMessage,
        );
      } else {
        AppLogger.warning(
            '🔐 [AUTO_LOGIN] Keeping credentials after API error: status=${e.statusCode} message=$apiMessage');
      }
      final reasonCode = (_isExplicitAuthInvalidError(apiMessage) ||
              e.statusCode == 401 ||
              e.statusCode == 403)
          ? PushLoginReasonCode.apiAuthInvalid
          : PushLoginReasonCode.transientError;
      return AutoLoginResult(
        success: false,
        errorMessage: apiMessage,
        hadCredentials: true,
        reasonCode: reasonCode,
      );
    } catch (e, stackTrace) {
      await handleError(e, stackTrace,
          context: 'LoginController.attemptAutomaticLogin', showToUser: false);
      AppLogger.warning(
          '🔐 [AUTO_LOGIN] Keeping credentials after transient/generic error: $e');
      return AutoLoginResult(
        success: false,
        errorMessage: 'Login failed due to network error',
        hadCredentials: true,
        reasonCode: PushLoginReasonCode.transientError,
      );
    }
  }

  Future<AutoLoginResult> _attemptAutomaticPasskeyLogin(
      SiteContext siteContext) async {
    if (siteContext.siteType != 'xenforo' || !isPasskeySupportedByPlatform) {
      return AutoLoginResult(
        success: false,
        errorMessage: 'Passkey auto-login is not available on this platform.',
        hadCredentials: true,
        reasonCode: PushLoginReasonCode.transientError,
      );
    }

    siteContext.passkeyLoginInProgress = true;
    try {
      final userProxy = SiteProxyService.getUserProxy();
      final challengeResult = await userProxy.getPasskeyChallengeAsync();

      if (!challengeResult.result ||
          challengeResult.challenge == null ||
          challengeResult.rpId == null) {
        final message = challengeResult.resultText?.trim().isNotEmpty == true
            ? challengeResult.resultText!
            : 'Passkey challenge could not be created';
        siteContext.loginDataOutput = null;
        await siteContext.saveToDevice();
        siteContext.updateLoginState();
        return AutoLoginResult(
          success: false,
          errorMessage: message,
          hadCredentials: true,
          reasonCode: PushLoginReasonCode.transientError,
        );
      }

      final payload = await _authenticateWithPasskey(
        challenge: challengeResult.challenge!,
        rpId: challengeResult.rpId!,
        timeout: challengeResult.timeout,
      );

      final loginResult = await userProxy.loginWithPasskeyAsync(
        webauthnChallenge: challengeResult.challenge!,
        webauthnPayload: payload,
      );

      if (loginResult.result && loginResult.user != null) {
        siteContext.loginDataOutput = loginResult;
        siteContext.lastSuccessfulLoginMethod = SiteContext.loginMethodPasskey;
        if (loginResult.user!.username.trim().isNotEmpty) {
          siteContext.username = loginResult.user!.username;
        }
        await siteContext.saveToDevice();
        await _recordVisitForPasskeyLogin(
          siteContext,
          username: loginResult.user!.username,
        );
        siteContext.updateLoginState();

        try {
          final siteController = Get.find<SiteController>();
          final currentSite =
              siteController.currentSite.value ?? siteContext.site;
          await _registerForPushNotifications(currentSite, loginResult);
        } catch (_) {
          AppLogger.debug(
              '🔔 [AUTO_LOGIN] ❌ Error during push notification registration (passkey)');
        }

        return AutoLoginResult(
          success: true,
          hadCredentials: true,
          reasonCode: PushLoginReasonCode.loginOk,
        );
      }

      final message = loginResult.resultText?.trim().isNotEmpty == true
          ? loginResult.resultText!
          : 'Passkey login failed';
      siteContext.loginDataOutput = null;
      await siteContext.saveToDevice();
      siteContext.updateLoginState();
      return AutoLoginResult(
        success: false,
        errorMessage: message,
        hadCredentials: true,
        reasonCode: PushLoginReasonCode.transientError,
      );
    } on PasskeyAuthCancelledException {
      siteContext.loginDataOutput = null;
      await siteContext.saveToDevice();
      siteContext.updateLoginState();
      return AutoLoginResult(
        success: false,
        errorMessage: 'Passkey authentication cancelled',
        hadCredentials: true,
        reasonCode: PushLoginReasonCode.tfaRequired,
      );
    } on DomainNotAssociatedException {
      siteContext.loginDataOutput = null;
      await siteContext.saveToDevice();
      siteContext.updateLoginState();
      return AutoLoginResult(
        success: false,
        errorMessage:
            'This forum is not yet set up for passkey access on this app.',
        hadCredentials: true,
        reasonCode: PushLoginReasonCode.transientError,
      );
    } on PermissionException catch (e) {
      siteContext.loginDataOutput = null;
      await siteContext.saveToDevice();
      siteContext.updateLoginState();
      return AutoLoginResult(
        success: false,
        errorMessage: e.toString(),
        hadCredentials: true,
        reasonCode: PushLoginReasonCode.apiAuthInvalid,
      );
    } on AuthenticationException catch (e) {
      siteContext.loginDataOutput = null;
      await siteContext.saveToDevice();
      siteContext.updateLoginState();
      return AutoLoginResult(
        success: false,
        errorMessage: e.toString(),
        hadCredentials: true,
        reasonCode: PushLoginReasonCode.apiAuthInvalid,
      );
    } on FCApiException catch (e, stackTrace) {
      await handleError(
        e,
        stackTrace,
        context: 'LoginController._attemptAutomaticPasskeyLogin',
        showToUser: false,
      );
      siteContext.loginDataOutput = null;
      await siteContext.saveToDevice();
      siteContext.updateLoginState();
      final message = e.message.trim().isNotEmpty ? e.message : e.toString();
      final reasonCode = (e.statusCode == 401 || e.statusCode == 403)
          ? PushLoginReasonCode.apiAuthInvalid
          : PushLoginReasonCode.transientError;
      return AutoLoginResult(
        success: false,
        errorMessage: message,
        hadCredentials: true,
        reasonCode: reasonCode,
      );
    } catch (e, stackTrace) {
      await handleError(
        e,
        stackTrace,
        context: 'LoginController._attemptAutomaticPasskeyLogin',
        showToUser: false,
      );
      if (e is PlatformException) {
        final msg = (e.message ?? '').toLowerCase();
        if (msg.contains('webcredentials') ||
            (msg.contains('verify') && msg.contains('association'))) {
          return AutoLoginResult(
            success: false,
            errorMessage:
                'This forum is not yet set up for passkey access on this app.',
            hadCredentials: true,
            reasonCode: PushLoginReasonCode.transientError,
          );
        }
      }
      siteContext.loginDataOutput = null;
      await siteContext.saveToDevice();
      siteContext.updateLoginState();
      return AutoLoginResult(
        success: false,
        errorMessage: 'Passkey login failed',
        hadCredentials: true,
        reasonCode: PushLoginReasonCode.transientError,
      );
    } finally {
      siteContext.passkeyLoginInProgress = false;
    }
  }

  /// Handles invalid credentials by removing them and demoting forum to guest access
  Future<void> _handleInvalidCredentials(
    SiteContext siteContext, {
    required String reason,
    String? detail,
  }) async {
    try {
      AppLogger.warning(
          '🔐 [AUTO_LOGIN] Clearing saved credentials. reason=$reason detail=${detail ?? ''}');
      // Remove credentials from SiteVisitTracker by Site ID only
      try {
        final siteController = Get.find<SiteController>();
        final currentSite = siteController.currentSite.value;
        if (currentSite != null) {
          await SiteVisitTracker.instance.removeCredentials(currentSite);
        }
      } catch (e, stackTrace) {
        await handleError(e, stackTrace,
            context: 'LoginController._handleInvalidCredentials',
            showToUser: false);
      }

      // Clear credentials from BaseForumInfo
      siteContext.username = null;
      siteContext.password = null;
      siteContext.loginDataOutput = null;
      siteContext.lastSuccessfulLoginMethod = null;

      // Save the updated baseForumInfo
      await siteContext.saveToDevice();

      // Update auth state
      siteContext.updateLoginState();

      AppLogger.info('Successfully demoted forum to guest access');
    } catch (e, stackTrace) {
      await handleError(e, stackTrace,
          context: 'LoginController._handleInvalidCredentials',
          showToUser: false);
    }
  }

  bool _isExplicitAuthInvalidError(String message) {
    final normalized = message.toLowerCase();
    return normalized.contains('invalid username') ||
        normalized.contains('invalid password') ||
        normalized.contains('incorrect password') ||
        normalized.contains('requested user') ||
        normalized.contains('credentials are invalid') ||
        normalized.contains('unauthorized') ||
        normalized.contains('forbidden');
  }

  /// Records visit with credentials to SiteVisitTracker for automatic login
  Future<void> _recordVisitWithCredentials(
      String username, String password, SiteContext siteContext) async {
    try {
      final siteUrl = siteContext.site.pluginUrl;

      if (siteUrl.isNotEmpty) {
        siteContext.username = username;
        siteContext.password = password;

        // Get the current forum from SiteController
        try {
          final siteController = Get.find<SiteController>();

          if (siteController.currentSite.value != null) {
            final currentSite = siteController.currentSite.value!;

            // Record visit with credentials
            await SiteVisitTracker.instance.recordVisit(
              currentSite,
              username: username,
              password: password,
            );
          }
        } catch (controllerError, stackTrace) {
          await handleError(controllerError, stackTrace,
              context: 'LoginController._recordVisitWithCredentials',
              showToUser: false);
        }
      }
    } catch (e, stackTrace) {
      await handleError(e, stackTrace,
          context: 'LoginController._recordVisitWithCredentials',
          showToUser: false);
    }
  }

  Future<void> _recordVisitForPasskeyLogin(
    SiteContext siteContext, {
    String? username,
  }) async {
    try {
      final siteController = Get.find<SiteController>();
      final currentSite = siteController.currentSite.value ?? siteContext.site;

      await SiteVisitTracker.instance.recordVisit(
        currentSite,
        username: username,
        markAsMyForum: true,
      );
    } catch (e, stackTrace) {
      await handleError(
        e,
        stackTrace,
        context: 'LoginController._recordVisitForPasskeyLogin',
        showToUser: false,
      );
    }
  }

  /// Handles logout process
  Future<bool> handleLogout(SiteContext siteContext) async {
    try {
      // Get site context before clearing login data

      // Call server logout
      final userProxy = SiteProxyService.getUserProxy();
      await userProxy.logoutUserAsync();

      // Remove credentials from SiteVisitTracker when user logs out
      try {
        final siteController = Get.find<SiteController>();
        final currentSite = siteController.currentSite.value;
        if (currentSite != null) {
          await SiteVisitTracker.instance.removeCredentials(currentSite);
        }
      } catch (e, stackTrace) {
        await handleError(e, stackTrace,
            context: 'LoginController.handleLogout', showToUser: false);
        // Don't fail logout if credential removal fails
      }

      // Deregister from push notifications for this forum
      try {
        // Get forum identifier for deregistration
        String? siteId;
        try {
          final forumController = Get.find<SiteController>();
          final currentForum = forumController.currentSite.value;
          if (currentForum?.id != null) {
            siteId = currentForum!.id.toString();
          }
        } catch (e, stackTrace) {
          await handleError(e, stackTrace,
              context: 'LoginController.handleLogout', showToUser: false);
        }

        if (siteId != null) {
          // Get push notification controller
          PushNotificationController? pushController;
          try {
            pushController = Get.find<PushNotificationController>();
          } catch (e, stackTrace) {
            await handleError(e, stackTrace,
                context: 'LoginController.handleLogout', showToUser: false);
          }

          if (pushController != null && pushController.isInitialized) {
            AppLogger.info('Deregistering from forum: $siteId');
            final success = await pushController.unregisterSite(siteId);
            if (success) {
              AppLogger.info(
                  'Successfully deregistered from push notifications for forum: $siteId');
            } else {
              AppLogger.warning(
                  'Failed to deregister from push notifications for forum: $siteId');
            }
          } else {
            AppLogger.warning(
                'Push notification controller not available, skipping deregistration');
          }
        } else {
          AppLogger.warning(
              'No forum ID available, skipping push notification deregistration');
        }
      } catch (e, stackTrace) {
        await handleError(e, stackTrace,
            context: 'LoginController.handleLogout', showToUser: false);
        // Don't fail logout if push notification deregistration fails
      }

      siteContext.username = null;
      siteContext.password = null;
      siteContext.lastSuccessfulLoginMethod = null;

      // Clear login data from context
      await siteContext.saveToDevice();

      // Update auth state - this will trigger the worker in site_home_page.dart
      siteContext.updateLoginState();

      // Re-initialize site to refresh permissions and configuration
      SiteController siteController = Get.put(SiteController());
      await siteController.initializeCurrentSite();

      return true;
    } catch (e, stackTrace) {
      await handleError(e, stackTrace, context: 'LoginController.handleLogout');
      return false;
    }
  }

  Future<FCLoginResult> _loginWithPasskeyTfa({
    required IFCUserProxy userProxy,
    required FCLoginResult loginResult,
    required String username,
    required String password,
  }) async {
    final passkeyChallenge = loginResult.passkeyChallenge;
    final passkeyRpId = loginResult.passkeyRpId;

    if (passkeyChallenge == null ||
        passkeyChallenge.trim().isEmpty ||
        passkeyRpId == null ||
        passkeyRpId.trim().isEmpty) {
      throw ValidationException.invalidInput('passkey challenge');
    }

    final payload = await _authenticateWithPasskey(
      challenge: passkeyChallenge,
      rpId: passkeyRpId,
      timeout: loginResult.passkeyTimeout,
    );

    return userProxy.loginAsync(
      username,
      password,
      false, // not anonymous
      null, // no trust code
      remember: true,
      tfaProvider: 'passkey',
      webauthnChallenge: passkeyChallenge,
      webauthnPayload: payload,
      trustDevice: true,
    );
  }

  Future<Map<String, String>> _authenticateWithPasskey({
    required String challenge,
    required String rpId,
    int? timeout,
  }) async {
    if (challenge.trim().isEmpty) {
      throw ValidationException.requiredField('passkey challenge');
    }
    if (rpId.trim().isEmpty) {
      throw ValidationException.requiredField('relying party id');
    }

    final authenticator = PasskeyAuthenticator();
    final canAuthenticate = await authenticator.canAuthenticate();
    if (!canAuthenticate) {
      throw PermissionException.featureNotAvailable('Passkeys');
    }

    final request = AuthenticateRequestType(
      relyingPartyId: rpId,
      challenge: challenge,
      mediation: MediationType.Optional,
      preferImmediatelyAvailableCredentials: true,
      timeout: timeout,
    );

    final response = await authenticator.authenticate(request);

    final normalizedClientData =
        _normalizeWebauthnBase64(response.clientDataJSON);
    final clientDataJson = utf8.decode(base64.decode(normalizedClientData));
    final clientData = jsonDecode(clientDataJson) as Map<String, dynamic>;
    final clientChallenge = clientData['challenge']?.toString() ?? '';
    // Server sends challenge as base64url; authenticator puts that same string in clientDataJSON.
    // Do not re-encode: compare with the challenge we sent, normalizing padding for comparison.
    final expectedChallenge = challenge.replaceAll('=', '');
    final clientChallengeNormalized = clientChallenge.replaceAll('=', '');
    AppLogger.debug(
      '🔐 [PASSKEY] clientDataJSON.challenge=$clientChallenge expected=$expectedChallenge matches=${clientChallengeNormalized == expectedChallenge}',
    );

    // ForumCopilot API expects standard base64; normalize base64url when needed.
    return {
      'id': _normalizeWebauthnBase64(response.id),
      'clientDataJSON': _normalizeWebauthnBase64(response.clientDataJSON),
      'authenticatorData': _normalizeWebauthnBase64(response.authenticatorData),
      'signature': _normalizeWebauthnBase64(response.signature),
    };
  }

  /// Convert base64url to standard base64 only when needed.
  static String _normalizeWebauthnBase64(String value) {
    if (value.isEmpty) return value;
    var normalized = value;
    final hasUrlChars = normalized.contains('-') || normalized.contains('_');
    if (hasUrlChars) {
      normalized = normalized.replaceAll('-', '+').replaceAll('_', '/');
    }

    if (!normalized.contains('=')) {
      final mod = normalized.length % 4;
      if (mod == 2) {
        normalized += '==';
      } else if (mod == 3) {
        normalized += '=';
      }
    }

    return normalized;
  }

  Future<void> _showLoginInfoDialog(
      String message, ColorScheme colorScheme) async {
    await Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.info_outline_rounded,
              color: colorScheme.primary,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Login Info',
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: TextStyle(
            color: colorScheme.onSurfaceVariant,
            height: 1.4,
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Get.back();
            },
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'OK',
              style: TextStyle(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        backgroundColor: colorScheme.surface,
        elevation: 8,
      ),
    );
  }

  Future<void> _showLoginErrorDialog(
      String message, ColorScheme colorScheme) async {
    await Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: colorScheme.error,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Login Failed',
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: TextStyle(
            color: colorScheme.onSurfaceVariant,
            height: 1.4,
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Get.back();
            },
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'OK',
              style: TextStyle(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        backgroundColor: colorScheme.surface,
        elevation: 8,
      ),
    );
  }

  /// Register for push notifications after successful login
  Future<void> _registerForPushNotifications(
    Site currentSite,
    FCLoginResult loginResult,
  ) async {
    try {
      AppLogger.info('Starting push notification registration...');

      // Get push notification controller
      PushNotificationController? pushController;
      try {
        pushController = Get.find<PushNotificationController>();
      } catch (e) {
        AppLogger.info(
            'PushNotificationController not found, attempting to create...');
        pushController = PushNotificationController();
        Get.put(pushController);
      }

      // Wait for controller to be ready if not initialized yet
      int attempts = 0;
      while (!pushController.isInitialized && attempts < 20) {
        await Future.delayed(const Duration(milliseconds: 250));
        attempts++;
        AppLogger.debug(
            'Waiting for PushNotificationController... attempt $attempts');
      }

      if (!pushController.isInitialized) {
        AppLogger.warning(
            'Push notification controller not initialized after waiting, skipping registration');
        return;
      }

      AppLogger.info(
          'PushNotificationController is ready, proceeding with registration...');

      // Get site identifier
      String siteId;
      if (currentSite.id != null) {
        siteId = currentSite.id.toString();
      } else {
        // Use URL host as fallback
        final uri = Uri.parse(currentSite.url);
        siteId = uri.host;
      }

      // Register for push notifications with delayed toasts to avoid blocking login page
      // Delay ensures login page closes before toasts appear
      final success = await pushController.registerSite(
        siteId: siteId,
        siteUrl: currentSite.url,
        siteName: currentSite.name,
        userId: loginResult.user?.id ?? '',
        username: loginResult.user?.username ?? '',
        suppressToasts: false,
        toastDelay: const Duration(
            milliseconds: 500), // Delay toasts to allow login page to close
      );

      if (success) {
        AppLogger.info(
            'Successfully registered for push notifications for site: ${currentSite.name}');
        AppLogger.debug(
            'Device ID: ${pushController.deviceId?.substring(0, 8)}...');
        AppLogger.debug(
            'FCM Token: ${pushController.fcmToken?.substring(0, 8)}...');
      } else {
        AppLogger.warning(
            'Failed to register for push notifications for site: ${currentSite.name}');
        AppLogger.warning('Error: ${pushController.lastError}');
      }
    } catch (e, stackTrace) {
      await handleError(e, stackTrace,
          context: 'LoginController._registerForPushNotifications',
          showToUser: false);
      // Don't fail login if push notification registration fails
    }
  }
}
