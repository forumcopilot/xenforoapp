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
/// getConfig by the config proxy each time a forum is opened. Read by the
/// reaction picker.
///
/// The registry holds one forum's set at a time and remembers which forum
/// ([siteKey]) it belongs to. A getConfig without `availableReactions` (add-on
/// before 1.8.0) clears it, so a forum opened after a newer one does not
/// inherit that forum's reactions and falls back to the single Like.
class ReactionRegistry {
  ReactionRegistry._();
  static final ReactionRegistry instance = ReactionRegistry._();

  List<FCReaction> _reactions = const [];
  String? _siteKey;

  /// All active reactions, in the forum's configured display order.
  List<FCReaction> get reactions => _reactions;

  /// True when the server sent a reaction set (i.e. the newer plugin is live).
  bool get isAvailable => _reactions.isNotEmpty;

  /// The forum the current set was loaded for (its plugin URL), or null when
  /// the registry is empty or was filled without one.
  String? get siteKey => _siteKey;

  /// Replace the set from a parsed getConfig payload.
  void setReactions(List<FCReaction> reactions, {String? siteKey}) {
    final sorted = [...reactions]
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
    _reactions = List.unmodifiable(sorted);
    _siteKey = siteKey;
  }

  /// Populate from the raw `availableReactions` value in a getConfig response.
  /// Anything but a list (the field is missing on add-on 1.3.x) clears the
  /// set: keeping it would show the previously opened forum's reactions.
  void setFromJsonList(dynamic rawList, {String? siteKey}) {
    if (rawList is! List) {
      clear();
      _siteKey = siteKey;
      return;
    }
    setReactions(
      rawList
          .whereType<Map>()
          .map((m) => FCReaction.fromJson(Map<String, dynamic>.from(m)))
          .toList(),
      siteKey: siteKey,
    );
  }

  /// Drop the set, e.g. when getConfig failed for a forum other than the one
  /// it was loaded for (see [clearUnlessFor]).
  void clear() {
    _reactions = const [];
    _siteKey = null;
  }

  /// Clear unless the set belongs to [siteKey]. Used when getConfig fails: a
  /// failed refresh of the same forum keeps its set, but another forum's set
  /// must not carry over to the one being opened.
  void clearUnlessFor(String siteKey) {
    if (_siteKey != siteKey) clear();
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
