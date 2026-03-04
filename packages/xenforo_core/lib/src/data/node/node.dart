import 'package:dart_mappable/dart_mappable.dart';

part 'node.mapper.dart';

/// XenForo node data model based on official API documentation
@MappableClass()
class XenForoNode with XenForoNodeMappable {
  /// Breadcrumbs for this node
  final List<Map<String, dynamic>>? breadcrumbs;

  /// Data related to the specific node type
  final Map<String, dynamic>? typeData;

  /// View URL
  final String? viewUrl;

  /// Node ID
  final int nodeId;

  /// Title
  final String? title;

  /// Node name
  final String? nodeName;

  /// Description
  final String? description;

  /// Node type ID
  final String? nodeTypeId;

  /// Parent node ID
  final int? parentNodeId;

  /// Display order
  final int? displayOrder;

  /// Whether to display in list
  final bool? displayInList;

  const XenForoNode({
    this.breadcrumbs,
    this.typeData,
    this.viewUrl,
    required this.nodeId,
    this.title,
    this.nodeName,
    this.description,
    this.nodeTypeId,
    this.parentNodeId,
    this.displayOrder,
    this.displayInList,
  });

  factory XenForoNode.fromJson(Map<String, dynamic> json) {
    return XenForoNode(
      breadcrumbs: json['breadcrumbs'] != null ? (json['breadcrumbs'] as List).map((crumb) => Map<String, dynamic>.from(crumb)).toList() : null,
      typeData: json['type_data'] as Map<String, dynamic>?,
      viewUrl: json['view_url'],
      nodeId: json['node_id'] ?? 0,
      title: json['title'],
      nodeName: json['node_name'],
      description: json['description'],
      nodeTypeId: json['node_type_id'],
      parentNodeId: json['parent_node_id'],
      displayOrder: json['display_order'],
      displayInList: json['display_in_list'],
    );
  }

  // Convenience getters for backward compatibility
  String get id => nodeId.toString();
  String get nodeType => nodeTypeId ?? '';
  String get parentId => parentNodeId?.toString() ?? '';
  int get displayOrderValue => displayOrder ?? 0;
  String get displayStyle => ''; // Not available in API
  bool get isVisible => displayInList ?? true;
  bool get isActive => true; // Assume active if accessible
  String get url => viewUrl ?? '';
  String get logoUrl => ''; // Not available in API
  String get backgroundUrl => ''; // Not available in API
  Map<String, dynamic> get permissions => {}; // Not available in API
  Map<String, dynamic> get customFields => typeData ?? {};
  List<XenForoNode> get children => []; // Not available in API
}
