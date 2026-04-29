// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fc_private_conversation_result.dart';

class FCNewConversationResultMapper
    extends ClassMapperBase<FCNewConversationResult> {
  FCNewConversationResultMapper._();

  static FCNewConversationResultMapper? _instance;
  static FCNewConversationResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = FCNewConversationResultMapper._(),
      );
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCNewConversationResult';

  static bool _$result(FCNewConversationResult v) => v.result;
  static const Field<FCNewConversationResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCNewConversationResult v) => v.resultText;
  static const Field<FCNewConversationResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static String _$convId(FCNewConversationResult v) => v.convId;
  static const Field<FCNewConversationResult, String> _f$convId = Field(
    'convId',
    _$convId,
  );

  @override
  final MappableFields<FCNewConversationResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #convId: _f$convId,
  };

  static FCNewConversationResult _instantiate(DecodingData data) {
    return FCNewConversationResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      convId: data.dec(_f$convId),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCNewConversationResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCNewConversationResult>(map);
  }

  static FCNewConversationResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCNewConversationResult>(json);
  }
}

mixin FCNewConversationResultMappable {
  String toJson() {
    return FCNewConversationResultMapper.ensureInitialized()
        .encodeJson<FCNewConversationResult>(this as FCNewConversationResult);
  }

  Map<String, dynamic> toMap() {
    return FCNewConversationResultMapper.ensureInitialized()
        .encodeMap<FCNewConversationResult>(this as FCNewConversationResult);
  }

  FCNewConversationResultCopyWith<
    FCNewConversationResult,
    FCNewConversationResult,
    FCNewConversationResult
  >
  get copyWith =>
      _FCNewConversationResultCopyWithImpl<
        FCNewConversationResult,
        FCNewConversationResult
      >(this as FCNewConversationResult, $identity, $identity);
  @override
  String toString() {
    return FCNewConversationResultMapper.ensureInitialized().stringifyValue(
      this as FCNewConversationResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCNewConversationResultMapper.ensureInitialized().equalsValue(
      this as FCNewConversationResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCNewConversationResultMapper.ensureInitialized().hashValue(
      this as FCNewConversationResult,
    );
  }
}

extension FCNewConversationResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCNewConversationResult, $Out> {
  FCNewConversationResultCopyWith<$R, FCNewConversationResult, $Out>
  get $asFCNewConversationResult => $base.as(
    (v, t, t2) => _FCNewConversationResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCNewConversationResultCopyWith<
  $R,
  $In extends FCNewConversationResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText, String? convId});
  FCNewConversationResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCNewConversationResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCNewConversationResult, $Out>
    implements
        FCNewConversationResultCopyWith<$R, FCNewConversationResult, $Out> {
  _FCNewConversationResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCNewConversationResult> $mapper =
      FCNewConversationResultMapper.ensureInitialized();
  @override
  $R call({bool? result, Object? resultText = $none, String? convId}) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (convId != null) #convId: convId,
    }),
  );
  @override
  FCNewConversationResult $make(CopyWithData data) => FCNewConversationResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    convId: data.get(#convId, or: $value.convId),
  );

  @override
  FCNewConversationResultCopyWith<$R2, FCNewConversationResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCNewConversationResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCReplyConversationResultMapper
    extends ClassMapperBase<FCReplyConversationResult> {
  FCReplyConversationResultMapper._();

  static FCReplyConversationResultMapper? _instance;
  static FCReplyConversationResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = FCReplyConversationResultMapper._(),
      );
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCReplyConversationResult';

  static bool _$result(FCReplyConversationResult v) => v.result;
  static const Field<FCReplyConversationResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCReplyConversationResult v) => v.resultText;
  static const Field<FCReplyConversationResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static String? _$messageId(FCReplyConversationResult v) => v.messageId;
  static const Field<FCReplyConversationResult, String> _f$messageId = Field(
    'messageId',
    _$messageId,
    opt: true,
  );

  @override
  final MappableFields<FCReplyConversationResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #messageId: _f$messageId,
  };

  static FCReplyConversationResult _instantiate(DecodingData data) {
    return FCReplyConversationResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      messageId: data.dec(_f$messageId),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCReplyConversationResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCReplyConversationResult>(map);
  }

  static FCReplyConversationResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCReplyConversationResult>(json);
  }
}

mixin FCReplyConversationResultMappable {
  String toJson() {
    return FCReplyConversationResultMapper.ensureInitialized()
        .encodeJson<FCReplyConversationResult>(
          this as FCReplyConversationResult,
        );
  }

  Map<String, dynamic> toMap() {
    return FCReplyConversationResultMapper.ensureInitialized()
        .encodeMap<FCReplyConversationResult>(
          this as FCReplyConversationResult,
        );
  }

  FCReplyConversationResultCopyWith<
    FCReplyConversationResult,
    FCReplyConversationResult,
    FCReplyConversationResult
  >
  get copyWith =>
      _FCReplyConversationResultCopyWithImpl<
        FCReplyConversationResult,
        FCReplyConversationResult
      >(this as FCReplyConversationResult, $identity, $identity);
  @override
  String toString() {
    return FCReplyConversationResultMapper.ensureInitialized().stringifyValue(
      this as FCReplyConversationResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCReplyConversationResultMapper.ensureInitialized().equalsValue(
      this as FCReplyConversationResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCReplyConversationResultMapper.ensureInitialized().hashValue(
      this as FCReplyConversationResult,
    );
  }
}

extension FCReplyConversationResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCReplyConversationResult, $Out> {
  FCReplyConversationResultCopyWith<$R, FCReplyConversationResult, $Out>
  get $asFCReplyConversationResult => $base.as(
    (v, t, t2) => _FCReplyConversationResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCReplyConversationResultCopyWith<
  $R,
  $In extends FCReplyConversationResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText, String? messageId});
  FCReplyConversationResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCReplyConversationResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCReplyConversationResult, $Out>
    implements
        FCReplyConversationResultCopyWith<$R, FCReplyConversationResult, $Out> {
  _FCReplyConversationResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCReplyConversationResult> $mapper =
      FCReplyConversationResultMapper.ensureInitialized();
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
    Object? messageId = $none,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (messageId != $none) #messageId: messageId,
    }),
  );
  @override
  FCReplyConversationResult $make(CopyWithData data) =>
      FCReplyConversationResult(
        result: data.get(#result, or: $value.result),
        resultText: data.get(#resultText, or: $value.resultText),
        messageId: data.get(#messageId, or: $value.messageId),
      );

  @override
  FCReplyConversationResultCopyWith<$R2, FCReplyConversationResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCReplyConversationResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCInviteParticipantResultMapper
    extends ClassMapperBase<FCInviteParticipantResult> {
  FCInviteParticipantResultMapper._();

  static FCInviteParticipantResultMapper? _instance;
  static FCInviteParticipantResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = FCInviteParticipantResultMapper._(),
      );
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCInviteParticipantResult';

  static bool _$result(FCInviteParticipantResult v) => v.result;
  static const Field<FCInviteParticipantResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCInviteParticipantResult v) => v.resultText;
  static const Field<FCInviteParticipantResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );

  @override
  final MappableFields<FCInviteParticipantResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
  };

  static FCInviteParticipantResult _instantiate(DecodingData data) {
    return FCInviteParticipantResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCInviteParticipantResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCInviteParticipantResult>(map);
  }

  static FCInviteParticipantResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCInviteParticipantResult>(json);
  }
}

mixin FCInviteParticipantResultMappable {
  String toJson() {
    return FCInviteParticipantResultMapper.ensureInitialized()
        .encodeJson<FCInviteParticipantResult>(
          this as FCInviteParticipantResult,
        );
  }

  Map<String, dynamic> toMap() {
    return FCInviteParticipantResultMapper.ensureInitialized()
        .encodeMap<FCInviteParticipantResult>(
          this as FCInviteParticipantResult,
        );
  }

  FCInviteParticipantResultCopyWith<
    FCInviteParticipantResult,
    FCInviteParticipantResult,
    FCInviteParticipantResult
  >
  get copyWith =>
      _FCInviteParticipantResultCopyWithImpl<
        FCInviteParticipantResult,
        FCInviteParticipantResult
      >(this as FCInviteParticipantResult, $identity, $identity);
  @override
  String toString() {
    return FCInviteParticipantResultMapper.ensureInitialized().stringifyValue(
      this as FCInviteParticipantResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCInviteParticipantResultMapper.ensureInitialized().equalsValue(
      this as FCInviteParticipantResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCInviteParticipantResultMapper.ensureInitialized().hashValue(
      this as FCInviteParticipantResult,
    );
  }
}

extension FCInviteParticipantResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCInviteParticipantResult, $Out> {
  FCInviteParticipantResultCopyWith<$R, FCInviteParticipantResult, $Out>
  get $asFCInviteParticipantResult => $base.as(
    (v, t, t2) => _FCInviteParticipantResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCInviteParticipantResultCopyWith<
  $R,
  $In extends FCInviteParticipantResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText});
  FCInviteParticipantResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCInviteParticipantResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCInviteParticipantResult, $Out>
    implements
        FCInviteParticipantResultCopyWith<$R, FCInviteParticipantResult, $Out> {
  _FCInviteParticipantResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCInviteParticipantResult> $mapper =
      FCInviteParticipantResultMapper.ensureInitialized();
  @override
  $R call({bool? result, Object? resultText = $none}) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
    }),
  );
  @override
  FCInviteParticipantResult $make(CopyWithData data) =>
      FCInviteParticipantResult(
        result: data.get(#result, or: $value.result),
        resultText: data.get(#resultText, or: $value.resultText),
      );

  @override
  FCInviteParticipantResultCopyWith<$R2, FCInviteParticipantResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCInviteParticipantResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCConversationInboxStatResultMapper
    extends ClassMapperBase<FCConversationInboxStatResult> {
  FCConversationInboxStatResultMapper._();

  static FCConversationInboxStatResultMapper? _instance;
  static FCConversationInboxStatResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = FCConversationInboxStatResultMapper._(),
      );
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCConversationInboxStatResult';

  static bool _$result(FCConversationInboxStatResult v) => v.result;
  static const Field<FCConversationInboxStatResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCConversationInboxStatResult v) => v.resultText;
  static const Field<FCConversationInboxStatResult, String> _f$resultText =
      Field('resultText', _$resultText, opt: true);
  static int _$totalConversations(FCConversationInboxStatResult v) =>
      v.totalConversations;
  static const Field<FCConversationInboxStatResult, int> _f$totalConversations =
      Field('totalConversations', _$totalConversations);
  static int _$unreadConversations(FCConversationInboxStatResult v) =>
      v.unreadConversations;
  static const Field<FCConversationInboxStatResult, int>
  _f$unreadConversations = Field('unreadConversations', _$unreadConversations);
  static int _$unreadMessages(FCConversationInboxStatResult v) =>
      v.unreadMessages;
  static const Field<FCConversationInboxStatResult, int> _f$unreadMessages =
      Field('unreadMessages', _$unreadMessages);

  @override
  final MappableFields<FCConversationInboxStatResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #totalConversations: _f$totalConversations,
    #unreadConversations: _f$unreadConversations,
    #unreadMessages: _f$unreadMessages,
  };

  static FCConversationInboxStatResult _instantiate(DecodingData data) {
    return FCConversationInboxStatResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      totalConversations: data.dec(_f$totalConversations),
      unreadConversations: data.dec(_f$unreadConversations),
      unreadMessages: data.dec(_f$unreadMessages),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCConversationInboxStatResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCConversationInboxStatResult>(map);
  }

  static FCConversationInboxStatResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCConversationInboxStatResult>(json);
  }
}

mixin FCConversationInboxStatResultMappable {
  String toJson() {
    return FCConversationInboxStatResultMapper.ensureInitialized()
        .encodeJson<FCConversationInboxStatResult>(
          this as FCConversationInboxStatResult,
        );
  }

  Map<String, dynamic> toMap() {
    return FCConversationInboxStatResultMapper.ensureInitialized()
        .encodeMap<FCConversationInboxStatResult>(
          this as FCConversationInboxStatResult,
        );
  }

  FCConversationInboxStatResultCopyWith<
    FCConversationInboxStatResult,
    FCConversationInboxStatResult,
    FCConversationInboxStatResult
  >
  get copyWith =>
      _FCConversationInboxStatResultCopyWithImpl<
        FCConversationInboxStatResult,
        FCConversationInboxStatResult
      >(this as FCConversationInboxStatResult, $identity, $identity);
  @override
  String toString() {
    return FCConversationInboxStatResultMapper.ensureInitialized()
        .stringifyValue(this as FCConversationInboxStatResult);
  }

  @override
  bool operator ==(Object other) {
    return FCConversationInboxStatResultMapper.ensureInitialized().equalsValue(
      this as FCConversationInboxStatResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCConversationInboxStatResultMapper.ensureInitialized().hashValue(
      this as FCConversationInboxStatResult,
    );
  }
}

extension FCConversationInboxStatResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCConversationInboxStatResult, $Out> {
  FCConversationInboxStatResultCopyWith<$R, FCConversationInboxStatResult, $Out>
  get $asFCConversationInboxStatResult => $base.as(
    (v, t, t2) =>
        _FCConversationInboxStatResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCConversationInboxStatResultCopyWith<
  $R,
  $In extends FCConversationInboxStatResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({
    bool? result,
    String? resultText,
    int? totalConversations,
    int? unreadConversations,
    int? unreadMessages,
  });
  FCConversationInboxStatResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCConversationInboxStatResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCConversationInboxStatResult, $Out>
    implements
        FCConversationInboxStatResultCopyWith<
          $R,
          FCConversationInboxStatResult,
          $Out
        > {
  _FCConversationInboxStatResultCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<FCConversationInboxStatResult> $mapper =
      FCConversationInboxStatResultMapper.ensureInitialized();
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
    int? totalConversations,
    int? unreadConversations,
    int? unreadMessages,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (totalConversations != null) #totalConversations: totalConversations,
      if (unreadConversations != null)
        #unreadConversations: unreadConversations,
      if (unreadMessages != null) #unreadMessages: unreadMessages,
    }),
  );
  @override
  FCConversationInboxStatResult $make(CopyWithData data) =>
      FCConversationInboxStatResult(
        result: data.get(#result, or: $value.result),
        resultText: data.get(#resultText, or: $value.resultText),
        totalConversations: data.get(
          #totalConversations,
          or: $value.totalConversations,
        ),
        unreadConversations: data.get(
          #unreadConversations,
          or: $value.unreadConversations,
        ),
        unreadMessages: data.get(#unreadMessages, or: $value.unreadMessages),
      );

  @override
  FCConversationInboxStatResultCopyWith<
    $R2,
    FCConversationInboxStatResult,
    $Out2
  >
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCConversationInboxStatResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCInboxStatResultMapper extends ClassMapperBase<FCInboxStatResult> {
  FCInboxStatResultMapper._();

  static FCInboxStatResultMapper? _instance;
  static FCInboxStatResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCInboxStatResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCInboxStatResult';

  static bool _$result(FCInboxStatResult v) => v.result;
  static const Field<FCInboxStatResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCInboxStatResult v) => v.resultText;
  static const Field<FCInboxStatResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static int _$totalConversations(FCInboxStatResult v) => v.totalConversations;
  static const Field<FCInboxStatResult, int> _f$totalConversations = Field(
    'totalConversations',
    _$totalConversations,
  );
  static int _$unreadConversations(FCInboxStatResult v) =>
      v.unreadConversations;
  static const Field<FCInboxStatResult, int> _f$unreadConversations = Field(
    'unreadConversations',
    _$unreadConversations,
  );
  static int _$unreadMessages(FCInboxStatResult v) => v.unreadMessages;
  static const Field<FCInboxStatResult, int> _f$unreadMessages = Field(
    'unreadMessages',
    _$unreadMessages,
  );

  @override
  final MappableFields<FCInboxStatResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #totalConversations: _f$totalConversations,
    #unreadConversations: _f$unreadConversations,
    #unreadMessages: _f$unreadMessages,
  };

  static FCInboxStatResult _instantiate(DecodingData data) {
    return FCInboxStatResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      totalConversations: data.dec(_f$totalConversations),
      unreadConversations: data.dec(_f$unreadConversations),
      unreadMessages: data.dec(_f$unreadMessages),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCInboxStatResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCInboxStatResult>(map);
  }

  static FCInboxStatResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCInboxStatResult>(json);
  }
}

mixin FCInboxStatResultMappable {
  String toJson() {
    return FCInboxStatResultMapper.ensureInitialized()
        .encodeJson<FCInboxStatResult>(this as FCInboxStatResult);
  }

  Map<String, dynamic> toMap() {
    return FCInboxStatResultMapper.ensureInitialized()
        .encodeMap<FCInboxStatResult>(this as FCInboxStatResult);
  }

  FCInboxStatResultCopyWith<
    FCInboxStatResult,
    FCInboxStatResult,
    FCInboxStatResult
  >
  get copyWith =>
      _FCInboxStatResultCopyWithImpl<FCInboxStatResult, FCInboxStatResult>(
        this as FCInboxStatResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCInboxStatResultMapper.ensureInitialized().stringifyValue(
      this as FCInboxStatResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCInboxStatResultMapper.ensureInitialized().equalsValue(
      this as FCInboxStatResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCInboxStatResultMapper.ensureInitialized().hashValue(
      this as FCInboxStatResult,
    );
  }
}

extension FCInboxStatResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCInboxStatResult, $Out> {
  FCInboxStatResultCopyWith<$R, FCInboxStatResult, $Out>
  get $asFCInboxStatResult => $base.as(
    (v, t, t2) => _FCInboxStatResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCInboxStatResultCopyWith<
  $R,
  $In extends FCInboxStatResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({
    bool? result,
    String? resultText,
    int? totalConversations,
    int? unreadConversations,
    int? unreadMessages,
  });
  FCInboxStatResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCInboxStatResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCInboxStatResult, $Out>
    implements FCInboxStatResultCopyWith<$R, FCInboxStatResult, $Out> {
  _FCInboxStatResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCInboxStatResult> $mapper =
      FCInboxStatResultMapper.ensureInitialized();
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
    int? totalConversations,
    int? unreadConversations,
    int? unreadMessages,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (totalConversations != null) #totalConversations: totalConversations,
      if (unreadConversations != null)
        #unreadConversations: unreadConversations,
      if (unreadMessages != null) #unreadMessages: unreadMessages,
    }),
  );
  @override
  FCInboxStatResult $make(CopyWithData data) => FCInboxStatResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    totalConversations: data.get(
      #totalConversations,
      or: $value.totalConversations,
    ),
    unreadConversations: data.get(
      #unreadConversations,
      or: $value.unreadConversations,
    ),
    unreadMessages: data.get(#unreadMessages, or: $value.unreadMessages),
  );

  @override
  FCInboxStatResultCopyWith<$R2, FCInboxStatResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCInboxStatResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCConversationsResultMapper
    extends ClassMapperBase<FCConversationsResult> {
  FCConversationsResultMapper._();

  static FCConversationsResultMapper? _instance;
  static FCConversationsResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCConversationsResultMapper._());
      FCBaseResultMapper.ensureInitialized();
      FCConversationSummaryMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCConversationsResult';

  static bool _$result(FCConversationsResult v) => v.result;
  static const Field<FCConversationsResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCConversationsResult v) => v.resultText;
  static const Field<FCConversationsResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static int _$conversationCount(FCConversationsResult v) =>
      v.conversationCount;
  static const Field<FCConversationsResult, int> _f$conversationCount = Field(
    'conversationCount',
    _$conversationCount,
  );
  static int _$unreadCount(FCConversationsResult v) => v.unreadCount;
  static const Field<FCConversationsResult, int> _f$unreadCount = Field(
    'unreadCount',
    _$unreadCount,
  );
  static bool _$canUpload(FCConversationsResult v) => v.canUpload;
  static const Field<FCConversationsResult, bool> _f$canUpload = Field(
    'canUpload',
    _$canUpload,
  );
  static List<FCConversationSummary> _$list(FCConversationsResult v) => v.list;
  static const Field<FCConversationsResult, List<FCConversationSummary>>
  _f$list = Field('list', _$list);

  @override
  final MappableFields<FCConversationsResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #conversationCount: _f$conversationCount,
    #unreadCount: _f$unreadCount,
    #canUpload: _f$canUpload,
    #list: _f$list,
  };

  static FCConversationsResult _instantiate(DecodingData data) {
    return FCConversationsResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      conversationCount: data.dec(_f$conversationCount),
      unreadCount: data.dec(_f$unreadCount),
      canUpload: data.dec(_f$canUpload),
      list: data.dec(_f$list),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCConversationsResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCConversationsResult>(map);
  }

  static FCConversationsResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCConversationsResult>(json);
  }
}

mixin FCConversationsResultMappable {
  String toJson() {
    return FCConversationsResultMapper.ensureInitialized()
        .encodeJson<FCConversationsResult>(this as FCConversationsResult);
  }

  Map<String, dynamic> toMap() {
    return FCConversationsResultMapper.ensureInitialized()
        .encodeMap<FCConversationsResult>(this as FCConversationsResult);
  }

  FCConversationsResultCopyWith<
    FCConversationsResult,
    FCConversationsResult,
    FCConversationsResult
  >
  get copyWith =>
      _FCConversationsResultCopyWithImpl<
        FCConversationsResult,
        FCConversationsResult
      >(this as FCConversationsResult, $identity, $identity);
  @override
  String toString() {
    return FCConversationsResultMapper.ensureInitialized().stringifyValue(
      this as FCConversationsResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCConversationsResultMapper.ensureInitialized().equalsValue(
      this as FCConversationsResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCConversationsResultMapper.ensureInitialized().hashValue(
      this as FCConversationsResult,
    );
  }
}

extension FCConversationsResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCConversationsResult, $Out> {
  FCConversationsResultCopyWith<$R, FCConversationsResult, $Out>
  get $asFCConversationsResult => $base.as(
    (v, t, t2) => _FCConversationsResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCConversationsResultCopyWith<
  $R,
  $In extends FCConversationsResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    FCConversationSummary,
    FCConversationSummaryCopyWith<
      $R,
      FCConversationSummary,
      FCConversationSummary
    >
  >
  get list;
  @override
  $R call({
    bool? result,
    String? resultText,
    int? conversationCount,
    int? unreadCount,
    bool? canUpload,
    List<FCConversationSummary>? list,
  });
  FCConversationsResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCConversationsResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCConversationsResult, $Out>
    implements FCConversationsResultCopyWith<$R, FCConversationsResult, $Out> {
  _FCConversationsResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCConversationsResult> $mapper =
      FCConversationsResultMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    FCConversationSummary,
    FCConversationSummaryCopyWith<
      $R,
      FCConversationSummary,
      FCConversationSummary
    >
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
    int? conversationCount,
    int? unreadCount,
    bool? canUpload,
    List<FCConversationSummary>? list,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (conversationCount != null) #conversationCount: conversationCount,
      if (unreadCount != null) #unreadCount: unreadCount,
      if (canUpload != null) #canUpload: canUpload,
      if (list != null) #list: list,
    }),
  );
  @override
  FCConversationsResult $make(CopyWithData data) => FCConversationsResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    conversationCount: data.get(
      #conversationCount,
      or: $value.conversationCount,
    ),
    unreadCount: data.get(#unreadCount, or: $value.unreadCount),
    canUpload: data.get(#canUpload, or: $value.canUpload),
    list: data.get(#list, or: $value.list),
  );

  @override
  FCConversationsResultCopyWith<$R2, FCConversationsResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCConversationsResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCConversationSummaryMapper
    extends ClassMapperBase<FCConversationSummary> {
  FCConversationSummaryMapper._();

  static FCConversationSummaryMapper? _instance;
  static FCConversationSummaryMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCConversationSummaryMapper._());
      FCParticipantMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCConversationSummary';

  static String _$convId(FCConversationSummary v) => v.convId;
  static const Field<FCConversationSummary, String> _f$convId = Field(
    'convId',
    _$convId,
  );
  static String _$replyCount(FCConversationSummary v) => v.replyCount;
  static const Field<FCConversationSummary, String> _f$replyCount = Field(
    'replyCount',
    _$replyCount,
  );
  static int _$participantCount(FCConversationSummary v) => v.participantCount;
  static const Field<FCConversationSummary, int> _f$participantCount = Field(
    'participantCount',
    _$participantCount,
  );
  static String? _$startUserId(FCConversationSummary v) => v.startUserId;
  static const Field<FCConversationSummary, String> _f$startUserId = Field(
    'startUserId',
    _$startUserId,
    opt: true,
  );
  static String? _$startTime(FCConversationSummary v) => v.startTime;
  static const Field<FCConversationSummary, String> _f$startTime = Field(
    'startTime',
    _$startTime,
    opt: true,
  );
  static String? _$subject(FCConversationSummary v) => v.subject;
  static const Field<FCConversationSummary, String> _f$subject = Field(
    'subject',
    _$subject,
    opt: true,
  );
  static String? _$convSubject(FCConversationSummary v) => v.convSubject;
  static const Field<FCConversationSummary, String> _f$convSubject = Field(
    'convSubject',
    _$convSubject,
    opt: true,
  );
  static String? _$lastUserId(FCConversationSummary v) => v.lastUserId;
  static const Field<FCConversationSummary, String> _f$lastUserId = Field(
    'lastUserId',
    _$lastUserId,
    opt: true,
  );
  static String? _$lastReplyTime(FCConversationSummary v) => v.lastReplyTime;
  static const Field<FCConversationSummary, String> _f$lastReplyTime = Field(
    'lastReplyTime',
    _$lastReplyTime,
    opt: true,
  );
  static String? _$lastConvTime(FCConversationSummary v) => v.lastConvTime;
  static const Field<FCConversationSummary, String> _f$lastConvTime = Field(
    'lastConvTime',
    _$lastConvTime,
    opt: true,
  );
  static bool? _$newPost(FCConversationSummary v) => v.newPost;
  static const Field<FCConversationSummary, bool> _f$newPost = Field(
    'newPost',
    _$newPost,
    opt: true,
  );
  static List<FCParticipant>? _$participants(FCConversationSummary v) =>
      v.participants;
  static const Field<FCConversationSummary, List<FCParticipant>>
  _f$participants = Field('participants', _$participants, opt: true);
  static bool? _$canEdit(FCConversationSummary v) => v.canEdit;
  static const Field<FCConversationSummary, bool> _f$canEdit = Field(
    'canEdit',
    _$canEdit,
    opt: true,
  );
  static bool? _$canClose(FCConversationSummary v) => v.canClose;
  static const Field<FCConversationSummary, bool> _f$canClose = Field(
    'canClose',
    _$canClose,
    opt: true,
  );
  static bool? _$isClosed(FCConversationSummary v) => v.isClosed;
  static const Field<FCConversationSummary, bool> _f$isClosed = Field(
    'isClosed',
    _$isClosed,
    opt: true,
  );
  static String? _$messageId(FCConversationSummary v) => v.messageId;
  static const Field<FCConversationSummary, String> _f$messageId = Field(
    'messageId',
    _$messageId,
    opt: true,
  );
  static int? _$unreadMessageCount(FCConversationSummary v) =>
      v.unreadMessageCount;
  static const Field<FCConversationSummary, int> _f$unreadMessageCount = Field(
    'unreadMessageCount',
    _$unreadMessageCount,
    opt: true,
  );

  @override
  final MappableFields<FCConversationSummary> fields = const {
    #convId: _f$convId,
    #replyCount: _f$replyCount,
    #participantCount: _f$participantCount,
    #startUserId: _f$startUserId,
    #startTime: _f$startTime,
    #subject: _f$subject,
    #convSubject: _f$convSubject,
    #lastUserId: _f$lastUserId,
    #lastReplyTime: _f$lastReplyTime,
    #lastConvTime: _f$lastConvTime,
    #newPost: _f$newPost,
    #participants: _f$participants,
    #canEdit: _f$canEdit,
    #canClose: _f$canClose,
    #isClosed: _f$isClosed,
    #messageId: _f$messageId,
    #unreadMessageCount: _f$unreadMessageCount,
  };

  static FCConversationSummary _instantiate(DecodingData data) {
    return FCConversationSummary(
      convId: data.dec(_f$convId),
      replyCount: data.dec(_f$replyCount),
      participantCount: data.dec(_f$participantCount),
      startUserId: data.dec(_f$startUserId),
      startTime: data.dec(_f$startTime),
      subject: data.dec(_f$subject),
      convSubject: data.dec(_f$convSubject),
      lastUserId: data.dec(_f$lastUserId),
      lastReplyTime: data.dec(_f$lastReplyTime),
      lastConvTime: data.dec(_f$lastConvTime),
      newPost: data.dec(_f$newPost),
      participants: data.dec(_f$participants),
      canEdit: data.dec(_f$canEdit),
      canClose: data.dec(_f$canClose),
      isClosed: data.dec(_f$isClosed),
      messageId: data.dec(_f$messageId),
      unreadMessageCount: data.dec(_f$unreadMessageCount),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCConversationSummary fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCConversationSummary>(map);
  }

  static FCConversationSummary fromJson(String json) {
    return ensureInitialized().decodeJson<FCConversationSummary>(json);
  }
}

mixin FCConversationSummaryMappable {
  String toJson() {
    return FCConversationSummaryMapper.ensureInitialized()
        .encodeJson<FCConversationSummary>(this as FCConversationSummary);
  }

  Map<String, dynamic> toMap() {
    return FCConversationSummaryMapper.ensureInitialized()
        .encodeMap<FCConversationSummary>(this as FCConversationSummary);
  }

  FCConversationSummaryCopyWith<
    FCConversationSummary,
    FCConversationSummary,
    FCConversationSummary
  >
  get copyWith =>
      _FCConversationSummaryCopyWithImpl<
        FCConversationSummary,
        FCConversationSummary
      >(this as FCConversationSummary, $identity, $identity);
  @override
  String toString() {
    return FCConversationSummaryMapper.ensureInitialized().stringifyValue(
      this as FCConversationSummary,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCConversationSummaryMapper.ensureInitialized().equalsValue(
      this as FCConversationSummary,
      other,
    );
  }

  @override
  int get hashCode {
    return FCConversationSummaryMapper.ensureInitialized().hashValue(
      this as FCConversationSummary,
    );
  }
}

extension FCConversationSummaryValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCConversationSummary, $Out> {
  FCConversationSummaryCopyWith<$R, FCConversationSummary, $Out>
  get $asFCConversationSummary => $base.as(
    (v, t, t2) => _FCConversationSummaryCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCConversationSummaryCopyWith<
  $R,
  $In extends FCConversationSummary,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    FCParticipant,
    FCParticipantCopyWith<$R, FCParticipant, FCParticipant>
  >?
  get participants;
  $R call({
    String? convId,
    String? replyCount,
    int? participantCount,
    String? startUserId,
    String? startTime,
    String? subject,
    String? convSubject,
    String? lastUserId,
    String? lastReplyTime,
    String? lastConvTime,
    bool? newPost,
    List<FCParticipant>? participants,
    bool? canEdit,
    bool? canClose,
    bool? isClosed,
    String? messageId,
    int? unreadMessageCount,
  });
  FCConversationSummaryCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCConversationSummaryCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCConversationSummary, $Out>
    implements FCConversationSummaryCopyWith<$R, FCConversationSummary, $Out> {
  _FCConversationSummaryCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCConversationSummary> $mapper =
      FCConversationSummaryMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    FCParticipant,
    FCParticipantCopyWith<$R, FCParticipant, FCParticipant>
  >?
  get participants => $value.participants != null
      ? ListCopyWith(
          $value.participants!,
          (v, t) => v.copyWith.$chain(t),
          (v) => call(participants: v),
        )
      : null;
  @override
  $R call({
    String? convId,
    String? replyCount,
    int? participantCount,
    Object? startUserId = $none,
    Object? startTime = $none,
    Object? subject = $none,
    Object? convSubject = $none,
    Object? lastUserId = $none,
    Object? lastReplyTime = $none,
    Object? lastConvTime = $none,
    Object? newPost = $none,
    Object? participants = $none,
    Object? canEdit = $none,
    Object? canClose = $none,
    Object? isClosed = $none,
    Object? messageId = $none,
    Object? unreadMessageCount = $none,
  }) => $apply(
    FieldCopyWithData({
      if (convId != null) #convId: convId,
      if (replyCount != null) #replyCount: replyCount,
      if (participantCount != null) #participantCount: participantCount,
      if (startUserId != $none) #startUserId: startUserId,
      if (startTime != $none) #startTime: startTime,
      if (subject != $none) #subject: subject,
      if (convSubject != $none) #convSubject: convSubject,
      if (lastUserId != $none) #lastUserId: lastUserId,
      if (lastReplyTime != $none) #lastReplyTime: lastReplyTime,
      if (lastConvTime != $none) #lastConvTime: lastConvTime,
      if (newPost != $none) #newPost: newPost,
      if (participants != $none) #participants: participants,
      if (canEdit != $none) #canEdit: canEdit,
      if (canClose != $none) #canClose: canClose,
      if (isClosed != $none) #isClosed: isClosed,
      if (messageId != $none) #messageId: messageId,
      if (unreadMessageCount != $none) #unreadMessageCount: unreadMessageCount,
    }),
  );
  @override
  FCConversationSummary $make(CopyWithData data) => FCConversationSummary(
    convId: data.get(#convId, or: $value.convId),
    replyCount: data.get(#replyCount, or: $value.replyCount),
    participantCount: data.get(#participantCount, or: $value.participantCount),
    startUserId: data.get(#startUserId, or: $value.startUserId),
    startTime: data.get(#startTime, or: $value.startTime),
    subject: data.get(#subject, or: $value.subject),
    convSubject: data.get(#convSubject, or: $value.convSubject),
    lastUserId: data.get(#lastUserId, or: $value.lastUserId),
    lastReplyTime: data.get(#lastReplyTime, or: $value.lastReplyTime),
    lastConvTime: data.get(#lastConvTime, or: $value.lastConvTime),
    newPost: data.get(#newPost, or: $value.newPost),
    participants: data.get(#participants, or: $value.participants),
    canEdit: data.get(#canEdit, or: $value.canEdit),
    canClose: data.get(#canClose, or: $value.canClose),
    isClosed: data.get(#isClosed, or: $value.isClosed),
    messageId: data.get(#messageId, or: $value.messageId),
    unreadMessageCount: data.get(
      #unreadMessageCount,
      or: $value.unreadMessageCount,
    ),
  );

  @override
  FCConversationSummaryCopyWith<$R2, FCConversationSummary, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCConversationSummaryCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCParticipantMapper extends ClassMapperBase<FCParticipant> {
  FCParticipantMapper._();

  static FCParticipantMapper? _instance;
  static FCParticipantMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCParticipantMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FCParticipant';

  static String _$userId(FCParticipant v) => v.userId;
  static const Field<FCParticipant, String> _f$userId = Field(
    'userId',
    _$userId,
  );
  static String _$username(FCParticipant v) => v.username;
  static const Field<FCParticipant, String> _f$username = Field(
    'username',
    _$username,
  );
  static String? _$iconUrl(FCParticipant v) => v.iconUrl;
  static const Field<FCParticipant, String> _f$iconUrl = Field(
    'iconUrl',
    _$iconUrl,
    opt: true,
  );
  static bool? _$isOnline(FCParticipant v) => v.isOnline;
  static const Field<FCParticipant, bool> _f$isOnline = Field(
    'isOnline',
    _$isOnline,
    opt: true,
  );

  @override
  final MappableFields<FCParticipant> fields = const {
    #userId: _f$userId,
    #username: _f$username,
    #iconUrl: _f$iconUrl,
    #isOnline: _f$isOnline,
  };

  static FCParticipant _instantiate(DecodingData data) {
    return FCParticipant(
      userId: data.dec(_f$userId),
      username: data.dec(_f$username),
      iconUrl: data.dec(_f$iconUrl),
      isOnline: data.dec(_f$isOnline),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCParticipant fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCParticipant>(map);
  }

  static FCParticipant fromJson(String json) {
    return ensureInitialized().decodeJson<FCParticipant>(json);
  }
}

mixin FCParticipantMappable {
  String toJson() {
    return FCParticipantMapper.ensureInitialized().encodeJson<FCParticipant>(
      this as FCParticipant,
    );
  }

  Map<String, dynamic> toMap() {
    return FCParticipantMapper.ensureInitialized().encodeMap<FCParticipant>(
      this as FCParticipant,
    );
  }

  FCParticipantCopyWith<FCParticipant, FCParticipant, FCParticipant>
  get copyWith => _FCParticipantCopyWithImpl<FCParticipant, FCParticipant>(
    this as FCParticipant,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return FCParticipantMapper.ensureInitialized().stringifyValue(
      this as FCParticipant,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCParticipantMapper.ensureInitialized().equalsValue(
      this as FCParticipant,
      other,
    );
  }

  @override
  int get hashCode {
    return FCParticipantMapper.ensureInitialized().hashValue(
      this as FCParticipant,
    );
  }
}

extension FCParticipantValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCParticipant, $Out> {
  FCParticipantCopyWith<$R, FCParticipant, $Out> get $asFCParticipant =>
      $base.as((v, t, t2) => _FCParticipantCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCParticipantCopyWith<$R, $In extends FCParticipant, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? userId, String? username, String? iconUrl, bool? isOnline});
  FCParticipantCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FCParticipantCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCParticipant, $Out>
    implements FCParticipantCopyWith<$R, FCParticipant, $Out> {
  _FCParticipantCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCParticipant> $mapper =
      FCParticipantMapper.ensureInitialized();
  @override
  $R call({
    String? userId,
    String? username,
    Object? iconUrl = $none,
    Object? isOnline = $none,
  }) => $apply(
    FieldCopyWithData({
      if (userId != null) #userId: userId,
      if (username != null) #username: username,
      if (iconUrl != $none) #iconUrl: iconUrl,
      if (isOnline != $none) #isOnline: isOnline,
    }),
  );
  @override
  FCParticipant $make(CopyWithData data) => FCParticipant(
    userId: data.get(#userId, or: $value.userId),
    username: data.get(#username, or: $value.username),
    iconUrl: data.get(#iconUrl, or: $value.iconUrl),
    isOnline: data.get(#isOnline, or: $value.isOnline),
  );

  @override
  FCParticipantCopyWith<$R2, FCParticipant, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCParticipantCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCConversationResultMapper extends ClassMapperBase<FCConversationResult> {
  FCConversationResultMapper._();

  static FCConversationResultMapper? _instance;
  static FCConversationResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCConversationResultMapper._());
      FCBaseResultMapper.ensureInitialized();
      FCConversationMessageMapper.ensureInitialized();
      FCParticipantMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCConversationResult';

  static bool _$result(FCConversationResult v) => v.result;
  static const Field<FCConversationResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCConversationResult v) => v.resultText;
  static const Field<FCConversationResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static String _$convId(FCConversationResult v) => v.convId;
  static const Field<FCConversationResult, String> _f$convId = Field(
    'convId',
    _$convId,
  );
  static String? _$subject(FCConversationResult v) => v.subject;
  static const Field<FCConversationResult, String> _f$subject = Field(
    'subject',
    _$subject,
    opt: true,
  );
  static String? _$convTitle(FCConversationResult v) => v.convTitle;
  static const Field<FCConversationResult, String> _f$convTitle = Field(
    'convTitle',
    _$convTitle,
    opt: true,
  );
  static List<FCConversationMessage> _$messages(FCConversationResult v) =>
      v.messages;
  static const Field<FCConversationResult, List<FCConversationMessage>>
  _f$messages = Field('messages', _$messages);
  static List<FCParticipant> _$participants(FCConversationResult v) =>
      v.participants;
  static const Field<FCConversationResult, List<FCParticipant>>
  _f$participants = Field('participants', _$participants);
  static int? _$participantCount(FCConversationResult v) => v.participantCount;
  static const Field<FCConversationResult, int> _f$participantCount = Field(
    'participantCount',
    _$participantCount,
    opt: true,
  );
  static bool? _$canReply(FCConversationResult v) => v.canReply;
  static const Field<FCConversationResult, bool> _f$canReply = Field(
    'canReply',
    _$canReply,
    opt: true,
  );
  static bool? _$canInvite(FCConversationResult v) => v.canInvite;
  static const Field<FCConversationResult, bool> _f$canInvite = Field(
    'canInvite',
    _$canInvite,
    opt: true,
  );
  static bool? _$canEdit(FCConversationResult v) => v.canEdit;
  static const Field<FCConversationResult, bool> _f$canEdit = Field(
    'canEdit',
    _$canEdit,
    opt: true,
  );
  static bool? _$canClose(FCConversationResult v) => v.canClose;
  static const Field<FCConversationResult, bool> _f$canClose = Field(
    'canClose',
    _$canClose,
    opt: true,
  );
  static bool? _$isClosed(FCConversationResult v) => v.isClosed;
  static const Field<FCConversationResult, bool> _f$isClosed = Field(
    'isClosed',
    _$isClosed,
    opt: true,
  );
  static int? _$totalMessageNum(FCConversationResult v) => v.totalMessageNum;
  static const Field<FCConversationResult, int> _f$totalMessageNum = Field(
    'totalMessageNum',
    _$totalMessageNum,
    opt: true,
  );
  static int? _$lastRead(FCConversationResult v) => v.lastRead;
  static const Field<FCConversationResult, int> _f$lastRead = Field(
    'lastRead',
    _$lastRead,
    opt: true,
  );
  static bool? _$canUpload(FCConversationResult v) => v.canUpload;
  static const Field<FCConversationResult, bool> _f$canUpload = Field(
    'canUpload',
    _$canUpload,
    opt: true,
  );
  static int? _$position(FCConversationResult v) => v.position;
  static const Field<FCConversationResult, int> _f$position = Field(
    'position',
    _$position,
    opt: true,
  );

  @override
  final MappableFields<FCConversationResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #convId: _f$convId,
    #subject: _f$subject,
    #convTitle: _f$convTitle,
    #messages: _f$messages,
    #participants: _f$participants,
    #participantCount: _f$participantCount,
    #canReply: _f$canReply,
    #canInvite: _f$canInvite,
    #canEdit: _f$canEdit,
    #canClose: _f$canClose,
    #isClosed: _f$isClosed,
    #totalMessageNum: _f$totalMessageNum,
    #lastRead: _f$lastRead,
    #canUpload: _f$canUpload,
    #position: _f$position,
  };

  static FCConversationResult _instantiate(DecodingData data) {
    return FCConversationResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      convId: data.dec(_f$convId),
      subject: data.dec(_f$subject),
      convTitle: data.dec(_f$convTitle),
      messages: data.dec(_f$messages),
      participants: data.dec(_f$participants),
      participantCount: data.dec(_f$participantCount),
      canReply: data.dec(_f$canReply),
      canInvite: data.dec(_f$canInvite),
      canEdit: data.dec(_f$canEdit),
      canClose: data.dec(_f$canClose),
      isClosed: data.dec(_f$isClosed),
      totalMessageNum: data.dec(_f$totalMessageNum),
      lastRead: data.dec(_f$lastRead),
      canUpload: data.dec(_f$canUpload),
      position: data.dec(_f$position),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCConversationResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCConversationResult>(map);
  }

  static FCConversationResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCConversationResult>(json);
  }
}

mixin FCConversationResultMappable {
  String toJson() {
    return FCConversationResultMapper.ensureInitialized()
        .encodeJson<FCConversationResult>(this as FCConversationResult);
  }

  Map<String, dynamic> toMap() {
    return FCConversationResultMapper.ensureInitialized()
        .encodeMap<FCConversationResult>(this as FCConversationResult);
  }

  FCConversationResultCopyWith<
    FCConversationResult,
    FCConversationResult,
    FCConversationResult
  >
  get copyWith =>
      _FCConversationResultCopyWithImpl<
        FCConversationResult,
        FCConversationResult
      >(this as FCConversationResult, $identity, $identity);
  @override
  String toString() {
    return FCConversationResultMapper.ensureInitialized().stringifyValue(
      this as FCConversationResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCConversationResultMapper.ensureInitialized().equalsValue(
      this as FCConversationResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCConversationResultMapper.ensureInitialized().hashValue(
      this as FCConversationResult,
    );
  }
}

extension FCConversationResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCConversationResult, $Out> {
  FCConversationResultCopyWith<$R, FCConversationResult, $Out>
  get $asFCConversationResult => $base.as(
    (v, t, t2) => _FCConversationResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCConversationResultCopyWith<
  $R,
  $In extends FCConversationResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    FCConversationMessage,
    FCConversationMessageCopyWith<
      $R,
      FCConversationMessage,
      FCConversationMessage
    >
  >
  get messages;
  ListCopyWith<
    $R,
    FCParticipant,
    FCParticipantCopyWith<$R, FCParticipant, FCParticipant>
  >
  get participants;
  @override
  $R call({
    bool? result,
    String? resultText,
    String? convId,
    String? subject,
    String? convTitle,
    List<FCConversationMessage>? messages,
    List<FCParticipant>? participants,
    int? participantCount,
    bool? canReply,
    bool? canInvite,
    bool? canEdit,
    bool? canClose,
    bool? isClosed,
    int? totalMessageNum,
    int? lastRead,
    bool? canUpload,
    int? position,
  });
  FCConversationResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCConversationResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCConversationResult, $Out>
    implements FCConversationResultCopyWith<$R, FCConversationResult, $Out> {
  _FCConversationResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCConversationResult> $mapper =
      FCConversationResultMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    FCConversationMessage,
    FCConversationMessageCopyWith<
      $R,
      FCConversationMessage,
      FCConversationMessage
    >
  >
  get messages => ListCopyWith(
    $value.messages,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(messages: v),
  );
  @override
  ListCopyWith<
    $R,
    FCParticipant,
    FCParticipantCopyWith<$R, FCParticipant, FCParticipant>
  >
  get participants => ListCopyWith(
    $value.participants,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(participants: v),
  );
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
    String? convId,
    Object? subject = $none,
    Object? convTitle = $none,
    List<FCConversationMessage>? messages,
    List<FCParticipant>? participants,
    Object? participantCount = $none,
    Object? canReply = $none,
    Object? canInvite = $none,
    Object? canEdit = $none,
    Object? canClose = $none,
    Object? isClosed = $none,
    Object? totalMessageNum = $none,
    Object? lastRead = $none,
    Object? canUpload = $none,
    Object? position = $none,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (convId != null) #convId: convId,
      if (subject != $none) #subject: subject,
      if (convTitle != $none) #convTitle: convTitle,
      if (messages != null) #messages: messages,
      if (participants != null) #participants: participants,
      if (participantCount != $none) #participantCount: participantCount,
      if (canReply != $none) #canReply: canReply,
      if (canInvite != $none) #canInvite: canInvite,
      if (canEdit != $none) #canEdit: canEdit,
      if (canClose != $none) #canClose: canClose,
      if (isClosed != $none) #isClosed: isClosed,
      if (totalMessageNum != $none) #totalMessageNum: totalMessageNum,
      if (lastRead != $none) #lastRead: lastRead,
      if (canUpload != $none) #canUpload: canUpload,
      if (position != $none) #position: position,
    }),
  );
  @override
  FCConversationResult $make(CopyWithData data) => FCConversationResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    convId: data.get(#convId, or: $value.convId),
    subject: data.get(#subject, or: $value.subject),
    convTitle: data.get(#convTitle, or: $value.convTitle),
    messages: data.get(#messages, or: $value.messages),
    participants: data.get(#participants, or: $value.participants),
    participantCount: data.get(#participantCount, or: $value.participantCount),
    canReply: data.get(#canReply, or: $value.canReply),
    canInvite: data.get(#canInvite, or: $value.canInvite),
    canEdit: data.get(#canEdit, or: $value.canEdit),
    canClose: data.get(#canClose, or: $value.canClose),
    isClosed: data.get(#isClosed, or: $value.isClosed),
    totalMessageNum: data.get(#totalMessageNum, or: $value.totalMessageNum),
    lastRead: data.get(#lastRead, or: $value.lastRead),
    canUpload: data.get(#canUpload, or: $value.canUpload),
    position: data.get(#position, or: $value.position),
  );

  @override
  FCConversationResultCopyWith<$R2, FCConversationResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCConversationResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCConversationMessageMapper
    extends ClassMapperBase<FCConversationMessage> {
  FCConversationMessageMapper._();

  static FCConversationMessageMapper? _instance;
  static FCConversationMessageMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCConversationMessageMapper._());
      FCLikeMapper.ensureInitialized();
      FCAttachmentMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCConversationMessage';

  static String _$messageId(FCConversationMessage v) => v.messageId;
  static const Field<FCConversationMessage, String> _f$messageId = Field(
    'messageId',
    _$messageId,
  );
  static String _$userId(FCConversationMessage v) => v.userId;
  static const Field<FCConversationMessage, String> _f$userId = Field(
    'userId',
    _$userId,
  );
  static String _$username(FCConversationMessage v) => v.username;
  static const Field<FCConversationMessage, String> _f$username = Field(
    'username',
    _$username,
  );
  static String? _$iconUrl(FCConversationMessage v) => v.iconUrl;
  static const Field<FCConversationMessage, String> _f$iconUrl = Field(
    'iconUrl',
    _$iconUrl,
    opt: true,
  );
  static String _$textBody(FCConversationMessage v) => v.textBody;
  static const Field<FCConversationMessage, String> _f$textBody = Field(
    'textBody',
    _$textBody,
  );
  static String _$messageTime(FCConversationMessage v) => v.messageTime;
  static const Field<FCConversationMessage, String> _f$messageTime = Field(
    'messageTime',
    _$messageTime,
  );
  static bool? _$isFromCurrentUser(FCConversationMessage v) =>
      v.isFromCurrentUser;
  static const Field<FCConversationMessage, bool> _f$isFromCurrentUser = Field(
    'isFromCurrentUser',
    _$isFromCurrentUser,
    opt: true,
  );
  static bool _$canLike(FCConversationMessage v) => v.canLike;
  static const Field<FCConversationMessage, bool> _f$canLike = Field(
    'canLike',
    _$canLike,
    opt: true,
    def: false,
  );
  static bool _$isLiked(FCConversationMessage v) => v.isLiked;
  static const Field<FCConversationMessage, bool> _f$isLiked = Field(
    'isLiked',
    _$isLiked,
    opt: true,
    def: false,
  );
  static int _$likeCount(FCConversationMessage v) => v.likeCount;
  static const Field<FCConversationMessage, int> _f$likeCount = Field(
    'likeCount',
    _$likeCount,
    opt: true,
    def: 0,
  );
  static List<FCLike> _$likesInfo(FCConversationMessage v) => v.likesInfo;
  static const Field<FCConversationMessage, List<FCLike>> _f$likesInfo = Field(
    'likesInfo',
    _$likesInfo,
    opt: true,
    def: const [],
  );
  static List<FCAttachment> _$attachments(FCConversationMessage v) =>
      v.attachments;
  static const Field<FCConversationMessage, List<FCAttachment>> _f$attachments =
      Field('attachments', _$attachments, opt: true, def: const []);
  static bool? _$isUnread(FCConversationMessage v) => v.isUnread;
  static const Field<FCConversationMessage, bool> _f$isUnread = Field(
    'isUnread',
    _$isUnread,
    opt: true,
  );
  static bool? _$isFirstMessage(FCConversationMessage v) => v.isFirstMessage;
  static const Field<FCConversationMessage, bool> _f$isFirstMessage = Field(
    'isFirstMessage',
    _$isFirstMessage,
    opt: true,
  );
  static bool? _$canReport(FCConversationMessage v) => v.canReport;
  static const Field<FCConversationMessage, bool> _f$canReport = Field(
    'canReport',
    _$canReport,
    opt: true,
  );
  static bool? _$isIgnored(FCConversationMessage v) => v.isIgnored;
  static const Field<FCConversationMessage, bool> _f$isIgnored = Field(
    'isIgnored',
    _$isIgnored,
    opt: true,
  );
  static bool? _$canEdit(FCConversationMessage v) => v.canEdit;
  static const Field<FCConversationMessage, bool> _f$canEdit = Field(
    'canEdit',
    _$canEdit,
    opt: true,
  );
  static int? _$messageNumber(FCConversationMessage v) => v.messageNumber;
  static const Field<FCConversationMessage, int> _f$messageNumber = Field(
    'messageNumber',
    _$messageNumber,
    opt: true,
  );

  @override
  final MappableFields<FCConversationMessage> fields = const {
    #messageId: _f$messageId,
    #userId: _f$userId,
    #username: _f$username,
    #iconUrl: _f$iconUrl,
    #textBody: _f$textBody,
    #messageTime: _f$messageTime,
    #isFromCurrentUser: _f$isFromCurrentUser,
    #canLike: _f$canLike,
    #isLiked: _f$isLiked,
    #likeCount: _f$likeCount,
    #likesInfo: _f$likesInfo,
    #attachments: _f$attachments,
    #isUnread: _f$isUnread,
    #isFirstMessage: _f$isFirstMessage,
    #canReport: _f$canReport,
    #isIgnored: _f$isIgnored,
    #canEdit: _f$canEdit,
    #messageNumber: _f$messageNumber,
  };

  static FCConversationMessage _instantiate(DecodingData data) {
    return FCConversationMessage(
      messageId: data.dec(_f$messageId),
      userId: data.dec(_f$userId),
      username: data.dec(_f$username),
      iconUrl: data.dec(_f$iconUrl),
      textBody: data.dec(_f$textBody),
      messageTime: data.dec(_f$messageTime),
      isFromCurrentUser: data.dec(_f$isFromCurrentUser),
      canLike: data.dec(_f$canLike),
      isLiked: data.dec(_f$isLiked),
      likeCount: data.dec(_f$likeCount),
      likesInfo: data.dec(_f$likesInfo),
      attachments: data.dec(_f$attachments),
      isUnread: data.dec(_f$isUnread),
      isFirstMessage: data.dec(_f$isFirstMessage),
      canReport: data.dec(_f$canReport),
      isIgnored: data.dec(_f$isIgnored),
      canEdit: data.dec(_f$canEdit),
      messageNumber: data.dec(_f$messageNumber),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCConversationMessage fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCConversationMessage>(map);
  }

  static FCConversationMessage fromJson(String json) {
    return ensureInitialized().decodeJson<FCConversationMessage>(json);
  }
}

mixin FCConversationMessageMappable {
  String toJson() {
    return FCConversationMessageMapper.ensureInitialized()
        .encodeJson<FCConversationMessage>(this as FCConversationMessage);
  }

  Map<String, dynamic> toMap() {
    return FCConversationMessageMapper.ensureInitialized()
        .encodeMap<FCConversationMessage>(this as FCConversationMessage);
  }

  FCConversationMessageCopyWith<
    FCConversationMessage,
    FCConversationMessage,
    FCConversationMessage
  >
  get copyWith =>
      _FCConversationMessageCopyWithImpl<
        FCConversationMessage,
        FCConversationMessage
      >(this as FCConversationMessage, $identity, $identity);
  @override
  String toString() {
    return FCConversationMessageMapper.ensureInitialized().stringifyValue(
      this as FCConversationMessage,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCConversationMessageMapper.ensureInitialized().equalsValue(
      this as FCConversationMessage,
      other,
    );
  }

  @override
  int get hashCode {
    return FCConversationMessageMapper.ensureInitialized().hashValue(
      this as FCConversationMessage,
    );
  }
}

extension FCConversationMessageValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCConversationMessage, $Out> {
  FCConversationMessageCopyWith<$R, FCConversationMessage, $Out>
  get $asFCConversationMessage => $base.as(
    (v, t, t2) => _FCConversationMessageCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCConversationMessageCopyWith<
  $R,
  $In extends FCConversationMessage,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, FCLike, FCLikeCopyWith<$R, FCLike, FCLike>> get likesInfo;
  ListCopyWith<
    $R,
    FCAttachment,
    FCAttachmentCopyWith<$R, FCAttachment, FCAttachment>
  >
  get attachments;
  $R call({
    String? messageId,
    String? userId,
    String? username,
    String? iconUrl,
    String? textBody,
    String? messageTime,
    bool? isFromCurrentUser,
    bool? canLike,
    bool? isLiked,
    int? likeCount,
    List<FCLike>? likesInfo,
    List<FCAttachment>? attachments,
    bool? isUnread,
    bool? isFirstMessage,
    bool? canReport,
    bool? isIgnored,
    bool? canEdit,
    int? messageNumber,
  });
  FCConversationMessageCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCConversationMessageCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCConversationMessage, $Out>
    implements FCConversationMessageCopyWith<$R, FCConversationMessage, $Out> {
  _FCConversationMessageCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCConversationMessage> $mapper =
      FCConversationMessageMapper.ensureInitialized();
  @override
  ListCopyWith<$R, FCLike, FCLikeCopyWith<$R, FCLike, FCLike>> get likesInfo =>
      ListCopyWith(
        $value.likesInfo,
        (v, t) => v.copyWith.$chain(t),
        (v) => call(likesInfo: v),
      );
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
  $R call({
    String? messageId,
    String? userId,
    String? username,
    Object? iconUrl = $none,
    String? textBody,
    String? messageTime,
    Object? isFromCurrentUser = $none,
    bool? canLike,
    bool? isLiked,
    int? likeCount,
    List<FCLike>? likesInfo,
    List<FCAttachment>? attachments,
    Object? isUnread = $none,
    Object? isFirstMessage = $none,
    Object? canReport = $none,
    Object? isIgnored = $none,
    Object? canEdit = $none,
    Object? messageNumber = $none,
  }) => $apply(
    FieldCopyWithData({
      if (messageId != null) #messageId: messageId,
      if (userId != null) #userId: userId,
      if (username != null) #username: username,
      if (iconUrl != $none) #iconUrl: iconUrl,
      if (textBody != null) #textBody: textBody,
      if (messageTime != null) #messageTime: messageTime,
      if (isFromCurrentUser != $none) #isFromCurrentUser: isFromCurrentUser,
      if (canLike != null) #canLike: canLike,
      if (isLiked != null) #isLiked: isLiked,
      if (likeCount != null) #likeCount: likeCount,
      if (likesInfo != null) #likesInfo: likesInfo,
      if (attachments != null) #attachments: attachments,
      if (isUnread != $none) #isUnread: isUnread,
      if (isFirstMessage != $none) #isFirstMessage: isFirstMessage,
      if (canReport != $none) #canReport: canReport,
      if (isIgnored != $none) #isIgnored: isIgnored,
      if (canEdit != $none) #canEdit: canEdit,
      if (messageNumber != $none) #messageNumber: messageNumber,
    }),
  );
  @override
  FCConversationMessage $make(CopyWithData data) => FCConversationMessage(
    messageId: data.get(#messageId, or: $value.messageId),
    userId: data.get(#userId, or: $value.userId),
    username: data.get(#username, or: $value.username),
    iconUrl: data.get(#iconUrl, or: $value.iconUrl),
    textBody: data.get(#textBody, or: $value.textBody),
    messageTime: data.get(#messageTime, or: $value.messageTime),
    isFromCurrentUser: data.get(
      #isFromCurrentUser,
      or: $value.isFromCurrentUser,
    ),
    canLike: data.get(#canLike, or: $value.canLike),
    isLiked: data.get(#isLiked, or: $value.isLiked),
    likeCount: data.get(#likeCount, or: $value.likeCount),
    likesInfo: data.get(#likesInfo, or: $value.likesInfo),
    attachments: data.get(#attachments, or: $value.attachments),
    isUnread: data.get(#isUnread, or: $value.isUnread),
    isFirstMessage: data.get(#isFirstMessage, or: $value.isFirstMessage),
    canReport: data.get(#canReport, or: $value.canReport),
    isIgnored: data.get(#isIgnored, or: $value.isIgnored),
    canEdit: data.get(#canEdit, or: $value.canEdit),
    messageNumber: data.get(#messageNumber, or: $value.messageNumber),
  );

  @override
  FCConversationMessageCopyWith<$R2, FCConversationMessage, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCConversationMessageCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCQuoteConversationResultMapper
    extends ClassMapperBase<FCQuoteConversationResult> {
  FCQuoteConversationResultMapper._();

  static FCQuoteConversationResultMapper? _instance;
  static FCQuoteConversationResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = FCQuoteConversationResultMapper._(),
      );
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCQuoteConversationResult';

  static bool _$result(FCQuoteConversationResult v) => v.result;
  static const Field<FCQuoteConversationResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCQuoteConversationResult v) => v.resultText;
  static const Field<FCQuoteConversationResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static String? _$quoteText(FCQuoteConversationResult v) => v.quoteText;
  static const Field<FCQuoteConversationResult, String> _f$quoteText = Field(
    'quoteText',
    _$quoteText,
    opt: true,
  );
  static String? _$authorName(FCQuoteConversationResult v) => v.authorName;
  static const Field<FCQuoteConversationResult, String> _f$authorName = Field(
    'authorName',
    _$authorName,
    opt: true,
  );

  @override
  final MappableFields<FCQuoteConversationResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #quoteText: _f$quoteText,
    #authorName: _f$authorName,
  };

  static FCQuoteConversationResult _instantiate(DecodingData data) {
    return FCQuoteConversationResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      quoteText: data.dec(_f$quoteText),
      authorName: data.dec(_f$authorName),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCQuoteConversationResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCQuoteConversationResult>(map);
  }

  static FCQuoteConversationResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCQuoteConversationResult>(json);
  }
}

mixin FCQuoteConversationResultMappable {
  String toJson() {
    return FCQuoteConversationResultMapper.ensureInitialized()
        .encodeJson<FCQuoteConversationResult>(
          this as FCQuoteConversationResult,
        );
  }

  Map<String, dynamic> toMap() {
    return FCQuoteConversationResultMapper.ensureInitialized()
        .encodeMap<FCQuoteConversationResult>(
          this as FCQuoteConversationResult,
        );
  }

  FCQuoteConversationResultCopyWith<
    FCQuoteConversationResult,
    FCQuoteConversationResult,
    FCQuoteConversationResult
  >
  get copyWith =>
      _FCQuoteConversationResultCopyWithImpl<
        FCQuoteConversationResult,
        FCQuoteConversationResult
      >(this as FCQuoteConversationResult, $identity, $identity);
  @override
  String toString() {
    return FCQuoteConversationResultMapper.ensureInitialized().stringifyValue(
      this as FCQuoteConversationResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCQuoteConversationResultMapper.ensureInitialized().equalsValue(
      this as FCQuoteConversationResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCQuoteConversationResultMapper.ensureInitialized().hashValue(
      this as FCQuoteConversationResult,
    );
  }
}

extension FCQuoteConversationResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCQuoteConversationResult, $Out> {
  FCQuoteConversationResultCopyWith<$R, FCQuoteConversationResult, $Out>
  get $asFCQuoteConversationResult => $base.as(
    (v, t, t2) => _FCQuoteConversationResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCQuoteConversationResultCopyWith<
  $R,
  $In extends FCQuoteConversationResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({
    bool? result,
    String? resultText,
    String? quoteText,
    String? authorName,
  });
  FCQuoteConversationResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCQuoteConversationResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCQuoteConversationResult, $Out>
    implements
        FCQuoteConversationResultCopyWith<$R, FCQuoteConversationResult, $Out> {
  _FCQuoteConversationResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCQuoteConversationResult> $mapper =
      FCQuoteConversationResultMapper.ensureInitialized();
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
  FCQuoteConversationResult $make(CopyWithData data) =>
      FCQuoteConversationResult(
        result: data.get(#result, or: $value.result),
        resultText: data.get(#resultText, or: $value.resultText),
        quoteText: data.get(#quoteText, or: $value.quoteText),
        authorName: data.get(#authorName, or: $value.authorName),
      );

  @override
  FCQuoteConversationResultCopyWith<$R2, FCQuoteConversationResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCQuoteConversationResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCLeaveConversationResultMapper
    extends ClassMapperBase<FCLeaveConversationResult> {
  FCLeaveConversationResultMapper._();

  static FCLeaveConversationResultMapper? _instance;
  static FCLeaveConversationResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = FCLeaveConversationResultMapper._(),
      );
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCLeaveConversationResult';

  static bool _$result(FCLeaveConversationResult v) => v.result;
  static const Field<FCLeaveConversationResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCLeaveConversationResult v) => v.resultText;
  static const Field<FCLeaveConversationResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );

  @override
  final MappableFields<FCLeaveConversationResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
  };

  static FCLeaveConversationResult _instantiate(DecodingData data) {
    return FCLeaveConversationResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCLeaveConversationResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCLeaveConversationResult>(map);
  }

  static FCLeaveConversationResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCLeaveConversationResult>(json);
  }
}

mixin FCLeaveConversationResultMappable {
  String toJson() {
    return FCLeaveConversationResultMapper.ensureInitialized()
        .encodeJson<FCLeaveConversationResult>(
          this as FCLeaveConversationResult,
        );
  }

  Map<String, dynamic> toMap() {
    return FCLeaveConversationResultMapper.ensureInitialized()
        .encodeMap<FCLeaveConversationResult>(
          this as FCLeaveConversationResult,
        );
  }

  FCLeaveConversationResultCopyWith<
    FCLeaveConversationResult,
    FCLeaveConversationResult,
    FCLeaveConversationResult
  >
  get copyWith =>
      _FCLeaveConversationResultCopyWithImpl<
        FCLeaveConversationResult,
        FCLeaveConversationResult
      >(this as FCLeaveConversationResult, $identity, $identity);
  @override
  String toString() {
    return FCLeaveConversationResultMapper.ensureInitialized().stringifyValue(
      this as FCLeaveConversationResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCLeaveConversationResultMapper.ensureInitialized().equalsValue(
      this as FCLeaveConversationResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCLeaveConversationResultMapper.ensureInitialized().hashValue(
      this as FCLeaveConversationResult,
    );
  }
}

extension FCLeaveConversationResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCLeaveConversationResult, $Out> {
  FCLeaveConversationResultCopyWith<$R, FCLeaveConversationResult, $Out>
  get $asFCLeaveConversationResult => $base.as(
    (v, t, t2) => _FCLeaveConversationResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCLeaveConversationResultCopyWith<
  $R,
  $In extends FCLeaveConversationResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText});
  FCLeaveConversationResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCLeaveConversationResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCLeaveConversationResult, $Out>
    implements
        FCLeaveConversationResultCopyWith<$R, FCLeaveConversationResult, $Out> {
  _FCLeaveConversationResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCLeaveConversationResult> $mapper =
      FCLeaveConversationResultMapper.ensureInitialized();
  @override
  $R call({bool? result, Object? resultText = $none}) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
    }),
  );
  @override
  FCLeaveConversationResult $make(CopyWithData data) =>
      FCLeaveConversationResult(
        result: data.get(#result, or: $value.result),
        resultText: data.get(#resultText, or: $value.resultText),
      );

  @override
  FCLeaveConversationResultCopyWith<$R2, FCLeaveConversationResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCLeaveConversationResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCMarkConversationUnreadResultMapper
    extends ClassMapperBase<FCMarkConversationUnreadResult> {
  FCMarkConversationUnreadResultMapper._();

  static FCMarkConversationUnreadResultMapper? _instance;
  static FCMarkConversationUnreadResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = FCMarkConversationUnreadResultMapper._(),
      );
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCMarkConversationUnreadResult';

  static bool _$result(FCMarkConversationUnreadResult v) => v.result;
  static const Field<FCMarkConversationUnreadResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCMarkConversationUnreadResult v) => v.resultText;
  static const Field<FCMarkConversationUnreadResult, String> _f$resultText =
      Field('resultText', _$resultText, opt: true);

  @override
  final MappableFields<FCMarkConversationUnreadResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
  };

  static FCMarkConversationUnreadResult _instantiate(DecodingData data) {
    return FCMarkConversationUnreadResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCMarkConversationUnreadResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCMarkConversationUnreadResult>(map);
  }

  static FCMarkConversationUnreadResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCMarkConversationUnreadResult>(json);
  }
}

mixin FCMarkConversationUnreadResultMappable {
  String toJson() {
    return FCMarkConversationUnreadResultMapper.ensureInitialized()
        .encodeJson<FCMarkConversationUnreadResult>(
          this as FCMarkConversationUnreadResult,
        );
  }

  Map<String, dynamic> toMap() {
    return FCMarkConversationUnreadResultMapper.ensureInitialized()
        .encodeMap<FCMarkConversationUnreadResult>(
          this as FCMarkConversationUnreadResult,
        );
  }

  FCMarkConversationUnreadResultCopyWith<
    FCMarkConversationUnreadResult,
    FCMarkConversationUnreadResult,
    FCMarkConversationUnreadResult
  >
  get copyWith =>
      _FCMarkConversationUnreadResultCopyWithImpl<
        FCMarkConversationUnreadResult,
        FCMarkConversationUnreadResult
      >(this as FCMarkConversationUnreadResult, $identity, $identity);
  @override
  String toString() {
    return FCMarkConversationUnreadResultMapper.ensureInitialized()
        .stringifyValue(this as FCMarkConversationUnreadResult);
  }

  @override
  bool operator ==(Object other) {
    return FCMarkConversationUnreadResultMapper.ensureInitialized().equalsValue(
      this as FCMarkConversationUnreadResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCMarkConversationUnreadResultMapper.ensureInitialized().hashValue(
      this as FCMarkConversationUnreadResult,
    );
  }
}

extension FCMarkConversationUnreadResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCMarkConversationUnreadResult, $Out> {
  FCMarkConversationUnreadResultCopyWith<
    $R,
    FCMarkConversationUnreadResult,
    $Out
  >
  get $asFCMarkConversationUnreadResult => $base.as(
    (v, t, t2) =>
        _FCMarkConversationUnreadResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCMarkConversationUnreadResultCopyWith<
  $R,
  $In extends FCMarkConversationUnreadResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText});
  FCMarkConversationUnreadResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCMarkConversationUnreadResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCMarkConversationUnreadResult, $Out>
    implements
        FCMarkConversationUnreadResultCopyWith<
          $R,
          FCMarkConversationUnreadResult,
          $Out
        > {
  _FCMarkConversationUnreadResultCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<FCMarkConversationUnreadResult> $mapper =
      FCMarkConversationUnreadResultMapper.ensureInitialized();
  @override
  $R call({bool? result, Object? resultText = $none}) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
    }),
  );
  @override
  FCMarkConversationUnreadResult $make(CopyWithData data) =>
      FCMarkConversationUnreadResult(
        result: data.get(#result, or: $value.result),
        resultText: data.get(#resultText, or: $value.resultText),
      );

  @override
  FCMarkConversationUnreadResultCopyWith<
    $R2,
    FCMarkConversationUnreadResult,
    $Out2
  >
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCMarkConversationUnreadResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCMarkConversationReadResultMapper
    extends ClassMapperBase<FCMarkConversationReadResult> {
  FCMarkConversationReadResultMapper._();

  static FCMarkConversationReadResultMapper? _instance;
  static FCMarkConversationReadResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = FCMarkConversationReadResultMapper._(),
      );
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCMarkConversationReadResult';

  static bool _$result(FCMarkConversationReadResult v) => v.result;
  static const Field<FCMarkConversationReadResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCMarkConversationReadResult v) => v.resultText;
  static const Field<FCMarkConversationReadResult, String> _f$resultText =
      Field('resultText', _$resultText, opt: true);

  @override
  final MappableFields<FCMarkConversationReadResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
  };

  static FCMarkConversationReadResult _instantiate(DecodingData data) {
    return FCMarkConversationReadResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCMarkConversationReadResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCMarkConversationReadResult>(map);
  }

  static FCMarkConversationReadResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCMarkConversationReadResult>(json);
  }
}

mixin FCMarkConversationReadResultMappable {
  String toJson() {
    return FCMarkConversationReadResultMapper.ensureInitialized()
        .encodeJson<FCMarkConversationReadResult>(
          this as FCMarkConversationReadResult,
        );
  }

  Map<String, dynamic> toMap() {
    return FCMarkConversationReadResultMapper.ensureInitialized()
        .encodeMap<FCMarkConversationReadResult>(
          this as FCMarkConversationReadResult,
        );
  }

  FCMarkConversationReadResultCopyWith<
    FCMarkConversationReadResult,
    FCMarkConversationReadResult,
    FCMarkConversationReadResult
  >
  get copyWith =>
      _FCMarkConversationReadResultCopyWithImpl<
        FCMarkConversationReadResult,
        FCMarkConversationReadResult
      >(this as FCMarkConversationReadResult, $identity, $identity);
  @override
  String toString() {
    return FCMarkConversationReadResultMapper.ensureInitialized()
        .stringifyValue(this as FCMarkConversationReadResult);
  }

  @override
  bool operator ==(Object other) {
    return FCMarkConversationReadResultMapper.ensureInitialized().equalsValue(
      this as FCMarkConversationReadResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCMarkConversationReadResultMapper.ensureInitialized().hashValue(
      this as FCMarkConversationReadResult,
    );
  }
}

extension FCMarkConversationReadResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCMarkConversationReadResult, $Out> {
  FCMarkConversationReadResultCopyWith<$R, FCMarkConversationReadResult, $Out>
  get $asFCMarkConversationReadResult => $base.as(
    (v, t, t2) => _FCMarkConversationReadResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCMarkConversationReadResultCopyWith<
  $R,
  $In extends FCMarkConversationReadResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText});
  FCMarkConversationReadResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCMarkConversationReadResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCMarkConversationReadResult, $Out>
    implements
        FCMarkConversationReadResultCopyWith<
          $R,
          FCMarkConversationReadResult,
          $Out
        > {
  _FCMarkConversationReadResultCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<FCMarkConversationReadResult> $mapper =
      FCMarkConversationReadResultMapper.ensureInitialized();
  @override
  $R call({bool? result, Object? resultText = $none}) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
    }),
  );
  @override
  FCMarkConversationReadResult $make(CopyWithData data) =>
      FCMarkConversationReadResult(
        result: data.get(#result, or: $value.result),
        resultText: data.get(#resultText, or: $value.resultText),
      );

  @override
  FCMarkConversationReadResultCopyWith<$R2, FCMarkConversationReadResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCMarkConversationReadResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCCloseConversationResultMapper
    extends ClassMapperBase<FCCloseConversationResult> {
  FCCloseConversationResultMapper._();

  static FCCloseConversationResultMapper? _instance;
  static FCCloseConversationResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = FCCloseConversationResultMapper._(),
      );
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCCloseConversationResult';

  static bool _$result(FCCloseConversationResult v) => v.result;
  static const Field<FCCloseConversationResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCCloseConversationResult v) => v.resultText;
  static const Field<FCCloseConversationResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static bool _$isLoginMod(FCCloseConversationResult v) => v.isLoginMod;
  static const Field<FCCloseConversationResult, bool> _f$isLoginMod = Field(
    'isLoginMod',
    _$isLoginMod,
    opt: true,
    def: true,
  );

  @override
  final MappableFields<FCCloseConversationResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #isLoginMod: _f$isLoginMod,
  };

  static FCCloseConversationResult _instantiate(DecodingData data) {
    return FCCloseConversationResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      isLoginMod: data.dec(_f$isLoginMod),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCCloseConversationResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCCloseConversationResult>(map);
  }

  static FCCloseConversationResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCCloseConversationResult>(json);
  }
}

mixin FCCloseConversationResultMappable {
  String toJson() {
    return FCCloseConversationResultMapper.ensureInitialized()
        .encodeJson<FCCloseConversationResult>(
          this as FCCloseConversationResult,
        );
  }

  Map<String, dynamic> toMap() {
    return FCCloseConversationResultMapper.ensureInitialized()
        .encodeMap<FCCloseConversationResult>(
          this as FCCloseConversationResult,
        );
  }

  FCCloseConversationResultCopyWith<
    FCCloseConversationResult,
    FCCloseConversationResult,
    FCCloseConversationResult
  >
  get copyWith =>
      _FCCloseConversationResultCopyWithImpl<
        FCCloseConversationResult,
        FCCloseConversationResult
      >(this as FCCloseConversationResult, $identity, $identity);
  @override
  String toString() {
    return FCCloseConversationResultMapper.ensureInitialized().stringifyValue(
      this as FCCloseConversationResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCCloseConversationResultMapper.ensureInitialized().equalsValue(
      this as FCCloseConversationResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCCloseConversationResultMapper.ensureInitialized().hashValue(
      this as FCCloseConversationResult,
    );
  }
}

extension FCCloseConversationResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCCloseConversationResult, $Out> {
  FCCloseConversationResultCopyWith<$R, FCCloseConversationResult, $Out>
  get $asFCCloseConversationResult => $base.as(
    (v, t, t2) => _FCCloseConversationResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCCloseConversationResultCopyWith<
  $R,
  $In extends FCCloseConversationResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText, bool? isLoginMod});
  FCCloseConversationResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCCloseConversationResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCCloseConversationResult, $Out>
    implements
        FCCloseConversationResultCopyWith<$R, FCCloseConversationResult, $Out> {
  _FCCloseConversationResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCCloseConversationResult> $mapper =
      FCCloseConversationResultMapper.ensureInitialized();
  @override
  $R call({bool? result, Object? resultText = $none, bool? isLoginMod}) =>
      $apply(
        FieldCopyWithData({
          if (result != null) #result: result,
          if (resultText != $none) #resultText: resultText,
          if (isLoginMod != null) #isLoginMod: isLoginMod,
        }),
      );
  @override
  FCCloseConversationResult $make(CopyWithData data) =>
      FCCloseConversationResult(
        result: data.get(#result, or: $value.result),
        resultText: data.get(#resultText, or: $value.resultText),
        isLoginMod: data.get(#isLoginMod, or: $value.isLoginMod),
      );

  @override
  FCCloseConversationResultCopyWith<$R2, FCCloseConversationResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCCloseConversationResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCRawConversationResultMapper
    extends ClassMapperBase<FCRawConversationResult> {
  FCRawConversationResultMapper._();

  static FCRawConversationResultMapper? _instance;
  static FCRawConversationResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = FCRawConversationResultMapper._(),
      );
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCRawConversationResult';

  static bool _$result(FCRawConversationResult v) => v.result;
  static const Field<FCRawConversationResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCRawConversationResult v) => v.resultText;
  static const Field<FCRawConversationResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static String? _$conversationTitle(FCRawConversationResult v) =>
      v.conversationTitle;
  static const Field<FCRawConversationResult, String> _f$conversationTitle =
      Field('conversationTitle', _$conversationTitle, opt: true);
  static bool? _$openInvite(FCRawConversationResult v) => v.openInvite;
  static const Field<FCRawConversationResult, bool> _f$openInvite = Field(
    'openInvite',
    _$openInvite,
    opt: true,
  );
  static bool? _$conversationOpen(FCRawConversationResult v) =>
      v.conversationOpen;
  static const Field<FCRawConversationResult, bool> _f$conversationOpen = Field(
    'conversationOpen',
    _$conversationOpen,
    opt: true,
  );
  static bool? _$canEdit(FCRawConversationResult v) => v.canEdit;
  static const Field<FCRawConversationResult, bool> _f$canEdit = Field(
    'canEdit',
    _$canEdit,
    opt: true,
  );

  @override
  final MappableFields<FCRawConversationResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #conversationTitle: _f$conversationTitle,
    #openInvite: _f$openInvite,
    #conversationOpen: _f$conversationOpen,
    #canEdit: _f$canEdit,
  };

  static FCRawConversationResult _instantiate(DecodingData data) {
    return FCRawConversationResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      conversationTitle: data.dec(_f$conversationTitle),
      openInvite: data.dec(_f$openInvite),
      conversationOpen: data.dec(_f$conversationOpen),
      canEdit: data.dec(_f$canEdit),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCRawConversationResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCRawConversationResult>(map);
  }

  static FCRawConversationResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCRawConversationResult>(json);
  }
}

mixin FCRawConversationResultMappable {
  String toJson() {
    return FCRawConversationResultMapper.ensureInitialized()
        .encodeJson<FCRawConversationResult>(this as FCRawConversationResult);
  }

  Map<String, dynamic> toMap() {
    return FCRawConversationResultMapper.ensureInitialized()
        .encodeMap<FCRawConversationResult>(this as FCRawConversationResult);
  }

  FCRawConversationResultCopyWith<
    FCRawConversationResult,
    FCRawConversationResult,
    FCRawConversationResult
  >
  get copyWith =>
      _FCRawConversationResultCopyWithImpl<
        FCRawConversationResult,
        FCRawConversationResult
      >(this as FCRawConversationResult, $identity, $identity);
  @override
  String toString() {
    return FCRawConversationResultMapper.ensureInitialized().stringifyValue(
      this as FCRawConversationResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCRawConversationResultMapper.ensureInitialized().equalsValue(
      this as FCRawConversationResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCRawConversationResultMapper.ensureInitialized().hashValue(
      this as FCRawConversationResult,
    );
  }
}

extension FCRawConversationResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCRawConversationResult, $Out> {
  FCRawConversationResultCopyWith<$R, FCRawConversationResult, $Out>
  get $asFCRawConversationResult => $base.as(
    (v, t, t2) => _FCRawConversationResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCRawConversationResultCopyWith<
  $R,
  $In extends FCRawConversationResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({
    bool? result,
    String? resultText,
    String? conversationTitle,
    bool? openInvite,
    bool? conversationOpen,
    bool? canEdit,
  });
  FCRawConversationResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCRawConversationResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCRawConversationResult, $Out>
    implements
        FCRawConversationResultCopyWith<$R, FCRawConversationResult, $Out> {
  _FCRawConversationResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCRawConversationResult> $mapper =
      FCRawConversationResultMapper.ensureInitialized();
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
    Object? conversationTitle = $none,
    Object? openInvite = $none,
    Object? conversationOpen = $none,
    Object? canEdit = $none,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (conversationTitle != $none) #conversationTitle: conversationTitle,
      if (openInvite != $none) #openInvite: openInvite,
      if (conversationOpen != $none) #conversationOpen: conversationOpen,
      if (canEdit != $none) #canEdit: canEdit,
    }),
  );
  @override
  FCRawConversationResult $make(CopyWithData data) => FCRawConversationResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    conversationTitle: data.get(
      #conversationTitle,
      or: $value.conversationTitle,
    ),
    openInvite: data.get(#openInvite, or: $value.openInvite),
    conversationOpen: data.get(#conversationOpen, or: $value.conversationOpen),
    canEdit: data.get(#canEdit, or: $value.canEdit),
  );

  @override
  FCRawConversationResultCopyWith<$R2, FCRawConversationResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCRawConversationResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCSaveRawConversationResultMapper
    extends ClassMapperBase<FCSaveRawConversationResult> {
  FCSaveRawConversationResultMapper._();

  static FCSaveRawConversationResultMapper? _instance;
  static FCSaveRawConversationResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = FCSaveRawConversationResultMapper._(),
      );
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCSaveRawConversationResult';

  static bool _$result(FCSaveRawConversationResult v) => v.result;
  static const Field<FCSaveRawConversationResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCSaveRawConversationResult v) => v.resultText;
  static const Field<FCSaveRawConversationResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static String? _$conversationTitle(FCSaveRawConversationResult v) =>
      v.conversationTitle;
  static const Field<FCSaveRawConversationResult, String> _f$conversationTitle =
      Field('conversationTitle', _$conversationTitle, opt: true);

  @override
  final MappableFields<FCSaveRawConversationResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #conversationTitle: _f$conversationTitle,
  };

  static FCSaveRawConversationResult _instantiate(DecodingData data) {
    return FCSaveRawConversationResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      conversationTitle: data.dec(_f$conversationTitle),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCSaveRawConversationResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCSaveRawConversationResult>(map);
  }

  static FCSaveRawConversationResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCSaveRawConversationResult>(json);
  }
}

mixin FCSaveRawConversationResultMappable {
  String toJson() {
    return FCSaveRawConversationResultMapper.ensureInitialized()
        .encodeJson<FCSaveRawConversationResult>(
          this as FCSaveRawConversationResult,
        );
  }

  Map<String, dynamic> toMap() {
    return FCSaveRawConversationResultMapper.ensureInitialized()
        .encodeMap<FCSaveRawConversationResult>(
          this as FCSaveRawConversationResult,
        );
  }

  FCSaveRawConversationResultCopyWith<
    FCSaveRawConversationResult,
    FCSaveRawConversationResult,
    FCSaveRawConversationResult
  >
  get copyWith =>
      _FCSaveRawConversationResultCopyWithImpl<
        FCSaveRawConversationResult,
        FCSaveRawConversationResult
      >(this as FCSaveRawConversationResult, $identity, $identity);
  @override
  String toString() {
    return FCSaveRawConversationResultMapper.ensureInitialized().stringifyValue(
      this as FCSaveRawConversationResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCSaveRawConversationResultMapper.ensureInitialized().equalsValue(
      this as FCSaveRawConversationResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCSaveRawConversationResultMapper.ensureInitialized().hashValue(
      this as FCSaveRawConversationResult,
    );
  }
}

extension FCSaveRawConversationResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCSaveRawConversationResult, $Out> {
  FCSaveRawConversationResultCopyWith<$R, FCSaveRawConversationResult, $Out>
  get $asFCSaveRawConversationResult => $base.as(
    (v, t, t2) => _FCSaveRawConversationResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCSaveRawConversationResultCopyWith<
  $R,
  $In extends FCSaveRawConversationResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText, String? conversationTitle});
  FCSaveRawConversationResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCSaveRawConversationResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCSaveRawConversationResult, $Out>
    implements
        FCSaveRawConversationResultCopyWith<
          $R,
          FCSaveRawConversationResult,
          $Out
        > {
  _FCSaveRawConversationResultCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<FCSaveRawConversationResult> $mapper =
      FCSaveRawConversationResultMapper.ensureInitialized();
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
    Object? conversationTitle = $none,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (conversationTitle != $none) #conversationTitle: conversationTitle,
    }),
  );
  @override
  FCSaveRawConversationResult $make(CopyWithData data) =>
      FCSaveRawConversationResult(
        result: data.get(#result, or: $value.result),
        resultText: data.get(#resultText, or: $value.resultText),
        conversationTitle: data.get(
          #conversationTitle,
          or: $value.conversationTitle,
        ),
      );

  @override
  FCSaveRawConversationResultCopyWith<$R2, FCSaveRawConversationResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCSaveRawConversationResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCRawMessageResultMapper extends ClassMapperBase<FCRawMessageResult> {
  FCRawMessageResultMapper._();

  static FCRawMessageResultMapper? _instance;
  static FCRawMessageResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCRawMessageResultMapper._());
      FCBaseResultMapper.ensureInitialized();
      FCAttachmentMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCRawMessageResult';

  static bool _$result(FCRawMessageResult v) => v.result;
  static const Field<FCRawMessageResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCRawMessageResult v) => v.resultText;
  static const Field<FCRawMessageResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static String? _$messageContent(FCRawMessageResult v) => v.messageContent;
  static const Field<FCRawMessageResult, String> _f$messageContent = Field(
    'messageContent',
    _$messageContent,
    opt: true,
  );
  static List<FCAttachment>? _$attachments(FCRawMessageResult v) =>
      v.attachments;
  static const Field<FCRawMessageResult, List<FCAttachment>> _f$attachments =
      Field('attachments', _$attachments, opt: true);

  @override
  final MappableFields<FCRawMessageResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #messageContent: _f$messageContent,
    #attachments: _f$attachments,
  };

  static FCRawMessageResult _instantiate(DecodingData data) {
    return FCRawMessageResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      messageContent: data.dec(_f$messageContent),
      attachments: data.dec(_f$attachments),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCRawMessageResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCRawMessageResult>(map);
  }

  static FCRawMessageResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCRawMessageResult>(json);
  }
}

mixin FCRawMessageResultMappable {
  String toJson() {
    return FCRawMessageResultMapper.ensureInitialized()
        .encodeJson<FCRawMessageResult>(this as FCRawMessageResult);
  }

  Map<String, dynamic> toMap() {
    return FCRawMessageResultMapper.ensureInitialized()
        .encodeMap<FCRawMessageResult>(this as FCRawMessageResult);
  }

  FCRawMessageResultCopyWith<
    FCRawMessageResult,
    FCRawMessageResult,
    FCRawMessageResult
  >
  get copyWith =>
      _FCRawMessageResultCopyWithImpl<FCRawMessageResult, FCRawMessageResult>(
        this as FCRawMessageResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCRawMessageResultMapper.ensureInitialized().stringifyValue(
      this as FCRawMessageResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCRawMessageResultMapper.ensureInitialized().equalsValue(
      this as FCRawMessageResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCRawMessageResultMapper.ensureInitialized().hashValue(
      this as FCRawMessageResult,
    );
  }
}

extension FCRawMessageResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCRawMessageResult, $Out> {
  FCRawMessageResultCopyWith<$R, FCRawMessageResult, $Out>
  get $asFCRawMessageResult => $base.as(
    (v, t, t2) => _FCRawMessageResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCRawMessageResultCopyWith<
  $R,
  $In extends FCRawMessageResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    FCAttachment,
    FCAttachmentCopyWith<$R, FCAttachment, FCAttachment>
  >?
  get attachments;
  @override
  $R call({
    bool? result,
    String? resultText,
    String? messageContent,
    List<FCAttachment>? attachments,
  });
  FCRawMessageResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCRawMessageResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCRawMessageResult, $Out>
    implements FCRawMessageResultCopyWith<$R, FCRawMessageResult, $Out> {
  _FCRawMessageResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCRawMessageResult> $mapper =
      FCRawMessageResultMapper.ensureInitialized();
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
  $R call({
    bool? result,
    Object? resultText = $none,
    Object? messageContent = $none,
    Object? attachments = $none,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (messageContent != $none) #messageContent: messageContent,
      if (attachments != $none) #attachments: attachments,
    }),
  );
  @override
  FCRawMessageResult $make(CopyWithData data) => FCRawMessageResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    messageContent: data.get(#messageContent, or: $value.messageContent),
    attachments: data.get(#attachments, or: $value.attachments),
  );

  @override
  FCRawMessageResultCopyWith<$R2, FCRawMessageResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCRawMessageResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCSaveRawMessageResultMapper
    extends ClassMapperBase<FCSaveRawMessageResult> {
  FCSaveRawMessageResultMapper._();

  static FCSaveRawMessageResultMapper? _instance;
  static FCSaveRawMessageResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCSaveRawMessageResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCSaveRawMessageResult';

  static bool _$result(FCSaveRawMessageResult v) => v.result;
  static const Field<FCSaveRawMessageResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCSaveRawMessageResult v) => v.resultText;
  static const Field<FCSaveRawMessageResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static String? _$messageContent(FCSaveRawMessageResult v) => v.messageContent;
  static const Field<FCSaveRawMessageResult, String> _f$messageContent = Field(
    'messageContent',
    _$messageContent,
    opt: true,
  );

  @override
  final MappableFields<FCSaveRawMessageResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #messageContent: _f$messageContent,
  };

  static FCSaveRawMessageResult _instantiate(DecodingData data) {
    return FCSaveRawMessageResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      messageContent: data.dec(_f$messageContent),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCSaveRawMessageResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCSaveRawMessageResult>(map);
  }

  static FCSaveRawMessageResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCSaveRawMessageResult>(json);
  }
}

mixin FCSaveRawMessageResultMappable {
  String toJson() {
    return FCSaveRawMessageResultMapper.ensureInitialized()
        .encodeJson<FCSaveRawMessageResult>(this as FCSaveRawMessageResult);
  }

  Map<String, dynamic> toMap() {
    return FCSaveRawMessageResultMapper.ensureInitialized()
        .encodeMap<FCSaveRawMessageResult>(this as FCSaveRawMessageResult);
  }

  FCSaveRawMessageResultCopyWith<
    FCSaveRawMessageResult,
    FCSaveRawMessageResult,
    FCSaveRawMessageResult
  >
  get copyWith =>
      _FCSaveRawMessageResultCopyWithImpl<
        FCSaveRawMessageResult,
        FCSaveRawMessageResult
      >(this as FCSaveRawMessageResult, $identity, $identity);
  @override
  String toString() {
    return FCSaveRawMessageResultMapper.ensureInitialized().stringifyValue(
      this as FCSaveRawMessageResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCSaveRawMessageResultMapper.ensureInitialized().equalsValue(
      this as FCSaveRawMessageResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCSaveRawMessageResultMapper.ensureInitialized().hashValue(
      this as FCSaveRawMessageResult,
    );
  }
}

extension FCSaveRawMessageResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCSaveRawMessageResult, $Out> {
  FCSaveRawMessageResultCopyWith<$R, FCSaveRawMessageResult, $Out>
  get $asFCSaveRawMessageResult => $base.as(
    (v, t, t2) => _FCSaveRawMessageResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCSaveRawMessageResultCopyWith<
  $R,
  $In extends FCSaveRawMessageResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText, String? messageContent});
  FCSaveRawMessageResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCSaveRawMessageResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCSaveRawMessageResult, $Out>
    implements
        FCSaveRawMessageResultCopyWith<$R, FCSaveRawMessageResult, $Out> {
  _FCSaveRawMessageResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCSaveRawMessageResult> $mapper =
      FCSaveRawMessageResultMapper.ensureInitialized();
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
    Object? messageContent = $none,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (messageContent != $none) #messageContent: messageContent,
    }),
  );
  @override
  FCSaveRawMessageResult $make(CopyWithData data) => FCSaveRawMessageResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    messageContent: data.get(#messageContent, or: $value.messageContent),
  );

  @override
  FCSaveRawMessageResultCopyWith<$R2, FCSaveRawMessageResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCSaveRawMessageResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

