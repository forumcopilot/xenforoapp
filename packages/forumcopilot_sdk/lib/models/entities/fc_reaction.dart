/// A single reaction the forum has configured (e.g. Like, Love, Haha).
///
/// Plain value class — intentionally NOT dart_mappable. The reaction set is
/// re-fetched from getConfig on every launch and held in [ReactionRegistry],
/// so it doesn't need to be part of the persisted, code-generated config model.
class FCReaction {
  /// XenForo reaction_id — this is what gets sent back when reacting.
  final int id;

  /// Human title, e.g. "Like", "Love".
  final String title;

  /// Native Unicode emoji when the server could map this reaction to one
  /// (the standard set), else null — in which case [imageUrl] is used.
  final String? emoji;

  /// Absolute URL to the reaction image (always present); fallback for custom
  /// reactions with no emoji mapping.
  final String imageUrl;

  /// Sort order from the forum config.
  final int displayOrder;

  const FCReaction({
    required this.id,
    required this.title,
    required this.emoji,
    required this.imageUrl,
    required this.displayOrder,
  });

  factory FCReaction.fromJson(Map<String, dynamic> json) {
    return FCReaction(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse('${json['id']}') ?? 0,
      title: (json['title'] ?? '').toString(),
      emoji: (json['emoji'] == null || '${json['emoji']}'.isEmpty)
          ? null
          : json['emoji'].toString(),
      imageUrl: (json['imageUrl'] ?? '').toString(),
      displayOrder: json['displayOrder'] is int
          ? json['displayOrder'] as int
          : int.tryParse('${json['displayOrder']}') ?? 0,
    );
  }

  bool get hasEmoji => emoji != null && emoji!.isNotEmpty;
}

/// Process-wide registry of the forum's available reactions, populated from
/// getConfig by the config proxy on each launch. Read by the reaction picker.
class ReactionRegistry {
  ReactionRegistry._();
  static final ReactionRegistry instance = ReactionRegistry._();

  List<FCReaction> _reactions = const [];

  /// All active reactions, in the forum's configured display order.
  List<FCReaction> get reactions => _reactions;

  /// True when the server sent a reaction set (i.e. the newer plugin is live).
  bool get isAvailable => _reactions.isNotEmpty;

  /// Replace the set from a parsed getConfig payload.
  void setReactions(List<FCReaction> reactions) {
    final sorted = [...reactions]
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
    _reactions = List.unmodifiable(sorted);
  }

  /// Populate from the raw `availableReactions` list in a getConfig response.
  void setFromJsonList(dynamic rawList) {
    if (rawList is List) {
      setReactions(rawList
          .whereType<Map>()
          .map((m) => FCReaction.fromJson(Map<String, dynamic>.from(m)))
          .toList());
    }
  }

  /// Look up a reaction by id (e.g. to render the viewer's current reaction).
  FCReaction? byId(int? id) {
    if (id == null) return null;
    for (final r in _reactions) {
      if (r.id == id) return r;
    }
    return null;
  }

  /// The default "Like" reaction (id 1) if present, else the first configured.
  FCReaction? get defaultReaction {
    if (_reactions.isEmpty) return null;
    return byId(1) ?? _reactions.first;
  }
}
