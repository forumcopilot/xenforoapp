import 'package:dart_mappable/dart_mappable.dart';

part 'thread_prefix.mapper.dart';

/// XenForo thread prefix data model based on official API documentation
@MappableClass()
class XenForoThreadPrefix with XenForoThreadPrefixMappable {
  /// Prefix ID
  final int prefixId;

  /// Title
  final String? title;

  /// Description
  final String? description;

  /// Usage help
  final String? usageHelp;

  /// Whether the acting user can use (select) this prefix
  final bool? isUsable;

  /// Prefix group ID
  final int? prefixGroupId;

  /// Display order
  final int? displayOrder;

  /// Effective order, taking group ordering into account
  final int? materializedOrder;

  const XenForoThreadPrefix({
    required this.prefixId,
    this.title,
    this.description,
    this.usageHelp,
    this.isUsable,
    this.prefixGroupId,
    this.displayOrder,
    this.materializedOrder,
  });

  factory XenForoThreadPrefix.fromJson(Map<String, dynamic> json) {
    return XenForoThreadPrefix(
      prefixId: json['prefix_id'] ?? 0,
      title: json['title'],
      description: json['description'],
      usageHelp: json['usage_help'],
      isUsable: json['is_usable'],
      prefixGroupId: json['prefix_group_id'],
      displayOrder: json['display_order'],
      materializedOrder: json['materialized_order'],
    );
  }

  // Convenience getters for backward compatibility
  String get id => prefixId.toString();
  String get name => title ?? '';
  String get help => usageHelp ?? '';
  bool get canUse => isUsable ?? false;
  int get groupId => prefixGroupId ?? 0;
  int get order => displayOrder ?? 0;
  int get effectiveOrder => materializedOrder ?? displayOrder ?? 0;
}
