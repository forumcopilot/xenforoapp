import 'package:dart_mappable/dart_mappable.dart';

part 'fc_thanks.mapper.dart';

/// FCThanks (Forum Consolidated Thanks) represents a thank you on a post
@MappableClass()
class FCThanks with FCThanksMappable {
  /// User ID who thanked the post
  String userId;

  /// Username who thanked the post
  String username;

  /// Avatar URL of the user who thanked the post
  String avatarUrl;

  /// Timestamp when the thanks was given
  DateTime? timestamp;

  FCThanks({
    required this.userId,
    required this.username,
    required this.avatarUrl,
    this.timestamp,
  });
}
