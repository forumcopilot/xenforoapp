// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'poll.dart';

class XenForoPollMapper extends ClassMapperBase<XenForoPoll> {
  XenForoPollMapper._();

  static XenForoPollMapper? _instance;
  static XenForoPollMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = XenForoPollMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'XenForoPoll';

  static bool? _$canVote(XenForoPoll v) => v.canVote;
  static const Field<XenForoPoll, bool> _f$canVote = Field(
    'canVote',
    _$canVote,
    opt: true,
  );
  static bool? _$hasVoted(XenForoPoll v) => v.hasVoted;
  static const Field<XenForoPoll, bool> _f$hasVoted = Field(
    'hasVoted',
    _$hasVoted,
    opt: true,
  );
  static List<Map<String, dynamic>>? _$responses(XenForoPoll v) => v.responses;
  static const Field<XenForoPoll, List<Map<String, dynamic>>> _f$responses =
      Field('responses', _$responses, opt: true);
  static int _$pollId(XenForoPoll v) => v.pollId;
  static const Field<XenForoPoll, int> _f$pollId = Field('pollId', _$pollId);
  static String? _$question(XenForoPoll v) => v.question;
  static const Field<XenForoPoll, String> _f$question = Field(
    'question',
    _$question,
    opt: true,
  );
  static int? _$voterCount(XenForoPoll v) => v.voterCount;
  static const Field<XenForoPoll, int> _f$voterCount = Field(
    'voterCount',
    _$voterCount,
    opt: true,
  );
  static bool? _$publicVotes(XenForoPoll v) => v.publicVotes;
  static const Field<XenForoPoll, bool> _f$publicVotes = Field(
    'publicVotes',
    _$publicVotes,
    opt: true,
  );
  static int? _$maxVotes(XenForoPoll v) => v.maxVotes;
  static const Field<XenForoPoll, int> _f$maxVotes = Field(
    'maxVotes',
    _$maxVotes,
    opt: true,
  );
  static int? _$closeDate(XenForoPoll v) => v.closeDate;
  static const Field<XenForoPoll, int> _f$closeDate = Field(
    'closeDate',
    _$closeDate,
    opt: true,
  );
  static bool? _$changeVote(XenForoPoll v) => v.changeVote;
  static const Field<XenForoPoll, bool> _f$changeVote = Field(
    'changeVote',
    _$changeVote,
    opt: true,
  );
  static bool? _$viewResultsUnvoted(XenForoPoll v) => v.viewResultsUnvoted;
  static const Field<XenForoPoll, bool> _f$viewResultsUnvoted = Field(
    'viewResultsUnvoted',
    _$viewResultsUnvoted,
    opt: true,
  );

  @override
  final MappableFields<XenForoPoll> fields = const {
    #canVote: _f$canVote,
    #hasVoted: _f$hasVoted,
    #responses: _f$responses,
    #pollId: _f$pollId,
    #question: _f$question,
    #voterCount: _f$voterCount,
    #publicVotes: _f$publicVotes,
    #maxVotes: _f$maxVotes,
    #closeDate: _f$closeDate,
    #changeVote: _f$changeVote,
    #viewResultsUnvoted: _f$viewResultsUnvoted,
  };

  static XenForoPoll _instantiate(DecodingData data) {
    return XenForoPoll(
      canVote: data.dec(_f$canVote),
      hasVoted: data.dec(_f$hasVoted),
      responses: data.dec(_f$responses),
      pollId: data.dec(_f$pollId),
      question: data.dec(_f$question),
      voterCount: data.dec(_f$voterCount),
      publicVotes: data.dec(_f$publicVotes),
      maxVotes: data.dec(_f$maxVotes),
      closeDate: data.dec(_f$closeDate),
      changeVote: data.dec(_f$changeVote),
      viewResultsUnvoted: data.dec(_f$viewResultsUnvoted),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static XenForoPoll fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<XenForoPoll>(map);
  }

  static XenForoPoll fromJson(String json) {
    return ensureInitialized().decodeJson<XenForoPoll>(json);
  }
}

mixin XenForoPollMappable {
  String toJson() {
    return XenForoPollMapper.ensureInitialized().encodeJson<XenForoPoll>(
      this as XenForoPoll,
    );
  }

  Map<String, dynamic> toMap() {
    return XenForoPollMapper.ensureInitialized().encodeMap<XenForoPoll>(
      this as XenForoPoll,
    );
  }

  XenForoPollCopyWith<XenForoPoll, XenForoPoll, XenForoPoll> get copyWith =>
      _XenForoPollCopyWithImpl<XenForoPoll, XenForoPoll>(
        this as XenForoPoll,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return XenForoPollMapper.ensureInitialized().stringifyValue(
      this as XenForoPoll,
    );
  }

  @override
  bool operator ==(Object other) {
    return XenForoPollMapper.ensureInitialized().equalsValue(
      this as XenForoPoll,
      other,
    );
  }

  @override
  int get hashCode {
    return XenForoPollMapper.ensureInitialized().hashValue(this as XenForoPoll);
  }
}

extension XenForoPollValueCopy<$R, $Out>
    on ObjectCopyWith<$R, XenForoPoll, $Out> {
  XenForoPollCopyWith<$R, XenForoPoll, $Out> get $asXenForoPoll =>
      $base.as((v, t, t2) => _XenForoPollCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class XenForoPollCopyWith<$R, $In extends XenForoPoll, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    Map<String, dynamic>,
    ObjectCopyWith<$R, Map<String, dynamic>, Map<String, dynamic>>
  >?
  get responses;
  $R call({
    bool? canVote,
    bool? hasVoted,
    List<Map<String, dynamic>>? responses,
    int? pollId,
    String? question,
    int? voterCount,
    bool? publicVotes,
    int? maxVotes,
    int? closeDate,
    bool? changeVote,
    bool? viewResultsUnvoted,
  });
  XenForoPollCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _XenForoPollCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, XenForoPoll, $Out>
    implements XenForoPollCopyWith<$R, XenForoPoll, $Out> {
  _XenForoPollCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<XenForoPoll> $mapper =
      XenForoPollMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    Map<String, dynamic>,
    ObjectCopyWith<$R, Map<String, dynamic>, Map<String, dynamic>>
  >?
  get responses => $value.responses != null
      ? ListCopyWith(
          $value.responses!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(responses: v),
        )
      : null;
  @override
  $R call({
    Object? canVote = $none,
    Object? hasVoted = $none,
    Object? responses = $none,
    int? pollId,
    Object? question = $none,
    Object? voterCount = $none,
    Object? publicVotes = $none,
    Object? maxVotes = $none,
    Object? closeDate = $none,
    Object? changeVote = $none,
    Object? viewResultsUnvoted = $none,
  }) => $apply(
    FieldCopyWithData({
      if (canVote != $none) #canVote: canVote,
      if (hasVoted != $none) #hasVoted: hasVoted,
      if (responses != $none) #responses: responses,
      if (pollId != null) #pollId: pollId,
      if (question != $none) #question: question,
      if (voterCount != $none) #voterCount: voterCount,
      if (publicVotes != $none) #publicVotes: publicVotes,
      if (maxVotes != $none) #maxVotes: maxVotes,
      if (closeDate != $none) #closeDate: closeDate,
      if (changeVote != $none) #changeVote: changeVote,
      if (viewResultsUnvoted != $none) #viewResultsUnvoted: viewResultsUnvoted,
    }),
  );
  @override
  XenForoPoll $make(CopyWithData data) => XenForoPoll(
    canVote: data.get(#canVote, or: $value.canVote),
    hasVoted: data.get(#hasVoted, or: $value.hasVoted),
    responses: data.get(#responses, or: $value.responses),
    pollId: data.get(#pollId, or: $value.pollId),
    question: data.get(#question, or: $value.question),
    voterCount: data.get(#voterCount, or: $value.voterCount),
    publicVotes: data.get(#publicVotes, or: $value.publicVotes),
    maxVotes: data.get(#maxVotes, or: $value.maxVotes),
    closeDate: data.get(#closeDate, or: $value.closeDate),
    changeVote: data.get(#changeVote, or: $value.changeVote),
    viewResultsUnvoted: data.get(
      #viewResultsUnvoted,
      or: $value.viewResultsUnvoted,
    ),
  );

  @override
  XenForoPollCopyWith<$R2, XenForoPoll, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _XenForoPollCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

