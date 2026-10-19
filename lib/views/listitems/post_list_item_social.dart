import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/models/entities/fc_post.dart';
import 'package:forumcopilot_sdk/models/entities/fc_reaction.dart';
import 'package:forumcopilot_flutter/views/widgets/react_button.dart';
import 'package:forumcopilot_flutter/views/widgets/reaction_summary.dart';
import '../../utils/accessibility_helpers.dart';
import '../../theme/design_tokens.dart';
import '../../l10n/generated/app_localizations.dart';

class PostListItemSocial extends StatelessWidget {
  final FCPost post;
  final bool isLiked;
  final int likeCount;
  final bool isLoggedIn;
  final VoidCallback? onLike;

  /// Long press on the react button: the reaction picker. Null on a forum
  /// with only Like.
  final VoidCallback? onLongPressLike;
  final VoidCallback? onShowLikes;
  final Widget? trailing;

  /// The viewer's current reaction (multi-reaction). Any reaction other
  /// than the forum's Like shows on the react button (native emoji, or the
  /// reaction's image for custom reactions) instead of the filled heart.
  final FCReaction? currentReaction;

  const PostListItemSocial({
    super.key,
    required this.post,
    required this.isLiked,
    required this.likeCount,
    this.currentReaction,
    this.isLoggedIn = false,
    this.onLike,
    this.onLongPressLike,
    this.onShowLikes,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final showReactButton = isLoggedIn && post.canLike;
    final showSummary = reactionTotal(post.likesInfo, likeCount) > 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // if (post.likesInfo.isNotEmpty) ...[
        //   const SizedBox(height: 12),
        //   Row(
        //     children: [
        //       Icon(Icons.favorite_border, size: 18, color: colorScheme.primary),
        //       const SizedBox(width: 6),
        //       Text('Likes: ', style: textTheme.bodySmall),
        //       ...post.likesInfo.take(4).map((l) => Padding(
        //             padding: const EdgeInsets.symmetric(horizontal: 2.0),
        //             child: Chip(
        //               label: Text(l.username, style: textTheme.bodySmall),
        //               visualDensity: VisualDensity.compact,
        //             ),
        //           )),
        //       if (post.likesInfo.length > 4)
        //         Text(
        //           ' + {post.likesInfo.length - 4} more people',
        //           style: textTheme.bodySmall,
        //         ),
        //     ],
        //   ),
        // ],
        // Like button row
        SizedBox(height: DesignTokens.spacingM),
        // As in the Discourse app: the actions sit at the end of the row, with
        // Reply last; the summary (the emoji people used and how many; a tap
        // lists who) packed against the react button it counts for.
        Row(
          children: [
            const Spacer(),
            if (showSummary) ...[
              ReactionSummary(
                likes: post.likesInfo,
                count: likeCount,
                besideReactButton: showReactButton,
                onTap: post.likesInfo.isNotEmpty ? onShowLikes : null,
              ),
            ],
            // Show like button only if logged in and can like
            if (showReactButton)
              ReactButton(
                isReacted: isLiked,
                reaction: isLiked ? currentReaction : null,
                // A tap likes (or takes your reaction back); a long press
                // opens the picker, so a Like is one tap on any forum.
                onTap: onLike,
                onLongPress: onLongPressLike,
                label: AccessibilityHelpers.getLikeButtonLabel(context, isLiked, likeCount),
                hint: onLongPressLike == null
                    ? null
                    : AppLocalizations.of(context).reactionHoldHint,
              ),
            // Reply last, as in the Discourse app.
            if (trailing != null) trailing!,
          ],
        ),
      ],
    );
  }
}
