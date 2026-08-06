// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fc_notification_result.dart';

class FCNotificationLevelResultMapper
    extends ClassMapperBase<FCNotificationLevelResult> {
  FCNotificationLevelResultMapper._();

  static FCNotificationLevelResultMapper? _instance;
  static FCNotificationLevelResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = FCNotificationLevelResultMapper._(),
      );
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCNotificationLevelResult';

  static bool _$result(FCNotificationLevelResult v) => v.result;
  static const Field<FCNotificationLevelResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCNotificationLevelResult v) => v.resultText;
  static const Field<FCNotificationLevelResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static FCNotificationLevel? _$level(FCNotificationLevelResult v) => v.level;
  static const Field<FCNotificationLevelResult, FCNotificationLevel> _f$level =
      Field('level', _$level, opt: true);

  @override
  final MappableFields<FCNotificationLevelResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #level: _f$level,
  };

  static FCNotificationLevelResult _instantiate(DecodingData data) {
    return FCNotificationLevelResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      level: data.dec(_f$level),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCNotificationLevelResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCNotificationLevelResult>(map);
  }

  static FCNotificationLevelResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCNotificationLevelResult>(json);
  }
}

mixin FCNotificationLevelResultMappable {
  String toJson() {
    return FCNotificationLevelResultMapper.ensureInitialized()
        .encodeJson<FCNotificationLevelResult>(
          this as FCNotificationLevelResult,
        );
  }

  Map<String, dynamic> toMap() {
    return FCNotificationLevelResultMapper.ensureInitialized()
        .encodeMap<FCNotificationLevelResult>(
          this as FCNotificationLevelResult,
        );
  }

  FCNotificationLevelResultCopyWith<
    FCNotificationLevelResult,
    FCNotificationLevelResult,
    FCNotificationLevelResult
  >
  get copyWith =>
      _FCNotificationLevelResultCopyWithImpl<
        FCNotificationLevelResult,
        FCNotificationLevelResult
      >(this as FCNotificationLevelResult, $identity, $identity);
  @override
  String toString() {
    return FCNotificationLevelResultMapper.ensureInitialized().stringifyValue(
      this as FCNotificationLevelResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCNotificationLevelResultMapper.ensureInitialized().equalsValue(
      this as FCNotificationLevelResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCNotificationLevelResultMapper.ensureInitialized().hashValue(
      this as FCNotificationLevelResult,
    );
  }
}

extension FCNotificationLevelResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCNotificationLevelResult, $Out> {
  FCNotificationLevelResultCopyWith<$R, FCNotificationLevelResult, $Out>
  get $asFCNotificationLevelResult => $base.as(
    (v, t, t2) => _FCNotificationLevelResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCNotificationLevelResultCopyWith<
  $R,
  $In extends FCNotificationLevelResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText, FCNotificationLevel? level});
  FCNotificationLevelResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCNotificationLevelResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCNotificationLevelResult, $Out>
    implements
        FCNotificationLevelResultCopyWith<$R, FCNotificationLevelResult, $Out> {
  _FCNotificationLevelResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCNotificationLevelResult> $mapper =
      FCNotificationLevelResultMapper.ensureInitialized();
  @override
  $R call({bool? result, Object? resultText = $none, Object? level = $none}) =>
      $apply(
        FieldCopyWithData({
          if (result != null) #result: result,
          if (resultText != $none) #resultText: resultText,
          if (level != $none) #level: level,
        }),
      );
  @override
  FCNotificationLevelResult $make(CopyWithData data) =>
      FCNotificationLevelResult(
        result: data.get(#result, or: $value.result),
        resultText: data.get(#resultText, or: $value.resultText),
        level: data.get(#level, or: $value.level),
      );

  @override
  FCNotificationLevelResultCopyWith<$R2, FCNotificationLevelResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCNotificationLevelResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCNotificationPrefsResultMapper
    extends ClassMapperBase<FCNotificationPrefsResult> {
  FCNotificationPrefsResultMapper._();

  static FCNotificationPrefsResultMapper? _instance;
  static FCNotificationPrefsResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = FCNotificationPrefsResultMapper._(),
      );
      FCBaseResultMapper.ensureInitialized();
      FCNotificationPrefsMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCNotificationPrefsResult';

  static bool _$result(FCNotificationPrefsResult v) => v.result;
  static const Field<FCNotificationPrefsResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCNotificationPrefsResult v) => v.resultText;
  static const Field<FCNotificationPrefsResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static FCNotificationPrefs? _$prefs(FCNotificationPrefsResult v) => v.prefs;
  static const Field<FCNotificationPrefsResult, FCNotificationPrefs> _f$prefs =
      Field('prefs', _$prefs, opt: true);

  @override
  final MappableFields<FCNotificationPrefsResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #prefs: _f$prefs,
  };

  static FCNotificationPrefsResult _instantiate(DecodingData data) {
    return FCNotificationPrefsResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      prefs: data.dec(_f$prefs),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCNotificationPrefsResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCNotificationPrefsResult>(map);
  }

  static FCNotificationPrefsResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCNotificationPrefsResult>(json);
  }
}

mixin FCNotificationPrefsResultMappable {
  String toJson() {
    return FCNotificationPrefsResultMapper.ensureInitialized()
        .encodeJson<FCNotificationPrefsResult>(
          this as FCNotificationPrefsResult,
        );
  }

  Map<String, dynamic> toMap() {
    return FCNotificationPrefsResultMapper.ensureInitialized()
        .encodeMap<FCNotificationPrefsResult>(
          this as FCNotificationPrefsResult,
        );
  }

  FCNotificationPrefsResultCopyWith<
    FCNotificationPrefsResult,
    FCNotificationPrefsResult,
    FCNotificationPrefsResult
  >
  get copyWith =>
      _FCNotificationPrefsResultCopyWithImpl<
        FCNotificationPrefsResult,
        FCNotificationPrefsResult
      >(this as FCNotificationPrefsResult, $identity, $identity);
  @override
  String toString() {
    return FCNotificationPrefsResultMapper.ensureInitialized().stringifyValue(
      this as FCNotificationPrefsResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCNotificationPrefsResultMapper.ensureInitialized().equalsValue(
      this as FCNotificationPrefsResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCNotificationPrefsResultMapper.ensureInitialized().hashValue(
      this as FCNotificationPrefsResult,
    );
  }
}

extension FCNotificationPrefsResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCNotificationPrefsResult, $Out> {
  FCNotificationPrefsResultCopyWith<$R, FCNotificationPrefsResult, $Out>
  get $asFCNotificationPrefsResult => $base.as(
    (v, t, t2) => _FCNotificationPrefsResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCNotificationPrefsResultCopyWith<
  $R,
  $In extends FCNotificationPrefsResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  FCNotificationPrefsCopyWith<$R, FCNotificationPrefs, FCNotificationPrefs>?
  get prefs;
  @override
  $R call({bool? result, String? resultText, FCNotificationPrefs? prefs});
  FCNotificationPrefsResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCNotificationPrefsResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCNotificationPrefsResult, $Out>
    implements
        FCNotificationPrefsResultCopyWith<$R, FCNotificationPrefsResult, $Out> {
  _FCNotificationPrefsResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCNotificationPrefsResult> $mapper =
      FCNotificationPrefsResultMapper.ensureInitialized();
  @override
  FCNotificationPrefsCopyWith<$R, FCNotificationPrefs, FCNotificationPrefs>?
  get prefs => $value.prefs?.copyWith.$chain((v) => call(prefs: v));
  @override
  $R call({bool? result, Object? resultText = $none, Object? prefs = $none}) =>
      $apply(
        FieldCopyWithData({
          if (result != null) #result: result,
          if (resultText != $none) #resultText: resultText,
          if (prefs != $none) #prefs: prefs,
        }),
      );
  @override
  FCNotificationPrefsResult $make(CopyWithData data) =>
      FCNotificationPrefsResult(
        result: data.get(#result, or: $value.result),
        resultText: data.get(#resultText, or: $value.resultText),
        prefs: data.get(#prefs, or: $value.prefs),
      );

  @override
  FCNotificationPrefsResultCopyWith<$R2, FCNotificationPrefsResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCNotificationPrefsResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

