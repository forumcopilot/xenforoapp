// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fc_post_result.dart';

class FCThreadResultMapper extends ClassMapperBase<FCThreadResult> {
  FCThreadResultMapper._();

  static FCThreadResultMapper? _instance;
  static FCThreadResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCThreadResultMapper._());
      FCTopicMapper.ensureInitialized();
      FCPostMapper.ensureInitialized();
      FCPollMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCThreadResult';

  static bool _$result(FCThreadResult v) => v.result;
  static const Field<FCThreadResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCThreadResult v) => v.resultText;
  static const Field<FCThreadResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static int _$totalPostNum(FCThreadResult v) => v.totalPostNum;
  static const Field<FCThreadResult, int> _f$totalPostNum = Field(
    'totalPostNum',
    _$totalPostNum,
  );
  static List<FCPost> _$posts(FCThreadResult v) => v.posts;
  static const Field<FCThreadResult, List<FCPost>> _f$posts = Field(
    'posts',
    _$posts,
    opt: true,
    def: const [],
  );
  static String _$id(FCThreadResult v) => v.id;
  static const Field<FCThreadResult, String> _f$id = Field('id', _$id);
  static String _$title(FCThreadResult v) => v.title;
  static const Field<FCThreadResult, String> _f$title = Field('title', _$title);
  static String _$forumId(FCThreadResult v) => v.forumId;
  static const Field<FCThreadResult, String> _f$forumId = Field(
    'forumId',
    _$forumId,
  );
  static String _$forumName(FCThreadResult v) => v.forumName;
  static const Field<FCThreadResult, String> _f$forumName = Field(
    'forumName',
    _$forumName,
  );
  static String _$authorId(FCThreadResult v) => v.authorId;
  static const Field<FCThreadResult, String> _f$authorId = Field(
    'authorId',
    _$authorId,
  );
  static String _$authorName(FCThreadResult v) => v.authorName;
  static const Field<FCThreadResult, String> _f$authorName = Field(
    'authorName',
    _$authorName,
  );
  static String? _$authorUserType(FCThreadResult v) => v.authorUserType;
  static const Field<FCThreadResult, String> _f$authorUserType = Field(
    'authorUserType',
    _$authorUserType,
  );
  static DateTime _$timestamp(FCThreadResult v) => v.timestamp;
  static const Field<FCThreadResult, DateTime> _f$timestamp = Field(
    'timestamp',
    _$timestamp,
    hook: MillisOrIsoDateHook(),
  );
  static String? _$prefix(FCThreadResult v) => v.prefix;
  static const Field<FCThreadResult, String> _f$prefix = Field(
    'prefix',
    _$prefix,
    opt: true,
  );
  static String? _$authorIconUrl(FCThreadResult v) => v.authorIconUrl;
  static const Field<FCThreadResult, String> _f$authorIconUrl = Field(
    'authorIconUrl',
    _$authorIconUrl,
    opt: true,
  );
  static int _$replyCount(FCThreadResult v) => v.replyCount;
  static const Field<FCThreadResult, int> _f$replyCount = Field(
    'replyCount',
    _$replyCount,
    opt: true,
    def: 0,
  );
  static int _$viewCount(FCThreadResult v) => v.viewCount;
  static const Field<FCThreadResult, int> _f$viewCount = Field(
    'viewCount',
    _$viewCount,
    opt: true,
    def: 0,
  );
  static bool _$hasNewPosts(FCThreadResult v) => v.hasNewPosts;
  static const Field<FCThreadResult, bool> _f$hasNewPosts = Field(
    'hasNewPosts',
    _$hasNewPosts,
    opt: true,
    def: false,
  );
  static bool _$isClosed(FCThreadResult v) => v.isClosed;
  static const Field<FCThreadResult, bool> _f$isClosed = Field(
    'isClosed',
    _$isClosed,
    opt: true,
    def: false,
  );
  static bool _$isSubscribed(FCThreadResult v) => v.isSubscribed;
  static const Field<FCThreadResult, bool> _f$isSubscribed = Field(
    'isSubscribed',
    _$isSubscribed,
    opt: true,
    def: false,
  );
  static bool _$canSubscribe(FCThreadResult v) => v.canSubscribe;
  static const Field<FCThreadResult, bool> _f$canSubscribe = Field(
    'canSubscribe',
    _$canSubscribe,
    opt: true,
    def: true,
  );
  static String? _$url(FCThreadResult v) => v.url;
  static const Field<FCThreadResult, String> _f$url = Field(
    'url',
    _$url,
    opt: true,
  );
  static String? _$shortContent(FCThreadResult v) => v.shortContent;
  static const Field<FCThreadResult, String> _f$shortContent = Field(
    'shortContent',
    _$shortContent,
    opt: true,
  );
  static List<String> _$participatedUserIds(FCThreadResult v) =>
      v.participatedUserIds;
  static const Field<FCThreadResult, List<String>> _f$participatedUserIds =
      Field(
        'participatedUserIds',
        _$participatedUserIds,
        opt: true,
        def: const [],
      );
  static bool _$isPinned(FCThreadResult v) => v.isPinned;
  static const Field<FCThreadResult, bool> _f$isPinned = Field(
    'isPinned',
    _$isPinned,
    opt: true,
    def: false,
    hook: FlexibleBoolHook(),
  );
  static bool _$isAnnouncement(FCThreadResult v) => v.isAnnouncement;
  static const Field<FCThreadResult, bool> _f$isAnnouncement = Field(
    'isAnnouncement',
    _$isAnnouncement,
    opt: true,
    def: false,
  );
  static bool _$isStickySource(FCThreadResult v) => v.isStickySource;
  static const Field<FCThreadResult, bool> _f$isStickySource = Field(
    'isStickySource',
    _$isStickySource,
    opt: true,
    def: false,
  );
  static bool _$canRename(FCThreadResult v) => v.canRename;
  static const Field<FCThreadResult, bool> _f$canRename = Field(
    'canRename',
    _$canRename,
    opt: true,
    def: false,
  );
  static bool _$canDelete(FCThreadResult v) => v.canDelete;
  static const Field<FCThreadResult, bool> _f$canDelete = Field(
    'canDelete',
    _$canDelete,
    opt: true,
    def: false,
  );
  static bool _$canClose(FCThreadResult v) => v.canClose;
  static const Field<FCThreadResult, bool> _f$canClose = Field(
    'canClose',
    _$canClose,
    opt: true,
    def: false,
  );
  static bool _$canApprove(FCThreadResult v) => v.canApprove;
  static const Field<FCThreadResult, bool> _f$canApprove = Field(
    'canApprove',
    _$canApprove,
    opt: true,
    def: false,
  );
  static bool _$canStick(FCThreadResult v) => v.canStick;
  static const Field<FCThreadResult, bool> _f$canStick = Field(
    'canStick',
    _$canStick,
    opt: true,
    def: false,
  );
  static bool _$canMove(FCThreadResult v) => v.canMove;
  static const Field<FCThreadResult, bool> _f$canMove = Field(
    'canMove',
    _$canMove,
    opt: true,
    def: false,
  );
  static bool _$canMerge(FCThreadResult v) => v.canMerge;
  static const Field<FCThreadResult, bool> _f$canMerge = Field(
    'canMerge',
    _$canMerge,
    opt: true,
    def: false,
  );
  static bool _$canBan(FCThreadResult v) => v.canBan;
  static const Field<FCThreadResult, bool> _f$canBan = Field(
    'canBan',
    _$canBan,
    opt: true,
    def: false,
  );
  static bool _$canReply(FCThreadResult v) => v.canReply;
  static const Field<FCThreadResult, bool> _f$canReply = Field(
    'canReply',
    _$canReply,
    opt: true,
    def: false,
  );
  static bool _$canReport(FCThreadResult v) => v.canReport;
  static const Field<FCThreadResult, bool> _f$canReport = Field(
    'canReport',
    _$canReport,
    opt: true,
    def: false,
  );
  static bool _$canUpload(FCThreadResult v) => v.canUpload;
  static const Field<FCThreadResult, bool> _f$canUpload = Field(
    'canUpload',
    _$canUpload,
    opt: true,
    def: false,
  );
  static bool _$isBanned(FCThreadResult v) => v.isBanned;
  static const Field<FCThreadResult, bool> _f$isBanned = Field(
    'isBanned',
    _$isBanned,
    opt: true,
    def: false,
  );
  static bool _$isApproved(FCThreadResult v) => v.isApproved;
  static const Field<FCThreadResult, bool> _f$isApproved = Field(
    'isApproved',
    _$isApproved,
    opt: true,
    def: true,
  );
  static bool _$isDeleted(FCThreadResult v) => v.isDeleted;
  static const Field<FCThreadResult, bool> _f$isDeleted = Field(
    'isDeleted',
    _$isDeleted,
    opt: true,
    def: false,
  );
  static bool _$isMoved(FCThreadResult v) => v.isMoved;
  static const Field<FCThreadResult, bool> _f$isMoved = Field(
    'isMoved',
    _$isMoved,
    opt: true,
    def: false,
  );
  static bool _$isMerged(FCThreadResult v) => v.isMerged;
  static const Field<FCThreadResult, bool> _f$isMerged = Field(
    'isMerged',
    _$isMerged,
    opt: true,
    def: false,
  );
  static String? _$realTopicId(FCThreadResult v) => v.realTopicId;
  static const Field<FCThreadResult, String> _f$realTopicId = Field(
    'realTopicId',
    _$realTopicId,
    opt: true,
  );
  static bool _$canLike(FCThreadResult v) => v.canLike;
  static const Field<FCThreadResult, bool> _f$canLike = Field(
    'canLike',
    _$canLike,
    opt: true,
    def: false,
  );
  static bool _$isLiked(FCThreadResult v) => v.isLiked;
  static const Field<FCThreadResult, bool> _f$isLiked = Field(
    'isLiked',
    _$isLiked,
    opt: true,
    def: false,
  );
  static int _$likeCount(FCThreadResult v) => v.likeCount;
  static const Field<FCThreadResult, int> _f$likeCount = Field(
    'likeCount',
    _$likeCount,
    opt: true,
    def: 0,
  );
  static bool _$canThank(FCThreadResult v) => v.canThank;
  static const Field<FCThreadResult, bool> _f$canThank = Field(
    'canThank',
    _$canThank,
    opt: true,
    def: false,
  );
  static bool _$hasPoll(FCThreadResult v) => v.hasPoll;
  static const Field<FCThreadResult, bool> _f$hasPoll = Field(
    'hasPoll',
    _$hasPoll,
    opt: true,
    def: false,
  );
  static FCPoll? _$poll(FCThreadResult v) => v.poll;
  static const Field<FCThreadResult, FCPoll> _f$poll = Field(
    'poll',
    _$poll,
    opt: true,
  );

  @override
  final MappableFields<FCThreadResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #totalPostNum: _f$totalPostNum,
    #posts: _f$posts,
    #id: _f$id,
    #title: _f$title,
    #forumId: _f$forumId,
    #forumName: _f$forumName,
    #authorId: _f$authorId,
    #authorName: _f$authorName,
    #authorUserType: _f$authorUserType,
    #timestamp: _f$timestamp,
    #prefix: _f$prefix,
    #authorIconUrl: _f$authorIconUrl,
    #replyCount: _f$replyCount,
    #viewCount: _f$viewCount,
    #hasNewPosts: _f$hasNewPosts,
    #isClosed: _f$isClosed,
    #isSubscribed: _f$isSubscribed,
    #canSubscribe: _f$canSubscribe,
    #url: _f$url,
    #shortContent: _f$shortContent,
    #participatedUserIds: _f$participatedUserIds,
    #isPinned: _f$isPinned,
    #isAnnouncement: _f$isAnnouncement,
    #isStickySource: _f$isStickySource,
    #canRename: _f$canRename,
    #canDelete: _f$canDelete,
    #canClose: _f$canClose,
    #canApprove: _f$canApprove,
    #canStick: _f$canStick,
    #canMove: _f$canMove,
    #canMerge: _f$canMerge,
    #canBan: _f$canBan,
    #canReply: _f$canReply,
    #canReport: _f$canReport,
    #canUpload: _f$canUpload,
    #isBanned: _f$isBanned,
    #isApproved: _f$isApproved,
    #isDeleted: _f$isDeleted,
    #isMoved: _f$isMoved,
    #isMerged: _f$isMerged,
    #realTopicId: _f$realTopicId,
    #canLike: _f$canLike,
    #isLiked: _f$isLiked,
    #likeCount: _f$likeCount,
    #canThank: _f$canThank,
    #hasPoll: _f$hasPoll,
    #poll: _f$poll,
  };

  static FCThreadResult _instantiate(DecodingData data) {
    return FCThreadResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      totalPostNum: data.dec(_f$totalPostNum),
      posts: data.dec(_f$posts),
      id: data.dec(_f$id),
      title: data.dec(_f$title),
      forumId: data.dec(_f$forumId),
      forumName: data.dec(_f$forumName),
      authorId: data.dec(_f$authorId),
      authorName: data.dec(_f$authorName),
      authorUserType: data.dec(_f$authorUserType),
      timestamp: data.dec(_f$timestamp),
      prefix: data.dec(_f$prefix),
      authorIconUrl: data.dec(_f$authorIconUrl),
      replyCount: data.dec(_f$replyCount),
      viewCount: data.dec(_f$viewCount),
      hasNewPosts: data.dec(_f$hasNewPosts),
      isClosed: data.dec(_f$isClosed),
      isSubscribed: data.dec(_f$isSubscribed),
      canSubscribe: data.dec(_f$canSubscribe),
      url: data.dec(_f$url),
      shortContent: data.dec(_f$shortContent),
      participatedUserIds: data.dec(_f$participatedUserIds),
      isPinned: data.dec(_f$isPinned),
      isAnnouncement: data.dec(_f$isAnnouncement),
      isStickySource: data.dec(_f$isStickySource),
      canRename: data.dec(_f$canRename),
      canDelete: data.dec(_f$canDelete),
      canClose: data.dec(_f$canClose),
      canApprove: data.dec(_f$canApprove),
      canStick: data.dec(_f$canStick),
      canMove: data.dec(_f$canMove),
      canMerge: data.dec(_f$canMerge),
      canBan: data.dec(_f$canBan),
      canReply: data.dec(_f$canReply),
      canReport: data.dec(_f$canReport),
      canUpload: data.dec(_f$canUpload),
      isBanned: data.dec(_f$isBanned),
      isApproved: data.dec(_f$isApproved),
      isDeleted: data.dec(_f$isDeleted),
      isMoved: data.dec(_f$isMoved),
      isMerged: data.dec(_f$isMerged),
      realTopicId: data.dec(_f$realTopicId),
      canLike: data.dec(_f$canLike),
      isLiked: data.dec(_f$isLiked),
      likeCount: data.dec(_f$likeCount),
      canThank: data.dec(_f$canThank),
      hasPoll: data.dec(_f$hasPoll),
      poll: data.dec(_f$poll),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCThreadResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCThreadResult>(map);
  }

  static FCThreadResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCThreadResult>(json);
  }
}

mixin FCThreadResultMappable {
  String toJson() {
    return FCThreadResultMapper.ensureInitialized().encodeJson<FCThreadResult>(
      this as FCThreadResult,
    );
  }

  Map<String, dynamic> toMap() {
    return FCThreadResultMapper.ensureInitialized().encodeMap<FCThreadResult>(
      this as FCThreadResult,
    );
  }

  FCThreadResultCopyWith<FCThreadResult, FCThreadResult, FCThreadResult>
  get copyWith => _FCThreadResultCopyWithImpl<FCThreadResult, FCThreadResult>(
    this as FCThreadResult,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return FCThreadResultMapper.ensureInitialized().stringifyValue(
      this as FCThreadResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCThreadResultMapper.ensureInitialized().equalsValue(
      this as FCThreadResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCThreadResultMapper.ensureInitialized().hashValue(
      this as FCThreadResult,
    );
  }
}

extension FCThreadResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCThreadResult, $Out> {
  FCThreadResultCopyWith<$R, FCThreadResult, $Out> get $asFCThreadResult =>
      $base.as((v, t, t2) => _FCThreadResultCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCThreadResultCopyWith<$R, $In extends FCThreadResult, $Out>
    implements FCTopicCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, FCPost, FCPostCopyWith<$R, FCPost, FCPost>> get posts;
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get participatedUserIds;
  @override
  FCPollCopyWith<$R, FCPoll, FCPoll>? get poll;
  @override
  $R call({
    bool? result,
    String? resultText,
    int? totalPostNum,
    List<FCPost>? posts,
    String? id,
    String? title,
    String? forumId,
    String? forumName,
    String? authorId,
    String? authorName,
    covariant String? authorUserType,
    DateTime? timestamp,
    String? prefix,
    String? authorIconUrl,
    int? replyCount,
    int? viewCount,
    bool? hasNewPosts,
    bool? isClosed,
    bool? isSubscribed,
    bool? canSubscribe,
    String? url,
    String? shortContent,
    List<String>? participatedUserIds,
    bool? isPinned,
    bool? isAnnouncement,
    bool? isStickySource,
    bool? canRename,
    bool? canDelete,
    bool? canClose,
    bool? canApprove,
    bool? canStick,
    bool? canMove,
    bool? canMerge,
    bool? canBan,
    bool? canReply,
    bool? canReport,
    bool? canUpload,
    bool? isBanned,
    bool? isApproved,
    bool? isDeleted,
    bool? isMoved,
    bool? isMerged,
    String? realTopicId,
    bool? canLike,
    bool? isLiked,
    int? likeCount,
    bool? canThank,
    bool? hasPoll,
    FCPoll? poll,
  });
  FCThreadResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCThreadResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCThreadResult, $Out>
    implements FCThreadResultCopyWith<$R, FCThreadResult, $Out> {
  _FCThreadResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCThreadResult> $mapper =
      FCThreadResultMapper.ensureInitialized();
  @override
  ListCopyWith<$R, FCPost, FCPostCopyWith<$R, FCPost, FCPost>> get posts =>
      ListCopyWith(
        $value.posts,
        (v, t) => v.copyWith.$chain(t),
        (v) => call(posts: v),
      );
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get participatedUserIds => ListCopyWith(
    $value.participatedUserIds,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(participatedUserIds: v),
  );
  @override
  FCPollCopyWith<$R, FCPoll, FCPoll>? get poll =>
      $value.poll?.copyWith.$chain((v) => call(poll: v));
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
    int? totalPostNum,
    List<FCPost>? posts,
    String? id,
    String? title,
    String? forumId,
    String? forumName,
    String? authorId,
    String? authorName,
    String? authorUserType,
    DateTime? timestamp,
    Object? prefix = $none,
    Object? authorIconUrl = $none,
    int? replyCount,
    int? viewCount,
    bool? hasNewPosts,
    bool? isClosed,
    bool? isSubscribed,
    bool? canSubscribe,
    Object? url = $none,
    Object? shortContent = $none,
    List<String>? participatedUserIds,
    bool? isPinned,
    bool? isAnnouncement,
    bool? isStickySource,
    bool? canRename,
    bool? canDelete,
    bool? canClose,
    bool? canApprove,
    bool? canStick,
    bool? canMove,
    bool? canMerge,
    bool? canBan,
    bool? canReply,
    bool? canReport,
    bool? canUpload,
    bool? isBanned,
    bool? isApproved,
    bool? isDeleted,
    bool? isMoved,
    bool? isMerged,
    Object? realTopicId = $none,
    bool? canLike,
    bool? isLiked,
    int? likeCount,
    bool? canThank,
    bool? hasPoll,
    Object? poll = $none,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (totalPostNum != null) #totalPostNum: totalPostNum,
      if (posts != null) #posts: posts,
      if (id != null) #id: id,
      if (title != null) #title: title,
      if (forumId != null) #forumId: forumId,
      if (forumName != null) #forumName: forumName,
      if (authorId != null) #authorId: authorId,
      if (authorName != null) #authorName: authorName,
      if (authorUserType != null) #authorUserType: authorUserType,
      if (timestamp != null) #timestamp: timestamp,
      if (prefix != $none) #prefix: prefix,
      if (authorIconUrl != $none) #authorIconUrl: authorIconUrl,
      if (replyCount != null) #replyCount: replyCount,
      if (viewCount != null) #viewCount: viewCount,
      if (hasNewPosts != null) #hasNewPosts: hasNewPosts,
      if (isClosed != null) #isClosed: isClosed,
      if (isSubscribed != null) #isSubscribed: isSubscribed,
      if (canSubscribe != null) #canSubscribe: canSubscribe,
      if (url != $none) #url: url,
      if (shortContent != $none) #shortContent: shortContent,
      if (participatedUserIds != null)
        #participatedUserIds: participatedUserIds,
      if (isPinned != null) #isPinned: isPinned,
      if (isAnnouncement != null) #isAnnouncement: isAnnouncement,
      if (isStickySource != null) #isStickySource: isStickySource,
      if (canRename != null) #canRename: canRename,
      if (canDelete != null) #canDelete: canDelete,
      if (canClose != null) #canClose: canClose,
      if (canApprove != null) #canApprove: canApprove,
      if (canStick != null) #canStick: canStick,
      if (canMove != null) #canMove: canMove,
      if (canMerge != null) #canMerge: canMerge,
      if (canBan != null) #canBan: canBan,
      if (canReply != null) #canReply: canReply,
      if (canReport != null) #canReport: canReport,
      if (canUpload != null) #canUpload: canUpload,
      if (isBanned != null) #isBanned: isBanned,
      if (isApproved != null) #isApproved: isApproved,
      if (isDeleted != null) #isDeleted: isDeleted,
      if (isMoved != null) #isMoved: isMoved,
      if (isMerged != null) #isMerged: isMerged,
      if (realTopicId != $none) #realTopicId: realTopicId,
      if (canLike != null) #canLike: canLike,
      if (isLiked != null) #isLiked: isLiked,
      if (likeCount != null) #likeCount: likeCount,
      if (canThank != null) #canThank: canThank,
      if (hasPoll != null) #hasPoll: hasPoll,
      if (poll != $none) #poll: poll,
    }),
  );
  @override
  FCThreadResult $make(CopyWithData data) => FCThreadResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    totalPostNum: data.get(#totalPostNum, or: $value.totalPostNum),
    posts: data.get(#posts, or: $value.posts),
    id: data.get(#id, or: $value.id),
    title: data.get(#title, or: $value.title),
    forumId: data.get(#forumId, or: $value.forumId),
    forumName: data.get(#forumName, or: $value.forumName),
    authorId: data.get(#authorId, or: $value.authorId),
    authorName: data.get(#authorName, or: $value.authorName),
    authorUserType: data.get(#authorUserType, or: $value.authorUserType),
    timestamp: data.get(#timestamp, or: $value.timestamp),
    prefix: data.get(#prefix, or: $value.prefix),
    authorIconUrl: data.get(#authorIconUrl, or: $value.authorIconUrl),
    replyCount: data.get(#replyCount, or: $value.replyCount),
    viewCount: data.get(#viewCount, or: $value.viewCount),
    hasNewPosts: data.get(#hasNewPosts, or: $value.hasNewPosts),
    isClosed: data.get(#isClosed, or: $value.isClosed),
    isSubscribed: data.get(#isSubscribed, or: $value.isSubscribed),
    canSubscribe: data.get(#canSubscribe, or: $value.canSubscribe),
    url: data.get(#url, or: $value.url),
    shortContent: data.get(#shortContent, or: $value.shortContent),
    participatedUserIds: data.get(
      #participatedUserIds,
      or: $value.participatedUserIds,
    ),
    isPinned: data.get(#isPinned, or: $value.isPinned),
    isAnnouncement: data.get(#isAnnouncement, or: $value.isAnnouncement),
    isStickySource: data.get(#isStickySource, or: $value.isStickySource),
    canRename: data.get(#canRename, or: $value.canRename),
    canDelete: data.get(#canDelete, or: $value.canDelete),
    canClose: data.get(#canClose, or: $value.canClose),
    canApprove: data.get(#canApprove, or: $value.canApprove),
    canStick: data.get(#canStick, or: $value.canStick),
    canMove: data.get(#canMove, or: $value.canMove),
    canMerge: data.get(#canMerge, or: $value.canMerge),
    canBan: data.get(#canBan, or: $value.canBan),
    canReply: data.get(#canReply, or: $value.canReply),
    canReport: data.get(#canReport, or: $value.canReport),
    canUpload: data.get(#canUpload, or: $value.canUpload),
    isBanned: data.get(#isBanned, or: $value.isBanned),
    isApproved: data.get(#isApproved, or: $value.isApproved),
    isDeleted: data.get(#isDeleted, or: $value.isDeleted),
    isMoved: data.get(#isMoved, or: $value.isMoved),
    isMerged: data.get(#isMerged, or: $value.isMerged),
    realTopicId: data.get(#realTopicId, or: $value.realTopicId),
    canLike: data.get(#canLike, or: $value.canLike),
    isLiked: data.get(#isLiked, or: $value.isLiked),
    likeCount: data.get(#likeCount, or: $value.likeCount),
    canThank: data.get(#canThank, or: $value.canThank),
    hasPoll: data.get(#hasPoll, or: $value.hasPoll),
    poll: data.get(#poll, or: $value.poll),
  );

  @override
  FCThreadResultCopyWith<$R2, FCThreadResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCThreadResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCThreadByUnreadResultMapper
    extends ClassMapperBase<FCThreadByUnreadResult> {
  FCThreadByUnreadResultMapper._();

  static FCThreadByUnreadResultMapper? _instance;
  static FCThreadByUnreadResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCThreadByUnreadResultMapper._());
      FCTopicMapper.ensureInitialized();
      FCPostMapper.ensureInitialized();
      FCPollMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCThreadByUnreadResult';

  static bool _$result(FCThreadByUnreadResult v) => v.result;
  static const Field<FCThreadByUnreadResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCThreadByUnreadResult v) => v.resultText;
  static const Field<FCThreadByUnreadResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static int _$totalPostNum(FCThreadByUnreadResult v) => v.totalPostNum;
  static const Field<FCThreadByUnreadResult, int> _f$totalPostNum = Field(
    'totalPostNum',
    _$totalPostNum,
  );
  static bool _$canReply(FCThreadByUnreadResult v) => v.canReply;
  static const Field<FCThreadByUnreadResult, bool> _f$canReply = Field(
    'canReply',
    _$canReply,
    opt: true,
    def: false,
  );
  static bool _$canReport(FCThreadByUnreadResult v) => v.canReport;
  static const Field<FCThreadByUnreadResult, bool> _f$canReport = Field(
    'canReport',
    _$canReport,
    opt: true,
    def: false,
  );
  static bool _$canUpload(FCThreadByUnreadResult v) => v.canUpload;
  static const Field<FCThreadByUnreadResult, bool> _f$canUpload = Field(
    'canUpload',
    _$canUpload,
    opt: true,
    def: false,
  );
  static List<FCPost> _$posts(FCThreadByUnreadResult v) => v.posts;
  static const Field<FCThreadByUnreadResult, List<FCPost>> _f$posts = Field(
    'posts',
    _$posts,
    opt: true,
    def: const [],
  );
  static int _$position(FCThreadByUnreadResult v) => v.position;
  static const Field<FCThreadByUnreadResult, int> _f$position = Field(
    'position',
    _$position,
  );
  static String _$id(FCThreadByUnreadResult v) => v.id;
  static const Field<FCThreadByUnreadResult, String> _f$id = Field('id', _$id);
  static String _$title(FCThreadByUnreadResult v) => v.title;
  static const Field<FCThreadByUnreadResult, String> _f$title = Field(
    'title',
    _$title,
  );
  static String _$forumId(FCThreadByUnreadResult v) => v.forumId;
  static const Field<FCThreadByUnreadResult, String> _f$forumId = Field(
    'forumId',
    _$forumId,
  );
  static String _$forumName(FCThreadByUnreadResult v) => v.forumName;
  static const Field<FCThreadByUnreadResult, String> _f$forumName = Field(
    'forumName',
    _$forumName,
  );
  static String _$authorId(FCThreadByUnreadResult v) => v.authorId;
  static const Field<FCThreadByUnreadResult, String> _f$authorId = Field(
    'authorId',
    _$authorId,
  );
  static String _$authorName(FCThreadByUnreadResult v) => v.authorName;
  static const Field<FCThreadByUnreadResult, String> _f$authorName = Field(
    'authorName',
    _$authorName,
  );
  static String? _$authorUserType(FCThreadByUnreadResult v) => v.authorUserType;
  static const Field<FCThreadByUnreadResult, String> _f$authorUserType = Field(
    'authorUserType',
    _$authorUserType,
  );
  static DateTime _$timestamp(FCThreadByUnreadResult v) => v.timestamp;
  static const Field<FCThreadByUnreadResult, DateTime> _f$timestamp = Field(
    'timestamp',
    _$timestamp,
    hook: MillisOrIsoDateHook(),
  );
  static String? _$prefix(FCThreadByUnreadResult v) => v.prefix;
  static const Field<FCThreadByUnreadResult, String> _f$prefix = Field(
    'prefix',
    _$prefix,
    opt: true,
  );
  static String? _$authorIconUrl(FCThreadByUnreadResult v) => v.authorIconUrl;
  static const Field<FCThreadByUnreadResult, String> _f$authorIconUrl = Field(
    'authorIconUrl',
    _$authorIconUrl,
    opt: true,
  );
  static int _$replyCount(FCThreadByUnreadResult v) => v.replyCount;
  static const Field<FCThreadByUnreadResult, int> _f$replyCount = Field(
    'replyCount',
    _$replyCount,
    opt: true,
    def: 0,
  );
  static int _$viewCount(FCThreadByUnreadResult v) => v.viewCount;
  static const Field<FCThreadByUnreadResult, int> _f$viewCount = Field(
    'viewCount',
    _$viewCount,
    opt: true,
    def: 0,
  );
  static bool _$hasNewPosts(FCThreadByUnreadResult v) => v.hasNewPosts;
  static const Field<FCThreadByUnreadResult, bool> _f$hasNewPosts = Field(
    'hasNewPosts',
    _$hasNewPosts,
    opt: true,
    def: false,
  );
  static bool _$isClosed(FCThreadByUnreadResult v) => v.isClosed;
  static const Field<FCThreadByUnreadResult, bool> _f$isClosed = Field(
    'isClosed',
    _$isClosed,
    opt: true,
    def: false,
  );
  static bool _$isSubscribed(FCThreadByUnreadResult v) => v.isSubscribed;
  static const Field<FCThreadByUnreadResult, bool> _f$isSubscribed = Field(
    'isSubscribed',
    _$isSubscribed,
    opt: true,
    def: false,
  );
  static bool _$canSubscribe(FCThreadByUnreadResult v) => v.canSubscribe;
  static const Field<FCThreadByUnreadResult, bool> _f$canSubscribe = Field(
    'canSubscribe',
    _$canSubscribe,
    opt: true,
    def: true,
  );
  static String? _$url(FCThreadByUnreadResult v) => v.url;
  static const Field<FCThreadByUnreadResult, String> _f$url = Field(
    'url',
    _$url,
    opt: true,
  );
  static String? _$shortContent(FCThreadByUnreadResult v) => v.shortContent;
  static const Field<FCThreadByUnreadResult, String> _f$shortContent = Field(
    'shortContent',
    _$shortContent,
    opt: true,
  );
  static List<String> _$participatedUserIds(FCThreadByUnreadResult v) =>
      v.participatedUserIds;
  static const Field<FCThreadByUnreadResult, List<String>>
  _f$participatedUserIds = Field(
    'participatedUserIds',
    _$participatedUserIds,
    opt: true,
    def: const [],
  );
  static bool _$isPinned(FCThreadByUnreadResult v) => v.isPinned;
  static const Field<FCThreadByUnreadResult, bool> _f$isPinned = Field(
    'isPinned',
    _$isPinned,
    opt: true,
    def: false,
    hook: FlexibleBoolHook(),
  );
  static bool _$isAnnouncement(FCThreadByUnreadResult v) => v.isAnnouncement;
  static const Field<FCThreadByUnreadResult, bool> _f$isAnnouncement = Field(
    'isAnnouncement',
    _$isAnnouncement,
    opt: true,
    def: false,
  );
  static bool _$isStickySource(FCThreadByUnreadResult v) => v.isStickySource;
  static const Field<FCThreadByUnreadResult, bool> _f$isStickySource = Field(
    'isStickySource',
    _$isStickySource,
    opt: true,
    def: false,
  );
  static bool _$canRename(FCThreadByUnreadResult v) => v.canRename;
  static const Field<FCThreadByUnreadResult, bool> _f$canRename = Field(
    'canRename',
    _$canRename,
    opt: true,
    def: false,
  );
  static bool _$canDelete(FCThreadByUnreadResult v) => v.canDelete;
  static const Field<FCThreadByUnreadResult, bool> _f$canDelete = Field(
    'canDelete',
    _$canDelete,
    opt: true,
    def: false,
  );
  static bool _$canClose(FCThreadByUnreadResult v) => v.canClose;
  static const Field<FCThreadByUnreadResult, bool> _f$canClose = Field(
    'canClose',
    _$canClose,
    opt: true,
    def: false,
  );
  static bool _$canApprove(FCThreadByUnreadResult v) => v.canApprove;
  static const Field<FCThreadByUnreadResult, bool> _f$canApprove = Field(
    'canApprove',
    _$canApprove,
    opt: true,
    def: false,
  );
  static bool _$canStick(FCThreadByUnreadResult v) => v.canStick;
  static const Field<FCThreadByUnreadResult, bool> _f$canStick = Field(
    'canStick',
    _$canStick,
    opt: true,
    def: false,
  );
  static bool _$canMove(FCThreadByUnreadResult v) => v.canMove;
  static const Field<FCThreadByUnreadResult, bool> _f$canMove = Field(
    'canMove',
    _$canMove,
    opt: true,
    def: false,
  );
  static bool _$canMerge(FCThreadByUnreadResult v) => v.canMerge;
  static const Field<FCThreadByUnreadResult, bool> _f$canMerge = Field(
    'canMerge',
    _$canMerge,
    opt: true,
    def: false,
  );
  static bool _$canBan(FCThreadByUnreadResult v) => v.canBan;
  static const Field<FCThreadByUnreadResult, bool> _f$canBan = Field(
    'canBan',
    _$canBan,
    opt: true,
    def: false,
  );
  static bool _$isBanned(FCThreadByUnreadResult v) => v.isBanned;
  static const Field<FCThreadByUnreadResult, bool> _f$isBanned = Field(
    'isBanned',
    _$isBanned,
    opt: true,
    def: false,
  );
  static bool _$isApproved(FCThreadByUnreadResult v) => v.isApproved;
  static const Field<FCThreadByUnreadResult, bool> _f$isApproved = Field(
    'isApproved',
    _$isApproved,
    opt: true,
    def: true,
  );
  static bool _$isDeleted(FCThreadByUnreadResult v) => v.isDeleted;
  static const Field<FCThreadByUnreadResult, bool> _f$isDeleted = Field(
    'isDeleted',
    _$isDeleted,
    opt: true,
    def: false,
  );
  static bool _$isMoved(FCThreadByUnreadResult v) => v.isMoved;
  static const Field<FCThreadByUnreadResult, bool> _f$isMoved = Field(
    'isMoved',
    _$isMoved,
    opt: true,
    def: false,
  );
  static bool _$isMerged(FCThreadByUnreadResult v) => v.isMerged;
  static const Field<FCThreadByUnreadResult, bool> _f$isMerged = Field(
    'isMerged',
    _$isMerged,
    opt: true,
    def: false,
  );
  static String? _$realTopicId(FCThreadByUnreadResult v) => v.realTopicId;
  static const Field<FCThreadByUnreadResult, String> _f$realTopicId = Field(
    'realTopicId',
    _$realTopicId,
    opt: true,
  );
  static bool _$canLike(FCThreadByUnreadResult v) => v.canLike;
  static const Field<FCThreadByUnreadResult, bool> _f$canLike = Field(
    'canLike',
    _$canLike,
    opt: true,
    def: false,
  );
  static bool _$isLiked(FCThreadByUnreadResult v) => v.isLiked;
  static const Field<FCThreadByUnreadResult, bool> _f$isLiked = Field(
    'isLiked',
    _$isLiked,
    opt: true,
    def: false,
  );
  static int _$likeCount(FCThreadByUnreadResult v) => v.likeCount;
  static const Field<FCThreadByUnreadResult, int> _f$likeCount = Field(
    'likeCount',
    _$likeCount,
    opt: true,
    def: 0,
  );
  static bool _$canThank(FCThreadByUnreadResult v) => v.canThank;
  static const Field<FCThreadByUnreadResult, bool> _f$canThank = Field(
    'canThank',
    _$canThank,
    opt: true,
    def: false,
  );
  static bool _$hasPoll(FCThreadByUnreadResult v) => v.hasPoll;
  static const Field<FCThreadByUnreadResult, bool> _f$hasPoll = Field(
    'hasPoll',
    _$hasPoll,
    opt: true,
    def: false,
  );
  static FCPoll? _$poll(FCThreadByUnreadResult v) => v.poll;
  static const Field<FCThreadByUnreadResult, FCPoll> _f$poll = Field(
    'poll',
    _$poll,
    opt: true,
  );

  @override
  final MappableFields<FCThreadByUnreadResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #totalPostNum: _f$totalPostNum,
    #canReply: _f$canReply,
    #canReport: _f$canReport,
    #canUpload: _f$canUpload,
    #posts: _f$posts,
    #position: _f$position,
    #id: _f$id,
    #title: _f$title,
    #forumId: _f$forumId,
    #forumName: _f$forumName,
    #authorId: _f$authorId,
    #authorName: _f$authorName,
    #authorUserType: _f$authorUserType,
    #timestamp: _f$timestamp,
    #prefix: _f$prefix,
    #authorIconUrl: _f$authorIconUrl,
    #replyCount: _f$replyCount,
    #viewCount: _f$viewCount,
    #hasNewPosts: _f$hasNewPosts,
    #isClosed: _f$isClosed,
    #isSubscribed: _f$isSubscribed,
    #canSubscribe: _f$canSubscribe,
    #url: _f$url,
    #shortContent: _f$shortContent,
    #participatedUserIds: _f$participatedUserIds,
    #isPinned: _f$isPinned,
    #isAnnouncement: _f$isAnnouncement,
    #isStickySource: _f$isStickySource,
    #canRename: _f$canRename,
    #canDelete: _f$canDelete,
    #canClose: _f$canClose,
    #canApprove: _f$canApprove,
    #canStick: _f$canStick,
    #canMove: _f$canMove,
    #canMerge: _f$canMerge,
    #canBan: _f$canBan,
    #isBanned: _f$isBanned,
    #isApproved: _f$isApproved,
    #isDeleted: _f$isDeleted,
    #isMoved: _f$isMoved,
    #isMerged: _f$isMerged,
    #realTopicId: _f$realTopicId,
    #canLike: _f$canLike,
    #isLiked: _f$isLiked,
    #likeCount: _f$likeCount,
    #canThank: _f$canThank,
    #hasPoll: _f$hasPoll,
    #poll: _f$poll,
  };

  static FCThreadByUnreadResult _instantiate(DecodingData data) {
    return FCThreadByUnreadResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      totalPostNum: data.dec(_f$totalPostNum),
      canReply: data.dec(_f$canReply),
      canReport: data.dec(_f$canReport),
      canUpload: data.dec(_f$canUpload),
      posts: data.dec(_f$posts),
      position: data.dec(_f$position),
      id: data.dec(_f$id),
      title: data.dec(_f$title),
      forumId: data.dec(_f$forumId),
      forumName: data.dec(_f$forumName),
      authorId: data.dec(_f$authorId),
      authorName: data.dec(_f$authorName),
      authorUserType: data.dec(_f$authorUserType),
      timestamp: data.dec(_f$timestamp),
      prefix: data.dec(_f$prefix),
      authorIconUrl: data.dec(_f$authorIconUrl),
      replyCount: data.dec(_f$replyCount),
      viewCount: data.dec(_f$viewCount),
      hasNewPosts: data.dec(_f$hasNewPosts),
      isClosed: data.dec(_f$isClosed),
      isSubscribed: data.dec(_f$isSubscribed),
      canSubscribe: data.dec(_f$canSubscribe),
      url: data.dec(_f$url),
      shortContent: data.dec(_f$shortContent),
      participatedUserIds: data.dec(_f$participatedUserIds),
      isPinned: data.dec(_f$isPinned),
      isAnnouncement: data.dec(_f$isAnnouncement),
      isStickySource: data.dec(_f$isStickySource),
      canRename: data.dec(_f$canRename),
      canDelete: data.dec(_f$canDelete),
      canClose: data.dec(_f$canClose),
      canApprove: data.dec(_f$canApprove),
      canStick: data.dec(_f$canStick),
      canMove: data.dec(_f$canMove),
      canMerge: data.dec(_f$canMerge),
      canBan: data.dec(_f$canBan),
      isBanned: data.dec(_f$isBanned),
      isApproved: data.dec(_f$isApproved),
      isDeleted: data.dec(_f$isDeleted),
      isMoved: data.dec(_f$isMoved),
      isMerged: data.dec(_f$isMerged),
      realTopicId: data.dec(_f$realTopicId),
      canLike: data.dec(_f$canLike),
      isLiked: data.dec(_f$isLiked),
      likeCount: data.dec(_f$likeCount),
      canThank: data.dec(_f$canThank),
      hasPoll: data.dec(_f$hasPoll),
      poll: data.dec(_f$poll),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCThreadByUnreadResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCThreadByUnreadResult>(map);
  }

  static FCThreadByUnreadResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCThreadByUnreadResult>(json);
  }
}

mixin FCThreadByUnreadResultMappable {
  String toJson() {
    return FCThreadByUnreadResultMapper.ensureInitialized()
        .encodeJson<FCThreadByUnreadResult>(this as FCThreadByUnreadResult);
  }

  Map<String, dynamic> toMap() {
    return FCThreadByUnreadResultMapper.ensureInitialized()
        .encodeMap<FCThreadByUnreadResult>(this as FCThreadByUnreadResult);
  }

  FCThreadByUnreadResultCopyWith<
    FCThreadByUnreadResult,
    FCThreadByUnreadResult,
    FCThreadByUnreadResult
  >
  get copyWith =>
      _FCThreadByUnreadResultCopyWithImpl<
        FCThreadByUnreadResult,
        FCThreadByUnreadResult
      >(this as FCThreadByUnreadResult, $identity, $identity);
  @override
  String toString() {
    return FCThreadByUnreadResultMapper.ensureInitialized().stringifyValue(
      this as FCThreadByUnreadResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCThreadByUnreadResultMapper.ensureInitialized().equalsValue(
      this as FCThreadByUnreadResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCThreadByUnreadResultMapper.ensureInitialized().hashValue(
      this as FCThreadByUnreadResult,
    );
  }
}

extension FCThreadByUnreadResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCThreadByUnreadResult, $Out> {
  FCThreadByUnreadResultCopyWith<$R, FCThreadByUnreadResult, $Out>
  get $asFCThreadByUnreadResult => $base.as(
    (v, t, t2) => _FCThreadByUnreadResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCThreadByUnreadResultCopyWith<
  $R,
  $In extends FCThreadByUnreadResult,
  $Out
>
    implements FCTopicCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, FCPost, FCPostCopyWith<$R, FCPost, FCPost>> get posts;
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get participatedUserIds;
  @override
  FCPollCopyWith<$R, FCPoll, FCPoll>? get poll;
  @override
  $R call({
    bool? result,
    String? resultText,
    int? totalPostNum,
    bool? canReply,
    bool? canReport,
    bool? canUpload,
    List<FCPost>? posts,
    int? position,
    String? id,
    String? title,
    String? forumId,
    String? forumName,
    String? authorId,
    String? authorName,
    covariant String? authorUserType,
    DateTime? timestamp,
    String? prefix,
    String? authorIconUrl,
    int? replyCount,
    int? viewCount,
    bool? hasNewPosts,
    bool? isClosed,
    bool? isSubscribed,
    bool? canSubscribe,
    String? url,
    String? shortContent,
    List<String>? participatedUserIds,
    bool? isPinned,
    bool? isAnnouncement,
    bool? isStickySource,
    bool? canRename,
    bool? canDelete,
    bool? canClose,
    bool? canApprove,
    bool? canStick,
    bool? canMove,
    bool? canMerge,
    bool? canBan,
    bool? isBanned,
    bool? isApproved,
    bool? isDeleted,
    bool? isMoved,
    bool? isMerged,
    String? realTopicId,
    bool? canLike,
    bool? isLiked,
    int? likeCount,
    bool? canThank,
    bool? hasPoll,
    FCPoll? poll,
  });
  FCThreadByUnreadResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCThreadByUnreadResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCThreadByUnreadResult, $Out>
    implements
        FCThreadByUnreadResultCopyWith<$R, FCThreadByUnreadResult, $Out> {
  _FCThreadByUnreadResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCThreadByUnreadResult> $mapper =
      FCThreadByUnreadResultMapper.ensureInitialized();
  @override
  ListCopyWith<$R, FCPost, FCPostCopyWith<$R, FCPost, FCPost>> get posts =>
      ListCopyWith(
        $value.posts,
        (v, t) => v.copyWith.$chain(t),
        (v) => call(posts: v),
      );
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get participatedUserIds => ListCopyWith(
    $value.participatedUserIds,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(participatedUserIds: v),
  );
  @override
  FCPollCopyWith<$R, FCPoll, FCPoll>? get poll =>
      $value.poll?.copyWith.$chain((v) => call(poll: v));
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
    int? totalPostNum,
    bool? canReply,
    bool? canReport,
    bool? canUpload,
    List<FCPost>? posts,
    int? position,
    String? id,
    String? title,
    String? forumId,
    String? forumName,
    String? authorId,
    String? authorName,
    String? authorUserType,
    DateTime? timestamp,
    Object? prefix = $none,
    Object? authorIconUrl = $none,
    int? replyCount,
    int? viewCount,
    bool? hasNewPosts,
    bool? isClosed,
    bool? isSubscribed,
    bool? canSubscribe,
    Object? url = $none,
    Object? shortContent = $none,
    List<String>? participatedUserIds,
    bool? isPinned,
    bool? isAnnouncement,
    bool? isStickySource,
    bool? canRename,
    bool? canDelete,
    bool? canClose,
    bool? canApprove,
    bool? canStick,
    bool? canMove,
    bool? canMerge,
    bool? canBan,
    bool? isBanned,
    bool? isApproved,
    bool? isDeleted,
    bool? isMoved,
    bool? isMerged,
    Object? realTopicId = $none,
    bool? canLike,
    bool? isLiked,
    int? likeCount,
    bool? canThank,
    bool? hasPoll,
    Object? poll = $none,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (totalPostNum != null) #totalPostNum: totalPostNum,
      if (canReply != null) #canReply: canReply,
      if (canReport != null) #canReport: canReport,
      if (canUpload != null) #canUpload: canUpload,
      if (posts != null) #posts: posts,
      if (position != null) #position: position,
      if (id != null) #id: id,
      if (title != null) #title: title,
      if (forumId != null) #forumId: forumId,
      if (forumName != null) #forumName: forumName,
      if (authorId != null) #authorId: authorId,
      if (authorName != null) #authorName: authorName,
      if (authorUserType != null) #authorUserType: authorUserType,
      if (timestamp != null) #timestamp: timestamp,
      if (prefix != $none) #prefix: prefix,
      if (authorIconUrl != $none) #authorIconUrl: authorIconUrl,
      if (replyCount != null) #replyCount: replyCount,
      if (viewCount != null) #viewCount: viewCount,
      if (hasNewPosts != null) #hasNewPosts: hasNewPosts,
      if (isClosed != null) #isClosed: isClosed,
      if (isSubscribed != null) #isSubscribed: isSubscribed,
      if (canSubscribe != null) #canSubscribe: canSubscribe,
      if (url != $none) #url: url,
      if (shortContent != $none) #shortContent: shortContent,
      if (participatedUserIds != null)
        #participatedUserIds: participatedUserIds,
      if (isPinned != null) #isPinned: isPinned,
      if (isAnnouncement != null) #isAnnouncement: isAnnouncement,
      if (isStickySource != null) #isStickySource: isStickySource,
      if (canRename != null) #canRename: canRename,
      if (canDelete != null) #canDelete: canDelete,
      if (canClose != null) #canClose: canClose,
      if (canApprove != null) #canApprove: canApprove,
      if (canStick != null) #canStick: canStick,
      if (canMove != null) #canMove: canMove,
      if (canMerge != null) #canMerge: canMerge,
      if (canBan != null) #canBan: canBan,
      if (isBanned != null) #isBanned: isBanned,
      if (isApproved != null) #isApproved: isApproved,
      if (isDeleted != null) #isDeleted: isDeleted,
      if (isMoved != null) #isMoved: isMoved,
      if (isMerged != null) #isMerged: isMerged,
      if (realTopicId != $none) #realTopicId: realTopicId,
      if (canLike != null) #canLike: canLike,
      if (isLiked != null) #isLiked: isLiked,
      if (likeCount != null) #likeCount: likeCount,
      if (canThank != null) #canThank: canThank,
      if (hasPoll != null) #hasPoll: hasPoll,
      if (poll != $none) #poll: poll,
    }),
  );
  @override
  FCThreadByUnreadResult $make(CopyWithData data) => FCThreadByUnreadResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    totalPostNum: data.get(#totalPostNum, or: $value.totalPostNum),
    canReply: data.get(#canReply, or: $value.canReply),
    canReport: data.get(#canReport, or: $value.canReport),
    canUpload: data.get(#canUpload, or: $value.canUpload),
    posts: data.get(#posts, or: $value.posts),
    position: data.get(#position, or: $value.position),
    id: data.get(#id, or: $value.id),
    title: data.get(#title, or: $value.title),
    forumId: data.get(#forumId, or: $value.forumId),
    forumName: data.get(#forumName, or: $value.forumName),
    authorId: data.get(#authorId, or: $value.authorId),
    authorName: data.get(#authorName, or: $value.authorName),
    authorUserType: data.get(#authorUserType, or: $value.authorUserType),
    timestamp: data.get(#timestamp, or: $value.timestamp),
    prefix: data.get(#prefix, or: $value.prefix),
    authorIconUrl: data.get(#authorIconUrl, or: $value.authorIconUrl),
    replyCount: data.get(#replyCount, or: $value.replyCount),
    viewCount: data.get(#viewCount, or: $value.viewCount),
    hasNewPosts: data.get(#hasNewPosts, or: $value.hasNewPosts),
    isClosed: data.get(#isClosed, or: $value.isClosed),
    isSubscribed: data.get(#isSubscribed, or: $value.isSubscribed),
    canSubscribe: data.get(#canSubscribe, or: $value.canSubscribe),
    url: data.get(#url, or: $value.url),
    shortContent: data.get(#shortContent, or: $value.shortContent),
    participatedUserIds: data.get(
      #participatedUserIds,
      or: $value.participatedUserIds,
    ),
    isPinned: data.get(#isPinned, or: $value.isPinned),
    isAnnouncement: data.get(#isAnnouncement, or: $value.isAnnouncement),
    isStickySource: data.get(#isStickySource, or: $value.isStickySource),
    canRename: data.get(#canRename, or: $value.canRename),
    canDelete: data.get(#canDelete, or: $value.canDelete),
    canClose: data.get(#canClose, or: $value.canClose),
    canApprove: data.get(#canApprove, or: $value.canApprove),
    canStick: data.get(#canStick, or: $value.canStick),
    canMove: data.get(#canMove, or: $value.canMove),
    canMerge: data.get(#canMerge, or: $value.canMerge),
    canBan: data.get(#canBan, or: $value.canBan),
    isBanned: data.get(#isBanned, or: $value.isBanned),
    isApproved: data.get(#isApproved, or: $value.isApproved),
    isDeleted: data.get(#isDeleted, or: $value.isDeleted),
    isMoved: data.get(#isMoved, or: $value.isMoved),
    isMerged: data.get(#isMerged, or: $value.isMerged),
    realTopicId: data.get(#realTopicId, or: $value.realTopicId),
    canLike: data.get(#canLike, or: $value.canLike),
    isLiked: data.get(#isLiked, or: $value.isLiked),
    likeCount: data.get(#likeCount, or: $value.likeCount),
    canThank: data.get(#canThank, or: $value.canThank),
    hasPoll: data.get(#hasPoll, or: $value.hasPoll),
    poll: data.get(#poll, or: $value.poll),
  );

  @override
  FCThreadByUnreadResultCopyWith<$R2, FCThreadByUnreadResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCThreadByUnreadResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCThreadByPostResultMapper extends ClassMapperBase<FCThreadByPostResult> {
  FCThreadByPostResultMapper._();

  static FCThreadByPostResultMapper? _instance;
  static FCThreadByPostResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCThreadByPostResultMapper._());
      FCTopicMapper.ensureInitialized();
      FCPostMapper.ensureInitialized();
      FCPollMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCThreadByPostResult';

  static bool _$result(FCThreadByPostResult v) => v.result;
  static const Field<FCThreadByPostResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCThreadByPostResult v) => v.resultText;
  static const Field<FCThreadByPostResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static int _$totalPostNum(FCThreadByPostResult v) => v.totalPostNum;
  static const Field<FCThreadByPostResult, int> _f$totalPostNum = Field(
    'totalPostNum',
    _$totalPostNum,
  );
  static bool _$canReply(FCThreadByPostResult v) => v.canReply;
  static const Field<FCThreadByPostResult, bool> _f$canReply = Field(
    'canReply',
    _$canReply,
    opt: true,
    def: false,
  );
  static bool _$canReport(FCThreadByPostResult v) => v.canReport;
  static const Field<FCThreadByPostResult, bool> _f$canReport = Field(
    'canReport',
    _$canReport,
    opt: true,
    def: false,
  );
  static bool _$canUpload(FCThreadByPostResult v) => v.canUpload;
  static const Field<FCThreadByPostResult, bool> _f$canUpload = Field(
    'canUpload',
    _$canUpload,
    opt: true,
    def: false,
  );
  static List<FCPost> _$posts(FCThreadByPostResult v) => v.posts;
  static const Field<FCThreadByPostResult, List<FCPost>> _f$posts = Field(
    'posts',
    _$posts,
    opt: true,
    def: const [],
  );
  static int _$position(FCThreadByPostResult v) => v.position;
  static const Field<FCThreadByPostResult, int> _f$position = Field(
    'position',
    _$position,
  );
  static String _$id(FCThreadByPostResult v) => v.id;
  static const Field<FCThreadByPostResult, String> _f$id = Field('id', _$id);
  static String _$title(FCThreadByPostResult v) => v.title;
  static const Field<FCThreadByPostResult, String> _f$title = Field(
    'title',
    _$title,
  );
  static String _$forumId(FCThreadByPostResult v) => v.forumId;
  static const Field<FCThreadByPostResult, String> _f$forumId = Field(
    'forumId',
    _$forumId,
  );
  static String _$forumName(FCThreadByPostResult v) => v.forumName;
  static const Field<FCThreadByPostResult, String> _f$forumName = Field(
    'forumName',
    _$forumName,
  );
  static String _$authorId(FCThreadByPostResult v) => v.authorId;
  static const Field<FCThreadByPostResult, String> _f$authorId = Field(
    'authorId',
    _$authorId,
  );
  static String _$authorName(FCThreadByPostResult v) => v.authorName;
  static const Field<FCThreadByPostResult, String> _f$authorName = Field(
    'authorName',
    _$authorName,
  );
  static String? _$authorUserType(FCThreadByPostResult v) => v.authorUserType;
  static const Field<FCThreadByPostResult, String> _f$authorUserType = Field(
    'authorUserType',
    _$authorUserType,
  );
  static DateTime _$timestamp(FCThreadByPostResult v) => v.timestamp;
  static const Field<FCThreadByPostResult, DateTime> _f$timestamp = Field(
    'timestamp',
    _$timestamp,
    hook: MillisOrIsoDateHook(),
  );
  static String? _$prefix(FCThreadByPostResult v) => v.prefix;
  static const Field<FCThreadByPostResult, String> _f$prefix = Field(
    'prefix',
    _$prefix,
    opt: true,
  );
  static String? _$authorIconUrl(FCThreadByPostResult v) => v.authorIconUrl;
  static const Field<FCThreadByPostResult, String> _f$authorIconUrl = Field(
    'authorIconUrl',
    _$authorIconUrl,
    opt: true,
  );
  static int _$replyCount(FCThreadByPostResult v) => v.replyCount;
  static const Field<FCThreadByPostResult, int> _f$replyCount = Field(
    'replyCount',
    _$replyCount,
    opt: true,
    def: 0,
  );
  static int _$viewCount(FCThreadByPostResult v) => v.viewCount;
  static const Field<FCThreadByPostResult, int> _f$viewCount = Field(
    'viewCount',
    _$viewCount,
    opt: true,
    def: 0,
  );
  static bool _$hasNewPosts(FCThreadByPostResult v) => v.hasNewPosts;
  static const Field<FCThreadByPostResult, bool> _f$hasNewPosts = Field(
    'hasNewPosts',
    _$hasNewPosts,
    opt: true,
    def: false,
  );
  static bool _$isClosed(FCThreadByPostResult v) => v.isClosed;
  static const Field<FCThreadByPostResult, bool> _f$isClosed = Field(
    'isClosed',
    _$isClosed,
    opt: true,
    def: false,
  );
  static bool _$isSubscribed(FCThreadByPostResult v) => v.isSubscribed;
  static const Field<FCThreadByPostResult, bool> _f$isSubscribed = Field(
    'isSubscribed',
    _$isSubscribed,
    opt: true,
    def: false,
  );
  static bool _$canSubscribe(FCThreadByPostResult v) => v.canSubscribe;
  static const Field<FCThreadByPostResult, bool> _f$canSubscribe = Field(
    'canSubscribe',
    _$canSubscribe,
    opt: true,
    def: true,
  );
  static String? _$url(FCThreadByPostResult v) => v.url;
  static const Field<FCThreadByPostResult, String> _f$url = Field(
    'url',
    _$url,
    opt: true,
  );
  static String? _$shortContent(FCThreadByPostResult v) => v.shortContent;
  static const Field<FCThreadByPostResult, String> _f$shortContent = Field(
    'shortContent',
    _$shortContent,
    opt: true,
  );
  static List<String> _$participatedUserIds(FCThreadByPostResult v) =>
      v.participatedUserIds;
  static const Field<FCThreadByPostResult, List<String>>
  _f$participatedUserIds = Field(
    'participatedUserIds',
    _$participatedUserIds,
    opt: true,
    def: const [],
  );
  static bool _$isPinned(FCThreadByPostResult v) => v.isPinned;
  static const Field<FCThreadByPostResult, bool> _f$isPinned = Field(
    'isPinned',
    _$isPinned,
    opt: true,
    def: false,
    hook: FlexibleBoolHook(),
  );
  static bool _$isAnnouncement(FCThreadByPostResult v) => v.isAnnouncement;
  static const Field<FCThreadByPostResult, bool> _f$isAnnouncement = Field(
    'isAnnouncement',
    _$isAnnouncement,
    opt: true,
    def: false,
  );
  static bool _$isStickySource(FCThreadByPostResult v) => v.isStickySource;
  static const Field<FCThreadByPostResult, bool> _f$isStickySource = Field(
    'isStickySource',
    _$isStickySource,
    opt: true,
    def: false,
  );
  static bool _$canRename(FCThreadByPostResult v) => v.canRename;
  static const Field<FCThreadByPostResult, bool> _f$canRename = Field(
    'canRename',
    _$canRename,
    opt: true,
    def: false,
  );
  static bool _$canDelete(FCThreadByPostResult v) => v.canDelete;
  static const Field<FCThreadByPostResult, bool> _f$canDelete = Field(
    'canDelete',
    _$canDelete,
    opt: true,
    def: false,
  );
  static bool _$canClose(FCThreadByPostResult v) => v.canClose;
  static const Field<FCThreadByPostResult, bool> _f$canClose = Field(
    'canClose',
    _$canClose,
    opt: true,
    def: false,
  );
  static bool _$canApprove(FCThreadByPostResult v) => v.canApprove;
  static const Field<FCThreadByPostResult, bool> _f$canApprove = Field(
    'canApprove',
    _$canApprove,
    opt: true,
    def: false,
  );
  static bool _$canStick(FCThreadByPostResult v) => v.canStick;
  static const Field<FCThreadByPostResult, bool> _f$canStick = Field(
    'canStick',
    _$canStick,
    opt: true,
    def: false,
  );
  static bool _$canMove(FCThreadByPostResult v) => v.canMove;
  static const Field<FCThreadByPostResult, bool> _f$canMove = Field(
    'canMove',
    _$canMove,
    opt: true,
    def: false,
  );
  static bool _$canMerge(FCThreadByPostResult v) => v.canMerge;
  static const Field<FCThreadByPostResult, bool> _f$canMerge = Field(
    'canMerge',
    _$canMerge,
    opt: true,
    def: false,
  );
  static bool _$canBan(FCThreadByPostResult v) => v.canBan;
  static const Field<FCThreadByPostResult, bool> _f$canBan = Field(
    'canBan',
    _$canBan,
    opt: true,
    def: false,
  );
  static bool _$isBanned(FCThreadByPostResult v) => v.isBanned;
  static const Field<FCThreadByPostResult, bool> _f$isBanned = Field(
    'isBanned',
    _$isBanned,
    opt: true,
    def: false,
  );
  static bool _$isApproved(FCThreadByPostResult v) => v.isApproved;
  static const Field<FCThreadByPostResult, bool> _f$isApproved = Field(
    'isApproved',
    _$isApproved,
    opt: true,
    def: true,
  );
  static bool _$isDeleted(FCThreadByPostResult v) => v.isDeleted;
  static const Field<FCThreadByPostResult, bool> _f$isDeleted = Field(
    'isDeleted',
    _$isDeleted,
    opt: true,
    def: false,
  );
  static bool _$isMoved(FCThreadByPostResult v) => v.isMoved;
  static const Field<FCThreadByPostResult, bool> _f$isMoved = Field(
    'isMoved',
    _$isMoved,
    opt: true,
    def: false,
  );
  static bool _$isMerged(FCThreadByPostResult v) => v.isMerged;
  static const Field<FCThreadByPostResult, bool> _f$isMerged = Field(
    'isMerged',
    _$isMerged,
    opt: true,
    def: false,
  );
  static String? _$realTopicId(FCThreadByPostResult v) => v.realTopicId;
  static const Field<FCThreadByPostResult, String> _f$realTopicId = Field(
    'realTopicId',
    _$realTopicId,
    opt: true,
  );
  static bool _$canLike(FCThreadByPostResult v) => v.canLike;
  static const Field<FCThreadByPostResult, bool> _f$canLike = Field(
    'canLike',
    _$canLike,
    opt: true,
    def: false,
  );
  static bool _$isLiked(FCThreadByPostResult v) => v.isLiked;
  static const Field<FCThreadByPostResult, bool> _f$isLiked = Field(
    'isLiked',
    _$isLiked,
    opt: true,
    def: false,
  );
  static int _$likeCount(FCThreadByPostResult v) => v.likeCount;
  static const Field<FCThreadByPostResult, int> _f$likeCount = Field(
    'likeCount',
    _$likeCount,
    opt: true,
    def: 0,
  );
  static bool _$canThank(FCThreadByPostResult v) => v.canThank;
  static const Field<FCThreadByPostResult, bool> _f$canThank = Field(
    'canThank',
    _$canThank,
    opt: true,
    def: false,
  );
  static bool _$hasPoll(FCThreadByPostResult v) => v.hasPoll;
  static const Field<FCThreadByPostResult, bool> _f$hasPoll = Field(
    'hasPoll',
    _$hasPoll,
    opt: true,
    def: false,
  );
  static FCPoll? _$poll(FCThreadByPostResult v) => v.poll;
  static const Field<FCThreadByPostResult, FCPoll> _f$poll = Field(
    'poll',
    _$poll,
    opt: true,
  );

  @override
  final MappableFields<FCThreadByPostResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #totalPostNum: _f$totalPostNum,
    #canReply: _f$canReply,
    #canReport: _f$canReport,
    #canUpload: _f$canUpload,
    #posts: _f$posts,
    #position: _f$position,
    #id: _f$id,
    #title: _f$title,
    #forumId: _f$forumId,
    #forumName: _f$forumName,
    #authorId: _f$authorId,
    #authorName: _f$authorName,
    #authorUserType: _f$authorUserType,
    #timestamp: _f$timestamp,
    #prefix: _f$prefix,
    #authorIconUrl: _f$authorIconUrl,
    #replyCount: _f$replyCount,
    #viewCount: _f$viewCount,
    #hasNewPosts: _f$hasNewPosts,
    #isClosed: _f$isClosed,
    #isSubscribed: _f$isSubscribed,
    #canSubscribe: _f$canSubscribe,
    #url: _f$url,
    #shortContent: _f$shortContent,
    #participatedUserIds: _f$participatedUserIds,
    #isPinned: _f$isPinned,
    #isAnnouncement: _f$isAnnouncement,
    #isStickySource: _f$isStickySource,
    #canRename: _f$canRename,
    #canDelete: _f$canDelete,
    #canClose: _f$canClose,
    #canApprove: _f$canApprove,
    #canStick: _f$canStick,
    #canMove: _f$canMove,
    #canMerge: _f$canMerge,
    #canBan: _f$canBan,
    #isBanned: _f$isBanned,
    #isApproved: _f$isApproved,
    #isDeleted: _f$isDeleted,
    #isMoved: _f$isMoved,
    #isMerged: _f$isMerged,
    #realTopicId: _f$realTopicId,
    #canLike: _f$canLike,
    #isLiked: _f$isLiked,
    #likeCount: _f$likeCount,
    #canThank: _f$canThank,
    #hasPoll: _f$hasPoll,
    #poll: _f$poll,
  };

  static FCThreadByPostResult _instantiate(DecodingData data) {
    return FCThreadByPostResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      totalPostNum: data.dec(_f$totalPostNum),
      canReply: data.dec(_f$canReply),
      canReport: data.dec(_f$canReport),
      canUpload: data.dec(_f$canUpload),
      posts: data.dec(_f$posts),
      position: data.dec(_f$position),
      id: data.dec(_f$id),
      title: data.dec(_f$title),
      forumId: data.dec(_f$forumId),
      forumName: data.dec(_f$forumName),
      authorId: data.dec(_f$authorId),
      authorName: data.dec(_f$authorName),
      authorUserType: data.dec(_f$authorUserType),
      timestamp: data.dec(_f$timestamp),
      prefix: data.dec(_f$prefix),
      authorIconUrl: data.dec(_f$authorIconUrl),
      replyCount: data.dec(_f$replyCount),
      viewCount: data.dec(_f$viewCount),
      hasNewPosts: data.dec(_f$hasNewPosts),
      isClosed: data.dec(_f$isClosed),
      isSubscribed: data.dec(_f$isSubscribed),
      canSubscribe: data.dec(_f$canSubscribe),
      url: data.dec(_f$url),
      shortContent: data.dec(_f$shortContent),
      participatedUserIds: data.dec(_f$participatedUserIds),
      isPinned: data.dec(_f$isPinned),
      isAnnouncement: data.dec(_f$isAnnouncement),
      isStickySource: data.dec(_f$isStickySource),
      canRename: data.dec(_f$canRename),
      canDelete: data.dec(_f$canDelete),
      canClose: data.dec(_f$canClose),
      canApprove: data.dec(_f$canApprove),
      canStick: data.dec(_f$canStick),
      canMove: data.dec(_f$canMove),
      canMerge: data.dec(_f$canMerge),
      canBan: data.dec(_f$canBan),
      isBanned: data.dec(_f$isBanned),
      isApproved: data.dec(_f$isApproved),
      isDeleted: data.dec(_f$isDeleted),
      isMoved: data.dec(_f$isMoved),
      isMerged: data.dec(_f$isMerged),
      realTopicId: data.dec(_f$realTopicId),
      canLike: data.dec(_f$canLike),
      isLiked: data.dec(_f$isLiked),
      likeCount: data.dec(_f$likeCount),
      canThank: data.dec(_f$canThank),
      hasPoll: data.dec(_f$hasPoll),
      poll: data.dec(_f$poll),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCThreadByPostResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCThreadByPostResult>(map);
  }

  static FCThreadByPostResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCThreadByPostResult>(json);
  }
}

mixin FCThreadByPostResultMappable {
  String toJson() {
    return FCThreadByPostResultMapper.ensureInitialized()
        .encodeJson<FCThreadByPostResult>(this as FCThreadByPostResult);
  }

  Map<String, dynamic> toMap() {
    return FCThreadByPostResultMapper.ensureInitialized()
        .encodeMap<FCThreadByPostResult>(this as FCThreadByPostResult);
  }

  FCThreadByPostResultCopyWith<
    FCThreadByPostResult,
    FCThreadByPostResult,
    FCThreadByPostResult
  >
  get copyWith =>
      _FCThreadByPostResultCopyWithImpl<
        FCThreadByPostResult,
        FCThreadByPostResult
      >(this as FCThreadByPostResult, $identity, $identity);
  @override
  String toString() {
    return FCThreadByPostResultMapper.ensureInitialized().stringifyValue(
      this as FCThreadByPostResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCThreadByPostResultMapper.ensureInitialized().equalsValue(
      this as FCThreadByPostResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCThreadByPostResultMapper.ensureInitialized().hashValue(
      this as FCThreadByPostResult,
    );
  }
}

extension FCThreadByPostResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCThreadByPostResult, $Out> {
  FCThreadByPostResultCopyWith<$R, FCThreadByPostResult, $Out>
  get $asFCThreadByPostResult => $base.as(
    (v, t, t2) => _FCThreadByPostResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCThreadByPostResultCopyWith<
  $R,
  $In extends FCThreadByPostResult,
  $Out
>
    implements FCTopicCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, FCPost, FCPostCopyWith<$R, FCPost, FCPost>> get posts;
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get participatedUserIds;
  @override
  FCPollCopyWith<$R, FCPoll, FCPoll>? get poll;
  @override
  $R call({
    bool? result,
    String? resultText,
    int? totalPostNum,
    bool? canReply,
    bool? canReport,
    bool? canUpload,
    List<FCPost>? posts,
    int? position,
    String? id,
    String? title,
    String? forumId,
    String? forumName,
    String? authorId,
    String? authorName,
    covariant String? authorUserType,
    DateTime? timestamp,
    String? prefix,
    String? authorIconUrl,
    int? replyCount,
    int? viewCount,
    bool? hasNewPosts,
    bool? isClosed,
    bool? isSubscribed,
    bool? canSubscribe,
    String? url,
    String? shortContent,
    List<String>? participatedUserIds,
    bool? isPinned,
    bool? isAnnouncement,
    bool? isStickySource,
    bool? canRename,
    bool? canDelete,
    bool? canClose,
    bool? canApprove,
    bool? canStick,
    bool? canMove,
    bool? canMerge,
    bool? canBan,
    bool? isBanned,
    bool? isApproved,
    bool? isDeleted,
    bool? isMoved,
    bool? isMerged,
    String? realTopicId,
    bool? canLike,
    bool? isLiked,
    int? likeCount,
    bool? canThank,
    bool? hasPoll,
    FCPoll? poll,
  });
  FCThreadByPostResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCThreadByPostResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCThreadByPostResult, $Out>
    implements FCThreadByPostResultCopyWith<$R, FCThreadByPostResult, $Out> {
  _FCThreadByPostResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCThreadByPostResult> $mapper =
      FCThreadByPostResultMapper.ensureInitialized();
  @override
  ListCopyWith<$R, FCPost, FCPostCopyWith<$R, FCPost, FCPost>> get posts =>
      ListCopyWith(
        $value.posts,
        (v, t) => v.copyWith.$chain(t),
        (v) => call(posts: v),
      );
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get participatedUserIds => ListCopyWith(
    $value.participatedUserIds,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(participatedUserIds: v),
  );
  @override
  FCPollCopyWith<$R, FCPoll, FCPoll>? get poll =>
      $value.poll?.copyWith.$chain((v) => call(poll: v));
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
    int? totalPostNum,
    bool? canReply,
    bool? canReport,
    bool? canUpload,
    List<FCPost>? posts,
    int? position,
    String? id,
    String? title,
    String? forumId,
    String? forumName,
    String? authorId,
    String? authorName,
    String? authorUserType,
    DateTime? timestamp,
    Object? prefix = $none,
    Object? authorIconUrl = $none,
    int? replyCount,
    int? viewCount,
    bool? hasNewPosts,
    bool? isClosed,
    bool? isSubscribed,
    bool? canSubscribe,
    Object? url = $none,
    Object? shortContent = $none,
    List<String>? participatedUserIds,
    bool? isPinned,
    bool? isAnnouncement,
    bool? isStickySource,
    bool? canRename,
    bool? canDelete,
    bool? canClose,
    bool? canApprove,
    bool? canStick,
    bool? canMove,
    bool? canMerge,
    bool? canBan,
    bool? isBanned,
    bool? isApproved,
    bool? isDeleted,
    bool? isMoved,
    bool? isMerged,
    Object? realTopicId = $none,
    bool? canLike,
    bool? isLiked,
    int? likeCount,
    bool? canThank,
    bool? hasPoll,
    Object? poll = $none,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (totalPostNum != null) #totalPostNum: totalPostNum,
      if (canReply != null) #canReply: canReply,
      if (canReport != null) #canReport: canReport,
      if (canUpload != null) #canUpload: canUpload,
      if (posts != null) #posts: posts,
      if (position != null) #position: position,
      if (id != null) #id: id,
      if (title != null) #title: title,
      if (forumId != null) #forumId: forumId,
      if (forumName != null) #forumName: forumName,
      if (authorId != null) #authorId: authorId,
      if (authorName != null) #authorName: authorName,
      if (authorUserType != null) #authorUserType: authorUserType,
      if (timestamp != null) #timestamp: timestamp,
      if (prefix != $none) #prefix: prefix,
      if (authorIconUrl != $none) #authorIconUrl: authorIconUrl,
      if (replyCount != null) #replyCount: replyCount,
      if (viewCount != null) #viewCount: viewCount,
      if (hasNewPosts != null) #hasNewPosts: hasNewPosts,
      if (isClosed != null) #isClosed: isClosed,
      if (isSubscribed != null) #isSubscribed: isSubscribed,
      if (canSubscribe != null) #canSubscribe: canSubscribe,
      if (url != $none) #url: url,
      if (shortContent != $none) #shortContent: shortContent,
      if (participatedUserIds != null)
        #participatedUserIds: participatedUserIds,
      if (isPinned != null) #isPinned: isPinned,
      if (isAnnouncement != null) #isAnnouncement: isAnnouncement,
      if (isStickySource != null) #isStickySource: isStickySource,
      if (canRename != null) #canRename: canRename,
      if (canDelete != null) #canDelete: canDelete,
      if (canClose != null) #canClose: canClose,
      if (canApprove != null) #canApprove: canApprove,
      if (canStick != null) #canStick: canStick,
      if (canMove != null) #canMove: canMove,
      if (canMerge != null) #canMerge: canMerge,
      if (canBan != null) #canBan: canBan,
      if (isBanned != null) #isBanned: isBanned,
      if (isApproved != null) #isApproved: isApproved,
      if (isDeleted != null) #isDeleted: isDeleted,
      if (isMoved != null) #isMoved: isMoved,
      if (isMerged != null) #isMerged: isMerged,
      if (realTopicId != $none) #realTopicId: realTopicId,
      if (canLike != null) #canLike: canLike,
      if (isLiked != null) #isLiked: isLiked,
      if (likeCount != null) #likeCount: likeCount,
      if (canThank != null) #canThank: canThank,
      if (hasPoll != null) #hasPoll: hasPoll,
      if (poll != $none) #poll: poll,
    }),
  );
  @override
  FCThreadByPostResult $make(CopyWithData data) => FCThreadByPostResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    totalPostNum: data.get(#totalPostNum, or: $value.totalPostNum),
    canReply: data.get(#canReply, or: $value.canReply),
    canReport: data.get(#canReport, or: $value.canReport),
    canUpload: data.get(#canUpload, or: $value.canUpload),
    posts: data.get(#posts, or: $value.posts),
    position: data.get(#position, or: $value.position),
    id: data.get(#id, or: $value.id),
    title: data.get(#title, or: $value.title),
    forumId: data.get(#forumId, or: $value.forumId),
    forumName: data.get(#forumName, or: $value.forumName),
    authorId: data.get(#authorId, or: $value.authorId),
    authorName: data.get(#authorName, or: $value.authorName),
    authorUserType: data.get(#authorUserType, or: $value.authorUserType),
    timestamp: data.get(#timestamp, or: $value.timestamp),
    prefix: data.get(#prefix, or: $value.prefix),
    authorIconUrl: data.get(#authorIconUrl, or: $value.authorIconUrl),
    replyCount: data.get(#replyCount, or: $value.replyCount),
    viewCount: data.get(#viewCount, or: $value.viewCount),
    hasNewPosts: data.get(#hasNewPosts, or: $value.hasNewPosts),
    isClosed: data.get(#isClosed, or: $value.isClosed),
    isSubscribed: data.get(#isSubscribed, or: $value.isSubscribed),
    canSubscribe: data.get(#canSubscribe, or: $value.canSubscribe),
    url: data.get(#url, or: $value.url),
    shortContent: data.get(#shortContent, or: $value.shortContent),
    participatedUserIds: data.get(
      #participatedUserIds,
      or: $value.participatedUserIds,
    ),
    isPinned: data.get(#isPinned, or: $value.isPinned),
    isAnnouncement: data.get(#isAnnouncement, or: $value.isAnnouncement),
    isStickySource: data.get(#isStickySource, or: $value.isStickySource),
    canRename: data.get(#canRename, or: $value.canRename),
    canDelete: data.get(#canDelete, or: $value.canDelete),
    canClose: data.get(#canClose, or: $value.canClose),
    canApprove: data.get(#canApprove, or: $value.canApprove),
    canStick: data.get(#canStick, or: $value.canStick),
    canMove: data.get(#canMove, or: $value.canMove),
    canMerge: data.get(#canMerge, or: $value.canMerge),
    canBan: data.get(#canBan, or: $value.canBan),
    isBanned: data.get(#isBanned, or: $value.isBanned),
    isApproved: data.get(#isApproved, or: $value.isApproved),
    isDeleted: data.get(#isDeleted, or: $value.isDeleted),
    isMoved: data.get(#isMoved, or: $value.isMoved),
    isMerged: data.get(#isMerged, or: $value.isMerged),
    realTopicId: data.get(#realTopicId, or: $value.realTopicId),
    canLike: data.get(#canLike, or: $value.canLike),
    isLiked: data.get(#isLiked, or: $value.isLiked),
    likeCount: data.get(#likeCount, or: $value.likeCount),
    canThank: data.get(#canThank, or: $value.canThank),
    hasPoll: data.get(#hasPoll, or: $value.hasPoll),
    poll: data.get(#poll, or: $value.poll),
  );

  @override
  FCThreadByPostResultCopyWith<$R2, FCThreadByPostResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCThreadByPostResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCReplyPostResultMapper extends ClassMapperBase<FCReplyPostResult> {
  FCReplyPostResultMapper._();

  static FCReplyPostResultMapper? _instance;
  static FCReplyPostResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCReplyPostResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCReplyPostResult';

  static bool _$result(FCReplyPostResult v) => v.result;
  static const Field<FCReplyPostResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCReplyPostResult v) => v.resultText;
  static const Field<FCReplyPostResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static String? _$postId(FCReplyPostResult v) => v.postId;
  static const Field<FCReplyPostResult, String> _f$postId = Field(
    'postId',
    _$postId,
    opt: true,
  );
  static int _$state(FCReplyPostResult v) => v.state;
  static const Field<FCReplyPostResult, int> _f$state = Field(
    'state',
    _$state,
    opt: true,
    def: 0,
  );
  static String? _$postContent(FCReplyPostResult v) => v.postContent;
  static const Field<FCReplyPostResult, String> _f$postContent = Field(
    'postContent',
    _$postContent,
    opt: true,
  );
  static bool _$canEdit(FCReplyPostResult v) => v.canEdit;
  static const Field<FCReplyPostResult, bool> _f$canEdit = Field(
    'canEdit',
    _$canEdit,
    opt: true,
    def: false,
  );
  static bool _$canDelete(FCReplyPostResult v) => v.canDelete;
  static const Field<FCReplyPostResult, bool> _f$canDelete = Field(
    'canDelete',
    _$canDelete,
    opt: true,
    def: false,
  );
  static bool _$canReport(FCReplyPostResult v) => v.canReport;
  static const Field<FCReplyPostResult, bool> _f$canReport = Field(
    'canReport',
    _$canReport,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<FCReplyPostResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #postId: _f$postId,
    #state: _f$state,
    #postContent: _f$postContent,
    #canEdit: _f$canEdit,
    #canDelete: _f$canDelete,
    #canReport: _f$canReport,
  };

  static FCReplyPostResult _instantiate(DecodingData data) {
    return FCReplyPostResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      postId: data.dec(_f$postId),
      state: data.dec(_f$state),
      postContent: data.dec(_f$postContent),
      canEdit: data.dec(_f$canEdit),
      canDelete: data.dec(_f$canDelete),
      canReport: data.dec(_f$canReport),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCReplyPostResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCReplyPostResult>(map);
  }

  static FCReplyPostResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCReplyPostResult>(json);
  }
}

mixin FCReplyPostResultMappable {
  String toJson() {
    return FCReplyPostResultMapper.ensureInitialized()
        .encodeJson<FCReplyPostResult>(this as FCReplyPostResult);
  }

  Map<String, dynamic> toMap() {
    return FCReplyPostResultMapper.ensureInitialized()
        .encodeMap<FCReplyPostResult>(this as FCReplyPostResult);
  }

  FCReplyPostResultCopyWith<
    FCReplyPostResult,
    FCReplyPostResult,
    FCReplyPostResult
  >
  get copyWith =>
      _FCReplyPostResultCopyWithImpl<FCReplyPostResult, FCReplyPostResult>(
        this as FCReplyPostResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCReplyPostResultMapper.ensureInitialized().stringifyValue(
      this as FCReplyPostResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCReplyPostResultMapper.ensureInitialized().equalsValue(
      this as FCReplyPostResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCReplyPostResultMapper.ensureInitialized().hashValue(
      this as FCReplyPostResult,
    );
  }
}

extension FCReplyPostResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCReplyPostResult, $Out> {
  FCReplyPostResultCopyWith<$R, FCReplyPostResult, $Out>
  get $asFCReplyPostResult => $base.as(
    (v, t, t2) => _FCReplyPostResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCReplyPostResultCopyWith<
  $R,
  $In extends FCReplyPostResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({
    bool? result,
    String? resultText,
    String? postId,
    int? state,
    String? postContent,
    bool? canEdit,
    bool? canDelete,
    bool? canReport,
  });
  FCReplyPostResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCReplyPostResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCReplyPostResult, $Out>
    implements FCReplyPostResultCopyWith<$R, FCReplyPostResult, $Out> {
  _FCReplyPostResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCReplyPostResult> $mapper =
      FCReplyPostResultMapper.ensureInitialized();
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
    Object? postId = $none,
    int? state,
    Object? postContent = $none,
    bool? canEdit,
    bool? canDelete,
    bool? canReport,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (postId != $none) #postId: postId,
      if (state != null) #state: state,
      if (postContent != $none) #postContent: postContent,
      if (canEdit != null) #canEdit: canEdit,
      if (canDelete != null) #canDelete: canDelete,
      if (canReport != null) #canReport: canReport,
    }),
  );
  @override
  FCReplyPostResult $make(CopyWithData data) => FCReplyPostResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    postId: data.get(#postId, or: $value.postId),
    state: data.get(#state, or: $value.state),
    postContent: data.get(#postContent, or: $value.postContent),
    canEdit: data.get(#canEdit, or: $value.canEdit),
    canDelete: data.get(#canDelete, or: $value.canDelete),
    canReport: data.get(#canReport, or: $value.canReport),
  );

  @override
  FCReplyPostResultCopyWith<$R2, FCReplyPostResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCReplyPostResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCReportPostResultMapper extends ClassMapperBase<FCReportPostResult> {
  FCReportPostResultMapper._();

  static FCReportPostResultMapper? _instance;
  static FCReportPostResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCReportPostResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCReportPostResult';

  static bool _$result(FCReportPostResult v) => v.result;
  static const Field<FCReportPostResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCReportPostResult v) => v.resultText;
  static const Field<FCReportPostResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );

  @override
  final MappableFields<FCReportPostResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
  };

  static FCReportPostResult _instantiate(DecodingData data) {
    return FCReportPostResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCReportPostResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCReportPostResult>(map);
  }

  static FCReportPostResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCReportPostResult>(json);
  }
}

mixin FCReportPostResultMappable {
  String toJson() {
    return FCReportPostResultMapper.ensureInitialized()
        .encodeJson<FCReportPostResult>(this as FCReportPostResult);
  }

  Map<String, dynamic> toMap() {
    return FCReportPostResultMapper.ensureInitialized()
        .encodeMap<FCReportPostResult>(this as FCReportPostResult);
  }

  FCReportPostResultCopyWith<
    FCReportPostResult,
    FCReportPostResult,
    FCReportPostResult
  >
  get copyWith =>
      _FCReportPostResultCopyWithImpl<FCReportPostResult, FCReportPostResult>(
        this as FCReportPostResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCReportPostResultMapper.ensureInitialized().stringifyValue(
      this as FCReportPostResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCReportPostResultMapper.ensureInitialized().equalsValue(
      this as FCReportPostResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCReportPostResultMapper.ensureInitialized().hashValue(
      this as FCReportPostResult,
    );
  }
}

extension FCReportPostResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCReportPostResult, $Out> {
  FCReportPostResultCopyWith<$R, FCReportPostResult, $Out>
  get $asFCReportPostResult => $base.as(
    (v, t, t2) => _FCReportPostResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCReportPostResultCopyWith<
  $R,
  $In extends FCReportPostResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText});
  FCReportPostResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCReportPostResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCReportPostResult, $Out>
    implements FCReportPostResultCopyWith<$R, FCReportPostResult, $Out> {
  _FCReportPostResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCReportPostResult> $mapper =
      FCReportPostResultMapper.ensureInitialized();
  @override
  $R call({bool? result, Object? resultText = $none}) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
    }),
  );
  @override
  FCReportPostResult $make(CopyWithData data) => FCReportPostResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
  );

  @override
  FCReportPostResultCopyWith<$R2, FCReportPostResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCReportPostResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCQuotePostResultMapper extends ClassMapperBase<FCQuotePostResult> {
  FCQuotePostResultMapper._();

  static FCQuotePostResultMapper? _instance;
  static FCQuotePostResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCQuotePostResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCQuotePostResult';

  static bool _$result(FCQuotePostResult v) => v.result;
  static const Field<FCQuotePostResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCQuotePostResult v) => v.resultText;
  static const Field<FCQuotePostResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static String? _$quoteContent(FCQuotePostResult v) => v.quoteContent;
  static const Field<FCQuotePostResult, String> _f$quoteContent = Field(
    'quoteContent',
    _$quoteContent,
    opt: true,
  );

  @override
  final MappableFields<FCQuotePostResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #quoteContent: _f$quoteContent,
  };

  static FCQuotePostResult _instantiate(DecodingData data) {
    return FCQuotePostResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      quoteContent: data.dec(_f$quoteContent),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCQuotePostResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCQuotePostResult>(map);
  }

  static FCQuotePostResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCQuotePostResult>(json);
  }
}

mixin FCQuotePostResultMappable {
  String toJson() {
    return FCQuotePostResultMapper.ensureInitialized()
        .encodeJson<FCQuotePostResult>(this as FCQuotePostResult);
  }

  Map<String, dynamic> toMap() {
    return FCQuotePostResultMapper.ensureInitialized()
        .encodeMap<FCQuotePostResult>(this as FCQuotePostResult);
  }

  FCQuotePostResultCopyWith<
    FCQuotePostResult,
    FCQuotePostResult,
    FCQuotePostResult
  >
  get copyWith =>
      _FCQuotePostResultCopyWithImpl<FCQuotePostResult, FCQuotePostResult>(
        this as FCQuotePostResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCQuotePostResultMapper.ensureInitialized().stringifyValue(
      this as FCQuotePostResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCQuotePostResultMapper.ensureInitialized().equalsValue(
      this as FCQuotePostResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCQuotePostResultMapper.ensureInitialized().hashValue(
      this as FCQuotePostResult,
    );
  }
}

extension FCQuotePostResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCQuotePostResult, $Out> {
  FCQuotePostResultCopyWith<$R, FCQuotePostResult, $Out>
  get $asFCQuotePostResult => $base.as(
    (v, t, t2) => _FCQuotePostResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCQuotePostResultCopyWith<
  $R,
  $In extends FCQuotePostResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText, String? quoteContent});
  FCQuotePostResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCQuotePostResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCQuotePostResult, $Out>
    implements FCQuotePostResultCopyWith<$R, FCQuotePostResult, $Out> {
  _FCQuotePostResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCQuotePostResult> $mapper =
      FCQuotePostResultMapper.ensureInitialized();
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
    Object? quoteContent = $none,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (quoteContent != $none) #quoteContent: quoteContent,
    }),
  );
  @override
  FCQuotePostResult $make(CopyWithData data) => FCQuotePostResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    quoteContent: data.get(#quoteContent, or: $value.quoteContent),
  );

  @override
  FCQuotePostResultCopyWith<$R2, FCQuotePostResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCQuotePostResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCRawPostResultMapper extends ClassMapperBase<FCRawPostResult> {
  FCRawPostResultMapper._();

  static FCRawPostResultMapper? _instance;
  static FCRawPostResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCRawPostResultMapper._());
      FCBaseResultMapper.ensureInitialized();
      FCAttachmentMapper.ensureInitialized();
      FCAttachmentDataMapper.ensureInitialized();
      FCPrefixMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCRawPostResult';

  static bool _$result(FCRawPostResult v) => v.result;
  static const Field<FCRawPostResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCRawPostResult v) => v.resultText;
  static const Field<FCRawPostResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static String? _$postContent(FCRawPostResult v) => v.postContent;
  static const Field<FCRawPostResult, String> _f$postContent = Field(
    'postContent',
    _$postContent,
    opt: true,
  );
  static String? _$postTitle(FCRawPostResult v) => v.postTitle;
  static const Field<FCRawPostResult, String> _f$postTitle = Field(
    'postTitle',
    _$postTitle,
    opt: true,
  );
  static bool? _$canEditTitle(FCRawPostResult v) => v.canEditTitle;
  static const Field<FCRawPostResult, bool> _f$canEditTitle = Field(
    'canEditTitle',
    _$canEditTitle,
    opt: true,
  );
  static String? _$forumId(FCRawPostResult v) => v.forumId;
  static const Field<FCRawPostResult, String> _f$forumId = Field(
    'forumId',
    _$forumId,
    opt: true,
  );
  static List<FCAttachment>? _$attachments(FCRawPostResult v) => v.attachments;
  static const Field<FCRawPostResult, List<FCAttachment>> _f$attachments =
      Field('attachments', _$attachments, opt: true);
  static FCAttachmentData? _$attachmentData(FCRawPostResult v) =>
      v.attachmentData;
  static const Field<FCRawPostResult, FCAttachmentData> _f$attachmentData =
      Field('attachmentData', _$attachmentData, opt: true);
  static String? _$prefixId(FCRawPostResult v) => v.prefixId;
  static const Field<FCRawPostResult, String> _f$prefixId = Field(
    'prefixId',
    _$prefixId,
    opt: true,
  );
  static bool _$requirePrefix(FCRawPostResult v) => v.requirePrefix;
  static const Field<FCRawPostResult, bool> _f$requirePrefix = Field(
    'requirePrefix',
    _$requirePrefix,
    opt: true,
    def: false,
  );
  static List<FCPrefix> _$prefixes(FCRawPostResult v) => v.prefixes;
  static const Field<FCRawPostResult, List<FCPrefix>> _f$prefixes = Field(
    'prefixes',
    _$prefixes,
    opt: true,
    def: const [],
  );

  @override
  final MappableFields<FCRawPostResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #postContent: _f$postContent,
    #postTitle: _f$postTitle,
    #canEditTitle: _f$canEditTitle,
    #forumId: _f$forumId,
    #attachments: _f$attachments,
    #attachmentData: _f$attachmentData,
    #prefixId: _f$prefixId,
    #requirePrefix: _f$requirePrefix,
    #prefixes: _f$prefixes,
  };

  static FCRawPostResult _instantiate(DecodingData data) {
    return FCRawPostResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      postContent: data.dec(_f$postContent),
      postTitle: data.dec(_f$postTitle),
      canEditTitle: data.dec(_f$canEditTitle),
      forumId: data.dec(_f$forumId),
      attachments: data.dec(_f$attachments),
      attachmentData: data.dec(_f$attachmentData),
      prefixId: data.dec(_f$prefixId),
      requirePrefix: data.dec(_f$requirePrefix),
      prefixes: data.dec(_f$prefixes),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCRawPostResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCRawPostResult>(map);
  }

  static FCRawPostResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCRawPostResult>(json);
  }
}

mixin FCRawPostResultMappable {
  String toJson() {
    return FCRawPostResultMapper.ensureInitialized()
        .encodeJson<FCRawPostResult>(this as FCRawPostResult);
  }

  Map<String, dynamic> toMap() {
    return FCRawPostResultMapper.ensureInitialized().encodeMap<FCRawPostResult>(
      this as FCRawPostResult,
    );
  }

  FCRawPostResultCopyWith<FCRawPostResult, FCRawPostResult, FCRawPostResult>
  get copyWith =>
      _FCRawPostResultCopyWithImpl<FCRawPostResult, FCRawPostResult>(
        this as FCRawPostResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCRawPostResultMapper.ensureInitialized().stringifyValue(
      this as FCRawPostResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCRawPostResultMapper.ensureInitialized().equalsValue(
      this as FCRawPostResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCRawPostResultMapper.ensureInitialized().hashValue(
      this as FCRawPostResult,
    );
  }
}

extension FCRawPostResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCRawPostResult, $Out> {
  FCRawPostResultCopyWith<$R, FCRawPostResult, $Out> get $asFCRawPostResult =>
      $base.as((v, t, t2) => _FCRawPostResultCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCRawPostResultCopyWith<$R, $In extends FCRawPostResult, $Out>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    FCAttachment,
    FCAttachmentCopyWith<$R, FCAttachment, FCAttachment>
  >?
  get attachments;
  FCAttachmentDataCopyWith<$R, FCAttachmentData, FCAttachmentData>?
  get attachmentData;
  ListCopyWith<$R, FCPrefix, FCPrefixCopyWith<$R, FCPrefix, FCPrefix>>
  get prefixes;
  @override
  $R call({
    bool? result,
    String? resultText,
    String? postContent,
    String? postTitle,
    bool? canEditTitle,
    String? forumId,
    List<FCAttachment>? attachments,
    FCAttachmentData? attachmentData,
    String? prefixId,
    bool? requirePrefix,
    List<FCPrefix>? prefixes,
  });
  FCRawPostResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCRawPostResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCRawPostResult, $Out>
    implements FCRawPostResultCopyWith<$R, FCRawPostResult, $Out> {
  _FCRawPostResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCRawPostResult> $mapper =
      FCRawPostResultMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    FCAttachment,
    FCAttachmentCopyWith<$R, FCAttachment, FCAttachment>
  >?
  get attachments => $value.attachments != null
      ? ListCopyWith(
          $value.attachments!,
          (v, t) => v.copyWith.$chain(t),
          (v) => call(attachments: v),
        )
      : null;
  @override
  FCAttachmentDataCopyWith<$R, FCAttachmentData, FCAttachmentData>?
  get attachmentData =>
      $value.attachmentData?.copyWith.$chain((v) => call(attachmentData: v));
  @override
  ListCopyWith<$R, FCPrefix, FCPrefixCopyWith<$R, FCPrefix, FCPrefix>>
  get prefixes => ListCopyWith(
    $value.prefixes,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(prefixes: v),
  );
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
    Object? postContent = $none,
    Object? postTitle = $none,
    Object? canEditTitle = $none,
    Object? forumId = $none,
    Object? attachments = $none,
    Object? attachmentData = $none,
    Object? prefixId = $none,
    bool? requirePrefix,
    List<FCPrefix>? prefixes,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (postContent != $none) #postContent: postContent,
      if (postTitle != $none) #postTitle: postTitle,
      if (canEditTitle != $none) #canEditTitle: canEditTitle,
      if (forumId != $none) #forumId: forumId,
      if (attachments != $none) #attachments: attachments,
      if (attachmentData != $none) #attachmentData: attachmentData,
      if (prefixId != $none) #prefixId: prefixId,
      if (requirePrefix != null) #requirePrefix: requirePrefix,
      if (prefixes != null) #prefixes: prefixes,
    }),
  );
  @override
  FCRawPostResult $make(CopyWithData data) => FCRawPostResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    postContent: data.get(#postContent, or: $value.postContent),
    postTitle: data.get(#postTitle, or: $value.postTitle),
    canEditTitle: data.get(#canEditTitle, or: $value.canEditTitle),
    forumId: data.get(#forumId, or: $value.forumId),
    attachments: data.get(#attachments, or: $value.attachments),
    attachmentData: data.get(#attachmentData, or: $value.attachmentData),
    prefixId: data.get(#prefixId, or: $value.prefixId),
    requirePrefix: data.get(#requirePrefix, or: $value.requirePrefix),
    prefixes: data.get(#prefixes, or: $value.prefixes),
  );

  @override
  FCRawPostResultCopyWith<$R2, FCRawPostResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCRawPostResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCSaveRawPostResultMapper extends ClassMapperBase<FCSaveRawPostResult> {
  FCSaveRawPostResultMapper._();

  static FCSaveRawPostResultMapper? _instance;
  static FCSaveRawPostResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCSaveRawPostResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCSaveRawPostResult';

  static bool _$result(FCSaveRawPostResult v) => v.result;
  static const Field<FCSaveRawPostResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCSaveRawPostResult v) => v.resultText;
  static const Field<FCSaveRawPostResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static String? _$postContent(FCSaveRawPostResult v) => v.postContent;
  static const Field<FCSaveRawPostResult, String> _f$postContent = Field(
    'postContent',
    _$postContent,
    opt: true,
  );

  @override
  final MappableFields<FCSaveRawPostResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #postContent: _f$postContent,
  };

  static FCSaveRawPostResult _instantiate(DecodingData data) {
    return FCSaveRawPostResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      postContent: data.dec(_f$postContent),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCSaveRawPostResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCSaveRawPostResult>(map);
  }

  static FCSaveRawPostResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCSaveRawPostResult>(json);
  }
}

mixin FCSaveRawPostResultMappable {
  String toJson() {
    return FCSaveRawPostResultMapper.ensureInitialized()
        .encodeJson<FCSaveRawPostResult>(this as FCSaveRawPostResult);
  }

  Map<String, dynamic> toMap() {
    return FCSaveRawPostResultMapper.ensureInitialized()
        .encodeMap<FCSaveRawPostResult>(this as FCSaveRawPostResult);
  }

  FCSaveRawPostResultCopyWith<
    FCSaveRawPostResult,
    FCSaveRawPostResult,
    FCSaveRawPostResult
  >
  get copyWith =>
      _FCSaveRawPostResultCopyWithImpl<
        FCSaveRawPostResult,
        FCSaveRawPostResult
      >(this as FCSaveRawPostResult, $identity, $identity);
  @override
  String toString() {
    return FCSaveRawPostResultMapper.ensureInitialized().stringifyValue(
      this as FCSaveRawPostResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCSaveRawPostResultMapper.ensureInitialized().equalsValue(
      this as FCSaveRawPostResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCSaveRawPostResultMapper.ensureInitialized().hashValue(
      this as FCSaveRawPostResult,
    );
  }
}

extension FCSaveRawPostResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCSaveRawPostResult, $Out> {
  FCSaveRawPostResultCopyWith<$R, FCSaveRawPostResult, $Out>
  get $asFCSaveRawPostResult => $base.as(
    (v, t, t2) => _FCSaveRawPostResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCSaveRawPostResultCopyWith<
  $R,
  $In extends FCSaveRawPostResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText, String? postContent});
  FCSaveRawPostResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCSaveRawPostResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCSaveRawPostResult, $Out>
    implements FCSaveRawPostResultCopyWith<$R, FCSaveRawPostResult, $Out> {
  _FCSaveRawPostResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCSaveRawPostResult> $mapper =
      FCSaveRawPostResultMapper.ensureInitialized();
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
    Object? postContent = $none,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (postContent != $none) #postContent: postContent,
    }),
  );
  @override
  FCSaveRawPostResult $make(CopyWithData data) => FCSaveRawPostResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    postContent: data.get(#postContent, or: $value.postContent),
  );

  @override
  FCSaveRawPostResultCopyWith<$R2, FCSaveRawPostResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCSaveRawPostResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCAnnouncementResultMapper extends ClassMapperBase<FCAnnouncementResult> {
  FCAnnouncementResultMapper._();

  static FCAnnouncementResultMapper? _instance;
  static FCAnnouncementResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCAnnouncementResultMapper._());
      FCTopicMapper.ensureInitialized();
      FCPostMapper.ensureInitialized();
      FCPollMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCAnnouncementResult';

  static bool _$result(FCAnnouncementResult v) => v.result;
  static const Field<FCAnnouncementResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCAnnouncementResult v) => v.resultText;
  static const Field<FCAnnouncementResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static int _$totalPostNum(FCAnnouncementResult v) => v.totalPostNum;
  static const Field<FCAnnouncementResult, int> _f$totalPostNum = Field(
    'totalPostNum',
    _$totalPostNum,
  );
  static String? _$announcementContent(FCAnnouncementResult v) =>
      v.announcementContent;
  static const Field<FCAnnouncementResult, String> _f$announcementContent =
      Field('announcementContent', _$announcementContent, opt: true);
  static String? _$announcementTitle(FCAnnouncementResult v) =>
      v.announcementTitle;
  static const Field<FCAnnouncementResult, String> _f$announcementTitle = Field(
    'announcementTitle',
    _$announcementTitle,
    opt: true,
  );
  static List<FCPost> _$posts(FCAnnouncementResult v) => v.posts;
  static const Field<FCAnnouncementResult, List<FCPost>> _f$posts = Field(
    'posts',
    _$posts,
    opt: true,
    def: const [],
  );
  static String _$id(FCAnnouncementResult v) => v.id;
  static const Field<FCAnnouncementResult, String> _f$id = Field('id', _$id);
  static String _$title(FCAnnouncementResult v) => v.title;
  static const Field<FCAnnouncementResult, String> _f$title = Field(
    'title',
    _$title,
  );
  static String _$forumId(FCAnnouncementResult v) => v.forumId;
  static const Field<FCAnnouncementResult, String> _f$forumId = Field(
    'forumId',
    _$forumId,
  );
  static String _$forumName(FCAnnouncementResult v) => v.forumName;
  static const Field<FCAnnouncementResult, String> _f$forumName = Field(
    'forumName',
    _$forumName,
  );
  static String _$authorId(FCAnnouncementResult v) => v.authorId;
  static const Field<FCAnnouncementResult, String> _f$authorId = Field(
    'authorId',
    _$authorId,
  );
  static String _$authorName(FCAnnouncementResult v) => v.authorName;
  static const Field<FCAnnouncementResult, String> _f$authorName = Field(
    'authorName',
    _$authorName,
  );
  static String? _$authorUserType(FCAnnouncementResult v) => v.authorUserType;
  static const Field<FCAnnouncementResult, String> _f$authorUserType = Field(
    'authorUserType',
    _$authorUserType,
  );
  static DateTime _$timestamp(FCAnnouncementResult v) => v.timestamp;
  static const Field<FCAnnouncementResult, DateTime> _f$timestamp = Field(
    'timestamp',
    _$timestamp,
    hook: MillisOrIsoDateHook(),
  );
  static String? _$prefix(FCAnnouncementResult v) => v.prefix;
  static const Field<FCAnnouncementResult, String> _f$prefix = Field(
    'prefix',
    _$prefix,
    opt: true,
  );
  static String? _$authorIconUrl(FCAnnouncementResult v) => v.authorIconUrl;
  static const Field<FCAnnouncementResult, String> _f$authorIconUrl = Field(
    'authorIconUrl',
    _$authorIconUrl,
    opt: true,
  );
  static int _$replyCount(FCAnnouncementResult v) => v.replyCount;
  static const Field<FCAnnouncementResult, int> _f$replyCount = Field(
    'replyCount',
    _$replyCount,
    opt: true,
    def: 0,
  );
  static int _$viewCount(FCAnnouncementResult v) => v.viewCount;
  static const Field<FCAnnouncementResult, int> _f$viewCount = Field(
    'viewCount',
    _$viewCount,
    opt: true,
    def: 0,
  );
  static bool _$hasNewPosts(FCAnnouncementResult v) => v.hasNewPosts;
  static const Field<FCAnnouncementResult, bool> _f$hasNewPosts = Field(
    'hasNewPosts',
    _$hasNewPosts,
    opt: true,
    def: false,
  );
  static bool _$isClosed(FCAnnouncementResult v) => v.isClosed;
  static const Field<FCAnnouncementResult, bool> _f$isClosed = Field(
    'isClosed',
    _$isClosed,
    opt: true,
    def: false,
  );
  static bool _$isSubscribed(FCAnnouncementResult v) => v.isSubscribed;
  static const Field<FCAnnouncementResult, bool> _f$isSubscribed = Field(
    'isSubscribed',
    _$isSubscribed,
    opt: true,
    def: false,
  );
  static bool _$canSubscribe(FCAnnouncementResult v) => v.canSubscribe;
  static const Field<FCAnnouncementResult, bool> _f$canSubscribe = Field(
    'canSubscribe',
    _$canSubscribe,
    opt: true,
    def: true,
  );
  static String? _$url(FCAnnouncementResult v) => v.url;
  static const Field<FCAnnouncementResult, String> _f$url = Field(
    'url',
    _$url,
    opt: true,
  );
  static String? _$shortContent(FCAnnouncementResult v) => v.shortContent;
  static const Field<FCAnnouncementResult, String> _f$shortContent = Field(
    'shortContent',
    _$shortContent,
    opt: true,
  );
  static List<String> _$participatedUserIds(FCAnnouncementResult v) =>
      v.participatedUserIds;
  static const Field<FCAnnouncementResult, List<String>>
  _f$participatedUserIds = Field(
    'participatedUserIds',
    _$participatedUserIds,
    opt: true,
    def: const [],
  );
  static bool _$isPinned(FCAnnouncementResult v) => v.isPinned;
  static const Field<FCAnnouncementResult, bool> _f$isPinned = Field(
    'isPinned',
    _$isPinned,
    opt: true,
    def: false,
    hook: FlexibleBoolHook(),
  );
  static bool _$isAnnouncement(FCAnnouncementResult v) => v.isAnnouncement;
  static const Field<FCAnnouncementResult, bool> _f$isAnnouncement = Field(
    'isAnnouncement',
    _$isAnnouncement,
    opt: true,
    def: false,
  );
  static bool _$isStickySource(FCAnnouncementResult v) => v.isStickySource;
  static const Field<FCAnnouncementResult, bool> _f$isStickySource = Field(
    'isStickySource',
    _$isStickySource,
    opt: true,
    def: false,
  );
  static bool _$canRename(FCAnnouncementResult v) => v.canRename;
  static const Field<FCAnnouncementResult, bool> _f$canRename = Field(
    'canRename',
    _$canRename,
    opt: true,
    def: false,
  );
  static bool _$canDelete(FCAnnouncementResult v) => v.canDelete;
  static const Field<FCAnnouncementResult, bool> _f$canDelete = Field(
    'canDelete',
    _$canDelete,
    opt: true,
    def: false,
  );
  static bool _$canClose(FCAnnouncementResult v) => v.canClose;
  static const Field<FCAnnouncementResult, bool> _f$canClose = Field(
    'canClose',
    _$canClose,
    opt: true,
    def: false,
  );
  static bool _$canApprove(FCAnnouncementResult v) => v.canApprove;
  static const Field<FCAnnouncementResult, bool> _f$canApprove = Field(
    'canApprove',
    _$canApprove,
    opt: true,
    def: false,
  );
  static bool _$canStick(FCAnnouncementResult v) => v.canStick;
  static const Field<FCAnnouncementResult, bool> _f$canStick = Field(
    'canStick',
    _$canStick,
    opt: true,
    def: false,
  );
  static bool _$canMove(FCAnnouncementResult v) => v.canMove;
  static const Field<FCAnnouncementResult, bool> _f$canMove = Field(
    'canMove',
    _$canMove,
    opt: true,
    def: false,
  );
  static bool _$canMerge(FCAnnouncementResult v) => v.canMerge;
  static const Field<FCAnnouncementResult, bool> _f$canMerge = Field(
    'canMerge',
    _$canMerge,
    opt: true,
    def: false,
  );
  static bool _$canBan(FCAnnouncementResult v) => v.canBan;
  static const Field<FCAnnouncementResult, bool> _f$canBan = Field(
    'canBan',
    _$canBan,
    opt: true,
    def: false,
  );
  static bool _$canReply(FCAnnouncementResult v) => v.canReply;
  static const Field<FCAnnouncementResult, bool> _f$canReply = Field(
    'canReply',
    _$canReply,
    opt: true,
    def: false,
  );
  static bool _$canReport(FCAnnouncementResult v) => v.canReport;
  static const Field<FCAnnouncementResult, bool> _f$canReport = Field(
    'canReport',
    _$canReport,
    opt: true,
    def: false,
  );
  static bool _$canUpload(FCAnnouncementResult v) => v.canUpload;
  static const Field<FCAnnouncementResult, bool> _f$canUpload = Field(
    'canUpload',
    _$canUpload,
    opt: true,
    def: false,
  );
  static bool _$isBanned(FCAnnouncementResult v) => v.isBanned;
  static const Field<FCAnnouncementResult, bool> _f$isBanned = Field(
    'isBanned',
    _$isBanned,
    opt: true,
    def: false,
  );
  static bool _$isApproved(FCAnnouncementResult v) => v.isApproved;
  static const Field<FCAnnouncementResult, bool> _f$isApproved = Field(
    'isApproved',
    _$isApproved,
    opt: true,
    def: true,
  );
  static bool _$isDeleted(FCAnnouncementResult v) => v.isDeleted;
  static const Field<FCAnnouncementResult, bool> _f$isDeleted = Field(
    'isDeleted',
    _$isDeleted,
    opt: true,
    def: false,
  );
  static bool _$isMoved(FCAnnouncementResult v) => v.isMoved;
  static const Field<FCAnnouncementResult, bool> _f$isMoved = Field(
    'isMoved',
    _$isMoved,
    opt: true,
    def: false,
  );
  static bool _$isMerged(FCAnnouncementResult v) => v.isMerged;
  static const Field<FCAnnouncementResult, bool> _f$isMerged = Field(
    'isMerged',
    _$isMerged,
    opt: true,
    def: false,
  );
  static String? _$realTopicId(FCAnnouncementResult v) => v.realTopicId;
  static const Field<FCAnnouncementResult, String> _f$realTopicId = Field(
    'realTopicId',
    _$realTopicId,
    opt: true,
  );
  static bool _$canLike(FCAnnouncementResult v) => v.canLike;
  static const Field<FCAnnouncementResult, bool> _f$canLike = Field(
    'canLike',
    _$canLike,
    opt: true,
    def: false,
  );
  static bool _$isLiked(FCAnnouncementResult v) => v.isLiked;
  static const Field<FCAnnouncementResult, bool> _f$isLiked = Field(
    'isLiked',
    _$isLiked,
    opt: true,
    def: false,
  );
  static int _$likeCount(FCAnnouncementResult v) => v.likeCount;
  static const Field<FCAnnouncementResult, int> _f$likeCount = Field(
    'likeCount',
    _$likeCount,
    opt: true,
    def: 0,
  );
  static bool _$canThank(FCAnnouncementResult v) => v.canThank;
  static const Field<FCAnnouncementResult, bool> _f$canThank = Field(
    'canThank',
    _$canThank,
    opt: true,
    def: false,
  );
  static bool _$hasPoll(FCAnnouncementResult v) => v.hasPoll;
  static const Field<FCAnnouncementResult, bool> _f$hasPoll = Field(
    'hasPoll',
    _$hasPoll,
    opt: true,
    def: false,
  );
  static FCPoll? _$poll(FCAnnouncementResult v) => v.poll;
  static const Field<FCAnnouncementResult, FCPoll> _f$poll = Field(
    'poll',
    _$poll,
    opt: true,
  );

  @override
  final MappableFields<FCAnnouncementResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #totalPostNum: _f$totalPostNum,
    #announcementContent: _f$announcementContent,
    #announcementTitle: _f$announcementTitle,
    #posts: _f$posts,
    #id: _f$id,
    #title: _f$title,
    #forumId: _f$forumId,
    #forumName: _f$forumName,
    #authorId: _f$authorId,
    #authorName: _f$authorName,
    #authorUserType: _f$authorUserType,
    #timestamp: _f$timestamp,
    #prefix: _f$prefix,
    #authorIconUrl: _f$authorIconUrl,
    #replyCount: _f$replyCount,
    #viewCount: _f$viewCount,
    #hasNewPosts: _f$hasNewPosts,
    #isClosed: _f$isClosed,
    #isSubscribed: _f$isSubscribed,
    #canSubscribe: _f$canSubscribe,
    #url: _f$url,
    #shortContent: _f$shortContent,
    #participatedUserIds: _f$participatedUserIds,
    #isPinned: _f$isPinned,
    #isAnnouncement: _f$isAnnouncement,
    #isStickySource: _f$isStickySource,
    #canRename: _f$canRename,
    #canDelete: _f$canDelete,
    #canClose: _f$canClose,
    #canApprove: _f$canApprove,
    #canStick: _f$canStick,
    #canMove: _f$canMove,
    #canMerge: _f$canMerge,
    #canBan: _f$canBan,
    #canReply: _f$canReply,
    #canReport: _f$canReport,
    #canUpload: _f$canUpload,
    #isBanned: _f$isBanned,
    #isApproved: _f$isApproved,
    #isDeleted: _f$isDeleted,
    #isMoved: _f$isMoved,
    #isMerged: _f$isMerged,
    #realTopicId: _f$realTopicId,
    #canLike: _f$canLike,
    #isLiked: _f$isLiked,
    #likeCount: _f$likeCount,
    #canThank: _f$canThank,
    #hasPoll: _f$hasPoll,
    #poll: _f$poll,
  };

  static FCAnnouncementResult _instantiate(DecodingData data) {
    return FCAnnouncementResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      totalPostNum: data.dec(_f$totalPostNum),
      announcementContent: data.dec(_f$announcementContent),
      announcementTitle: data.dec(_f$announcementTitle),
      posts: data.dec(_f$posts),
      id: data.dec(_f$id),
      title: data.dec(_f$title),
      forumId: data.dec(_f$forumId),
      forumName: data.dec(_f$forumName),
      authorId: data.dec(_f$authorId),
      authorName: data.dec(_f$authorName),
      authorUserType: data.dec(_f$authorUserType),
      timestamp: data.dec(_f$timestamp),
      prefix: data.dec(_f$prefix),
      authorIconUrl: data.dec(_f$authorIconUrl),
      replyCount: data.dec(_f$replyCount),
      viewCount: data.dec(_f$viewCount),
      hasNewPosts: data.dec(_f$hasNewPosts),
      isClosed: data.dec(_f$isClosed),
      isSubscribed: data.dec(_f$isSubscribed),
      canSubscribe: data.dec(_f$canSubscribe),
      url: data.dec(_f$url),
      shortContent: data.dec(_f$shortContent),
      participatedUserIds: data.dec(_f$participatedUserIds),
      isPinned: data.dec(_f$isPinned),
      isAnnouncement: data.dec(_f$isAnnouncement),
      isStickySource: data.dec(_f$isStickySource),
      canRename: data.dec(_f$canRename),
      canDelete: data.dec(_f$canDelete),
      canClose: data.dec(_f$canClose),
      canApprove: data.dec(_f$canApprove),
      canStick: data.dec(_f$canStick),
      canMove: data.dec(_f$canMove),
      canMerge: data.dec(_f$canMerge),
      canBan: data.dec(_f$canBan),
      canReply: data.dec(_f$canReply),
      canReport: data.dec(_f$canReport),
      canUpload: data.dec(_f$canUpload),
      isBanned: data.dec(_f$isBanned),
      isApproved: data.dec(_f$isApproved),
      isDeleted: data.dec(_f$isDeleted),
      isMoved: data.dec(_f$isMoved),
      isMerged: data.dec(_f$isMerged),
      realTopicId: data.dec(_f$realTopicId),
      canLike: data.dec(_f$canLike),
      isLiked: data.dec(_f$isLiked),
      likeCount: data.dec(_f$likeCount),
      canThank: data.dec(_f$canThank),
      hasPoll: data.dec(_f$hasPoll),
      poll: data.dec(_f$poll),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCAnnouncementResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCAnnouncementResult>(map);
  }

  static FCAnnouncementResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCAnnouncementResult>(json);
  }
}

mixin FCAnnouncementResultMappable {
  String toJson() {
    return FCAnnouncementResultMapper.ensureInitialized()
        .encodeJson<FCAnnouncementResult>(this as FCAnnouncementResult);
  }

  Map<String, dynamic> toMap() {
    return FCAnnouncementResultMapper.ensureInitialized()
        .encodeMap<FCAnnouncementResult>(this as FCAnnouncementResult);
  }

  FCAnnouncementResultCopyWith<
    FCAnnouncementResult,
    FCAnnouncementResult,
    FCAnnouncementResult
  >
  get copyWith =>
      _FCAnnouncementResultCopyWithImpl<
        FCAnnouncementResult,
        FCAnnouncementResult
      >(this as FCAnnouncementResult, $identity, $identity);
  @override
  String toString() {
    return FCAnnouncementResultMapper.ensureInitialized().stringifyValue(
      this as FCAnnouncementResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCAnnouncementResultMapper.ensureInitialized().equalsValue(
      this as FCAnnouncementResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCAnnouncementResultMapper.ensureInitialized().hashValue(
      this as FCAnnouncementResult,
    );
  }
}

extension FCAnnouncementResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCAnnouncementResult, $Out> {
  FCAnnouncementResultCopyWith<$R, FCAnnouncementResult, $Out>
  get $asFCAnnouncementResult => $base.as(
    (v, t, t2) => _FCAnnouncementResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCAnnouncementResultCopyWith<
  $R,
  $In extends FCAnnouncementResult,
  $Out
>
    implements FCTopicCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, FCPost, FCPostCopyWith<$R, FCPost, FCPost>> get posts;
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get participatedUserIds;
  @override
  FCPollCopyWith<$R, FCPoll, FCPoll>? get poll;
  @override
  $R call({
    bool? result,
    String? resultText,
    int? totalPostNum,
    String? announcementContent,
    String? announcementTitle,
    List<FCPost>? posts,
    String? id,
    String? title,
    String? forumId,
    String? forumName,
    String? authorId,
    String? authorName,
    covariant String? authorUserType,
    DateTime? timestamp,
    String? prefix,
    String? authorIconUrl,
    int? replyCount,
    int? viewCount,
    bool? hasNewPosts,
    bool? isClosed,
    bool? isSubscribed,
    bool? canSubscribe,
    String? url,
    String? shortContent,
    List<String>? participatedUserIds,
    bool? isPinned,
    bool? isAnnouncement,
    bool? isStickySource,
    bool? canRename,
    bool? canDelete,
    bool? canClose,
    bool? canApprove,
    bool? canStick,
    bool? canMove,
    bool? canMerge,
    bool? canBan,
    bool? canReply,
    bool? canReport,
    bool? canUpload,
    bool? isBanned,
    bool? isApproved,
    bool? isDeleted,
    bool? isMoved,
    bool? isMerged,
    String? realTopicId,
    bool? canLike,
    bool? isLiked,
    int? likeCount,
    bool? canThank,
    bool? hasPoll,
    FCPoll? poll,
  });
  FCAnnouncementResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCAnnouncementResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCAnnouncementResult, $Out>
    implements FCAnnouncementResultCopyWith<$R, FCAnnouncementResult, $Out> {
  _FCAnnouncementResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCAnnouncementResult> $mapper =
      FCAnnouncementResultMapper.ensureInitialized();
  @override
  ListCopyWith<$R, FCPost, FCPostCopyWith<$R, FCPost, FCPost>> get posts =>
      ListCopyWith(
        $value.posts,
        (v, t) => v.copyWith.$chain(t),
        (v) => call(posts: v),
      );
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get participatedUserIds => ListCopyWith(
    $value.participatedUserIds,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(participatedUserIds: v),
  );
  @override
  FCPollCopyWith<$R, FCPoll, FCPoll>? get poll =>
      $value.poll?.copyWith.$chain((v) => call(poll: v));
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
    int? totalPostNum,
    Object? announcementContent = $none,
    Object? announcementTitle = $none,
    List<FCPost>? posts,
    String? id,
    String? title,
    String? forumId,
    String? forumName,
    String? authorId,
    String? authorName,
    String? authorUserType,
    DateTime? timestamp,
    Object? prefix = $none,
    Object? authorIconUrl = $none,
    int? replyCount,
    int? viewCount,
    bool? hasNewPosts,
    bool? isClosed,
    bool? isSubscribed,
    bool? canSubscribe,
    Object? url = $none,
    Object? shortContent = $none,
    List<String>? participatedUserIds,
    bool? isPinned,
    bool? isAnnouncement,
    bool? isStickySource,
    bool? canRename,
    bool? canDelete,
    bool? canClose,
    bool? canApprove,
    bool? canStick,
    bool? canMove,
    bool? canMerge,
    bool? canBan,
    bool? canReply,
    bool? canReport,
    bool? canUpload,
    bool? isBanned,
    bool? isApproved,
    bool? isDeleted,
    bool? isMoved,
    bool? isMerged,
    Object? realTopicId = $none,
    bool? canLike,
    bool? isLiked,
    int? likeCount,
    bool? canThank,
    bool? hasPoll,
    Object? poll = $none,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (totalPostNum != null) #totalPostNum: totalPostNum,
      if (announcementContent != $none)
        #announcementContent: announcementContent,
      if (announcementTitle != $none) #announcementTitle: announcementTitle,
      if (posts != null) #posts: posts,
      if (id != null) #id: id,
      if (title != null) #title: title,
      if (forumId != null) #forumId: forumId,
      if (forumName != null) #forumName: forumName,
      if (authorId != null) #authorId: authorId,
      if (authorName != null) #authorName: authorName,
      if (authorUserType != null) #authorUserType: authorUserType,
      if (timestamp != null) #timestamp: timestamp,
      if (prefix != $none) #prefix: prefix,
      if (authorIconUrl != $none) #authorIconUrl: authorIconUrl,
      if (replyCount != null) #replyCount: replyCount,
      if (viewCount != null) #viewCount: viewCount,
      if (hasNewPosts != null) #hasNewPosts: hasNewPosts,
      if (isClosed != null) #isClosed: isClosed,
      if (isSubscribed != null) #isSubscribed: isSubscribed,
      if (canSubscribe != null) #canSubscribe: canSubscribe,
      if (url != $none) #url: url,
      if (shortContent != $none) #shortContent: shortContent,
      if (participatedUserIds != null)
        #participatedUserIds: participatedUserIds,
      if (isPinned != null) #isPinned: isPinned,
      if (isAnnouncement != null) #isAnnouncement: isAnnouncement,
      if (isStickySource != null) #isStickySource: isStickySource,
      if (canRename != null) #canRename: canRename,
      if (canDelete != null) #canDelete: canDelete,
      if (canClose != null) #canClose: canClose,
      if (canApprove != null) #canApprove: canApprove,
      if (canStick != null) #canStick: canStick,
      if (canMove != null) #canMove: canMove,
      if (canMerge != null) #canMerge: canMerge,
      if (canBan != null) #canBan: canBan,
      if (canReply != null) #canReply: canReply,
      if (canReport != null) #canReport: canReport,
      if (canUpload != null) #canUpload: canUpload,
      if (isBanned != null) #isBanned: isBanned,
      if (isApproved != null) #isApproved: isApproved,
      if (isDeleted != null) #isDeleted: isDeleted,
      if (isMoved != null) #isMoved: isMoved,
      if (isMerged != null) #isMerged: isMerged,
      if (realTopicId != $none) #realTopicId: realTopicId,
      if (canLike != null) #canLike: canLike,
      if (isLiked != null) #isLiked: isLiked,
      if (likeCount != null) #likeCount: likeCount,
      if (canThank != null) #canThank: canThank,
      if (hasPoll != null) #hasPoll: hasPoll,
      if (poll != $none) #poll: poll,
    }),
  );
  @override
  FCAnnouncementResult $make(CopyWithData data) => FCAnnouncementResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    totalPostNum: data.get(#totalPostNum, or: $value.totalPostNum),
    announcementContent: data.get(
      #announcementContent,
      or: $value.announcementContent,
    ),
    announcementTitle: data.get(
      #announcementTitle,
      or: $value.announcementTitle,
    ),
    posts: data.get(#posts, or: $value.posts),
    id: data.get(#id, or: $value.id),
    title: data.get(#title, or: $value.title),
    forumId: data.get(#forumId, or: $value.forumId),
    forumName: data.get(#forumName, or: $value.forumName),
    authorId: data.get(#authorId, or: $value.authorId),
    authorName: data.get(#authorName, or: $value.authorName),
    authorUserType: data.get(#authorUserType, or: $value.authorUserType),
    timestamp: data.get(#timestamp, or: $value.timestamp),
    prefix: data.get(#prefix, or: $value.prefix),
    authorIconUrl: data.get(#authorIconUrl, or: $value.authorIconUrl),
    replyCount: data.get(#replyCount, or: $value.replyCount),
    viewCount: data.get(#viewCount, or: $value.viewCount),
    hasNewPosts: data.get(#hasNewPosts, or: $value.hasNewPosts),
    isClosed: data.get(#isClosed, or: $value.isClosed),
    isSubscribed: data.get(#isSubscribed, or: $value.isSubscribed),
    canSubscribe: data.get(#canSubscribe, or: $value.canSubscribe),
    url: data.get(#url, or: $value.url),
    shortContent: data.get(#shortContent, or: $value.shortContent),
    participatedUserIds: data.get(
      #participatedUserIds,
      or: $value.participatedUserIds,
    ),
    isPinned: data.get(#isPinned, or: $value.isPinned),
    isAnnouncement: data.get(#isAnnouncement, or: $value.isAnnouncement),
    isStickySource: data.get(#isStickySource, or: $value.isStickySource),
    canRename: data.get(#canRename, or: $value.canRename),
    canDelete: data.get(#canDelete, or: $value.canDelete),
    canClose: data.get(#canClose, or: $value.canClose),
    canApprove: data.get(#canApprove, or: $value.canApprove),
    canStick: data.get(#canStick, or: $value.canStick),
    canMove: data.get(#canMove, or: $value.canMove),
    canMerge: data.get(#canMerge, or: $value.canMerge),
    canBan: data.get(#canBan, or: $value.canBan),
    canReply: data.get(#canReply, or: $value.canReply),
    canReport: data.get(#canReport, or: $value.canReport),
    canUpload: data.get(#canUpload, or: $value.canUpload),
    isBanned: data.get(#isBanned, or: $value.isBanned),
    isApproved: data.get(#isApproved, or: $value.isApproved),
    isDeleted: data.get(#isDeleted, or: $value.isDeleted),
    isMoved: data.get(#isMoved, or: $value.isMoved),
    isMerged: data.get(#isMerged, or: $value.isMerged),
    realTopicId: data.get(#realTopicId, or: $value.realTopicId),
    canLike: data.get(#canLike, or: $value.canLike),
    isLiked: data.get(#isLiked, or: $value.isLiked),
    likeCount: data.get(#likeCount, or: $value.likeCount),
    canThank: data.get(#canThank, or: $value.canThank),
    hasPoll: data.get(#hasPoll, or: $value.hasPoll),
    poll: data.get(#poll, or: $value.poll),
  );

  @override
  FCAnnouncementResultCopyWith<$R2, FCAnnouncementResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCAnnouncementResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

