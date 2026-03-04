import 'package:dart_mappable/dart_mappable.dart';
import 'package:forumcopilot_sdk/models/entities/fc_custom_field_definition.dart';
import 'package:forumcopilot_sdk/models/results/fc_base_result.dart';
import 'package:forumcopilot_sdk/models/registration/fc_registration_requirements.dart';

part 'fc_account_result.mapper.dart';

/// Forum Copilot Signin Result
/// Maps from SigninData_Output
@MappableClass()
class FCSigninResult extends FCBaseResult with FCSigninResultMappable {
  /// Return this user ID
  String? userId;

  /// User email
  String? email;

  /// User type
  String? userType;

  /// Return user's display name if the forum system support display name feature
  String? username;

  /// Login name
  String? login;

  /// Return a list of usergroup ID that this user belongs to
  List<String>? usergroupId;

  /// User avatar URL
  String? iconUrl;

  /// Return total number of post of this user
  int postCount;

  /// This instructs the app to hide the "Messaging" tab
  bool canPm;

  /// This instructs the app to disable "Send PM" feature
  bool canSendPm;

  /// Return true if this particular user has moderation capability
  bool canModerate;

  /// Return false if users do not have permission to search in this forum
  bool canSearch;

  /// Return false if this user does not have permission to see current list of online user
  bool canWhosonline;

  /// Return false if this user does not have permission to user profile page
  bool canProfile;

  /// Return true if this user can modify his avatar
  bool canUploadAvatar;

  /// Return the maximum allowed attachments the user can upload in a single post
  int maxAttachment;

  /// Return the maximum allowed PNG file size that the user can upload (in bytes)
  int maxPngSize;

  /// Return the maximum allowed JPEG file size that the user can upload (in bytes)
  int maxJpgSize;

  /// Whether this is a registration (true) or login (false)
  bool register;

  /// Status code: "1" - username is already taken, "2" - need all parameters for register,
  /// "3" - email mismatch, others are of no concern
  String status;

  FCSigninResult({
    required bool result,
    String? resultText,
    this.userId,
    this.email,
    this.userType,
    this.username,
    this.login,
    this.usergroupId,
    this.iconUrl,
    this.postCount = 0,
    this.canPm = false,
    this.canSendPm = false,
    this.canModerate = false,
    this.canSearch = false,
    this.canWhosonline = false,
    this.canProfile = false,
    this.canUploadAvatar = false,
    this.maxAttachment = 0,
    this.maxPngSize = 0,
    this.maxJpgSize = 0,
    this.register = false,
    this.status = '',
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Forget Password Result
/// Maps from ForgetPasswordData_Output
@MappableClass()
class FCForgetPasswordResult extends FCBaseResult with FCForgetPasswordResultMappable {
  /// Whether the password reset was verified
  bool verified;

  FCForgetPasswordResult({
    required bool result,
    String? resultText,
    this.verified = false,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Update Password Result
/// Maps from UpdatePasswordData_Output
@MappableClass()
class FCUpdatePasswordResult extends FCBaseResult with FCUpdatePasswordResultMappable {
  FCUpdatePasswordResult({
    required bool result,
    String? resultText,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Update Profile Result
/// Maps from UpdateProfileData_Output
@MappableClass()
class FCUpdateProfileResult extends FCBaseResult with FCUpdateProfileResultMappable {
  FCUpdateProfileResult({
    required bool result,
    String? resultText,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Update Password SSO Result
/// Maps from UpdatePasswordSSOData_Output
@MappableClass()
class FCUpdatePasswordSSOResult extends FCBaseResult with FCUpdatePasswordSSOResultMappable {
  FCUpdatePasswordSSOResult({
    required bool result,
    String? resultText,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Update Email Result
/// Maps from UpdateEmailData_Output
@MappableClass()
class FCUpdateEmailResult extends FCBaseResult with FCUpdateEmailResultMappable {
  FCUpdateEmailResult({
    required bool result,
    String? resultText,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Register Result
/// Maps from RegisterData_Output
@MappableClass()
class FCRegisterResult extends FCBaseResult with FCRegisterResultMappable {
  /// Preview topic ID for new user
  String previewTopicId;

  /// User ID of the created account
  String? userId;

  /// Username of the created account
  String? username;

  /// User account state: "valid", "email_confirm", "moderated"
  String? userState;

  /// Whether email confirmation is required
  bool? requiresEmailConfirmation;

  /// Whether manual approval is required
  bool? requiresManualApproval;

  /// Registration completion message from the server
  String? message;

  FCRegisterResult({
    required bool result,
    String? resultText,
    this.previewTopicId = '',
    this.userId,
    this.username,
    this.userState,
    this.requiresEmailConfirmation,
    this.requiresManualApproval,
    this.message,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Custom Register Field
/// Maps from PrefetchAccountData_CustomField
@MappableClass()
class FCCustomRegisterField with FCCustomRegisterFieldMappable {
  /// Field name
  String name;

  /// Field description
  String description;

  /// Field key
  String key;

  /// Field type
  String type;

  /// Field format
  String format;

  /// Default value
  dynamic defaultValue;

  /// Field options
  String options;

  // Compatibility properties for snake_case access
  dynamic get default_value => defaultValue;

  FCCustomRegisterField({
    this.name = "",
    this.description = "",
    this.key = "",
    this.type = "",
    this.format = "",
    this.defaultValue,
    this.options = "",
  });
}

/// Forum Copilot Prefetch Account Result
/// Maps from PrefetchAccountData_Output
@MappableClass()
class FCPrefetchAccountResult extends FCBaseResult with FCPrefetchAccountResultMappable {
  /// Whether the account exists
  bool accountExists;

  /// Username if account exists
  String? username;

  /// Email if account exists
  String? email;

  /// Whether registration is open (forum open AND registration enabled)
  bool registrationOpen;

  /// Whether API registration is possible (requires registrationOpen: true AND registration not too complex)
  bool canRegisterViaAPI;

  /// Registration URL for web redirect (always provided)
  String registerViaWebUrl;

  /// Registration requirements (new API structure)
  FCRegistrationRequirements? registrationRequirements;

  /// Custom register fields (legacy, for backward compatibility)
  // This is a computed getter, not a stored field
  List<FCCustomFieldDefinition> get customRegisterFields {
    return registrationRequirements?.customFields ?? [];
  }

  // Compatibility properties for snake_case access
  List<FCCustomFieldDefinition> get custom_register_fields => customRegisterFields;

  FCPrefetchAccountResult({
    required bool result,
    String? resultText,
    this.accountExists = false,
    this.username,
    this.email,
    this.registrationOpen = false,
    this.canRegisterViaAPI = false,
    this.registerViaWebUrl = '',
    this.registrationRequirements,
  }) : super(result: result, resultText: resultText);
}
