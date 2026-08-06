// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'post.dart';

class XenForoPostMapper extends ClassMapperBase<XenForoPost> {
  XenForoPostMapper._();

  static XenForoPostMapper? _instance;
  static XenForoPostMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = XenForoPostMapper._());
      XenForoThreadMapper.ensureInitialized();
      XenForoAttachmentMapper.ensureInitialized();
      XenForoUserMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'XenForoPost';

  static String? _$username(XenForoPost v) => v.username;
  static const Field<XenForoPost, String> _f$username = Field(
    'username',
    _$username,
    opt: true,
  );
  static bool? _$isFirstPost(XenForoPost v) => v.isFirstPost;
  static const Field<XenForoPost, bool> _f$isFirstPost = Field(
    'isFirstPost',
    _$isFirstPost,
    opt: true,
  );
  static bool? _$isLastPost(XenForoPost v) => v.isLastPost;
  static const Field<XenForoPost, bool> _f$isLastPost = Field(
    'isLastPost',
    _$isLastPost,
    opt: true,
  );
  static bool? _$isUnread(XenForoPost v) => v.isUnread;
  static const Field<XenForoPost, bool> _f$isUnread = Field(
    'isUnread',
    _$isUnread,
    opt: true,
  );
  static String? _$messageParsed(XenForoPost v) => v.messageParsed;
  static const Field<XenForoPost, String> _f$messageParsed = Field(
    'messageParsed',
    _$messageParsed,
    opt: true,
  );
  static bool? _$canEdit(XenForoPost v) => v.canEdit;
  static const Field<XenForoPost, bool> _f$canEdit = Field(
    'canEdit',
    _$canEdit,
    opt: true,
  );
  static bool? _$canSoftDelete(XenForoPost v) => v.canSoftDelete;
  static const Field<XenForoPost, bool> _f$canSoftDelete = Field(
    'canSoftDelete',
    _$canSoftDelete,
    opt: true,
  );
  static bool? _$canHardDelete(XenForoPost v) => v.canHardDelete;
  static const Field<XenForoPost, bool> _f$canHardDelete = Field(
    'canHardDelete',
    _$canHardDelete,
    opt: true,
  );
  static bool? _$canReact(XenForoPost v) => v.canReact;
  static const Field<XenForoPost, bool> _f$canReact = Field(
    'canReact',
    _$canReact,
    opt: true,
  );
  static bool? _$canViewAttachments(XenForoPost v) => v.canViewAttachments;
  static const Field<XenForoPost, bool> _f$canViewAttachments = Field(
    'canViewAttachments',
    _$canViewAttachments,
    opt: true,
  );
  static String? _$viewUrl(XenForoPost v) => v.viewUrl;
  static const Field<XenForoPost, String> _f$viewUrl = Field(
    'viewUrl',
    _$viewUrl,
    opt: true,
  );
  static XenForoThread? _$thread(XenForoPost v) => v.thread;
  static const Field<XenForoPost, XenForoThread> _f$thread = Field(
    'thread',
    _$thread,
    opt: true,
  );
  static List<XenForoAttachment>? _$attachments(XenForoPost v) => v.attachments;
  static const Field<XenForoPost, List<XenForoAttachment>> _f$attachments =
      Field('attachments', _$attachments, opt: true);
  static bool? _$isReactedTo(XenForoPost v) => v.isReactedTo;
  static const Field<XenForoPost, bool> _f$isReactedTo = Field(
    'isReactedTo',
    _$isReactedTo,
    opt: true,
  );
  static int? _$visitorReactionId(XenForoPost v) => v.visitorReactionId;
  static const Field<XenForoPost, int> _f$visitorReactionId = Field(
    'visitorReactionId',
    _$visitorReactionId,
    opt: true,
  );
  static int? _$voteScore(XenForoPost v) => v.voteScore;
  static const Field<XenForoPost, int> _f$voteScore = Field(
    'voteScore',
    _$voteScore,
    opt: true,
  );
  static bool? _$canContentVote(XenForoPost v) => v.canContentVote;
  static const Field<XenForoPost, bool> _f$canContentVote = Field(
    'canContentVote',
    _$canContentVote,
    opt: true,
  );
  static List<String>? _$allowedContentVoteTypes(XenForoPost v) =>
      v.allowedContentVoteTypes;
  static const Field<XenForoPost, List<String>> _f$allowedContentVoteTypes =
      Field('allowedContentVoteTypes', _$allowedContentVoteTypes, opt: true);
  static bool? _$isContentVoted(XenForoPost v) => v.isContentVoted;
  static const Field<XenForoPost, bool> _f$isContentVoted = Field(
    'isContentVoted',
    _$isContentVoted,
    opt: true,
  );
  static String? _$visitorContentVote(XenForoPost v) => v.visitorContentVote;
  static const Field<XenForoPost, String> _f$visitorContentVote = Field(
    'visitorContentVote',
    _$visitorContentVote,
    opt: true,
  );
  static int _$postId(XenForoPost v) => v.postId;
  static const Field<XenForoPost, int> _f$postId = Field('postId', _$postId);
  static int? _$threadId(XenForoPost v) => v.threadId;
  static const Field<XenForoPost, int> _f$threadId = Field(
    'threadId',
    _$threadId,
    opt: true,
  );
  static int? _$userId(XenForoPost v) => v.userId;
  static const Field<XenForoPost, int> _f$userId = Field(
    'userId',
    _$userId,
    opt: true,
  );
  static int? _$postDate(XenForoPost v) => v.postDate;
  static const Field<XenForoPost, int> _f$postDate = Field(
    'postDate',
    _$postDate,
    opt: true,
  );
  static String? _$message(XenForoPost v) => v.message;
  static const Field<XenForoPost, String> _f$message = Field(
    'message',
    _$message,
    opt: true,
  );
  static String? _$messageState(XenForoPost v) => v.messageState;
  static const Field<XenForoPost, String> _f$messageState = Field(
    'messageState',
    _$messageState,
    opt: true,
  );
  static int? _$attachCount(XenForoPost v) => v.attachCount;
  static const Field<XenForoPost, int> _f$attachCount = Field(
    'attachCount',
    _$attachCount,
    opt: true,
  );
  static String? _$warningMessage(XenForoPost v) => v.warningMessage;
  static const Field<XenForoPost, String> _f$warningMessage = Field(
    'warningMessage',
    _$warningMessage,
    opt: true,
  );
  static int? _$position(XenForoPost v) => v.position;
  static const Field<XenForoPost, int> _f$position = Field(
    'position',
    _$position,
    opt: true,
  );
  static int? _$lastEditDate(XenForoPost v) => v.lastEditDate;
  static const Field<XenForoPost, int> _f$lastEditDate = Field(
    'lastEditDate',
    _$lastEditDate,
    opt: true,
  );
  static int? _$reactionScore(XenForoPost v) => v.reactionScore;
  static const Field<XenForoPost, int> _f$reactionScore = Field(
    'reactionScore',
    _$reactionScore,
    opt: true,
  );
  static XenForoUser? _$user(XenForoPost v) => v.user;
  static const Field<XenForoPost, XenForoUser> _f$user = Field(
    'user',
    _$user,
    opt: true,
  );

  @override
  final MappableFields<XenForoPost> fields = const {
    #username: _f$username,
    #isFirstPost: _f$isFirstPost,
    #isLastPost: _f$isLastPost,
    #isUnread: _f$isUnread,
    #messageParsed: _f$messageParsed,
    #canEdit: _f$canEdit,
    #canSoftDelete: _f$canSoftDelete,
    #canHardDelete: _f$canHardDelete,
    #canReact: _f$canReact,
    #canViewAttachments: _f$canViewAttachments,
    #viewUrl: _f$viewUrl,
    #thread: _f$thread,
    #attachments: _f$attachments,
    #isReactedTo: _f$isReactedTo,
    #visitorReactionId: _f$visitorReactionId,
    #voteScore: _f$voteScore,
    #canContentVote: _f$canContentVote,
    #allowedContentVoteTypes: _f$allowedContentVoteTypes,
    #isContentVoted: _f$isContentVoted,
    #visitorContentVote: _f$visitorContentVote,
    #postId: _f$postId,
    #threadId: _f$threadId,
    #userId: _f$userId,
    #postDate: _f$postDate,
    #message: _f$message,
    #messageState: _f$messageState,
    #attachCount: _f$attachCount,
    #warningMessage: _f$warningMessage,
    #position: _f$position,
    #lastEditDate: _f$lastEditDate,
    #reactionScore: _f$reactionScore,
    #user: _f$user,
  };

  static XenForoPost _instantiate(DecodingData data) {
    return XenForoPost(
      username: data.dec(_f$username),
      isFirstPost: data.dec(_f$isFirstPost),
      isLastPost: data.dec(_f$isLastPost),
      isUnread: data.dec(_f$isUnread),
      messageParsed: data.dec(_f$messageParsed),
      canEdit: data.dec(_f$canEdit),
      canSoftDelete: data.dec(_f$canSoftDelete),
      canHardDelete: data.dec(_f$canHardDelete),
      canReact: data.dec(_f$canReact),
      canViewAttachments: data.dec(_f$canViewAttachments),
      viewUrl: data.dec(_f$viewUrl),
      thread: data.dec(_f$thread),
      attachments: data.dec(_f$attachments),
      isReactedTo: data.dec(_f$isReactedTo),
      visitorReactionId: data.dec(_f$visitorReactionId),
      voteScore: data.dec(_f$voteScore),
      canContentVote: data.dec(_f$canContentVote),
      allowedContentVoteTypes: data.dec(_f$allowedContentVoteTypes),
      isContentVoted: data.dec(_f$isContentVoted),
      visitorContentVote: data.dec(_f$visitorContentVote),
      postId: data.dec(_f$postId),
      threadId: data.dec(_f$threadId),
      userId: data.dec(_f$userId),
      postDate: data.dec(_f$postDate),
      message: data.dec(_f$message),
      messageState: data.dec(_f$messageState),
      attachCount: data.dec(_f$attachCount),
      warningMessage: data.dec(_f$warningMessage),
      position: data.dec(_f$position),
      lastEditDate: data.dec(_f$lastEditDate),
      reactionScore: data.dec(_f$reactionScore),
      user: data.dec(_f$user),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static XenForoPost fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<XenForoPost>(map);
  }

  static XenForoPost fromJson(String json) {
    return ensureInitialized().decodeJson<XenForoPost>(json);
  }
}

mixin XenForoPostMappable {
  String toJson() {
    return XenForoPostMapper.ensureInitialized().encodeJson<XenForoPost>(
      this as XenForoPost,
    );
  }

  Map<String, dynamic> toMap() {
    return XenForoPostMapper.ensureInitialized().encodeMap<XenForoPost>(
      this as XenForoPost,
    );
  }

  XenForoPostCopyWith<XenForoPost, XenForoPost, XenForoPost> get copyWith =>
      _XenForoPostCopyWithImpl<XenForoPost, XenForoPost>(
        this as XenForoPost,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return XenForoPostMapper.ensureInitialized().stringifyValue(
      this as XenForoPost,
    );
  }

  @override
  bool operator ==(Object other) {
    return XenForoPostMapper.ensureInitialized().equalsValue(
      this as XenForoPost,
      other,
    );
  }

  @override
  int get hashCode {
    return XenForoPostMapper.ensureInitialized().hashValue(this as XenForoPost);
  }
}

extension XenForoPostValueCopy<$R, $Out>
    on ObjectCopyWith<$R, XenForoPost, $Out> {
  XenForoPostCopyWith<$R, XenForoPost, $Out> get $asXenForoPost =>
      $base.as((v, t, t2) => _XenForoPostCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class XenForoPostCopyWith<$R, $In extends XenForoPost, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  XenForoThreadCopyWith<$R, XenForoThread, XenForoThread>? get thread;
  ListCopyWith<
    $R,
    XenForoAttachment,
    XenForoAttachmentCopyWith<$R, XenForoAttachment, XenForoAttachment>
  >?
  get attachments;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>?
  get allowedContentVoteTypes;
  XenForoUserCopyWith<$R, XenForoUser, XenForoUser>? get user;
  $R call({
    String? username,
    bool? isFirstPost,
    bool? isLastPost,
    bool? isUnread,
    String? messageParsed,
    bool? canEdit,
    bool? canSoftDelete,
    bool? canHardDelete,
    bool? canReact,
    bool? canViewAttachments,
    String? viewUrl,
    XenForoThread? thread,
    List<XenForoAttachment>? attachments,
    bool? isReactedTo,
    int? visitorReactionId,
    int? voteScore,
    bool? canContentVote,
    List<String>? allowedContentVoteTypes,
    bool? isContentVoted,
    String? visitorContentVote,
    int? postId,
    int? threadId,
    int? userId,
    int? postDate,
    String? message,
    String? messageState,
    int? attachCount,
    String? warningMessage,
    int? position,
    int? lastEditDate,
    int? reactionScore,
    XenForoUser? user,
  });
  XenForoPostCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _XenForoPostCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, XenForoPost, $Out>
    implements XenForoPostCopyWith<$R, XenForoPost, $Out> {
  _XenForoPostCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<XenForoPost> $mapper =
      XenForoPostMapper.ensureInitialized();
  @override
  XenForoThreadCopyWith<$R, XenForoThread, XenForoThread>? get thread =>
      $value.thread?.copyWith.$chain((v) => call(thread: v));
  @override
  ListCopyWith<
    $R,
    XenForoAttachment,
    XenForoAttachmentCopyWith<$R, XenForoAttachment, XenForoAttachment>
  >?
  get attachments => $value.attachments != null
      ? ListCopyWith(
          $value.attachments!,
          (v, t) => v.copyWith.$chain(t),
          (v) => call(attachments: v),
        )
      : null;
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>?
  get allowedContentVoteTypes => $value.allowedContentVoteTypes != null
      ? ListCopyWith(
          $value.allowedContentVoteTypes!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(allowedContentVoteTypes: v),
        )
      : null;
  @override
  XenForoUserCopyWith<$R, XenForoUser, XenForoUser>? get user =>
      $value.user?.copyWith.$chain((v) => call(user: v));
  @override
  $R call({
    Object? username = $none,
    Object? isFirstPost = $none,
    Object? isLastPost = $none,
    Object? isUnread = $none,
    Object? messageParsed = $none,
    Object? canEdit = $none,
    Object? canSoftDelete = $none,
    Object? canHardDelete = $none,
    Object? canReact = $none,
    Object? canViewAttachments = $none,
    Object? viewUrl = $none,
    Object? thread = $none,
    Object? attachments = $none,
    Object? isReactedTo = $none,
    Object? visitorReactionId = $none,
    Object? voteScore = $none,
    Object? canContentVote = $none,
    Object? allowedContentVoteTypes = $none,
    Object? isContentVoted = $none,
    Object? visitorContentVote = $none,
    int? postId,
    Object? threadId = $none,
    Object? userId = $none,
    Object? postDate = $none,
    Object? message = $none,
    Object? messageState = $none,
    Object? attachCount = $none,
    Object? warningMessage = $none,
    Object? position = $none,
    Object? lastEditDate = $none,
    Object? reactionScore = $none,
    Object? user = $none,
  }) => $apply(
    FieldCopyWithData({
      if (username != $none) #username: username,
      if (isFirstPost != $none) #isFirstPost: isFirstPost,
      if (isLastPost != $none) #isLastPost: isLastPost,
      if (isUnread != $none) #isUnread: isUnread,
      if (messageParsed != $none) #messageParsed: messageParsed,
      if (canEdit != $none) #canEdit: canEdit,
      if (canSoftDelete != $none) #canSoftDelete: canSoftDelete,
      if (canHardDelete != $none) #canHardDelete: canHardDelete,
      if (canReact != $none) #canReact: canReact,
      if (canViewAttachments != $none) #canViewAttachments: canViewAttachments,
      if (viewUrl != $none) #viewUrl: viewUrl,
      if (thread != $none) #thread: thread,
      if (attachments != $none) #attachments: attachments,
      if (isReactedTo != $none) #isReactedTo: isReactedTo,
      if (visitorReactionId != $none) #visitorReactionId: visitorReactionId,
      if (voteScore != $none) #voteScore: voteScore,
      if (canContentVote != $none) #canContentVote: canContentVote,
      if (allowedContentVoteTypes != $none)
        #allowedContentVoteTypes: allowedContentVoteTypes,
      if (isContentVoted != $none) #isContentVoted: isContentVoted,
      if (visitorContentVote != $none) #visitorContentVote: visitorContentVote,
      if (postId != null) #postId: postId,
      if (threadId != $none) #threadId: threadId,
      if (userId != $none) #userId: userId,
      if (postDate != $none) #postDate: postDate,
      if (message != $none) #message: message,
      if (messageState != $none) #messageState: messageState,
      if (attachCount != $none) #attachCount: attachCount,
      if (warningMessage != $none) #warningMessage: warningMessage,
      if (position != $none) #position: position,
      if (lastEditDate != $none) #lastEditDate: lastEditDate,
      if (reactionScore != $none) #reactionScore: reactionScore,
      if (user != $none) #user: user,
    }),
  );
  @override
  XenForoPost $make(CopyWithData data) => XenForoPost(
    username: data.get(#username, or: $value.username),
    isFirstPost: data.get(#isFirstPost, or: $value.isFirstPost),
    isLastPost: data.get(#isLastPost, or: $value.isLastPost),
    isUnread: data.get(#isUnread, or: $value.isUnread),
    messageParsed: data.get(#messageParsed, or: $value.messageParsed),
    canEdit: data.get(#canEdit, or: $value.canEdit),
    canSoftDelete: data.get(#canSoftDelete, or: $value.canSoftDelete),
    canHardDelete: data.get(#canHardDelete, or: $value.canHardDelete),
    canReact: data.get(#canReact, or: $value.canReact),
    canViewAttachments: data.get(
      #canViewAttachments,
      or: $value.canViewAttachments,
    ),
    viewUrl: data.get(#viewUrl, or: $value.viewUrl),
    thread: data.get(#thread, or: $value.thread),
    attachments: data.get(#attachments, or: $value.attachments),
    isReactedTo: data.get(#isReactedTo, or: $value.isReactedTo),
    visitorReactionId: data.get(
      #visitorReactionId,
      or: $value.visitorReactionId,
    ),
    voteScore: data.get(#voteScore, or: $value.voteScore),
    canContentVote: data.get(#canContentVote, or: $value.canContentVote),
    allowedContentVoteTypes: data.get(
      #allowedContentVoteTypes,
      or: $value.allowedContentVoteTypes,
    ),
    isContentVoted: data.get(#isContentVoted, or: $value.isContentVoted),
    visitorContentVote: data.get(
      #visitorContentVote,
      or: $value.visitorContentVote,
    ),
    postId: data.get(#postId, or: $value.postId),
    threadId: data.get(#threadId, or: $value.threadId),
    userId: data.get(#userId, or: $value.userId),
    postDate: data.get(#postDate, or: $value.postDate),
    message: data.get(#message, or: $value.message),
    messageState: data.get(#messageState, or: $value.messageState),
    attachCount: data.get(#attachCount, or: $value.attachCount),
    warningMessage: data.get(#warningMessage, or: $value.warningMessage),
    position: data.get(#position, or: $value.position),
    lastEditDate: data.get(#lastEditDate, or: $value.lastEditDate),
    reactionScore: data.get(#reactionScore, or: $value.reactionScore),
    user: data.get(#user, or: $value.user),
  );

  @override
  XenForoPostCopyWith<$R2, XenForoPost, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _XenForoPostCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

