// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fc_private_message_result.dart';

class FCReportPMResultMapper extends ClassMapperBase<FCReportPMResult> {
  FCReportPMResultMapper._();

  static FCReportPMResultMapper? _instance;
  static FCReportPMResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCReportPMResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCReportPMResult';

  static bool _$result(FCReportPMResult v) => v.result;
  static const Field<FCReportPMResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCReportPMResult v) => v.resultText;
  static const Field<FCReportPMResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );

  @override
  final MappableFields<FCReportPMResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
  };

  static FCReportPMResult _instantiate(DecodingData data) {
    return FCReportPMResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCReportPMResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCReportPMResult>(map);
  }

  static FCReportPMResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCReportPMResult>(json);
  }
}

mixin FCReportPMResultMappable {
  String toJson() {
    return FCReportPMResultMapper.ensureInitialized()
        .encodeJson<FCReportPMResult>(this as FCReportPMResult);
  }

  Map<String, dynamic> toMap() {
    return FCReportPMResultMapper.ensureInitialized()
        .encodeMap<FCReportPMResult>(this as FCReportPMResult);
  }

  FCReportPMResultCopyWith<FCReportPMResult, FCReportPMResult, FCReportPMResult>
  get copyWith =>
      _FCReportPMResultCopyWithImpl<FCReportPMResult, FCReportPMResult>(
        this as FCReportPMResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCReportPMResultMapper.ensureInitialized().stringifyValue(
      this as FCReportPMResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCReportPMResultMapper.ensureInitialized().equalsValue(
      this as FCReportPMResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCReportPMResultMapper.ensureInitialized().hashValue(
      this as FCReportPMResult,
    );
  }
}

extension FCReportPMResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCReportPMResult, $Out> {
  FCReportPMResultCopyWith<$R, FCReportPMResult, $Out>
  get $asFCReportPMResult =>
      $base.as((v, t, t2) => _FCReportPMResultCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCReportPMResultCopyWith<$R, $In extends FCReportPMResult, $Out>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText});
  FCReportPMResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCReportPMResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCReportPMResult, $Out>
    implements FCReportPMResultCopyWith<$R, FCReportPMResult, $Out> {
  _FCReportPMResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCReportPMResult> $mapper =
      FCReportPMResultMapper.ensureInitialized();
  @override
  $R call({bool? result, Object? resultText = $none}) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
    }),
  );
  @override
  FCReportPMResult $make(CopyWithData data) => FCReportPMResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
  );

  @override
  FCReportPMResultCopyWith<$R2, FCReportPMResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCReportPMResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCCreateMessageResultMapper
    extends ClassMapperBase<FCCreateMessageResult> {
  FCCreateMessageResultMapper._();

  static FCCreateMessageResultMapper? _instance;
  static FCCreateMessageResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCCreateMessageResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCCreateMessageResult';

  static bool _$result(FCCreateMessageResult v) => v.result;
  static const Field<FCCreateMessageResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCCreateMessageResult v) => v.resultText;
  static const Field<FCCreateMessageResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static String _$msgId(FCCreateMessageResult v) => v.msgId;
  static const Field<FCCreateMessageResult, String> _f$msgId = Field(
    'msgId',
    _$msgId,
  );

  @override
  final MappableFields<FCCreateMessageResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #msgId: _f$msgId,
  };

  static FCCreateMessageResult _instantiate(DecodingData data) {
    return FCCreateMessageResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      msgId: data.dec(_f$msgId),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCCreateMessageResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCCreateMessageResult>(map);
  }

  static FCCreateMessageResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCCreateMessageResult>(json);
  }
}

mixin FCCreateMessageResultMappable {
  String toJson() {
    return FCCreateMessageResultMapper.ensureInitialized()
        .encodeJson<FCCreateMessageResult>(this as FCCreateMessageResult);
  }

  Map<String, dynamic> toMap() {
    return FCCreateMessageResultMapper.ensureInitialized()
        .encodeMap<FCCreateMessageResult>(this as FCCreateMessageResult);
  }

  FCCreateMessageResultCopyWith<
    FCCreateMessageResult,
    FCCreateMessageResult,
    FCCreateMessageResult
  >
  get copyWith =>
      _FCCreateMessageResultCopyWithImpl<
        FCCreateMessageResult,
        FCCreateMessageResult
      >(this as FCCreateMessageResult, $identity, $identity);
  @override
  String toString() {
    return FCCreateMessageResultMapper.ensureInitialized().stringifyValue(
      this as FCCreateMessageResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCCreateMessageResultMapper.ensureInitialized().equalsValue(
      this as FCCreateMessageResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCCreateMessageResultMapper.ensureInitialized().hashValue(
      this as FCCreateMessageResult,
    );
  }
}

extension FCCreateMessageResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCCreateMessageResult, $Out> {
  FCCreateMessageResultCopyWith<$R, FCCreateMessageResult, $Out>
  get $asFCCreateMessageResult => $base.as(
    (v, t, t2) => _FCCreateMessageResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCCreateMessageResultCopyWith<
  $R,
  $In extends FCCreateMessageResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText, String? msgId});
  FCCreateMessageResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCCreateMessageResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCCreateMessageResult, $Out>
    implements FCCreateMessageResultCopyWith<$R, FCCreateMessageResult, $Out> {
  _FCCreateMessageResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCCreateMessageResult> $mapper =
      FCCreateMessageResultMapper.ensureInitialized();
  @override
  $R call({bool? result, Object? resultText = $none, String? msgId}) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (msgId != null) #msgId: msgId,
    }),
  );
  @override
  FCCreateMessageResult $make(CopyWithData data) => FCCreateMessageResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    msgId: data.get(#msgId, or: $value.msgId),
  );

  @override
  FCCreateMessageResultCopyWith<$R2, FCCreateMessageResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCCreateMessageResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCBoxInfoResultMapper extends ClassMapperBase<FCBoxInfoResult> {
  FCBoxInfoResultMapper._();

  static FCBoxInfoResultMapper? _instance;
  static FCBoxInfoResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCBoxInfoResultMapper._());
      FCBaseResultMapper.ensureInitialized();
      FCBoxInfoMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCBoxInfoResult';

  static bool _$result(FCBoxInfoResult v) => v.result;
  static const Field<FCBoxInfoResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCBoxInfoResult v) => v.resultText;
  static const Field<FCBoxInfoResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static int _$messageRoomCount(FCBoxInfoResult v) => v.messageRoomCount;
  static const Field<FCBoxInfoResult, int> _f$messageRoomCount = Field(
    'messageRoomCount',
    _$messageRoomCount,
  );
  static List<FCBoxInfo> _$list(FCBoxInfoResult v) => v.list;
  static const Field<FCBoxInfoResult, List<FCBoxInfo>> _f$list = Field(
    'list',
    _$list,
  );

  @override
  final MappableFields<FCBoxInfoResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #messageRoomCount: _f$messageRoomCount,
    #list: _f$list,
  };

  static FCBoxInfoResult _instantiate(DecodingData data) {
    return FCBoxInfoResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      messageRoomCount: data.dec(_f$messageRoomCount),
      list: data.dec(_f$list),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCBoxInfoResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCBoxInfoResult>(map);
  }

  static FCBoxInfoResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCBoxInfoResult>(json);
  }
}

mixin FCBoxInfoResultMappable {
  String toJson() {
    return FCBoxInfoResultMapper.ensureInitialized()
        .encodeJson<FCBoxInfoResult>(this as FCBoxInfoResult);
  }

  Map<String, dynamic> toMap() {
    return FCBoxInfoResultMapper.ensureInitialized().encodeMap<FCBoxInfoResult>(
      this as FCBoxInfoResult,
    );
  }

  FCBoxInfoResultCopyWith<FCBoxInfoResult, FCBoxInfoResult, FCBoxInfoResult>
  get copyWith =>
      _FCBoxInfoResultCopyWithImpl<FCBoxInfoResult, FCBoxInfoResult>(
        this as FCBoxInfoResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCBoxInfoResultMapper.ensureInitialized().stringifyValue(
      this as FCBoxInfoResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCBoxInfoResultMapper.ensureInitialized().equalsValue(
      this as FCBoxInfoResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCBoxInfoResultMapper.ensureInitialized().hashValue(
      this as FCBoxInfoResult,
    );
  }
}

extension FCBoxInfoResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCBoxInfoResult, $Out> {
  FCBoxInfoResultCopyWith<$R, FCBoxInfoResult, $Out> get $asFCBoxInfoResult =>
      $base.as((v, t, t2) => _FCBoxInfoResultCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCBoxInfoResultCopyWith<$R, $In extends FCBoxInfoResult, $Out>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, FCBoxInfo, FCBoxInfoCopyWith<$R, FCBoxInfo, FCBoxInfo>>
  get list;
  @override
  $R call({
    bool? result,
    String? resultText,
    int? messageRoomCount,
    List<FCBoxInfo>? list,
  });
  FCBoxInfoResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCBoxInfoResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCBoxInfoResult, $Out>
    implements FCBoxInfoResultCopyWith<$R, FCBoxInfoResult, $Out> {
  _FCBoxInfoResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCBoxInfoResult> $mapper =
      FCBoxInfoResultMapper.ensureInitialized();
  @override
  ListCopyWith<$R, FCBoxInfo, FCBoxInfoCopyWith<$R, FCBoxInfo, FCBoxInfo>>
  get list => ListCopyWith(
    $value.list,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(list: v),
  );
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
    int? messageRoomCount,
    List<FCBoxInfo>? list,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (messageRoomCount != null) #messageRoomCount: messageRoomCount,
      if (list != null) #list: list,
    }),
  );
  @override
  FCBoxInfoResult $make(CopyWithData data) => FCBoxInfoResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    messageRoomCount: data.get(#messageRoomCount, or: $value.messageRoomCount),
    list: data.get(#list, or: $value.list),
  );

  @override
  FCBoxInfoResultCopyWith<$R2, FCBoxInfoResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCBoxInfoResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCBoxInfoMapper extends ClassMapperBase<FCBoxInfo> {
  FCBoxInfoMapper._();

  static FCBoxInfoMapper? _instance;
  static FCBoxInfoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCBoxInfoMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FCBoxInfo';

  static String _$boxId(FCBoxInfo v) => v.boxId;
  static const Field<FCBoxInfo, String> _f$boxId = Field('boxId', _$boxId);
  static String _$boxName(FCBoxInfo v) => v.boxName;
  static const Field<FCBoxInfo, String> _f$boxName = Field(
    'boxName',
    _$boxName,
  );
  static String _$boxType(FCBoxInfo v) => v.boxType;
  static const Field<FCBoxInfo, String> _f$boxType = Field(
    'boxType',
    _$boxType,
  );
  static int _$messageCount(FCBoxInfo v) => v.messageCount;
  static const Field<FCBoxInfo, int> _f$messageCount = Field(
    'messageCount',
    _$messageCount,
  );
  static int _$unreadCount(FCBoxInfo v) => v.unreadCount;
  static const Field<FCBoxInfo, int> _f$unreadCount = Field(
    'unreadCount',
    _$unreadCount,
  );

  @override
  final MappableFields<FCBoxInfo> fields = const {
    #boxId: _f$boxId,
    #boxName: _f$boxName,
    #boxType: _f$boxType,
    #messageCount: _f$messageCount,
    #unreadCount: _f$unreadCount,
  };

  static FCBoxInfo _instantiate(DecodingData data) {
    return FCBoxInfo(
      boxId: data.dec(_f$boxId),
      boxName: data.dec(_f$boxName),
      boxType: data.dec(_f$boxType),
      messageCount: data.dec(_f$messageCount),
      unreadCount: data.dec(_f$unreadCount),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCBoxInfo fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCBoxInfo>(map);
  }

  static FCBoxInfo fromJson(String json) {
    return ensureInitialized().decodeJson<FCBoxInfo>(json);
  }
}

mixin FCBoxInfoMappable {
  String toJson() {
    return FCBoxInfoMapper.ensureInitialized().encodeJson<FCBoxInfo>(
      this as FCBoxInfo,
    );
  }

  Map<String, dynamic> toMap() {
    return FCBoxInfoMapper.ensureInitialized().encodeMap<FCBoxInfo>(
      this as FCBoxInfo,
    );
  }

  FCBoxInfoCopyWith<FCBoxInfo, FCBoxInfo, FCBoxInfo> get copyWith =>
      _FCBoxInfoCopyWithImpl<FCBoxInfo, FCBoxInfo>(
        this as FCBoxInfo,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCBoxInfoMapper.ensureInitialized().stringifyValue(
      this as FCBoxInfo,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCBoxInfoMapper.ensureInitialized().equalsValue(
      this as FCBoxInfo,
      other,
    );
  }

  @override
  int get hashCode {
    return FCBoxInfoMapper.ensureInitialized().hashValue(this as FCBoxInfo);
  }
}

extension FCBoxInfoValueCopy<$R, $Out> on ObjectCopyWith<$R, FCBoxInfo, $Out> {
  FCBoxInfoCopyWith<$R, FCBoxInfo, $Out> get $asFCBoxInfo =>
      $base.as((v, t, t2) => _FCBoxInfoCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCBoxInfoCopyWith<$R, $In extends FCBoxInfo, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? boxId,
    String? boxName,
    String? boxType,
    int? messageCount,
    int? unreadCount,
  });
  FCBoxInfoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FCBoxInfoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCBoxInfo, $Out>
    implements FCBoxInfoCopyWith<$R, FCBoxInfo, $Out> {
  _FCBoxInfoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCBoxInfo> $mapper =
      FCBoxInfoMapper.ensureInitialized();
  @override
  $R call({
    String? boxId,
    String? boxName,
    String? boxType,
    int? messageCount,
    int? unreadCount,
  }) => $apply(
    FieldCopyWithData({
      if (boxId != null) #boxId: boxId,
      if (boxName != null) #boxName: boxName,
      if (boxType != null) #boxType: boxType,
      if (messageCount != null) #messageCount: messageCount,
      if (unreadCount != null) #unreadCount: unreadCount,
    }),
  );
  @override
  FCBoxInfo $make(CopyWithData data) => FCBoxInfo(
    boxId: data.get(#boxId, or: $value.boxId),
    boxName: data.get(#boxName, or: $value.boxName),
    boxType: data.get(#boxType, or: $value.boxType),
    messageCount: data.get(#messageCount, or: $value.messageCount),
    unreadCount: data.get(#unreadCount, or: $value.unreadCount),
  );

  @override
  FCBoxInfoCopyWith<$R2, FCBoxInfo, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCBoxInfoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCBoxResultMapper extends ClassMapperBase<FCBoxResult> {
  FCBoxResultMapper._();

  static FCBoxResultMapper? _instance;
  static FCBoxResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCBoxResultMapper._());
      FCBaseResultMapper.ensureInitialized();
      FCPrivateMessageMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCBoxResult';

  static bool _$result(FCBoxResult v) => v.result;
  static const Field<FCBoxResult, bool> _f$result = Field('result', _$result);
  static String? _$resultText(FCBoxResult v) => v.resultText;
  static const Field<FCBoxResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static int _$totalMessageNum(FCBoxResult v) => v.totalMessageNum;
  static const Field<FCBoxResult, int> _f$totalMessageNum = Field(
    'totalMessageNum',
    _$totalMessageNum,
  );
  static List<FCPrivateMessage> _$list(FCBoxResult v) => v.list;
  static const Field<FCBoxResult, List<FCPrivateMessage>> _f$list = Field(
    'list',
    _$list,
  );

  @override
  final MappableFields<FCBoxResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #totalMessageNum: _f$totalMessageNum,
    #list: _f$list,
  };

  static FCBoxResult _instantiate(DecodingData data) {
    return FCBoxResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      totalMessageNum: data.dec(_f$totalMessageNum),
      list: data.dec(_f$list),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCBoxResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCBoxResult>(map);
  }

  static FCBoxResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCBoxResult>(json);
  }
}

mixin FCBoxResultMappable {
  String toJson() {
    return FCBoxResultMapper.ensureInitialized().encodeJson<FCBoxResult>(
      this as FCBoxResult,
    );
  }

  Map<String, dynamic> toMap() {
    return FCBoxResultMapper.ensureInitialized().encodeMap<FCBoxResult>(
      this as FCBoxResult,
    );
  }

  FCBoxResultCopyWith<FCBoxResult, FCBoxResult, FCBoxResult> get copyWith =>
      _FCBoxResultCopyWithImpl<FCBoxResult, FCBoxResult>(
        this as FCBoxResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCBoxResultMapper.ensureInitialized().stringifyValue(
      this as FCBoxResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCBoxResultMapper.ensureInitialized().equalsValue(
      this as FCBoxResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCBoxResultMapper.ensureInitialized().hashValue(this as FCBoxResult);
  }
}

extension FCBoxResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCBoxResult, $Out> {
  FCBoxResultCopyWith<$R, FCBoxResult, $Out> get $asFCBoxResult =>
      $base.as((v, t, t2) => _FCBoxResultCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCBoxResultCopyWith<$R, $In extends FCBoxResult, $Out>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    FCPrivateMessage,
    FCPrivateMessageCopyWith<$R, FCPrivateMessage, FCPrivateMessage>
  >
  get list;
  @override
  $R call({
    bool? result,
    String? resultText,
    int? totalMessageNum,
    List<FCPrivateMessage>? list,
  });
  FCBoxResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FCBoxResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCBoxResult, $Out>
    implements FCBoxResultCopyWith<$R, FCBoxResult, $Out> {
  _FCBoxResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCBoxResult> $mapper =
      FCBoxResultMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    FCPrivateMessage,
    FCPrivateMessageCopyWith<$R, FCPrivateMessage, FCPrivateMessage>
  >
  get list => ListCopyWith(
    $value.list,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(list: v),
  );
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
    int? totalMessageNum,
    List<FCPrivateMessage>? list,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (totalMessageNum != null) #totalMessageNum: totalMessageNum,
      if (list != null) #list: list,
    }),
  );
  @override
  FCBoxResult $make(CopyWithData data) => FCBoxResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    totalMessageNum: data.get(#totalMessageNum, or: $value.totalMessageNum),
    list: data.get(#list, or: $value.list),
  );

  @override
  FCBoxResultCopyWith<$R2, FCBoxResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCBoxResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCPrivateMessageMapper extends ClassMapperBase<FCPrivateMessage> {
  FCPrivateMessageMapper._();

  static FCPrivateMessageMapper? _instance;
  static FCPrivateMessageMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCPrivateMessageMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FCPrivateMessage';

  static String _$msgId(FCPrivateMessage v) => v.msgId;
  static const Field<FCPrivateMessage, String> _f$msgId = Field(
    'msgId',
    _$msgId,
  );
  static String _$subject(FCPrivateMessage v) => v.subject;
  static const Field<FCPrivateMessage, String> _f$subject = Field(
    'subject',
    _$subject,
  );
  static String? _$msgSubject(FCPrivateMessage v) => v.msgSubject;
  static const Field<FCPrivateMessage, String> _f$msgSubject = Field(
    'msgSubject',
    _$msgSubject,
    opt: true,
  );
  static String? _$msgFrom(FCPrivateMessage v) => v.msgFrom;
  static const Field<FCPrivateMessage, String> _f$msgFrom = Field(
    'msgFrom',
    _$msgFrom,
    opt: true,
  );
  static List<String>? _$msgTo(FCPrivateMessage v) => v.msgTo;
  static const Field<FCPrivateMessage, List<String>> _f$msgTo = Field(
    'msgTo',
    _$msgTo,
    opt: true,
  );
  static String _$authorId(FCPrivateMessage v) => v.authorId;
  static const Field<FCPrivateMessage, String> _f$authorId = Field(
    'authorId',
    _$authorId,
  );
  static String _$authorName(FCPrivateMessage v) => v.authorName;
  static const Field<FCPrivateMessage, String> _f$authorName = Field(
    'authorName',
    _$authorName,
  );
  static String? _$iconUrl(FCPrivateMessage v) => v.iconUrl;
  static const Field<FCPrivateMessage, String> _f$iconUrl = Field(
    'iconUrl',
    _$iconUrl,
    opt: true,
  );
  static String _$textBody(FCPrivateMessage v) => v.textBody;
  static const Field<FCPrivateMessage, String> _f$textBody = Field(
    'textBody',
    _$textBody,
  );
  static String _$msgTime(FCPrivateMessage v) => v.msgTime;
  static const Field<FCPrivateMessage, String> _f$msgTime = Field(
    'msgTime',
    _$msgTime,
  );
  static String? _$sentDate(FCPrivateMessage v) => v.sentDate;
  static const Field<FCPrivateMessage, String> _f$sentDate = Field(
    'sentDate',
    _$sentDate,
    opt: true,
  );
  static String? _$timestamp(FCPrivateMessage v) => v.timestamp;
  static const Field<FCPrivateMessage, String> _f$timestamp = Field(
    'timestamp',
    _$timestamp,
    opt: true,
  );
  static int _$msgState(FCPrivateMessage v) => v.msgState;
  static const Field<FCPrivateMessage, int> _f$msgState = Field(
    'msgState',
    _$msgState,
  );
  static bool _$isUnread(FCPrivateMessage v) => v.isUnread;
  static const Field<FCPrivateMessage, bool> _f$isUnread = Field(
    'isUnread',
    _$isUnread,
  );
  static bool? _$isFromCurrentUser(FCPrivateMessage v) => v.isFromCurrentUser;
  static const Field<FCPrivateMessage, bool> _f$isFromCurrentUser = Field(
    'isFromCurrentUser',
    _$isFromCurrentUser,
    opt: true,
  );

  @override
  final MappableFields<FCPrivateMessage> fields = const {
    #msgId: _f$msgId,
    #subject: _f$subject,
    #msgSubject: _f$msgSubject,
    #msgFrom: _f$msgFrom,
    #msgTo: _f$msgTo,
    #authorId: _f$authorId,
    #authorName: _f$authorName,
    #iconUrl: _f$iconUrl,
    #textBody: _f$textBody,
    #msgTime: _f$msgTime,
    #sentDate: _f$sentDate,
    #timestamp: _f$timestamp,
    #msgState: _f$msgState,
    #isUnread: _f$isUnread,
    #isFromCurrentUser: _f$isFromCurrentUser,
  };

  static FCPrivateMessage _instantiate(DecodingData data) {
    return FCPrivateMessage(
      msgId: data.dec(_f$msgId),
      subject: data.dec(_f$subject),
      msgSubject: data.dec(_f$msgSubject),
      msgFrom: data.dec(_f$msgFrom),
      msgTo: data.dec(_f$msgTo),
      authorId: data.dec(_f$authorId),
      authorName: data.dec(_f$authorName),
      iconUrl: data.dec(_f$iconUrl),
      textBody: data.dec(_f$textBody),
      msgTime: data.dec(_f$msgTime),
      sentDate: data.dec(_f$sentDate),
      timestamp: data.dec(_f$timestamp),
      msgState: data.dec(_f$msgState),
      isUnread: data.dec(_f$isUnread),
      isFromCurrentUser: data.dec(_f$isFromCurrentUser),
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
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>? get msgTo;
  $R call({
    String? msgId,
    String? subject,
    String? msgSubject,
    String? msgFrom,
    List<String>? msgTo,
    String? authorId,
    String? authorName,
    String? iconUrl,
    String? textBody,
    String? msgTime,
    String? sentDate,
    String? timestamp,
    int? msgState,
    bool? isUnread,
    bool? isFromCurrentUser,
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
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>? get msgTo =>
      $value.msgTo != null
      ? ListCopyWith(
          $value.msgTo!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(msgTo: v),
        )
      : null;
  @override
  $R call({
    String? msgId,
    String? subject,
    Object? msgSubject = $none,
    Object? msgFrom = $none,
    Object? msgTo = $none,
    String? authorId,
    String? authorName,
    Object? iconUrl = $none,
    String? textBody,
    String? msgTime,
    Object? sentDate = $none,
    Object? timestamp = $none,
    int? msgState,
    bool? isUnread,
    Object? isFromCurrentUser = $none,
  }) => $apply(
    FieldCopyWithData({
      if (msgId != null) #msgId: msgId,
      if (subject != null) #subject: subject,
      if (msgSubject != $none) #msgSubject: msgSubject,
      if (msgFrom != $none) #msgFrom: msgFrom,
      if (msgTo != $none) #msgTo: msgTo,
      if (authorId != null) #authorId: authorId,
      if (authorName != null) #authorName: authorName,
      if (iconUrl != $none) #iconUrl: iconUrl,
      if (textBody != null) #textBody: textBody,
      if (msgTime != null) #msgTime: msgTime,
      if (sentDate != $none) #sentDate: sentDate,
      if (timestamp != $none) #timestamp: timestamp,
      if (msgState != null) #msgState: msgState,
      if (isUnread != null) #isUnread: isUnread,
      if (isFromCurrentUser != $none) #isFromCurrentUser: isFromCurrentUser,
    }),
  );
  @override
  FCPrivateMessage $make(CopyWithData data) => FCPrivateMessage(
    msgId: data.get(#msgId, or: $value.msgId),
    subject: data.get(#subject, or: $value.subject),
    msgSubject: data.get(#msgSubject, or: $value.msgSubject),
    msgFrom: data.get(#msgFrom, or: $value.msgFrom),
    msgTo: data.get(#msgTo, or: $value.msgTo),
    authorId: data.get(#authorId, or: $value.authorId),
    authorName: data.get(#authorName, or: $value.authorName),
    iconUrl: data.get(#iconUrl, or: $value.iconUrl),
    textBody: data.get(#textBody, or: $value.textBody),
    msgTime: data.get(#msgTime, or: $value.msgTime),
    sentDate: data.get(#sentDate, or: $value.sentDate),
    timestamp: data.get(#timestamp, or: $value.timestamp),
    msgState: data.get(#msgState, or: $value.msgState),
    isUnread: data.get(#isUnread, or: $value.isUnread),
    isFromCurrentUser: data.get(
      #isFromCurrentUser,
      or: $value.isFromCurrentUser,
    ),
  );

  @override
  FCPrivateMessageCopyWith<$R2, FCPrivateMessage, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCPrivateMessageCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCMessageResultMapper extends ClassMapperBase<FCMessageResult> {
  FCMessageResultMapper._();

  static FCMessageResultMapper? _instance;
  static FCMessageResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCMessageResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCMessageResult';

  static bool _$result(FCMessageResult v) => v.result;
  static const Field<FCMessageResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCMessageResult v) => v.resultText;
  static const Field<FCMessageResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static String _$msgId(FCMessageResult v) => v.msgId;
  static const Field<FCMessageResult, String> _f$msgId = Field(
    'msgId',
    _$msgId,
  );
  static String _$subject(FCMessageResult v) => v.subject;
  static const Field<FCMessageResult, String> _f$subject = Field(
    'subject',
    _$subject,
  );
  static String _$authorId(FCMessageResult v) => v.authorId;
  static const Field<FCMessageResult, String> _f$authorId = Field(
    'authorId',
    _$authorId,
  );
  static String _$authorName(FCMessageResult v) => v.authorName;
  static const Field<FCMessageResult, String> _f$authorName = Field(
    'authorName',
    _$authorName,
  );
  static String? _$msgFrom(FCMessageResult v) => v.msgFrom;
  static const Field<FCMessageResult, String> _f$msgFrom = Field(
    'msgFrom',
    _$msgFrom,
    opt: true,
  );
  static String? _$msgTo(FCMessageResult v) => v.msgTo;
  static const Field<FCMessageResult, String> _f$msgTo = Field(
    'msgTo',
    _$msgTo,
    opt: true,
  );
  static String? _$iconUrl(FCMessageResult v) => v.iconUrl;
  static const Field<FCMessageResult, String> _f$iconUrl = Field(
    'iconUrl',
    _$iconUrl,
    opt: true,
  );
  static String _$textBody(FCMessageResult v) => v.textBody;
  static const Field<FCMessageResult, String> _f$textBody = Field(
    'textBody',
    _$textBody,
  );
  static String _$msgTime(FCMessageResult v) => v.msgTime;
  static const Field<FCMessageResult, String> _f$msgTime = Field(
    'msgTime',
    _$msgTime,
  );
  static bool _$isUnread(FCMessageResult v) => v.isUnread;
  static const Field<FCMessageResult, bool> _f$isUnread = Field(
    'isUnread',
    _$isUnread,
  );
  static bool? _$canReply(FCMessageResult v) => v.canReply;
  static const Field<FCMessageResult, bool> _f$canReply = Field(
    'canReply',
    _$canReply,
    opt: true,
  );
  static bool? _$canForward(FCMessageResult v) => v.canForward;
  static const Field<FCMessageResult, bool> _f$canForward = Field(
    'canForward',
    _$canForward,
    opt: true,
  );
  static bool? _$canReport(FCMessageResult v) => v.canReport;
  static const Field<FCMessageResult, bool> _f$canReport = Field(
    'canReport',
    _$canReport,
    opt: true,
  );

  @override
  final MappableFields<FCMessageResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #msgId: _f$msgId,
    #subject: _f$subject,
    #authorId: _f$authorId,
    #authorName: _f$authorName,
    #msgFrom: _f$msgFrom,
    #msgTo: _f$msgTo,
    #iconUrl: _f$iconUrl,
    #textBody: _f$textBody,
    #msgTime: _f$msgTime,
    #isUnread: _f$isUnread,
    #canReply: _f$canReply,
    #canForward: _f$canForward,
    #canReport: _f$canReport,
  };

  static FCMessageResult _instantiate(DecodingData data) {
    return FCMessageResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      msgId: data.dec(_f$msgId),
      subject: data.dec(_f$subject),
      authorId: data.dec(_f$authorId),
      authorName: data.dec(_f$authorName),
      msgFrom: data.dec(_f$msgFrom),
      msgTo: data.dec(_f$msgTo),
      iconUrl: data.dec(_f$iconUrl),
      textBody: data.dec(_f$textBody),
      msgTime: data.dec(_f$msgTime),
      isUnread: data.dec(_f$isUnread),
      canReply: data.dec(_f$canReply),
      canForward: data.dec(_f$canForward),
      canReport: data.dec(_f$canReport),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCMessageResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCMessageResult>(map);
  }

  static FCMessageResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCMessageResult>(json);
  }
}

mixin FCMessageResultMappable {
  String toJson() {
    return FCMessageResultMapper.ensureInitialized()
        .encodeJson<FCMessageResult>(this as FCMessageResult);
  }

  Map<String, dynamic> toMap() {
    return FCMessageResultMapper.ensureInitialized().encodeMap<FCMessageResult>(
      this as FCMessageResult,
    );
  }

  FCMessageResultCopyWith<FCMessageResult, FCMessageResult, FCMessageResult>
  get copyWith =>
      _FCMessageResultCopyWithImpl<FCMessageResult, FCMessageResult>(
        this as FCMessageResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCMessageResultMapper.ensureInitialized().stringifyValue(
      this as FCMessageResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCMessageResultMapper.ensureInitialized().equalsValue(
      this as FCMessageResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCMessageResultMapper.ensureInitialized().hashValue(
      this as FCMessageResult,
    );
  }
}

extension FCMessageResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCMessageResult, $Out> {
  FCMessageResultCopyWith<$R, FCMessageResult, $Out> get $asFCMessageResult =>
      $base.as((v, t, t2) => _FCMessageResultCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCMessageResultCopyWith<$R, $In extends FCMessageResult, $Out>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({
    bool? result,
    String? resultText,
    String? msgId,
    String? subject,
    String? authorId,
    String? authorName,
    String? msgFrom,
    String? msgTo,
    String? iconUrl,
    String? textBody,
    String? msgTime,
    bool? isUnread,
    bool? canReply,
    bool? canForward,
    bool? canReport,
  });
  FCMessageResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCMessageResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCMessageResult, $Out>
    implements FCMessageResultCopyWith<$R, FCMessageResult, $Out> {
  _FCMessageResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCMessageResult> $mapper =
      FCMessageResultMapper.ensureInitialized();
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
    String? msgId,
    String? subject,
    String? authorId,
    String? authorName,
    Object? msgFrom = $none,
    Object? msgTo = $none,
    Object? iconUrl = $none,
    String? textBody,
    String? msgTime,
    bool? isUnread,
    Object? canReply = $none,
    Object? canForward = $none,
    Object? canReport = $none,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (msgId != null) #msgId: msgId,
      if (subject != null) #subject: subject,
      if (authorId != null) #authorId: authorId,
      if (authorName != null) #authorName: authorName,
      if (msgFrom != $none) #msgFrom: msgFrom,
      if (msgTo != $none) #msgTo: msgTo,
      if (iconUrl != $none) #iconUrl: iconUrl,
      if (textBody != null) #textBody: textBody,
      if (msgTime != null) #msgTime: msgTime,
      if (isUnread != null) #isUnread: isUnread,
      if (canReply != $none) #canReply: canReply,
      if (canForward != $none) #canForward: canForward,
      if (canReport != $none) #canReport: canReport,
    }),
  );
  @override
  FCMessageResult $make(CopyWithData data) => FCMessageResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    msgId: data.get(#msgId, or: $value.msgId),
    subject: data.get(#subject, or: $value.subject),
    authorId: data.get(#authorId, or: $value.authorId),
    authorName: data.get(#authorName, or: $value.authorName),
    msgFrom: data.get(#msgFrom, or: $value.msgFrom),
    msgTo: data.get(#msgTo, or: $value.msgTo),
    iconUrl: data.get(#iconUrl, or: $value.iconUrl),
    textBody: data.get(#textBody, or: $value.textBody),
    msgTime: data.get(#msgTime, or: $value.msgTime),
    isUnread: data.get(#isUnread, or: $value.isUnread),
    canReply: data.get(#canReply, or: $value.canReply),
    canForward: data.get(#canForward, or: $value.canForward),
    canReport: data.get(#canReport, or: $value.canReport),
  );

  @override
  FCMessageResultCopyWith<$R2, FCMessageResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCMessageResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCQuotePMResultMapper extends ClassMapperBase<FCQuotePMResult> {
  FCQuotePMResultMapper._();

  static FCQuotePMResultMapper? _instance;
  static FCQuotePMResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCQuotePMResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCQuotePMResult';

  static bool _$result(FCQuotePMResult v) => v.result;
  static const Field<FCQuotePMResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCQuotePMResult v) => v.resultText;
  static const Field<FCQuotePMResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static String? _$quoteText(FCQuotePMResult v) => v.quoteText;
  static const Field<FCQuotePMResult, String> _f$quoteText = Field(
    'quoteText',
    _$quoteText,
    opt: true,
  );
  static String? _$authorName(FCQuotePMResult v) => v.authorName;
  static const Field<FCQuotePMResult, String> _f$authorName = Field(
    'authorName',
    _$authorName,
    opt: true,
  );

  @override
  final MappableFields<FCQuotePMResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #quoteText: _f$quoteText,
    #authorName: _f$authorName,
  };

  static FCQuotePMResult _instantiate(DecodingData data) {
    return FCQuotePMResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      quoteText: data.dec(_f$quoteText),
      authorName: data.dec(_f$authorName),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCQuotePMResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCQuotePMResult>(map);
  }

  static FCQuotePMResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCQuotePMResult>(json);
  }
}

mixin FCQuotePMResultMappable {
  String toJson() {
    return FCQuotePMResultMapper.ensureInitialized()
        .encodeJson<FCQuotePMResult>(this as FCQuotePMResult);
  }

  Map<String, dynamic> toMap() {
    return FCQuotePMResultMapper.ensureInitialized().encodeMap<FCQuotePMResult>(
      this as FCQuotePMResult,
    );
  }

  FCQuotePMResultCopyWith<FCQuotePMResult, FCQuotePMResult, FCQuotePMResult>
  get copyWith =>
      _FCQuotePMResultCopyWithImpl<FCQuotePMResult, FCQuotePMResult>(
        this as FCQuotePMResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCQuotePMResultMapper.ensureInitialized().stringifyValue(
      this as FCQuotePMResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCQuotePMResultMapper.ensureInitialized().equalsValue(
      this as FCQuotePMResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCQuotePMResultMapper.ensureInitialized().hashValue(
      this as FCQuotePMResult,
    );
  }
}

extension FCQuotePMResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCQuotePMResult, $Out> {
  FCQuotePMResultCopyWith<$R, FCQuotePMResult, $Out> get $asFCQuotePMResult =>
      $base.as((v, t, t2) => _FCQuotePMResultCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCQuotePMResultCopyWith<$R, $In extends FCQuotePMResult, $Out>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({
    bool? result,
    String? resultText,
    String? quoteText,
    String? authorName,
  });
  FCQuotePMResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCQuotePMResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCQuotePMResult, $Out>
    implements FCQuotePMResultCopyWith<$R, FCQuotePMResult, $Out> {
  _FCQuotePMResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCQuotePMResult> $mapper =
      FCQuotePMResultMapper.ensureInitialized();
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
    Object? quoteText = $none,
    Object? authorName = $none,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (quoteText != $none) #quoteText: quoteText,
      if (authorName != $none) #authorName: authorName,
    }),
  );
  @override
  FCQuotePMResult $make(CopyWithData data) => FCQuotePMResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    quoteText: data.get(#quoteText, or: $value.quoteText),
    authorName: data.get(#authorName, or: $value.authorName),
  );

  @override
  FCQuotePMResultCopyWith<$R2, FCQuotePMResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCQuotePMResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCDeleteMessageResultMapper
    extends ClassMapperBase<FCDeleteMessageResult> {
  FCDeleteMessageResultMapper._();

  static FCDeleteMessageResultMapper? _instance;
  static FCDeleteMessageResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCDeleteMessageResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCDeleteMessageResult';

  static bool _$result(FCDeleteMessageResult v) => v.result;
  static const Field<FCDeleteMessageResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCDeleteMessageResult v) => v.resultText;
  static const Field<FCDeleteMessageResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );

  @override
  final MappableFields<FCDeleteMessageResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
  };

  static FCDeleteMessageResult _instantiate(DecodingData data) {
    return FCDeleteMessageResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCDeleteMessageResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCDeleteMessageResult>(map);
  }

  static FCDeleteMessageResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCDeleteMessageResult>(json);
  }
}

mixin FCDeleteMessageResultMappable {
  String toJson() {
    return FCDeleteMessageResultMapper.ensureInitialized()
        .encodeJson<FCDeleteMessageResult>(this as FCDeleteMessageResult);
  }

  Map<String, dynamic> toMap() {
    return FCDeleteMessageResultMapper.ensureInitialized()
        .encodeMap<FCDeleteMessageResult>(this as FCDeleteMessageResult);
  }

  FCDeleteMessageResultCopyWith<
    FCDeleteMessageResult,
    FCDeleteMessageResult,
    FCDeleteMessageResult
  >
  get copyWith =>
      _FCDeleteMessageResultCopyWithImpl<
        FCDeleteMessageResult,
        FCDeleteMessageResult
      >(this as FCDeleteMessageResult, $identity, $identity);
  @override
  String toString() {
    return FCDeleteMessageResultMapper.ensureInitialized().stringifyValue(
      this as FCDeleteMessageResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCDeleteMessageResultMapper.ensureInitialized().equalsValue(
      this as FCDeleteMessageResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCDeleteMessageResultMapper.ensureInitialized().hashValue(
      this as FCDeleteMessageResult,
    );
  }
}

extension FCDeleteMessageResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCDeleteMessageResult, $Out> {
  FCDeleteMessageResultCopyWith<$R, FCDeleteMessageResult, $Out>
  get $asFCDeleteMessageResult => $base.as(
    (v, t, t2) => _FCDeleteMessageResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCDeleteMessageResultCopyWith<
  $R,
  $In extends FCDeleteMessageResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText});
  FCDeleteMessageResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCDeleteMessageResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCDeleteMessageResult, $Out>
    implements FCDeleteMessageResultCopyWith<$R, FCDeleteMessageResult, $Out> {
  _FCDeleteMessageResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCDeleteMessageResult> $mapper =
      FCDeleteMessageResultMapper.ensureInitialized();
  @override
  $R call({bool? result, Object? resultText = $none}) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
    }),
  );
  @override
  FCDeleteMessageResult $make(CopyWithData data) => FCDeleteMessageResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
  );

  @override
  FCDeleteMessageResultCopyWith<$R2, FCDeleteMessageResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCDeleteMessageResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCMarkPMUnreadResultMapper extends ClassMapperBase<FCMarkPMUnreadResult> {
  FCMarkPMUnreadResultMapper._();

  static FCMarkPMUnreadResultMapper? _instance;
  static FCMarkPMUnreadResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCMarkPMUnreadResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCMarkPMUnreadResult';

  static bool _$result(FCMarkPMUnreadResult v) => v.result;
  static const Field<FCMarkPMUnreadResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCMarkPMUnreadResult v) => v.resultText;
  static const Field<FCMarkPMUnreadResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );

  @override
  final MappableFields<FCMarkPMUnreadResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
  };

  static FCMarkPMUnreadResult _instantiate(DecodingData data) {
    return FCMarkPMUnreadResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCMarkPMUnreadResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCMarkPMUnreadResult>(map);
  }

  static FCMarkPMUnreadResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCMarkPMUnreadResult>(json);
  }
}

mixin FCMarkPMUnreadResultMappable {
  String toJson() {
    return FCMarkPMUnreadResultMapper.ensureInitialized()
        .encodeJson<FCMarkPMUnreadResult>(this as FCMarkPMUnreadResult);
  }

  Map<String, dynamic> toMap() {
    return FCMarkPMUnreadResultMapper.ensureInitialized()
        .encodeMap<FCMarkPMUnreadResult>(this as FCMarkPMUnreadResult);
  }

  FCMarkPMUnreadResultCopyWith<
    FCMarkPMUnreadResult,
    FCMarkPMUnreadResult,
    FCMarkPMUnreadResult
  >
  get copyWith =>
      _FCMarkPMUnreadResultCopyWithImpl<
        FCMarkPMUnreadResult,
        FCMarkPMUnreadResult
      >(this as FCMarkPMUnreadResult, $identity, $identity);
  @override
  String toString() {
    return FCMarkPMUnreadResultMapper.ensureInitialized().stringifyValue(
      this as FCMarkPMUnreadResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCMarkPMUnreadResultMapper.ensureInitialized().equalsValue(
      this as FCMarkPMUnreadResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCMarkPMUnreadResultMapper.ensureInitialized().hashValue(
      this as FCMarkPMUnreadResult,
    );
  }
}

extension FCMarkPMUnreadResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCMarkPMUnreadResult, $Out> {
  FCMarkPMUnreadResultCopyWith<$R, FCMarkPMUnreadResult, $Out>
  get $asFCMarkPMUnreadResult => $base.as(
    (v, t, t2) => _FCMarkPMUnreadResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCMarkPMUnreadResultCopyWith<
  $R,
  $In extends FCMarkPMUnreadResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText});
  FCMarkPMUnreadResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCMarkPMUnreadResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCMarkPMUnreadResult, $Out>
    implements FCMarkPMUnreadResultCopyWith<$R, FCMarkPMUnreadResult, $Out> {
  _FCMarkPMUnreadResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCMarkPMUnreadResult> $mapper =
      FCMarkPMUnreadResultMapper.ensureInitialized();
  @override
  $R call({bool? result, Object? resultText = $none}) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
    }),
  );
  @override
  FCMarkPMUnreadResult $make(CopyWithData data) => FCMarkPMUnreadResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
  );

  @override
  FCMarkPMUnreadResultCopyWith<$R2, FCMarkPMUnreadResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCMarkPMUnreadResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCMarkPMReadResultMapper extends ClassMapperBase<FCMarkPMReadResult> {
  FCMarkPMReadResultMapper._();

  static FCMarkPMReadResultMapper? _instance;
  static FCMarkPMReadResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCMarkPMReadResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCMarkPMReadResult';

  static bool _$result(FCMarkPMReadResult v) => v.result;
  static const Field<FCMarkPMReadResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCMarkPMReadResult v) => v.resultText;
  static const Field<FCMarkPMReadResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );

  @override
  final MappableFields<FCMarkPMReadResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
  };

  static FCMarkPMReadResult _instantiate(DecodingData data) {
    return FCMarkPMReadResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCMarkPMReadResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCMarkPMReadResult>(map);
  }

  static FCMarkPMReadResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCMarkPMReadResult>(json);
  }
}

mixin FCMarkPMReadResultMappable {
  String toJson() {
    return FCMarkPMReadResultMapper.ensureInitialized()
        .encodeJson<FCMarkPMReadResult>(this as FCMarkPMReadResult);
  }

  Map<String, dynamic> toMap() {
    return FCMarkPMReadResultMapper.ensureInitialized()
        .encodeMap<FCMarkPMReadResult>(this as FCMarkPMReadResult);
  }

  FCMarkPMReadResultCopyWith<
    FCMarkPMReadResult,
    FCMarkPMReadResult,
    FCMarkPMReadResult
  >
  get copyWith =>
      _FCMarkPMReadResultCopyWithImpl<FCMarkPMReadResult, FCMarkPMReadResult>(
        this as FCMarkPMReadResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCMarkPMReadResultMapper.ensureInitialized().stringifyValue(
      this as FCMarkPMReadResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCMarkPMReadResultMapper.ensureInitialized().equalsValue(
      this as FCMarkPMReadResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCMarkPMReadResultMapper.ensureInitialized().hashValue(
      this as FCMarkPMReadResult,
    );
  }
}

extension FCMarkPMReadResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCMarkPMReadResult, $Out> {
  FCMarkPMReadResultCopyWith<$R, FCMarkPMReadResult, $Out>
  get $asFCMarkPMReadResult => $base.as(
    (v, t, t2) => _FCMarkPMReadResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCMarkPMReadResultCopyWith<
  $R,
  $In extends FCMarkPMReadResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText});
  FCMarkPMReadResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCMarkPMReadResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCMarkPMReadResult, $Out>
    implements FCMarkPMReadResultCopyWith<$R, FCMarkPMReadResult, $Out> {
  _FCMarkPMReadResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCMarkPMReadResult> $mapper =
      FCMarkPMReadResultMapper.ensureInitialized();
  @override
  $R call({bool? result, Object? resultText = $none}) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
    }),
  );
  @override
  FCMarkPMReadResult $make(CopyWithData data) => FCMarkPMReadResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
  );

  @override
  FCMarkPMReadResultCopyWith<$R2, FCMarkPMReadResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCMarkPMReadResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

