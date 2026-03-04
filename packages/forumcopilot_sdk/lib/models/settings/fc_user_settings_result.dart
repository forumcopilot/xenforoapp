import 'package:dart_mappable/dart_mappable.dart';
import 'package:forumcopilot_sdk/models/results/fc_base_result.dart';
import 'package:forumcopilot_sdk/models/settings/fc_user_setting.dart';
import 'package:forumcopilot_sdk/models/settings/fc_settings_category.dart';

part 'fc_user_settings_result.mapper.dart';

/// Result from getUserSettingsCategories API
@MappableClass()
class FCUserSettingsCategoriesResult extends FCBaseResult with FCUserSettingsCategoriesResultMappable {
  /// List of available categories
  List<FCSettingsCategory> categories;

  FCUserSettingsCategoriesResult({
    required bool result,
    String? resultText,
    this.categories = const [],
  }) : super(result: result, resultText: resultText);
}

/// Result from getUserSettings and updateUserSettings APIs
@MappableClass()
class FCUserSettingsResult extends FCBaseResult with FCUserSettingsResultMappable {
  /// The category that was requested/updated
  String category;

  /// Whether this category is enabled/available
  bool enabled;

  /// List of settings for this category
  List<FCUserSetting> settings;

  FCUserSettingsResult({
    required bool result,
    String? resultText,
    required this.category,
    required this.enabled,
    this.settings = const [],
  }) : super(result: result, resultText: resultText);
}

