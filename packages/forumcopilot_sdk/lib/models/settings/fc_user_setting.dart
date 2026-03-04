import 'package:dart_mappable/dart_mappable.dart';

part 'fc_user_setting.mapper.dart';

/// Field dependency condition
@MappableClass()
class FCSettingDependency with FCSettingDependencyMappable {
  /// Field ID that this setting depends on
  String key;

  /// Value that the dependency field must have for this setting to be shown
  dynamic value;

  FCSettingDependency({
    required this.key,
    required this.value,
  });
}

/// User setting item (extends FCCustomFieldDefinition structure)
@MappableClass()
class FCUserSetting with FCUserSettingMappable {
  /// Field identifier
  String fieldId;

  /// Display title
  String title;

  /// Description/help text
  String description;

  /// UI field type: toggle, checkbox, radio, select, multiselect, textbox, textarea, number
  String fieldType;

  /// Data type: boolean, string, number, array
  String dataType;

  /// Current value
  dynamic value;

  /// Default value
  dynamic defaultValue;

  /// Choices for choice-based fields (radio, select, multiselect)
  Map<String, String>? choices;

  /// Whether this setting is required
  bool required;

  /// Whether this setting is read-only
  bool readOnly;

  /// Maximum length for text fields
  int? maxLength;

  /// Validation match type (e.g., "email", "url", "number")
  String? matchType;

  /// Additional validation parameters
  Map<String, dynamic>? matchParams;

  /// Minimum value for number fields
  num? min;

  /// Maximum value for number fields
  num? max;

  /// Regex pattern for validation
  String? pattern;

  /// Placeholder text for text inputs
  String? placeholder;

  /// Display order
  int displayOrder;

  /// Group identifier for organizing settings visually
  String? group;

  /// Conditional display dependency
  FCSettingDependency? dependsOn;

  FCUserSetting({
    required this.fieldId,
    required this.title,
    required this.description,
    required this.fieldType,
    required this.dataType,
    required this.value,
    required this.defaultValue,
    this.choices,
    this.required = false,
    this.readOnly = false,
    this.maxLength,
    this.matchType,
    this.matchParams,
    this.min,
    this.max,
    this.pattern,
    this.placeholder,
    this.displayOrder = 0,
    this.group,
    this.dependsOn,
  });
}

