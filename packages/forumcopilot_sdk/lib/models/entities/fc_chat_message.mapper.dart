// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fc_chat_message.dart';

class FCChatMessageMapper extends ClassMapperBase<FCChatMessage> {
  FCChatMessageMapper._();

  static FCChatMessageMapper? _instance;
  static FCChatMessageMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCChatMessageMapper._());
      FCChatMessageReactionMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCChatMessage';

  static int _$id(FCChatMessage v) => v.id;
  static const Field<FCChatMessage, int> _f$id = Field('id', _$id);
  static int _$channelId(FCChatMessage v) => v.channelId;
  static const Field<FCChatMessage, int> _f$channelId = Field(
    'channelId',
    _$channelId,
  );
  static int? _$threadId(FCChatMessage v) => v.threadId;
  static const Field<FCChatMessage, int> _f$threadId = Field(
    'threadId',
    _$threadId,
    opt: true,
  );
  static String _$message(FCChatMessage v) => v.message;
  static const Field<FCChatMessage, String> _f$message = Field(
    'message',
    _$message,
  );
  static String _$cooked(FCChatMessage v) => v.cooked;
  static const Field<FCChatMessage, String> _f$cooked = Field(
    'cooked',
    _$cooked,
  );
  static String? _$excerpt(FCChatMessage v) => v.excerpt;
  static const Field<FCChatMessage, String> _f$excerpt = Field(
    'excerpt',
    _$excerpt,
    opt: true,
  );
  static int _$authorId(FCChatMessage v) => v.authorId;
  static const Field<FCChatMessage, int> _f$authorId = Field(
    'authorId',
    _$authorId,
  );
  static String _$authorUsername(FCChatMessage v) => v.authorUsername;
  static const Field<FCChatMessage, String> _f$authorUsername = Field(
    'authorUsername',
    _$authorUsername,
  );
  static String? _$authorName(FCChatMessage v) => v.authorName;
  static const Field<FCChatMessage, String> _f$authorName = Field(
    'authorName',
    _$authorName,
    opt: true,
  );
  static String? _$authorAvatarUrl(FCChatMessage v) => v.authorAvatarUrl;
  static const Field<FCChatMessage, String> _f$authorAvatarUrl = Field(
    'authorAvatarUrl',
    _$authorAvatarUrl,
    opt: true,
  );
  static DateTime _$createdAt(FCChatMessage v) => v.createdAt;
  static const Field<FCChatMessage, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
  );
  static bool _$edited(FCChatMessage v) => v.edited;
  static const Field<FCChatMessage, bool> _f$edited = Field(
    'edited',
    _$edited,
    opt: true,
    def: false,
  );
  static bool _$deleted(FCChatMessage v) => v.deleted;
  static const Field<FCChatMessage, bool> _f$deleted = Field(
    'deleted',
    _$deleted,
    opt: true,
    def: false,
  );
  static bool _$streaming(FCChatMessage v) => v.streaming;
  static const Field<FCChatMessage, bool> _f$streaming = Field(
    'streaming',
    _$streaming,
    opt: true,
    def: false,
  );
  static List<FCChatMessageReaction> _$reactions(FCChatMessage v) =>
      v.reactions;
  static const Field<FCChatMessage, List<FCChatMessageReaction>> _f$reactions =
      Field('reactions', _$reactions, opt: true, def: const []);

  @override
  final MappableFields<FCChatMessage> fields = const {
    #id: _f$id,
    #channelId: _f$channelId,
    #threadId: _f$threadId,
    #message: _f$message,
    #cooked: _f$cooked,
    #excerpt: _f$excerpt,
    #authorId: _f$authorId,
    #authorUsername: _f$authorUsername,
    #authorName: _f$authorName,
    #authorAvatarUrl: _f$authorAvatarUrl,
    #createdAt: _f$createdAt,
    #edited: _f$edited,
    #deleted: _f$deleted,
    #streaming: _f$streaming,
    #reactions: _f$reactions,
  };

  static FCChatMessage _instantiate(DecodingData data) {
    return FCChatMessage(
      id: data.dec(_f$id),
      channelId: data.dec(_f$channelId),
      threadId: data.dec(_f$threadId),
      message: data.dec(_f$message),
      cooked: data.dec(_f$cooked),
      excerpt: data.dec(_f$excerpt),
      authorId: data.dec(_f$authorId),
      authorUsername: data.dec(_f$authorUsername),
      authorName: data.dec(_f$authorName),
      authorAvatarUrl: data.dec(_f$authorAvatarUrl),
      createdAt: data.dec(_f$createdAt),
      edited: data.dec(_f$edited),
      deleted: data.dec(_f$deleted),
      streaming: data.dec(_f$streaming),
      reactions: data.dec(_f$reactions),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCChatMessage fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCChatMessage>(map);
  }

  static FCChatMessage fromJson(String json) {
    return ensureInitialized().decodeJson<FCChatMessage>(json);
  }
}

mixin FCChatMessageMappable {
  String toJson() {
    return FCChatMessageMapper.ensureInitialized().encodeJson<FCChatMessage>(
      this as FCChatMessage,
    );
  }

  Map<String, dynamic> toMap() {
    return FCChatMessageMapper.ensureInitialized().encodeMap<FCChatMessage>(
      this as FCChatMessage,
    );
  }

  FCChatMessageCopyWith<FCChatMessage, FCChatMessage, FCChatMessage>
  get copyWith => _FCChatMessageCopyWithImpl<FCChatMessage, FCChatMessage>(
    this as FCChatMessage,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return FCChatMessageMapper.ensureInitialized().stringifyValue(
      this as FCChatMessage,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCChatMessageMapper.ensureInitialized().equalsValue(
      this as FCChatMessage,
      other,
    );
  }

  @override
  int get hashCode {
    return FCChatMessageMapper.ensureInitialized().hashValue(
      this as FCChatMessage,
    );
  }
}

extension FCChatMessageValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCChatMessage, $Out> {
  FCChatMessageCopyWith<$R, FCChatMessage, $Out> get $asFCChatMessage =>
      $base.as((v, t, t2) => _FCChatMessageCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCChatMessageCopyWith<$R, $In extends FCChatMessage, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    FCChatMessageReaction,
    FCChatMessageReactionCopyWith<
      $R,
      FCChatMessageReaction,
      FCChatMessageReaction
    >
  >
  get reactions;
  $R call({
    int? id,
    int? channelId,
    int? threadId,
    String? message,
    String? cooked,
    String? excerpt,
    int? authorId,
    String? authorUsername,
    String? authorName,
    String? authorAvatarUrl,
    DateTime? createdAt,
    bool? edited,
    bool? deleted,
    bool? streaming,
    List<FCChatMessageReaction>? reactions,
  });
  FCChatMessageCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FCChatMessageCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCChatMessage, $Out>
    implements FCChatMessageCopyWith<$R, FCChatMessage, $Out> {
  _FCChatMessageCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCChatMessage> $mapper =
      FCChatMessageMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    FCChatMessageReaction,
    FCChatMessageReactionCopyWith<
      $R,
      FCChatMessageReaction,
      FCChatMessageReaction
    >
  >
  get reactions => ListCopyWith(
    $value.reactions,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(reactions: v),
  );
  @override
  $R call({
    int? id,
    int? channelId,
    Object? threadId = $none,
    String? message,
    String? cooked,
    Object? excerpt = $none,
    int? authorId,
    String? authorUsername,
    Object? authorName = $none,
    Object? authorAvatarUrl = $none,
    DateTime? createdAt,
    bool? edited,
    bool? deleted,
    bool? streaming,
    List<FCChatMessageReaction>? reactions,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (channelId != null) #channelId: channelId,
      if (threadId != $none) #threadId: threadId,
      if (message != null) #message: message,
      if (cooked != null) #cooked: cooked,
      if (excerpt != $none) #excerpt: excerpt,
      if (authorId != null) #authorId: authorId,
      if (authorUsername != null) #authorUsername: authorUsername,
      if (authorName != $none) #authorName: authorName,
      if (authorAvatarUrl != $none) #authorAvatarUrl: authorAvatarUrl,
      if (createdAt != null) #createdAt: createdAt,
      if (edited != null) #edited: edited,
      if (deleted != null) #deleted: deleted,
      if (streaming != null) #streaming: streaming,
      if (reactions != null) #reactions: reactions,
    }),
  );
  @override
  FCChatMessage $make(CopyWithData data) => FCChatMessage(
    id: data.get(#id, or: $value.id),
    channelId: data.get(#channelId, or: $value.channelId),
    threadId: data.get(#threadId, or: $value.threadId),
    message: data.get(#message, or: $value.message),
    cooked: data.get(#cooked, or: $value.cooked),
    excerpt: data.get(#excerpt, or: $value.excerpt),
    authorId: data.get(#authorId, or: $value.authorId),
    authorUsername: data.get(#authorUsername, or: $value.authorUsername),
    authorName: data.get(#authorName, or: $value.authorName),
    authorAvatarUrl: data.get(#authorAvatarUrl, or: $value.authorAvatarUrl),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    edited: data.get(#edited, or: $value.edited),
    deleted: data.get(#deleted, or: $value.deleted),
    streaming: data.get(#streaming, or: $value.streaming),
    reactions: data.get(#reactions, or: $value.reactions),
  );

  @override
  FCChatMessageCopyWith<$R2, FCChatMessage, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCChatMessageCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCChatMessageReactionMapper
    extends ClassMapperBase<FCChatMessageReaction> {
  FCChatMessageReactionMapper._();

  static FCChatMessageReactionMapper? _instance;
  static FCChatMessageReactionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCChatMessageReactionMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FCChatMessageReaction';

  static String _$emoji(FCChatMessageReaction v) => v.emoji;
  static const Field<FCChatMessageReaction, String> _f$emoji = Field(
    'emoji',
    _$emoji,
  );
  static int _$count(FCChatMessageReaction v) => v.count;
  static const Field<FCChatMessageReaction, int> _f$count = Field(
    'count',
    _$count,
  );
  static bool _$reacted(FCChatMessageReaction v) => v.reacted;
  static const Field<FCChatMessageReaction, bool> _f$reacted = Field(
    'reacted',
    _$reacted,
    opt: true,
    def: false,
  );
  static List<String> _$usernames(FCChatMessageReaction v) => v.usernames;
  static const Field<FCChatMessageReaction, List<String>> _f$usernames = Field(
    'usernames',
    _$usernames,
    opt: true,
    def: const [],
  );

  @override
  final MappableFields<FCChatMessageReaction> fields = const {
    #emoji: _f$emoji,
    #count: _f$count,
    #reacted: _f$reacted,
    #usernames: _f$usernames,
  };

  static FCChatMessageReaction _instantiate(DecodingData data) {
    return FCChatMessageReaction(
      emoji: data.dec(_f$emoji),
      count: data.dec(_f$count),
      reacted: data.dec(_f$reacted),
      usernames: data.dec(_f$usernames),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCChatMessageReaction fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCChatMessageReaction>(map);
  }

  static FCChatMessageReaction fromJson(String json) {
    return ensureInitialized().decodeJson<FCChatMessageReaction>(json);
  }
}

mixin FCChatMessageReactionMappable {
  String toJson() {
    return FCChatMessageReactionMapper.ensureInitialized()
        .encodeJson<FCChatMessageReaction>(this as FCChatMessageReaction);
  }

  Map<String, dynamic> toMap() {
    return FCChatMessageReactionMapper.ensureInitialized()
        .encodeMap<FCChatMessageReaction>(this as FCChatMessageReaction);
  }

  FCChatMessageReactionCopyWith<
    FCChatMessageReaction,
    FCChatMessageReaction,
    FCChatMessageReaction
  >
  get copyWith =>
      _FCChatMessageReactionCopyWithImpl<
        FCChatMessageReaction,
        FCChatMessageReaction
      >(this as FCChatMessageReaction, $identity, $identity);
  @override
  String toString() {
    return FCChatMessageReactionMapper.ensureInitialized().stringifyValue(
      this as FCChatMessageReaction,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCChatMessageReactionMapper.ensureInitialized().equalsValue(
      this as FCChatMessageReaction,
      other,
    );
  }

  @override
  int get hashCode {
    return FCChatMessageReactionMapper.ensureInitialized().hashValue(
      this as FCChatMessageReaction,
    );
  }
}

extension FCChatMessageReactionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCChatMessageReaction, $Out> {
  FCChatMessageReactionCopyWith<$R, FCChatMessageReaction, $Out>
  get $asFCChatMessageReaction => $base.as(
    (v, t, t2) => _FCChatMessageReactionCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCChatMessageReactionCopyWith<
  $R,
  $In extends FCChatMessageReaction,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get usernames;
  $R call({String? emoji, int? count, bool? reacted, List<String>? usernames});
  FCChatMessageReactionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCChatMessageReactionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCChatMessageReaction, $Out>
    implements FCChatMessageReactionCopyWith<$R, FCChatMessageReaction, $Out> {
  _FCChatMessageReactionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCChatMessageReaction> $mapper =
      FCChatMessageReactionMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get usernames =>
      ListCopyWith(
        $value.usernames,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(usernames: v),
      );
  @override
  $R call({
    String? emoji,
    int? count,
    bool? reacted,
    List<String>? usernames,
  }) => $apply(
    FieldCopyWithData({
      if (emoji != null) #emoji: emoji,
      if (count != null) #count: count,
      if (reacted != null) #reacted: reacted,
      if (usernames != null) #usernames: usernames,
    }),
  );
  @override
  FCChatMessageReaction $make(CopyWithData data) => FCChatMessageReaction(
    emoji: data.get(#emoji, or: $value.emoji),
    count: data.get(#count, or: $value.count),
    reacted: data.get(#reacted, or: $value.reacted),
    usernames: data.get(#usernames, or: $value.usernames),
  );

  @override
  FCChatMessageReactionCopyWith<$R2, FCChatMessageReaction, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCChatMessageReactionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

