/// Structured search filters for the SDK (Discourse: maps directly to
/// `/search.json?q=` operator DSL).
///
/// Phase 5.42 — promoted out of `discourse_core` (was
/// `DiscourseSearchFilters`) so the search-filters concept is
/// expressed directly on the SDK surface. Tokens stay Discourse-shaped
/// because Discourse is the only backend in v1; XF-shaped mappings can
/// be added later without breaking the UI's filter widgets.
///
/// All fields are optional and combine with `AND`. Empty/null fields
/// are dropped. The serialized fragment goes after the user's plain
/// keywords.
class FCSearchFilters {
  final Set<FCSearchStatus> status;
  final Set<FCSearchPersonal> personal;

  /// Restrict to a topic's first post (the original).
  final bool firstPostsOnly;

  /// Restrict to title matches.
  final bool titleOnly;

  /// Tag filter. Implementations may accept multiple values.
  final List<String> tags;

  /// Restrict to a category. Pass the slug or numeric id depending on
  /// the backend; Discourse accepts both.
  final String? categorySlug;

  /// `@username` author filter.
  final String? username;

  final int? minPosts;
  final int? maxPosts;

  /// Inclusive day-boundary date filters (Discourse uses the user's
  /// local timezone by convention).
  final DateTime? after;
  final DateTime? before;

  /// Sort order. Null preserves relevance/default.
  final FCSearchSort? sort;

  const FCSearchFilters({
    this.status = const {},
    this.personal = const {},
    this.firstPostsOnly = false,
    this.titleOnly = false,
    this.tags = const [],
    this.categorySlug,
    this.username,
    this.minPosts,
    this.maxPosts,
    this.after,
    this.before,
    this.sort,
  });

  bool get isEmpty =>
      status.isEmpty &&
      personal.isEmpty &&
      !firstPostsOnly &&
      !titleOnly &&
      tags.isEmpty &&
      (categorySlug?.isEmpty ?? true) &&
      (username?.isEmpty ?? true) &&
      minPosts == null &&
      maxPosts == null &&
      after == null &&
      before == null &&
      sort == null;

  /// Serialize to the backend's search-DSL fragment that comes after
  /// the user's free-text keywords. Returns an empty string when
  /// [isEmpty]. Discourse's tokens are emitted; non-Discourse
  /// implementations can ignore the output and consume the typed
  /// fields directly.
  String toQueryFragment() {
    final parts = <String>[];
    for (final s in status) {
      parts.add('status:${s.token}');
    }
    for (final p in personal) {
      parts.add('in:${p.token}');
    }
    if (firstPostsOnly) parts.add('in:first');
    if (titleOnly) parts.add('in:title');
    for (final tag in tags) {
      final t = tag.trim();
      if (t.isNotEmpty) parts.add('tag:$t');
    }
    if (categorySlug != null && categorySlug!.isNotEmpty) {
      parts.add('category:${categorySlug!.trim()}');
    }
    if (username != null && username!.isNotEmpty) {
      parts.add('@${username!.trim()}');
    }
    if (minPosts != null) parts.add('min_posts:${minPosts!}');
    if (maxPosts != null) parts.add('max_posts:${maxPosts!}');
    if (after != null) parts.add('after:${_isoDate(after!)}');
    if (before != null) parts.add('before:${_isoDate(before!)}');
    if (sort != null) parts.add('order:${sort!.token}');
    return parts.join(' ');
  }

  String _isoDate(DateTime d) {
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    return '$y-$m-$dd';
  }

  FCSearchFilters copyWith({
    Set<FCSearchStatus>? status,
    Set<FCSearchPersonal>? personal,
    bool? firstPostsOnly,
    bool? titleOnly,
    List<String>? tags,
    String? categorySlug,
    String? username,
    int? minPosts,
    int? maxPosts,
    DateTime? after,
    DateTime? before,
    FCSearchSort? sort,
    bool clearSort = false,
  }) {
    return FCSearchFilters(
      status: status ?? this.status,
      personal: personal ?? this.personal,
      firstPostsOnly: firstPostsOnly ?? this.firstPostsOnly,
      titleOnly: titleOnly ?? this.titleOnly,
      tags: tags ?? this.tags,
      categorySlug: categorySlug ?? this.categorySlug,
      username: username ?? this.username,
      minPosts: minPosts ?? this.minPosts,
      maxPosts: maxPosts ?? this.maxPosts,
      after: after ?? this.after,
      before: before ?? this.before,
      sort: clearSort ? null : (sort ?? this.sort),
    );
  }
}

/// Topic status operators. Discourse's `discourse-solved` plugin
/// contributes `solved`/`unsolved`; on stock Discourse those degrade
/// gracefully (return zero results).
enum FCSearchStatus {
  open('open', 'Open'),
  closed('closed', 'Closed'),
  archived('archived', 'Archived'),
  noReplies('noreplies', 'No replies'),
  publicOnly('public', 'Public only'),
  solved('solved', 'Solved'),
  unsolved('unsolved', 'Unsolved');

  final String token;
  final String label;
  const FCSearchStatus(this.token, this.label);
}

/// `in:` operators that scope to the current user's relationship with
/// a topic — bookmarks, likes, watching, etc.
enum FCSearchPersonal {
  bookmarks('bookmarks', 'My bookmarks'),
  liked('liked', 'I liked'),
  posted('posted', 'I posted in'),
  watching('watching', 'Watching'),
  tracking('tracking', 'Tracking'),
  seen('seen', 'Seen'),
  unseen('unseen', 'Unseen');

  final String token;
  final String label;
  const FCSearchPersonal(this.token, this.label);
}

/// Sort order for search results.
enum FCSearchSort {
  latest('latest', 'Latest post'),
  likes('likes', 'Most likes'),
  views('views', 'Most views'),
  latestTopic('latest_topic', 'Latest topic');

  final String token;
  final String label;
  const FCSearchSort(this.token, this.label);
}
