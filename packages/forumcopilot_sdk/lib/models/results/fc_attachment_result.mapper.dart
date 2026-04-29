// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fc_attachment_result.dart';

class FCAttachmentUploadResultMapper
    extends ClassMapperBase<FCAttachmentUploadResult> {
  FCAttachmentUploadResultMapper._();

  static FCAttachmentUploadResultMapper? _instance;
  static FCAttachmentUploadResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = FCAttachmentUploadResultMapper._(),
      );
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCAttachmentUploadResult';

  static bool _$result(FCAttachmentUploadResult v) => v.result;
  static const Field<FCAttachmentUploadResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCAttachmentUploadResult v) => v.resultText;
  static const Field<FCAttachmentUploadResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static String? _$attachmentId(FCAttachmentUploadResult v) => v.attachmentId;
  static const Field<FCAttachmentUploadResult, String> _f$attachmentId = Field(
    'attachmentId',
    _$attachmentId,
    opt: true,
  );
  static String? _$fileName(FCAttachmentUploadResult v) => v.fileName;
  static const Field<FCAttachmentUploadResult, String> _f$fileName = Field(
    'fileName',
    _$fileName,
    opt: true,
  );
  static String? _$groupId(FCAttachmentUploadResult v) => v.groupId;
  static const Field<FCAttachmentUploadResult, String> _f$groupId = Field(
    'groupId',
    _$groupId,
    opt: true,
  );
  static int? _$fileSize(FCAttachmentUploadResult v) => v.fileSize;
  static const Field<FCAttachmentUploadResult, int> _f$fileSize = Field(
    'fileSize',
    _$fileSize,
    opt: true,
  );

  @override
  final MappableFields<FCAttachmentUploadResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #attachmentId: _f$attachmentId,
    #fileName: _f$fileName,
    #groupId: _f$groupId,
    #fileSize: _f$fileSize,
  };

  static FCAttachmentUploadResult _instantiate(DecodingData data) {
    return FCAttachmentUploadResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      attachmentId: data.dec(_f$attachmentId),
      fileName: data.dec(_f$fileName),
      groupId: data.dec(_f$groupId),
      fileSize: data.dec(_f$fileSize),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCAttachmentUploadResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCAttachmentUploadResult>(map);
  }

  static FCAttachmentUploadResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCAttachmentUploadResult>(json);
  }
}

mixin FCAttachmentUploadResultMappable {
  String toJson() {
    return FCAttachmentUploadResultMapper.ensureInitialized()
        .encodeJson<FCAttachmentUploadResult>(this as FCAttachmentUploadResult);
  }

  Map<String, dynamic> toMap() {
    return FCAttachmentUploadResultMapper.ensureInitialized()
        .encodeMap<FCAttachmentUploadResult>(this as FCAttachmentUploadResult);
  }

  FCAttachmentUploadResultCopyWith<
    FCAttachmentUploadResult,
    FCAttachmentUploadResult,
    FCAttachmentUploadResult
  >
  get copyWith =>
      _FCAttachmentUploadResultCopyWithImpl<
        FCAttachmentUploadResult,
        FCAttachmentUploadResult
      >(this as FCAttachmentUploadResult, $identity, $identity);
  @override
  String toString() {
    return FCAttachmentUploadResultMapper.ensureInitialized().stringifyValue(
      this as FCAttachmentUploadResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCAttachmentUploadResultMapper.ensureInitialized().equalsValue(
      this as FCAttachmentUploadResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCAttachmentUploadResultMapper.ensureInitialized().hashValue(
      this as FCAttachmentUploadResult,
    );
  }
}

extension FCAttachmentUploadResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCAttachmentUploadResult, $Out> {
  FCAttachmentUploadResultCopyWith<$R, FCAttachmentUploadResult, $Out>
  get $asFCAttachmentUploadResult => $base.as(
    (v, t, t2) => _FCAttachmentUploadResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCAttachmentUploadResultCopyWith<
  $R,
  $In extends FCAttachmentUploadResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({
    bool? result,
    String? resultText,
    String? attachmentId,
    String? fileName,
    String? groupId,
    int? fileSize,
  });
  FCAttachmentUploadResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCAttachmentUploadResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCAttachmentUploadResult, $Out>
    implements
        FCAttachmentUploadResultCopyWith<$R, FCAttachmentUploadResult, $Out> {
  _FCAttachmentUploadResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCAttachmentUploadResult> $mapper =
      FCAttachmentUploadResultMapper.ensureInitialized();
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
    Object? attachmentId = $none,
    Object? fileName = $none,
    Object? groupId = $none,
    Object? fileSize = $none,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (attachmentId != $none) #attachmentId: attachmentId,
      if (fileName != $none) #fileName: fileName,
      if (groupId != $none) #groupId: groupId,
      if (fileSize != $none) #fileSize: fileSize,
    }),
  );
  @override
  FCAttachmentUploadResult $make(CopyWithData data) => FCAttachmentUploadResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    attachmentId: data.get(#attachmentId, or: $value.attachmentId),
    fileName: data.get(#fileName, or: $value.fileName),
    groupId: data.get(#groupId, or: $value.groupId),
    fileSize: data.get(#fileSize, or: $value.fileSize),
  );

  @override
  FCAttachmentUploadResultCopyWith<$R2, FCAttachmentUploadResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCAttachmentUploadResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCAttachmentRemoveResultMapper
    extends ClassMapperBase<FCAttachmentRemoveResult> {
  FCAttachmentRemoveResultMapper._();

  static FCAttachmentRemoveResultMapper? _instance;
  static FCAttachmentRemoveResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = FCAttachmentRemoveResultMapper._(),
      );
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCAttachmentRemoveResult';

  static bool _$result(FCAttachmentRemoveResult v) => v.result;
  static const Field<FCAttachmentRemoveResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCAttachmentRemoveResult v) => v.resultText;
  static const Field<FCAttachmentRemoveResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static String? _$groupId(FCAttachmentRemoveResult v) => v.groupId;
  static const Field<FCAttachmentRemoveResult, String> _f$groupId = Field(
    'groupId',
    _$groupId,
    opt: true,
  );

  @override
  final MappableFields<FCAttachmentRemoveResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #groupId: _f$groupId,
  };

  static FCAttachmentRemoveResult _instantiate(DecodingData data) {
    return FCAttachmentRemoveResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      groupId: data.dec(_f$groupId),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCAttachmentRemoveResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCAttachmentRemoveResult>(map);
  }

  static FCAttachmentRemoveResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCAttachmentRemoveResult>(json);
  }
}

mixin FCAttachmentRemoveResultMappable {
  String toJson() {
    return FCAttachmentRemoveResultMapper.ensureInitialized()
        .encodeJson<FCAttachmentRemoveResult>(this as FCAttachmentRemoveResult);
  }

  Map<String, dynamic> toMap() {
    return FCAttachmentRemoveResultMapper.ensureInitialized()
        .encodeMap<FCAttachmentRemoveResult>(this as FCAttachmentRemoveResult);
  }

  FCAttachmentRemoveResultCopyWith<
    FCAttachmentRemoveResult,
    FCAttachmentRemoveResult,
    FCAttachmentRemoveResult
  >
  get copyWith =>
      _FCAttachmentRemoveResultCopyWithImpl<
        FCAttachmentRemoveResult,
        FCAttachmentRemoveResult
      >(this as FCAttachmentRemoveResult, $identity, $identity);
  @override
  String toString() {
    return FCAttachmentRemoveResultMapper.ensureInitialized().stringifyValue(
      this as FCAttachmentRemoveResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCAttachmentRemoveResultMapper.ensureInitialized().equalsValue(
      this as FCAttachmentRemoveResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCAttachmentRemoveResultMapper.ensureInitialized().hashValue(
      this as FCAttachmentRemoveResult,
    );
  }
}

extension FCAttachmentRemoveResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCAttachmentRemoveResult, $Out> {
  FCAttachmentRemoveResultCopyWith<$R, FCAttachmentRemoveResult, $Out>
  get $asFCAttachmentRemoveResult => $base.as(
    (v, t, t2) => _FCAttachmentRemoveResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCAttachmentRemoveResultCopyWith<
  $R,
  $In extends FCAttachmentRemoveResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText, String? groupId});
  FCAttachmentRemoveResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCAttachmentRemoveResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCAttachmentRemoveResult, $Out>
    implements
        FCAttachmentRemoveResultCopyWith<$R, FCAttachmentRemoveResult, $Out> {
  _FCAttachmentRemoveResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCAttachmentRemoveResult> $mapper =
      FCAttachmentRemoveResultMapper.ensureInitialized();
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
    Object? groupId = $none,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (groupId != $none) #groupId: groupId,
    }),
  );
  @override
  FCAttachmentRemoveResult $make(CopyWithData data) => FCAttachmentRemoveResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    groupId: data.get(#groupId, or: $value.groupId),
  );

  @override
  FCAttachmentRemoveResultCopyWith<$R2, FCAttachmentRemoveResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCAttachmentRemoveResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCTapatalkImageUploadResultMapper
    extends ClassMapperBase<FCTapatalkImageUploadResult> {
  FCTapatalkImageUploadResultMapper._();

  static FCTapatalkImageUploadResultMapper? _instance;
  static FCTapatalkImageUploadResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = FCTapatalkImageUploadResultMapper._(),
      );
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCTapatalkImageUploadResult';

  static bool _$result(FCTapatalkImageUploadResult v) => v.result;
  static const Field<FCTapatalkImageUploadResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCTapatalkImageUploadResult v) => v.resultText;
  static const Field<FCTapatalkImageUploadResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static String? _$imageUrl(FCTapatalkImageUploadResult v) => v.imageUrl;
  static const Field<FCTapatalkImageUploadResult, String> _f$imageUrl = Field(
    'imageUrl',
    _$imageUrl,
    opt: true,
  );
  static String? _$imageId(FCTapatalkImageUploadResult v) => v.imageId;
  static const Field<FCTapatalkImageUploadResult, String> _f$imageId = Field(
    'imageId',
    _$imageId,
    opt: true,
  );
  static String? _$thumbnailUrl(FCTapatalkImageUploadResult v) =>
      v.thumbnailUrl;
  static const Field<FCTapatalkImageUploadResult, String> _f$thumbnailUrl =
      Field('thumbnailUrl', _$thumbnailUrl, opt: true);

  @override
  final MappableFields<FCTapatalkImageUploadResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #imageUrl: _f$imageUrl,
    #imageId: _f$imageId,
    #thumbnailUrl: _f$thumbnailUrl,
  };

  static FCTapatalkImageUploadResult _instantiate(DecodingData data) {
    return FCTapatalkImageUploadResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      imageUrl: data.dec(_f$imageUrl),
      imageId: data.dec(_f$imageId),
      thumbnailUrl: data.dec(_f$thumbnailUrl),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCTapatalkImageUploadResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCTapatalkImageUploadResult>(map);
  }

  static FCTapatalkImageUploadResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCTapatalkImageUploadResult>(json);
  }
}

mixin FCTapatalkImageUploadResultMappable {
  String toJson() {
    return FCTapatalkImageUploadResultMapper.ensureInitialized()
        .encodeJson<FCTapatalkImageUploadResult>(
          this as FCTapatalkImageUploadResult,
        );
  }

  Map<String, dynamic> toMap() {
    return FCTapatalkImageUploadResultMapper.ensureInitialized()
        .encodeMap<FCTapatalkImageUploadResult>(
          this as FCTapatalkImageUploadResult,
        );
  }

  FCTapatalkImageUploadResultCopyWith<
    FCTapatalkImageUploadResult,
    FCTapatalkImageUploadResult,
    FCTapatalkImageUploadResult
  >
  get copyWith =>
      _FCTapatalkImageUploadResultCopyWithImpl<
        FCTapatalkImageUploadResult,
        FCTapatalkImageUploadResult
      >(this as FCTapatalkImageUploadResult, $identity, $identity);
  @override
  String toString() {
    return FCTapatalkImageUploadResultMapper.ensureInitialized().stringifyValue(
      this as FCTapatalkImageUploadResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCTapatalkImageUploadResultMapper.ensureInitialized().equalsValue(
      this as FCTapatalkImageUploadResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCTapatalkImageUploadResultMapper.ensureInitialized().hashValue(
      this as FCTapatalkImageUploadResult,
    );
  }
}

extension FCTapatalkImageUploadResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCTapatalkImageUploadResult, $Out> {
  FCTapatalkImageUploadResultCopyWith<$R, FCTapatalkImageUploadResult, $Out>
  get $asFCTapatalkImageUploadResult => $base.as(
    (v, t, t2) => _FCTapatalkImageUploadResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCTapatalkImageUploadResultCopyWith<
  $R,
  $In extends FCTapatalkImageUploadResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({
    bool? result,
    String? resultText,
    String? imageUrl,
    String? imageId,
    String? thumbnailUrl,
  });
  FCTapatalkImageUploadResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCTapatalkImageUploadResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCTapatalkImageUploadResult, $Out>
    implements
        FCTapatalkImageUploadResultCopyWith<
          $R,
          FCTapatalkImageUploadResult,
          $Out
        > {
  _FCTapatalkImageUploadResultCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<FCTapatalkImageUploadResult> $mapper =
      FCTapatalkImageUploadResultMapper.ensureInitialized();
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
    Object? imageUrl = $none,
    Object? imageId = $none,
    Object? thumbnailUrl = $none,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (imageUrl != $none) #imageUrl: imageUrl,
      if (imageId != $none) #imageId: imageId,
      if (thumbnailUrl != $none) #thumbnailUrl: thumbnailUrl,
    }),
  );
  @override
  FCTapatalkImageUploadResult $make(CopyWithData data) =>
      FCTapatalkImageUploadResult(
        result: data.get(#result, or: $value.result),
        resultText: data.get(#resultText, or: $value.resultText),
        imageUrl: data.get(#imageUrl, or: $value.imageUrl),
        imageId: data.get(#imageId, or: $value.imageId),
        thumbnailUrl: data.get(#thumbnailUrl, or: $value.thumbnailUrl),
      );

  @override
  FCTapatalkImageUploadResultCopyWith<$R2, FCTapatalkImageUploadResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCTapatalkImageUploadResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

