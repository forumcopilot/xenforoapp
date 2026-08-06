// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fc_bookmark.dart';

class FCBookmarkMapper extends ClassMapperBase<FCBookmark> {
  FCBookmarkMapper._();

  static FCBookmarkMapper? _instance;
  static FCBookmarkMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCBookmarkMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FCBookmark';

  static int _$id(FCBookmark v) => v.id;
  static const Field<FCBookmark, int> _f$id = Field('id', _$id);
  static String? _$bookmarkableType(FCBookmark v) => v.bookmarkableType;
  static const Field<FCBookmark, String> _f$bookmarkableType = Field(
    'bookmarkableType',
    _$bookmarkableType,
    opt: true,
  );
  static int? _$bookmarkableId(FCBookmark v) => v.bookmarkableId;
  static const Field<FCBookmark, int> _f$bookmarkableId = Field(
    'bookmarkableId',
    _$bookmarkableId,
    opt: true,
  );
  static int? _$topicId(FCBookmark v) => v.topicId;
  static const Field<FCBookmark, int> _f$topicId = Field(
    'topicId',
    _$topicId,
    opt: true,
  );
  static int? _$postNumber(FCBookmark v) => v.postNumber;
  static const Field<FCBookmark, int> _f$postNumber = Field(
    'postNumber',
    _$postNumber,
    opt: true,
  );
  static String? _$title(FCBookmark v) => v.title;
  static const Field<FCBookmark, String> _f$title = Field(
    'title',
    _$title,
    opt: true,
  );
  static String? _$excerpt(FCBookmark v) => v.excerpt;
  static const Field<FCBookmark, String> _f$excerpt = Field(
    'excerpt',
    _$excerpt,
    opt: true,
  );
  static String? _$name(FCBookmark v) => v.name;
  static const Field<FCBookmark, String> _f$name = Field(
    'name',
    _$name,
    opt: true,
  );
  static String? _$username(FCBookmark v) => v.username;
  static const Field<FCBookmark, String> _f$username = Field(
    'username',
    _$username,
    opt: true,
  );
  static String? _$avatarUrl(FCBookmark v) => v.avatarUrl;
  static const Field<FCBookmark, String> _f$avatarUrl = Field(
    'avatarUrl',
    _$avatarUrl,
    opt: true,
  );
  static DateTime? _$createdAt(FCBookmark v) => v.createdAt;
  static const Field<FCBookmark, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
    opt: true,
  );
  static DateTime? _$reminderAt(FCBookmark v) => v.reminderAt;
  static const Field<FCBookmark, DateTime> _f$reminderAt = Field(
    'reminderAt',
    _$reminderAt,
    opt: true,
  );
  static bool _$pinned(FCBookmark v) => v.pinned;
  static const Field<FCBookmark, bool> _f$pinned = Field(
    'pinned',
    _$pinned,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<FCBookmark> fields = const {
    #id: _f$id,
    #bookmarkableType: _f$bookmarkableType,
    #bookmarkableId: _f$bookmarkableId,
    #topicId: _f$topicId,
    #postNumber: _f$postNumber,
    #title: _f$title,
    #excerpt: _f$excerpt,
    #name: _f$name,
    #username: _f$username,
    #avatarUrl: _f$avatarUrl,
    #createdAt: _f$createdAt,
    #reminderAt: _f$reminderAt,
    #pinned: _f$pinned,
  };

  static FCBookmark _instantiate(DecodingData data) {
    return FCBookmark(
      id: data.dec(_f$id),
      bookmarkableType: data.dec(_f$bookmarkableType),
      bookmarkableId: data.dec(_f$bookmarkableId),
      topicId: data.dec(_f$topicId),
      postNumber: data.dec(_f$postNumber),
      title: data.dec(_f$title),
      excerpt: data.dec(_f$excerpt),
      name: data.dec(_f$name),
      username: data.dec(_f$username),
      avatarUrl: data.dec(_f$avatarUrl),
      createdAt: data.dec(_f$createdAt),
      reminderAt: data.dec(_f$reminderAt),
      pinned: data.dec(_f$pinned),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCBookmark fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCBookmark>(map);
  }

  static FCBookmark fromJson(String json) {
    return ensureInitialized().decodeJson<FCBookmark>(json);
  }
}

mixin FCBookmarkMappable {
  String toJson() {
    return FCBookmarkMapper.ensureInitialized().encodeJson<FCBookmark>(
      this as FCBookmark,
    );
  }

  Map<String, dynamic> toMap() {
    return FCBookmarkMapper.ensureInitialized().encodeMap<FCBookmark>(
      this as FCBookmark,
    );
  }

  FCBookmarkCopyWith<FCBookmark, FCBookmark, FCBookmark> get copyWith =>
      _FCBookmarkCopyWithImpl<FCBookmark, FCBookmark>(
        this as FCBookmark,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCBookmarkMapper.ensureInitialized().stringifyValue(
      this as FCBookmark,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCBookmarkMapper.ensureInitialized().equalsValue(
      this as FCBookmark,
      other,
    );
  }

  @override
  int get hashCode {
    return FCBookmarkMapper.ensureInitialized().hashValue(this as FCBookmark);
  }
}

extension FCBookmarkValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCBookmark, $Out> {
  FCBookmarkCopyWith<$R, FCBookmark, $Out> get $asFCBookmark =>
      $base.as((v, t, t2) => _FCBookmarkCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCBookmarkCopyWith<$R, $In extends FCBookmark, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    int? id,
    String? bookmarkableType,
    int? bookmarkableId,
    int? topicId,
    int? postNumber,
    String? title,
    String? excerpt,
    String? name,
    String? username,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? reminderAt,
    bool? pinned,
  });
  FCBookmarkCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FCBookmarkCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCBookmark, $Out>
    implements FCBookmarkCopyWith<$R, FCBookmark, $Out> {
  _FCBookmarkCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCBookmark> $mapper =
      FCBookmarkMapper.ensureInitialized();
  @override
  $R call({
    int? id,
    Object? bookmarkableType = $none,
    Object? bookmarkableId = $none,
    Object? topicId = $none,
    Object? postNumber = $none,
    Object? title = $none,
    Object? excerpt = $none,
    Object? name = $none,
    Object? username = $none,
    Object? avatarUrl = $none,
    Object? createdAt = $none,
    Object? reminderAt = $none,
    bool? pinned,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (bookmarkableType != $none) #bookmarkableType: bookmarkableType,
      if (bookmarkableId != $none) #bookmarkableId: bookmarkableId,
      if (topicId != $none) #topicId: topicId,
      if (postNumber != $none) #postNumber: postNumber,
      if (title != $none) #title: title,
      if (excerpt != $none) #excerpt: excerpt,
      if (name != $none) #name: name,
      if (username != $none) #username: username,
      if (avatarUrl != $none) #avatarUrl: avatarUrl,
      if (createdAt != $none) #createdAt: createdAt,
      if (reminderAt != $none) #reminderAt: reminderAt,
      if (pinned != null) #pinned: pinned,
    }),
  );
  @override
  FCBookmark $make(CopyWithData data) => FCBookmark(
    id: data.get(#id, or: $value.id),
    bookmarkableType: data.get(#bookmarkableType, or: $value.bookmarkableType),
    bookmarkableId: data.get(#bookmarkableId, or: $value.bookmarkableId),
    topicId: data.get(#topicId, or: $value.topicId),
    postNumber: data.get(#postNumber, or: $value.postNumber),
    title: data.get(#title, or: $value.title),
    excerpt: data.get(#excerpt, or: $value.excerpt),
    name: data.get(#name, or: $value.name),
    username: data.get(#username, or: $value.username),
    avatarUrl: data.get(#avatarUrl, or: $value.avatarUrl),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    reminderAt: data.get(#reminderAt, or: $value.reminderAt),
    pinned: data.get(#pinned, or: $value.pinned),
  );

  @override
  FCBookmarkCopyWith<$R2, FCBookmark, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCBookmarkCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

