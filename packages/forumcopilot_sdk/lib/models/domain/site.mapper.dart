// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'site.dart';

class SiteMapper extends ClassMapperBase<Site> {
  SiteMapper._();

  static SiteMapper? _instance;
  static SiteMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SiteMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Site';

  static int? _$id(Site v) => v.id;
  static const Field<Site, int> _f$id = Field('id', _$id, opt: true);
  static String _$name(Site v) => v.name;
  static const Field<Site, String> _f$name = Field('name', _$name);
  static String _$url(Site v) => v.url;
  static const Field<Site, String> _f$url = Field('url', _$url);
  static String _$description(Site v) => v.description;
  static const Field<Site, String> _f$description = Field(
    'description',
    _$description,
  );
  static String? _$logoUrl(Site v) => v.logoUrl;
  static const Field<Site, String> _f$logoUrl = Field(
    'logoUrl',
    _$logoUrl,
    opt: true,
  );
  static String? _$backgroundUrl(Site v) => v.backgroundUrl;
  static const Field<Site, String> _f$backgroundUrl = Field(
    'backgroundUrl',
    _$backgroundUrl,
    opt: true,
  );
  static String? _$endpoint(Site v) => v.endpoint;
  static const Field<Site, String> _f$endpoint = Field(
    'endpoint',
    _$endpoint,
    opt: true,
  );
  static String? _$baseUrl(Site v) => v.baseUrl;
  static const Field<Site, String> _f$baseUrl = Field(
    'baseUrl',
    _$baseUrl,
    opt: true,
  );
  static String _$siteType(Site v) => v.siteType;
  static const Field<Site, String> _f$siteType = Field('siteType', _$siteType);
  static String? _$language(Site v) => v.language;
  static const Field<Site, String> _f$language = Field(
    'language',
    _$language,
    opt: true,
  );
  static String? _$country(Site v) => v.country;
  static const Field<Site, String> _f$country = Field(
    'country',
    _$country,
    opt: true,
  );

  @override
  final MappableFields<Site> fields = const {
    #id: _f$id,
    #name: _f$name,
    #url: _f$url,
    #description: _f$description,
    #logoUrl: _f$logoUrl,
    #backgroundUrl: _f$backgroundUrl,
    #endpoint: _f$endpoint,
    #baseUrl: _f$baseUrl,
    #siteType: _f$siteType,
    #language: _f$language,
    #country: _f$country,
  };

  static Site _instantiate(DecodingData data) {
    return Site(
      id: data.dec(_f$id),
      name: data.dec(_f$name),
      url: data.dec(_f$url),
      description: data.dec(_f$description),
      logoUrl: data.dec(_f$logoUrl),
      backgroundUrl: data.dec(_f$backgroundUrl),
      endpoint: data.dec(_f$endpoint),
      baseUrl: data.dec(_f$baseUrl),
      siteType: data.dec(_f$siteType),
      language: data.dec(_f$language),
      country: data.dec(_f$country),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Site fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Site>(map);
  }

  static Site fromJson(String json) {
    return ensureInitialized().decodeJson<Site>(json);
  }
}

mixin SiteMappable {
  String toJson() {
    return SiteMapper.ensureInitialized().encodeJson<Site>(this as Site);
  }

  Map<String, dynamic> toMap() {
    return SiteMapper.ensureInitialized().encodeMap<Site>(this as Site);
  }

  SiteCopyWith<Site, Site, Site> get copyWith =>
      _SiteCopyWithImpl<Site, Site>(this as Site, $identity, $identity);
  @override
  String toString() {
    return SiteMapper.ensureInitialized().stringifyValue(this as Site);
  }

  @override
  bool operator ==(Object other) {
    return SiteMapper.ensureInitialized().equalsValue(this as Site, other);
  }

  @override
  int get hashCode {
    return SiteMapper.ensureInitialized().hashValue(this as Site);
  }
}

extension SiteValueCopy<$R, $Out> on ObjectCopyWith<$R, Site, $Out> {
  SiteCopyWith<$R, Site, $Out> get $asSite =>
      $base.as((v, t, t2) => _SiteCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SiteCopyWith<$R, $In extends Site, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    int? id,
    String? name,
    String? url,
    String? description,
    String? logoUrl,
    String? backgroundUrl,
    String? endpoint,
    String? baseUrl,
    String? siteType,
    String? language,
    String? country,
  });
  SiteCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _SiteCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Site, $Out>
    implements SiteCopyWith<$R, Site, $Out> {
  _SiteCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Site> $mapper = SiteMapper.ensureInitialized();
  @override
  $R call({
    Object? id = $none,
    String? name,
    String? url,
    String? description,
    Object? logoUrl = $none,
    Object? backgroundUrl = $none,
    Object? endpoint = $none,
    Object? baseUrl = $none,
    String? siteType,
    Object? language = $none,
    Object? country = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != $none) #id: id,
      if (name != null) #name: name,
      if (url != null) #url: url,
      if (description != null) #description: description,
      if (logoUrl != $none) #logoUrl: logoUrl,
      if (backgroundUrl != $none) #backgroundUrl: backgroundUrl,
      if (endpoint != $none) #endpoint: endpoint,
      if (baseUrl != $none) #baseUrl: baseUrl,
      if (siteType != null) #siteType: siteType,
      if (language != $none) #language: language,
      if (country != $none) #country: country,
    }),
  );
  @override
  Site $make(CopyWithData data) => Site(
    id: data.get(#id, or: $value.id),
    name: data.get(#name, or: $value.name),
    url: data.get(#url, or: $value.url),
    description: data.get(#description, or: $value.description),
    logoUrl: data.get(#logoUrl, or: $value.logoUrl),
    backgroundUrl: data.get(#backgroundUrl, or: $value.backgroundUrl),
    endpoint: data.get(#endpoint, or: $value.endpoint),
    baseUrl: data.get(#baseUrl, or: $value.baseUrl),
    siteType: data.get(#siteType, or: $value.siteType),
    language: data.get(#language, or: $value.language),
    country: data.get(#country, or: $value.country),
  );

  @override
  SiteCopyWith<$R2, Site, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _SiteCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

