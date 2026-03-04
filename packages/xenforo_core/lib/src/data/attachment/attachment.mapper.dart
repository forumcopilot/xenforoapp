// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'attachment.dart';

class XenForoAttachmentMapper extends ClassMapperBase<XenForoAttachment> {
  XenForoAttachmentMapper._();

  static XenForoAttachmentMapper? _instance;
  static XenForoAttachmentMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = XenForoAttachmentMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'XenForoAttachment';

  static int _$attachmentId(XenForoAttachment v) => v.attachmentId;
  static const Field<XenForoAttachment, int> _f$attachmentId =
      Field('attachmentId', _$attachmentId);
  static String _$filename(XenForoAttachment v) => v.filename;
  static const Field<XenForoAttachment, String> _f$filename =
      Field('filename', _$filename);
  static int _$fileSize(XenForoAttachment v) => v.fileSize;
  static const Field<XenForoAttachment, int> _f$fileSize =
      Field('fileSize', _$fileSize);
  static int? _$height(XenForoAttachment v) => v.height;
  static const Field<XenForoAttachment, int> _f$height =
      Field('height', _$height, opt: true);
  static int? _$width(XenForoAttachment v) => v.width;
  static const Field<XenForoAttachment, int> _f$width =
      Field('width', _$width, opt: true);
  static String? _$thumbnailUrl(XenForoAttachment v) => v.thumbnailUrl;
  static const Field<XenForoAttachment, String> _f$thumbnailUrl =
      Field('thumbnailUrl', _$thumbnailUrl, opt: true);
  static String? _$directUrl(XenForoAttachment v) => v.directUrl;
  static const Field<XenForoAttachment, String> _f$directUrl =
      Field('directUrl', _$directUrl, opt: true);
  static bool? _$isVideo(XenForoAttachment v) => v.isVideo;
  static const Field<XenForoAttachment, bool> _f$isVideo =
      Field('isVideo', _$isVideo, opt: true);
  static bool? _$isAudio(XenForoAttachment v) => v.isAudio;
  static const Field<XenForoAttachment, bool> _f$isAudio =
      Field('isAudio', _$isAudio, opt: true);
  static String? _$contentType(XenForoAttachment v) => v.contentType;
  static const Field<XenForoAttachment, String> _f$contentType =
      Field('contentType', _$contentType, opt: true);
  static int? _$contentId(XenForoAttachment v) => v.contentId;
  static const Field<XenForoAttachment, int> _f$contentId =
      Field('contentId', _$contentId, opt: true);
  static int? _$attachDate(XenForoAttachment v) => v.attachDate;
  static const Field<XenForoAttachment, int> _f$attachDate =
      Field('attachDate', _$attachDate, opt: true);
  static int? _$viewCount(XenForoAttachment v) => v.viewCount;
  static const Field<XenForoAttachment, int> _f$viewCount =
      Field('viewCount', _$viewCount, opt: true);

  @override
  final MappableFields<XenForoAttachment> fields = const {
    #attachmentId: _f$attachmentId,
    #filename: _f$filename,
    #fileSize: _f$fileSize,
    #height: _f$height,
    #width: _f$width,
    #thumbnailUrl: _f$thumbnailUrl,
    #directUrl: _f$directUrl,
    #isVideo: _f$isVideo,
    #isAudio: _f$isAudio,
    #contentType: _f$contentType,
    #contentId: _f$contentId,
    #attachDate: _f$attachDate,
    #viewCount: _f$viewCount,
  };

  static XenForoAttachment _instantiate(DecodingData data) {
    return XenForoAttachment(
        attachmentId: data.dec(_f$attachmentId),
        filename: data.dec(_f$filename),
        fileSize: data.dec(_f$fileSize),
        height: data.dec(_f$height),
        width: data.dec(_f$width),
        thumbnailUrl: data.dec(_f$thumbnailUrl),
        directUrl: data.dec(_f$directUrl),
        isVideo: data.dec(_f$isVideo),
        isAudio: data.dec(_f$isAudio),
        contentType: data.dec(_f$contentType),
        contentId: data.dec(_f$contentId),
        attachDate: data.dec(_f$attachDate),
        viewCount: data.dec(_f$viewCount));
  }

  @override
  final Function instantiate = _instantiate;

  static XenForoAttachment fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<XenForoAttachment>(map);
  }

  static XenForoAttachment fromJson(String json) {
    return ensureInitialized().decodeJson<XenForoAttachment>(json);
  }
}

mixin XenForoAttachmentMappable {
  String toJson() {
    return XenForoAttachmentMapper.ensureInitialized()
        .encodeJson<XenForoAttachment>(this as XenForoAttachment);
  }

  Map<String, dynamic> toMap() {
    return XenForoAttachmentMapper.ensureInitialized()
        .encodeMap<XenForoAttachment>(this as XenForoAttachment);
  }

  XenForoAttachmentCopyWith<XenForoAttachment, XenForoAttachment,
          XenForoAttachment>
      get copyWith =>
          _XenForoAttachmentCopyWithImpl<XenForoAttachment, XenForoAttachment>(
              this as XenForoAttachment, $identity, $identity);
  @override
  String toString() {
    return XenForoAttachmentMapper.ensureInitialized()
        .stringifyValue(this as XenForoAttachment);
  }

  @override
  bool operator ==(Object other) {
    return XenForoAttachmentMapper.ensureInitialized()
        .equalsValue(this as XenForoAttachment, other);
  }

  @override
  int get hashCode {
    return XenForoAttachmentMapper.ensureInitialized()
        .hashValue(this as XenForoAttachment);
  }
}

extension XenForoAttachmentValueCopy<$R, $Out>
    on ObjectCopyWith<$R, XenForoAttachment, $Out> {
  XenForoAttachmentCopyWith<$R, XenForoAttachment, $Out>
      get $asXenForoAttachment => $base
          .as((v, t, t2) => _XenForoAttachmentCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class XenForoAttachmentCopyWith<$R, $In extends XenForoAttachment,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {int? attachmentId,
      String? filename,
      int? fileSize,
      int? height,
      int? width,
      String? thumbnailUrl,
      String? directUrl,
      bool? isVideo,
      bool? isAudio,
      String? contentType,
      int? contentId,
      int? attachDate,
      int? viewCount});
  XenForoAttachmentCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _XenForoAttachmentCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, XenForoAttachment, $Out>
    implements XenForoAttachmentCopyWith<$R, XenForoAttachment, $Out> {
  _XenForoAttachmentCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<XenForoAttachment> $mapper =
      XenForoAttachmentMapper.ensureInitialized();
  @override
  $R call(
          {int? attachmentId,
          String? filename,
          int? fileSize,
          Object? height = $none,
          Object? width = $none,
          Object? thumbnailUrl = $none,
          Object? directUrl = $none,
          Object? isVideo = $none,
          Object? isAudio = $none,
          Object? contentType = $none,
          Object? contentId = $none,
          Object? attachDate = $none,
          Object? viewCount = $none}) =>
      $apply(FieldCopyWithData({
        if (attachmentId != null) #attachmentId: attachmentId,
        if (filename != null) #filename: filename,
        if (fileSize != null) #fileSize: fileSize,
        if (height != $none) #height: height,
        if (width != $none) #width: width,
        if (thumbnailUrl != $none) #thumbnailUrl: thumbnailUrl,
        if (directUrl != $none) #directUrl: directUrl,
        if (isVideo != $none) #isVideo: isVideo,
        if (isAudio != $none) #isAudio: isAudio,
        if (contentType != $none) #contentType: contentType,
        if (contentId != $none) #contentId: contentId,
        if (attachDate != $none) #attachDate: attachDate,
        if (viewCount != $none) #viewCount: viewCount
      }));
  @override
  XenForoAttachment $make(CopyWithData data) => XenForoAttachment(
      attachmentId: data.get(#attachmentId, or: $value.attachmentId),
      filename: data.get(#filename, or: $value.filename),
      fileSize: data.get(#fileSize, or: $value.fileSize),
      height: data.get(#height, or: $value.height),
      width: data.get(#width, or: $value.width),
      thumbnailUrl: data.get(#thumbnailUrl, or: $value.thumbnailUrl),
      directUrl: data.get(#directUrl, or: $value.directUrl),
      isVideo: data.get(#isVideo, or: $value.isVideo),
      isAudio: data.get(#isAudio, or: $value.isAudio),
      contentType: data.get(#contentType, or: $value.contentType),
      contentId: data.get(#contentId, or: $value.contentId),
      attachDate: data.get(#attachDate, or: $value.attachDate),
      viewCount: data.get(#viewCount, or: $value.viewCount));

  @override
  XenForoAttachmentCopyWith<$R2, XenForoAttachment, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _XenForoAttachmentCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
