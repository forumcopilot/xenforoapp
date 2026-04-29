// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fc_topic.dart';

class FCTopicMapper extends ClassMapperBase<FCTopic> {
  FCTopicMapper._();

  static FCTopicMapper? _instance;
  static FCTopicMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCTopicMapper._());
      FCPollMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCTopic';

  static String _$id(FCTopic v) => v.id;
  static const Field<FCTopic, String> _f$id = Field('id', _$id);
  static String _$title(FCTopic v) => v.title;
  static const Field<FCTopic, String> _f$title = Field('title', _$title);
  static String _$forumId(FCTopic v) => v.forumId;
  static const Field<FCTopic, String> _f$forumId = Field('forumId', _$forumId);
  static String _$forumName(FCTopic v) => v.forumName;
  static const Field<FCTopic, String> _f$forumName = Field(
    'forumName',
    _$forumName,
  );
  static String _$authorId(FCTopic v) => v.authorId;
  static const Field<FCTopic, String> _f$authorId = Field(
    'authorId',
    _$authorId,
  );
  static String _$authorName(FCTopic v) => v.authorName;
  static const Field<FCTopic, String> _f$authorName = Field(
    'authorName',
    _$authorName,
  );
  static DateTime _$timestamp(FCTopic v) => v.timestamp;
  static const Field<FCTopic, DateTime> _f$timestamp = Field(
    'timestamp',
    _$timestamp,
    hook: MillisOrIsoDateHook(),
  );
  static String? _$authorUserType(FCTopic v) => v.authorUserType;
  static const Field<FCTopic, String> _f$authorUserType = Field(
    'authorUserType',
    _$authorUserType,
    opt: true,
  );
  static String? _$prefix(FCTopic v) => v.prefix;
  static const Field<FCTopic, String> _f$prefix = Field(
    'prefix',
    _$prefix,
    opt: true,
  );
  static String? _$authorIconUrl(FCTopic v) => v.authorIconUrl;
  static const Field<FCTopic, String> _f$authorIconUrl = Field(
    'authorIconUrl',
    _$authorIconUrl,
    opt: true,
  );
  static int _$replyCount(FCTopic v) => v.replyCount;
  static const Field<FCTopic, int> _f$replyCount = Field(
    'replyCount',
    _$replyCount,
    opt: true,
    def: 0,
  );
  static int _$viewCount(FCTopic v) => v.viewCount;
  static const Field<FCTopic, int> _f$viewCount = Field(
    'viewCount',
    _$viewCount,
    opt: true,
    def: 0,
  );
  static bool _$hasNewPosts(FCTopic v) => v.hasNewPosts;
  static const Field<FCTopic, bool> _f$hasNewPosts = Field(
    'hasNewPosts',
    _$hasNewPosts,
    opt: true,
    def: false,
  );
  static bool _$isClosed(FCTopic v) => v.isClosed;
  static const Field<FCTopic, bool> _f$isClosed = Field(
    'isClosed',
    _$isClosed,
    opt: true,
    def: false,
  );
  static bool _$isSubscribed(FCTopic v) => v.isSubscribed;
  static const Field<FCTopic, bool> _f$isSubscribed = Field(
    'isSubscribed',
    _$isSubscribed,
    opt: true,
    def: false,
  );
  static bool _$canSubscribe(FCTopic v) => v.canSubscribe;
  static const Field<FCTopic, bool> _f$canSubscribe = Field(
    'canSubscribe',
    _$canSubscribe,
    opt: true,
    def: true,
  );
  static String? _$url(FCTopic v) => v.url;
  static const Field<FCTopic, String> _f$url = Field('url', _$url, opt: true);
  static String? _$shortContent(FCTopic v) => v.shortContent;
  static const Field<FCTopic, String> _f$shortContent = Field(
    'shortContent',
    _$shortContent,
    opt: true,
  );
  static List<String> _$participatedUserIds(FCTopic v) => v.participatedUserIds;
  static const Field<FCTopic, List<String>> _f$participatedUserIds = Field(
    'participatedUserIds',
    _$participatedUserIds,
    opt: true,
    def: const [],
  );
  static bool _$isPinned(FCTopic v) => v.isPinned;
  static const Field<FCTopic, bool> _f$isPinned = Field(
    'isPinned',
    _$isPinned,
    opt: true,
    def: false,
    hook: FlexibleBoolHook(),
  );
  static bool _$isAnnouncement(FCTopic v) => v.isAnnouncement;
  static const Field<FCTopic, bool> _f$isAnnouncement = Field(
    'isAnnouncement',
    _$isAnnouncement,
    opt: true,
    def: false,
  );
  static bool _$isStickySource(FCTopic v) => v.isStickySource;
  static const Field<FCTopic, bool> _f$isStickySource = Field(
    'isStickySource',
    _$isStickySource,
    opt: true,
    def: false,
  );
  static bool _$canRename(FCTopic v) => v.canRename;
  static const Field<FCTopic, bool> _f$canRename = Field(
    'canRename',
    _$canRename,
    opt: true,
    def: false,
  );
  static bool _$canDelete(FCTopic v) => v.canDelete;
  static const Field<FCTopic, bool> _f$canDelete = Field(
    'canDelete',
    _$canDelete,
    opt: true,
    def: false,
  );
  static bool _$canClose(FCTopic v) => v.canClose;
  static const Field<FCTopic, bool> _f$canClose = Field(
    'canClose',
    _$canClose,
    opt: true,
    def: false,
  );
  static bool _$canApprove(FCTopic v) => v.canApprove;
  static const Field<FCTopic, bool> _f$canApprove = Field(
    'canApprove',
    _$canApprove,
    opt: true,
    def: false,
  );
  static bool _$canStick(FCTopic v) => v.canStick;
  static const Field<FCTopic, bool> _f$canStick = Field(
    'canStick',
    _$canStick,
    opt: true,
    def: false,
  );
  static bool _$canMove(FCTopic v) => v.canMove;
  static const Field<FCTopic, bool> _f$canMove = Field(
    'canMove',
    _$canMove,
    opt: true,
    def: false,
  );
  static bool _$canMerge(FCTopic v) => v.canMerge;
  static const Field<FCTopic, bool> _f$canMerge = Field(
    'canMerge',
    _$canMerge,
    opt: true,
    def: false,
  );
  static bool _$canBan(FCTopic v) => v.canBan;
  static const Field<FCTopic, bool> _f$canBan = Field(
    'canBan',
    _$canBan,
    opt: true,
    def: false,
  );
  static bool _$canReply(FCTopic v) => v.canReply;
  static const Field<FCTopic, bool> _f$canReply = Field(
    'canReply',
    _$canReply,
    opt: true,
    def: false,
  );
  static bool _$canReport(FCTopic v) => v.canReport;
  static const Field<FCTopic, bool> _f$canReport = Field(
    'canReport',
    _$canReport,
    opt: true,
    def: false,
  );
  static bool _$canUpload(FCTopic v) => v.canUpload;
  static const Field<FCTopic, bool> _f$canUpload = Field(
    'canUpload',
    _$canUpload,
    opt: true,
    def: false,
  );
  static bool _$isBanned(FCTopic v) => v.isBanned;
  static const Field<FCTopic, bool> _f$isBanned = Field(
    'isBanned',
    _$isBanned,
    opt: true,
    def: false,
  );
  static bool _$isApproved(FCTopic v) => v.isApproved;
  static const Field<FCTopic, bool> _f$isApproved = Field(
    'isApproved',
    _$isApproved,
    opt: true,
    def: true,
  );
  static bool _$isDeleted(FCTopic v) => v.isDeleted;
  static const Field<FCTopic, bool> _f$isDeleted = Field(
    'isDeleted',
    _$isDeleted,
    opt: true,
    def: false,
  );
  static bool _$isMoved(FCTopic v) => v.isMoved;
  static const Field<FCTopic, bool> _f$isMoved = Field(
    'isMoved',
    _$isMoved,
    opt: true,
    def: false,
  );
  static bool _$isMerged(FCTopic v) => v.isMerged;
  static const Field<FCTopic, bool> _f$isMerged = Field(
    'isMerged',
    _$isMerged,
    opt: true,
    def: false,
  );
  static String? _$realTopicId(FCTopic v) => v.realTopicId;
  static const Field<FCTopic, String> _f$realTopicId = Field(
    'realTopicId',
    _$realTopicId,
    opt: true,
  );
  static bool _$canLike(FCTopic v) => v.canLike;
  static const Field<FCTopic, bool> _f$canLike = Field(
    'canLike',
    _$canLike,
    opt: true,
    def: false,
  );
  static bool _$isLiked(FCTopic v) => v.isLiked;
  static const Field<FCTopic, bool> _f$isLiked = Field(
    'isLiked',
    _$isLiked,
    opt: true,
    def: false,
  );
  static int _$likeCount(FCTopic v) => v.likeCount;
  static const Field<FCTopic, int> _f$likeCount = Field(
    'likeCount',
    _$likeCount,
    opt: true,
    def: 0,
  );
  static bool _$canThank(FCTopic v) => v.canThank;
  static const Field<FCTopic, bool> _f$canThank = Field(
    'canThank',
    _$canThank,
    opt: true,
    def: false,
  );
  static bool _$hasPoll(FCTopic v) => v.hasPoll;
  static const Field<FCTopic, bool> _f$hasPoll = Field(
    'hasPoll',
    _$hasPoll,
    opt: true,
    def: false,
  );
  static FCPoll? _$poll(FCTopic v) => v.poll;
  static const Field<FCTopic, FCPoll> _f$poll = Field(
    'poll',
    _$poll,
    opt: true,
  );

  @override
  final MappableFields<FCTopic> fields = const {
    #id: _f$id,
    #title: _f$title,
    #forumId: _f$forumId,
    #forumName: _f$forumName,
    #authorId: _f$authorId,
    #authorName: _f$authorName,
    #timestamp: _f$timestamp,
    #authorUserType: _f$authorUserType,
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

  static FCTopic _instantiate(DecodingData data) {
    return FCTopic(
      id: data.dec(_f$id),
      title: data.dec(_f$title),
      forumId: data.dec(_f$forumId),
      forumName: data.dec(_f$forumName),
      authorId: data.dec(_f$authorId),
      authorName: data.dec(_f$authorName),
      timestamp: data.dec(_f$timestamp),
      authorUserType: data.dec(_f$authorUserType),
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

  static FCTopic fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCTopic>(map);
  }

  static FCTopic fromJson(String json) {
    return ensureInitialized().decodeJson<FCTopic>(json);
  }
}

mixin FCTopicMappable {
  String toJson() {
    return FCTopicMapper.ensureInitialized().encodeJson<FCTopic>(
      this as FCTopic,
    );
  }

  Map<String, dynamic> toMap() {
    return FCTopicMapper.ensureInitialized().encodeMap<FCTopic>(
      this as FCTopic,
    );
  }

  FCTopicCopyWith<FCTopic, FCTopic, FCTopic> get copyWith =>
      _FCTopicCopyWithImpl<FCTopic, FCTopic>(
        this as FCTopic,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCTopicMapper.ensureInitialized().stringifyValue(this as FCTopic);
  }

  @override
  bool operator ==(Object other) {
    return FCTopicMapper.ensureInitialized().equalsValue(
      this as FCTopic,
      other,
    );
  }

  @override
  int get hashCode {
    return FCTopicMapper.ensureInitialized().hashValue(this as FCTopic);
  }
}

extension FCTopicValueCopy<$R, $Out> on ObjectCopyWith<$R, FCTopic, $Out> {
  FCTopicCopyWith<$R, FCTopic, $Out> get $asFCTopic =>
      $base.as((v, t, t2) => _FCTopicCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCTopicCopyWith<$R, $In extends FCTopic, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get participatedUserIds;
  FCPollCopyWith<$R, FCPoll, FCPoll>? get poll;
  $R call({
    String? id,
    String? title,
    String? forumId,
    String? forumName,
    String? authorId,
    String? authorName,
    DateTime? timestamp,
    String? authorUserType,
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
  FCTopicCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FCTopicCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCTopic, $Out>
    implements FCTopicCopyWith<$R, FCTopic, $Out> {
  _FCTopicCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCTopic> $mapper =
      FCTopicMapper.ensureInitialized();
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
    String? id,
    String? title,
    String? forumId,
    String? forumName,
    String? authorId,
    String? authorName,
    DateTime? timestamp,
    Object? authorUserType = $none,
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
      if (id != null) #id: id,
      if (title != null) #title: title,
      if (forumId != null) #forumId: forumId,
      if (forumName != null) #forumName: forumName,
      if (authorId != null) #authorId: authorId,
      if (authorName != null) #authorName: authorName,
      if (timestamp != null) #timestamp: timestamp,
      if (authorUserType != $none) #authorUserType: authorUserType,
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
  FCTopic $make(CopyWithData data) => FCTopic(
    id: data.get(#id, or: $value.id),
    title: data.get(#title, or: $value.title),
    forumId: data.get(#forumId, or: $value.forumId),
    forumName: data.get(#forumName, or: $value.forumName),
    authorId: data.get(#authorId, or: $value.authorId),
    authorName: data.get(#authorName, or: $value.authorName),
    timestamp: data.get(#timestamp, or: $value.timestamp),
    authorUserType: data.get(#authorUserType, or: $value.authorUserType),
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
  FCTopicCopyWith<$R2, FCTopic, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCTopicCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

