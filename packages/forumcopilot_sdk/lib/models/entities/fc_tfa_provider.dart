import 'package:dart_mappable/dart_mappable.dart';

part 'fc_tfa_provider.mapper.dart';

/// Two-Factor Authentication Provider
/// Represents an available TFA method for a user
@MappableClass()
class FCTFAProvider with FCTFAProviderMappable {
  /// Provider identifier: "totp", "email", or "backup"
  String id;

  /// Display title for the provider
  String title;

  /// Description of the provider
  String description;

  /// Provider type: "passkey" or "code"
  String? type;

  FCTFAProvider({
    required this.id,
    required this.title,
    required this.description,
    this.type,
  });
}
