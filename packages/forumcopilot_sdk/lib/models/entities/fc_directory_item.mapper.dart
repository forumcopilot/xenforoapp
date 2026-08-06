// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fc_directory_item.dart';

class FCDirectoryItemMapper extends ClassMapperBase<FCDirectoryItem> {
  FCDirectoryItemMapper._();

  static FCDirectoryItemMapper? _instance;
  static FCDirectoryItemMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCDirectoryItemMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FCDirectoryItem';

  static int _$id(FCDirectoryItem v) => v.id;
  static const Field<FCDirectoryItem, int> _f$id = Field('id', _$id);
  static String _$username(FCDirectoryItem v) => v.username;
  static const Field<FCDirectoryItem, String> _f$username = Field(
    'username',
    _$username,
  );
  static String _$avatarUrl(FCDirectoryItem v) => v.avatarUrl;
  static const Field<FCDirectoryItem, String> _f$avatarUrl = Field(
    'avatarUrl',
    _$avatarUrl,
  );
  static String? _$name(FCDirectoryItem v) => v.name;
  static const Field<FCDirectoryItem, String> _f$name = Field(
    'name',
    _$name,
    opt: true,
  );
  static int? _$trustLevel(FCDirectoryItem v) => v.trustLevel;
  static const Field<FCDirectoryItem, int> _f$trustLevel = Field(
    'trustLevel',
    _$trustLevel,
    opt: true,
  );
  static int _$likesReceived(FCDirectoryItem v) => v.likesReceived;
  static const Field<FCDirectoryItem, int> _f$likesReceived = Field(
    'likesReceived',
    _$likesReceived,
    opt: true,
    def: 0,
  );
  static int _$likesGiven(FCDirectoryItem v) => v.likesGiven;
  static const Field<FCDirectoryItem, int> _f$likesGiven = Field(
    'likesGiven',
    _$likesGiven,
    opt: true,
    def: 0,
  );
  static int _$topicsEntered(FCDirectoryItem v) => v.topicsEntered;
  static const Field<FCDirectoryItem, int> _f$topicsEntered = Field(
    'topicsEntered',
    _$topicsEntered,
    opt: true,
    def: 0,
  );
  static int _$postsRead(FCDirectoryItem v) => v.postsRead;
  static const Field<FCDirectoryItem, int> _f$postsRead = Field(
    'postsRead',
    _$postsRead,
    opt: true,
    def: 0,
  );
  static int _$daysVisited(FCDirectoryItem v) => v.daysVisited;
  static const Field<FCDirectoryItem, int> _f$daysVisited = Field(
    'daysVisited',
    _$daysVisited,
    opt: true,
    def: 0,
  );
  static int _$topicCount(FCDirectoryItem v) => v.topicCount;
  static const Field<FCDirectoryItem, int> _f$topicCount = Field(
    'topicCount',
    _$topicCount,
    opt: true,
    def: 0,
  );
  static int _$postCount(FCDirectoryItem v) => v.postCount;
  static const Field<FCDirectoryItem, int> _f$postCount = Field(
    'postCount',
    _$postCount,
    opt: true,
    def: 0,
  );

  @override
  final MappableFields<FCDirectoryItem> fields = const {
    #id: _f$id,
    #username: _f$username,
    #avatarUrl: _f$avatarUrl,
    #name: _f$name,
    #trustLevel: _f$trustLevel,
    #likesReceived: _f$likesReceived,
    #likesGiven: _f$likesGiven,
    #topicsEntered: _f$topicsEntered,
    #postsRead: _f$postsRead,
    #daysVisited: _f$daysVisited,
    #topicCount: _f$topicCount,
    #postCount: _f$postCount,
  };

  static FCDirectoryItem _instantiate(DecodingData data) {
    return FCDirectoryItem(
      id: data.dec(_f$id),
      username: data.dec(_f$username),
      avatarUrl: data.dec(_f$avatarUrl),
      name: data.dec(_f$name),
      trustLevel: data.dec(_f$trustLevel),
      likesReceived: data.dec(_f$likesReceived),
      likesGiven: data.dec(_f$likesGiven),
      topicsEntered: data.dec(_f$topicsEntered),
      postsRead: data.dec(_f$postsRead),
      daysVisited: data.dec(_f$daysVisited),
      topicCount: data.dec(_f$topicCount),
      postCount: data.dec(_f$postCount),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCDirectoryItem fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCDirectoryItem>(map);
  }

  static FCDirectoryItem fromJson(String json) {
    return ensureInitialized().decodeJson<FCDirectoryItem>(json);
  }
}

mixin FCDirectoryItemMappable {
  String toJson() {
    return FCDirectoryItemMapper.ensureInitialized()
        .encodeJson<FCDirectoryItem>(this as FCDirectoryItem);
  }

  Map<String, dynamic> toMap() {
    return FCDirectoryItemMapper.ensureInitialized().encodeMap<FCDirectoryItem>(
      this as FCDirectoryItem,
    );
  }

  FCDirectoryItemCopyWith<FCDirectoryItem, FCDirectoryItem, FCDirectoryItem>
  get copyWith =>
      _FCDirectoryItemCopyWithImpl<FCDirectoryItem, FCDirectoryItem>(
        this as FCDirectoryItem,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCDirectoryItemMapper.ensureInitialized().stringifyValue(
      this as FCDirectoryItem,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCDirectoryItemMapper.ensureInitialized().equalsValue(
      this as FCDirectoryItem,
      other,
    );
  }

  @override
  int get hashCode {
    return FCDirectoryItemMapper.ensureInitialized().hashValue(
      this as FCDirectoryItem,
    );
  }
}

extension FCDirectoryItemValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCDirectoryItem, $Out> {
  FCDirectoryItemCopyWith<$R, FCDirectoryItem, $Out> get $asFCDirectoryItem =>
      $base.as((v, t, t2) => _FCDirectoryItemCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCDirectoryItemCopyWith<$R, $In extends FCDirectoryItem, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    int? id,
    String? username,
    String? avatarUrl,
    String? name,
    int? trustLevel,
    int? likesReceived,
    int? likesGiven,
    int? topicsEntered,
    int? postsRead,
    int? daysVisited,
    int? topicCount,
    int? postCount,
  });
  FCDirectoryItemCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCDirectoryItemCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCDirectoryItem, $Out>
    implements FCDirectoryItemCopyWith<$R, FCDirectoryItem, $Out> {
  _FCDirectoryItemCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCDirectoryItem> $mapper =
      FCDirectoryItemMapper.ensureInitialized();
  @override
  $R call({
    int? id,
    String? username,
    String? avatarUrl,
    Object? name = $none,
    Object? trustLevel = $none,
    int? likesReceived,
    int? likesGiven,
    int? topicsEntered,
    int? postsRead,
    int? daysVisited,
    int? topicCount,
    int? postCount,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (username != null) #username: username,
      if (avatarUrl != null) #avatarUrl: avatarUrl,
      if (name != $none) #name: name,
      if (trustLevel != $none) #trustLevel: trustLevel,
      if (likesReceived != null) #likesReceived: likesReceived,
      if (likesGiven != null) #likesGiven: likesGiven,
      if (topicsEntered != null) #topicsEntered: topicsEntered,
      if (postsRead != null) #postsRead: postsRead,
      if (daysVisited != null) #daysVisited: daysVisited,
      if (topicCount != null) #topicCount: topicCount,
      if (postCount != null) #postCount: postCount,
    }),
  );
  @override
  FCDirectoryItem $make(CopyWithData data) => FCDirectoryItem(
    id: data.get(#id, or: $value.id),
    username: data.get(#username, or: $value.username),
    avatarUrl: data.get(#avatarUrl, or: $value.avatarUrl),
    name: data.get(#name, or: $value.name),
    trustLevel: data.get(#trustLevel, or: $value.trustLevel),
    likesReceived: data.get(#likesReceived, or: $value.likesReceived),
    likesGiven: data.get(#likesGiven, or: $value.likesGiven),
    topicsEntered: data.get(#topicsEntered, or: $value.topicsEntered),
    postsRead: data.get(#postsRead, or: $value.postsRead),
    daysVisited: data.get(#daysVisited, or: $value.daysVisited),
    topicCount: data.get(#topicCount, or: $value.topicCount),
    postCount: data.get(#postCount, or: $value.postCount),
  );

  @override
  FCDirectoryItemCopyWith<$R2, FCDirectoryItem, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCDirectoryItemCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

