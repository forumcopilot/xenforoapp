// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'thread_prefix.dart';

class XenForoThreadPrefixMapper extends ClassMapperBase<XenForoThreadPrefix> {
  XenForoThreadPrefixMapper._();

  static XenForoThreadPrefixMapper? _instance;
  static XenForoThreadPrefixMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = XenForoThreadPrefixMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'XenForoThreadPrefix';

  static int _$prefixId(XenForoThreadPrefix v) => v.prefixId;
  static const Field<XenForoThreadPrefix, int> _f$prefixId =
      Field('prefixId', _$prefixId);
  static String? _$title(XenForoThreadPrefix v) => v.title;
  static const Field<XenForoThreadPrefix, String> _f$title =
      Field('title', _$title, opt: true);
  static String? _$description(XenForoThreadPrefix v) => v.description;
  static const Field<XenForoThreadPrefix, String> _f$description =
      Field('description', _$description, opt: true);
  static String? _$usageHelp(XenForoThreadPrefix v) => v.usageHelp;
  static const Field<XenForoThreadPrefix, String> _f$usageHelp =
      Field('usageHelp', _$usageHelp, opt: true);
  static bool? _$isUsable(XenForoThreadPrefix v) => v.isUsable;
  static const Field<XenForoThreadPrefix, bool> _f$isUsable =
      Field('isUsable', _$isUsable, opt: true);
  static int? _$prefixGroupId(XenForoThreadPrefix v) => v.prefixGroupId;
  static const Field<XenForoThreadPrefix, int> _f$prefixGroupId =
      Field('prefixGroupId', _$prefixGroupId, opt: true);
  static int? _$displayOrder(XenForoThreadPrefix v) => v.displayOrder;
  static const Field<XenForoThreadPrefix, int> _f$displayOrder =
      Field('displayOrder', _$displayOrder, opt: true);
  static int? _$materializedOrder(XenForoThreadPrefix v) => v.materializedOrder;
  static const Field<XenForoThreadPrefix, int> _f$materializedOrder =
      Field('materializedOrder', _$materializedOrder, opt: true);

  @override
  final MappableFields<XenForoThreadPrefix> fields = const {
    #prefixId: _f$prefixId,
    #title: _f$title,
    #description: _f$description,
    #usageHelp: _f$usageHelp,
    #isUsable: _f$isUsable,
    #prefixGroupId: _f$prefixGroupId,
    #displayOrder: _f$displayOrder,
    #materializedOrder: _f$materializedOrder,
  };

  static XenForoThreadPrefix _instantiate(DecodingData data) {
    return XenForoThreadPrefix(
        prefixId: data.dec(_f$prefixId),
        title: data.dec(_f$title),
        description: data.dec(_f$description),
        usageHelp: data.dec(_f$usageHelp),
        isUsable: data.dec(_f$isUsable),
        prefixGroupId: data.dec(_f$prefixGroupId),
        displayOrder: data.dec(_f$displayOrder),
        materializedOrder: data.dec(_f$materializedOrder));
  }

  @override
  final Function instantiate = _instantiate;

  static XenForoThreadPrefix fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<XenForoThreadPrefix>(map);
  }

  static XenForoThreadPrefix fromJson(String json) {
    return ensureInitialized().decodeJson<XenForoThreadPrefix>(json);
  }
}

mixin XenForoThreadPrefixMappable {
  String toJson() {
    return XenForoThreadPrefixMapper.ensureInitialized()
        .encodeJson<XenForoThreadPrefix>(this as XenForoThreadPrefix);
  }

  Map<String, dynamic> toMap() {
    return XenForoThreadPrefixMapper.ensureInitialized()
        .encodeMap<XenForoThreadPrefix>(this as XenForoThreadPrefix);
  }

  XenForoThreadPrefixCopyWith<XenForoThreadPrefix, XenForoThreadPrefix,
      XenForoThreadPrefix> get copyWith => _XenForoThreadPrefixCopyWithImpl<
          XenForoThreadPrefix, XenForoThreadPrefix>(
      this as XenForoThreadPrefix, $identity, $identity);
  @override
  String toString() {
    return XenForoThreadPrefixMapper.ensureInitialized()
        .stringifyValue(this as XenForoThreadPrefix);
  }

  @override
  bool operator ==(Object other) {
    return XenForoThreadPrefixMapper.ensureInitialized()
        .equalsValue(this as XenForoThreadPrefix, other);
  }

  @override
  int get hashCode {
    return XenForoThreadPrefixMapper.ensureInitialized()
        .hashValue(this as XenForoThreadPrefix);
  }
}

extension XenForoThreadPrefixValueCopy<$R, $Out>
    on ObjectCopyWith<$R, XenForoThreadPrefix, $Out> {
  XenForoThreadPrefixCopyWith<$R, XenForoThreadPrefix, $Out>
      get $asXenForoThreadPrefix => $base.as(
          (v, t, t2) => _XenForoThreadPrefixCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class XenForoThreadPrefixCopyWith<$R, $In extends XenForoThreadPrefix,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {int? prefixId,
      String? title,
      String? description,
      String? usageHelp,
      bool? isUsable,
      int? prefixGroupId,
      int? displayOrder,
      int? materializedOrder});
  XenForoThreadPrefixCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _XenForoThreadPrefixCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, XenForoThreadPrefix, $Out>
    implements XenForoThreadPrefixCopyWith<$R, XenForoThreadPrefix, $Out> {
  _XenForoThreadPrefixCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<XenForoThreadPrefix> $mapper =
      XenForoThreadPrefixMapper.ensureInitialized();
  @override
  $R call(
          {int? prefixId,
          Object? title = $none,
          Object? description = $none,
          Object? usageHelp = $none,
          Object? isUsable = $none,
          Object? prefixGroupId = $none,
          Object? displayOrder = $none,
          Object? materializedOrder = $none}) =>
      $apply(FieldCopyWithData({
        if (prefixId != null) #prefixId: prefixId,
        if (title != $none) #title: title,
        if (description != $none) #description: description,
        if (usageHelp != $none) #usageHelp: usageHelp,
        if (isUsable != $none) #isUsable: isUsable,
        if (prefixGroupId != $none) #prefixGroupId: prefixGroupId,
        if (displayOrder != $none) #displayOrder: displayOrder,
        if (materializedOrder != $none) #materializedOrder: materializedOrder
      }));
  @override
  XenForoThreadPrefix $make(CopyWithData data) => XenForoThreadPrefix(
      prefixId: data.get(#prefixId, or: $value.prefixId),
      title: data.get(#title, or: $value.title),
      description: data.get(#description, or: $value.description),
      usageHelp: data.get(#usageHelp, or: $value.usageHelp),
      isUsable: data.get(#isUsable, or: $value.isUsable),
      prefixGroupId: data.get(#prefixGroupId, or: $value.prefixGroupId),
      displayOrder: data.get(#displayOrder, or: $value.displayOrder),
      materializedOrder:
          data.get(#materializedOrder, or: $value.materializedOrder));

  @override
  XenForoThreadPrefixCopyWith<$R2, XenForoThreadPrefix, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _XenForoThreadPrefixCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
