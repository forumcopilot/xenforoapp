import 'package:forumcopilot_sdk/models/entities/fc_reaction.dart';
import 'package:test/test.dart';

/// The six reactions a stock XenForo 2.x forum sends from add-on 1.8.0 on.
const _sixReactions = [
  {'id': 1, 'title': 'Like', 'emoji': '👍', 'imageUrl': '', 'displayOrder': 100},
  {'id': 2, 'title': 'Love', 'emoji': '❤️', 'imageUrl': '', 'displayOrder': 200},
  {'id': 3, 'title': 'Haha', 'emoji': '😄', 'imageUrl': '', 'displayOrder': 300},
  {'id': 4, 'title': 'Wow', 'emoji': '😮', 'imageUrl': '', 'displayOrder': 400},
  {'id': 5, 'title': 'Sad', 'emoji': '😢', 'imageUrl': '', 'displayOrder': 500},
  {'id': 6, 'title': 'Angry', 'emoji': '😠', 'imageUrl': '', 'displayOrder': 600},
];

const _newForum = 'https://new.example.com/forumcopilot.php';
const _oldForum = 'https://old.example.com/forumcopilot.php';

void main() {
  final registry = ReactionRegistry.instance;

  setUp(registry.clear);

  test('loads a reaction set in display order and remembers its forum', () {
    registry.setFromJsonList(_sixReactions.reversed.toList(), siteKey: _newForum);

    expect(registry.isAvailable, isTrue);
    expect(registry.reactions.map((r) => r.title),
        ['Like', 'Love', 'Haha', 'Wow', 'Sad', 'Angry']);
    expect(registry.siteKey, _newForum);
    expect(registry.byId(4)?.emoji, '😮');
    expect(registry.defaultReaction?.id, 1);
  });

  test('a forum without availableReactions does not inherit the previous set',
      () {
    // Add-on 1.8.x forum first, then an add-on 1.3.x forum in the same
    // session: 1.3.x has no availableReactions in getConfig.
    registry.setFromJsonList(_sixReactions, siteKey: _newForum);
    registry.setFromJsonList(null, siteKey: _oldForum);

    expect(registry.isAvailable, isFalse);
    expect(registry.reactions, isEmpty);
    expect(registry.byId(2), isNull);
    expect(registry.defaultReaction, isNull);
    expect(registry.siteKey, _oldForum);
  });

  test('a non-list availableReactions clears the set too', () {
    registry.setFromJsonList(_sixReactions, siteKey: _newForum);
    registry.setFromJsonList({'unexpected': true}, siteKey: _oldForum);

    expect(registry.isAvailable, isFalse);
  });

  test('an empty list leaves the forum on the single Like', () {
    registry.setFromJsonList(_sixReactions, siteKey: _newForum);
    registry.setFromJsonList(const [], siteKey: _oldForum);

    expect(registry.isAvailable, isFalse);
  });

  test('clearUnlessFor keeps the set for its own forum only', () {
    registry.setFromJsonList(_sixReactions, siteKey: _newForum);

    registry.clearUnlessFor(_newForum);
    expect(registry.reactions, hasLength(6));

    registry.clearUnlessFor(_oldForum);
    expect(registry.isAvailable, isFalse);
    expect(registry.siteKey, isNull);
  });
}
