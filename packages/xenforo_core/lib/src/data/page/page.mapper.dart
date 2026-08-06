// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'page.dart';

class XenForoPageMapper extends ClassMapperBase<XenForoPage> {
  XenForoPageMapper._();

  static XenForoPageMapper? _instance;
  static XenForoPageMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = XenForoPageMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'XenForoPage';

  static int? _$publishDate(XenForoPage v) => v.publishDate;
  static const Field<XenForoPage, int> _f$publishDate = Field(
    'publishDate',
    _$publishDate,
    opt: true,
  );
  static int? _$viewCount(XenForoPage v) => v.viewCount;
  static const Field<XenForoPage, int> _f$viewCount = Field(
    'viewCount',
    _$viewCount,
    opt: true,
  );

  @override
  final MappableFields<XenForoPage> fields = const {
    #publishDate: _f$publishDate,
    #viewCount: _f$viewCount,
  };

  static XenForoPage _instantiate(DecodingData data) {
    return XenForoPage(
      publishDate: data.dec(_f$publishDate),
      viewCount: data.dec(_f$viewCount),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static XenForoPage fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<XenForoPage>(map);
  }

  static XenForoPage fromJson(String json) {
    return ensureInitialized().decodeJson<XenForoPage>(json);
  }
}

mixin XenForoPageMappable {
  String toJson() {
    return XenForoPageMapper.ensureInitialized().encodeJson<XenForoPage>(
      this as XenForoPage,
    );
  }

  Map<String, dynamic> toMap() {
    return XenForoPageMapper.ensureInitialized().encodeMap<XenForoPage>(
      this as XenForoPage,
    );
  }

  XenForoPageCopyWith<XenForoPage, XenForoPage, XenForoPage> get copyWith =>
      _XenForoPageCopyWithImpl<XenForoPage, XenForoPage>(
        this as XenForoPage,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return XenForoPageMapper.ensureInitialized().stringifyValue(
      this as XenForoPage,
    );
  }

  @override
  bool operator ==(Object other) {
    return XenForoPageMapper.ensureInitialized().equalsValue(
      this as XenForoPage,
      other,
    );
  }

  @override
  int get hashCode {
    return XenForoPageMapper.ensureInitialized().hashValue(this as XenForoPage);
  }
}

extension XenForoPageValueCopy<$R, $Out>
    on ObjectCopyWith<$R, XenForoPage, $Out> {
  XenForoPageCopyWith<$R, XenForoPage, $Out> get $asXenForoPage =>
      $base.as((v, t, t2) => _XenForoPageCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class XenForoPageCopyWith<$R, $In extends XenForoPage, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({int? publishDate, int? viewCount});
  XenForoPageCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _XenForoPageCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, XenForoPage, $Out>
    implements XenForoPageCopyWith<$R, XenForoPage, $Out> {
  _XenForoPageCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<XenForoPage> $mapper =
      XenForoPageMapper.ensureInitialized();
  @override
  $R call({Object? publishDate = $none, Object? viewCount = $none}) => $apply(
    FieldCopyWithData({
      if (publishDate != $none) #publishDate: publishDate,
      if (viewCount != $none) #viewCount: viewCount,
    }),
  );
  @override
  XenForoPage $make(CopyWithData data) => XenForoPage(
    publishDate: data.get(#publishDate, or: $value.publishDate),
    viewCount: data.get(#viewCount, or: $value.viewCount),
  );

  @override
  XenForoPageCopyWith<$R2, XenForoPage, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _XenForoPageCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

