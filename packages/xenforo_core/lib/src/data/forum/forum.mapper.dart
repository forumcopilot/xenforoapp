// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'forum.dart';

class XenForoForumMapper extends ClassMapperBase<XenForoForum> {
  XenForoForumMapper._();

  static XenForoForumMapper? _instance;
  static XenForoForumMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = XenForoForumMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'XenForoForum';

  static String? _$forumTypeId(XenForoForum v) => v.forumTypeId;
  static const Field<XenForoForum, String> _f$forumTypeId = Field(
    'forumTypeId',
    _$forumTypeId,
    opt: true,
  );
  static bool? _$allowPosting(XenForoForum v) => v.allowPosting;
  static const Field<XenForoForum, bool> _f$allowPosting = Field(
    'allowPosting',
    _$allowPosting,
    opt: true,
  );
  static bool? _$requirePrefix(XenForoForum v) => v.requirePrefix;
  static const Field<XenForoForum, bool> _f$requirePrefix = Field(
    'requirePrefix',
    _$requirePrefix,
    opt: true,
  );
  static int? _$minTags(XenForoForum v) => v.minTags;
  static const Field<XenForoForum, int> _f$minTags = Field(
    'minTags',
    _$minTags,
    opt: true,
  );

  @override
  final MappableFields<XenForoForum> fields = const {
    #forumTypeId: _f$forumTypeId,
    #allowPosting: _f$allowPosting,
    #requirePrefix: _f$requirePrefix,
    #minTags: _f$minTags,
  };

  static XenForoForum _instantiate(DecodingData data) {
    return XenForoForum(
      forumTypeId: data.dec(_f$forumTypeId),
      allowPosting: data.dec(_f$allowPosting),
      requirePrefix: data.dec(_f$requirePrefix),
      minTags: data.dec(_f$minTags),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static XenForoForum fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<XenForoForum>(map);
  }

  static XenForoForum fromJson(String json) {
    return ensureInitialized().decodeJson<XenForoForum>(json);
  }
}

mixin XenForoForumMappable {
  String toJson() {
    return XenForoForumMapper.ensureInitialized().encodeJson<XenForoForum>(
      this as XenForoForum,
    );
  }

  Map<String, dynamic> toMap() {
    return XenForoForumMapper.ensureInitialized().encodeMap<XenForoForum>(
      this as XenForoForum,
    );
  }

  XenForoForumCopyWith<XenForoForum, XenForoForum, XenForoForum> get copyWith =>
      _XenForoForumCopyWithImpl<XenForoForum, XenForoForum>(
        this as XenForoForum,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return XenForoForumMapper.ensureInitialized().stringifyValue(
      this as XenForoForum,
    );
  }

  @override
  bool operator ==(Object other) {
    return XenForoForumMapper.ensureInitialized().equalsValue(
      this as XenForoForum,
      other,
    );
  }

  @override
  int get hashCode {
    return XenForoForumMapper.ensureInitialized().hashValue(
      this as XenForoForum,
    );
  }
}

extension XenForoForumValueCopy<$R, $Out>
    on ObjectCopyWith<$R, XenForoForum, $Out> {
  XenForoForumCopyWith<$R, XenForoForum, $Out> get $asXenForoForum =>
      $base.as((v, t, t2) => _XenForoForumCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class XenForoForumCopyWith<$R, $In extends XenForoForum, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? forumTypeId,
    bool? allowPosting,
    bool? requirePrefix,
    int? minTags,
  });
  XenForoForumCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _XenForoForumCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, XenForoForum, $Out>
    implements XenForoForumCopyWith<$R, XenForoForum, $Out> {
  _XenForoForumCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<XenForoForum> $mapper =
      XenForoForumMapper.ensureInitialized();
  @override
  $R call({
    Object? forumTypeId = $none,
    Object? allowPosting = $none,
    Object? requirePrefix = $none,
    Object? minTags = $none,
  }) => $apply(
    FieldCopyWithData({
      if (forumTypeId != $none) #forumTypeId: forumTypeId,
      if (allowPosting != $none) #allowPosting: allowPosting,
      if (requirePrefix != $none) #requirePrefix: requirePrefix,
      if (minTags != $none) #minTags: minTags,
    }),
  );
  @override
  XenForoForum $make(CopyWithData data) => XenForoForum(
    forumTypeId: data.get(#forumTypeId, or: $value.forumTypeId),
    allowPosting: data.get(#allowPosting, or: $value.allowPosting),
    requirePrefix: data.get(#requirePrefix, or: $value.requirePrefix),
    minTags: data.get(#minTags, or: $value.minTags),
  );

  @override
  XenForoForumCopyWith<$R2, XenForoForum, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _XenForoForumCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

