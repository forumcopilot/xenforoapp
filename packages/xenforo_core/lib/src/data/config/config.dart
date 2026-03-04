import 'package:dart_mappable/dart_mappable.dart';

part 'config.mapper.dart';

/// XenForo configuration data model
@MappableClass()
class XenForoConfig with XenForoConfigMappable {
  final String versionId;
  final String versionString;
  final String apiVersion;
  final String title;
  final String tagline;
  final String url;
  final String baseUrl;
  final String timezone;
  final String language;
  final String currency;
  final String dateFormat;
  final String timeFormat;
  final bool debugMode;
  final bool developmentMode;
  final bool maintenanceMode;
  final String maintenanceMessage;
  final Map<String, dynamic> options;
  final Map<String, dynamic> permissions;
  final Map<String, dynamic> features;

  const XenForoConfig({
    required this.versionId,
    required this.versionString,
    required this.apiVersion,
    required this.title,
    required this.tagline,
    required this.url,
    required this.baseUrl,
    required this.timezone,
    required this.language,
    required this.currency,
    required this.dateFormat,
    required this.timeFormat,
    required this.debugMode,
    required this.developmentMode,
    required this.maintenanceMode,
    required this.maintenanceMessage,
    required this.options,
    required this.permissions,
    required this.features,
  });

  factory XenForoConfig.fromJson(Map<String, dynamic> json) {
    return XenForoConfig(
      versionId: json['version_id']?.toString() ?? '',
      versionString: json['version_string']?.toString() ?? '',
      apiVersion: json['api_version']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      tagline: json['tagline']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      baseUrl: json['base_url']?.toString() ?? '',
      timezone: json['timezone']?.toString() ?? '',
      language: json['language']?.toString() ?? '',
      currency: json['currency']?.toString() ?? '',
      dateFormat: json['date_format']?.toString() ?? '',
      timeFormat: json['time_format']?.toString() ?? '',
      debugMode: json['debug_mode'] == true,
      developmentMode: json['development_mode'] == true,
      maintenanceMode: json['maintenance_mode'] == true,
      maintenanceMessage: json['maintenance_message']?.toString() ?? '',
      options: json['options'] as Map<String, dynamic>? ?? {},
      permissions: json['permissions'] as Map<String, dynamic>? ?? {},
      features: json['features'] as Map<String, dynamic>? ?? {},
    );
  }
}
