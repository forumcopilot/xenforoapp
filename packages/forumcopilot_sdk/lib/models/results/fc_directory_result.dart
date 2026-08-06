import 'package:dart_mappable/dart_mappable.dart';
import 'package:forumcopilot_sdk/models/entities/fc_badge.dart';
import 'package:forumcopilot_sdk/models/entities/fc_directory_item.dart';
import 'package:forumcopilot_sdk/models/results/fc_base_result.dart';

part 'fc_directory_result.mapper.dart';

/// Paginated list of directory entries (Discourse:
/// `GET /directory_items.json`).
@MappableClass()
class FCDirectoryItemResult extends FCBaseResult
    with FCDirectoryItemResultMappable {
  int total;
  List<FCDirectoryItem> items;

  FCDirectoryItemResult({
    required bool result,
    String? resultText,
    required this.total,
    required this.items,
  }) : super(result: result, resultText: resultText);
}

/// Badge catalog or per-user badge list (Discourse:
/// `GET /badges.json` / `GET /user-badges/{username}.json`).
@MappableClass()
class FCBadgeResult extends FCBaseResult with FCBadgeResultMappable {
  List<FCBadge> badges;

  FCBadgeResult({
    required bool result,
    String? resultText,
    this.badges = const [],
  }) : super(result: result, resultText: resultText);
}
