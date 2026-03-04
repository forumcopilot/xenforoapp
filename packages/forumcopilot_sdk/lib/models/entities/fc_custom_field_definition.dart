import 'package:dart_mappable/dart_mappable.dart';

part 'fc_custom_field_definition.mapper.dart';

@MappableClass()
class FCCustomFieldDefinition with FCCustomFieldDefinitionMappable {
  String name;

  String description;

  String key;

  /// Field ID (preferred over key for new API responses)
  String? fieldId;

  String type;

  String format;

  dynamic defaultValue;

  String options;

  /// Display order for custom fields
  int? displayOrder;

  /// Choices as a map (alternative to parsing options string)
  Map<String, String>? choices;

  /// Whether this field is required
  bool required;

  /// Maximum length for text fields
  int? maxLength;

  FCCustomFieldDefinition({
    required this.name,
    required this.description,
    required this.key,
    this.fieldId,
    required this.type,
    required this.format,
    required this.defaultValue,
    required this.options,
    this.displayOrder,
    this.choices,
    this.required = false,
    this.maxLength,
  });

  /// Get the field identifier, preferring fieldId over key
  String get identifier => fieldId ?? key;
}
