// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'thread.dart';

class XenForoThreadMapper extends ClassMapperBase<XenForoThread> {
  XenForoThreadMapper._();

  static XenForoThreadMapper? _instance;
  static XenForoThreadMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = XenForoThreadMapper._());
      XenForoNodeMapper.ensureInitialized();
      XenForoUserMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'XenForoThread';

  static String? _$username(XenForoThread v) => v.username;
  static const Field<XenForoThread, String> _f$username = Field(
    'username',
    _$username,
    opt: true,
  );
  static bool? _$isWatching(XenForoThread v) => v.isWatching;
  static const Field<XenForoThread, bool> _f$isWatching = Field(
    'isWatching',
    _$isWatching,
    opt: true,
  );
  static int? _$visitorPostCount(XenForoThread v) => v.visitorPostCount;
  static const Field<XenForoThread, int> _f$visitorPostCount = Field(
    'visitorPostCount',
    _$visitorPostCount,
    opt: true,
  );
  static bool? _$isUnread(XenForoThread v) => v.isUnread;
  static const Field<XenForoThread, bool> _f$isUnread = Field(
    'isUnread',
    _$isUnread,
    opt: true,
  );
  static Map<String, dynamic>? _$customFields(XenForoThread v) =>
      v.customFields;
  static const Field<XenForoThread, Map<String, dynamic>> _f$customFields =
      Field('customFields', _$customFields, opt: true);
  static List<String>? _$tags(XenForoThread v) => v.tags;
  static const Field<XenForoThread, List<String>> _f$tags = Field(
    'tags',
    _$tags,
    opt: true,
  );
  static String? _$prefix(XenForoThread v) => v.prefix;
  static const Field<XenForoThread, String> _f$prefix = Field(
    'prefix',
    _$prefix,
    opt: true,
  );
  static bool? _$canEdit(XenForoThread v) => v.canEdit;
  static const Field<XenForoThread, bool> _f$canEdit = Field(
    'canEdit',
    _$canEdit,
    opt: true,
  );
  static bool? _$canEditTags(XenForoThread v) => v.canEditTags;
  static const Field<XenForoThread, bool> _f$canEditTags = Field(
    'canEditTags',
    _$canEditTags,
    opt: true,
  );
  static bool? _$canReply(XenForoThread v) => v.canReply;
  static const Field<XenForoThread, bool> _f$canReply = Field(
    'canReply',
    _$canReply,
    opt: true,
  );
  static bool? _$canSoftDelete(XenForoThread v) => v.canSoftDelete;
  static const Field<XenForoThread, bool> _f$canSoftDelete = Field(
    'canSoftDelete',
    _$canSoftDelete,
    opt: true,
  );
  static bool? _$canHardDelete(XenForoThread v) => v.canHardDelete;
  static const Field<XenForoThread, bool> _f$canHardDelete = Field(
    'canHardDelete',
    _$canHardDelete,
    opt: true,
  );
  static bool? _$canViewAttachments(XenForoThread v) => v.canViewAttachments;
  static const Field<XenForoThread, bool> _f$canViewAttachments = Field(
    'canViewAttachments',
    _$canViewAttachments,
    opt: true,
  );
  static String? _$viewUrl(XenForoThread v) => v.viewUrl;
  static const Field<XenForoThread, String> _f$viewUrl = Field(
    'viewUrl',
    _$viewUrl,
    opt: true,
  );
  static bool? _$isFirstPostPinned(XenForoThread v) => v.isFirstPostPinned;
  static const Field<XenForoThread, bool> _f$isFirstPostPinned = Field(
    'isFirstPostPinned',
    _$isFirstPostPinned,
    opt: true,
  );
  static List<int>? _$highlightedPostIds(XenForoThread v) =>
      v.highlightedPostIds;
  static const Field<XenForoThread, List<int>> _f$highlightedPostIds = Field(
    'highlightedPostIds',
    _$highlightedPostIds,
    opt: true,
  );
  static bool? _$isSearchEngineIndexable(XenForoThread v) =>
      v.isSearchEngineIndexable;
  static const Field<XenForoThread, bool> _f$isSearchEngineIndexable = Field(
    'isSearchEngineIndexable',
    _$isSearchEngineIndexable,
    opt: true,
  );
  static String? _$indexState(XenForoThread v) => v.indexState;
  static const Field<XenForoThread, String> _f$indexState = Field(
    'indexState',
    _$indexState,
    opt: true,
  );
  static XenForoNode? _$forum(XenForoThread v) => v.forum;
  static const Field<XenForoThread, XenForoNode> _f$forum = Field(
    'forum',
    _$forum,
    opt: true,
  );
  static int? _$voteScore(XenForoThread v) => v.voteScore;
  static const Field<XenForoThread, int> _f$voteScore = Field(
    'voteScore',
    _$voteScore,
    opt: true,
  );
  static bool? _$canContentVote(XenForoThread v) => v.canContentVote;
  static const Field<XenForoThread, bool> _f$canContentVote = Field(
    'canContentVote',
    _$canContentVote,
    opt: true,
  );
  static List<String>? _$allowedContentVoteTypes(XenForoThread v) =>
      v.allowedContentVoteTypes;
  static const Field<XenForoThread, List<String>> _f$allowedContentVoteTypes =
      Field('allowedContentVoteTypes', _$allowedContentVoteTypes, opt: true);
  static bool? _$isContentVoted(XenForoThread v) => v.isContentVoted;
  static const Field<XenForoThread, bool> _f$isContentVoted = Field(
    'isContentVoted',
    _$isContentVoted,
    opt: true,
  );
  static String? _$visitorContentVote(XenForoThread v) => v.visitorContentVote;
  static const Field<XenForoThread, String> _f$visitorContentVote = Field(
    'visitorContentVote',
    _$visitorContentVote,
    opt: true,
  );
  static int _$threadId(XenForoThread v) => v.threadId;
  static const Field<XenForoThread, int> _f$threadId = Field(
    'threadId',
    _$threadId,
  );
  static int? _$nodeId(XenForoThread v) => v.nodeId;
  static const Field<XenForoThread, int> _f$nodeId = Field(
    'nodeId',
    _$nodeId,
    opt: true,
  );
  static String? _$title(XenForoThread v) => v.title;
  static const Field<XenForoThread, String> _f$title = Field(
    'title',
    _$title,
    opt: true,
  );
  static int? _$replyCount(XenForoThread v) => v.replyCount;
  static const Field<XenForoThread, int> _f$replyCount = Field(
    'replyCount',
    _$replyCount,
    opt: true,
  );
  static int? _$viewCount(XenForoThread v) => v.viewCount;
  static const Field<XenForoThread, int> _f$viewCount = Field(
    'viewCount',
    _$viewCount,
    opt: true,
  );
  static int? _$userId(XenForoThread v) => v.userId;
  static const Field<XenForoThread, int> _f$userId = Field(
    'userId',
    _$userId,
    opt: true,
  );
  static int? _$postDate(XenForoThread v) => v.postDate;
  static const Field<XenForoThread, int> _f$postDate = Field(
    'postDate',
    _$postDate,
    opt: true,
  );
  static bool? _$sticky(XenForoThread v) => v.sticky;
  static const Field<XenForoThread, bool> _f$sticky = Field(
    'sticky',
    _$sticky,
    opt: true,
  );
  static String? _$discussionState(XenForoThread v) => v.discussionState;
  static const Field<XenForoThread, String> _f$discussionState = Field(
    'discussionState',
    _$discussionState,
    opt: true,
  );
  static bool? _$discussionOpen(XenForoThread v) => v.discussionOpen;
  static const Field<XenForoThread, bool> _f$discussionOpen = Field(
    'discussionOpen',
    _$discussionOpen,
    opt: true,
  );
  static String? _$discussionType(XenForoThread v) => v.discussionType;
  static const Field<XenForoThread, String> _f$discussionType = Field(
    'discussionType',
    _$discussionType,
    opt: true,
  );
  static int? _$firstPostId(XenForoThread v) => v.firstPostId;
  static const Field<XenForoThread, int> _f$firstPostId = Field(
    'firstPostId',
    _$firstPostId,
    opt: true,
  );
  static int? _$lastPostDate(XenForoThread v) => v.lastPostDate;
  static const Field<XenForoThread, int> _f$lastPostDate = Field(
    'lastPostDate',
    _$lastPostDate,
    opt: true,
  );
  static int? _$lastPostId(XenForoThread v) => v.lastPostId;
  static const Field<XenForoThread, int> _f$lastPostId = Field(
    'lastPostId',
    _$lastPostId,
    opt: true,
  );
  static int? _$lastPostUserId(XenForoThread v) => v.lastPostUserId;
  static const Field<XenForoThread, int> _f$lastPostUserId = Field(
    'lastPostUserId',
    _$lastPostUserId,
    opt: true,
  );
  static String? _$lastPostUsername(XenForoThread v) => v.lastPostUsername;
  static const Field<XenForoThread, String> _f$lastPostUsername = Field(
    'lastPostUsername',
    _$lastPostUsername,
    opt: true,
  );
  static int? _$firstPostReactionScore(XenForoThread v) =>
      v.firstPostReactionScore;
  static const Field<XenForoThread, int> _f$firstPostReactionScore = Field(
    'firstPostReactionScore',
    _$firstPostReactionScore,
    opt: true,
  );
  static int? _$prefixId(XenForoThread v) => v.prefixId;
  static const Field<XenForoThread, int> _f$prefixId = Field(
    'prefixId',
    _$prefixId,
    opt: true,
  );
  static XenForoUser? _$user(XenForoThread v) => v.user;
  static const Field<XenForoThread, XenForoUser> _f$user = Field(
    'user',
    _$user,
    opt: true,
  );

  @override
  final MappableFields<XenForoThread> fields = const {
    #username: _f$username,
    #isWatching: _f$isWatching,
    #visitorPostCount: _f$visitorPostCount,
    #isUnread: _f$isUnread,
    #customFields: _f$customFields,
    #tags: _f$tags,
    #prefix: _f$prefix,
    #canEdit: _f$canEdit,
    #canEditTags: _f$canEditTags,
    #canReply: _f$canReply,
    #canSoftDelete: _f$canSoftDelete,
    #canHardDelete: _f$canHardDelete,
    #canViewAttachments: _f$canViewAttachments,
    #viewUrl: _f$viewUrl,
    #isFirstPostPinned: _f$isFirstPostPinned,
    #highlightedPostIds: _f$highlightedPostIds,
    #isSearchEngineIndexable: _f$isSearchEngineIndexable,
    #indexState: _f$indexState,
    #forum: _f$forum,
    #voteScore: _f$voteScore,
    #canContentVote: _f$canContentVote,
    #allowedContentVoteTypes: _f$allowedContentVoteTypes,
    #isContentVoted: _f$isContentVoted,
    #visitorContentVote: _f$visitorContentVote,
    #threadId: _f$threadId,
    #nodeId: _f$nodeId,
    #title: _f$title,
    #replyCount: _f$replyCount,
    #viewCount: _f$viewCount,
    #userId: _f$userId,
    #postDate: _f$postDate,
    #sticky: _f$sticky,
    #discussionState: _f$discussionState,
    #discussionOpen: _f$discussionOpen,
    #discussionType: _f$discussionType,
    #firstPostId: _f$firstPostId,
    #lastPostDate: _f$lastPostDate,
    #lastPostId: _f$lastPostId,
    #lastPostUserId: _f$lastPostUserId,
    #lastPostUsername: _f$lastPostUsername,
    #firstPostReactionScore: _f$firstPostReactionScore,
    #prefixId: _f$prefixId,
    #user: _f$user,
  };

  static XenForoThread _instantiate(DecodingData data) {
    return XenForoThread(
      username: data.dec(_f$username),
      isWatching: data.dec(_f$isWatching),
      visitorPostCount: data.dec(_f$visitorPostCount),
      isUnread: data.dec(_f$isUnread),
      customFields: data.dec(_f$customFields),
      tags: data.dec(_f$tags),
      prefix: data.dec(_f$prefix),
      canEdit: data.dec(_f$canEdit),
      canEditTags: data.dec(_f$canEditTags),
      canReply: data.dec(_f$canReply),
      canSoftDelete: data.dec(_f$canSoftDelete),
      canHardDelete: data.dec(_f$canHardDelete),
      canViewAttachments: data.dec(_f$canViewAttachments),
      viewUrl: data.dec(_f$viewUrl),
      isFirstPostPinned: data.dec(_f$isFirstPostPinned),
      highlightedPostIds: data.dec(_f$highlightedPostIds),
      isSearchEngineIndexable: data.dec(_f$isSearchEngineIndexable),
      indexState: data.dec(_f$indexState),
      forum: data.dec(_f$forum),
      voteScore: data.dec(_f$voteScore),
      canContentVote: data.dec(_f$canContentVote),
      allowedContentVoteTypes: data.dec(_f$allowedContentVoteTypes),
      isContentVoted: data.dec(_f$isContentVoted),
      visitorContentVote: data.dec(_f$visitorContentVote),
      threadId: data.dec(_f$threadId),
      nodeId: data.dec(_f$nodeId),
      title: data.dec(_f$title),
      replyCount: data.dec(_f$replyCount),
      viewCount: data.dec(_f$viewCount),
      userId: data.dec(_f$userId),
      postDate: data.dec(_f$postDate),
      sticky: data.dec(_f$sticky),
      discussionState: data.dec(_f$discussionState),
      discussionOpen: data.dec(_f$discussionOpen),
      discussionType: data.dec(_f$discussionType),
      firstPostId: data.dec(_f$firstPostId),
      lastPostDate: data.dec(_f$lastPostDate),
      lastPostId: data.dec(_f$lastPostId),
      lastPostUserId: data.dec(_f$lastPostUserId),
      lastPostUsername: data.dec(_f$lastPostUsername),
      firstPostReactionScore: data.dec(_f$firstPostReactionScore),
      prefixId: data.dec(_f$prefixId),
      user: data.dec(_f$user),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static XenForoThread fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<XenForoThread>(map);
  }

  static XenForoThread fromJson(String json) {
    return ensureInitialized().decodeJson<XenForoThread>(json);
  }
}

mixin XenForoThreadMappable {
  String toJson() {
    return XenForoThreadMapper.ensureInitialized().encodeJson<XenForoThread>(
      this as XenForoThread,
    );
  }

  Map<String, dynamic> toMap() {
    return XenForoThreadMapper.ensureInitialized().encodeMap<XenForoThread>(
      this as XenForoThread,
    );
  }

  XenForoThreadCopyWith<XenForoThread, XenForoThread, XenForoThread>
  get copyWith => _XenForoThreadCopyWithImpl<XenForoThread, XenForoThread>(
    this as XenForoThread,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return XenForoThreadMapper.ensureInitialized().stringifyValue(
      this as XenForoThread,
    );
  }

  @override
  bool operator ==(Object other) {
    return XenForoThreadMapper.ensureInitialized().equalsValue(
      this as XenForoThread,
      other,
    );
  }

  @override
  int get hashCode {
    return XenForoThreadMapper.ensureInitialized().hashValue(
      this as XenForoThread,
    );
  }
}

extension XenForoThreadValueCopy<$R, $Out>
    on ObjectCopyWith<$R, XenForoThread, $Out> {
  XenForoThreadCopyWith<$R, XenForoThread, $Out> get $asXenForoThread =>
      $base.as((v, t, t2) => _XenForoThreadCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class XenForoThreadCopyWith<$R, $In extends XenForoThread, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>?
  get customFields;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>? get tags;
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>>? get highlightedPostIds;
  XenForoNodeCopyWith<$R, XenForoNode, XenForoNode>? get forum;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>?
  get allowedContentVoteTypes;
  XenForoUserCopyWith<$R, XenForoUser, XenForoUser>? get user;
  $R call({
    String? username,
    bool? isWatching,
    int? visitorPostCount,
    bool? isUnread,
    Map<String, dynamic>? customFields,
    List<String>? tags,
    String? prefix,
    bool? canEdit,
    bool? canEditTags,
    bool? canReply,
    bool? canSoftDelete,
    bool? canHardDelete,
    bool? canViewAttachments,
    String? viewUrl,
    bool? isFirstPostPinned,
    List<int>? highlightedPostIds,
    bool? isSearchEngineIndexable,
    String? indexState,
    XenForoNode? forum,
    int? voteScore,
    bool? canContentVote,
    List<String>? allowedContentVoteTypes,
    bool? isContentVoted,
    String? visitorContentVote,
    int? threadId,
    int? nodeId,
    String? title,
    int? replyCount,
    int? viewCount,
    int? userId,
    int? postDate,
    bool? sticky,
    String? discussionState,
    bool? discussionOpen,
    String? discussionType,
    int? firstPostId,
    int? lastPostDate,
    int? lastPostId,
    int? lastPostUserId,
    String? lastPostUsername,
    int? firstPostReactionScore,
    int? prefixId,
    XenForoUser? user,
  });
  XenForoThreadCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _XenForoThreadCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, XenForoThread, $Out>
    implements XenForoThreadCopyWith<$R, XenForoThread, $Out> {
  _XenForoThreadCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<XenForoThread> $mapper =
      XenForoThreadMapper.ensureInitialized();
  @override
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>?
  get customFields => $value.customFields != null
      ? MapCopyWith(
          $value.customFields!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(customFields: v),
        )
      : null;
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>? get tags =>
      $value.tags != null
      ? ListCopyWith(
          $value.tags!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(tags: v),
        )
      : null;
  @override
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>>? get highlightedPostIds =>
      $value.highlightedPostIds != null
      ? ListCopyWith(
          $value.highlightedPostIds!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(highlightedPostIds: v),
        )
      : null;
  @override
  XenForoNodeCopyWith<$R, XenForoNode, XenForoNode>? get forum =>
      $value.forum?.copyWith.$chain((v) => call(forum: v));
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
    Object? isWatching = $none,
    Object? visitorPostCount = $none,
    Object? isUnread = $none,
    Object? customFields = $none,
    Object? tags = $none,
    Object? prefix = $none,
    Object? canEdit = $none,
    Object? canEditTags = $none,
    Object? canReply = $none,
    Object? canSoftDelete = $none,
    Object? canHardDelete = $none,
    Object? canViewAttachments = $none,
    Object? viewUrl = $none,
    Object? isFirstPostPinned = $none,
    Object? highlightedPostIds = $none,
    Object? isSearchEngineIndexable = $none,
    Object? indexState = $none,
    Object? forum = $none,
    Object? voteScore = $none,
    Object? canContentVote = $none,
    Object? allowedContentVoteTypes = $none,
    Object? isContentVoted = $none,
    Object? visitorContentVote = $none,
    int? threadId,
    Object? nodeId = $none,
    Object? title = $none,
    Object? replyCount = $none,
    Object? viewCount = $none,
    Object? userId = $none,
    Object? postDate = $none,
    Object? sticky = $none,
    Object? discussionState = $none,
    Object? discussionOpen = $none,
    Object? discussionType = $none,
    Object? firstPostId = $none,
    Object? lastPostDate = $none,
    Object? lastPostId = $none,
    Object? lastPostUserId = $none,
    Object? lastPostUsername = $none,
    Object? firstPostReactionScore = $none,
    Object? prefixId = $none,
    Object? user = $none,
  }) => $apply(
    FieldCopyWithData({
      if (username != $none) #username: username,
      if (isWatching != $none) #isWatching: isWatching,
      if (visitorPostCount != $none) #visitorPostCount: visitorPostCount,
      if (isUnread != $none) #isUnread: isUnread,
      if (customFields != $none) #customFields: customFields,
      if (tags != $none) #tags: tags,
      if (prefix != $none) #prefix: prefix,
      if (canEdit != $none) #canEdit: canEdit,
      if (canEditTags != $none) #canEditTags: canEditTags,
      if (canReply != $none) #canReply: canReply,
      if (canSoftDelete != $none) #canSoftDelete: canSoftDelete,
      if (canHardDelete != $none) #canHardDelete: canHardDelete,
      if (canViewAttachments != $none) #canViewAttachments: canViewAttachments,
      if (viewUrl != $none) #viewUrl: viewUrl,
      if (isFirstPostPinned != $none) #isFirstPostPinned: isFirstPostPinned,
      if (highlightedPostIds != $none) #highlightedPostIds: highlightedPostIds,
      if (isSearchEngineIndexable != $none)
        #isSearchEngineIndexable: isSearchEngineIndexable,
      if (indexState != $none) #indexState: indexState,
      if (forum != $none) #forum: forum,
      if (voteScore != $none) #voteScore: voteScore,
      if (canContentVote != $none) #canContentVote: canContentVote,
      if (allowedContentVoteTypes != $none)
        #allowedContentVoteTypes: allowedContentVoteTypes,
      if (isContentVoted != $none) #isContentVoted: isContentVoted,
      if (visitorContentVote != $none) #visitorContentVote: visitorContentVote,
      if (threadId != null) #threadId: threadId,
      if (nodeId != $none) #nodeId: nodeId,
      if (title != $none) #title: title,
      if (replyCount != $none) #replyCount: replyCount,
      if (viewCount != $none) #viewCount: viewCount,
      if (userId != $none) #userId: userId,
      if (postDate != $none) #postDate: postDate,
      if (sticky != $none) #sticky: sticky,
      if (discussionState != $none) #discussionState: discussionState,
      if (discussionOpen != $none) #discussionOpen: discussionOpen,
      if (discussionType != $none) #discussionType: discussionType,
      if (firstPostId != $none) #firstPostId: firstPostId,
      if (lastPostDate != $none) #lastPostDate: lastPostDate,
      if (lastPostId != $none) #lastPostId: lastPostId,
      if (lastPostUserId != $none) #lastPostUserId: lastPostUserId,
      if (lastPostUsername != $none) #lastPostUsername: lastPostUsername,
      if (firstPostReactionScore != $none)
        #firstPostReactionScore: firstPostReactionScore,
      if (prefixId != $none) #prefixId: prefixId,
      if (user != $none) #user: user,
    }),
  );
  @override
  XenForoThread $make(CopyWithData data) => XenForoThread(
    username: data.get(#username, or: $value.username),
    isWatching: data.get(#isWatching, or: $value.isWatching),
    visitorPostCount: data.get(#visitorPostCount, or: $value.visitorPostCount),
    isUnread: data.get(#isUnread, or: $value.isUnread),
    customFields: data.get(#customFields, or: $value.customFields),
    tags: data.get(#tags, or: $value.tags),
    prefix: data.get(#prefix, or: $value.prefix),
    canEdit: data.get(#canEdit, or: $value.canEdit),
    canEditTags: data.get(#canEditTags, or: $value.canEditTags),
    canReply: data.get(#canReply, or: $value.canReply),
    canSoftDelete: data.get(#canSoftDelete, or: $value.canSoftDelete),
    canHardDelete: data.get(#canHardDelete, or: $value.canHardDelete),
    canViewAttachments: data.get(
      #canViewAttachments,
      or: $value.canViewAttachments,
    ),
    viewUrl: data.get(#viewUrl, or: $value.viewUrl),
    isFirstPostPinned: data.get(
      #isFirstPostPinned,
      or: $value.isFirstPostPinned,
    ),
    highlightedPostIds: data.get(
      #highlightedPostIds,
      or: $value.highlightedPostIds,
    ),
    isSearchEngineIndexable: data.get(
      #isSearchEngineIndexable,
      or: $value.isSearchEngineIndexable,
    ),
    indexState: data.get(#indexState, or: $value.indexState),
    forum: data.get(#forum, or: $value.forum),
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
    threadId: data.get(#threadId, or: $value.threadId),
    nodeId: data.get(#nodeId, or: $value.nodeId),
    title: data.get(#title, or: $value.title),
    replyCount: data.get(#replyCount, or: $value.replyCount),
    viewCount: data.get(#viewCount, or: $value.viewCount),
    userId: data.get(#userId, or: $value.userId),
    postDate: data.get(#postDate, or: $value.postDate),
    sticky: data.get(#sticky, or: $value.sticky),
    discussionState: data.get(#discussionState, or: $value.discussionState),
    discussionOpen: data.get(#discussionOpen, or: $value.discussionOpen),
    discussionType: data.get(#discussionType, or: $value.discussionType),
    firstPostId: data.get(#firstPostId, or: $value.firstPostId),
    lastPostDate: data.get(#lastPostDate, or: $value.lastPostDate),
    lastPostId: data.get(#lastPostId, or: $value.lastPostId),
    lastPostUserId: data.get(#lastPostUserId, or: $value.lastPostUserId),
    lastPostUsername: data.get(#lastPostUsername, or: $value.lastPostUsername),
    firstPostReactionScore: data.get(
      #firstPostReactionScore,
      or: $value.firstPostReactionScore,
    ),
    prefixId: data.get(#prefixId, or: $value.prefixId),
    user: data.get(#user, or: $value.user),
  );

  @override
  XenForoThreadCopyWith<$R2, XenForoThread, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _XenForoThreadCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

