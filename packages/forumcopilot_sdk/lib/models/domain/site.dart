import 'package:dart_mappable/dart_mappable.dart';

part 'site.mapper.dart';

@MappableClass()
class Site with SiteMappable {
  final int? id;
  final String name;
  final String url;
  final String description;
  final String? logoUrl;
  final String? backgroundUrl;
  final String? endpoint;
  final String? baseUrl;
  final String siteType;
  final String? language;
  final String? country;

  const Site({
    this.id,
    required this.name,
    required this.url,
    required this.description,
    this.logoUrl,
    this.backgroundUrl,
    this.endpoint,
    this.baseUrl,
    required this.siteType,
    this.language,
    this.country,
  });

  /// Get the full URL (baseUrl + endpoint)
  String get pluginUrl {
    if (baseUrl == null || baseUrl!.isEmpty) return url;
    if (endpoint == null || endpoint!.isEmpty) return baseUrl!;

    String cleanBaseUrl = baseUrl!.endsWith('/') ? baseUrl!.substring(0, baseUrl!.length - 1) : baseUrl!;
    String cleanEndpoint = endpoint!.startsWith('/') ? endpoint!.substring(1) : endpoint!;

    return '$cleanBaseUrl/$cleanEndpoint';
  }

  String get extension {
    return pluginUrl.split('.').last;
  }

  /// Get display name (name or URL if name is empty)
  String get displayName => name.isNotEmpty ? name : url;

  /// Check if this is a valid site
  bool get isValid => url.isNotEmpty;

  @override
  String toString() => 'Site(id: $id, name: $name, url: $url)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Site && other.id == id && other.url == url;
  }

  @override
  int get hashCode => id.hashCode ^ url.hashCode;
}
