import 'package:dart_mappable/dart_mappable.dart';

part 'thread_field.mapper.dart';

/// XenForo thread field data model based on official API documentation
@MappableClass()
class XenForoThreadField with XenForoThreadFieldMappable {
  /// Field ID
  final String fieldId;

  /// Title
  final String? title;

  /// Description
  final String? description;

  /// Display order
  final int? displayOrder;

  /// Field type
  final String? fieldType;

  /// For choice types, an ordered list of choices
  final Map<String, dynamic>? fieldChoices;

  /// Match type
  final String? matchType;

  /// Match parameters
  final List<dynamic>? matchParams;

  /// Maximum length
  final int? maxLength;

  /// Whether field is required
  final bool? required;

  /// Display group
  final String? displayGroup;

  const XenForoThreadField({
    required this.fieldId,
    this.title,
    this.description,
    this.displayOrder,
    this.fieldType,
    this.fieldChoices,
    this.matchType,
    this.matchParams,
    this.maxLength,
    this.required,
    this.displayGroup,
  });

  factory XenForoThreadField.fromJson(Map<String, dynamic> json) {
    return XenForoThreadField(
      fieldId: json['field_id'] ?? '',
      title: json['title'],
      description: json['description'],
      displayOrder: json['display_order'],
      fieldType: json['field_type'],
      fieldChoices: json['field_choices'] as Map<String, dynamic>?,
      matchType: json['match_type'],
      matchParams: json['match_params'] as List<dynamic>?,
      maxLength: json['max_length'],
      required: json['required'],
      displayGroup: json['display_group'],
    );
  }

  // Convenience getters for backward compatibility
  String get id => fieldId;
  String get name => title ?? '';
  String get help => description ?? '';
  String get type => fieldType ?? '';
  bool get isRequired => required ?? false;
  int get maxLengthValue => maxLength ?? 0;
  String get group => displayGroup ?? '';
  int get order => displayOrder ?? 0;
  Map<String, dynamic> get choices => fieldChoices ?? {};
  String get matchTypeValue => matchType ?? '';
  List<dynamic> get matchParameters => matchParams ?? [];
}
