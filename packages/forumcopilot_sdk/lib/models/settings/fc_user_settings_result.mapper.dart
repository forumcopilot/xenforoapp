// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fc_user_settings_result.dart';

class FCUserSettingsCategoriesResultMapper
    extends ClassMapperBase<FCUserSettingsCategoriesResult> {
  FCUserSettingsCategoriesResultMapper._();

  static FCUserSettingsCategoriesResultMapper? _instance;
  static FCUserSettingsCategoriesResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = FCUserSettingsCategoriesResultMapper._(),
      );
      FCBaseResultMapper.ensureInitialized();
      FCSettingsCategoryMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCUserSettingsCategoriesResult';

  static bool _$result(FCUserSettingsCategoriesResult v) => v.result;
  static const Field<FCUserSettingsCategoriesResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCUserSettingsCategoriesResult v) => v.resultText;
  static const Field<FCUserSettingsCategoriesResult, String> _f$resultText =
      Field('resultText', _$resultText, opt: true);
  static List<FCSettingsCategory> _$categories(
    FCUserSettingsCategoriesResult v,
  ) => v.categories;
  static const Field<FCUserSettingsCategoriesResult, List<FCSettingsCategory>>
  _f$categories = Field('categories', _$categories, opt: true, def: const []);

  @override
  final MappableFields<FCUserSettingsCategoriesResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #categories: _f$categories,
  };

  static FCUserSettingsCategoriesResult _instantiate(DecodingData data) {
    return FCUserSettingsCategoriesResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      categories: data.dec(_f$categories),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCUserSettingsCategoriesResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCUserSettingsCategoriesResult>(map);
  }

  static FCUserSettingsCategoriesResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCUserSettingsCategoriesResult>(json);
  }
}

mixin FCUserSettingsCategoriesResultMappable {
  String toJson() {
    return FCUserSettingsCategoriesResultMapper.ensureInitialized()
        .encodeJson<FCUserSettingsCategoriesResult>(
          this as FCUserSettingsCategoriesResult,
        );
  }

  Map<String, dynamic> toMap() {
    return FCUserSettingsCategoriesResultMapper.ensureInitialized()
        .encodeMap<FCUserSettingsCategoriesResult>(
          this as FCUserSettingsCategoriesResult,
        );
  }

  FCUserSettingsCategoriesResultCopyWith<
    FCUserSettingsCategoriesResult,
    FCUserSettingsCategoriesResult,
    FCUserSettingsCategoriesResult
  >
  get copyWith =>
      _FCUserSettingsCategoriesResultCopyWithImpl<
        FCUserSettingsCategoriesResult,
        FCUserSettingsCategoriesResult
      >(this as FCUserSettingsCategoriesResult, $identity, $identity);
  @override
  String toString() {
    return FCUserSettingsCategoriesResultMapper.ensureInitialized()
        .stringifyValue(this as FCUserSettingsCategoriesResult);
  }

  @override
  bool operator ==(Object other) {
    return FCUserSettingsCategoriesResultMapper.ensureInitialized().equalsValue(
      this as FCUserSettingsCategoriesResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCUserSettingsCategoriesResultMapper.ensureInitialized().hashValue(
      this as FCUserSettingsCategoriesResult,
    );
  }
}

extension FCUserSettingsCategoriesResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCUserSettingsCategoriesResult, $Out> {
  FCUserSettingsCategoriesResultCopyWith<
    $R,
    FCUserSettingsCategoriesResult,
    $Out
  >
  get $asFCUserSettingsCategoriesResult => $base.as(
    (v, t, t2) =>
        _FCUserSettingsCategoriesResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCUserSettingsCategoriesResultCopyWith<
  $R,
  $In extends FCUserSettingsCategoriesResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    FCSettingsCategory,
    FCSettingsCategoryCopyWith<$R, FCSettingsCategory, FCSettingsCategory>
  >
  get categories;
  @override
  $R call({
    bool? result,
    String? resultText,
    List<FCSettingsCategory>? categories,
  });
  FCUserSettingsCategoriesResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCUserSettingsCategoriesResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCUserSettingsCategoriesResult, $Out>
    implements
        FCUserSettingsCategoriesResultCopyWith<
          $R,
          FCUserSettingsCategoriesResult,
          $Out
        > {
  _FCUserSettingsCategoriesResultCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<FCUserSettingsCategoriesResult> $mapper =
      FCUserSettingsCategoriesResultMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    FCSettingsCategory,
    FCSettingsCategoryCopyWith<$R, FCSettingsCategory, FCSettingsCategory>
  >
  get categories => ListCopyWith(
    $value.categories,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(categories: v),
  );
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
    List<FCSettingsCategory>? categories,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (categories != null) #categories: categories,
    }),
  );
  @override
  FCUserSettingsCategoriesResult $make(CopyWithData data) =>
      FCUserSettingsCategoriesResult(
        result: data.get(#result, or: $value.result),
        resultText: data.get(#resultText, or: $value.resultText),
        categories: data.get(#categories, or: $value.categories),
      );

  @override
  FCUserSettingsCategoriesResultCopyWith<
    $R2,
    FCUserSettingsCategoriesResult,
    $Out2
  >
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCUserSettingsCategoriesResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCUserSettingsResultMapper extends ClassMapperBase<FCUserSettingsResult> {
  FCUserSettingsResultMapper._();

  static FCUserSettingsResultMapper? _instance;
  static FCUserSettingsResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCUserSettingsResultMapper._());
      FCBaseResultMapper.ensureInitialized();
      FCUserSettingMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCUserSettingsResult';

  static bool _$result(FCUserSettingsResult v) => v.result;
  static const Field<FCUserSettingsResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCUserSettingsResult v) => v.resultText;
  static const Field<FCUserSettingsResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static String _$category(FCUserSettingsResult v) => v.category;
  static const Field<FCUserSettingsResult, String> _f$category = Field(
    'category',
    _$category,
  );
  static bool _$enabled(FCUserSettingsResult v) => v.enabled;
  static const Field<FCUserSettingsResult, bool> _f$enabled = Field(
    'enabled',
    _$enabled,
  );
  static List<FCUserSetting> _$settings(FCUserSettingsResult v) => v.settings;
  static const Field<FCUserSettingsResult, List<FCUserSetting>> _f$settings =
      Field('settings', _$settings, opt: true, def: const []);

  @override
  final MappableFields<FCUserSettingsResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #category: _f$category,
    #enabled: _f$enabled,
    #settings: _f$settings,
  };

  static FCUserSettingsResult _instantiate(DecodingData data) {
    return FCUserSettingsResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      category: data.dec(_f$category),
      enabled: data.dec(_f$enabled),
      settings: data.dec(_f$settings),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCUserSettingsResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCUserSettingsResult>(map);
  }

  static FCUserSettingsResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCUserSettingsResult>(json);
  }
}

mixin FCUserSettingsResultMappable {
  String toJson() {
    return FCUserSettingsResultMapper.ensureInitialized()
        .encodeJson<FCUserSettingsResult>(this as FCUserSettingsResult);
  }

  Map<String, dynamic> toMap() {
    return FCUserSettingsResultMapper.ensureInitialized()
        .encodeMap<FCUserSettingsResult>(this as FCUserSettingsResult);
  }

  FCUserSettingsResultCopyWith<
    FCUserSettingsResult,
    FCUserSettingsResult,
    FCUserSettingsResult
  >
  get copyWith =>
      _FCUserSettingsResultCopyWithImpl<
        FCUserSettingsResult,
        FCUserSettingsResult
      >(this as FCUserSettingsResult, $identity, $identity);
  @override
  String toString() {
    return FCUserSettingsResultMapper.ensureInitialized().stringifyValue(
      this as FCUserSettingsResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCUserSettingsResultMapper.ensureInitialized().equalsValue(
      this as FCUserSettingsResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCUserSettingsResultMapper.ensureInitialized().hashValue(
      this as FCUserSettingsResult,
    );
  }
}

extension FCUserSettingsResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCUserSettingsResult, $Out> {
  FCUserSettingsResultCopyWith<$R, FCUserSettingsResult, $Out>
  get $asFCUserSettingsResult => $base.as(
    (v, t, t2) => _FCUserSettingsResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCUserSettingsResultCopyWith<
  $R,
  $In extends FCUserSettingsResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    FCUserSetting,
    FCUserSettingCopyWith<$R, FCUserSetting, FCUserSetting>
  >
  get settings;
  @override
  $R call({
    bool? result,
    String? resultText,
    String? category,
    bool? enabled,
    List<FCUserSetting>? settings,
  });
  FCUserSettingsResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCUserSettingsResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCUserSettingsResult, $Out>
    implements FCUserSettingsResultCopyWith<$R, FCUserSettingsResult, $Out> {
  _FCUserSettingsResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCUserSettingsResult> $mapper =
      FCUserSettingsResultMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    FCUserSetting,
    FCUserSettingCopyWith<$R, FCUserSetting, FCUserSetting>
  >
  get settings => ListCopyWith(
    $value.settings,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(settings: v),
  );
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
    String? category,
    bool? enabled,
    List<FCUserSetting>? settings,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (category != null) #category: category,
      if (enabled != null) #enabled: enabled,
      if (settings != null) #settings: settings,
    }),
  );
  @override
  FCUserSettingsResult $make(CopyWithData data) => FCUserSettingsResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    category: data.get(#category, or: $value.category),
    enabled: data.get(#enabled, or: $value.enabled),
    settings: data.get(#settings, or: $value.settings),
  );

  @override
  FCUserSettingsResultCopyWith<$R2, FCUserSettingsResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCUserSettingsResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

