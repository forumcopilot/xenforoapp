import 'package:dart_mappable/dart_mappable.dart';

part 'fc_thread_posting.mapper.dart';

/// What starting a thread in a forum takes, as the website's "Post thread"
/// form has it (XenForo add-on 1.11.0+, on getForum rows): tags, custom
/// thread fields, thread types, polls.
@MappableClass()
class FCThreadPostingOptions with FCThreadPostingOptionsMappable {
  const FCThreadPostingOptions({
    this.forumType = 'discussion',
    this.canTag = false,
    this.minTags = 0,
    this.threadFields = const [],
    this.threadTypes = const [],
    this.defaultThreadType = 'discussion',
    this.canCreatePoll = false,
  });

  /// XenForo's forum type: `discussion`, `question`, `suggestion`, `article`.
  final String forumType;

  /// Whether the member may tag the thread, and how many tags it needs.
  final bool canTag;
  final int minTags;

  /// The custom thread fields the member fills in.
  final List<FCThreadField> threadFields;

  /// The thread types the member may start, and the forum's default.
  final List<FCThreadTypeOption> threadTypes;
  final String defaultThreadType;

  /// Whether the member may start a poll.
  final bool canCreatePoll;

  /// From a getForum row; null from older add-ons, which send none of it.
  static FCThreadPostingOptions? fromJson(Map<String, dynamic> row) {
    if (!row.containsKey('threadTypes') && !row.containsKey('threadFields')) return null;
    return FCThreadPostingOptions(
      forumType: '${row['forumType'] ?? 'discussion'}',
      canTag: row['canTag'] == true,
      minTags: int.tryParse('${row['minTags'] ?? 0}') ?? 0,
      threadFields: [
        for (final f in (row['threadFields'] as List?) ?? const [])
          if (f is Map && f['id'] != null) FCThreadField.fromJson(f.cast<String, dynamic>()),
      ],
      threadTypes: [
        for (final t in (row['threadTypes'] as List?) ?? const [])
          if (t is Map && t['type'] != null) FCThreadTypeOption(type: '${t['type']}', title: '${t['title'] ?? t['type']}'),
      ],
      defaultThreadType: '${row['defaultThreadType'] ?? 'discussion'}',
      canCreatePoll: row['canCreatePoll'] == true,
    );
  }
}

/// A custom thread field, as XenForo defines it.
@MappableClass()
class FCThreadField with FCThreadFieldMappable {
  const FCThreadField({
    required this.id,
    required this.title,
    this.description = '',
    this.type = 'textbox',
    this.required = false,
    this.choices = const [],
    this.group = '',
    this.maxLength = 0,
  });

  final String id;
  final String title;
  final String description;

  /// XenForo's field type: `textbox`, `textarea`, `bbcode`, `select`,
  /// `radio`, `checkbox`, `multiselect`, `stars`, `date`, `color`.
  final String type;
  final bool required;
  final List<FCFieldChoice> choices;

  /// Where the website shows it: `before` or `after` the message, or
  /// `thread_status`.
  final String group;

  /// 0: no limit.
  final int maxLength;

  /// Whether the member picks several values (sent as a list).
  bool get isMultiple => type == 'checkbox' || type == 'multiselect';

  factory FCThreadField.fromJson(Map<String, dynamic> json) => FCThreadField(
        id: '${json['id']}',
        title: '${json['title'] ?? json['id']}',
        description: '${json['description'] ?? ''}',
        type: '${json['type'] ?? 'textbox'}',
        required: json['required'] == true,
        choices: [
          for (final c in (json['choices'] as List?) ?? const [])
            if (c is Map) FCFieldChoice(value: '${c['value']}', title: '${c['title'] ?? c['value']}'),
        ],
        group: '${json['group'] ?? ''}',
        maxLength: int.tryParse('${json['maxLength'] ?? 0}') ?? 0,
      );
}

/// One choice of a select, radio, checkbox or multiselect field.
@MappableClass()
class FCFieldChoice with FCFieldChoiceMappable {
  const FCFieldChoice({required this.value, required this.title});

  final String value;
  final String title;
}

/// A thread type the member may start, titled by the forum.
@MappableClass()
class FCThreadTypeOption with FCThreadTypeOptionMappable {
  const FCThreadTypeOption({required this.type, required this.title});

  /// `discussion`, `poll`, `question`, `article`, `suggestion`...
  final String type;
  final String title;
}

/// A poll for a new thread, as the website's poll form takes it.
class FCNewPoll {
  const FCNewPoll({
    required this.question,
    required this.responses,
    this.maxVotes = 1,
    this.changeVote = false,
    this.publicVotes = false,
    this.viewResultsUnvoted = true,
    this.closeDays = 0,
  });

  final String question;
  final List<String> responses;

  /// How many responses a voter may pick; 0: unlimited.
  final int maxVotes;
  final bool changeVote;
  final bool publicVotes;
  final bool viewResultsUnvoted;

  /// Close the poll after this many days; 0: never.
  final int closeDays;

  /// The newTopic params.
  Map<String, dynamic> toParams() => {
        'isPoll': true,
        'pollQuestion': question,
        'pollOptions': responses,
        'pollMaxVotes': maxVotes,
        'pollChangeVote': changeVote,
        'pollPublicVotes': publicVotes,
        'pollViewResultsUnvoted': viewResultsUnvoted,
        'pollCloseDays': closeDays,
      };
}
