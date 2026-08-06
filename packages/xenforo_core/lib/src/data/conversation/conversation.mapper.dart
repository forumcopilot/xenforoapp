// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'conversation.dart';

class XenForoConversationMapper extends ClassMapperBase<XenForoConversation> {
  XenForoConversationMapper._();

  static XenForoConversationMapper? _instance;
  static XenForoConversationMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = XenForoConversationMapper._());
      XenForoUserMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'XenForoConversation';

  static String? _$username(XenForoConversation v) => v.username;
  static const Field<XenForoConversation, String> _f$username = Field(
    'username',
    _$username,
    opt: true,
  );
  static Map<String, String>? _$recipients(XenForoConversation v) =>
      v.recipients;
  static const Field<XenForoConversation, Map<String, String>> _f$recipients =
      Field('recipients', _$recipients, opt: true);
  static bool? _$isStarred(XenForoConversation v) => v.isStarred;
  static const Field<XenForoConversation, bool> _f$isStarred = Field(
    'isStarred',
    _$isStarred,
    opt: true,
  );
  static bool? _$isUnread(XenForoConversation v) => v.isUnread;
  static const Field<XenForoConversation, bool> _f$isUnread = Field(
    'isUnread',
    _$isUnread,
    opt: true,
  );
  static bool? _$canEdit(XenForoConversation v) => v.canEdit;
  static const Field<XenForoConversation, bool> _f$canEdit = Field(
    'canEdit',
    _$canEdit,
    opt: true,
  );
  static bool? _$canReply(XenForoConversation v) => v.canReply;
  static const Field<XenForoConversation, bool> _f$canReply = Field(
    'canReply',
    _$canReply,
    opt: true,
  );
  static bool? _$canInvite(XenForoConversation v) => v.canInvite;
  static const Field<XenForoConversation, bool> _f$canInvite = Field(
    'canInvite',
    _$canInvite,
    opt: true,
  );
  static bool? _$canUploadAttachment(XenForoConversation v) =>
      v.canUploadAttachment;
  static const Field<XenForoConversation, bool> _f$canUploadAttachment = Field(
    'canUploadAttachment',
    _$canUploadAttachment,
    opt: true,
  );
  static String? _$viewUrl(XenForoConversation v) => v.viewUrl;
  static const Field<XenForoConversation, String> _f$viewUrl = Field(
    'viewUrl',
    _$viewUrl,
    opt: true,
  );
  static int _$conversationId(XenForoConversation v) => v.conversationId;
  static const Field<XenForoConversation, int> _f$conversationId = Field(
    'conversationId',
    _$conversationId,
  );
  static String? _$title(XenForoConversation v) => v.title;
  static const Field<XenForoConversation, String> _f$title = Field(
    'title',
    _$title,
    opt: true,
  );
  static int? _$userId(XenForoConversation v) => v.userId;
  static const Field<XenForoConversation, int> _f$userId = Field(
    'userId',
    _$userId,
    opt: true,
  );
  static int? _$startDate(XenForoConversation v) => v.startDate;
  static const Field<XenForoConversation, int> _f$startDate = Field(
    'startDate',
    _$startDate,
    opt: true,
  );
  static bool? _$openInvite(XenForoConversation v) => v.openInvite;
  static const Field<XenForoConversation, bool> _f$openInvite = Field(
    'openInvite',
    _$openInvite,
    opt: true,
  );
  static bool? _$conversationOpen(XenForoConversation v) => v.conversationOpen;
  static const Field<XenForoConversation, bool> _f$conversationOpen = Field(
    'conversationOpen',
    _$conversationOpen,
    opt: true,
  );
  static int? _$replyCount(XenForoConversation v) => v.replyCount;
  static const Field<XenForoConversation, int> _f$replyCount = Field(
    'replyCount',
    _$replyCount,
    opt: true,
  );
  static int? _$recipientCount(XenForoConversation v) => v.recipientCount;
  static const Field<XenForoConversation, int> _f$recipientCount = Field(
    'recipientCount',
    _$recipientCount,
    opt: true,
  );
  static int? _$firstMessageId(XenForoConversation v) => v.firstMessageId;
  static const Field<XenForoConversation, int> _f$firstMessageId = Field(
    'firstMessageId',
    _$firstMessageId,
    opt: true,
  );
  static int? _$lastMessageDate(XenForoConversation v) => v.lastMessageDate;
  static const Field<XenForoConversation, int> _f$lastMessageDate = Field(
    'lastMessageDate',
    _$lastMessageDate,
    opt: true,
  );
  static int? _$lastMessageId(XenForoConversation v) => v.lastMessageId;
  static const Field<XenForoConversation, int> _f$lastMessageId = Field(
    'lastMessageId',
    _$lastMessageId,
    opt: true,
  );
  static int? _$lastMessageUserId(XenForoConversation v) => v.lastMessageUserId;
  static const Field<XenForoConversation, int> _f$lastMessageUserId = Field(
    'lastMessageUserId',
    _$lastMessageUserId,
    opt: true,
  );
  static XenForoUser? _$starter(XenForoConversation v) => v.starter;
  static const Field<XenForoConversation, XenForoUser> _f$starter = Field(
    'starter',
    _$starter,
    opt: true,
  );

  @override
  final MappableFields<XenForoConversation> fields = const {
    #username: _f$username,
    #recipients: _f$recipients,
    #isStarred: _f$isStarred,
    #isUnread: _f$isUnread,
    #canEdit: _f$canEdit,
    #canReply: _f$canReply,
    #canInvite: _f$canInvite,
    #canUploadAttachment: _f$canUploadAttachment,
    #viewUrl: _f$viewUrl,
    #conversationId: _f$conversationId,
    #title: _f$title,
    #userId: _f$userId,
    #startDate: _f$startDate,
    #openInvite: _f$openInvite,
    #conversationOpen: _f$conversationOpen,
    #replyCount: _f$replyCount,
    #recipientCount: _f$recipientCount,
    #firstMessageId: _f$firstMessageId,
    #lastMessageDate: _f$lastMessageDate,
    #lastMessageId: _f$lastMessageId,
    #lastMessageUserId: _f$lastMessageUserId,
    #starter: _f$starter,
  };

  static XenForoConversation _instantiate(DecodingData data) {
    return XenForoConversation(
      username: data.dec(_f$username),
      recipients: data.dec(_f$recipients),
      isStarred: data.dec(_f$isStarred),
      isUnread: data.dec(_f$isUnread),
      canEdit: data.dec(_f$canEdit),
      canReply: data.dec(_f$canReply),
      canInvite: data.dec(_f$canInvite),
      canUploadAttachment: data.dec(_f$canUploadAttachment),
      viewUrl: data.dec(_f$viewUrl),
      conversationId: data.dec(_f$conversationId),
      title: data.dec(_f$title),
      userId: data.dec(_f$userId),
      startDate: data.dec(_f$startDate),
      openInvite: data.dec(_f$openInvite),
      conversationOpen: data.dec(_f$conversationOpen),
      replyCount: data.dec(_f$replyCount),
      recipientCount: data.dec(_f$recipientCount),
      firstMessageId: data.dec(_f$firstMessageId),
      lastMessageDate: data.dec(_f$lastMessageDate),
      lastMessageId: data.dec(_f$lastMessageId),
      lastMessageUserId: data.dec(_f$lastMessageUserId),
      starter: data.dec(_f$starter),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static XenForoConversation fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<XenForoConversation>(map);
  }

  static XenForoConversation fromJson(String json) {
    return ensureInitialized().decodeJson<XenForoConversation>(json);
  }
}

mixin XenForoConversationMappable {
  String toJson() {
    return XenForoConversationMapper.ensureInitialized()
        .encodeJson<XenForoConversation>(this as XenForoConversation);
  }

  Map<String, dynamic> toMap() {
    return XenForoConversationMapper.ensureInitialized()
        .encodeMap<XenForoConversation>(this as XenForoConversation);
  }

  XenForoConversationCopyWith<
    XenForoConversation,
    XenForoConversation,
    XenForoConversation
  >
  get copyWith =>
      _XenForoConversationCopyWithImpl<
        XenForoConversation,
        XenForoConversation
      >(this as XenForoConversation, $identity, $identity);
  @override
  String toString() {
    return XenForoConversationMapper.ensureInitialized().stringifyValue(
      this as XenForoConversation,
    );
  }

  @override
  bool operator ==(Object other) {
    return XenForoConversationMapper.ensureInitialized().equalsValue(
      this as XenForoConversation,
      other,
    );
  }

  @override
  int get hashCode {
    return XenForoConversationMapper.ensureInitialized().hashValue(
      this as XenForoConversation,
    );
  }
}

extension XenForoConversationValueCopy<$R, $Out>
    on ObjectCopyWith<$R, XenForoConversation, $Out> {
  XenForoConversationCopyWith<$R, XenForoConversation, $Out>
  get $asXenForoConversation => $base.as(
    (v, t, t2) => _XenForoConversationCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class XenForoConversationCopyWith<
  $R,
  $In extends XenForoConversation,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, String, ObjectCopyWith<$R, String, String>>?
  get recipients;
  XenForoUserCopyWith<$R, XenForoUser, XenForoUser>? get starter;
  $R call({
    String? username,
    Map<String, String>? recipients,
    bool? isStarred,
    bool? isUnread,
    bool? canEdit,
    bool? canReply,
    bool? canInvite,
    bool? canUploadAttachment,
    String? viewUrl,
    int? conversationId,
    String? title,
    int? userId,
    int? startDate,
    bool? openInvite,
    bool? conversationOpen,
    int? replyCount,
    int? recipientCount,
    int? firstMessageId,
    int? lastMessageDate,
    int? lastMessageId,
    int? lastMessageUserId,
    XenForoUser? starter,
  });
  XenForoConversationCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _XenForoConversationCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, XenForoConversation, $Out>
    implements XenForoConversationCopyWith<$R, XenForoConversation, $Out> {
  _XenForoConversationCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<XenForoConversation> $mapper =
      XenForoConversationMapper.ensureInitialized();
  @override
  MapCopyWith<$R, String, String, ObjectCopyWith<$R, String, String>>?
  get recipients => $value.recipients != null
      ? MapCopyWith(
          $value.recipients!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(recipients: v),
        )
      : null;
  @override
  XenForoUserCopyWith<$R, XenForoUser, XenForoUser>? get starter =>
      $value.starter?.copyWith.$chain((v) => call(starter: v));
  @override
  $R call({
    Object? username = $none,
    Object? recipients = $none,
    Object? isStarred = $none,
    Object? isUnread = $none,
    Object? canEdit = $none,
    Object? canReply = $none,
    Object? canInvite = $none,
    Object? canUploadAttachment = $none,
    Object? viewUrl = $none,
    int? conversationId,
    Object? title = $none,
    Object? userId = $none,
    Object? startDate = $none,
    Object? openInvite = $none,
    Object? conversationOpen = $none,
    Object? replyCount = $none,
    Object? recipientCount = $none,
    Object? firstMessageId = $none,
    Object? lastMessageDate = $none,
    Object? lastMessageId = $none,
    Object? lastMessageUserId = $none,
    Object? starter = $none,
  }) => $apply(
    FieldCopyWithData({
      if (username != $none) #username: username,
      if (recipients != $none) #recipients: recipients,
      if (isStarred != $none) #isStarred: isStarred,
      if (isUnread != $none) #isUnread: isUnread,
      if (canEdit != $none) #canEdit: canEdit,
      if (canReply != $none) #canReply: canReply,
      if (canInvite != $none) #canInvite: canInvite,
      if (canUploadAttachment != $none)
        #canUploadAttachment: canUploadAttachment,
      if (viewUrl != $none) #viewUrl: viewUrl,
      if (conversationId != null) #conversationId: conversationId,
      if (title != $none) #title: title,
      if (userId != $none) #userId: userId,
      if (startDate != $none) #startDate: startDate,
      if (openInvite != $none) #openInvite: openInvite,
      if (conversationOpen != $none) #conversationOpen: conversationOpen,
      if (replyCount != $none) #replyCount: replyCount,
      if (recipientCount != $none) #recipientCount: recipientCount,
      if (firstMessageId != $none) #firstMessageId: firstMessageId,
      if (lastMessageDate != $none) #lastMessageDate: lastMessageDate,
      if (lastMessageId != $none) #lastMessageId: lastMessageId,
      if (lastMessageUserId != $none) #lastMessageUserId: lastMessageUserId,
      if (starter != $none) #starter: starter,
    }),
  );
  @override
  XenForoConversation $make(CopyWithData data) => XenForoConversation(
    username: data.get(#username, or: $value.username),
    recipients: data.get(#recipients, or: $value.recipients),
    isStarred: data.get(#isStarred, or: $value.isStarred),
    isUnread: data.get(#isUnread, or: $value.isUnread),
    canEdit: data.get(#canEdit, or: $value.canEdit),
    canReply: data.get(#canReply, or: $value.canReply),
    canInvite: data.get(#canInvite, or: $value.canInvite),
    canUploadAttachment: data.get(
      #canUploadAttachment,
      or: $value.canUploadAttachment,
    ),
    viewUrl: data.get(#viewUrl, or: $value.viewUrl),
    conversationId: data.get(#conversationId, or: $value.conversationId),
    title: data.get(#title, or: $value.title),
    userId: data.get(#userId, or: $value.userId),
    startDate: data.get(#startDate, or: $value.startDate),
    openInvite: data.get(#openInvite, or: $value.openInvite),
    conversationOpen: data.get(#conversationOpen, or: $value.conversationOpen),
    replyCount: data.get(#replyCount, or: $value.replyCount),
    recipientCount: data.get(#recipientCount, or: $value.recipientCount),
    firstMessageId: data.get(#firstMessageId, or: $value.firstMessageId),
    lastMessageDate: data.get(#lastMessageDate, or: $value.lastMessageDate),
    lastMessageId: data.get(#lastMessageId, or: $value.lastMessageId),
    lastMessageUserId: data.get(
      #lastMessageUserId,
      or: $value.lastMessageUserId,
    ),
    starter: data.get(#starter, or: $value.starter),
  );

  @override
  XenForoConversationCopyWith<$R2, XenForoConversation, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _XenForoConversationCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

