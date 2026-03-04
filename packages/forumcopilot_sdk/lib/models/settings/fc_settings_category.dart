import 'package:dart_mappable/dart_mappable.dart';

part 'fc_settings_category.mapper.dart';

/// Settings category from getUserSettingsCategories API
@MappableClass()
class FCSettingsCategory with FCSettingsCategoryMappable {
  /// Category identifier (e.g., "push_notifications")
  String key;

  /// Human-readable category name
  String displayName;

  /// Category description
  String description;

  /// Whether this category is enabled/available
  bool enabled;

  FCSettingsCategory({
    required this.key,
    required this.displayName,
    required this.description,
    required this.enabled,
  });
}

