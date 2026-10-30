// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fc_forum_info.dart';

class FCForumNoticeMapper extends ClassMapperBase<FCForumNotice> {
  FCForumNoticeMapper._();

  static FCForumNoticeMapper? _instance;
  static FCForumNoticeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCForumNoticeMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FCForumNotice';

  static int _$id(FCForumNotice v) => v.id;
  static const Field<FCForumNotice, int> _f$id = Field('id', _$id);
  static String _$type(FCForumNotice v) => v.type;
  static const Field<FCForumNotice, String> _f$type = Field(
    'type',
    _$type,
    opt: true,
    def: 'block',
  );
  static String _$title(FCForumNotice v) => v.title;
  static const Field<FCForumNotice, String> _f$title = Field(
    'title',
    _$title,
    opt: true,
    def: '',
  );
  static String _$message(FCForumNotice v) => v.message;
  static const Field<FCForumNotice, String> _f$message = Field(
    'message',
    _$message,
    opt: true,
    def: '',
  );
  static bool _$dismissible(FCForumNotice v) => v.dismissible;
  static const Field<FCForumNotice, bool> _f$dismissible = Field(
    'dismissible',
    _$dismissible,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<FCForumNotice> fields = const {
    #id: _f$id,
    #type: _f$type,
    #title: _f$title,
    #message: _f$message,
    #dismissible: _f$dismissible,
  };

  static FCForumNotice _instantiate(DecodingData data) {
    return FCForumNotice(
      id: data.dec(_f$id),
      type: data.dec(_f$type),
      title: data.dec(_f$title),
      message: data.dec(_f$message),
      dismissible: data.dec(_f$dismissible),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCForumNotice fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCForumNotice>(map);
  }

  static FCForumNotice fromJson(String json) {
    return ensureInitialized().decodeJson<FCForumNotice>(json);
  }
}

mixin FCForumNoticeMappable {
  String toJson() {
    return FCForumNoticeMapper.ensureInitialized().encodeJson<FCForumNotice>(
      this as FCForumNotice,
    );
  }

  Map<String, dynamic> toMap() {
    return FCForumNoticeMapper.ensureInitialized().encodeMap<FCForumNotice>(
      this as FCForumNotice,
    );
  }

  FCForumNoticeCopyWith<FCForumNotice, FCForumNotice, FCForumNotice>
  get copyWith => _FCForumNoticeCopyWithImpl<FCForumNotice, FCForumNotice>(
    this as FCForumNotice,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return FCForumNoticeMapper.ensureInitialized().stringifyValue(
      this as FCForumNotice,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCForumNoticeMapper.ensureInitialized().equalsValue(
      this as FCForumNotice,
      other,
    );
  }

  @override
  int get hashCode {
    return FCForumNoticeMapper.ensureInitialized().hashValue(
      this as FCForumNotice,
    );
  }
}

extension FCForumNoticeValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCForumNotice, $Out> {
  FCForumNoticeCopyWith<$R, FCForumNotice, $Out> get $asFCForumNotice =>
      $base.as((v, t, t2) => _FCForumNoticeCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCForumNoticeCopyWith<$R, $In extends FCForumNotice, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    int? id,
    String? type,
    String? title,
    String? message,
    bool? dismissible,
  });
  FCForumNoticeCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FCForumNoticeCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCForumNotice, $Out>
    implements FCForumNoticeCopyWith<$R, FCForumNotice, $Out> {
  _FCForumNoticeCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCForumNotice> $mapper =
      FCForumNoticeMapper.ensureInitialized();
  @override
  $R call({
    int? id,
    String? type,
    String? title,
    String? message,
    bool? dismissible,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (type != null) #type: type,
      if (title != null) #title: title,
      if (message != null) #message: message,
      if (dismissible != null) #dismissible: dismissible,
    }),
  );
  @override
  FCForumNotice $make(CopyWithData data) => FCForumNotice(
    id: data.get(#id, or: $value.id),
    type: data.get(#type, or: $value.type),
    title: data.get(#title, or: $value.title),
    message: data.get(#message, or: $value.message),
    dismissible: data.get(#dismissible, or: $value.dismissible),
  );

  @override
  FCForumNoticeCopyWith<$R2, FCForumNotice, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCForumNoticeCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCForumPageMapper extends ClassMapperBase<FCForumPage> {
  FCForumPageMapper._();

  static FCForumPageMapper? _instance;
  static FCForumPageMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCForumPageMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FCForumPage';

  static String _$title(FCForumPage v) => v.title;
  static const Field<FCForumPage, String> _f$title = Field('title', _$title);
  static String _$url(FCForumPage v) => v.url;
  static const Field<FCForumPage, String> _f$url = Field('url', _$url);

  @override
  final MappableFields<FCForumPage> fields = const {
    #title: _f$title,
    #url: _f$url,
  };

  static FCForumPage _instantiate(DecodingData data) {
    return FCForumPage(title: data.dec(_f$title), url: data.dec(_f$url));
  }

  @override
  final Function instantiate = _instantiate;

  static FCForumPage fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCForumPage>(map);
  }

  static FCForumPage fromJson(String json) {
    return ensureInitialized().decodeJson<FCForumPage>(json);
  }
}

mixin FCForumPageMappable {
  String toJson() {
    return FCForumPageMapper.ensureInitialized().encodeJson<FCForumPage>(
      this as FCForumPage,
    );
  }

  Map<String, dynamic> toMap() {
    return FCForumPageMapper.ensureInitialized().encodeMap<FCForumPage>(
      this as FCForumPage,
    );
  }

  FCForumPageCopyWith<FCForumPage, FCForumPage, FCForumPage> get copyWith =>
      _FCForumPageCopyWithImpl<FCForumPage, FCForumPage>(
        this as FCForumPage,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCForumPageMapper.ensureInitialized().stringifyValue(
      this as FCForumPage,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCForumPageMapper.ensureInitialized().equalsValue(
      this as FCForumPage,
      other,
    );
  }

  @override
  int get hashCode {
    return FCForumPageMapper.ensureInitialized().hashValue(this as FCForumPage);
  }
}

extension FCForumPageValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCForumPage, $Out> {
  FCForumPageCopyWith<$R, FCForumPage, $Out> get $asFCForumPage =>
      $base.as((v, t, t2) => _FCForumPageCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCForumPageCopyWith<$R, $In extends FCForumPage, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? title, String? url});
  FCForumPageCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FCForumPageCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCForumPage, $Out>
    implements FCForumPageCopyWith<$R, FCForumPage, $Out> {
  _FCForumPageCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCForumPage> $mapper =
      FCForumPageMapper.ensureInitialized();
  @override
  $R call({String? title, String? url}) => $apply(
    FieldCopyWithData({
      if (title != null) #title: title,
      if (url != null) #url: url,
    }),
  );
  @override
  FCForumPage $make(CopyWithData data) => FCForumPage(
    title: data.get(#title, or: $value.title),
    url: data.get(#url, or: $value.url),
  );

  @override
  FCForumPageCopyWith<$R2, FCForumPage, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCForumPageCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCPolicyAcceptanceMapper extends ClassMapperBase<FCPolicyAcceptance> {
  FCPolicyAcceptanceMapper._();

  static FCPolicyAcceptanceMapper? _instance;
  static FCPolicyAcceptanceMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCPolicyAcceptanceMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FCPolicyAcceptance';

  static bool _$termsRequired(FCPolicyAcceptance v) => v.termsRequired;
  static const Field<FCPolicyAcceptance, bool> _f$termsRequired = Field(
    'termsRequired',
    _$termsRequired,
    opt: true,
    def: false,
  );
  static bool _$privacyRequired(FCPolicyAcceptance v) => v.privacyRequired;
  static const Field<FCPolicyAcceptance, bool> _f$privacyRequired = Field(
    'privacyRequired',
    _$privacyRequired,
    opt: true,
    def: false,
  );
  static String _$acceptUrl(FCPolicyAcceptance v) => v.acceptUrl;
  static const Field<FCPolicyAcceptance, String> _f$acceptUrl = Field(
    'acceptUrl',
    _$acceptUrl,
    opt: true,
    def: '',
  );

  @override
  final MappableFields<FCPolicyAcceptance> fields = const {
    #termsRequired: _f$termsRequired,
    #privacyRequired: _f$privacyRequired,
    #acceptUrl: _f$acceptUrl,
  };

  static FCPolicyAcceptance _instantiate(DecodingData data) {
    return FCPolicyAcceptance(
      termsRequired: data.dec(_f$termsRequired),
      privacyRequired: data.dec(_f$privacyRequired),
      acceptUrl: data.dec(_f$acceptUrl),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCPolicyAcceptance fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCPolicyAcceptance>(map);
  }

  static FCPolicyAcceptance fromJson(String json) {
    return ensureInitialized().decodeJson<FCPolicyAcceptance>(json);
  }
}

mixin FCPolicyAcceptanceMappable {
  String toJson() {
    return FCPolicyAcceptanceMapper.ensureInitialized()
        .encodeJson<FCPolicyAcceptance>(this as FCPolicyAcceptance);
  }

  Map<String, dynamic> toMap() {
    return FCPolicyAcceptanceMapper.ensureInitialized()
        .encodeMap<FCPolicyAcceptance>(this as FCPolicyAcceptance);
  }

  FCPolicyAcceptanceCopyWith<
    FCPolicyAcceptance,
    FCPolicyAcceptance,
    FCPolicyAcceptance
  >
  get copyWith =>
      _FCPolicyAcceptanceCopyWithImpl<FCPolicyAcceptance, FCPolicyAcceptance>(
        this as FCPolicyAcceptance,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCPolicyAcceptanceMapper.ensureInitialized().stringifyValue(
      this as FCPolicyAcceptance,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCPolicyAcceptanceMapper.ensureInitialized().equalsValue(
      this as FCPolicyAcceptance,
      other,
    );
  }

  @override
  int get hashCode {
    return FCPolicyAcceptanceMapper.ensureInitialized().hashValue(
      this as FCPolicyAcceptance,
    );
  }
}

extension FCPolicyAcceptanceValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCPolicyAcceptance, $Out> {
  FCPolicyAcceptanceCopyWith<$R, FCPolicyAcceptance, $Out>
  get $asFCPolicyAcceptance => $base.as(
    (v, t, t2) => _FCPolicyAcceptanceCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCPolicyAcceptanceCopyWith<
  $R,
  $In extends FCPolicyAcceptance,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({bool? termsRequired, bool? privacyRequired, String? acceptUrl});
  FCPolicyAcceptanceCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCPolicyAcceptanceCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCPolicyAcceptance, $Out>
    implements FCPolicyAcceptanceCopyWith<$R, FCPolicyAcceptance, $Out> {
  _FCPolicyAcceptanceCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCPolicyAcceptance> $mapper =
      FCPolicyAcceptanceMapper.ensureInitialized();
  @override
  $R call({bool? termsRequired, bool? privacyRequired, String? acceptUrl}) =>
      $apply(
        FieldCopyWithData({
          if (termsRequired != null) #termsRequired: termsRequired,
          if (privacyRequired != null) #privacyRequired: privacyRequired,
          if (acceptUrl != null) #acceptUrl: acceptUrl,
        }),
      );
  @override
  FCPolicyAcceptance $make(CopyWithData data) => FCPolicyAcceptance(
    termsRequired: data.get(#termsRequired, or: $value.termsRequired),
    privacyRequired: data.get(#privacyRequired, or: $value.privacyRequired),
    acceptUrl: data.get(#acceptUrl, or: $value.acceptUrl),
  );

  @override
  FCPolicyAcceptanceCopyWith<$R2, FCPolicyAcceptance, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCPolicyAcceptanceCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

