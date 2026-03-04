// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'node.dart';

class XenForoNodeMapper extends ClassMapperBase<XenForoNode> {
  XenForoNodeMapper._();

  static XenForoNodeMapper? _instance;
  static XenForoNodeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = XenForoNodeMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'XenForoNode';

  static List<Map<String, dynamic>>? _$breadcrumbs(XenForoNode v) =>
      v.breadcrumbs;
  static const Field<XenForoNode, List<Map<String, dynamic>>> _f$breadcrumbs =
      Field('breadcrumbs', _$breadcrumbs, opt: true);
  static Map<String, dynamic>? _$typeData(XenForoNode v) => v.typeData;
  static const Field<XenForoNode, Map<String, dynamic>> _f$typeData =
      Field('typeData', _$typeData, opt: true);
  static String? _$viewUrl(XenForoNode v) => v.viewUrl;
  static const Field<XenForoNode, String> _f$viewUrl =
      Field('viewUrl', _$viewUrl, opt: true);
  static int _$nodeId(XenForoNode v) => v.nodeId;
  static const Field<XenForoNode, int> _f$nodeId = Field('nodeId', _$nodeId);
  static String? _$title(XenForoNode v) => v.title;
  static const Field<XenForoNode, String> _f$title =
      Field('title', _$title, opt: true);
  static String? _$nodeName(XenForoNode v) => v.nodeName;
  static const Field<XenForoNode, String> _f$nodeName =
      Field('nodeName', _$nodeName, opt: true);
  static String? _$description(XenForoNode v) => v.description;
  static const Field<XenForoNode, String> _f$description =
      Field('description', _$description, opt: true);
  static String? _$nodeTypeId(XenForoNode v) => v.nodeTypeId;
  static const Field<XenForoNode, String> _f$nodeTypeId =
      Field('nodeTypeId', _$nodeTypeId, opt: true);
  static int? _$parentNodeId(XenForoNode v) => v.parentNodeId;
  static const Field<XenForoNode, int> _f$parentNodeId =
      Field('parentNodeId', _$parentNodeId, opt: true);
  static int? _$displayOrder(XenForoNode v) => v.displayOrder;
  static const Field<XenForoNode, int> _f$displayOrder =
      Field('displayOrder', _$displayOrder, opt: true);
  static bool? _$displayInList(XenForoNode v) => v.displayInList;
  static const Field<XenForoNode, bool> _f$displayInList =
      Field('displayInList', _$displayInList, opt: true);

  @override
  final MappableFields<XenForoNode> fields = const {
    #breadcrumbs: _f$breadcrumbs,
    #typeData: _f$typeData,
    #viewUrl: _f$viewUrl,
    #nodeId: _f$nodeId,
    #title: _f$title,
    #nodeName: _f$nodeName,
    #description: _f$description,
    #nodeTypeId: _f$nodeTypeId,
    #parentNodeId: _f$parentNodeId,
    #displayOrder: _f$displayOrder,
    #displayInList: _f$displayInList,
  };

  static XenForoNode _instantiate(DecodingData data) {
    return XenForoNode(
        breadcrumbs: data.dec(_f$breadcrumbs),
        typeData: data.dec(_f$typeData),
        viewUrl: data.dec(_f$viewUrl),
        nodeId: data.dec(_f$nodeId),
        title: data.dec(_f$title),
        nodeName: data.dec(_f$nodeName),
        description: data.dec(_f$description),
        nodeTypeId: data.dec(_f$nodeTypeId),
        parentNodeId: data.dec(_f$parentNodeId),
        displayOrder: data.dec(_f$displayOrder),
        displayInList: data.dec(_f$displayInList));
  }

  @override
  final Function instantiate = _instantiate;

  static XenForoNode fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<XenForoNode>(map);
  }

  static XenForoNode fromJson(String json) {
    return ensureInitialized().decodeJson<XenForoNode>(json);
  }
}

mixin XenForoNodeMappable {
  String toJson() {
    return XenForoNodeMapper.ensureInitialized()
        .encodeJson<XenForoNode>(this as XenForoNode);
  }

  Map<String, dynamic> toMap() {
    return XenForoNodeMapper.ensureInitialized()
        .encodeMap<XenForoNode>(this as XenForoNode);
  }

  XenForoNodeCopyWith<XenForoNode, XenForoNode, XenForoNode> get copyWith =>
      _XenForoNodeCopyWithImpl<XenForoNode, XenForoNode>(
          this as XenForoNode, $identity, $identity);
  @override
  String toString() {
    return XenForoNodeMapper.ensureInitialized()
        .stringifyValue(this as XenForoNode);
  }

  @override
  bool operator ==(Object other) {
    return XenForoNodeMapper.ensureInitialized()
        .equalsValue(this as XenForoNode, other);
  }

  @override
  int get hashCode {
    return XenForoNodeMapper.ensureInitialized().hashValue(this as XenForoNode);
  }
}

extension XenForoNodeValueCopy<$R, $Out>
    on ObjectCopyWith<$R, XenForoNode, $Out> {
  XenForoNodeCopyWith<$R, XenForoNode, $Out> get $asXenForoNode =>
      $base.as((v, t, t2) => _XenForoNodeCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class XenForoNodeCopyWith<$R, $In extends XenForoNode, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, Map<String, dynamic>,
          ObjectCopyWith<$R, Map<String, dynamic>, Map<String, dynamic>>>?
      get breadcrumbs;
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>?
      get typeData;
  $R call(
      {List<Map<String, dynamic>>? breadcrumbs,
      Map<String, dynamic>? typeData,
      String? viewUrl,
      int? nodeId,
      String? title,
      String? nodeName,
      String? description,
      String? nodeTypeId,
      int? parentNodeId,
      int? displayOrder,
      bool? displayInList});
  XenForoNodeCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _XenForoNodeCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, XenForoNode, $Out>
    implements XenForoNodeCopyWith<$R, XenForoNode, $Out> {
  _XenForoNodeCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<XenForoNode> $mapper =
      XenForoNodeMapper.ensureInitialized();
  @override
  ListCopyWith<$R, Map<String, dynamic>,
          ObjectCopyWith<$R, Map<String, dynamic>, Map<String, dynamic>>>?
      get breadcrumbs => $value.breadcrumbs != null
          ? ListCopyWith(
              $value.breadcrumbs!,
              (v, t) => ObjectCopyWith(v, $identity, t),
              (v) => call(breadcrumbs: v))
          : null;
  @override
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>?
      get typeData => $value.typeData != null
          ? MapCopyWith(
              $value.typeData!,
              (v, t) => ObjectCopyWith(v, $identity, t),
              (v) => call(typeData: v))
          : null;
  @override
  $R call(
          {Object? breadcrumbs = $none,
          Object? typeData = $none,
          Object? viewUrl = $none,
          int? nodeId,
          Object? title = $none,
          Object? nodeName = $none,
          Object? description = $none,
          Object? nodeTypeId = $none,
          Object? parentNodeId = $none,
          Object? displayOrder = $none,
          Object? displayInList = $none}) =>
      $apply(FieldCopyWithData({
        if (breadcrumbs != $none) #breadcrumbs: breadcrumbs,
        if (typeData != $none) #typeData: typeData,
        if (viewUrl != $none) #viewUrl: viewUrl,
        if (nodeId != null) #nodeId: nodeId,
        if (title != $none) #title: title,
        if (nodeName != $none) #nodeName: nodeName,
        if (description != $none) #description: description,
        if (nodeTypeId != $none) #nodeTypeId: nodeTypeId,
        if (parentNodeId != $none) #parentNodeId: parentNodeId,
        if (displayOrder != $none) #displayOrder: displayOrder,
        if (displayInList != $none) #displayInList: displayInList
      }));
  @override
  XenForoNode $make(CopyWithData data) => XenForoNode(
      breadcrumbs: data.get(#breadcrumbs, or: $value.breadcrumbs),
      typeData: data.get(#typeData, or: $value.typeData),
      viewUrl: data.get(#viewUrl, or: $value.viewUrl),
      nodeId: data.get(#nodeId, or: $value.nodeId),
      title: data.get(#title, or: $value.title),
      nodeName: data.get(#nodeName, or: $value.nodeName),
      description: data.get(#description, or: $value.description),
      nodeTypeId: data.get(#nodeTypeId, or: $value.nodeTypeId),
      parentNodeId: data.get(#parentNodeId, or: $value.parentNodeId),
      displayOrder: data.get(#displayOrder, or: $value.displayOrder),
      displayInList: data.get(#displayInList, or: $value.displayInList));

  @override
  XenForoNodeCopyWith<$R2, XenForoNode, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _XenForoNodeCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
