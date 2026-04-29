// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fc_private_message.dart';

class FCPrivateMessageMapper extends ClassMapperBase<FCPrivateMessage> {
  FCPrivateMessageMapper._();

  static FCPrivateMessageMapper? _instance;
  static FCPrivateMessageMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCPrivateMessageMapper._());
      FCMessageAttachmentMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCPrivateMessage';

  static String _$id(FCPrivateMessage v) => v.id;
  static const Field<FCPrivateMessage, String> _f$id = Field('id', _$id);
  static String _$subject(FCPrivateMessage v) => v.subject;
  static const Field<FCPrivateMessage, String> _f$subject = Field(
    'subject',
    _$subject,
  );
  static String _$content(FCPrivateMessage v) => v.content;
  static const Field<FCPrivateMessage, String> _f$content = Field(
    'content',
    _$content,
  );
  static String _$senderId(FCPrivateMessage v) => v.senderId;
  static const Field<FCPrivateMessage, String> _f$senderId = Field(
    'senderId',
    _$senderId,
  );
  static String _$senderName(FCPrivateMessage v) => v.senderName;
  static const Field<FCPrivateMessage, String> _f$senderName = Field(
    'senderName',
    _$senderName,
  );
  static String? _$senderUserType(FCPrivateMessage v) => v.senderUserType;
  static const Field<FCPrivateMessage, String> _f$senderUserType = Field(
    'senderUserType',
    _$senderUserType,
    opt: true,
  );
  static String? _$senderIconUrl(FCPrivateMessage v) => v.senderIconUrl;
  static const Field<FCPrivateMessage, String> _f$senderIconUrl = Field(
    'senderIconUrl',
    _$senderIconUrl,
    opt: true,
  );
  static String _$recipientId(FCPrivateMessage v) => v.recipientId;
  static const Field<FCPrivateMessage, String> _f$recipientId = Field(
    'recipientId',
    _$recipientId,
  );
  static String _$recipientName(FCPrivateMessage v) => v.recipientName;
  static const Field<FCPrivateMessage, String> _f$recipientName = Field(
    'recipientName',
    _$recipientName,
  );
  static DateTime _$timestamp(FCPrivateMessage v) => v.timestamp;
  static const Field<FCPrivateMessage, DateTime> _f$timestamp = Field(
    'timestamp',
    _$timestamp,
  );
  static bool _$isRead(FCPrivateMessage v) => v.isRead;
  static const Field<FCPrivateMessage, bool> _f$isRead = Field(
    'isRead',
    _$isRead,
    opt: true,
    def: false,
  );
  static bool _$isReplied(FCPrivateMessage v) => v.isReplied;
  static const Field<FCPrivateMessage, bool> _f$isReplied = Field(
    'isReplied',
    _$isReplied,
    opt: true,
    def: false,
  );
  static bool _$isFromCurrentUser(FCPrivateMessage v) => v.isFromCurrentUser;
  static const Field<FCPrivateMessage, bool> _f$isFromCurrentUser = Field(
    'isFromCurrentUser',
    _$isFromCurrentUser,
    opt: true,
    def: false,
  );
  static bool _$canDelete(FCPrivateMessage v) => v.canDelete;
  static const Field<FCPrivateMessage, bool> _f$canDelete = Field(
    'canDelete',
    _$canDelete,
    opt: true,
    def: false,
  );
  static bool _$canReport(FCPrivateMessage v) => v.canReport;
  static const Field<FCPrivateMessage, bool> _f$canReport = Field(
    'canReport',
    _$canReport,
    opt: true,
    def: false,
  );
  static bool _$canForward(FCPrivateMessage v) => v.canForward;
  static const Field<FCPrivateMessage, bool> _f$canForward = Field(
    'canForward',
    _$canForward,
    opt: true,
    def: false,
  );
  static bool _$canReply(FCPrivateMessage v) => v.canReply;
  static const Field<FCPrivateMessage, bool> _f$canReply = Field(
    'canReply',
    _$canReply,
    opt: true,
    def: false,
  );
  static List<FCMessageAttachment> _$attachments(FCPrivateMessage v) =>
      v.attachments;
  static const Field<FCPrivateMessage, List<FCMessageAttachment>>
  _f$attachments = Field(
    'attachments',
    _$attachments,
    opt: true,
    def: const [],
  );

  @override
  final MappableFields<FCPrivateMessage> fields = const {
    #id: _f$id,
    #subject: _f$subject,
    #content: _f$content,
    #senderId: _f$senderId,
    #senderName: _f$senderName,
    #senderUserType: _f$senderUserType,
    #senderIconUrl: _f$senderIconUrl,
    #recipientId: _f$recipientId,
    #recipientName: _f$recipientName,
    #timestamp: _f$timestamp,
    #isRead: _f$isRead,
    #isReplied: _f$isReplied,
    #isFromCurrentUser: _f$isFromCurrentUser,
    #canDelete: _f$canDelete,
    #canReport: _f$canReport,
    #canForward: _f$canForward,
    #canReply: _f$canReply,
    #attachments: _f$attachments,
  };

  static FCPrivateMessage _instantiate(DecodingData data) {
    return FCPrivateMessage(
      id: data.dec(_f$id),
      subject: data.dec(_f$subject),
      content: data.dec(_f$content),
      senderId: data.dec(_f$senderId),
      senderName: data.dec(_f$senderName),
      senderUserType: data.dec(_f$senderUserType),
      senderIconUrl: data.dec(_f$senderIconUrl),
      recipientId: data.dec(_f$recipientId),
      recipientName: data.dec(_f$recipientName),
      timestamp: data.dec(_f$timestamp),
      isRead: data.dec(_f$isRead),
      isReplied: data.dec(_f$isReplied),
      isFromCurrentUser: data.dec(_f$isFromCurrentUser),
      canDelete: data.dec(_f$canDelete),
      canReport: data.dec(_f$canReport),
      canForward: data.dec(_f$canForward),
      canReply: data.dec(_f$canReply),
      attachments: data.dec(_f$attachments),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCPrivateMessage fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCPrivateMessage>(map);
  }

  static FCPrivateMessage fromJson(String json) {
    return ensureInitialized().decodeJson<FCPrivateMessage>(json);
  }
}

mixin FCPrivateMessageMappable {
  String toJson() {
    return FCPrivateMessageMapper.ensureInitialized()
        .encodeJson<FCPrivateMessage>(this as FCPrivateMessage);
  }

  Map<String, dynamic> toMap() {
    return FCPrivateMessageMapper.ensureInitialized()
        .encodeMap<FCPrivateMessage>(this as FCPrivateMessage);
  }

  FCPrivateMessageCopyWith<FCPrivateMessage, FCPrivateMessage, FCPrivateMessage>
  get copyWith =>
      _FCPrivateMessageCopyWithImpl<FCPrivateMessage, FCPrivateMessage>(
        this as FCPrivateMessage,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCPrivateMessageMapper.ensureInitialized().stringifyValue(
      this as FCPrivateMessage,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCPrivateMessageMapper.ensureInitialized().equalsValue(
      this as FCPrivateMessage,
      other,
    );
  }

  @override
  int get hashCode {
    return FCPrivateMessageMapper.ensureInitialized().hashValue(
      this as FCPrivateMessage,
    );
  }
}

extension FCPrivateMessageValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCPrivateMessage, $Out> {
  FCPrivateMessageCopyWith<$R, FCPrivateMessage, $Out>
  get $asFCPrivateMessage =>
      $base.as((v, t, t2) => _FCPrivateMessageCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCPrivateMessageCopyWith<$R, $In extends FCPrivateMessage, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    FCMessageAttachment,
    FCMessageAttachmentCopyWith<$R, FCMessageAttachment, FCMessageAttachment>
  >
  get attachments;
  $R call({
    String? id,
    String? subject,
    String? content,
    String? senderId,
    String? senderName,
    String? senderUserType,
    String? senderIconUrl,
    String? recipientId,
    String? recipientName,
    DateTime? timestamp,
    bool? isRead,
    bool? isReplied,
    bool? isFromCurrentUser,
    bool? canDelete,
    bool? canReport,
    bool? canForward,
    bool? canReply,
    List<FCMessageAttachment>? attachments,
  });
  FCPrivateMessageCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCPrivateMessageCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCPrivateMessage, $Out>
    implements FCPrivateMessageCopyWith<$R, FCPrivateMessage, $Out> {
  _FCPrivateMessageCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCPrivateMessage> $mapper =
      FCPrivateMessageMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    FCMessageAttachment,
    FCMessageAttachmentCopyWith<$R, FCMessageAttachment, FCMessageAttachment>
  >
  get attachments => ListCopyWith(
    $value.attachments,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(attachments: v),
  );
  @override
  $R call({
    String? id,
    String? subject,
    String? content,
    String? senderId,
    String? senderName,
    Object? senderUserType = $none,
    Object? senderIconUrl = $none,
    String? recipientId,
    String? recipientName,
    DateTime? timestamp,
    bool? isRead,
    bool? isReplied,
    bool? isFromCurrentUser,
    bool? canDelete,
    bool? canReport,
    bool? canForward,
    bool? canReply,
    List<FCMessageAttachment>? attachments,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (subject != null) #subject: subject,
      if (content != null) #content: content,
      if (senderId != null) #senderId: senderId,
      if (senderName != null) #senderName: senderName,
      if (senderUserType != $none) #senderUserType: senderUserType,
      if (senderIconUrl != $none) #senderIconUrl: senderIconUrl,
      if (recipientId != null) #recipientId: recipientId,
      if (recipientName != null) #recipientName: recipientName,
      if (timestamp != null) #timestamp: timestamp,
      if (isRead != null) #isRead: isRead,
      if (isReplied != null) #isReplied: isReplied,
      if (isFromCurrentUser != null) #isFromCurrentUser: isFromCurrentUser,
      if (canDelete != null) #canDelete: canDelete,
      if (canReport != null) #canReport: canReport,
      if (canForward != null) #canForward: canForward,
      if (canReply != null) #canReply: canReply,
      if (attachments != null) #attachments: attachments,
    }),
  );
  @override
  FCPrivateMessage $make(CopyWithData data) => FCPrivateMessage(
    id: data.get(#id, or: $value.id),
    subject: data.get(#subject, or: $value.subject),
    content: data.get(#content, or: $value.content),
    senderId: data.get(#senderId, or: $value.senderId),
    senderName: data.get(#senderName, or: $value.senderName),
    senderUserType: data.get(#senderUserType, or: $value.senderUserType),
    senderIconUrl: data.get(#senderIconUrl, or: $value.senderIconUrl),
    recipientId: data.get(#recipientId, or: $value.recipientId),
    recipientName: data.get(#recipientName, or: $value.recipientName),
    timestamp: data.get(#timestamp, or: $value.timestamp),
    isRead: data.get(#isRead, or: $value.isRead),
    isReplied: data.get(#isReplied, or: $value.isReplied),
    isFromCurrentUser: data.get(
      #isFromCurrentUser,
      or: $value.isFromCurrentUser,
    ),
    canDelete: data.get(#canDelete, or: $value.canDelete),
    canReport: data.get(#canReport, or: $value.canReport),
    canForward: data.get(#canForward, or: $value.canForward),
    canReply: data.get(#canReply, or: $value.canReply),
    attachments: data.get(#attachments, or: $value.attachments),
  );

  @override
  FCPrivateMessageCopyWith<$R2, FCPrivateMessage, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCPrivateMessageCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCMessageAttachmentMapper extends ClassMapperBase<FCMessageAttachment> {
  FCMessageAttachmentMapper._();

  static FCMessageAttachmentMapper? _instance;
  static FCMessageAttachmentMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCMessageAttachmentMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FCMessageAttachment';

  static String _$id(FCMessageAttachment v) => v.id;
  static const Field<FCMessageAttachment, String> _f$id = Field('id', _$id);
  static String _$filename(FCMessageAttachment v) => v.filename;
  static const Field<FCMessageAttachment, String> _f$filename = Field(
    'filename',
    _$filename,
  );
  static int _$fileSize(FCMessageAttachment v) => v.fileSize;
  static const Field<FCMessageAttachment, int> _f$fileSize = Field(
    'fileSize',
    _$fileSize,
  );
  static String _$contentType(FCMessageAttachment v) => v.contentType;
  static const Field<FCMessageAttachment, String> _f$contentType = Field(
    'contentType',
    _$contentType,
  );
  static String _$url(FCMessageAttachment v) => v.url;
  static const Field<FCMessageAttachment, String> _f$url = Field('url', _$url);
  static String? _$thumbnailUrl(FCMessageAttachment v) => v.thumbnailUrl;
  static const Field<FCMessageAttachment, String> _f$thumbnailUrl = Field(
    'thumbnailUrl',
    _$thumbnailUrl,
    opt: true,
  );
  static bool _$isImage(FCMessageAttachment v) => v.isImage;
  static const Field<FCMessageAttachment, bool> _f$isImage = Field(
    'isImage',
    _$isImage,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<FCMessageAttachment> fields = const {
    #id: _f$id,
    #filename: _f$filename,
    #fileSize: _f$fileSize,
    #contentType: _f$contentType,
    #url: _f$url,
    #thumbnailUrl: _f$thumbnailUrl,
    #isImage: _f$isImage,
  };

  static FCMessageAttachment _instantiate(DecodingData data) {
    return FCMessageAttachment(
      id: data.dec(_f$id),
      filename: data.dec(_f$filename),
      fileSize: data.dec(_f$fileSize),
      contentType: data.dec(_f$contentType),
      url: data.dec(_f$url),
      thumbnailUrl: data.dec(_f$thumbnailUrl),
      isImage: data.dec(_f$isImage),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCMessageAttachment fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCMessageAttachment>(map);
  }

  static FCMessageAttachment fromJson(String json) {
    return ensureInitialized().decodeJson<FCMessageAttachment>(json);
  }
}

mixin FCMessageAttachmentMappable {
  String toJson() {
    return FCMessageAttachmentMapper.ensureInitialized()
        .encodeJson<FCMessageAttachment>(this as FCMessageAttachment);
  }

  Map<String, dynamic> toMap() {
    return FCMessageAttachmentMapper.ensureInitialized()
        .encodeMap<FCMessageAttachment>(this as FCMessageAttachment);
  }

  FCMessageAttachmentCopyWith<
    FCMessageAttachment,
    FCMessageAttachment,
    FCMessageAttachment
  >
  get copyWith =>
      _FCMessageAttachmentCopyWithImpl<
        FCMessageAttachment,
        FCMessageAttachment
      >(this as FCMessageAttachment, $identity, $identity);
  @override
  String toString() {
    return FCMessageAttachmentMapper.ensureInitialized().stringifyValue(
      this as FCMessageAttachment,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCMessageAttachmentMapper.ensureInitialized().equalsValue(
      this as FCMessageAttachment,
      other,
    );
  }

  @override
  int get hashCode {
    return FCMessageAttachmentMapper.ensureInitialized().hashValue(
      this as FCMessageAttachment,
    );
  }
}

extension FCMessageAttachmentValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCMessageAttachment, $Out> {
  FCMessageAttachmentCopyWith<$R, FCMessageAttachment, $Out>
  get $asFCMessageAttachment => $base.as(
    (v, t, t2) => _FCMessageAttachmentCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCMessageAttachmentCopyWith<
  $R,
  $In extends FCMessageAttachment,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    String? filename,
    int? fileSize,
    String? contentType,
    String? url,
    String? thumbnailUrl,
    bool? isImage,
  });
  FCMessageAttachmentCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCMessageAttachmentCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCMessageAttachment, $Out>
    implements FCMessageAttachmentCopyWith<$R, FCMessageAttachment, $Out> {
  _FCMessageAttachmentCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCMessageAttachment> $mapper =
      FCMessageAttachmentMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? filename,
    int? fileSize,
    String? contentType,
    String? url,
    Object? thumbnailUrl = $none,
    bool? isImage,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (filename != null) #filename: filename,
      if (fileSize != null) #fileSize: fileSize,
      if (contentType != null) #contentType: contentType,
      if (url != null) #url: url,
      if (thumbnailUrl != $none) #thumbnailUrl: thumbnailUrl,
      if (isImage != null) #isImage: isImage,
    }),
  );
  @override
  FCMessageAttachment $make(CopyWithData data) => FCMessageAttachment(
    id: data.get(#id, or: $value.id),
    filename: data.get(#filename, or: $value.filename),
    fileSize: data.get(#fileSize, or: $value.fileSize),
    contentType: data.get(#contentType, or: $value.contentType),
    url: data.get(#url, or: $value.url),
    thumbnailUrl: data.get(#thumbnailUrl, or: $value.thumbnailUrl),
    isImage: data.get(#isImage, or: $value.isImage),
  );

  @override
  FCMessageAttachmentCopyWith<$R2, FCMessageAttachment, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCMessageAttachmentCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

