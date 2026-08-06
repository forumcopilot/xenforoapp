// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fc_reaction_result.dart';

class FCToggleReactionResultMapper
    extends ClassMapperBase<FCToggleReactionResult> {
  FCToggleReactionResultMapper._();

  static FCToggleReactionResultMapper? _instance;
  static FCToggleReactionResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCToggleReactionResultMapper._());
      FCBaseResultMapper.ensureInitialized();
      FCPostReactionMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCToggleReactionResult';

  static bool _$result(FCToggleReactionResult v) => v.result;
  static const Field<FCToggleReactionResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCToggleReactionResult v) => v.resultText;
  static const Field<FCToggleReactionResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static List<FCPostReaction> _$reactions(FCToggleReactionResult v) =>
      v.reactions;
  static const Field<FCToggleReactionResult, List<FCPostReaction>>
  _f$reactions = Field('reactions', _$reactions, opt: true, def: const []);

  @override
  final MappableFields<FCToggleReactionResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #reactions: _f$reactions,
  };

  static FCToggleReactionResult _instantiate(DecodingData data) {
    return FCToggleReactionResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      reactions: data.dec(_f$reactions),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCToggleReactionResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCToggleReactionResult>(map);
  }

  static FCToggleReactionResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCToggleReactionResult>(json);
  }
}

mixin FCToggleReactionResultMappable {
  String toJson() {
    return FCToggleReactionResultMapper.ensureInitialized()
        .encodeJson<FCToggleReactionResult>(this as FCToggleReactionResult);
  }

  Map<String, dynamic> toMap() {
    return FCToggleReactionResultMapper.ensureInitialized()
        .encodeMap<FCToggleReactionResult>(this as FCToggleReactionResult);
  }

  FCToggleReactionResultCopyWith<
    FCToggleReactionResult,
    FCToggleReactionResult,
    FCToggleReactionResult
  >
  get copyWith =>
      _FCToggleReactionResultCopyWithImpl<
        FCToggleReactionResult,
        FCToggleReactionResult
      >(this as FCToggleReactionResult, $identity, $identity);
  @override
  String toString() {
    return FCToggleReactionResultMapper.ensureInitialized().stringifyValue(
      this as FCToggleReactionResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCToggleReactionResultMapper.ensureInitialized().equalsValue(
      this as FCToggleReactionResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCToggleReactionResultMapper.ensureInitialized().hashValue(
      this as FCToggleReactionResult,
    );
  }
}

extension FCToggleReactionResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCToggleReactionResult, $Out> {
  FCToggleReactionResultCopyWith<$R, FCToggleReactionResult, $Out>
  get $asFCToggleReactionResult => $base.as(
    (v, t, t2) => _FCToggleReactionResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCToggleReactionResultCopyWith<
  $R,
  $In extends FCToggleReactionResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    FCPostReaction,
    FCPostReactionCopyWith<$R, FCPostReaction, FCPostReaction>
  >
  get reactions;
  @override
  $R call({bool? result, String? resultText, List<FCPostReaction>? reactions});
  FCToggleReactionResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCToggleReactionResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCToggleReactionResult, $Out>
    implements
        FCToggleReactionResultCopyWith<$R, FCToggleReactionResult, $Out> {
  _FCToggleReactionResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCToggleReactionResult> $mapper =
      FCToggleReactionResultMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    FCPostReaction,
    FCPostReactionCopyWith<$R, FCPostReaction, FCPostReaction>
  >
  get reactions => ListCopyWith(
    $value.reactions,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(reactions: v),
  );
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
    List<FCPostReaction>? reactions,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (reactions != null) #reactions: reactions,
    }),
  );
  @override
  FCToggleReactionResult $make(CopyWithData data) => FCToggleReactionResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    reactions: data.get(#reactions, or: $value.reactions),
  );

  @override
  FCToggleReactionResultCopyWith<$R2, FCToggleReactionResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCToggleReactionResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCAvailableReactionsResultMapper
    extends ClassMapperBase<FCAvailableReactionsResult> {
  FCAvailableReactionsResultMapper._();

  static FCAvailableReactionsResultMapper? _instance;
  static FCAvailableReactionsResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = FCAvailableReactionsResultMapper._(),
      );
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCAvailableReactionsResult';

  static bool _$result(FCAvailableReactionsResult v) => v.result;
  static const Field<FCAvailableReactionsResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCAvailableReactionsResult v) => v.resultText;
  static const Field<FCAvailableReactionsResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static List<String> _$reactions(FCAvailableReactionsResult v) => v.reactions;
  static const Field<FCAvailableReactionsResult, List<String>> _f$reactions =
      Field('reactions', _$reactions, opt: true, def: const []);

  @override
  final MappableFields<FCAvailableReactionsResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #reactions: _f$reactions,
  };

  static FCAvailableReactionsResult _instantiate(DecodingData data) {
    return FCAvailableReactionsResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      reactions: data.dec(_f$reactions),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCAvailableReactionsResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCAvailableReactionsResult>(map);
  }

  static FCAvailableReactionsResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCAvailableReactionsResult>(json);
  }
}

mixin FCAvailableReactionsResultMappable {
  String toJson() {
    return FCAvailableReactionsResultMapper.ensureInitialized()
        .encodeJson<FCAvailableReactionsResult>(
          this as FCAvailableReactionsResult,
        );
  }

  Map<String, dynamic> toMap() {
    return FCAvailableReactionsResultMapper.ensureInitialized()
        .encodeMap<FCAvailableReactionsResult>(
          this as FCAvailableReactionsResult,
        );
  }

  FCAvailableReactionsResultCopyWith<
    FCAvailableReactionsResult,
    FCAvailableReactionsResult,
    FCAvailableReactionsResult
  >
  get copyWith =>
      _FCAvailableReactionsResultCopyWithImpl<
        FCAvailableReactionsResult,
        FCAvailableReactionsResult
      >(this as FCAvailableReactionsResult, $identity, $identity);
  @override
  String toString() {
    return FCAvailableReactionsResultMapper.ensureInitialized().stringifyValue(
      this as FCAvailableReactionsResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCAvailableReactionsResultMapper.ensureInitialized().equalsValue(
      this as FCAvailableReactionsResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCAvailableReactionsResultMapper.ensureInitialized().hashValue(
      this as FCAvailableReactionsResult,
    );
  }
}

extension FCAvailableReactionsResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCAvailableReactionsResult, $Out> {
  FCAvailableReactionsResultCopyWith<$R, FCAvailableReactionsResult, $Out>
  get $asFCAvailableReactionsResult => $base.as(
    (v, t, t2) => _FCAvailableReactionsResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCAvailableReactionsResultCopyWith<
  $R,
  $In extends FCAvailableReactionsResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get reactions;
  @override
  $R call({bool? result, String? resultText, List<String>? reactions});
  FCAvailableReactionsResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCAvailableReactionsResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCAvailableReactionsResult, $Out>
    implements
        FCAvailableReactionsResultCopyWith<
          $R,
          FCAvailableReactionsResult,
          $Out
        > {
  _FCAvailableReactionsResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCAvailableReactionsResult> $mapper =
      FCAvailableReactionsResultMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get reactions =>
      ListCopyWith(
        $value.reactions,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(reactions: v),
      );
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
    List<String>? reactions,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (reactions != null) #reactions: reactions,
    }),
  );
  @override
  FCAvailableReactionsResult $make(CopyWithData data) =>
      FCAvailableReactionsResult(
        result: data.get(#result, or: $value.result),
        resultText: data.get(#resultText, or: $value.resultText),
        reactions: data.get(#reactions, or: $value.reactions),
      );

  @override
  FCAvailableReactionsResultCopyWith<$R2, FCAvailableReactionsResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCAvailableReactionsResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCPostVoteResultMapper extends ClassMapperBase<FCPostVoteResult> {
  FCPostVoteResultMapper._();

  static FCPostVoteResultMapper? _instance;
  static FCPostVoteResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCPostVoteResultMapper._());
      FCBaseResultMapper.ensureInitialized();
      FCPostVoteMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCPostVoteResult';

  static bool _$result(FCPostVoteResult v) => v.result;
  static const Field<FCPostVoteResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCPostVoteResult v) => v.resultText;
  static const Field<FCPostVoteResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static FCPostVote? _$vote(FCPostVoteResult v) => v.vote;
  static const Field<FCPostVoteResult, FCPostVote> _f$vote = Field(
    'vote',
    _$vote,
    opt: true,
  );

  @override
  final MappableFields<FCPostVoteResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #vote: _f$vote,
  };

  static FCPostVoteResult _instantiate(DecodingData data) {
    return FCPostVoteResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      vote: data.dec(_f$vote),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCPostVoteResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCPostVoteResult>(map);
  }

  static FCPostVoteResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCPostVoteResult>(json);
  }
}

mixin FCPostVoteResultMappable {
  String toJson() {
    return FCPostVoteResultMapper.ensureInitialized()
        .encodeJson<FCPostVoteResult>(this as FCPostVoteResult);
  }

  Map<String, dynamic> toMap() {
    return FCPostVoteResultMapper.ensureInitialized()
        .encodeMap<FCPostVoteResult>(this as FCPostVoteResult);
  }

  FCPostVoteResultCopyWith<FCPostVoteResult, FCPostVoteResult, FCPostVoteResult>
  get copyWith =>
      _FCPostVoteResultCopyWithImpl<FCPostVoteResult, FCPostVoteResult>(
        this as FCPostVoteResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCPostVoteResultMapper.ensureInitialized().stringifyValue(
      this as FCPostVoteResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCPostVoteResultMapper.ensureInitialized().equalsValue(
      this as FCPostVoteResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCPostVoteResultMapper.ensureInitialized().hashValue(
      this as FCPostVoteResult,
    );
  }
}

extension FCPostVoteResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCPostVoteResult, $Out> {
  FCPostVoteResultCopyWith<$R, FCPostVoteResult, $Out>
  get $asFCPostVoteResult =>
      $base.as((v, t, t2) => _FCPostVoteResultCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCPostVoteResultCopyWith<$R, $In extends FCPostVoteResult, $Out>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  FCPostVoteCopyWith<$R, FCPostVote, FCPostVote>? get vote;
  @override
  $R call({bool? result, String? resultText, FCPostVote? vote});
  FCPostVoteResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCPostVoteResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCPostVoteResult, $Out>
    implements FCPostVoteResultCopyWith<$R, FCPostVoteResult, $Out> {
  _FCPostVoteResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCPostVoteResult> $mapper =
      FCPostVoteResultMapper.ensureInitialized();
  @override
  FCPostVoteCopyWith<$R, FCPostVote, FCPostVote>? get vote =>
      $value.vote?.copyWith.$chain((v) => call(vote: v));
  @override
  $R call({bool? result, Object? resultText = $none, Object? vote = $none}) =>
      $apply(
        FieldCopyWithData({
          if (result != null) #result: result,
          if (resultText != $none) #resultText: resultText,
          if (vote != $none) #vote: vote,
        }),
      );
  @override
  FCPostVoteResult $make(CopyWithData data) => FCPostVoteResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    vote: data.get(#vote, or: $value.vote),
  );

  @override
  FCPostVoteResultCopyWith<$R2, FCPostVoteResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCPostVoteResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

