import 'package:dart_mappable/dart_mappable.dart';
import 'package:forumcopilot_sdk/models/entities/fc_custom_field_definition.dart';

part 'fc_registration_requirements.mapper.dart';

/// Flexible field requirement for username, email, password, DOB, location, emailChoice
/// Different fields use different combinations of these optional properties
@MappableClass()
class FCFieldRequirement with FCFieldRequirementMappable {
  /// Whether this field is required
  bool required;

  /// Minimum length (for username)
  int? minLength;

  /// Maximum length (for username)
  int? maxLength;

  /// Whether to check password strength (for password)
  bool? checkStrength;

  /// Minimum age requirement (for dateOfBirth)
  int? minimumAge;

  /// Whether date of birth is required (for dateOfBirth)
  bool? requireDob;

  /// Whether location is required (for location)
  bool? requireLocation;

  /// Whether email choice is required (for emailChoice)
  bool? requireEmailChoice;

  FCFieldRequirement({
    required this.required,
    this.minLength,
    this.maxLength,
    this.checkStrength,
    this.minimumAge,
    this.requireDob,
    this.requireLocation,
    this.requireEmailChoice,
  });
}

/// Policy requirement for Terms of Service and Privacy Policy
@MappableClass()
class FCPolicyRequirement with FCPolicyRequirementMappable {
  /// Whether acceptance of this policy is required
  bool required;

  /// URL to the policy document
  String url;

  FCPolicyRequirement({
    required this.required,
    required this.url,
  });
}

/// CAPTCHA requirement configuration
@MappableClass()
class FCCaptchaRequirement with FCCaptchaRequirementMappable {
  /// Whether CAPTCHA is required
  bool required;

  /// CAPTCHA type: ReCaptcha, HCaptcha, Turnstile, TextCaptcha, KeyCaptcha
  String? type;

  /// Whether CAPTCHA is invisible
  bool? invisible;

  /// Site key for the CAPTCHA service
  String? siteKey;

  FCCaptchaRequirement({
    required this.required,
    this.type,
    this.invisible,
    this.siteKey,
  });
}

/// Registration requirements container
/// Contains all field requirements and configuration for building the registration form
@MappableClass()
class FCRegistrationRequirements with FCRegistrationRequirementsMappable {
  /// Username field requirements
  FCFieldRequirement? username;

  /// Email field requirements
  FCFieldRequirement? email;

  /// Password field requirements
  FCFieldRequirement? password;

  /// Date of birth field requirements
  FCFieldRequirement? dateOfBirth;

  /// Location field requirements
  FCFieldRequirement? location;

  /// Email choice field requirements
  FCFieldRequirement? emailChoice;

  /// Custom registration fields
  List<FCCustomFieldDefinition> customFields;

  /// CAPTCHA requirements
  FCCaptchaRequirement? captcha;

  /// Privacy policy requirements
  FCPolicyRequirement? privacyPolicy;

  /// Terms of service requirements
  FCPolicyRequirement? termsOfService;

  FCRegistrationRequirements({
    this.username,
    this.email,
    this.password,
    this.dateOfBirth,
    this.location,
    this.emailChoice,
    this.customFields = const [],
    this.captcha,
    this.privacyPolicy,
    this.termsOfService,
  });
}


