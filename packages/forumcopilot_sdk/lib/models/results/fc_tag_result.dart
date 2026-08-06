import 'package:dart_mappable/dart_mappable.dart';
import 'package:forumcopilot_sdk/models/entities/fc_tag.dart';
import 'package:forumcopilot_sdk/models/results/fc_base_result.dart';

part 'fc_tag_result.mapper.dart';

/// Result of fetching all visible tags (Discourse: `GET /tags.json`).
@MappableClass()
class FCTagListResult extends FCBaseResult with FCTagListResultMappable {
  int total;
  List<FCTag> items;

  FCTagListResult({
    required bool result,
    String? resultText,
    required this.total,
    required this.items,
  }) : super(result: result, resultText: resultText);
}

/// Result of autocomplete tag-name search (Discourse:
/// `GET /tags/filter/search.json?q=&limit=`). Returns only tag
/// names (strings) — the composer doesn't need counts/descriptions
/// for suggestions.
@MappableClass()
class FCTagSearchResult extends FCBaseResult with FCTagSearchResultMappable {
  List<String> names;

  FCTagSearchResult({
    required bool result,
    String? resultText,
    required this.names,
  }) : super(result: result, resultText: resultText);
}
