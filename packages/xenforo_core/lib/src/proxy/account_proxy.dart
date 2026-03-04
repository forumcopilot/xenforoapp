import 'dart:convert';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/interfaces/i_fc_account_proxy.dart';
import 'package:forumcopilot_sdk/models/results/fc_account_result.dart';
import 'package:forumcopilot_sdk/models/registration/fc_registration_requirements.dart';
import 'package:forumcopilot_sdk/models/entities/fc_custom_field_definition.dart';
import 'package:forumcopilot_sdk/models/settings/fc_settings_category.dart';
import 'package:forumcopilot_sdk/models/settings/fc_user_setting.dart';
import 'package:forumcopilot_sdk/models/settings/fc_user_settings_result.dart';
import '../base_xenforo_proxy.dart';

/// XenForo implementation of IFCAccountProxy
/// Handles user registration and authentication for XenForo forums
class XenForoAccountProxy extends BaseXenForoProxy implements IFCAccountProxy {
  XenForoAccountProxy(SiteContext context) : super(context);

  @override
  Future<FCForgetPasswordResult> forgetPassword(String username, String token, String code) async {
    print('✅ [XENFORO_ACCOUNT] forgetPassword called via plugin API');
    print('   📋 Parameters: username=$username');

    try {
      // Call plugin API with forgotPassword method
      // The API accepts usernameOrEmail parameter (it auto-detects if it's an email or username)
      final response = await callPluginApi('forgotPassword', {
        'usernameOrEmail': username,
      });

      // Convert response to FCForgetPasswordResult
      return FCForgetPasswordResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString(),
        verified: response['verified'] ?? false,
      );
    } catch (e) {
      print('❌ [XENFORO_ACCOUNT] forgetPassword error: $e');
      return FCForgetPasswordResult(
        result: false,
        resultText: 'Error requesting password reset: $e',
        verified: false,
      );
    }
  }

  @override
  Future<FCPrefetchAccountResult?> prefetchAccount() async {
    print('✅ [XENFORO_ACCOUNT] prefetchAccount called via plugin API');

    try {
      final response = await callPluginApi('prefetchAccount', {});

      print('   📥 [XENFORO_ACCOUNT] prefetchAccount response keys: ${response.keys.toList()}');
      print('   📥 [XENFORO_ACCOUNT] Full JSON response (formatted):');
      // Pretty print the JSON response
      try {
        final encoder = JsonEncoder.withIndent('  ');
        print(encoder.convert(response));
      } catch (e) {
        print('   ${response.toString()}');
      }
      print('   📥 [XENFORO_ACCOUNT] registrationOpen: ${response['registrationOpen']}');
      print('   📥 [XENFORO_ACCOUNT] canRegisterViaAPI: ${response['canRegisterViaAPI']}');
      print('   📥 [XENFORO_ACCOUNT] registerViaWebUrl: ${response['registerViaWebUrl']}');

      // Parse registrationRequirements if present
      FCRegistrationRequirements? registrationRequirements;
      if (response['registrationRequirements'] != null) {
        registrationRequirements = _parseRegistrationRequirements(
          response['registrationRequirements'] as Map<String, dynamic>,
        );
      }

      return FCPrefetchAccountResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString(),
        accountExists: response['accountExists'] ?? false,
        username: response['username']?.toString(),
        email: response['email']?.toString(),
        registrationOpen: response['registrationOpen'] ?? false,
        canRegisterViaAPI: response['canRegisterViaAPI'] ?? false,
        registerViaWebUrl: response['registerViaWebUrl']?.toString() ?? '',
        registrationRequirements: registrationRequirements,
      );
    } catch (e) {
      print('❌ [XENFORO_ACCOUNT] prefetchAccount error: $e');
      return null;
    }
  }

  FCRegistrationRequirements _parseRegistrationRequirements(Map<String, dynamic> data) {
    // Helper function to safely convert to int (shared by multiple parsers)
    int? _parseInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) {
        final parsed = int.tryParse(value);
        return parsed;
      }
      return null;
    }

    // Parse field requirements
    FCFieldRequirement? _parseFieldRequirement(dynamic fieldData) {
      if (fieldData == null) return null;
      final map = fieldData as Map<String, dynamic>;
      
      return FCFieldRequirement(
        required: map['required'] ?? false,
        minLength: _parseInt(map['minLength']),
        maxLength: _parseInt(map['maxLength']),
        checkStrength: map['checkStrength'] as bool?,
        minimumAge: _parseInt(map['minimumAge']),
        requireDob: map['requireDob'] as bool?,
        requireLocation: map['requireLocation'] as bool?,
        requireEmailChoice: map['requireEmailChoice'] as bool?,
      );
    }

    // Parse policy requirement
    FCPolicyRequirement? _parsePolicyRequirement(dynamic policyData) {
      if (policyData == null) return null;
      final map = policyData as Map<String, dynamic>;
      return FCPolicyRequirement(
        required: map['required'] ?? false,
        url: map['url']?.toString() ?? '',
      );
    }

    // Parse CAPTCHA requirement
    FCCaptchaRequirement? _parseCaptchaRequirement(dynamic captchaData) {
      if (captchaData == null) return null;
      final map = captchaData as Map<String, dynamic>;
      return FCCaptchaRequirement(
        required: map['required'] ?? false,
        type: map['type']?.toString(),
        invisible: map['invisible'] as bool?,
        siteKey: map['siteKey']?.toString(),
      );
    }

    // Parse custom fields
    List<FCCustomFieldDefinition> _parseCustomFields(dynamic customFieldsData) {
      if (customFieldsData == null) return [];
      final List<dynamic> fieldsList = customFieldsData as List<dynamic>;
      return fieldsList.map((fieldData) {
        final map = fieldData as Map<String, dynamic>;
        // Handle choices as Map or string
        Map<String, String>? choices;
        if (map['choices'] != null) {
          if (map['choices'] is Map) {
            choices = Map<String, String>.from(
              (map['choices'] as Map).map((k, v) => MapEntry(k.toString(), v.toString())),
            );
          }
        }
        return FCCustomFieldDefinition(
          name: map['title']?.toString() ?? map['name']?.toString() ?? '',
          description: map['description']?.toString() ?? '',
          key: map['fieldId']?.toString() ?? map['key']?.toString() ?? '',
          fieldId: map['fieldId']?.toString(),
          type: map['fieldType']?.toString() ?? map['type']?.toString() ?? '',
          format: map['format']?.toString() ?? '',
          defaultValue: map['defaultValue'],
          options: map['options']?.toString() ?? '',
          displayOrder: map['displayOrder'] as int?,
          choices: choices,
          required: map['required'] as bool? ?? false,
          maxLength: _parseInt(map['maxLength']),
        );
      }).toList();
    }

    return FCRegistrationRequirements(
      username: _parseFieldRequirement(data['username']),
      email: _parseFieldRequirement(data['email']),
      password: _parseFieldRequirement(data['password']),
      dateOfBirth: _parseFieldRequirement(data['dateOfBirth']),
      location: _parseFieldRequirement(data['location']),
      emailChoice: _parseFieldRequirement(data['emailChoice']),
      customFields: _parseCustomFields(data['customFields']),
      captcha: _parseCaptchaRequirement(data['captcha']),
      privacyPolicy: _parsePolicyRequirement(data['privacyPolicy']),
      termsOfService: _parsePolicyRequirement(data['termsOfService']),
    );
  }

  @override
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
  }) async {
    print('✅ [XENFORO_ACCOUNT] register called via plugin API');
    print('   📋 Parameters: username=$username, email=$email');

    try {
      final params = <String, dynamic>{
        'username': username,
        'email': email,
        'password': password,
      };

      if (passwordConfirm != null) params['passwordConfirm'] = passwordConfirm;
      if (timezone != null) params['timezone'] = timezone;
      if (dateOfBirth != null && dateOfBirth.isNotEmpty) {
        params['dateOfBirth'] = dateOfBirth; // Send as YYYY-MM-DD format
        print('   📋 dateOfBirth: $dateOfBirth');
      }
      if (location != null) params['location'] = location;
      if (emailChoice != null) params['emailChoice'] = emailChoice;
      if (customFields != null && customFields.isNotEmpty) params['customFields'] = customFields;
      if (captchaToken != null) params['captchaToken'] = captchaToken;
      if (acceptTerms != null) params['acceptTerms'] = acceptTerms;
      if (acceptPrivacy != null) params['acceptPrivacy'] = acceptPrivacy;

      final response = await callPluginApi('register', params);

      print('   📥 [XENFORO_ACCOUNT] register response keys: ${response.keys.toList()}');

      return FCRegisterResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString(),
        previewTopicId: response['previewTopicId']?.toString() ?? '',
        userId: response['userId']?.toString(),
        username: response['username']?.toString(),
        userState: response['userState']?.toString(),
        requiresEmailConfirmation: response['requiresEmailConfirmation'] as bool?,
        requiresManualApproval: response['requiresManualApproval'] as bool?,
        message: response['message']?.toString(),
      );
    } catch (e) {
      print('❌ [XENFORO_ACCOUNT] register error: $e');
      return FCRegisterResult(
        result: false,
        resultText: 'Registration failed: $e',
      );
    }
  }

  @override
  Future<FCSigninResult> signinLogin(String token, String code, String? trustCode) {
    // TODO: implement signinLogin
    throw UnimplementedError();
  }

  @override
  Future<FCSigninResult> signinLoginWithEmail(String token, String code, String email, String? trustCode) {
    // TODO: implement signinLoginWithEmail
    throw UnimplementedError();
  }

  @override
  Future<FCSigninResult> signinLoginWithUsername(String token, String code, String email, String username, String? trustCode) {
    // TODO: implement signinLoginWithUsername
    throw UnimplementedError();
  }

  @override
  Future<FCSigninResult> signinRegister(String token, String code, String email, String username, String password, {Map<String, dynamic>? customRegisterFields}) {
    // TODO: implement signinRegister
    throw UnimplementedError();
  }

  @override
  Future<FCUpdateEmailResult> updateEmail(String password, String newEmail) {
    // TODO: implement updateEmail
    throw UnimplementedError();
  }

  @override
  Future<FCUpdatePasswordResult> updatePassword(String oldPassword, String newPassword) {
    // TODO: implement updatePassword
    throw UnimplementedError();
  }

  @override
  Future<FCUpdatePasswordSSOResult> updatePasswordSSO(String newPassword, String token, String code) {
    // TODO: implement updatePasswordSSO
    throw UnimplementedError();
  }

  @override
  Future<FCUpdateProfileResult> updateProfile(String userId, Map<String, dynamic> customFields) {
    // TODO: implement updateProfile
    throw UnimplementedError();
  }

  /// Get list of available settings categories
  Future<FCUserSettingsCategoriesResult> getUserSettingsCategories() async {
    print('✅ [XENFORO_ACCOUNT] getUserSettingsCategories called via plugin API');

    try {
      final response = await callPluginApi('getUserSettingsCategories', {});

      print('   📥 [XENFORO_ACCOUNT] getUserSettingsCategories response keys: ${response.keys.toList()}');

      // Parse categories
      List<FCSettingsCategory> categories = [];
      if (response['categories'] != null) {
        final categoriesList = response['categories'] as List<dynamic>;
        categories = categoriesList.map((catData) {
          final map = catData as Map<String, dynamic>;
          return FCSettingsCategory(
            key: map['key']?.toString() ?? '',
            displayName: map['displayName']?.toString() ?? '',
            description: map['description']?.toString() ?? '',
            enabled: map['enabled'] as bool? ?? false,
          );
        }).toList();
      }

      return FCUserSettingsCategoriesResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString(),
        categories: categories,
      );
    } catch (e) {
      print('❌ [XENFORO_ACCOUNT] getUserSettingsCategories error: $e');
      return FCUserSettingsCategoriesResult(
        result: false,
        resultText: 'Error fetching settings categories: $e',
        categories: [],
      );
    }
  }

  /// Get settings for a specific category
  Future<FCUserSettingsResult> getUserSettings(String category) async {
    print('✅ [XENFORO_ACCOUNT] getUserSettings called via plugin API');
    print('   📋 Parameters: category=$category');

    try {
      final response = await callPluginApi('getUserSettings', {
        'category': category,
      });

      print('   📥 [XENFORO_ACCOUNT] getUserSettings response keys: ${response.keys.toList()}');

      // Parse settings
      List<FCUserSetting> settings = [];
      if (response['settings'] != null) {
        final settingsList = response['settings'] as List<dynamic>;
        settings = settingsList.map((settingData) {
          return _parseUserSetting(settingData as Map<String, dynamic>);
        }).toList();
      }

      return FCUserSettingsResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString(),
        category: response['category']?.toString() ?? category,
        enabled: response['enabled'] as bool? ?? false,
        settings: settings,
      );
    } catch (e) {
      print('❌ [XENFORO_ACCOUNT] getUserSettings error: $e');
      return FCUserSettingsResult(
        result: false,
        resultText: 'Error fetching settings: $e',
        category: category,
        enabled: false,
        settings: [],
      );
    }
  }

  /// Update settings for a specific category
  Future<FCUserSettingsResult> updateUserSettings(
    String category,
    Map<String, dynamic> settings,
  ) async {
    print('✅ [XENFORO_ACCOUNT] updateUserSettings called via plugin API');
    print('   📋 Parameters: category=$category, settings keys: ${settings.keys.toList()}');

    try {
      final response = await callPluginApi('updateUserSettings', {
        'category': category,
        'settings': settings,
      });

      print('   📥 [XENFORO_ACCOUNT] updateUserSettings response keys: ${response.keys.toList()}');

      // Parse updated settings
      List<FCUserSetting> updatedSettings = [];
      if (response['settings'] != null) {
        final settingsList = response['settings'] as List<dynamic>;
        updatedSettings = settingsList.map((settingData) {
          return _parseUserSetting(settingData as Map<String, dynamic>);
        }).toList();
      }

      return FCUserSettingsResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString(),
        category: response['category']?.toString() ?? category,
        enabled: response['enabled'] as bool? ?? false,
        settings: updatedSettings,
      );
    } catch (e) {
      print('❌ [XENFORO_ACCOUNT] updateUserSettings error: $e');
      return FCUserSettingsResult(
        result: false,
        resultText: 'Error updating settings: $e',
        category: category,
        enabled: false,
        settings: [],
      );
    }
  }

  /// Parse a user setting from API response
  FCUserSetting _parseUserSetting(Map<String, dynamic> map) {
    // Helper function to safely convert to int
    int? _parseInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) {
        final parsed = int.tryParse(value);
        return parsed;
      }
      return null;
    }

    // Helper function to safely convert to num
    num? _parseNum(dynamic value) {
      if (value == null) return null;
      if (value is num) return value;
      if (value is String) {
        final parsed = num.tryParse(value);
        return parsed;
      }
      return null;
    }

    // Parse choices
    Map<String, String>? choices;
    if (map['choices'] != null) {
      if (map['choices'] is Map) {
        choices = Map<String, String>.from(
          (map['choices'] as Map).map((k, v) => MapEntry(k.toString(), v.toString())),
        );
      }
    }

    // Parse dependency
    FCSettingDependency? dependsOn;
    if (map['dependsOn'] != null) {
      final depMap = map['dependsOn'] as Map<String, dynamic>;
      dependsOn = FCSettingDependency(
        key: depMap['key']?.toString() ?? '',
        value: depMap['value'],
      );
    }

    return FCUserSetting(
      fieldId: map['fieldId']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      fieldType: map['fieldType']?.toString() ?? '',
      dataType: map['dataType']?.toString() ?? '',
      value: map['value'],
      defaultValue: map['default'],
      choices: choices,
      required: map['required'] as bool? ?? false,
      readOnly: map['readOnly'] as bool? ?? false,
      maxLength: _parseInt(map['maxLength']),
      matchType: map['matchType']?.toString(),
      matchParams: map['matchParams'] as Map<String, dynamic>?,
      min: _parseNum(map['min']),
      max: _parseNum(map['max']),
      pattern: map['pattern']?.toString(),
      placeholder: map['placeholder']?.toString(),
      displayOrder: _parseInt(map['displayOrder']) ?? 0,
      group: map['group']?.toString(),
      dependsOn: dependsOn,
    );
  }
}
