// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fc_chat_channel.dart';

class FCChatChannelMapper extends ClassMapperBase<FCChatChannel> {
  FCChatChannelMapper._();

  static FCChatChannelMapper? _instance;
  static FCChatChannelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCChatChannelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FCChatChannel';

  static int _$id(FCChatChannel v) => v.id;
  static const Field<FCChatChannel, int> _f$id = Field('id', _$id);
  static String _$title(FCChatChannel v) => v.title;
  static const Field<FCChatChannel, String> _f$title = Field('title', _$title);
  static String? _$description(FCChatChannel v) => v.description;
  static const Field<FCChatChannel, String> _f$description = Field(
    'description',
    _$description,
    opt: true,
  );
  static String? _$slug(FCChatChannel v) => v.slug;
  static const Field<FCChatChannel, String> _f$slug = Field(
    'slug',
    _$slug,
    opt: true,
  );
  static String _$chatableType(FCChatChannel v) => v.chatableType;
  static const Field<FCChatChannel, String> _f$chatableType = Field(
    'chatableType',
    _$chatableType,
    opt: true,
    def: 'Category',
  );
  static int _$unreadCount(FCChatChannel v) => v.unreadCount;
  static const Field<FCChatChannel, int> _f$unreadCount = Field(
    'unreadCount',
    _$unreadCount,
    opt: true,
    def: 0,
  );
  static int _$mentionCount(FCChatChannel v) => v.mentionCount;
  static const Field<FCChatChannel, int> _f$mentionCount = Field(
    'mentionCount',
    _$mentionCount,
    opt: true,
    def: 0,
  );
  static int? _$lastReadMessageId(FCChatChannel v) => v.lastReadMessageId;
  static const Field<FCChatChannel, int> _f$lastReadMessageId = Field(
    'lastReadMessageId',
    _$lastReadMessageId,
    opt: true,
  );
  static bool _$isFollowing(FCChatChannel v) => v.isFollowing;
  static const Field<FCChatChannel, bool> _f$isFollowing = Field(
    'isFollowing',
    _$isFollowing,
    opt: true,
    def: false,
  );
  static bool _$canJoin(FCChatChannel v) => v.canJoin;
  static const Field<FCChatChannel, bool> _f$canJoin = Field(
    'canJoin',
    _$canJoin,
    opt: true,
    def: false,
  );
  static String _$status(FCChatChannel v) => v.status;
  static const Field<FCChatChannel, String> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: 'open',
  );
  static DateTime? _$lastMessageAt(FCChatChannel v) => v.lastMessageAt;
  static const Field<FCChatChannel, DateTime> _f$lastMessageAt = Field(
    'lastMessageAt',
    _$lastMessageAt,
    opt: true,
  );

  @override
  final MappableFields<FCChatChannel> fields = const {
    #id: _f$id,
    #title: _f$title,
    #description: _f$description,
    #slug: _f$slug,
    #chatableType: _f$chatableType,
    #unreadCount: _f$unreadCount,
    #mentionCount: _f$mentionCount,
    #lastReadMessageId: _f$lastReadMessageId,
    #isFollowing: _f$isFollowing,
    #canJoin: _f$canJoin,
    #status: _f$status,
    #lastMessageAt: _f$lastMessageAt,
  };

  static FCChatChannel _instantiate(DecodingData data) {
    return FCChatChannel(
      id: data.dec(_f$id),
      title: data.dec(_f$title),
      description: data.dec(_f$description),
      slug: data.dec(_f$slug),
      chatableType: data.dec(_f$chatableType),
      unreadCount: data.dec(_f$unreadCount),
      mentionCount: data.dec(_f$mentionCount),
      lastReadMessageId: data.dec(_f$lastReadMessageId),
      isFollowing: data.dec(_f$isFollowing),
      canJoin: data.dec(_f$canJoin),
      status: data.dec(_f$status),
      lastMessageAt: data.dec(_f$lastMessageAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCChatChannel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCChatChannel>(map);
  }

  static FCChatChannel fromJson(String json) {
    return ensureInitialized().decodeJson<FCChatChannel>(json);
  }
}

mixin FCChatChannelMappable {
  String toJson() {
    return FCChatChannelMapper.ensureInitialized().encodeJson<FCChatChannel>(
      this as FCChatChannel,
    );
  }

  Map<String, dynamic> toMap() {
    return FCChatChannelMapper.ensureInitialized().encodeMap<FCChatChannel>(
      this as FCChatChannel,
    );
  }

  FCChatChannelCopyWith<FCChatChannel, FCChatChannel, FCChatChannel>
  get copyWith => _FCChatChannelCopyWithImpl<FCChatChannel, FCChatChannel>(
    this as FCChatChannel,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return FCChatChannelMapper.ensureInitialized().stringifyValue(
      this as FCChatChannel,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCChatChannelMapper.ensureInitialized().equalsValue(
      this as FCChatChannel,
      other,
    );
  }

  @override
  int get hashCode {
    return FCChatChannelMapper.ensureInitialized().hashValue(
      this as FCChatChannel,
    );
  }
}

extension FCChatChannelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCChatChannel, $Out> {
  FCChatChannelCopyWith<$R, FCChatChannel, $Out> get $asFCChatChannel =>
      $base.as((v, t, t2) => _FCChatChannelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCChatChannelCopyWith<$R, $In extends FCChatChannel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    int? id,
    String? title,
    String? description,
    String? slug,
    String? chatableType,
    int? unreadCount,
    int? mentionCount,
    int? lastReadMessageId,
    bool? isFollowing,
    bool? canJoin,
    String? status,
    DateTime? lastMessageAt,
  });
  FCChatChannelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FCChatChannelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCChatChannel, $Out>
    implements FCChatChannelCopyWith<$R, FCChatChannel, $Out> {
  _FCChatChannelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCChatChannel> $mapper =
      FCChatChannelMapper.ensureInitialized();
  @override
  $R call({
    int? id,
    String? title,
    Object? description = $none,
    Object? slug = $none,
    String? chatableType,
    int? unreadCount,
    int? mentionCount,
    Object? lastReadMessageId = $none,
    bool? isFollowing,
    bool? canJoin,
    String? status,
    Object? lastMessageAt = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (title != null) #title: title,
      if (description != $none) #description: description,
      if (slug != $none) #slug: slug,
      if (chatableType != null) #chatableType: chatableType,
      if (unreadCount != null) #unreadCount: unreadCount,
      if (mentionCount != null) #mentionCount: mentionCount,
      if (lastReadMessageId != $none) #lastReadMessageId: lastReadMessageId,
      if (isFollowing != null) #isFollowing: isFollowing,
      if (canJoin != null) #canJoin: canJoin,
      if (status != null) #status: status,
      if (lastMessageAt != $none) #lastMessageAt: lastMessageAt,
    }),
  );
  @override
  FCChatChannel $make(CopyWithData data) => FCChatChannel(
    id: data.get(#id, or: $value.id),
    title: data.get(#title, or: $value.title),
    description: data.get(#description, or: $value.description),
    slug: data.get(#slug, or: $value.slug),
    chatableType: data.get(#chatableType, or: $value.chatableType),
    unreadCount: data.get(#unreadCount, or: $value.unreadCount),
    mentionCount: data.get(#mentionCount, or: $value.mentionCount),
    lastReadMessageId: data.get(
      #lastReadMessageId,
      or: $value.lastReadMessageId,
    ),
    isFollowing: data.get(#isFollowing, or: $value.isFollowing),
    canJoin: data.get(#canJoin, or: $value.canJoin),
    status: data.get(#status, or: $value.status),
    lastMessageAt: data.get(#lastMessageAt, or: $value.lastMessageAt),
  );

  @override
  FCChatChannelCopyWith<$R2, FCChatChannel, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCChatChannelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

