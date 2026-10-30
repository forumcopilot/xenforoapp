import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../theme/design_tokens.dart';

/// What a forum's thread list can be sorted and filtered by, from its first
/// page (XenForo add-on 1.11.0+).
class ThreadListOptions {
  const ThreadListOptions({
    required this.sortOptions,
    this.defaultOrder,
    this.defaultDirection,
    this.prefixes = const [],
    this.dateLimitOptions = const [],
    this.dateLimitDays = 0,
  });

  final List<FCSortOption> sortOptions;
  final String? defaultOrder;
  final String? defaultDirection;
  final List<FCPrefix> prefixes;
  final List<int> dateLimitOptions;

  /// The forum's own date limit, in days (0: none).
  final int dateLimitDays;

  /// From a getTopic reply; null when the forum can't sort or filter.
  static ThreadListOptions? from(FCTopicDataResult result) {
    final sortOptions = result.sortOptions;
    if (sortOptions == null || sortOptions.isEmpty) return null;
    return ThreadListOptions(
      sortOptions: sortOptions,
      defaultOrder: result.defaultOrder,
      defaultDirection: result.defaultDirection,
      prefixes: result.prefixes,
      dateLimitOptions: result.dateLimitOptions ?? const [],
      dateLimitDays: result.dateLimitDays ?? 0,
    );
  }

  String sortTitle(String key) => sortOptions.where((o) => o.key == key).firstOrNull?.title ?? key;

  String? prefixTitle(int id) => prefixes.where((p) => p.prefixId == '$id').firstOrNull?.prefixDisplayName;
}

/// A period of days as XenForo's "Last updated" menu names it: Any time,
/// 7 days, 2 months, 1 year...
String threadPeriodLabel(AppLocalizations l10n, int days) {
  if (days < 0) return l10n.anyTime;
  if (days >= 365 && days % 365 == 0) return l10n.periodYears(days ~/ 365);
  if (days >= 60) return l10n.periodMonths((days / 30).round());
  return l10n.periodDays(days);
}

/// The website's thread filter menu as a sheet: prefix, started by, last
/// updated, sort order. Pops the new filters, or null when closed.
class ThreadFiltersSheet extends StatefulWidget {
  const ThreadFiltersSheet({super.key, required this.options, required this.filters});

  final ThreadListOptions options;
  final FCTopicFilters filters;

  @override
  State<ThreadFiltersSheet> createState() => _ThreadFiltersSheetState();
}

class _ThreadFiltersSheetState extends State<ThreadFiltersSheet> {
  late int? _prefixId = widget.filters.prefixId;
  late final TextEditingController _starter = TextEditingController(text: widget.filters.starterName ?? '');
  late int _lastDays = widget.filters.lastDays ?? (widget.options.dateLimitDays > 0 ? widget.options.dateLimitDays : -1);
  late String _order = widget.filters.order ?? widget.options.defaultOrder ?? widget.options.sortOptions.first.key;
  late String _direction = widget.filters.direction ?? widget.options.defaultDirection ?? 'desc';

  @override
  void dispose() {
    _starter.dispose();
    super.dispose();
  }

  FCTopicFilters _chosen() {
    final options = widget.options;
    final forumOrder = _order == (options.defaultOrder ?? options.sortOptions.first.key) &&
        _direction == (options.defaultDirection ?? 'desc');
    final forumLimit = _lastDays == (options.dateLimitDays > 0 ? options.dateLimitDays : -1);
    final starter = _starter.text.trim();
    return FCTopicFilters(
      // The forum's own order and date limit need no filter.
      order: forumOrder ? null : _order,
      direction: forumOrder ? null : _direction,
      prefixId: _prefixId,
      starterName: starter.isEmpty ? null : starter,
      lastDays: forumLimit ? null : _lastDays,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final options = widget.options;
    final days = {...options.dateLimitOptions, _lastDays}.toList()..sort((a, b) => a < 0 ? -1 : (b < 0 ? 1 : a - b));

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          DesignTokens.spacingL,
          0,
          DesignTokens.spacingL,
          DesignTokens.spacingM + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.threadFilters, style: textTheme.titleLarge?.copyWith(color: colorScheme.onSurface)),
              const SizedBox(height: DesignTokens.spacingL),
              if (options.prefixes.isNotEmpty) ...[
                DropdownButtonFormField<int?>(
                  initialValue: _prefixId,
                  decoration: InputDecoration(labelText: l10n.prefix, border: const OutlineInputBorder()),
                  items: [
                    DropdownMenuItem<int?>(value: null, child: Text(l10n.anyPrefix)),
                    for (final p in options.prefixes)
                      if (int.tryParse(p.prefixId) != null)
                        DropdownMenuItem<int?>(
                          value: int.parse(p.prefixId),
                          child: Text(p.group?.isNotEmpty == true ? '${p.group} · ${p.prefixDisplayName}' : p.prefixDisplayName),
                        ),
                  ],
                  onChanged: (value) => setState(() => _prefixId = value),
                ),
                const SizedBox(height: DesignTokens.spacingM),
              ],
              TextField(
                controller: _starter,
                textInputAction: TextInputAction.done,
                autocorrect: false,
                decoration: InputDecoration(labelText: l10n.startedBy, border: const OutlineInputBorder()),
              ),
              if (days.length > 1) ...[
                const SizedBox(height: DesignTokens.spacingM),
                DropdownButtonFormField<int>(
                  initialValue: _lastDays,
                  decoration: InputDecoration(labelText: l10n.lastUpdated, border: const OutlineInputBorder()),
                  items: [
                    for (final d in days) DropdownMenuItem<int>(value: d, child: Text(threadPeriodLabel(l10n, d))),
                  ],
                  onChanged: (value) => setState(() => _lastDays = value ?? _lastDays),
                ),
              ],
              const SizedBox(height: DesignTokens.spacingM),
              DropdownButtonFormField<String>(
                initialValue: _order,
                decoration: InputDecoration(labelText: l10n.sortBy, border: const OutlineInputBorder()),
                items: [
                  for (final o in options.sortOptions) DropdownMenuItem<String>(value: o.key, child: Text(o.title)),
                ],
                onChanged: (value) => setState(() => _order = value ?? _order),
              ),
              const SizedBox(height: DesignTokens.spacingS),
              SegmentedButton<String>(
                segments: [
                  ButtonSegment(value: 'asc', icon: const Icon(Icons.arrow_upward_rounded), label: Text(l10n.sortAscending)),
                  ButtonSegment(value: 'desc', icon: const Icon(Icons.arrow_downward_rounded), label: Text(l10n.sortDescending)),
                ],
                selected: {_direction},
                onSelectionChanged: (value) => setState(() => _direction = value.first),
              ),
              const SizedBox(height: DesignTokens.spacingL),
              Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(const FCTopicFilters()),
                    child: Text(l10n.clearFilters),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(l10n.cancel),
                  ),
                  const SizedBox(width: DesignTokens.spacingS),
                  FilledButton(
                    onPressed: () => Navigator.of(context).pop(_chosen()),
                    child: Text(l10n.applyFilters),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
