// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fc_registration_requirements.dart';

class FCFieldRequirementMapper extends ClassMapperBase<FCFieldRequirement> {
  FCFieldRequirementMapper._();

  static FCFieldRequirementMapper? _instance;
  static FCFieldRequirementMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCFieldRequirementMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FCFieldRequirement';

  static bool _$required(FCFieldRequirement v) => v.required;
  static const Field<FCFieldRequirement, bool> _f$required = Field(
    'required',
    _$required,
  );
  static int? _$minLength(FCFieldRequirement v) => v.minLength;
  static const Field<FCFieldRequirement, int> _f$minLength = Field(
    'minLength',
    _$minLength,
    opt: true,
  );
  static int? _$maxLength(FCFieldRequirement v) => v.maxLength;
  static const Field<FCFieldRequirement, int> _f$maxLength = Field(
    'maxLength',
    _$maxLength,
    opt: true,
  );
  static bool? _$checkStrength(FCFieldRequirement v) => v.checkStrength;
  static const Field<FCFieldRequirement, bool> _f$checkStrength = Field(
    'checkStrength',
    _$checkStrength,
    opt: true,
  );
  static int? _$minimumAge(FCFieldRequirement v) => v.minimumAge;
  static const Field<FCFieldRequirement, int> _f$minimumAge = Field(
    'minimumAge',
    _$minimumAge,
    opt: true,
  );
  static bool? _$requireDob(FCFieldRequirement v) => v.requireDob;
  static const Field<FCFieldRequirement, bool> _f$requireDob = Field(
    'requireDob',
    _$requireDob,
    opt: true,
  );
  static bool? _$requireLocation(FCFieldRequirement v) => v.requireLocation;
  static const Field<FCFieldRequirement, bool> _f$requireLocation = Field(
    'requireLocation',
    _$requireLocation,
    opt: true,
  );
  static bool? _$requireEmailChoice(FCFieldRequirement v) =>
      v.requireEmailChoice;
  static const Field<FCFieldRequirement, bool> _f$requireEmailChoice = Field(
    'requireEmailChoice',
    _$requireEmailChoice,
    opt: true,
  );

  @override
  final MappableFields<FCFieldRequirement> fields = const {
    #required: _f$required,
    #minLength: _f$minLength,
    #maxLength: _f$maxLength,
    #checkStrength: _f$checkStrength,
    #minimumAge: _f$minimumAge,
    #requireDob: _f$requireDob,
    #requireLocation: _f$requireLocation,
    #requireEmailChoice: _f$requireEmailChoice,
  };

  static FCFieldRequirement _instantiate(DecodingData data) {
    return FCFieldRequirement(
      required: data.dec(_f$required),
      minLength: data.dec(_f$minLength),
      maxLength: data.dec(_f$maxLength),
      checkStrength: data.dec(_f$checkStrength),
      minimumAge: data.dec(_f$minimumAge),
      requireDob: data.dec(_f$requireDob),
      requireLocation: data.dec(_f$requireLocation),
      requireEmailChoice: data.dec(_f$requireEmailChoice),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCFieldRequirement fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCFieldRequirement>(map);
  }

  static FCFieldRequirement fromJson(String json) {
    return ensureInitialized().decodeJson<FCFieldRequirement>(json);
  }
}

mixin FCFieldRequirementMappable {
  String toJson() {
    return FCFieldRequirementMapper.ensureInitialized()
        .encodeJson<FCFieldRequirement>(this as FCFieldRequirement);
  }

  Map<String, dynamic> toMap() {
    return FCFieldRequirementMapper.ensureInitialized()
        .encodeMap<FCFieldRequirement>(this as FCFieldRequirement);
  }

  FCFieldRequirementCopyWith<
    FCFieldRequirement,
    FCFieldRequirement,
    FCFieldRequirement
  >
  get copyWith =>
      _FCFieldRequirementCopyWithImpl<FCFieldRequirement, FCFieldRequirement>(
        this as FCFieldRequirement,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCFieldRequirementMapper.ensureInitialized().stringifyValue(
      this as FCFieldRequirement,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCFieldRequirementMapper.ensureInitialized().equalsValue(
      this as FCFieldRequirement,
      other,
    );
  }

  @override
  int get hashCode {
    return FCFieldRequirementMapper.ensureInitialized().hashValue(
      this as FCFieldRequirement,
    );
  }
}

extension FCFieldRequirementValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCFieldRequirement, $Out> {
  FCFieldRequirementCopyWith<$R, FCFieldRequirement, $Out>
  get $asFCFieldRequirement => $base.as(
    (v, t, t2) => _FCFieldRequirementCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCFieldRequirementCopyWith<
  $R,
  $In extends FCFieldRequirement,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    bool? required,
    int? minLength,
    int? maxLength,
    bool? checkStrength,
    int? minimumAge,
    bool? requireDob,
    bool? requireLocation,
    bool? requireEmailChoice,
  });
  FCFieldRequirementCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCFieldRequirementCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCFieldRequirement, $Out>
    implements FCFieldRequirementCopyWith<$R, FCFieldRequirement, $Out> {
  _FCFieldRequirementCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCFieldRequirement> $mapper =
      FCFieldRequirementMapper.ensureInitialized();
  @override
  $R call({
    bool? required,
    Object? minLength = $none,
    Object? maxLength = $none,
    Object? checkStrength = $none,
    Object? minimumAge = $none,
    Object? requireDob = $none,
    Object? requireLocation = $none,
    Object? requireEmailChoice = $none,
  }) => $apply(
    FieldCopyWithData({
      if (required != null) #required: required,
      if (minLength != $none) #minLength: minLength,
      if (maxLength != $none) #maxLength: maxLength,
      if (checkStrength != $none) #checkStrength: checkStrength,
      if (minimumAge != $none) #minimumAge: minimumAge,
      if (requireDob != $none) #requireDob: requireDob,
      if (requireLocation != $none) #requireLocation: requireLocation,
      if (requireEmailChoice != $none) #requireEmailChoice: requireEmailChoice,
    }),
  );
  @override
  FCFieldRequirement $make(CopyWithData data) => FCFieldRequirement(
    required: data.get(#required, or: $value.required),
    minLength: data.get(#minLength, or: $value.minLength),
    maxLength: data.get(#maxLength, or: $value.maxLength),
    checkStrength: data.get(#checkStrength, or: $value.checkStrength),
    minimumAge: data.get(#minimumAge, or: $value.minimumAge),
    requireDob: data.get(#requireDob, or: $value.requireDob),
    requireLocation: data.get(#requireLocation, or: $value.requireLocation),
    requireEmailChoice: data.get(
      #requireEmailChoice,
      or: $value.requireEmailChoice,
    ),
  );

  @override
  FCFieldRequirementCopyWith<$R2, FCFieldRequirement, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCFieldRequirementCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCPolicyRequirementMapper extends ClassMapperBase<FCPolicyRequirement> {
  FCPolicyRequirementMapper._();

  static FCPolicyRequirementMapper? _instance;
  static FCPolicyRequirementMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCPolicyRequirementMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FCPolicyRequirement';

  static bool _$required(FCPolicyRequirement v) => v.required;
  static const Field<FCPolicyRequirement, bool> _f$required = Field(
    'required',
    _$required,
  );
  static String _$url(FCPolicyRequirement v) => v.url;
  static const Field<FCPolicyRequirement, String> _f$url = Field('url', _$url);

  @override
  final MappableFields<FCPolicyRequirement> fields = const {
    #required: _f$required,
    #url: _f$url,
  };

  static FCPolicyRequirement _instantiate(DecodingData data) {
    return FCPolicyRequirement(
      required: data.dec(_f$required),
      url: data.dec(_f$url),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCPolicyRequirement fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCPolicyRequirement>(map);
  }

  static FCPolicyRequirement fromJson(String json) {
    return ensureInitialized().decodeJson<FCPolicyRequirement>(json);
  }
}

mixin FCPolicyRequirementMappable {
  String toJson() {
    return FCPolicyRequirementMapper.ensureInitialized()
        .encodeJson<FCPolicyRequirement>(this as FCPolicyRequirement);
  }

  Map<String, dynamic> toMap() {
    return FCPolicyRequirementMapper.ensureInitialized()
        .encodeMap<FCPolicyRequirement>(this as FCPolicyRequirement);
  }

  FCPolicyRequirementCopyWith<
    FCPolicyRequirement,
    FCPolicyRequirement,
    FCPolicyRequirement
  >
  get copyWith =>
      _FCPolicyRequirementCopyWithImpl<
        FCPolicyRequirement,
        FCPolicyRequirement
      >(this as FCPolicyRequirement, $identity, $identity);
  @override
  String toString() {
    return FCPolicyRequirementMapper.ensureInitialized().stringifyValue(
      this as FCPolicyRequirement,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCPolicyRequirementMapper.ensureInitialized().equalsValue(
      this as FCPolicyRequirement,
      other,
    );
  }

  @override
  int get hashCode {
    return FCPolicyRequirementMapper.ensureInitialized().hashValue(
      this as FCPolicyRequirement,
    );
  }
}

extension FCPolicyRequirementValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCPolicyRequirement, $Out> {
  FCPolicyRequirementCopyWith<$R, FCPolicyRequirement, $Out>
  get $asFCPolicyRequirement => $base.as(
    (v, t, t2) => _FCPolicyRequirementCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCPolicyRequirementCopyWith<
  $R,
  $In extends FCPolicyRequirement,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({bool? required, String? url});
  FCPolicyRequirementCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCPolicyRequirementCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCPolicyRequirement, $Out>
    implements FCPolicyRequirementCopyWith<$R, FCPolicyRequirement, $Out> {
  _FCPolicyRequirementCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCPolicyRequirement> $mapper =
      FCPolicyRequirementMapper.ensureInitialized();
  @override
  $R call({bool? required, String? url}) => $apply(
    FieldCopyWithData({
      if (required != null) #required: required,
      if (url != null) #url: url,
    }),
  );
  @override
  FCPolicyRequirement $make(CopyWithData data) => FCPolicyRequirement(
    required: data.get(#required, or: $value.required),
    url: data.get(#url, or: $value.url),
  );

  @override
  FCPolicyRequirementCopyWith<$R2, FCPolicyRequirement, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCPolicyRequirementCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCCaptchaRequirementMapper extends ClassMapperBase<FCCaptchaRequirement> {
  FCCaptchaRequirementMapper._();

  static FCCaptchaRequirementMapper? _instance;
  static FCCaptchaRequirementMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCCaptchaRequirementMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FCCaptchaRequirement';

  static bool _$required(FCCaptchaRequirement v) => v.required;
  static const Field<FCCaptchaRequirement, bool> _f$required = Field(
    'required',
    _$required,
  );
  static String? _$type(FCCaptchaRequirement v) => v.type;
  static const Field<FCCaptchaRequirement, String> _f$type = Field(
    'type',
    _$type,
    opt: true,
  );
  static bool? _$invisible(FCCaptchaRequirement v) => v.invisible;
  static const Field<FCCaptchaRequirement, bool> _f$invisible = Field(
    'invisible',
    _$invisible,
    opt: true,
  );
  static String? _$siteKey(FCCaptchaRequirement v) => v.siteKey;
  static const Field<FCCaptchaRequirement, String> _f$siteKey = Field(
    'siteKey',
    _$siteKey,
    opt: true,
  );

  @override
  final MappableFields<FCCaptchaRequirement> fields = const {
    #required: _f$required,
    #type: _f$type,
    #invisible: _f$invisible,
    #siteKey: _f$siteKey,
  };

  static FCCaptchaRequirement _instantiate(DecodingData data) {
    return FCCaptchaRequirement(
      required: data.dec(_f$required),
      type: data.dec(_f$type),
      invisible: data.dec(_f$invisible),
      siteKey: data.dec(_f$siteKey),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCCaptchaRequirement fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCCaptchaRequirement>(map);
  }

  static FCCaptchaRequirement fromJson(String json) {
    return ensureInitialized().decodeJson<FCCaptchaRequirement>(json);
  }
}

mixin FCCaptchaRequirementMappable {
  String toJson() {
    return FCCaptchaRequirementMapper.ensureInitialized()
        .encodeJson<FCCaptchaRequirement>(this as FCCaptchaRequirement);
  }

  Map<String, dynamic> toMap() {
    return FCCaptchaRequirementMapper.ensureInitialized()
        .encodeMap<FCCaptchaRequirement>(this as FCCaptchaRequirement);
  }

  FCCaptchaRequirementCopyWith<
    FCCaptchaRequirement,
    FCCaptchaRequirement,
    FCCaptchaRequirement
  >
  get copyWith =>
      _FCCaptchaRequirementCopyWithImpl<
        FCCaptchaRequirement,
        FCCaptchaRequirement
      >(this as FCCaptchaRequirement, $identity, $identity);
  @override
  String toString() {
    return FCCaptchaRequirementMapper.ensureInitialized().stringifyValue(
      this as FCCaptchaRequirement,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCCaptchaRequirementMapper.ensureInitialized().equalsValue(
      this as FCCaptchaRequirement,
      other,
    );
  }

  @override
  int get hashCode {
    return FCCaptchaRequirementMapper.ensureInitialized().hashValue(
      this as FCCaptchaRequirement,
    );
  }
}

extension FCCaptchaRequirementValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCCaptchaRequirement, $Out> {
  FCCaptchaRequirementCopyWith<$R, FCCaptchaRequirement, $Out>
  get $asFCCaptchaRequirement => $base.as(
    (v, t, t2) => _FCCaptchaRequirementCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCCaptchaRequirementCopyWith<
  $R,
  $In extends FCCaptchaRequirement,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({bool? required, String? type, bool? invisible, String? siteKey});
  FCCaptchaRequirementCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCCaptchaRequirementCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCCaptchaRequirement, $Out>
    implements FCCaptchaRequirementCopyWith<$R, FCCaptchaRequirement, $Out> {
  _FCCaptchaRequirementCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCCaptchaRequirement> $mapper =
      FCCaptchaRequirementMapper.ensureInitialized();
  @override
  $R call({
    bool? required,
    Object? type = $none,
    Object? invisible = $none,
    Object? siteKey = $none,
  }) => $apply(
    FieldCopyWithData({
      if (required != null) #required: required,
      if (type != $none) #type: type,
      if (invisible != $none) #invisible: invisible,
      if (siteKey != $none) #siteKey: siteKey,
    }),
  );
  @override
  FCCaptchaRequirement $make(CopyWithData data) => FCCaptchaRequirement(
    required: data.get(#required, or: $value.required),
    type: data.get(#type, or: $value.type),
    invisible: data.get(#invisible, or: $value.invisible),
    siteKey: data.get(#siteKey, or: $value.siteKey),
  );

  @override
  FCCaptchaRequirementCopyWith<$R2, FCCaptchaRequirement, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCCaptchaRequirementCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCRegistrationRequirementsMapper
    extends ClassMapperBase<FCRegistrationRequirements> {
  FCRegistrationRequirementsMapper._();

  static FCRegistrationRequirementsMapper? _instance;
  static FCRegistrationRequirementsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = FCRegistrationRequirementsMapper._(),
      );
      FCFieldRequirementMapper.ensureInitialized();
      FCCustomFieldDefinitionMapper.ensureInitialized();
      FCCaptchaRequirementMapper.ensureInitialized();
      FCPolicyRequirementMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCRegistrationRequirements';

  static FCFieldRequirement? _$username(FCRegistrationRequirements v) =>
      v.username;
  static const Field<FCRegistrationRequirements, FCFieldRequirement>
  _f$username = Field('username', _$username, opt: true);
  static FCFieldRequirement? _$email(FCRegistrationRequirements v) => v.email;
  static const Field<FCRegistrationRequirements, FCFieldRequirement> _f$email =
      Field('email', _$email, opt: true);
  static FCFieldRequirement? _$password(FCRegistrationRequirements v) =>
      v.password;
  static const Field<FCRegistrationRequirements, FCFieldRequirement>
  _f$password = Field('password', _$password, opt: true);
  static FCFieldRequirement? _$dateOfBirth(FCRegistrationRequirements v) =>
      v.dateOfBirth;
  static const Field<FCRegistrationRequirements, FCFieldRequirement>
  _f$dateOfBirth = Field('dateOfBirth', _$dateOfBirth, opt: true);
  static FCFieldRequirement? _$location(FCRegistrationRequirements v) =>
      v.location;
  static const Field<FCRegistrationRequirements, FCFieldRequirement>
  _f$location = Field('location', _$location, opt: true);
  static FCFieldRequirement? _$emailChoice(FCRegistrationRequirements v) =>
      v.emailChoice;
  static const Field<FCRegistrationRequirements, FCFieldRequirement>
  _f$emailChoice = Field('emailChoice', _$emailChoice, opt: true);
  static List<FCCustomFieldDefinition> _$customFields(
    FCRegistrationRequirements v,
  ) => v.customFields;
  static const Field<FCRegistrationRequirements, List<FCCustomFieldDefinition>>
  _f$customFields = Field(
    'customFields',
    _$customFields,
    opt: true,
    def: const [],
  );
  static FCCaptchaRequirement? _$captcha(FCRegistrationRequirements v) =>
      v.captcha;
  static const Field<FCRegistrationRequirements, FCCaptchaRequirement>
  _f$captcha = Field('captcha', _$captcha, opt: true);
  static FCPolicyRequirement? _$privacyPolicy(FCRegistrationRequirements v) =>
      v.privacyPolicy;
  static const Field<FCRegistrationRequirements, FCPolicyRequirement>
  _f$privacyPolicy = Field('privacyPolicy', _$privacyPolicy, opt: true);
  static FCPolicyRequirement? _$termsOfService(FCRegistrationRequirements v) =>
      v.termsOfService;
  static const Field<FCRegistrationRequirements, FCPolicyRequirement>
  _f$termsOfService = Field('termsOfService', _$termsOfService, opt: true);

  @override
  final MappableFields<FCRegistrationRequirements> fields = const {
    #username: _f$username,
    #email: _f$email,
    #password: _f$password,
    #dateOfBirth: _f$dateOfBirth,
    #location: _f$location,
    #emailChoice: _f$emailChoice,
    #customFields: _f$customFields,
    #captcha: _f$captcha,
    #privacyPolicy: _f$privacyPolicy,
    #termsOfService: _f$termsOfService,
  };

  static FCRegistrationRequirements _instantiate(DecodingData data) {
    return FCRegistrationRequirements(
      username: data.dec(_f$username),
      email: data.dec(_f$email),
      password: data.dec(_f$password),
      dateOfBirth: data.dec(_f$dateOfBirth),
      location: data.dec(_f$location),
      emailChoice: data.dec(_f$emailChoice),
      customFields: data.dec(_f$customFields),
      captcha: data.dec(_f$captcha),
      privacyPolicy: data.dec(_f$privacyPolicy),
      termsOfService: data.dec(_f$termsOfService),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCRegistrationRequirements fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCRegistrationRequirements>(map);
  }

  static FCRegistrationRequirements fromJson(String json) {
    return ensureInitialized().decodeJson<FCRegistrationRequirements>(json);
  }
}

mixin FCRegistrationRequirementsMappable {
  String toJson() {
    return FCRegistrationRequirementsMapper.ensureInitialized()
        .encodeJson<FCRegistrationRequirements>(
          this as FCRegistrationRequirements,
        );
  }

  Map<String, dynamic> toMap() {
    return FCRegistrationRequirementsMapper.ensureInitialized()
        .encodeMap<FCRegistrationRequirements>(
          this as FCRegistrationRequirements,
        );
  }

  FCRegistrationRequirementsCopyWith<
    FCRegistrationRequirements,
    FCRegistrationRequirements,
    FCRegistrationRequirements
  >
  get copyWith =>
      _FCRegistrationRequirementsCopyWithImpl<
        FCRegistrationRequirements,
        FCRegistrationRequirements
      >(this as FCRegistrationRequirements, $identity, $identity);
  @override
  String toString() {
    return FCRegistrationRequirementsMapper.ensureInitialized().stringifyValue(
      this as FCRegistrationRequirements,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCRegistrationRequirementsMapper.ensureInitialized().equalsValue(
      this as FCRegistrationRequirements,
      other,
    );
  }

  @override
  int get hashCode {
    return FCRegistrationRequirementsMapper.ensureInitialized().hashValue(
      this as FCRegistrationRequirements,
    );
  }
}

extension FCRegistrationRequirementsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCRegistrationRequirements, $Out> {
  FCRegistrationRequirementsCopyWith<$R, FCRegistrationRequirements, $Out>
  get $asFCRegistrationRequirements => $base.as(
    (v, t, t2) => _FCRegistrationRequirementsCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCRegistrationRequirementsCopyWith<
  $R,
  $In extends FCRegistrationRequirements,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  FCFieldRequirementCopyWith<$R, FCFieldRequirement, FCFieldRequirement>?
  get username;
  FCFieldRequirementCopyWith<$R, FCFieldRequirement, FCFieldRequirement>?
  get email;
  FCFieldRequirementCopyWith<$R, FCFieldRequirement, FCFieldRequirement>?
  get password;
  FCFieldRequirementCopyWith<$R, FCFieldRequirement, FCFieldRequirement>?
  get dateOfBirth;
  FCFieldRequirementCopyWith<$R, FCFieldRequirement, FCFieldRequirement>?
  get location;
  FCFieldRequirementCopyWith<$R, FCFieldRequirement, FCFieldRequirement>?
  get emailChoice;
  ListCopyWith<
    $R,
    FCCustomFieldDefinition,
    FCCustomFieldDefinitionCopyWith<
      $R,
      FCCustomFieldDefinition,
      FCCustomFieldDefinition
    >
  >
  get customFields;
  FCCaptchaRequirementCopyWith<$R, FCCaptchaRequirement, FCCaptchaRequirement>?
  get captcha;
  FCPolicyRequirementCopyWith<$R, FCPolicyRequirement, FCPolicyRequirement>?
  get privacyPolicy;
  FCPolicyRequirementCopyWith<$R, FCPolicyRequirement, FCPolicyRequirement>?
  get termsOfService;
  $R call({
    FCFieldRequirement? username,
    FCFieldRequirement? email,
    FCFieldRequirement? password,
    FCFieldRequirement? dateOfBirth,
    FCFieldRequirement? location,
    FCFieldRequirement? emailChoice,
    List<FCCustomFieldDefinition>? customFields,
    FCCaptchaRequirement? captcha,
    FCPolicyRequirement? privacyPolicy,
    FCPolicyRequirement? termsOfService,
  });
  FCRegistrationRequirementsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCRegistrationRequirementsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCRegistrationRequirements, $Out>
    implements
        FCRegistrationRequirementsCopyWith<
          $R,
          FCRegistrationRequirements,
          $Out
        > {
  _FCRegistrationRequirementsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCRegistrationRequirements> $mapper =
      FCRegistrationRequirementsMapper.ensureInitialized();
  @override
  FCFieldRequirementCopyWith<$R, FCFieldRequirement, FCFieldRequirement>?
  get username => $value.username?.copyWith.$chain((v) => call(username: v));
  @override
  FCFieldRequirementCopyWith<$R, FCFieldRequirement, FCFieldRequirement>?
  get email => $value.email?.copyWith.$chain((v) => call(email: v));
  @override
  FCFieldRequirementCopyWith<$R, FCFieldRequirement, FCFieldRequirement>?
  get password => $value.password?.copyWith.$chain((v) => call(password: v));
  @override
  FCFieldRequirementCopyWith<$R, FCFieldRequirement, FCFieldRequirement>?
  get dateOfBirth =>
      $value.dateOfBirth?.copyWith.$chain((v) => call(dateOfBirth: v));
  @override
  FCFieldRequirementCopyWith<$R, FCFieldRequirement, FCFieldRequirement>?
  get location => $value.location?.copyWith.$chain((v) => call(location: v));
  @override
  FCFieldRequirementCopyWith<$R, FCFieldRequirement, FCFieldRequirement>?
  get emailChoice =>
      $value.emailChoice?.copyWith.$chain((v) => call(emailChoice: v));
  @override
  ListCopyWith<
    $R,
    FCCustomFieldDefinition,
    FCCustomFieldDefinitionCopyWith<
      $R,
      FCCustomFieldDefinition,
      FCCustomFieldDefinition
    >
  >
  get customFields => ListCopyWith(
    $value.customFields,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(customFields: v),
  );
  @override
  FCCaptchaRequirementCopyWith<$R, FCCaptchaRequirement, FCCaptchaRequirement>?
  get captcha => $value.captcha?.copyWith.$chain((v) => call(captcha: v));
  @override
  FCPolicyRequirementCopyWith<$R, FCPolicyRequirement, FCPolicyRequirement>?
  get privacyPolicy =>
      $value.privacyPolicy?.copyWith.$chain((v) => call(privacyPolicy: v));
  @override
  FCPolicyRequirementCopyWith<$R, FCPolicyRequirement, FCPolicyRequirement>?
  get termsOfService =>
      $value.termsOfService?.copyWith.$chain((v) => call(termsOfService: v));
  @override
  $R call({
    Object? username = $none,
    Object? email = $none,
    Object? password = $none,
    Object? dateOfBirth = $none,
    Object? location = $none,
    Object? emailChoice = $none,
    List<FCCustomFieldDefinition>? customFields,
    Object? captcha = $none,
    Object? privacyPolicy = $none,
    Object? termsOfService = $none,
  }) => $apply(
    FieldCopyWithData({
      if (username != $none) #username: username,
      if (email != $none) #email: email,
      if (password != $none) #password: password,
      if (dateOfBirth != $none) #dateOfBirth: dateOfBirth,
      if (location != $none) #location: location,
      if (emailChoice != $none) #emailChoice: emailChoice,
      if (customFields != null) #customFields: customFields,
      if (captcha != $none) #captcha: captcha,
      if (privacyPolicy != $none) #privacyPolicy: privacyPolicy,
      if (termsOfService != $none) #termsOfService: termsOfService,
    }),
  );
  @override
  FCRegistrationRequirements $make(CopyWithData data) =>
      FCRegistrationRequirements(
        username: data.get(#username, or: $value.username),
        email: data.get(#email, or: $value.email),
        password: data.get(#password, or: $value.password),
        dateOfBirth: data.get(#dateOfBirth, or: $value.dateOfBirth),
        location: data.get(#location, or: $value.location),
        emailChoice: data.get(#emailChoice, or: $value.emailChoice),
        customFields: data.get(#customFields, or: $value.customFields),
        captcha: data.get(#captcha, or: $value.captcha),
        privacyPolicy: data.get(#privacyPolicy, or: $value.privacyPolicy),
        termsOfService: data.get(#termsOfService, or: $value.termsOfService),
      );

  @override
  FCRegistrationRequirementsCopyWith<$R2, FCRegistrationRequirements, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCRegistrationRequirementsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

