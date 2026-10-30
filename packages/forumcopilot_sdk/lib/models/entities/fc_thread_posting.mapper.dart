// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fc_thread_posting.dart';

class FCThreadPostingOptionsMapper
    extends ClassMapperBase<FCThreadPostingOptions> {
  FCThreadPostingOptionsMapper._();

  static FCThreadPostingOptionsMapper? _instance;
  static FCThreadPostingOptionsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCThreadPostingOptionsMapper._());
      FCThreadFieldMapper.ensureInitialized();
      FCThreadTypeOptionMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCThreadPostingOptions';

  static String _$forumType(FCThreadPostingOptions v) => v.forumType;
  static const Field<FCThreadPostingOptions, String> _f$forumType = Field(
    'forumType',
    _$forumType,
    opt: true,
    def: 'discussion',
  );
  static bool _$canTag(FCThreadPostingOptions v) => v.canTag;
  static const Field<FCThreadPostingOptions, bool> _f$canTag = Field(
    'canTag',
    _$canTag,
    opt: true,
    def: false,
  );
  static int _$minTags(FCThreadPostingOptions v) => v.minTags;
  static const Field<FCThreadPostingOptions, int> _f$minTags = Field(
    'minTags',
    _$minTags,
    opt: true,
    def: 0,
  );
  static List<FCThreadField> _$threadFields(FCThreadPostingOptions v) =>
      v.threadFields;
  static const Field<FCThreadPostingOptions, List<FCThreadField>>
  _f$threadFields = Field(
    'threadFields',
    _$threadFields,
    opt: true,
    def: const [],
  );
  static List<FCThreadTypeOption> _$threadTypes(FCThreadPostingOptions v) =>
      v.threadTypes;
  static const Field<FCThreadPostingOptions, List<FCThreadTypeOption>>
  _f$threadTypes = Field(
    'threadTypes',
    _$threadTypes,
    opt: true,
    def: const [],
  );
  static String _$defaultThreadType(FCThreadPostingOptions v) =>
      v.defaultThreadType;
  static const Field<FCThreadPostingOptions, String> _f$defaultThreadType =
      Field(
        'defaultThreadType',
        _$defaultThreadType,
        opt: true,
        def: 'discussion',
      );
  static bool _$canCreatePoll(FCThreadPostingOptions v) => v.canCreatePoll;
  static const Field<FCThreadPostingOptions, bool> _f$canCreatePoll = Field(
    'canCreatePoll',
    _$canCreatePoll,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<FCThreadPostingOptions> fields = const {
    #forumType: _f$forumType,
    #canTag: _f$canTag,
    #minTags: _f$minTags,
    #threadFields: _f$threadFields,
    #threadTypes: _f$threadTypes,
    #defaultThreadType: _f$defaultThreadType,
    #canCreatePoll: _f$canCreatePoll,
  };

  static FCThreadPostingOptions _instantiate(DecodingData data) {
    return FCThreadPostingOptions(
      forumType: data.dec(_f$forumType),
      canTag: data.dec(_f$canTag),
      minTags: data.dec(_f$minTags),
      threadFields: data.dec(_f$threadFields),
      threadTypes: data.dec(_f$threadTypes),
      defaultThreadType: data.dec(_f$defaultThreadType),
      canCreatePoll: data.dec(_f$canCreatePoll),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCThreadPostingOptions fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCThreadPostingOptions>(map);
  }

  static FCThreadPostingOptions fromJson(String json) {
    return ensureInitialized().decodeJson<FCThreadPostingOptions>(json);
  }
}

mixin FCThreadPostingOptionsMappable {
  String toJson() {
    return FCThreadPostingOptionsMapper.ensureInitialized()
        .encodeJson<FCThreadPostingOptions>(this as FCThreadPostingOptions);
  }

  Map<String, dynamic> toMap() {
    return FCThreadPostingOptionsMapper.ensureInitialized()
        .encodeMap<FCThreadPostingOptions>(this as FCThreadPostingOptions);
  }

  FCThreadPostingOptionsCopyWith<
    FCThreadPostingOptions,
    FCThreadPostingOptions,
    FCThreadPostingOptions
  >
  get copyWith =>
      _FCThreadPostingOptionsCopyWithImpl<
        FCThreadPostingOptions,
        FCThreadPostingOptions
      >(this as FCThreadPostingOptions, $identity, $identity);
  @override
  String toString() {
    return FCThreadPostingOptionsMapper.ensureInitialized().stringifyValue(
      this as FCThreadPostingOptions,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCThreadPostingOptionsMapper.ensureInitialized().equalsValue(
      this as FCThreadPostingOptions,
      other,
    );
  }

  @override
  int get hashCode {
    return FCThreadPostingOptionsMapper.ensureInitialized().hashValue(
      this as FCThreadPostingOptions,
    );
  }
}

extension FCThreadPostingOptionsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCThreadPostingOptions, $Out> {
  FCThreadPostingOptionsCopyWith<$R, FCThreadPostingOptions, $Out>
  get $asFCThreadPostingOptions => $base.as(
    (v, t, t2) => _FCThreadPostingOptionsCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCThreadPostingOptionsCopyWith<
  $R,
  $In extends FCThreadPostingOptions,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    FCThreadField,
    FCThreadFieldCopyWith<$R, FCThreadField, FCThreadField>
  >
  get threadFields;
  ListCopyWith<
    $R,
    FCThreadTypeOption,
    FCThreadTypeOptionCopyWith<$R, FCThreadTypeOption, FCThreadTypeOption>
  >
  get threadTypes;
  $R call({
    String? forumType,
    bool? canTag,
    int? minTags,
    List<FCThreadField>? threadFields,
    List<FCThreadTypeOption>? threadTypes,
    String? defaultThreadType,
    bool? canCreatePoll,
  });
  FCThreadPostingOptionsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCThreadPostingOptionsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCThreadPostingOptions, $Out>
    implements
        FCThreadPostingOptionsCopyWith<$R, FCThreadPostingOptions, $Out> {
  _FCThreadPostingOptionsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCThreadPostingOptions> $mapper =
      FCThreadPostingOptionsMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    FCThreadField,
    FCThreadFieldCopyWith<$R, FCThreadField, FCThreadField>
  >
  get threadFields => ListCopyWith(
    $value.threadFields,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(threadFields: v),
  );
  @override
  ListCopyWith<
    $R,
    FCThreadTypeOption,
    FCThreadTypeOptionCopyWith<$R, FCThreadTypeOption, FCThreadTypeOption>
  >
  get threadTypes => ListCopyWith(
    $value.threadTypes,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(threadTypes: v),
  );
  @override
  $R call({
    String? forumType,
    bool? canTag,
    int? minTags,
    List<FCThreadField>? threadFields,
    List<FCThreadTypeOption>? threadTypes,
    String? defaultThreadType,
    bool? canCreatePoll,
  }) => $apply(
    FieldCopyWithData({
      if (forumType != null) #forumType: forumType,
      if (canTag != null) #canTag: canTag,
      if (minTags != null) #minTags: minTags,
      if (threadFields != null) #threadFields: threadFields,
      if (threadTypes != null) #threadTypes: threadTypes,
      if (defaultThreadType != null) #defaultThreadType: defaultThreadType,
      if (canCreatePoll != null) #canCreatePoll: canCreatePoll,
    }),
  );
  @override
  FCThreadPostingOptions $make(CopyWithData data) => FCThreadPostingOptions(
    forumType: data.get(#forumType, or: $value.forumType),
    canTag: data.get(#canTag, or: $value.canTag),
    minTags: data.get(#minTags, or: $value.minTags),
    threadFields: data.get(#threadFields, or: $value.threadFields),
    threadTypes: data.get(#threadTypes, or: $value.threadTypes),
    defaultThreadType: data.get(
      #defaultThreadType,
      or: $value.defaultThreadType,
    ),
    canCreatePoll: data.get(#canCreatePoll, or: $value.canCreatePoll),
  );

  @override
  FCThreadPostingOptionsCopyWith<$R2, FCThreadPostingOptions, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCThreadPostingOptionsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCThreadFieldMapper extends ClassMapperBase<FCThreadField> {
  FCThreadFieldMapper._();

  static FCThreadFieldMapper? _instance;
  static FCThreadFieldMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCThreadFieldMapper._());
      FCFieldChoiceMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCThreadField';

  static String _$id(FCThreadField v) => v.id;
  static const Field<FCThreadField, String> _f$id = Field('id', _$id);
  static String _$title(FCThreadField v) => v.title;
  static const Field<FCThreadField, String> _f$title = Field('title', _$title);
  static String _$description(FCThreadField v) => v.description;
  static const Field<FCThreadField, String> _f$description = Field(
    'description',
    _$description,
    opt: true,
    def: '',
  );
  static String _$type(FCThreadField v) => v.type;
  static const Field<FCThreadField, String> _f$type = Field(
    'type',
    _$type,
    opt: true,
    def: 'textbox',
  );
  static bool _$required(FCThreadField v) => v.required;
  static const Field<FCThreadField, bool> _f$required = Field(
    'required',
    _$required,
    opt: true,
    def: false,
  );
  static List<FCFieldChoice> _$choices(FCThreadField v) => v.choices;
  static const Field<FCThreadField, List<FCFieldChoice>> _f$choices = Field(
    'choices',
    _$choices,
    opt: true,
    def: const [],
  );
  static String _$group(FCThreadField v) => v.group;
  static const Field<FCThreadField, String> _f$group = Field(
    'group',
    _$group,
    opt: true,
    def: '',
  );
  static int _$maxLength(FCThreadField v) => v.maxLength;
  static const Field<FCThreadField, int> _f$maxLength = Field(
    'maxLength',
    _$maxLength,
    opt: true,
    def: 0,
  );

  @override
  final MappableFields<FCThreadField> fields = const {
    #id: _f$id,
    #title: _f$title,
    #description: _f$description,
    #type: _f$type,
    #required: _f$required,
    #choices: _f$choices,
    #group: _f$group,
    #maxLength: _f$maxLength,
  };

  static FCThreadField _instantiate(DecodingData data) {
    return FCThreadField(
      id: data.dec(_f$id),
      title: data.dec(_f$title),
      description: data.dec(_f$description),
      type: data.dec(_f$type),
      required: data.dec(_f$required),
      choices: data.dec(_f$choices),
      group: data.dec(_f$group),
      maxLength: data.dec(_f$maxLength),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCThreadField fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCThreadField>(map);
  }

  static FCThreadField fromJson(String json) {
    return ensureInitialized().decodeJson<FCThreadField>(json);
  }
}

mixin FCThreadFieldMappable {
  String toJson() {
    return FCThreadFieldMapper.ensureInitialized().encodeJson<FCThreadField>(
      this as FCThreadField,
    );
  }

  Map<String, dynamic> toMap() {
    return FCThreadFieldMapper.ensureInitialized().encodeMap<FCThreadField>(
      this as FCThreadField,
    );
  }

  FCThreadFieldCopyWith<FCThreadField, FCThreadField, FCThreadField>
  get copyWith => _FCThreadFieldCopyWithImpl<FCThreadField, FCThreadField>(
    this as FCThreadField,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return FCThreadFieldMapper.ensureInitialized().stringifyValue(
      this as FCThreadField,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCThreadFieldMapper.ensureInitialized().equalsValue(
      this as FCThreadField,
      other,
    );
  }

  @override
  int get hashCode {
    return FCThreadFieldMapper.ensureInitialized().hashValue(
      this as FCThreadField,
    );
  }
}

extension FCThreadFieldValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCThreadField, $Out> {
  FCThreadFieldCopyWith<$R, FCThreadField, $Out> get $asFCThreadField =>
      $base.as((v, t, t2) => _FCThreadFieldCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCThreadFieldCopyWith<$R, $In extends FCThreadField, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    FCFieldChoice,
    FCFieldChoiceCopyWith<$R, FCFieldChoice, FCFieldChoice>
  >
  get choices;
  $R call({
    String? id,
    String? title,
    String? description,
    String? type,
    bool? required,
    List<FCFieldChoice>? choices,
    String? group,
    int? maxLength,
  });
  FCThreadFieldCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FCThreadFieldCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCThreadField, $Out>
    implements FCThreadFieldCopyWith<$R, FCThreadField, $Out> {
  _FCThreadFieldCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCThreadField> $mapper =
      FCThreadFieldMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    FCFieldChoice,
    FCFieldChoiceCopyWith<$R, FCFieldChoice, FCFieldChoice>
  >
  get choices => ListCopyWith(
    $value.choices,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(choices: v),
  );
  @override
  $R call({
    String? id,
    String? title,
    String? description,
    String? type,
    bool? required,
    List<FCFieldChoice>? choices,
    String? group,
    int? maxLength,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (title != null) #title: title,
      if (description != null) #description: description,
      if (type != null) #type: type,
      if (required != null) #required: required,
      if (choices != null) #choices: choices,
      if (group != null) #group: group,
      if (maxLength != null) #maxLength: maxLength,
    }),
  );
  @override
  FCThreadField $make(CopyWithData data) => FCThreadField(
    id: data.get(#id, or: $value.id),
    title: data.get(#title, or: $value.title),
    description: data.get(#description, or: $value.description),
    type: data.get(#type, or: $value.type),
    required: data.get(#required, or: $value.required),
    choices: data.get(#choices, or: $value.choices),
    group: data.get(#group, or: $value.group),
    maxLength: data.get(#maxLength, or: $value.maxLength),
  );

  @override
  FCThreadFieldCopyWith<$R2, FCThreadField, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCThreadFieldCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCFieldChoiceMapper extends ClassMapperBase<FCFieldChoice> {
  FCFieldChoiceMapper._();

  static FCFieldChoiceMapper? _instance;
  static FCFieldChoiceMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCFieldChoiceMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FCFieldChoice';

  static String _$value(FCFieldChoice v) => v.value;
  static const Field<FCFieldChoice, String> _f$value = Field('value', _$value);
  static String _$title(FCFieldChoice v) => v.title;
  static const Field<FCFieldChoice, String> _f$title = Field('title', _$title);

  @override
  final MappableFields<FCFieldChoice> fields = const {
    #value: _f$value,
    #title: _f$title,
  };

  static FCFieldChoice _instantiate(DecodingData data) {
    return FCFieldChoice(value: data.dec(_f$value), title: data.dec(_f$title));
  }

  @override
  final Function instantiate = _instantiate;

  static FCFieldChoice fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCFieldChoice>(map);
  }

  static FCFieldChoice fromJson(String json) {
    return ensureInitialized().decodeJson<FCFieldChoice>(json);
  }
}

mixin FCFieldChoiceMappable {
  String toJson() {
    return FCFieldChoiceMapper.ensureInitialized().encodeJson<FCFieldChoice>(
      this as FCFieldChoice,
    );
  }

  Map<String, dynamic> toMap() {
    return FCFieldChoiceMapper.ensureInitialized().encodeMap<FCFieldChoice>(
      this as FCFieldChoice,
    );
  }

  FCFieldChoiceCopyWith<FCFieldChoice, FCFieldChoice, FCFieldChoice>
  get copyWith => _FCFieldChoiceCopyWithImpl<FCFieldChoice, FCFieldChoice>(
    this as FCFieldChoice,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return FCFieldChoiceMapper.ensureInitialized().stringifyValue(
      this as FCFieldChoice,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCFieldChoiceMapper.ensureInitialized().equalsValue(
      this as FCFieldChoice,
      other,
    );
  }

  @override
  int get hashCode {
    return FCFieldChoiceMapper.ensureInitialized().hashValue(
      this as FCFieldChoice,
    );
  }
}

extension FCFieldChoiceValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCFieldChoice, $Out> {
  FCFieldChoiceCopyWith<$R, FCFieldChoice, $Out> get $asFCFieldChoice =>
      $base.as((v, t, t2) => _FCFieldChoiceCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCFieldChoiceCopyWith<$R, $In extends FCFieldChoice, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? value, String? title});
  FCFieldChoiceCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FCFieldChoiceCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCFieldChoice, $Out>
    implements FCFieldChoiceCopyWith<$R, FCFieldChoice, $Out> {
  _FCFieldChoiceCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCFieldChoice> $mapper =
      FCFieldChoiceMapper.ensureInitialized();
  @override
  $R call({String? value, String? title}) => $apply(
    FieldCopyWithData({
      if (value != null) #value: value,
      if (title != null) #title: title,
    }),
  );
  @override
  FCFieldChoice $make(CopyWithData data) => FCFieldChoice(
    value: data.get(#value, or: $value.value),
    title: data.get(#title, or: $value.title),
  );

  @override
  FCFieldChoiceCopyWith<$R2, FCFieldChoice, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCFieldChoiceCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCThreadTypeOptionMapper extends ClassMapperBase<FCThreadTypeOption> {
  FCThreadTypeOptionMapper._();

  static FCThreadTypeOptionMapper? _instance;
  static FCThreadTypeOptionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCThreadTypeOptionMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FCThreadTypeOption';

  static String _$type(FCThreadTypeOption v) => v.type;
  static const Field<FCThreadTypeOption, String> _f$type = Field(
    'type',
    _$type,
  );
  static String _$title(FCThreadTypeOption v) => v.title;
  static const Field<FCThreadTypeOption, String> _f$title = Field(
    'title',
    _$title,
  );

  @override
  final MappableFields<FCThreadTypeOption> fields = const {
    #type: _f$type,
    #title: _f$title,
  };

  static FCThreadTypeOption _instantiate(DecodingData data) {
    return FCThreadTypeOption(
      type: data.dec(_f$type),
      title: data.dec(_f$title),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCThreadTypeOption fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCThreadTypeOption>(map);
  }

  static FCThreadTypeOption fromJson(String json) {
    return ensureInitialized().decodeJson<FCThreadTypeOption>(json);
  }
}

mixin FCThreadTypeOptionMappable {
  String toJson() {
    return FCThreadTypeOptionMapper.ensureInitialized()
        .encodeJson<FCThreadTypeOption>(this as FCThreadTypeOption);
  }

  Map<String, dynamic> toMap() {
    return FCThreadTypeOptionMapper.ensureInitialized()
        .encodeMap<FCThreadTypeOption>(this as FCThreadTypeOption);
  }

  FCThreadTypeOptionCopyWith<
    FCThreadTypeOption,
    FCThreadTypeOption,
    FCThreadTypeOption
  >
  get copyWith =>
      _FCThreadTypeOptionCopyWithImpl<FCThreadTypeOption, FCThreadTypeOption>(
        this as FCThreadTypeOption,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCThreadTypeOptionMapper.ensureInitialized().stringifyValue(
      this as FCThreadTypeOption,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCThreadTypeOptionMapper.ensureInitialized().equalsValue(
      this as FCThreadTypeOption,
      other,
    );
  }

  @override
  int get hashCode {
    return FCThreadTypeOptionMapper.ensureInitialized().hashValue(
      this as FCThreadTypeOption,
    );
  }
}

extension FCThreadTypeOptionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCThreadTypeOption, $Out> {
  FCThreadTypeOptionCopyWith<$R, FCThreadTypeOption, $Out>
  get $asFCThreadTypeOption => $base.as(
    (v, t, t2) => _FCThreadTypeOptionCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCThreadTypeOptionCopyWith<
  $R,
  $In extends FCThreadTypeOption,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? type, String? title});
  FCThreadTypeOptionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCThreadTypeOptionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCThreadTypeOption, $Out>
    implements FCThreadTypeOptionCopyWith<$R, FCThreadTypeOption, $Out> {
  _FCThreadTypeOptionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCThreadTypeOption> $mapper =
      FCThreadTypeOptionMapper.ensureInitialized();
  @override
  $R call({String? type, String? title}) => $apply(
    FieldCopyWithData({
      if (type != null) #type: type,
      if (title != null) #title: title,
    }),
  );
  @override
  FCThreadTypeOption $make(CopyWithData data) => FCThreadTypeOption(
    type: data.get(#type, or: $value.type),
    title: data.get(#title, or: $value.title),
  );

  @override
  FCThreadTypeOptionCopyWith<$R2, FCThreadTypeOption, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCThreadTypeOptionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

