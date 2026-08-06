import 'package:dart_mappable/dart_mappable.dart';
import 'package:forumcopilot_sdk/models/entities/fc_draft.dart';
import 'package:forumcopilot_sdk/models/results/fc_base_result.dart';

part 'fc_draft_result.mapper.dart';

/// Result of saving a server-side draft (Discourse: `POST /drafts.json`).
/// [sequence] is the updated optimistic-concurrency token the server
/// returned, when available — pass it back on the next save.
@MappableClass()
class FCSaveDraftResult extends FCBaseResult with FCSaveDraftResultMappable {
  int? sequence;

  FCSaveDraftResult({
    required bool result,
    String? resultText,
    this.sequence,
  }) : super(result: result, resultText: resultText);
}

/// Result of loading a single draft by key (Discourse:
/// `GET /drafts/{key}.json`). [draft] is null when no draft exists.
@MappableClass()
class FCLoadDraftResult extends FCBaseResult with FCLoadDraftResultMappable {
  FCDraft? draft;

  FCLoadDraftResult({
    required bool result,
    String? resultText,
    this.draft,
  }) : super(result: result, resultText: resultText);
}

/// Result of deleting a draft (Discourse:
/// `DELETE /drafts/{key}.json?sequence=N`).
@MappableClass()
class FCDeleteDraftResult extends FCBaseResult
    with FCDeleteDraftResultMappable {
  FCDeleteDraftResult({
    required bool result,
    String? resultText,
  }) : super(result: result, resultText: resultText);
}

/// Result of listing the current user's drafts (Discourse:
/// `GET /drafts.json`).
@MappableClass()
class FCDraftListResult extends FCBaseResult with FCDraftListResultMappable {
  int total;
  List<FCDraft> items;

  FCDraftListResult({
    required bool result,
    String? resultText,
    required this.total,
    required this.items,
  }) : super(result: result, resultText: resultText);
}
