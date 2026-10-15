import 'package:flutter_test/flutter_test.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';
import 'package:xenforo_core/xenforo_core.dart';

/// Offline tests for how reaction data from `forumcopilot.php` is read. The
/// proxies are fed canned responses instead of calling a forum.

const _newForum = 'https://new.example.com/forumcopilot.php';
const _oldForum = 'https://old.example.com/forumcopilot.php';

SiteContext _siteContext(String pluginUrl) {
  final baseUrl = pluginUrl.replaceFirst('/forumcopilot.php', '');
  return SiteContext(
    siteType: 'xenforo',
    site: Site(
      id: null,
      name: 'Test',
      url: baseUrl,
      description: '',
      endpoint: 'forumcopilot.php',
      baseUrl: baseUrl,
      logoUrl: null,
      backgroundUrl: null,
      siteType: 'xenforo',
    ),
  );
}

/// Returns [response] (or throws [error]) for every plugin call.
class _CannedConfigProxy extends XenForoConfigProxy {
  _CannedConfigProxy(String pluginUrl, {this.response, this.error})
      : super(_siteContext(pluginUrl));

  final Map<String, dynamic>? response;
  final Object? error;

  @override
  Future<Map<String, dynamic>> callPluginApi(
      String method, Map<String, dynamic> params) async {
    if (error != null) throw error!;
    return Map<String, dynamic>.from(response!);
  }
}

class _CannedConversationProxy extends XenForoPrivateConversationProxy {
  _CannedConversationProxy(this.response) : super(_siteContext(_newForum));

  final Map<String, dynamic> response;

  @override
  Future<Map<String, dynamic>> callPluginApi(
      String method, Map<String, dynamic> params) async {
    return response;
  }
}

Map<String, dynamic> _config({List<Map<String, dynamic>>? reactions}) => {
      'result': true,
      'version': 'fc_1.8.10',
      'systemVersion': '2.3.7',
      if (reactions != null) 'availableReactions': reactions,
    };

final _sixReactions = [
  for (final (id, title, emoji) in [
    (1, 'Like', '👍'),
    (2, 'Love', '❤️'),
    (3, 'Haha', '😄'),
    (4, 'Wow', '😮'),
    (5, 'Sad', '😢'),
    (6, 'Angry', '😠'),
  ])
    {
      'id': id,
      'title': title,
      'emoji': emoji,
      'imageUrl': '',
      'displayOrder': id * 100,
    },
];

void main() {
  group('getConfig and the reaction registry', () {
    final registry = ReactionRegistry.instance;
    setUp(registry.clear);

    test('a 1.3.x forum opened after a 1.8.x forum gets no reaction set',
        () async {
      await _CannedConfigProxy(_newForum,
              response: _config(reactions: _sixReactions))
          .getConfig(_newForum, forceRefresh: true);
      expect(registry.reactions, hasLength(6));

      // Add-on 1.3.x: getConfig has no availableReactions.
      await _CannedConfigProxy(_oldForum, response: _config())
          .getConfig(_oldForum, forceRefresh: true);
      expect(registry.isAvailable, isFalse,
          reason: 'the 1.8.x forum\'s reactions must not carry over');
    });

    test('a failed getConfig for another forum clears the set', () async {
      await _CannedConfigProxy(_newForum,
              response: _config(reactions: _sixReactions))
          .getConfig(_newForum, forceRefresh: true);

      await _CannedConfigProxy(_oldForum, error: Exception('offline'))
          .getConfig(_oldForum, forceRefresh: true);
      expect(registry.isAvailable, isFalse);
    });

    test('a failed refresh of the same forum keeps its set', () async {
      await _CannedConfigProxy(_newForum,
              response: _config(reactions: _sixReactions))
          .getConfig(_newForum, forceRefresh: true);

      await _CannedConfigProxy(_newForum, error: Exception('offline'))
          .getConfig(_newForum, forceRefresh: true);
      expect(registry.reactions, hasLength(6));
    });
  });

  group('getConversation likesInfo', () {
    test('keeps each reaction\'s type', () async {
      final proxy = _CannedConversationProxy({
        'result': true,
        'convId': '7',
        'subject': 'Hello',
        'participants': [],
        'messages': [
          {
            'id': 42,
            'authorId': 2,
            'authorName': 'Alice',
            'messageContent': 'Hi',
            'timestamp': 1760000000,
            'canLike': true,
            'isLiked': true,
            'likeCount': 2,
            'likesInfo': [
              {
                'userId': '3',
                'username': 'WilliamThompson971',
                'avatarUrl': 'https://new.example.com/a.png',
                'timestamp': 1760000000000,
                'reactionId': 4,
                'reactionName': 'Wow',
                'reactionEmoji': '😮',
                'reactionIconUrl': null,
              },
              {
                // A custom image reaction, with string-typed numbers.
                'userId': '5',
                'username': 'Bob',
                'avatarUrl': '',
                'timestamp': '1760000001000',
                'reactionId': '9',
                'reactionName': 'Mind Blown',
                'reactionEmoji': '',
                'reactionIconUrl': 'https://new.example.com/mind_blown.png',
              },
            ],
          },
        ],
      });

      final result = await proxy.getConversationAsync('7', 0, 19, false);

      expect(result.messages, hasLength(1));
      final likes = result.messages.single.likesInfo;
      expect(likes, hasLength(2));

      final wow = likes[0];
      expect(wow.username, 'WilliamThompson971');
      expect(wow.reactionId, 4);
      expect(wow.reactionName, 'Wow');
      expect(wow.reactionEmoji, '😮');
      expect(wow.reactionIconUrl, isNull);
      expect(wow.timestamp,
          DateTime.fromMillisecondsSinceEpoch(1760000000000));

      final custom = likes[1];
      expect(custom.reactionId, 9);
      expect(custom.reactionName, 'Mind Blown');
      expect(custom.reactionEmoji, isNull);
      expect(custom.reactionIconUrl, 'https://new.example.com/mind_blown.png');
      expect(custom.timestamp,
          DateTime.fromMillisecondsSinceEpoch(1760000001000));
    });

    test('an entry without reaction fields (single Like) still parses',
        () async {
      final proxy = _CannedConversationProxy({
        'result': true,
        'convId': '7',
        'messages': [
          {
            'id': 43,
            'authorId': 2,
            'authorName': 'Alice',
            'messageContent': 'Hi',
            'timestamp': 1760000000,
            'likeCount': 1,
            'likesInfo': [
              {
                'userId': '3',
                'username': 'Carol',
                'avatarUrl': '',
                'timestamp': 1760000000000,
              },
            ],
          },
        ],
      });

      final result = await proxy.getConversationAsync('7', 0, 19, false);
      final like = result.messages.single.likesInfo.single;
      expect(like.username, 'Carol');
      expect(like.reactionId, isNull);
      expect(like.reactionName, isNull);
    });
  });
}
