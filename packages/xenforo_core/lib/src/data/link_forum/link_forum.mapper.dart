// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'link_forum.dart';

class XenForoLinkForumMapper extends ClassMapperBase<XenForoLinkForum> {
  XenForoLinkForumMapper._();

  static XenForoLinkForumMapper? _instance;
  static XenForoLinkForumMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = XenForoLinkForumMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'XenForoLinkForum';

  static String? _$linkUrl(XenForoLinkForum v) => v.linkUrl;
  static const Field<XenForoLinkForum, String> _f$linkUrl =
      Field('linkUrl', _$linkUrl, opt: true);
  static int? _$redirectCount(XenForoLinkForum v) => v.redirectCount;
  static const Field<XenForoLinkForum, int> _f$redirectCount =
      Field('redirectCount', _$redirectCount, opt: true);

  @override
  final MappableFields<XenForoLinkForum> fields = const {
    #linkUrl: _f$linkUrl,
    #redirectCount: _f$redirectCount,
  };

  static XenForoLinkForum _instantiate(DecodingData data) {
    return XenForoLinkForum(
        linkUrl: data.dec(_f$linkUrl),
        redirectCount: data.dec(_f$redirectCount));
  }

  @override
  final Function instantiate = _instantiate;

  static XenForoLinkForum fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<XenForoLinkForum>(map);
  }

  static XenForoLinkForum fromJson(String json) {
    return ensureInitialized().decodeJson<XenForoLinkForum>(json);
  }
}

mixin XenForoLinkForumMappable {
  String toJson() {
    return XenForoLinkForumMapper.ensureInitialized()
        .encodeJson<XenForoLinkForum>(this as XenForoLinkForum);
  }

  Map<String, dynamic> toMap() {
    return XenForoLinkForumMapper.ensureInitialized()
        .encodeMap<XenForoLinkForum>(this as XenForoLinkForum);
  }

  XenForoLinkForumCopyWith<XenForoLinkForum, XenForoLinkForum, XenForoLinkForum>
      get copyWith =>
          _XenForoLinkForumCopyWithImpl<XenForoLinkForum, XenForoLinkForum>(
              this as XenForoLinkForum, $identity, $identity);
  @override
  String toString() {
    return XenForoLinkForumMapper.ensureInitialized()
        .stringifyValue(this as XenForoLinkForum);
  }

  @override
  bool operator ==(Object other) {
    return XenForoLinkForumMapper.ensureInitialized()
        .equalsValue(this as XenForoLinkForum, other);
  }

  @override
  int get hashCode {
    return XenForoLinkForumMapper.ensureInitialized()
        .hashValue(this as XenForoLinkForum);
  }
}

extension XenForoLinkForumValueCopy<$R, $Out>
    on ObjectCopyWith<$R, XenForoLinkForum, $Out> {
  XenForoLinkForumCopyWith<$R, XenForoLinkForum, $Out>
      get $asXenForoLinkForum => $base
          .as((v, t, t2) => _XenForoLinkForumCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class XenForoLinkForumCopyWith<$R, $In extends XenForoLinkForum, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? linkUrl, int? redirectCount});
  XenForoLinkForumCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _XenForoLinkForumCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, XenForoLinkForum, $Out>
    implements XenForoLinkForumCopyWith<$R, XenForoLinkForum, $Out> {
  _XenForoLinkForumCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<XenForoLinkForum> $mapper =
      XenForoLinkForumMapper.ensureInitialized();
  @override
  $R call({Object? linkUrl = $none, Object? redirectCount = $none}) =>
      $apply(FieldCopyWithData({
        if (linkUrl != $none) #linkUrl: linkUrl,
        if (redirectCount != $none) #redirectCount: redirectCount
      }));
  @override
  XenForoLinkForum $make(CopyWithData data) => XenForoLinkForum(
      linkUrl: data.get(#linkUrl, or: $value.linkUrl),
      redirectCount: data.get(#redirectCount, or: $value.redirectCount));

  @override
  XenForoLinkForumCopyWith<$R2, XenForoLinkForum, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _XenForoLinkForumCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
