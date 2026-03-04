import 'package:dart_mappable/dart_mappable.dart';

part 'search.mapper.dart';

/// XenForo search data model based on official API documentation
@MappableClass()
class XenForoSearch with XenForoSearchMappable {
  /// Search ID
  final int searchId;

  /// Result count
  final int? resultCount;

  /// Search type
  final String? searchType;

  /// Search query
  final String? searchQuery;

  /// Search constraints
  final List<dynamic>? searchConstraints;

  /// Search order
  final String? searchOrder;

  /// Search grouping
  final bool? searchGrouping;

  /// Warnings
  final List<dynamic>? warnings;

  /// User ID
  final int? userId;

  /// Search date (Unix timestamp)
  final int? searchDate;

  /// Query hash
  final String? queryHash;

  const XenForoSearch({
    required this.searchId,
    this.resultCount,
    this.searchType,
    this.searchQuery,
    this.searchConstraints,
    this.searchOrder,
    this.searchGrouping,
    this.warnings,
    this.userId,
    this.searchDate,
    this.queryHash,
  });

  factory XenForoSearch.fromJson(Map<String, dynamic> json) {
    return XenForoSearch(
      searchId: json['search_id'] ?? 0,
      resultCount: json['result_count'],
      searchType: json['search_type'],
      searchQuery: json['search_query'],
      searchConstraints: json['search_constraints'] as List<dynamic>?,
      searchOrder: json['search_order'],
      searchGrouping: json['search_grouping'],
      warnings: json['warnings'] as List<dynamic>?,
      userId: json['user_id'],
      searchDate: json['search_date'],
      queryHash: json['query_hash'],
    );
  }

  // Convenience getters for backward compatibility
  String get id => searchId.toString();
  DateTime get searchDateTime => searchDate != null ? DateTime.fromMillisecondsSinceEpoch(searchDate! * 1000) : DateTime.now();
  String get query => searchQuery ?? '';
  int get totalResults => resultCount ?? 0;
  String get type => searchType ?? '';
  bool get isGrouped => searchGrouping ?? false;
  String get order => searchOrder ?? '';
  List<dynamic> get constraints => searchConstraints ?? [];
  List<dynamic> get warningList => warnings ?? [];
}
