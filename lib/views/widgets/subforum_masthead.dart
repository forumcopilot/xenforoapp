import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/models/entities/fc_forum.dart';

import '../../theme/forum_identity.dart';
import 'forum_icon_tile.dart';
import 'forum_masthead.dart' show ForumMasthead, MastheadCollapsedOnly, mastheadOpenness;
import 'forum_stats.dart';
import 'sheet_title.dart';

/// The top of a forum's page (a sub-forum, or a category's forums), laid
/// out like the forum's Home masthead and the Discourse app's category
/// header: where it sits (the forum, and the forum it is in), its icon and
/// name, two lines of description (a tap reads the rest when cut short)
/// and how big it is, in the forum's header colours with its accent along
/// the bottom.
///
/// It collapses into the page's bar, down to the icon and the name, so the
/// name shows once: in the open header or in the bar. It replaces a centred
/// banner over the app's pattern, under a bar that repeated the name.
class SubforumMasthead extends StatelessWidget {
  const SubforumMasthead({
    super.key,
    required this.siteContext,
    required this.forum,
    this.parent,
    this.onOpenParent,
    this.actions = const [],
  });

  final SiteContext siteContext;
  final FCForum forum;

  /// The forum this one is in; null at the top, or while it is looked up.
  final FCForum? parent;

  /// Opens [parent]; null leaves its name in the breadcrumb inert.
  final VoidCallback? onOpenParent;

  /// The bar's actions, open or collapsed (the ⋮ menu).
  final List<Widget> actions;

  static const toolbarHeight = ForumMasthead.toolbarHeight;
  static const lineHeight = ForumMasthead.lineHeight;

  /// The space the header takes below the status bar once collapsed, so a
  /// refresh indicator can sit under the bar.
  static double get collapsedHeight => toolbarHeight + lineHeight;

  static const double _iconSize = 40;
  static const EdgeInsets _padding = EdgeInsets.fromLTRB(16, 0, 16, 16);

  String? get _description {
    final d = forum.description?.trim();
    return d == null || d.isEmpty ? null : d;
  }

  @override
  Widget build(BuildContext context) {
    final identity = ForumIdentity.of(context, siteContext.site);
    final styles = _IntroStyles.of(context, identity);
    final layout = _IntroLayout.measure(context, styles, forum.name, _description, forumStatsLine(context, forum));
    final overlay = identity.hasDarkBackground ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark;
    return SliverAppBar(
      pinned: true,
      expandedHeight: toolbarHeight + layout.height + lineHeight,
      toolbarHeight: toolbarHeight,
      backgroundColor: identity.background,
      foregroundColor: identity.foreground,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      elevation: 0,
      systemOverlayStyle: overlay.copyWith(statusBarColor: Colors.transparent),
      // Close to the back button; the usual margin where there is none.
      titleSpacing: (ModalRoute.of(context)?.canPop ?? false) ? 4 : NavigationToolbar.kMiddleSpacing,
      centerTitle: false,
      title: MastheadCollapsedOnly(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ForumIconTile(name: forum.name, url: forum.logoUrl, size: 28),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                forum.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: styles.name,
              ),
            ),
          ],
        ),
      ),
      actions: [...actions, const SizedBox(width: 4)],
      flexibleSpace: _SubforumIntro(
        identity: identity,
        styles: styles,
        layout: layout,
        forum: forum,
        description: _description,
        parent: parent,
        onOpenParent: onOpenParent,
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

/// The open header's text styles, in the forum's header colours.
class _IntroStyles {
  _IntroStyles({
    required this.crumb,
    required this.name,
    required this.description,
    required this.stats,
    required this.muted,
  });

  factory _IntroStyles.of(BuildContext context, ForumIdentity identity) {
    final text = Theme.of(context).textTheme;
    final fg = identity.foreground;
    return _IntroStyles(
      crumb: text.bodySmall?.copyWith(color: fg.withValues(alpha: 0.7)),
      name: text.titleLarge?.copyWith(color: fg, fontWeight: FontWeight.w500),
      description: text.bodyMedium?.copyWith(color: fg.withValues(alpha: 0.8)),
      stats: text.bodySmall?.copyWith(color: fg.withValues(alpha: 0.7)),
      muted: fg.withValues(alpha: 0.7),
    );
  }

  final TextStyle? crumb;
  final TextStyle? name;
  final TextStyle? description;
  final TextStyle? stats;
  final Color muted;
}

/// The open header's height at this width and text size, measured line by
/// line, and whether the description had to be cut short.
class _IntroLayout {
  _IntroLayout({required this.height, required this.stats, required this.descriptionCut});

  static const double crumbPadding = 4;
  static const double nameGap = 4;
  static const double descriptionGap = 8;
  static const double statsGap = 6;

  factory _IntroLayout.measure(
      BuildContext context, _IntroStyles styles, String name, String? description, String? stats) {
    final scaler = MediaQuery.textScalerOf(context);
    final direction = Directionality.of(context);
    final width = MediaQuery.sizeOf(context).width - SubforumMasthead._padding.horizontal;
    var descriptionCut = false;
    double measure(String s, TextStyle? style, int maxLines, double maxWidth, {bool isDescription = false}) {
      final painter = TextPainter(
        text: TextSpan(text: s, style: style),
        maxLines: maxLines,
        textDirection: direction,
        textScaler: scaler,
      )..layout(maxWidth: math.max(0, maxWidth));
      if (isDescription) descriptionCut = painter.didExceedMaxLines;
      final h = painter.height;
      painter.dispose();
      return h.ceilToDouble();
    }

    var h = math.max(measure('A', styles.crumb, 1, width), 16) + 2 * crumbPadding;
    h += nameGap +
        math.max(measure(name, styles.name, 2, width - SubforumMasthead._iconSize - 12), SubforumMasthead._iconSize);
    if (description != null) {
      h += descriptionGap + measure(description, styles.description, 2, width, isDescription: true);
    }
    if (stats != null) h += statsGap + measure(stats, styles.stats, 1, width);
    return _IntroLayout(height: h + SubforumMasthead._padding.vertical, stats: stats, descriptionCut: descriptionCut);
  }

  final double height;
  final String? stats;
  final bool descriptionCut;
}

/// The open header: breadcrumb, icon and name, description and stats,
/// clipped between the bar and the accent line so it slides under the bar
/// as the page scrolls, fading.
class _SubforumIntro extends StatelessWidget {
  const _SubforumIntro({
    required this.identity,
    required this.styles,
    required this.layout,
    required this.forum,
    required this.description,
    required this.parent,
    required this.onOpenParent,
  });

  final ForumIdentity identity;
  final _IntroStyles styles;
  final _IntroLayout layout;
  final FCForum forum;
  final String? description;
  final FCForum? parent;
  final VoidCallback? onOpenParent;

  void _showDescription(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SheetTitle(forum.name),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(description ?? '', style: Theme.of(context).textTheme.bodyLarge),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = mastheadOpenness(context);
    final opacity = ((t - 0.3) / 0.7).clamp(0.0, 1.0);
    final hidden = opacity < 0.5;
    final parent = this.parent;
    final description = this.description;
    final stats = layout.stats;

    // Where the forum sits: the forum's name, then the forum this one is in.
    final crumb = Padding(
      padding: const EdgeInsets.symmetric(vertical: _IntroLayout.crumbPadding),
      child: Row(
        children: [
          Icon(Icons.forum_outlined, size: 16, color: styles.muted),
          const SizedBox(width: 6),
          Flexible(
            child: Text(identity.name, style: styles.crumb, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          if (parent != null) ...[
            Icon(Icons.chevron_right, size: 16, color: styles.muted),
            Flexible(
              child: Semantics(
                button: onOpenParent != null,
                child: InkWell(
                  onTap: onOpenParent,
                  child: Text(
                    parent.name,
                    style: styles.crumb?.copyWith(fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );

    final content = Padding(
      padding: SubforumMasthead._padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          crumb,
          const SizedBox(height: _IntroLayout.nameGap),
          Row(
            children: [
              ForumIconTile(name: forum.name, url: forum.logoUrl, size: SubforumMasthead._iconSize),
              const SizedBox(width: 12),
              Expanded(
                child: Semantics(
                  header: true,
                  child: Text(forum.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: styles.name),
                ),
              ),
            ],
          ),
          if (description != null) ...[
            const SizedBox(height: _IntroLayout.descriptionGap),
            // Cut short at two lines; a tap reads the rest.
            Semantics(
              button: layout.descriptionCut,
              child: GestureDetector(
                onTap: layout.descriptionCut ? () => _showDescription(context) : null,
                child: Text(description, maxLines: 2, overflow: TextOverflow.ellipsis, style: styles.description),
              ),
            ),
          ],
          if (stats != null) ...[
            const SizedBox(height: _IntroLayout.statsGap),
            Text(stats, maxLines: 1, overflow: TextOverflow.ellipsis, style: styles.stats),
          ],
        ],
      ),
    );

    return Stack(children: [
      Positioned(
        top: MediaQuery.paddingOf(context).top + SubforumMasthead.toolbarHeight,
        left: 0,
        right: 0,
        bottom: SubforumMasthead.lineHeight,
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
