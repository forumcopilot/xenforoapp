// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fc_device_result.dart';

class FCDeviceResultMapper extends ClassMapperBase<FCDeviceResult> {
  FCDeviceResultMapper._();

  static FCDeviceResultMapper? _instance;
  static FCDeviceResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCDeviceResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCDeviceResult';

  static bool _$result(FCDeviceResult v) => v.result;
  static const Field<FCDeviceResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCDeviceResult v) => v.resultText;
  static const Field<FCDeviceResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static String? _$deviceId(FCDeviceResult v) => v.deviceId;
  static const Field<FCDeviceResult, String> _f$deviceId = Field(
    'deviceId',
    _$deviceId,
    opt: true,
  );

  @override
  final MappableFields<FCDeviceResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #deviceId: _f$deviceId,
  };

  static FCDeviceResult _instantiate(DecodingData data) {
    return FCDeviceResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      deviceId: data.dec(_f$deviceId),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCDeviceResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCDeviceResult>(map);
  }

  static FCDeviceResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCDeviceResult>(json);
  }
}

mixin FCDeviceResultMappable {
  String toJson() {
    return FCDeviceResultMapper.ensureInitialized().encodeJson<FCDeviceResult>(
      this as FCDeviceResult,
    );
  }

  Map<String, dynamic> toMap() {
    return FCDeviceResultMapper.ensureInitialized().encodeMap<FCDeviceResult>(
      this as FCDeviceResult,
    );
  }

  FCDeviceResultCopyWith<FCDeviceResult, FCDeviceResult, FCDeviceResult>
  get copyWith => _FCDeviceResultCopyWithImpl<FCDeviceResult, FCDeviceResult>(
    this as FCDeviceResult,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return FCDeviceResultMapper.ensureInitialized().stringifyValue(
      this as FCDeviceResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCDeviceResultMapper.ensureInitialized().equalsValue(
      this as FCDeviceResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCDeviceResultMapper.ensureInitialized().hashValue(
      this as FCDeviceResult,
    );
  }
}

extension FCDeviceResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCDeviceResult, $Out> {
  FCDeviceResultCopyWith<$R, FCDeviceResult, $Out> get $asFCDeviceResult =>
      $base.as((v, t, t2) => _FCDeviceResultCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCDeviceResultCopyWith<$R, $In extends FCDeviceResult, $Out>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText, String? deviceId});
  FCDeviceResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCDeviceResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCDeviceResult, $Out>
    implements FCDeviceResultCopyWith<$R, FCDeviceResult, $Out> {
  _FCDeviceResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCDeviceResult> $mapper =
      FCDeviceResultMapper.ensureInitialized();
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
    Object? deviceId = $none,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (deviceId != $none) #deviceId: deviceId,
    }),
  );
  @override
  FCDeviceResult $make(CopyWithData data) => FCDeviceResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    deviceId: data.get(#deviceId, or: $value.deviceId),
  );

  @override
  FCDeviceResultCopyWith<$R2, FCDeviceResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCDeviceResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

