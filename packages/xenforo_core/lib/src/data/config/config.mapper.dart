// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'config.dart';

class XenForoConfigMapper extends ClassMapperBase<XenForoConfig> {
  XenForoConfigMapper._();

  static XenForoConfigMapper? _instance;
  static XenForoConfigMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = XenForoConfigMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'XenForoConfig';

  static String _$versionId(XenForoConfig v) => v.versionId;
  static const Field<XenForoConfig, String> _f$versionId =
      Field('versionId', _$versionId);
  static String _$versionString(XenForoConfig v) => v.versionString;
  static const Field<XenForoConfig, String> _f$versionString =
      Field('versionString', _$versionString);
  static String _$apiVersion(XenForoConfig v) => v.apiVersion;
  static const Field<XenForoConfig, String> _f$apiVersion =
      Field('apiVersion', _$apiVersion);
  static String _$title(XenForoConfig v) => v.title;
  static const Field<XenForoConfig, String> _f$title = Field('title', _$title);
  static String _$tagline(XenForoConfig v) => v.tagline;
  static const Field<XenForoConfig, String> _f$tagline =
      Field('tagline', _$tagline);
  static String _$url(XenForoConfig v) => v.url;
  static const Field<XenForoConfig, String> _f$url = Field('url', _$url);
  static String _$baseUrl(XenForoConfig v) => v.baseUrl;
  static const Field<XenForoConfig, String> _f$baseUrl =
      Field('baseUrl', _$baseUrl);
  static String _$timezone(XenForoConfig v) => v.timezone;
  static const Field<XenForoConfig, String> _f$timezone =
      Field('timezone', _$timezone);
  static String _$language(XenForoConfig v) => v.language;
  static const Field<XenForoConfig, String> _f$language =
      Field('language', _$language);
  static String _$currency(XenForoConfig v) => v.currency;
  static const Field<XenForoConfig, String> _f$currency =
      Field('currency', _$currency);
  static String _$dateFormat(XenForoConfig v) => v.dateFormat;
  static const Field<XenForoConfig, String> _f$dateFormat =
      Field('dateFormat', _$dateFormat);
  static String _$timeFormat(XenForoConfig v) => v.timeFormat;
  static const Field<XenForoConfig, String> _f$timeFormat =
      Field('timeFormat', _$timeFormat);
  static bool _$debugMode(XenForoConfig v) => v.debugMode;
  static const Field<XenForoConfig, bool> _f$debugMode =
      Field('debugMode', _$debugMode);
  static bool _$developmentMode(XenForoConfig v) => v.developmentMode;
  static const Field<XenForoConfig, bool> _f$developmentMode =
      Field('developmentMode', _$developmentMode);
  static bool _$maintenanceMode(XenForoConfig v) => v.maintenanceMode;
  static const Field<XenForoConfig, bool> _f$maintenanceMode =
      Field('maintenanceMode', _$maintenanceMode);
  static String _$maintenanceMessage(XenForoConfig v) => v.maintenanceMessage;
  static const Field<XenForoConfig, String> _f$maintenanceMessage =
      Field('maintenanceMessage', _$maintenanceMessage);
  static Map<String, dynamic> _$options(XenForoConfig v) => v.options;
  static const Field<XenForoConfig, Map<String, dynamic>> _f$options =
      Field('options', _$options);
  static Map<String, dynamic> _$permissions(XenForoConfig v) => v.permissions;
  static const Field<XenForoConfig, Map<String, dynamic>> _f$permissions =
      Field('permissions', _$permissions);
  static Map<String, dynamic> _$features(XenForoConfig v) => v.features;
  static const Field<XenForoConfig, Map<String, dynamic>> _f$features =
      Field('features', _$features);

  @override
  final MappableFields<XenForoConfig> fields = const {
    #versionId: _f$versionId,
    #versionString: _f$versionString,
    #apiVersion: _f$apiVersion,
    #title: _f$title,
    #tagline: _f$tagline,
    #url: _f$url,
    #baseUrl: _f$baseUrl,
    #timezone: _f$timezone,
    #language: _f$language,
    #currency: _f$currency,
    #dateFormat: _f$dateFormat,
    #timeFormat: _f$timeFormat,
    #debugMode: _f$debugMode,
    #developmentMode: _f$developmentMode,
    #maintenanceMode: _f$maintenanceMode,
    #maintenanceMessage: _f$maintenanceMessage,
    #options: _f$options,
    #permissions: _f$permissions,
    #features: _f$features,
  };

  static XenForoConfig _instantiate(DecodingData data) {
    return XenForoConfig(
        versionId: data.dec(_f$versionId),
        versionString: data.dec(_f$versionString),
        apiVersion: data.dec(_f$apiVersion),
        title: data.dec(_f$title),
        tagline: data.dec(_f$tagline),
        url: data.dec(_f$url),
        baseUrl: data.dec(_f$baseUrl),
        timezone: data.dec(_f$timezone),
        language: data.dec(_f$language),
        currency: data.dec(_f$currency),
        dateFormat: data.dec(_f$dateFormat),
        timeFormat: data.dec(_f$timeFormat),
        debugMode: data.dec(_f$debugMode),
        developmentMode: data.dec(_f$developmentMode),
        maintenanceMode: data.dec(_f$maintenanceMode),
        maintenanceMessage: data.dec(_f$maintenanceMessage),
        options: data.dec(_f$options),
        permissions: data.dec(_f$permissions),
        features: data.dec(_f$features));
  }

  @override
  final Function instantiate = _instantiate;

  static XenForoConfig fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<XenForoConfig>(map);
  }

  static XenForoConfig fromJson(String json) {
    return ensureInitialized().decodeJson<XenForoConfig>(json);
  }
}

mixin XenForoConfigMappable {
  String toJson() {
    return XenForoConfigMapper.ensureInitialized()
        .encodeJson<XenForoConfig>(this as XenForoConfig);
  }

  Map<String, dynamic> toMap() {
    return XenForoConfigMapper.ensureInitialized()
        .encodeMap<XenForoConfig>(this as XenForoConfig);
  }

  XenForoConfigCopyWith<XenForoConfig, XenForoConfig, XenForoConfig>
      get copyWith => _XenForoConfigCopyWithImpl<XenForoConfig, XenForoConfig>(
          this as XenForoConfig, $identity, $identity);
  @override
  String toString() {
    return XenForoConfigMapper.ensureInitialized()
        .stringifyValue(this as XenForoConfig);
  }

  @override
  bool operator ==(Object other) {
    return XenForoConfigMapper.ensureInitialized()
        .equalsValue(this as XenForoConfig, other);
  }

  @override
  int get hashCode {
    return XenForoConfigMapper.ensureInitialized()
        .hashValue(this as XenForoConfig);
  }
}

extension XenForoConfigValueCopy<$R, $Out>
    on ObjectCopyWith<$R, XenForoConfig, $Out> {
  XenForoConfigCopyWith<$R, XenForoConfig, $Out> get $asXenForoConfig =>
      $base.as((v, t, t2) => _XenForoConfigCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class XenForoConfigCopyWith<$R, $In extends XenForoConfig, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
      get options;
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
      get permissions;
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
      get features;
  $R call(
      {String? versionId,
      String? versionString,
      String? apiVersion,
      String? title,
      String? tagline,
      String? url,
      String? baseUrl,
      String? timezone,
      String? language,
      String? currency,
      String? dateFormat,
      String? timeFormat,
      bool? debugMode,
      bool? developmentMode,
      bool? maintenanceMode,
      String? maintenanceMessage,
      Map<String, dynamic>? options,
      Map<String, dynamic>? permissions,
      Map<String, dynamic>? features});
  XenForoConfigCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _XenForoConfigCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, XenForoConfig, $Out>
    implements XenForoConfigCopyWith<$R, XenForoConfig, $Out> {
  _XenForoConfigCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<XenForoConfig> $mapper =
      XenForoConfigMapper.ensureInitialized();
  @override
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
      get options => MapCopyWith($value.options,
          (v, t) => ObjectCopyWith(v, $identity, t), (v) => call(options: v));
  @override
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
      get permissions => MapCopyWith(
          $value.permissions,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(permissions: v));
  @override
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
      get features => MapCopyWith($value.features,
          (v, t) => ObjectCopyWith(v, $identity, t), (v) => call(features: v));
  @override
  $R call(
          {String? versionId,
          String? versionString,
          String? apiVersion,
          String? title,
          String? tagline,
          String? url,
          String? baseUrl,
          String? timezone,
          String? language,
          String? currency,
          String? dateFormat,
          String? timeFormat,
          bool? debugMode,
          bool? developmentMode,
          bool? maintenanceMode,
          String? maintenanceMessage,
          Map<String, dynamic>? options,
          Map<String, dynamic>? permissions,
          Map<String, dynamic>? features}) =>
      $apply(FieldCopyWithData({
        if (versionId != null) #versionId: versionId,
        if (versionString != null) #versionString: versionString,
        if (apiVersion != null) #apiVersion: apiVersion,
        if (title != null) #title: title,
        if (tagline != null) #tagline: tagline,
        if (url != null) #url: url,
        if (baseUrl != null) #baseUrl: baseUrl,
        if (timezone != null) #timezone: timezone,
        if (language != null) #language: language,
        if (currency != null) #currency: currency,
        if (dateFormat != null) #dateFormat: dateFormat,
        if (timeFormat != null) #timeFormat: timeFormat,
        if (debugMode != null) #debugMode: debugMode,
        if (developmentMode != null) #developmentMode: developmentMode,
        if (maintenanceMode != null) #maintenanceMode: maintenanceMode,
        if (maintenanceMessage != null) #maintenanceMessage: maintenanceMessage,
        if (options != null) #options: options,
        if (permissions != null) #permissions: permissions,
        if (features != null) #features: features
      }));
  @override
  XenForoConfig $make(CopyWithData data) => XenForoConfig(
      versionId: data.get(#versionId, or: $value.versionId),
      versionString: data.get(#versionString, or: $value.versionString),
      apiVersion: data.get(#apiVersion, or: $value.apiVersion),
      title: data.get(#title, or: $value.title),
      tagline: data.get(#tagline, or: $value.tagline),
      url: data.get(#url, or: $value.url),
      baseUrl: data.get(#baseUrl, or: $value.baseUrl),
      timezone: data.get(#timezone, or: $value.timezone),
      language: data.get(#language, or: $value.language),
      currency: data.get(#currency, or: $value.currency),
      dateFormat: data.get(#dateFormat, or: $value.dateFormat),
      timeFormat: data.get(#timeFormat, or: $value.timeFormat),
      debugMode: data.get(#debugMode, or: $value.debugMode),
      developmentMode: data.get(#developmentMode, or: $value.developmentMode),
      maintenanceMode: data.get(#maintenanceMode, or: $value.maintenanceMode),
      maintenanceMessage:
          data.get(#maintenanceMessage, or: $value.maintenanceMessage),
      options: data.get(#options, or: $value.options),
      permissions: data.get(#permissions, or: $value.permissions),
      features: data.get(#features, or: $value.features));

  @override
  XenForoConfigCopyWith<$R2, XenForoConfig, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _XenForoConfigCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
