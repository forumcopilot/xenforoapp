// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fc_forum.dart';

class FCForumMapper extends ClassMapperBase<FCForum> {
  FCForumMapper._();

  static FCForumMapper? _instance;
  static FCForumMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCForumMapper._());
      FCForumMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCForum';

  static String _$id(FCForum v) => v.id;
  static const Field<FCForum, String> _f$id = Field('id', _$id);
  static String _$name(FCForum v) => v.name;
  static const Field<FCForum, String> _f$name = Field('name', _$name);
  static String? _$description(FCForum v) => v.description;
  static const Field<FCForum, String> _f$description = Field(
    'description',
    _$description,
    opt: true,
  );
  static String? _$logoUrl(FCForum v) => v.logoUrl;
  static const Field<FCForum, String> _f$logoUrl = Field(
    'logoUrl',
    _$logoUrl,
    opt: true,
  );
  static String? _$backgroundUrl(FCForum v) => v.backgroundUrl;
  static const Field<FCForum, String> _f$backgroundUrl = Field(
    'backgroundUrl',
    _$backgroundUrl,
    opt: true,
  );
  static String? _$parentId(FCForum v) => v.parentId;
  static const Field<FCForum, String> _f$parentId = Field(
    'parentId',
    _$parentId,
    opt: true,
  );
  static bool _$hasNewPosts(FCForum v) => v.hasNewPosts;
  static const Field<FCForum, bool> _f$hasNewPosts = Field(
    'hasNewPosts',
    _$hasNewPosts,
    opt: true,
    def: false,
  );
  static bool _$isProtected(FCForum v) => v.isProtected;
  static const Field<FCForum, bool> _f$isProtected = Field(
    'isProtected',
    _$isProtected,
    opt: true,
    def: false,
  );
  static bool _$isSubscribed(FCForum v) => v.isSubscribed;
  static const Field<FCForum, bool> _f$isSubscribed = Field(
    'isSubscribed',
    _$isSubscribed,
    opt: true,
    def: false,
  );
  static bool _$canSubscribe(FCForum v) => v.canSubscribe;
  static const Field<FCForum, bool> _f$canSubscribe = Field(
    'canSubscribe',
    _$canSubscribe,
    opt: true,
    def: true,
  );
  static bool _$canPost(FCForum v) => v.canPost;
  static const Field<FCForum, bool> _f$canPost = Field(
    'canPost',
    _$canPost,
    opt: true,
    def: true,
  );
  static bool _$canUpload(FCForum v) => v.canUpload;
  static const Field<FCForum, bool> _f$canUpload = Field(
    'canUpload',
    _$canUpload,
    opt: true,
    def: true,
  );
  static bool _$canViewContent(FCForum v) => v.canViewContent;
  static const Field<FCForum, bool> _f$canViewContent = Field(
    'canViewContent',
    _$canViewContent,
    opt: true,
    def: true,
  );
  static String? _$externalUrl(FCForum v) => v.externalUrl;
  static const Field<FCForum, String> _f$externalUrl = Field(
    'externalUrl',
    _$externalUrl,
    opt: true,
  );
  static bool _$isLinkForum(FCForum v) => v.isLinkForum;
  static const Field<FCForum, bool> _f$isLinkForum = Field(
    'isLinkForum',
    _$isLinkForum,
    opt: true,
    def: false,
  );
  static bool _$isSubForumContainer(FCForum v) => v.isSubForumContainer;
  static const Field<FCForum, bool> _f$isSubForumContainer = Field(
    'isSubForumContainer',
    _$isSubForumContainer,
    opt: true,
    def: false,
  );
  static List<FCForum> _$childForums(FCForum v) => v.childForums;
  static const Field<FCForum, List<FCForum>> _f$childForums = Field(
    'childForums',
    _$childForums,
    opt: true,
    def: const [],
  );

  @override
  final MappableFields<FCForum> fields = const {
    #id: _f$id,
    #name: _f$name,
    #description: _f$description,
    #logoUrl: _f$logoUrl,
    #backgroundUrl: _f$backgroundUrl,
    #parentId: _f$parentId,
    #hasNewPosts: _f$hasNewPosts,
    #isProtected: _f$isProtected,
    #isSubscribed: _f$isSubscribed,
    #canSubscribe: _f$canSubscribe,
    #canPost: _f$canPost,
    #canUpload: _f$canUpload,
    #canViewContent: _f$canViewContent,
    #externalUrl: _f$externalUrl,
    #isLinkForum: _f$isLinkForum,
    #isSubForumContainer: _f$isSubForumContainer,
    #childForums: _f$childForums,
  };

  static FCForum _instantiate(DecodingData data) {
    return FCForum(
      id: data.dec(_f$id),
      name: data.dec(_f$name),
      description: data.dec(_f$description),
      logoUrl: data.dec(_f$logoUrl),
      backgroundUrl: data.dec(_f$backgroundUrl),
      parentId: data.dec(_f$parentId),
      hasNewPosts: data.dec(_f$hasNewPosts),
      isProtected: data.dec(_f$isProtected),
      isSubscribed: data.dec(_f$isSubscribed),
      canSubscribe: data.dec(_f$canSubscribe),
      canPost: data.dec(_f$canPost),
      canUpload: data.dec(_f$canUpload),
      canViewContent: data.dec(_f$canViewContent),
      externalUrl: data.dec(_f$externalUrl),
      isLinkForum: data.dec(_f$isLinkForum),
      isSubForumContainer: data.dec(_f$isSubForumContainer),
      childForums: data.dec(_f$childForums),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCForum fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCForum>(map);
  }

  static FCForum fromJson(String json) {
    return ensureInitialized().decodeJson<FCForum>(json);
  }
}

mixin FCForumMappable {
  String toJson() {
    return FCForumMapper.ensureInitialized().encodeJson<FCForum>(
      this as FCForum,
    );
  }

  Map<String, dynamic> toMap() {
    return FCForumMapper.ensureInitialized().encodeMap<FCForum>(
      this as FCForum,
    );
  }

  FCForumCopyWith<FCForum, FCForum, FCForum> get copyWith =>
      _FCForumCopyWithImpl<FCForum, FCForum>(
        this as FCForum,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCForumMapper.ensureInitialized().stringifyValue(this as FCForum);
  }

  @override
  bool operator ==(Object other) {
    return FCForumMapper.ensureInitialized().equalsValue(
      this as FCForum,
      other,
    );
  }

  @override
  int get hashCode {
    return FCForumMapper.ensureInitialized().hashValue(this as FCForum);
  }
}

extension FCForumValueCopy<$R, $Out> on ObjectCopyWith<$R, FCForum, $Out> {
  FCForumCopyWith<$R, FCForum, $Out> get $asFCForum =>
      $base.as((v, t, t2) => _FCForumCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCForumCopyWith<$R, $In extends FCForum, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, FCForum, FCForumCopyWith<$R, FCForum, FCForum>>
  get childForums;
  $R call({
    String? id,
    String? name,
    String? description,
    String? logoUrl,
    String? backgroundUrl,
    String? parentId,
    bool? hasNewPosts,
    bool? isProtected,
    bool? isSubscribed,
    bool? canSubscribe,
    bool? canPost,
    bool? canUpload,
    bool? canViewContent,
    String? externalUrl,
    bool? isLinkForum,
    bool? isSubForumContainer,
    List<FCForum>? childForums,
  });
  FCForumCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FCForumCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCForum, $Out>
    implements FCForumCopyWith<$R, FCForum, $Out> {
  _FCForumCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCForum> $mapper =
      FCForumMapper.ensureInitialized();
  @override
  ListCopyWith<$R, FCForum, FCForumCopyWith<$R, FCForum, FCForum>>
  get childForums => ListCopyWith(
    $value.childForums,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(childForums: v),
  );
  @override
  $R call({
    String? id,
    String? name,
    Object? description = $none,
    Object? logoUrl = $none,
    Object? backgroundUrl = $none,
    Object? parentId = $none,
    bool? hasNewPosts,
    bool? isProtected,
    bool? isSubscribed,
    bool? canSubscribe,
    bool? canPost,
    bool? canUpload,
    bool? canViewContent,
    Object? externalUrl = $none,
    bool? isLinkForum,
    bool? isSubForumContainer,
    List<FCForum>? childForums,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (name != null) #name: name,
      if (description != $none) #description: description,
      if (logoUrl != $none) #logoUrl: logoUrl,
      if (backgroundUrl != $none) #backgroundUrl: backgroundUrl,
      if (parentId != $none) #parentId: parentId,
      if (hasNewPosts != null) #hasNewPosts: hasNewPosts,
      if (isProtected != null) #isProtected: isProtected,
      if (isSubscribed != null) #isSubscribed: isSubscribed,
      if (canSubscribe != null) #canSubscribe: canSubscribe,
      if (canPost != null) #canPost: canPost,
      if (canUpload != null) #canUpload: canUpload,
      if (canViewContent != null) #canViewContent: canViewContent,
      if (externalUrl != $none) #externalUrl: externalUrl,
      if (isLinkForum != null) #isLinkForum: isLinkForum,
      if (isSubForumContainer != null)
        #isSubForumContainer: isSubForumContainer,
      if (childForums != null) #childForums: childForums,
    }),
  );
  @override
  FCForum $make(CopyWithData data) => FCForum(
    id: data.get(#id, or: $value.id),
    name: data.get(#name, or: $value.name),
    description: data.get(#description, or: $value.description),
    logoUrl: data.get(#logoUrl, or: $value.logoUrl),
    backgroundUrl: data.get(#backgroundUrl, or: $value.backgroundUrl),
    parentId: data.get(#parentId, or: $value.parentId),
    hasNewPosts: data.get(#hasNewPosts, or: $value.hasNewPosts),
    isProtected: data.get(#isProtected, or: $value.isProtected),
    isSubscribed: data.get(#isSubscribed, or: $value.isSubscribed),
    canSubscribe: data.get(#canSubscribe, or: $value.canSubscribe),
    canPost: data.get(#canPost, or: $value.canPost),
    canUpload: data.get(#canUpload, or: $value.canUpload),
    canViewContent: data.get(#canViewContent, or: $value.canViewContent),
    externalUrl: data.get(#externalUrl, or: $value.externalUrl),
    isLinkForum: data.get(#isLinkForum, or: $value.isLinkForum),
    isSubForumContainer: data.get(
      #isSubForumContainer,
      or: $value.isSubForumContainer,
    ),
    childForums: data.get(#childForums, or: $value.childForums),
  );

  @override
  FCForumCopyWith<$R2, FCForum, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCForumCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

