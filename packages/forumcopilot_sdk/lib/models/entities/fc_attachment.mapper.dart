// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fc_attachment.dart';

class FCAttachmentMapper extends ClassMapperBase<FCAttachment> {
  FCAttachmentMapper._();

  static FCAttachmentMapper? _instance;
  static FCAttachmentMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCAttachmentMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FCAttachment';

  static String _$id(FCAttachment v) => v.id;
  static const Field<FCAttachment, String> _f$id = Field('id', _$id);
  static String _$filename(FCAttachment v) => v.filename;
  static const Field<FCAttachment, String> _f$filename = Field(
    'filename',
    _$filename,
    key: r'fileName',
  );
  static String? _$contentType(FCAttachment v) => v.contentType;
  static const Field<FCAttachment, String> _f$contentType = Field(
    'contentType',
    _$contentType,
    key: r'mimeType',
    opt: true,
  );
  static int _$fileSize(FCAttachment v) => v.fileSize;
  static const Field<FCAttachment, int> _f$fileSize = Field(
    'fileSize',
    _$fileSize,
  );
  static String _$url(FCAttachment v) => v.url;
  static const Field<FCAttachment, String> _f$url = Field('url', _$url);
  static String? _$thumbnailUrl(FCAttachment v) => v.thumbnailUrl;
  static const Field<FCAttachment, String> _f$thumbnailUrl = Field(
    'thumbnailUrl',
    _$thumbnailUrl,
    opt: true,
  );
  static bool _$isImage(FCAttachment v) => v.isImage;
  static const Field<FCAttachment, bool> _f$isImage = Field(
    'isImage',
    _$isImage,
    opt: true,
    def: false,
  );
  static String? _$forumId(FCAttachment v) => v.forumId;
  static const Field<FCAttachment, String> _f$forumId = Field(
    'forumId',
    _$forumId,
    opt: true,
  );
  static String? _$postId(FCAttachment v) => v.postId;
  static const Field<FCAttachment, String> _f$postId = Field(
    'postId',
    _$postId,
    opt: true,
  );
  static bool? _$canViewUrl(FCAttachment v) => v.canViewUrl;
  static const Field<FCAttachment, bool> _f$canViewUrl = Field(
    'canViewUrl',
    _$canViewUrl,
    opt: true,
  );
  static bool? _$canViewThumbnailUrl(FCAttachment v) => v.canViewThumbnailUrl;
  static const Field<FCAttachment, bool> _f$canViewThumbnailUrl = Field(
    'canViewThumbnailUrl',
    _$canViewThumbnailUrl,
    opt: true,
  );
  static String? _$groupId(FCAttachment v) => v.groupId;
  static const Field<FCAttachment, String> _f$groupId = Field(
    'groupId',
    _$groupId,
    opt: true,
  );
  static int? _$width(FCAttachment v) => v.width;
  static const Field<FCAttachment, int> _f$width = Field(
    'width',
    _$width,
    opt: true,
  );
  static int? _$height(FCAttachment v) => v.height;
  static const Field<FCAttachment, int> _f$height = Field(
    'height',
    _$height,
    opt: true,
  );
  static String? _$icon(FCAttachment v) => v.icon;
  static const Field<FCAttachment, String> _f$icon = Field(
    'icon',
    _$icon,
    opt: true,
  );
  static String? _$iconName(FCAttachment v) => v.iconName;
  static const Field<FCAttachment, String> _f$iconName = Field(
    'iconName',
    _$iconName,
    opt: true,
  );
  static bool? _$isVideo(FCAttachment v) => v.isVideo;
  static const Field<FCAttachment, bool> _f$isVideo = Field(
    'isVideo',
    _$isVideo,
    opt: true,
  );
  static bool? _$isAudio(FCAttachment v) => v.isAudio;
  static const Field<FCAttachment, bool> _f$isAudio = Field(
    'isAudio',
    _$isAudio,
    opt: true,
  );
  static String? _$link(FCAttachment v) => v.link;
  static const Field<FCAttachment, String> _f$link = Field(
    'link',
    _$link,
    opt: true,
  );
  static String? _$typeGrouping(FCAttachment v) => v.typeGrouping;
  static const Field<FCAttachment, String> _f$typeGrouping = Field(
    'typeGrouping',
    _$typeGrouping,
    opt: true,
  );
  static String? _$fileSizePrintable(FCAttachment v) => v.fileSizePrintable;
  static const Field<FCAttachment, String> _f$fileSizePrintable = Field(
    'fileSizePrintable',
    _$fileSizePrintable,
    opt: true,
  );
  static bool? _$isInline(FCAttachment v) => v.isInline;
  static const Field<FCAttachment, bool> _f$isInline = Field(
    'isInline',
    _$isInline,
    opt: true,
  );

  @override
  final MappableFields<FCAttachment> fields = const {
    #id: _f$id,
    #filename: _f$filename,
    #contentType: _f$contentType,
    #fileSize: _f$fileSize,
    #url: _f$url,
    #thumbnailUrl: _f$thumbnailUrl,
    #isImage: _f$isImage,
    #forumId: _f$forumId,
    #postId: _f$postId,
    #canViewUrl: _f$canViewUrl,
    #canViewThumbnailUrl: _f$canViewThumbnailUrl,
    #groupId: _f$groupId,
    #width: _f$width,
    #height: _f$height,
    #icon: _f$icon,
    #iconName: _f$iconName,
    #isVideo: _f$isVideo,
    #isAudio: _f$isAudio,
    #link: _f$link,
    #typeGrouping: _f$typeGrouping,
    #fileSizePrintable: _f$fileSizePrintable,
    #isInline: _f$isInline,
  };

  static FCAttachment _instantiate(DecodingData data) {
    return FCAttachment(
      id: data.dec(_f$id),
      filename: data.dec(_f$filename),
      contentType: data.dec(_f$contentType),
      fileSize: data.dec(_f$fileSize),
      url: data.dec(_f$url),
      thumbnailUrl: data.dec(_f$thumbnailUrl),
      isImage: data.dec(_f$isImage),
      forumId: data.dec(_f$forumId),
      postId: data.dec(_f$postId),
      canViewUrl: data.dec(_f$canViewUrl),
      canViewThumbnailUrl: data.dec(_f$canViewThumbnailUrl),
      groupId: data.dec(_f$groupId),
      width: data.dec(_f$width),
      height: data.dec(_f$height),
      icon: data.dec(_f$icon),
      iconName: data.dec(_f$iconName),
      isVideo: data.dec(_f$isVideo),
      isAudio: data.dec(_f$isAudio),
      link: data.dec(_f$link),
      typeGrouping: data.dec(_f$typeGrouping),
      fileSizePrintable: data.dec(_f$fileSizePrintable),
      isInline: data.dec(_f$isInline),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCAttachment fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCAttachment>(map);
  }

  static FCAttachment fromJson(String json) {
    return ensureInitialized().decodeJson<FCAttachment>(json);
  }
}

mixin FCAttachmentMappable {
  String toJson() {
    return FCAttachmentMapper.ensureInitialized().encodeJson<FCAttachment>(
      this as FCAttachment,
    );
  }

  Map<String, dynamic> toMap() {
    return FCAttachmentMapper.ensureInitialized().encodeMap<FCAttachment>(
      this as FCAttachment,
    );
  }

  FCAttachmentCopyWith<FCAttachment, FCAttachment, FCAttachment> get copyWith =>
      _FCAttachmentCopyWithImpl<FCAttachment, FCAttachment>(
        this as FCAttachment,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCAttachmentMapper.ensureInitialized().stringifyValue(
      this as FCAttachment,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCAttachmentMapper.ensureInitialized().equalsValue(
      this as FCAttachment,
      other,
    );
  }

  @override
  int get hashCode {
    return FCAttachmentMapper.ensureInitialized().hashValue(
      this as FCAttachment,
    );
  }
}

extension FCAttachmentValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCAttachment, $Out> {
  FCAttachmentCopyWith<$R, FCAttachment, $Out> get $asFCAttachment =>
      $base.as((v, t, t2) => _FCAttachmentCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCAttachmentCopyWith<$R, $In extends FCAttachment, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    String? filename,
    String? contentType,
    int? fileSize,
    String? url,
    String? thumbnailUrl,
    bool? isImage,
    String? forumId,
    String? postId,
    bool? canViewUrl,
    bool? canViewThumbnailUrl,
    String? groupId,
    int? width,
    int? height,
    String? icon,
    String? iconName,
    bool? isVideo,
    bool? isAudio,
    String? link,
    String? typeGrouping,
    String? fileSizePrintable,
    bool? isInline,
  });
  FCAttachmentCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FCAttachmentCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCAttachment, $Out>
    implements FCAttachmentCopyWith<$R, FCAttachment, $Out> {
  _FCAttachmentCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCAttachment> $mapper =
      FCAttachmentMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? filename,
    Object? contentType = $none,
    int? fileSize,
    String? url,
    Object? thumbnailUrl = $none,
    bool? isImage,
    Object? forumId = $none,
    Object? postId = $none,
    Object? canViewUrl = $none,
    Object? canViewThumbnailUrl = $none,
    Object? groupId = $none,
    Object? width = $none,
    Object? height = $none,
    Object? icon = $none,
    Object? iconName = $none,
    Object? isVideo = $none,
    Object? isAudio = $none,
    Object? link = $none,
    Object? typeGrouping = $none,
    Object? fileSizePrintable = $none,
    Object? isInline = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (filename != null) #filename: filename,
      if (contentType != $none) #contentType: contentType,
      if (fileSize != null) #fileSize: fileSize,
      if (url != null) #url: url,
      if (thumbnailUrl != $none) #thumbnailUrl: thumbnailUrl,
      if (isImage != null) #isImage: isImage,
      if (forumId != $none) #forumId: forumId,
      if (postId != $none) #postId: postId,
      if (canViewUrl != $none) #canViewUrl: canViewUrl,
      if (canViewThumbnailUrl != $none)
        #canViewThumbnailUrl: canViewThumbnailUrl,
      if (groupId != $none) #groupId: groupId,
      if (width != $none) #width: width,
      if (height != $none) #height: height,
      if (icon != $none) #icon: icon,
      if (iconName != $none) #iconName: iconName,
      if (isVideo != $none) #isVideo: isVideo,
      if (isAudio != $none) #isAudio: isAudio,
      if (link != $none) #link: link,
      if (typeGrouping != $none) #typeGrouping: typeGrouping,
      if (fileSizePrintable != $none) #fileSizePrintable: fileSizePrintable,
      if (isInline != $none) #isInline: isInline,
    }),
  );
  @override
  FCAttachment $make(CopyWithData data) => FCAttachment(
    id: data.get(#id, or: $value.id),
    filename: data.get(#filename, or: $value.filename),
    contentType: data.get(#contentType, or: $value.contentType),
    fileSize: data.get(#fileSize, or: $value.fileSize),
    url: data.get(#url, or: $value.url),
    thumbnailUrl: data.get(#thumbnailUrl, or: $value.thumbnailUrl),
    isImage: data.get(#isImage, or: $value.isImage),
    forumId: data.get(#forumId, or: $value.forumId),
    postId: data.get(#postId, or: $value.postId),
    canViewUrl: data.get(#canViewUrl, or: $value.canViewUrl),
    canViewThumbnailUrl: data.get(
      #canViewThumbnailUrl,
      or: $value.canViewThumbnailUrl,
    ),
    groupId: data.get(#groupId, or: $value.groupId),
    width: data.get(#width, or: $value.width),
    height: data.get(#height, or: $value.height),
    icon: data.get(#icon, or: $value.icon),
    iconName: data.get(#iconName, or: $value.iconName),
    isVideo: data.get(#isVideo, or: $value.isVideo),
    isAudio: data.get(#isAudio, or: $value.isAudio),
    link: data.get(#link, or: $value.link),
    typeGrouping: data.get(#typeGrouping, or: $value.typeGrouping),
    fileSizePrintable: data.get(
      #fileSizePrintable,
      or: $value.fileSizePrintable,
    ),
    isInline: data.get(#isInline, or: $value.isInline),
  );

  @override
  FCAttachmentCopyWith<$R2, FCAttachment, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCAttachmentCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

