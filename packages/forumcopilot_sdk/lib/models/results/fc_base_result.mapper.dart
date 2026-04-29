// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fc_base_result.dart';

class FCBaseResultMapper extends ClassMapperBase<FCBaseResult> {
  FCBaseResultMapper._();

  static FCBaseResultMapper? _instance;
  static FCBaseResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCBaseResultMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FCBaseResult';

  static bool _$result(FCBaseResult v) => v.result;
  static const Field<FCBaseResult, bool> _f$result = Field('result', _$result);
  static String? _$resultText(FCBaseResult v) => v.resultText;
  static const Field<FCBaseResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );

  @override
  final MappableFields<FCBaseResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
  };

  static FCBaseResult _instantiate(DecodingData data) {
    throw MapperException.missingConstructor('FCBaseResult');
  }

  @override
  final Function instantiate = _instantiate;

  static FCBaseResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCBaseResult>(map);
  }

  static FCBaseResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCBaseResult>(json);
  }
}

mixin FCBaseResultMappable {
  String toJson();
  Map<String, dynamic> toMap();
  FCBaseResultCopyWith<FCBaseResult, FCBaseResult, FCBaseResult> get copyWith;
}

abstract class FCBaseResultCopyWith<$R, $In extends FCBaseResult, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({bool? result, String? resultText});
  FCBaseResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

