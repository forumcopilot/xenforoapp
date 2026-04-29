// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fc_poll.dart';

class FCPollResponseMapper extends ClassMapperBase<FCPollResponse> {
  FCPollResponseMapper._();

  static FCPollResponseMapper? _instance;
  static FCPollResponseMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCPollResponseMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FCPollResponse';

  static String _$id(FCPollResponse v) => v.id;
  static const Field<FCPollResponse, String> _f$id = Field('id', _$id);
  static String _$text(FCPollResponse v) => v.text;
  static const Field<FCPollResponse, String> _f$text = Field('text', _$text);
  static int? _$voteCount(FCPollResponse v) => v.voteCount;
  static const Field<FCPollResponse, int> _f$voteCount = Field(
    'voteCount',
    _$voteCount,
    opt: true,
  );
  static bool _$viewerVotedFor(FCPollResponse v) => v.viewerVotedFor;
  static const Field<FCPollResponse, bool> _f$viewerVotedFor = Field(
    'viewerVotedFor',
    _$viewerVotedFor,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<FCPollResponse> fields = const {
    #id: _f$id,
    #text: _f$text,
    #voteCount: _f$voteCount,
    #viewerVotedFor: _f$viewerVotedFor,
  };

  static FCPollResponse _instantiate(DecodingData data) {
    return FCPollResponse(
      id: data.dec(_f$id),
      text: data.dec(_f$text),
      voteCount: data.dec(_f$voteCount),
      viewerVotedFor: data.dec(_f$viewerVotedFor),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCPollResponse fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCPollResponse>(map);
  }

  static FCPollResponse fromJson(String json) {
    return ensureInitialized().decodeJson<FCPollResponse>(json);
  }
}

mixin FCPollResponseMappable {
  String toJson() {
    return FCPollResponseMapper.ensureInitialized().encodeJson<FCPollResponse>(
      this as FCPollResponse,
    );
  }

  Map<String, dynamic> toMap() {
    return FCPollResponseMapper.ensureInitialized().encodeMap<FCPollResponse>(
      this as FCPollResponse,
    );
  }

  FCPollResponseCopyWith<FCPollResponse, FCPollResponse, FCPollResponse>
  get copyWith => _FCPollResponseCopyWithImpl<FCPollResponse, FCPollResponse>(
    this as FCPollResponse,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return FCPollResponseMapper.ensureInitialized().stringifyValue(
      this as FCPollResponse,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCPollResponseMapper.ensureInitialized().equalsValue(
      this as FCPollResponse,
      other,
    );
  }

  @override
  int get hashCode {
    return FCPollResponseMapper.ensureInitialized().hashValue(
      this as FCPollResponse,
    );
  }
}

extension FCPollResponseValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCPollResponse, $Out> {
  FCPollResponseCopyWith<$R, FCPollResponse, $Out> get $asFCPollResponse =>
      $base.as((v, t, t2) => _FCPollResponseCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCPollResponseCopyWith<$R, $In extends FCPollResponse, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? id, String? text, int? voteCount, bool? viewerVotedFor});
  FCPollResponseCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCPollResponseCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCPollResponse, $Out>
    implements FCPollResponseCopyWith<$R, FCPollResponse, $Out> {
  _FCPollResponseCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCPollResponse> $mapper =
      FCPollResponseMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? text,
    Object? voteCount = $none,
    bool? viewerVotedFor,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (text != null) #text: text,
      if (voteCount != $none) #voteCount: voteCount,
      if (viewerVotedFor != null) #viewerVotedFor: viewerVotedFor,
    }),
  );
  @override
  FCPollResponse $make(CopyWithData data) => FCPollResponse(
    id: data.get(#id, or: $value.id),
    text: data.get(#text, or: $value.text),
    voteCount: data.get(#voteCount, or: $value.voteCount),
    viewerVotedFor: data.get(#viewerVotedFor, or: $value.viewerVotedFor),
  );

  @override
  FCPollResponseCopyWith<$R2, FCPollResponse, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCPollResponseCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCPollMapper extends ClassMapperBase<FCPoll> {
  FCPollMapper._();

  static FCPollMapper? _instance;
  static FCPollMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCPollMapper._());
      FCPollResponseMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCPoll';

  static String _$pollId(FCPoll v) => v.pollId;
  static const Field<FCPoll, String> _f$pollId = Field('pollId', _$pollId);
  static String _$topicId(FCPoll v) => v.topicId;
  static const Field<FCPoll, String> _f$topicId = Field('topicId', _$topicId);
  static String _$question(FCPoll v) => v.question;
  static const Field<FCPoll, String> _f$question = Field(
    'question',
    _$question,
  );
  static List<FCPollResponse> _$responses(FCPoll v) => v.responses;
  static const Field<FCPoll, List<FCPollResponse>> _f$responses = Field(
    'responses',
    _$responses,
    opt: true,
    def: const [],
  );
  static int? _$voterCount(FCPoll v) => v.voterCount;
  static const Field<FCPoll, int> _f$voterCount = Field(
    'voterCount',
    _$voterCount,
    opt: true,
  );
  static int _$maxVotes(FCPoll v) => v.maxVotes;
  static const Field<FCPoll, int> _f$maxVotes = Field(
    'maxVotes',
    _$maxVotes,
    opt: true,
    def: 1,
  );
  static bool _$changeVote(FCPoll v) => v.changeVote;
  static const Field<FCPoll, bool> _f$changeVote = Field(
    'changeVote',
    _$changeVote,
    opt: true,
    def: false,
  );
  static bool _$publicVotes(FCPoll v) => v.publicVotes;
  static const Field<FCPoll, bool> _f$publicVotes = Field(
    'publicVotes',
    _$publicVotes,
    opt: true,
    def: false,
  );
  static bool _$viewResultsUnvoted(FCPoll v) => v.viewResultsUnvoted;
  static const Field<FCPoll, bool> _f$viewResultsUnvoted = Field(
    'viewResultsUnvoted',
    _$viewResultsUnvoted,
    opt: true,
    def: false,
  );
  static int _$closeDate(FCPoll v) => v.closeDate;
  static const Field<FCPoll, int> _f$closeDate = Field(
    'closeDate',
    _$closeDate,
    opt: true,
    def: 0,
  );
  static bool _$isClosed(FCPoll v) => v.isClosed;
  static const Field<FCPoll, bool> _f$isClosed = Field(
    'isClosed',
    _$isClosed,
    opt: true,
    def: false,
  );
  static bool _$canVote(FCPoll v) => v.canVote;
  static const Field<FCPoll, bool> _f$canVote = Field(
    'canVote',
    _$canVote,
    opt: true,
    def: false,
  );
  static bool _$hasVoted(FCPoll v) => v.hasVoted;
  static const Field<FCPoll, bool> _f$hasVoted = Field(
    'hasVoted',
    _$hasVoted,
    opt: true,
    def: false,
  );
  static bool _$canViewResults(FCPoll v) => v.canViewResults;
  static const Field<FCPoll, bool> _f$canViewResults = Field(
    'canViewResults',
    _$canViewResults,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<FCPoll> fields = const {
    #pollId: _f$pollId,
    #topicId: _f$topicId,
    #question: _f$question,
    #responses: _f$responses,
    #voterCount: _f$voterCount,
    #maxVotes: _f$maxVotes,
    #changeVote: _f$changeVote,
    #publicVotes: _f$publicVotes,
    #viewResultsUnvoted: _f$viewResultsUnvoted,
    #closeDate: _f$closeDate,
    #isClosed: _f$isClosed,
    #canVote: _f$canVote,
    #hasVoted: _f$hasVoted,
    #canViewResults: _f$canViewResults,
  };

  static FCPoll _instantiate(DecodingData data) {
    return FCPoll(
      pollId: data.dec(_f$pollId),
      topicId: data.dec(_f$topicId),
      question: data.dec(_f$question),
      responses: data.dec(_f$responses),
      voterCount: data.dec(_f$voterCount),
      maxVotes: data.dec(_f$maxVotes),
      changeVote: data.dec(_f$changeVote),
      publicVotes: data.dec(_f$publicVotes),
      viewResultsUnvoted: data.dec(_f$viewResultsUnvoted),
      closeDate: data.dec(_f$closeDate),
      isClosed: data.dec(_f$isClosed),
      canVote: data.dec(_f$canVote),
      hasVoted: data.dec(_f$hasVoted),
      canViewResults: data.dec(_f$canViewResults),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCPoll fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCPoll>(map);
  }

  static FCPoll fromJson(String json) {
    return ensureInitialized().decodeJson<FCPoll>(json);
  }
}

mixin FCPollMappable {
  String toJson() {
    return FCPollMapper.ensureInitialized().encodeJson<FCPoll>(this as FCPoll);
  }

  Map<String, dynamic> toMap() {
    return FCPollMapper.ensureInitialized().encodeMap<FCPoll>(this as FCPoll);
  }

  FCPollCopyWith<FCPoll, FCPoll, FCPoll> get copyWith =>
      _FCPollCopyWithImpl<FCPoll, FCPoll>(this as FCPoll, $identity, $identity);
  @override
  String toString() {
    return FCPollMapper.ensureInitialized().stringifyValue(this as FCPoll);
  }

  @override
  bool operator ==(Object other) {
    return FCPollMapper.ensureInitialized().equalsValue(this as FCPoll, other);
  }

  @override
  int get hashCode {
    return FCPollMapper.ensureInitialized().hashValue(this as FCPoll);
  }
}

extension FCPollValueCopy<$R, $Out> on ObjectCopyWith<$R, FCPoll, $Out> {
  FCPollCopyWith<$R, FCPoll, $Out> get $asFCPoll =>
      $base.as((v, t, t2) => _FCPollCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCPollCopyWith<$R, $In extends FCPoll, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    FCPollResponse,
    FCPollResponseCopyWith<$R, FCPollResponse, FCPollResponse>
  >
  get responses;
  $R call({
    String? pollId,
    String? topicId,
    String? question,
    List<FCPollResponse>? responses,
    int? voterCount,
    int? maxVotes,
    bool? changeVote,
    bool? publicVotes,
    bool? viewResultsUnvoted,
    int? closeDate,
    bool? isClosed,
    bool? canVote,
    bool? hasVoted,
    bool? canViewResults,
  });
  FCPollCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FCPollCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, FCPoll, $Out>
    implements FCPollCopyWith<$R, FCPoll, $Out> {
  _FCPollCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCPoll> $mapper = FCPollMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    FCPollResponse,
    FCPollResponseCopyWith<$R, FCPollResponse, FCPollResponse>
  >
  get responses => ListCopyWith(
    $value.responses,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(responses: v),
  );
  @override
  $R call({
    String? pollId,
    String? topicId,
    String? question,
    List<FCPollResponse>? responses,
    Object? voterCount = $none,
    int? maxVotes,
    bool? changeVote,
    bool? publicVotes,
    bool? viewResultsUnvoted,
    int? closeDate,
    bool? isClosed,
    bool? canVote,
    bool? hasVoted,
    bool? canViewResults,
  }) => $apply(
    FieldCopyWithData({
      if (pollId != null) #pollId: pollId,
      if (topicId != null) #topicId: topicId,
      if (question != null) #question: question,
      if (responses != null) #responses: responses,
      if (voterCount != $none) #voterCount: voterCount,
      if (maxVotes != null) #maxVotes: maxVotes,
      if (changeVote != null) #changeVote: changeVote,
      if (publicVotes != null) #publicVotes: publicVotes,
      if (viewResultsUnvoted != null) #viewResultsUnvoted: viewResultsUnvoted,
      if (closeDate != null) #closeDate: closeDate,
      if (isClosed != null) #isClosed: isClosed,
      if (canVote != null) #canVote: canVote,
      if (hasVoted != null) #hasVoted: hasVoted,
      if (canViewResults != null) #canViewResults: canViewResults,
    }),
  );
  @override
  FCPoll $make(CopyWithData data) => FCPoll(
    pollId: data.get(#pollId, or: $value.pollId),
    topicId: data.get(#topicId, or: $value.topicId),
    question: data.get(#question, or: $value.question),
    responses: data.get(#responses, or: $value.responses),
    voterCount: data.get(#voterCount, or: $value.voterCount),
    maxVotes: data.get(#maxVotes, or: $value.maxVotes),
    changeVote: data.get(#changeVote, or: $value.changeVote),
    publicVotes: data.get(#publicVotes, or: $value.publicVotes),
    viewResultsUnvoted: data.get(
      #viewResultsUnvoted,
      or: $value.viewResultsUnvoted,
    ),
    closeDate: data.get(#closeDate, or: $value.closeDate),
    isClosed: data.get(#isClosed, or: $value.isClosed),
    canVote: data.get(#canVote, or: $value.canVote),
    hasVoted: data.get(#hasVoted, or: $value.hasVoted),
    canViewResults: data.get(#canViewResults, or: $value.canViewResults),
  );

  @override
  FCPollCopyWith<$R2, FCPoll, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCPollCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

