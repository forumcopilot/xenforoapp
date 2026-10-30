/// Sorting and filters for a forum's thread list, as the website's filter
/// menu has them (XenForo add-on 1.11.0+; older add-ons ignore them). Null
/// fields are left to the forum.
class FCTopicFilters {
  const FCTopicFilters({this.order, this.direction, this.prefixId, this.starterName, this.lastDays});

  /// A sort option's key (FCTopicDataResult.sortOptions), and `asc` or
  /// `desc`.
  final String? order;
  final String? direction;

  /// Only threads with this prefix.
  final int? prefixId;

  /// Only threads this member started.
  final String? starterName;

  /// Only threads with a post in the last N days; -1: any time.
  final int? lastDays;

  /// Whether any filter (not just the order) is set.
  bool get filters => prefixId != null || (starterName?.trim().isNotEmpty ?? false) || lastDays != null;

  bool get isEmpty => order == null && !filters;

  /// The filters a getTopic reply says it applied (`appliedFilters`),
  /// leaving out the forum's own order and date limit, so that a filter the
  /// forum ignored (an unknown member's name, say) isn't shown as set.
  factory FCTopicFilters.fromApplied(
    Map<String, dynamic> applied, {
    String? defaultOrder,
    String? defaultDirection,
    int dateLimitDays = 0,
  }) {
    final order = applied['order']?.toString();
    final direction = applied['direction']?.toString();
    final ownOrder = order == null || (order == defaultOrder && (direction ?? 'desc') == (defaultDirection ?? 'desc'));
    final lastDays = int.tryParse('${applied['lastDays'] ?? ''}');
    final ownLimit = lastDays == null || lastDays == (dateLimitDays > 0 ? dateLimitDays : -1);
    final starter = applied['starterName']?.toString();
    return FCTopicFilters(
      order: ownOrder ? null : order,
      direction: ownOrder ? null : direction,
      prefixId: int.tryParse('${applied['prefixId'] ?? ''}'),
      starterName: starter == null || starter.trim().isEmpty ? null : starter,
      lastDays: ownLimit ? null : lastDays,
    );
  }

  /// The getTopic params.
  Map<String, dynamic> toParams() => {
        if (order != null) 'order': order,
        if (order != null && direction != null) 'direction': direction,
        if (prefixId != null) 'prefixId': prefixId,
        if (starterName?.trim().isNotEmpty ?? false) 'starterName': starterName!.trim(),
        if (lastDays != null) 'lastDays': lastDays,
      };
}
