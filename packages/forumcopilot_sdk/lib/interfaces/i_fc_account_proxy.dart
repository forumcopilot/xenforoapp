import '../models/results/fc_account_result.dart';
import '../models/settings/fc_user_settings_result.dart';

/// Interface for account management operations
/// This interface handles user authentication, registration, and profile management
abstract class IFCAccountProxy {
  /// Create a new account (register or sign in)
  Future<FCSigninResult> signinRegister(String token, String code, String email, String username, String password, {Map<String, dynamic>? customRegisterFields});

  /// Sign in using email address
  Future<FCSigninResult> signinLoginWithEmail(String token, String code, String email, String? trustCode);

  /// Sign in using username
  Future<FCSigninResult> signinLoginWithUsername(String token, String code, String email, String username, String? trustCode);

  /// Sign in without email or username
  Future<FCSigninResult> signinLogin(String token, String code, String? trustCode);

  /// Request for password reset
  Future<FCForgetPasswordResult> forgetPassword(String username, String token, String code);

  /// Update current user's password
  Future<FCUpdatePasswordResult> updatePassword(String oldPassword, String newPassword);

  /// Update user profile
  Future<FCUpdateProfileResult> updateProfile(String userId, Map<String, dynamic> customFields);

  /// Update password via SSO
  Future<FCUpdatePasswordSSOResult> updatePasswordSSO(String newPassword, String token, String code);

  /// Update current user's email address
  Future<FCUpdateEmailResult> updateEmail(String password, String newEmail);

  /// Register a new forum account
  Future<FCRegisterResult> register({
    required String username,
    required String email,
    required String password,
    String? passwordConfirm,
    String? timezone,
    String? dateOfBirth, // Format: YYYY-MM-DD (ISO 8601 date format)
    String? location,
    bool? emailChoice,
    Map<String, dynamic>? customFields,
    String? captchaToken,
    bool? acceptTerms,
    bool? acceptPrivacy,
  });

  /// Prefetch user account information and get registration requirements
  Future<FCPrefetchAccountResult?> prefetchAccount();

  /// Get list of available settings categories
  Future<FCUserSettingsCategoriesResult> getUserSettingsCategories();

  /// Get settings for a specific category
  Future<FCUserSettingsResult> getUserSettings(String category);

  /// Update settings for a specific category
  Future<FCUserSettingsResult> updateUserSettings(String category, Map<String, dynamic> settings);
}
