import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/models/results/fc_forum_result.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../theme/forum_identity.dart';
import '../../utils/safe_image.dart';
import 'forum_icon_tile.dart';

/// The top of a forum's Home: its logo and name, one line about the forum,
/// how big it is, and a search field, with a line in the accent along the
/// bottom. (Modelled on the Discourse app's forum masthead.)
///
/// It collapses into the app bar as the page scrolls, down to the logo, the
/// name and a search button, so the screen always says whose forum it is.
/// It replaces an app bar titled "Home" over a patterned banner.
class ForumMasthead extends StatelessWidget {
  const ForumMasthead({
    super.key,
    required this.siteContext,
    this.boardStats,
    this.onSearch,
    this.actions = const [],
  });

  final SiteContext siteContext;
  final FCBoardStatResult? boardStats;

  /// Opens search; null where the visitor cannot search (a guest on a forum
  /// that keeps search to members), which leaves the field out.
  final VoidCallback? onSearch;

  /// Shown in the bar whether open or collapsed (Mark forum read).
  final List<Widget> actions;

  static const toolbarHeight = 64.0;
  static const lineHeight = 3.0;
  static const searchHeight = 48.0;

  /// "56.8K members · 18.5K topics · 1.2M posts", or null before the forum's
  /// stats have loaded.
  static String? statsLine(BuildContext context, FCBoardStatResult? stats) {
    if (stats == null || !stats.result) return null;
    final l10n = AppLocalizations.of(context);
    final parts = [
      if (stats.totalMembers > 0) l10n.statsMembers(stats.totalMembers),
      if (stats.totalThreads > 0) l10n.statsTopics(stats.totalThreads),
      if (stats.totalPosts > 0) l10n.statsPosts(stats.totalPosts),
    ];
    return parts.isEmpty ? null : parts.join(' · ');
  }

  /// The open header's height below the bar at the reader's text size: the
  /// description and stats lines that exist, then the search field.
  static double _introHeight(BuildContext context, ForumIdentity identity,
      {required bool hasStats, required bool hasSearch}) {
    final text = Theme.of(context).textTheme;
    final scaler = MediaQuery.textScalerOf(context);
    double line(TextStyle? s) => (scaler.scale(s?.fontSize ?? 14) * (s?.height ?? 1.4) - 1e-6).ceilToDouble();
    final hasDescription = identity.description != null;
    var h = 0.0;
    // With the logo in the bar, the name is the first line under it.
    if (identity.wordmark != null) h += line(text.titleLarge) + (hasDescription || hasStats ? 2 : 0);
    if (hasDescription) h += line(text.bodyMedium);
    if (hasStats) h += (hasDescription ? 2 : 0) + line(text.bodySmall);
    if (hasSearch) h += (h > 0 ? 12 : 0) + searchHeight;
    return h > 0 ? h + 16 : 0;
  }

  /// The space the open header takes below the status bar, so a refresh
  /// indicator can sit under the bar.
  static double get collapsedHeight => toolbarHeight + lineHeight;

  @override
  Widget build(BuildContext context) {
    final identity = ForumIdentity.of(context, siteContext.site);
    final stats = statsLine(context, boardStats);
    final expanded = toolbarHeight +
        _introHeight(context, identity, hasStats: stats != null, hasSearch: onSearch != null) +
        lineHeight;
    final overlay = identity.hasDarkBackground ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark;
    final l10n = AppLocalizations.of(context);
    return SliverAppBar(
      pinned: true,
      expandedHeight: expanded,
      toolbarHeight: toolbarHeight,
      backgroundColor: identity.background,
      foregroundColor: identity.foreground,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      elevation: 0,
      systemOverlayStyle: overlay.copyWith(statusBarColor: Colors.transparent),
      titleSpacing: 4,
      centerTitle: false,
      title: _MastheadTitle(identity: identity),
      actions: [
        if (onSearch != null)
          _CollapsedOnly(
            child: IconButton(
              tooltip: l10n.search,
              icon: const Icon(Icons.search),
              onPressed: onSearch,
            ),
          ),
        ...actions,
        const SizedBox(width: 4),
      ],
      flexibleSpace: Stack(
        fit: StackFit.expand,
        children: [
          if (identity.banner != null) _MastheadBanner(identity: identity),
          _MastheadIntro(identity: identity, stats: stats, onSearch: onSearch),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(lineHeight),
        child: ColoredBox(
          color: identity.accent,
          child: const SizedBox(height: lineHeight, width: double.infinity),
        ),
      ),
    );
  }
}

/// How far the masthead has collapsed: 1 fully open, 0 down to its bar.
double _openness(BuildContext context) {
  final settings = context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
  if (settings == null) return 1;
  final range = settings.maxExtent - settings.minExtent;
  if (range <= 0) return 0;
  return ((settings.currentExtent - settings.minExtent) / range).clamp(0.0, 1.0);
}

/// The forum's banner picture behind the open header, under a veil of the
/// header's colour so the text reads; the veil thickens as the header
/// collapses, leaving a plain bar.
class _MastheadBanner extends StatelessWidget {
  const _MastheadBanner({required this.identity});

  final ForumIdentity identity;

  static const double _openVeil = 0.75;

  @override
  Widget build(BuildContext context) {
    final t = _openness(context);
    if (t <= 0) return const SizedBox.shrink();
    return Stack(
      fit: StackFit.expand,
      children: [
        ExcludeSemantics(
          child: SafeImageNetwork.networkSafe(
            identity.banner!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
          ),
        ),
        ColoredBox(color: identity.background.withValues(alpha: 1 - (1 - _openVeil) * t)),
      ],
    );
  }
}

/// The forum's own logo while the header is open, where it has one drawn for
/// this header; its icon and name once the header has become the bar.
class _MastheadTitle extends StatelessWidget {
  const _MastheadTitle({required this.identity});

  final ForumIdentity identity;

  static const double _wordmarkHeight = 36;

  @override
  Widget build(BuildContext context) {
    final wordmark = identity.wordmark;
    final Widget child;
    if (wordmark != null && _openness(context) > 0.5) {
      final aspect = identity.wordmarkAspectRatio;
      child = Semantics(
        key: const ValueKey('wordmark'),
        header: true,
        label: identity.name,
        child: ExcludeSemantics(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: _wordmarkHeight, maxWidth: 240),
            child: BrandImage(
              wordmark,
              height: _wordmarkHeight,
              width: aspect != null ? _wordmarkHeight * aspect : null,
              alignment: Alignment.centerLeft,
              fallback: _iconAndName,
            ),
          ),
        ),
      );
    } else {
      child = KeyedSubtree(key: const ValueKey('iconAndName'), child: _iconAndName(context));
    }
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 150),
      layoutBuilder: (current, previous) => Stack(
        alignment: AlignmentDirectional.centerStart,
        children: [...previous, if (current != null) current],
      ),
      child: child,
    );
  }

  Widget _iconAndName(BuildContext context) {
    return Semantics(
      header: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ForumIconTile(name: identity.name, url: identity.icon, size: 32),
          const SizedBox(width: 12),
          Flexible(
            child: LayoutBuilder(
              builder: (context, constraints) => Text(
                identity.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: _nameStyle(context, constraints.maxWidth),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// The name at title size, or a size down when that would cut it short.
  TextStyle? _nameStyle(BuildContext context, double width) {
    final text = Theme.of(context).textTheme;
    TextStyle? styled(TextStyle? s) => s?.copyWith(color: identity.foreground, fontWeight: FontWeight.w500);
    final large = styled(text.titleLarge);
    final painter = TextPainter(
      text: TextSpan(text: identity.name, style: large),
      maxLines: 1,
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
    )..layout();
    final fits = !painter.didExceedMaxLines && painter.width <= width;
    painter.dispose();
    return fits ? large : styled(text.titleMedium);
  }
}

/// Shown only once the header has collapsed (the search button, which the
/// open header has as a field).
class _CollapsedOnly extends StatelessWidget {
  const _CollapsedOnly({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final shown = _openness(context) < 0.3;
    return AnimatedOpacity(
      opacity: shown ? 1 : 0,
      duration: const Duration(milliseconds: 150),
      child: ExcludeSemantics(
        excluding: !shown,
        child: IgnorePointer(ignoring: !shown, child: child),
      ),
    );
  }
}

/// The open header's lower part: a line about the forum, its stats and the
/// search field. It sits between the bar and the accent line and is clipped
/// there, so on scroll it slides under the bar, fading.
class _MastheadIntro extends StatelessWidget {
  const _MastheadIntro({required this.identity, required this.stats, required this.onSearch});

  final ForumIdentity identity;
  final String? stats;
  final VoidCallback? onSearch;

  @override
  Widget build(BuildContext context) {
    final t = _openness(context);
    final opacity = ((t - 0.3) / 0.7).clamp(0.0, 1.0);
    final hidden = opacity < 0.5;
    final text = Theme.of(context).textTheme;
    final fg = identity.foreground;
    final l10n = AppLocalizations.of(context);
    final description = identity.description;
    final stats = this.stats;
    final onSearch = this.onSearch;
    if (identity.wordmark == null && description == null && stats == null && onSearch == null) {
      return const SizedBox.shrink();
    }

    final content = Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // The bar shows the logo, which may not say the name.
          if (identity.wordmark != null) ...[
            ExcludeSemantics(
              child: Text(
                identity.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: text.titleLarge?.copyWith(color: fg, fontWeight: FontWeight.w600),
              ),
            ),
            if (description != null || stats != null) const SizedBox(height: 2),
          ],
          if (description != null)
            Text(
              description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: text.bodyMedium?.copyWith(color: fg.withValues(alpha: 0.8)),
            ),
          if (stats != null) ...[
            if (description != null) const SizedBox(height: 2),
            Text(
              stats,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: text.bodySmall?.copyWith(color: fg.withValues(alpha: 0.7)),
            ),
          ],
          if (onSearch != null) ...[
            if (description != null || stats != null) const SizedBox(height: 12),
            SizedBox(
              height: ForumMasthead.searchHeight,
              child: Semantics(
                button: true,
                child: Material(
                  color: Color.alphaBlend(
                    fg.withValues(alpha: identity.hasDarkBackground ? 0.12 : 0.06),
                    identity.background,
                  ),
                  shape: const StadiumBorder(),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: onSearch,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(children: [
                        Icon(Icons.search, color: fg),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            l10n.searchForumName(identity.name),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: text.bodyLarge?.copyWith(color: fg.withValues(alpha: 0.7)),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
    return Stack(children: [
      Positioned(
        top: MediaQuery.paddingOf(context).top + ForumMasthead.toolbarHeight,
        left: 0,
        right: 0,
        bottom: ForumMasthead.lineHeight,
        child: ClipRect(
          child: OverflowBox(
            alignment: Alignment.bottomCenter,
            minHeight: 0,
            maxHeight: double.infinity,
            child: Opacity(
              opacity: opacity,
              child: IgnorePointer(
                ignoring: hidden,
                child: ExcludeSemantics(excluding: hidden, child: content),
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}
