// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fc_post.dart';

class FCPostMapper extends ClassMapperBase<FCPost> {
  FCPostMapper._();

  static FCPostMapper? _instance;
  static FCPostMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCPostMapper._());
      FCAttachmentMapper.ensureInitialized();
      FCThanksMapper.ensureInitialized();
      FCLikeMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCPost';

  static String _$id(FCPost v) => v.id;
  static const Field<FCPost, String> _f$id = Field('id', _$id);
  static String _$title(FCPost v) => v.title;
  static const Field<FCPost, String> _f$title = Field('title', _$title);
  static String _$content(FCPost v) => v.content;
  static const Field<FCPost, String> _f$content = Field('content', _$content);
  static String _$topicId(FCPost v) => v.topicId;
  static const Field<FCPost, String> _f$topicId = Field('topicId', _$topicId);
  static String? _$topicTitle(FCPost v) => v.topicTitle;
  static const Field<FCPost, String> _f$topicTitle = Field(
    'topicTitle',
    _$topicTitle,
    opt: true,
  );
  static String _$authorId(FCPost v) => v.authorId;
  static const Field<FCPost, String> _f$authorId = Field(
    'authorId',
    _$authorId,
  );
  static String _$authorName(FCPost v) => v.authorName;
  static const Field<FCPost, String> _f$authorName = Field(
    'authorName',
    _$authorName,
  );
  static String? _$authorUserType(FCPost v) => v.authorUserType;
  static const Field<FCPost, String> _f$authorUserType = Field(
    'authorUserType',
    _$authorUserType,
    opt: true,
  );
  static DateTime? _$timestamp(FCPost v) => v.timestamp;
  static const Field<FCPost, DateTime> _f$timestamp = Field(
    'timestamp',
    _$timestamp,
    opt: true,
    hook: MillisOrIsoDateHook(),
  );
  static String? _$authorIconUrl(FCPost v) => v.authorIconUrl;
  static const Field<FCPost, String> _f$authorIconUrl = Field(
    'authorIconUrl',
    _$authorIconUrl,
    opt: true,
  );
  static bool _$isAuthorOnline(FCPost v) => v.isAuthorOnline;
  static const Field<FCPost, bool> _f$isAuthorOnline = Field(
    'isAuthorOnline',
    _$isAuthorOnline,
    opt: true,
    def: false,
  );
  static bool _$canEdit(FCPost v) => v.canEdit;
  static const Field<FCPost, bool> _f$canEdit = Field(
    'canEdit',
    _$canEdit,
    opt: true,
    def: false,
  );
  static bool _$allowSmilies(FCPost v) => v.allowSmilies;
  static const Field<FCPost, bool> _f$allowSmilies = Field(
    'allowSmilies',
    _$allowSmilies,
    opt: true,
    def: true,
  );
  static List<FCAttachment> _$attachments(FCPost v) => v.attachments;
  static const Field<FCPost, List<FCAttachment>> _f$attachments = Field(
    'attachments',
    _$attachments,
    opt: true,
    def: const [],
  );
  static List<FCAttachment> _$inlineAttachments(FCPost v) =>
      v.inlineAttachments;
  static const Field<FCPost, List<FCAttachment>> _f$inlineAttachments = Field(
    'inlineAttachments',
    _$inlineAttachments,
    opt: true,
    def: const [],
  );
  static List<FCThanks> _$thanksInfo(FCPost v) => v.thanksInfo;
  static const Field<FCPost, List<FCThanks>> _f$thanksInfo = Field(
    'thanksInfo',
    _$thanksInfo,
    opt: true,
    def: const [],
  );
  static List<FCLike> _$likesInfo(FCPost v) => v.likesInfo;
  static const Field<FCPost, List<FCLike>> _f$likesInfo = Field(
    'likesInfo',
    _$likesInfo,
    opt: true,
    def: const [],
  );
  static int? _$postNumber(FCPost v) => v.postNumber;
  static const Field<FCPost, int> _f$postNumber = Field(
    'postNumber',
    _$postNumber,
    opt: true,
  );
  static bool _$canBan(FCPost v) => v.canBan;
  static const Field<FCPost, bool> _f$canBan = Field(
    'canBan',
    _$canBan,
    opt: true,
    def: false,
  );
  static bool _$canDelete(FCPost v) => v.canDelete;
  static const Field<FCPost, bool> _f$canDelete = Field(
    'canDelete',
    _$canDelete,
    opt: true,
    def: false,
  );
  static bool _$canApprove(FCPost v) => v.canApprove;
  static const Field<FCPost, bool> _f$canApprove = Field(
    'canApprove',
    _$canApprove,
    opt: true,
    def: false,
  );
  static bool _$canMove(FCPost v) => v.canMove;
  static const Field<FCPost, bool> _f$canMove = Field(
    'canMove',
    _$canMove,
    opt: true,
    def: false,
  );
  static bool _$canReport(FCPost v) => v.canReport;
  static const Field<FCPost, bool> _f$canReport = Field(
    'canReport',
    _$canReport,
    opt: true,
    def: false,
  );
  static bool _$isBanned(FCPost v) => v.isBanned;
  static const Field<FCPost, bool> _f$isBanned = Field(
    'isBanned',
    _$isBanned,
    opt: true,
    def: false,
  );
  static bool _$isDeleted(FCPost v) => v.isDeleted;
  static const Field<FCPost, bool> _f$isDeleted = Field(
    'isDeleted',
    _$isDeleted,
    opt: true,
    def: false,
  );
  static bool _$isApproved(FCPost v) => v.isApproved;
  static const Field<FCPost, bool> _f$isApproved = Field(
    'isApproved',
    _$isApproved,
    opt: true,
    def: true,
  );
  static bool _$isLiked(FCPost v) => v.isLiked;
  static const Field<FCPost, bool> _f$isLiked = Field(
    'isLiked',
    _$isLiked,
    opt: true,
    def: false,
  );
  static bool _$isThanked(FCPost v) => v.isThanked;
  static const Field<FCPost, bool> _f$isThanked = Field(
    'isThanked',
    _$isThanked,
    opt: true,
    def: false,
  );
  static bool _$canLike(FCPost v) => v.canLike;
  static const Field<FCPost, bool> _f$canLike = Field(
    'canLike',
    _$canLike,
    opt: true,
    def: false,
  );
  static bool _$canThank(FCPost v) => v.canThank;
  static const Field<FCPost, bool> _f$canThank = Field(
    'canThank',
    _$canThank,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<FCPost> fields = const {
    #id: _f$id,
    #title: _f$title,
    #content: _f$content,
    #topicId: _f$topicId,
    #topicTitle: _f$topicTitle,
    #authorId: _f$authorId,
    #authorName: _f$authorName,
    #authorUserType: _f$authorUserType,
    #timestamp: _f$timestamp,
    #authorIconUrl: _f$authorIconUrl,
    #isAuthorOnline: _f$isAuthorOnline,
    #canEdit: _f$canEdit,
    #allowSmilies: _f$allowSmilies,
    #attachments: _f$attachments,
    #inlineAttachments: _f$inlineAttachments,
    #thanksInfo: _f$thanksInfo,
    #likesInfo: _f$likesInfo,
    #postNumber: _f$postNumber,
    #canBan: _f$canBan,
    #canDelete: _f$canDelete,
    #canApprove: _f$canApprove,
    #canMove: _f$canMove,
    #canReport: _f$canReport,
    #isBanned: _f$isBanned,
    #isDeleted: _f$isDeleted,
    #isApproved: _f$isApproved,
    #isLiked: _f$isLiked,
    #isThanked: _f$isThanked,
    #canLike: _f$canLike,
    #canThank: _f$canThank,
  };

  static FCPost _instantiate(DecodingData data) {
    return FCPost(
      id: data.dec(_f$id),
      title: data.dec(_f$title),
      content: data.dec(_f$content),
      topicId: data.dec(_f$topicId),
      topicTitle: data.dec(_f$topicTitle),
      authorId: data.dec(_f$authorId),
      authorName: data.dec(_f$authorName),
      authorUserType: data.dec(_f$authorUserType),
      timestamp: data.dec(_f$timestamp),
      authorIconUrl: data.dec(_f$authorIconUrl),
      isAuthorOnline: data.dec(_f$isAuthorOnline),
      canEdit: data.dec(_f$canEdit),
      allowSmilies: data.dec(_f$allowSmilies),
      attachments: data.dec(_f$attachments),
      inlineAttachments: data.dec(_f$inlineAttachments),
      thanksInfo: data.dec(_f$thanksInfo),
      likesInfo: data.dec(_f$likesInfo),
      postNumber: data.dec(_f$postNumber),
      canBan: data.dec(_f$canBan),
      canDelete: data.dec(_f$canDelete),
      canApprove: data.dec(_f$canApprove),
      canMove: data.dec(_f$canMove),
      canReport: data.dec(_f$canReport),
      isBanned: data.dec(_f$isBanned),
      isDeleted: data.dec(_f$isDeleted),
      isApproved: data.dec(_f$isApproved),
      isLiked: data.dec(_f$isLiked),
      isThanked: data.dec(_f$isThanked),
      canLike: data.dec(_f$canLike),
      canThank: data.dec(_f$canThank),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCPost fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCPost>(map);
  }

  static FCPost fromJson(String json) {
    return ensureInitialized().decodeJson<FCPost>(json);
  }
}

mixin FCPostMappable {
  String toJson() {
    return FCPostMapper.ensureInitialized().encodeJson<FCPost>(this as FCPost);
  }

  Map<String, dynamic> toMap() {
    return FCPostMapper.ensureInitialized().encodeMap<FCPost>(this as FCPost);
  }

  FCPostCopyWith<FCPost, FCPost, FCPost> get copyWith =>
      _FCPostCopyWithImpl<FCPost, FCPost>(this as FCPost, $identity, $identity);
  @override
  String toString() {
    return FCPostMapper.ensureInitialized().stringifyValue(this as FCPost);
  }

  @override
  bool operator ==(Object other) {
    return FCPostMapper.ensureInitialized().equalsValue(this as FCPost, other);
  }

  @override
  int get hashCode {
    return FCPostMapper.ensureInitialized().hashValue(this as FCPost);
  }
}

extension FCPostValueCopy<$R, $Out> on ObjectCopyWith<$R, FCPost, $Out> {
  FCPostCopyWith<$R, FCPost, $Out> get $asFCPost =>
      $base.as((v, t, t2) => _FCPostCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCPostCopyWith<$R, $In extends FCPost, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    FCAttachment,
    FCAttachmentCopyWith<$R, FCAttachment, FCAttachment>
  >
  get attachments;
  ListCopyWith<
    $R,
    FCAttachment,
    FCAttachmentCopyWith<$R, FCAttachment, FCAttachment>
  >
  get inlineAttachments;
  ListCopyWith<$R, FCThanks, FCThanksCopyWith<$R, FCThanks, FCThanks>>
  get thanksInfo;
  ListCopyWith<$R, FCLike, FCLikeCopyWith<$R, FCLike, FCLike>> get likesInfo;
  $R call({
    String? id,
    String? title,
    String? content,
    String? topicId,
    String? topicTitle,
    String? authorId,
    String? authorName,
    String? authorUserType,
    DateTime? timestamp,
    String? authorIconUrl,
    bool? isAuthorOnline,
    bool? canEdit,
    bool? allowSmilies,
    List<FCAttachment>? attachments,
    List<FCAttachment>? inlineAttachments,
    List<FCThanks>? thanksInfo,
    List<FCLike>? likesInfo,
    int? postNumber,
    bool? canBan,
    bool? canDelete,
    bool? canApprove,
    bool? canMove,
    bool? canReport,
    bool? isBanned,
    bool? isDeleted,
    bool? isApproved,
    bool? isLiked,
    bool? isThanked,
    bool? canLike,
    bool? canThank,
  });
  FCPostCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FCPostCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, FCPost, $Out>
    implements FCPostCopyWith<$R, FCPost, $Out> {
  _FCPostCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCPost> $mapper = FCPostMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    FCAttachment,
    FCAttachmentCopyWith<$R, FCAttachment, FCAttachment>
  >
  get attachments => ListCopyWith(
    $value.attachments,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(attachments: v),
  );
  @override
  ListCopyWith<
    $R,
    FCAttachment,
    FCAttachmentCopyWith<$R, FCAttachment, FCAttachment>
  >
  get inlineAttachments => ListCopyWith(
    $value.inlineAttachments,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(inlineAttachments: v),
  );
  @override
  ListCopyWith<$R, FCThanks, FCThanksCopyWith<$R, FCThanks, FCThanks>>
  get thanksInfo => ListCopyWith(
    $value.thanksInfo,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(thanksInfo: v),
  );
  @override
  ListCopyWith<$R, FCLike, FCLikeCopyWith<$R, FCLike, FCLike>> get likesInfo =>
      ListCopyWith(
        $value.likesInfo,
        (v, t) => v.copyWith.$chain(t),
        (v) => call(likesInfo: v),
      );
  @override
  $R call({
    String? id,
    String? title,
    String? content,
    String? topicId,
    Object? topicTitle = $none,
    String? authorId,
    String? authorName,
    Object? authorUserType = $none,
    Object? timestamp = $none,
    Object? authorIconUrl = $none,
    bool? isAuthorOnline,
    bool? canEdit,
    bool? allowSmilies,
    List<FCAttachment>? attachments,
    List<FCAttachment>? inlineAttachments,
    List<FCThanks>? thanksInfo,
    List<FCLike>? likesInfo,
    Object? postNumber = $none,
    bool? canBan,
    bool? canDelete,
    bool? canApprove,
    bool? canMove,
    bool? canReport,
    bool? isBanned,
    bool? isDeleted,
    bool? isApproved,
    bool? isLiked,
    bool? isThanked,
    bool? canLike,
    bool? canThank,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (title != null) #title: title,
      if (content != null) #content: content,
      if (topicId != null) #topicId: topicId,
      if (topicTitle != $none) #topicTitle: topicTitle,
      if (authorId != null) #authorId: authorId,
      if (authorName != null) #authorName: authorName,
      if (authorUserType != $none) #authorUserType: authorUserType,
      if (timestamp != $none) #timestamp: timestamp,
      if (authorIconUrl != $none) #authorIconUrl: authorIconUrl,
      if (isAuthorOnline != null) #isAuthorOnline: isAuthorOnline,
      if (canEdit != null) #canEdit: canEdit,
      if (allowSmilies != null) #allowSmilies: allowSmilies,
      if (attachments != null) #attachments: attachments,
      if (inlineAttachments != null) #inlineAttachments: inlineAttachments,
      if (thanksInfo != null) #thanksInfo: thanksInfo,
      if (likesInfo != null) #likesInfo: likesInfo,
      if (postNumber != $none) #postNumber: postNumber,
      if (canBan != null) #canBan: canBan,
      if (canDelete != null) #canDelete: canDelete,
      if (canApprove != null) #canApprove: canApprove,
      if (canMove != null) #canMove: canMove,
      if (canReport != null) #canReport: canReport,
      if (isBanned != null) #isBanned: isBanned,
      if (isDeleted != null) #isDeleted: isDeleted,
      if (isApproved != null) #isApproved: isApproved,
      if (isLiked != null) #isLiked: isLiked,
      if (isThanked != null) #isThanked: isThanked,
      if (canLike != null) #canLike: canLike,
      if (canThank != null) #canThank: canThank,
    }),
  );
  @override
  FCPost $make(CopyWithData data) => FCPost(
    id: data.get(#id, or: $value.id),
    title: data.get(#title, or: $value.title),
    content: data.get(#content, or: $value.content),
    topicId: data.get(#topicId, or: $value.topicId),
    topicTitle: data.get(#topicTitle, or: $value.topicTitle),
    authorId: data.get(#authorId, or: $value.authorId),
    authorName: data.get(#authorName, or: $value.authorName),
    authorUserType: data.get(#authorUserType, or: $value.authorUserType),
    timestamp: data.get(#timestamp, or: $value.timestamp),
    authorIconUrl: data.get(#authorIconUrl, or: $value.authorIconUrl),
    isAuthorOnline: data.get(#isAuthorOnline, or: $value.isAuthorOnline),
    canEdit: data.get(#canEdit, or: $value.canEdit),
    allowSmilies: data.get(#allowSmilies, or: $value.allowSmilies),
    attachments: data.get(#attachments, or: $value.attachments),
    inlineAttachments: data.get(
      #inlineAttachments,
      or: $value.inlineAttachments,
    ),
    thanksInfo: data.get(#thanksInfo, or: $value.thanksInfo),
    likesInfo: data.get(#likesInfo, or: $value.likesInfo),
    postNumber: data.get(#postNumber, or: $value.postNumber),
    canBan: data.get(#canBan, or: $value.canBan),
    canDelete: data.get(#canDelete, or: $value.canDelete),
    canApprove: data.get(#canApprove, or: $value.canApprove),
    canMove: data.get(#canMove, or: $value.canMove),
    canReport: data.get(#canReport, or: $value.canReport),
    isBanned: data.get(#isBanned, or: $value.isBanned),
    isDeleted: data.get(#isDeleted, or: $value.isDeleted),
    isApproved: data.get(#isApproved, or: $value.isApproved),
    isLiked: data.get(#isLiked, or: $value.isLiked),
    isThanked: data.get(#isThanked, or: $value.isThanked),
    canLike: data.get(#canLike, or: $value.canLike),
    canThank: data.get(#canThank, or: $value.canThank),
  );

  @override
  FCPostCopyWith<$R2, FCPost, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCPostCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

