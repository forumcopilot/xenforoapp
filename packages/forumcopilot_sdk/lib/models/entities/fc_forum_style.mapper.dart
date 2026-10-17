// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fc_forum_style.dart';

class FCForumStyleMapper extends ClassMapperBase<FCForumStyle> {
  FCForumStyleMapper._();

  static FCForumStyleMapper? _instance;
  static FCForumStyleMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCForumStyleMapper._());
      FCStyleSchemeMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCForumStyle';

  static FCStyleScheme? _$light(FCForumStyle v) => v.light;
  static const Field<FCForumStyle, FCStyleScheme> _f$light = Field(
    'light',
    _$light,
    opt: true,
  );
  static FCStyleScheme? _$dark(FCForumStyle v) => v.dark;
  static const Field<FCForumStyle, FCStyleScheme> _f$dark = Field(
    'dark',
    _$dark,
    opt: true,
  );

  @override
  final MappableFields<FCForumStyle> fields = const {
    #light: _f$light,
    #dark: _f$dark,
  };

  static FCForumStyle _instantiate(DecodingData data) {
    return FCForumStyle(light: data.dec(_f$light), dark: data.dec(_f$dark));
  }

  @override
  final Function instantiate = _instantiate;

  static FCForumStyle fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCForumStyle>(map);
  }

  static FCForumStyle fromJson(String json) {
    return ensureInitialized().decodeJson<FCForumStyle>(json);
  }
}

mixin FCForumStyleMappable {
  String toJson() {
    return FCForumStyleMapper.ensureInitialized().encodeJson<FCForumStyle>(
      this as FCForumStyle,
    );
  }

  Map<String, dynamic> toMap() {
    return FCForumStyleMapper.ensureInitialized().encodeMap<FCForumStyle>(
      this as FCForumStyle,
    );
  }

  FCForumStyleCopyWith<FCForumStyle, FCForumStyle, FCForumStyle> get copyWith =>
      _FCForumStyleCopyWithImpl<FCForumStyle, FCForumStyle>(
        this as FCForumStyle,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCForumStyleMapper.ensureInitialized().stringifyValue(
      this as FCForumStyle,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCForumStyleMapper.ensureInitialized().equalsValue(
      this as FCForumStyle,
      other,
    );
  }

  @override
  int get hashCode {
    return FCForumStyleMapper.ensureInitialized().hashValue(
      this as FCForumStyle,
    );
  }
}

extension FCForumStyleValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCForumStyle, $Out> {
  FCForumStyleCopyWith<$R, FCForumStyle, $Out> get $asFCForumStyle =>
      $base.as((v, t, t2) => _FCForumStyleCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCForumStyleCopyWith<$R, $In extends FCForumStyle, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  FCStyleSchemeCopyWith<$R, FCStyleScheme, FCStyleScheme>? get light;
  FCStyleSchemeCopyWith<$R, FCStyleScheme, FCStyleScheme>? get dark;
  $R call({FCStyleScheme? light, FCStyleScheme? dark});
  FCForumStyleCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FCForumStyleCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCForumStyle, $Out>
    implements FCForumStyleCopyWith<$R, FCForumStyle, $Out> {
  _FCForumStyleCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCForumStyle> $mapper =
      FCForumStyleMapper.ensureInitialized();
  @override
  FCStyleSchemeCopyWith<$R, FCStyleScheme, FCStyleScheme>? get light =>
      $value.light?.copyWith.$chain((v) => call(light: v));
  @override
  FCStyleSchemeCopyWith<$R, FCStyleScheme, FCStyleScheme>? get dark =>
      $value.dark?.copyWith.$chain((v) => call(dark: v));
  @override
  $R call({Object? light = $none, Object? dark = $none}) => $apply(
    FieldCopyWithData({
      if (light != $none) #light: light,
      if (dark != $none) #dark: dark,
    }),
  );
  @override
  FCForumStyle $make(CopyWithData data) => FCForumStyle(
    light: data.get(#light, or: $value.light),
    dark: data.get(#dark, or: $value.dark),
  );

  @override
  FCForumStyleCopyWith<$R2, FCForumStyle, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCForumStyleCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCStyleSchemeMapper extends ClassMapperBase<FCStyleScheme> {
  FCStyleSchemeMapper._();

  static FCStyleSchemeMapper? _instance;
  static FCStyleSchemeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCStyleSchemeMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FCStyleScheme';

  static String? _$headerBackground(FCStyleScheme v) => v.headerBackground;
  static const Field<FCStyleScheme, String> _f$headerBackground = Field(
    'headerBackground',
    _$headerBackground,
    opt: true,
  );
  static String? _$headerText(FCStyleScheme v) => v.headerText;
  static const Field<FCStyleScheme, String> _f$headerText = Field(
    'headerText',
    _$headerText,
    opt: true,
  );
  static String? _$page(FCStyleScheme v) => v.page;
  static const Field<FCStyleScheme, String> _f$page = Field(
    'page',
    _$page,
    opt: true,
  );
  static String? _$content(FCStyleScheme v) => v.content;
  static const Field<FCStyleScheme, String> _f$content = Field(
    'content',
    _$content,
    opt: true,
  );
  static String? _$text(FCStyleScheme v) => v.text;
  static const Field<FCStyleScheme, String> _f$text = Field(
    'text',
    _$text,
    opt: true,
  );
  static String? _$link(FCStyleScheme v) => v.link;
  static const Field<FCStyleScheme, String> _f$link = Field(
    'link',
    _$link,
    opt: true,
  );
  static String? _$button(FCStyleScheme v) => v.button;
  static const Field<FCStyleScheme, String> _f$button = Field(
    'button',
    _$button,
    opt: true,
  );
  static String? _$buttonText(FCStyleScheme v) => v.buttonText;
  static const Field<FCStyleScheme, String> _f$buttonText = Field(
    'buttonText',
    _$buttonText,
    opt: true,
  );
  static String? _$accent(FCStyleScheme v) => v.accent;
  static const Field<FCStyleScheme, String> _f$accent = Field(
    'accent',
    _$accent,
    opt: true,
  );
  static String? _$error(FCStyleScheme v) => v.error;
  static const Field<FCStyleScheme, String> _f$error = Field(
    'error',
    _$error,
    opt: true,
  );
  static String? _$success(FCStyleScheme v) => v.success;
  static const Field<FCStyleScheme, String> _f$success = Field(
    'success',
    _$success,
    opt: true,
  );
  static String? _$themeColor(FCStyleScheme v) => v.themeColor;
  static const Field<FCStyleScheme, String> _f$themeColor = Field(
    'themeColor',
    _$themeColor,
    opt: true,
  );
  static String? _$logo(FCStyleScheme v) => v.logo;
  static const Field<FCStyleScheme, String> _f$logo = Field(
    'logo',
    _$logo,
    opt: true,
  );
  static int? _$logoWidth(FCStyleScheme v) => v.logoWidth;
  static const Field<FCStyleScheme, int> _f$logoWidth = Field(
    'logoWidth',
    _$logoWidth,
    opt: true,
  );
  static int? _$logoHeight(FCStyleScheme v) => v.logoHeight;
  static const Field<FCStyleScheme, int> _f$logoHeight = Field(
    'logoHeight',
    _$logoHeight,
    opt: true,
  );

  @override
  final MappableFields<FCStyleScheme> fields = const {
    #headerBackground: _f$headerBackground,
    #headerText: _f$headerText,
    #page: _f$page,
    #content: _f$content,
    #text: _f$text,
    #link: _f$link,
    #button: _f$button,
    #buttonText: _f$buttonText,
    #accent: _f$accent,
    #error: _f$error,
    #success: _f$success,
    #themeColor: _f$themeColor,
    #logo: _f$logo,
    #logoWidth: _f$logoWidth,
    #logoHeight: _f$logoHeight,
  };

  static FCStyleScheme _instantiate(DecodingData data) {
    return FCStyleScheme(
      headerBackground: data.dec(_f$headerBackground),
      headerText: data.dec(_f$headerText),
      page: data.dec(_f$page),
      content: data.dec(_f$content),
      text: data.dec(_f$text),
      link: data.dec(_f$link),
      button: data.dec(_f$button),
      buttonText: data.dec(_f$buttonText),
      accent: data.dec(_f$accent),
      error: data.dec(_f$error),
      success: data.dec(_f$success),
      themeColor: data.dec(_f$themeColor),
      logo: data.dec(_f$logo),
      logoWidth: data.dec(_f$logoWidth),
      logoHeight: data.dec(_f$logoHeight),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCStyleScheme fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCStyleScheme>(map);
  }

  static FCStyleScheme fromJson(String json) {
    return ensureInitialized().decodeJson<FCStyleScheme>(json);
  }
}

mixin FCStyleSchemeMappable {
  String toJson() {
    return FCStyleSchemeMapper.ensureInitialized().encodeJson<FCStyleScheme>(
      this as FCStyleScheme,
    );
  }

  Map<String, dynamic> toMap() {
    return FCStyleSchemeMapper.ensureInitialized().encodeMap<FCStyleScheme>(
      this as FCStyleScheme,
    );
  }

  FCStyleSchemeCopyWith<FCStyleScheme, FCStyleScheme, FCStyleScheme>
  get copyWith => _FCStyleSchemeCopyWithImpl<FCStyleScheme, FCStyleScheme>(
    this as FCStyleScheme,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return FCStyleSchemeMapper.ensureInitialized().stringifyValue(
      this as FCStyleScheme,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCStyleSchemeMapper.ensureInitialized().equalsValue(
      this as FCStyleScheme,
      other,
    );
  }

  @override
  int get hashCode {
    return FCStyleSchemeMapper.ensureInitialized().hashValue(
      this as FCStyleScheme,
    );
  }
}

extension FCStyleSchemeValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCStyleScheme, $Out> {
  FCStyleSchemeCopyWith<$R, FCStyleScheme, $Out> get $asFCStyleScheme =>
      $base.as((v, t, t2) => _FCStyleSchemeCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCStyleSchemeCopyWith<$R, $In extends FCStyleScheme, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? headerBackground,
    String? headerText,
    String? page,
    String? content,
    String? text,
    String? link,
    String? button,
    String? buttonText,
    String? accent,
    String? error,
    String? success,
    String? themeColor,
    String? logo,
    int? logoWidth,
    int? logoHeight,
  });
  FCStyleSchemeCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FCStyleSchemeCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCStyleScheme, $Out>
    implements FCStyleSchemeCopyWith<$R, FCStyleScheme, $Out> {
  _FCStyleSchemeCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCStyleScheme> $mapper =
      FCStyleSchemeMapper.ensureInitialized();
  @override
  $R call({
    Object? headerBackground = $none,
    Object? headerText = $none,
    Object? page = $none,
    Object? content = $none,
    Object? text = $none,
    Object? link = $none,
    Object? button = $none,
    Object? buttonText = $none,
    Object? accent = $none,
    Object? error = $none,
    Object? success = $none,
    Object? themeColor = $none,
    Object? logo = $none,
    Object? logoWidth = $none,
    Object? logoHeight = $none,
  }) => $apply(
    FieldCopyWithData({
      if (headerBackground != $none) #headerBackground: headerBackground,
      if (headerText != $none) #headerText: headerText,
      if (page != $none) #page: page,
      if (content != $none) #content: content,
      if (text != $none) #text: text,
      if (link != $none) #link: link,
      if (button != $none) #button: button,
      if (buttonText != $none) #buttonText: buttonText,
      if (accent != $none) #accent: accent,
      if (error != $none) #error: error,
      if (success != $none) #success: success,
      if (themeColor != $none) #themeColor: themeColor,
      if (logo != $none) #logo: logo,
      if (logoWidth != $none) #logoWidth: logoWidth,
      if (logoHeight != $none) #logoHeight: logoHeight,
    }),
  );
  @override
  FCStyleScheme $make(CopyWithData data) => FCStyleScheme(
    headerBackground: data.get(#headerBackground, or: $value.headerBackground),
    headerText: data.get(#headerText, or: $value.headerText),
    page: data.get(#page, or: $value.page),
    content: data.get(#content, or: $value.content),
    text: data.get(#text, or: $value.text),
    link: data.get(#link, or: $value.link),
    button: data.get(#button, or: $value.button),
    buttonText: data.get(#buttonText, or: $value.buttonText),
    accent: data.get(#accent, or: $value.accent),
    error: data.get(#error, or: $value.error),
    success: data.get(#success, or: $value.success),
    themeColor: data.get(#themeColor, or: $value.themeColor),
    logo: data.get(#logo, or: $value.logo),
    logoWidth: data.get(#logoWidth, or: $value.logoWidth),
    logoHeight: data.get(#logoHeight, or: $value.logoHeight),
  );

  @override
  FCStyleSchemeCopyWith<$R2, FCStyleScheme, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCStyleSchemeCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

