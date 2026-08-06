// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fc_post_vote.dart';

class FCPostVoteMapper extends ClassMapperBase<FCPostVote> {
  FCPostVoteMapper._();

  static FCPostVoteMapper? _instance;
  static FCPostVoteMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCPostVoteMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FCPostVote';

  static int _$voteCount(FCPostVote v) => v.voteCount;
  static const Field<FCPostVote, int> _f$voteCount = Field(
    'voteCount',
    _$voteCount,
    opt: true,
    def: 0,
  );
  static bool _$hasVotes(FCPostVote v) => v.hasVotes;
  static const Field<FCPostVote, bool> _f$hasVotes = Field(
    'hasVotes',
    _$hasVotes,
    opt: true,
    def: false,
  );
  static String? _$viewerDirection(FCPostVote v) => v.viewerDirection;
  static const Field<FCPostVote, String> _f$viewerDirection = Field(
    'viewerDirection',
    _$viewerDirection,
    opt: true,
  );

  @override
  final MappableFields<FCPostVote> fields = const {
    #voteCount: _f$voteCount,
    #hasVotes: _f$hasVotes,
    #viewerDirection: _f$viewerDirection,
  };

  static FCPostVote _instantiate(DecodingData data) {
    return FCPostVote(
      voteCount: data.dec(_f$voteCount),
      hasVotes: data.dec(_f$hasVotes),
      viewerDirection: data.dec(_f$viewerDirection),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCPostVote fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCPostVote>(map);
  }

  static FCPostVote fromJson(String json) {
    return ensureInitialized().decodeJson<FCPostVote>(json);
  }
}

mixin FCPostVoteMappable {
  String toJson() {
    return FCPostVoteMapper.ensureInitialized().encodeJson<FCPostVote>(
      this as FCPostVote,
    );
  }

  Map<String, dynamic> toMap() {
    return FCPostVoteMapper.ensureInitialized().encodeMap<FCPostVote>(
      this as FCPostVote,
    );
  }

  FCPostVoteCopyWith<FCPostVote, FCPostVote, FCPostVote> get copyWith =>
      _FCPostVoteCopyWithImpl<FCPostVote, FCPostVote>(
        this as FCPostVote,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCPostVoteMapper.ensureInitialized().stringifyValue(
      this as FCPostVote,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCPostVoteMapper.ensureInitialized().equalsValue(
      this as FCPostVote,
      other,
    );
  }

  @override
  int get hashCode {
    return FCPostVoteMapper.ensureInitialized().hashValue(this as FCPostVote);
  }
}

extension FCPostVoteValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCPostVote, $Out> {
  FCPostVoteCopyWith<$R, FCPostVote, $Out> get $asFCPostVote =>
      $base.as((v, t, t2) => _FCPostVoteCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCPostVoteCopyWith<$R, $In extends FCPostVote, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({int? voteCount, bool? hasVotes, String? viewerDirection});
  FCPostVoteCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FCPostVoteCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCPostVote, $Out>
    implements FCPostVoteCopyWith<$R, FCPostVote, $Out> {
  _FCPostVoteCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCPostVote> $mapper =
      FCPostVoteMapper.ensureInitialized();
  @override
  $R call({int? voteCount, bool? hasVotes, Object? viewerDirection = $none}) =>
      $apply(
        FieldCopyWithData({
          if (voteCount != null) #voteCount: voteCount,
          if (hasVotes != null) #hasVotes: hasVotes,
          if (viewerDirection != $none) #viewerDirection: viewerDirection,
        }),
      );
  @override
  FCPostVote $make(CopyWithData data) => FCPostVote(
    voteCount: data.get(#voteCount, or: $value.voteCount),
    hasVotes: data.get(#hasVotes, or: $value.hasVotes),
    viewerDirection: data.get(#viewerDirection, or: $value.viewerDirection),
  );

  @override
  FCPostVoteCopyWith<$R2, FCPostVote, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCPostVoteCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

