import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/models/entities/fc_like.dart';
import 'package:forumcopilot_sdk/models/entities/fc_reaction.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../theme/design_tokens.dart';
import '../user_profile_page.dart';
import 'reaction_picker.dart' show ReactionGlyph, reactionCountLabel;
import 'reaction_summary.dart';
import 'user_avatar.dart';

/// Who reacted to a post or direct message, and with what.
///
/// Opened by a tap on the reaction summary. Ported from the Discourse app's
/// sheet, which follows the Discourse web menu (and XenForo's own "members
/// who reacted" overlay, which has a tab per reaction): a title with the
/// count, a filter chip per reaction with its count when more than one kind
/// was used, and one row per person with their reaction. The reader's own
/// row comes first, marked "You". A button at the bottom opens the picker
/// for a reader who may react.
///
/// The server sends the whole list with the post or message, so the chips
/// filter it here; nothing is fetched.
class ReactionUsersSheet extends StatefulWidget {
  final SiteContext siteContext;
  final List<FCLike> likes;

  /// The server's count (see [reactionTotal]).
  final int count;

  /// Opens the reaction picker; null when the reader may not react (a guest,
  /// their own post, a forum with the single Like), which hides the button.
  final VoidCallback? onReact;

  const ReactionUsersSheet({
    super.key,
    required this.siteContext,
    required this.likes,
    required this.count,
    this.onReact,
  });

  static Future<void> show({
    required BuildContext context,
    required SiteContext siteContext,
    required List<FCLike> likes,
    required int count,
    VoidCallback? onReact,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(DesignTokens.radiusL)),
      ),
      builder: (_) => ReactionUsersSheet(
        siteContext: siteContext,
        // A snapshot: the post's list changes under an open sheet otherwise.
        likes: List.of(likes),
        count: count,
        onReact: onReact,
      ),
    );
  }

  @override
  State<ReactionUsersSheet> createState() => _ReactionUsersSheetState();
}

class _ReactionUsersSheetState extends State<ReactionUsersSheet> {
  /// The reaction the list is filtered on; [_all] for everyone.
  Object? _filter = _all;
  static const Object _all = Object();

  bool _isViewer(FCLike like) {
    final me = widget.siteContext.currentUsername;
    return me != null && like.username.toLowerCase() == me.toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final groups = groupReactions(widget.likes);
    final total = reactionTotal(widget.likes, widget.count);
    final mine = widget.likes.where(_isViewer).firstOrNull;

    final visible = identical(_filter, _all)
        ? widget.likes
        : widget.likes.where((l) => l.reactionId == _filter).toList();
    // The reader's own row leads, wherever the server put it.
    final rows = [
      ...visible.where(_isViewer),
      ...visible.where((l) => !_isViewer(l)),
    ];

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.25,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.only(bottom: DesignTokens.spacingM),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      DesignTokens.spacingL, DesignTokens.spacingS, DesignTokens.spacingS, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Semantics(
                          header: true,
                          child: Text(
                            total > 0
                                ? reactionCountLabel(context, total)
                                : l10n.reactedBy,
                            style: textTheme.titleMedium,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                if (groups.length > 1) _buildFilters(context, groups, total),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: rows.length,
                    itemBuilder: (context, index) => _UserRow(
                      like: rows[index],
                      isYou: _isViewer(rows[index]),
                      siteContext: widget.siteContext,
                    ),
                  ),
                ),
                if (widget.onReact != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        DesignTokens.spacingL, DesignTokens.spacingS, DesignTokens.spacingL, 0),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          final onReact = widget.onReact!;
                          Navigator.pop(context);
                          onReact();
                        },
                        child: Text(mine != null
                            ? l10n.changeYourReaction
                            : l10n.react),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilters(BuildContext context, List<ReactionGroup> groups, int total) {
    final l10n = AppLocalizations.of(context);
    final all = l10n.reactionsAll;

    Widget chip({
      required Object? filter,
      required Widget label,
      required String semantics,
    }) {
      final selected = identical(filter, _all) ? identical(_filter, _all) : _filter == filter;
      return Padding(
        padding: const EdgeInsetsDirectional.only(end: DesignTokens.spacingS),
        child: Semantics(
          label: semantics,
          selected: selected,
          button: true,
          excludeSemantics: true,
          child: ChoiceChip(
            selected: selected,
            showCheckmark: false,
            onSelected: (_) => setState(() => _filter = filter),
            label: label,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(
          DesignTokens.spacingL, DesignTokens.spacingXS, DesignTokens.spacingL, DesignTokens.spacingS),
      child: Row(
        children: [
          chip(filter: _all, label: Text('$all $total'), semantics: '$all, $total'),
          for (final g in groups)
            chip(
              filter: g.id,
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ReactionGlyph(reaction: g.glyph, size: DesignTokens.iconSizeM),
                  const SizedBox(width: DesignTokens.spacingXS),
                  Text('${g.count}'),
                ],
              ),
              semantics: l10n.reactionFilterSemantics(g.name, g.count),
            ),
        ],
      ),
    );
  }
}

class _UserRow extends StatelessWidget {
  final FCLike like;
  final bool isYou;
  final SiteContext siteContext;

  const _UserRow({required this.like, required this.isYou, required this.siteContext});

  void _openProfile(BuildContext context) {
    final navigator = Navigator.of(context);
    navigator.pop();
    navigator.push(
      MaterialPageRoute(
        builder: (_) => UserProfilePage(
          siteContext: siteContext,
          userId: like.userId,
          userName: like.username,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final FCReaction glyph = reactionGlyphFor(like.reactionId, like);
    return Semantics(
      label: l10n.viewProfileOfUser(like.username),
      button: true,
      child: Material(
        color: isYou ? colorScheme.primaryContainer.withValues(alpha: 0.45) : Colors.transparent,
        child: InkWell(
          onTap: () => _openProfile(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.spacingL, vertical: DesignTokens.spacingS),
            child: Row(
              children: [
                UserAvatar(
                  username: like.username,
                  iconUrl: like.avatarUrl.isNotEmpty ? like.avatarUrl : null,
                  radius: DesignTokens.avatarRadiusM,
                ),
                const SizedBox(width: DesignTokens.spacingM),
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          like.username,
                          style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isYou) ...[
                        const SizedBox(width: DesignTokens.spacingS),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(DesignTokens.radiusXS),
                            border: Border.all(color: colorScheme.primary),
                          ),
                          child: Text(
                            l10n.reactionYou,
                            style: textTheme.labelSmall?.copyWith(color: colorScheme.primary),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: DesignTokens.spacingS),
                ReactionGlyph(reaction: glyph, size: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
