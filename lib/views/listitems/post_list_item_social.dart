import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/models/entities/fc_post.dart';
import 'package:forumcopilot_sdk/models/entities/fc_reaction.dart';
import 'package:forumcopilot_flutter/views/widgets/reaction_picker.dart' show ReactionGlyph;
import 'package:forumcopilot_flutter/views/widgets/reaction_summary.dart';
import '../../utils/accessibility_helpers.dart';
import '../../theme/design_tokens.dart';

class PostListItemSocial extends StatelessWidget {
  final FCPost post;
  final bool isLiked;
  final int likeCount;
  final bool isLoggedIn;
  final VoidCallback? onLike;
  final VoidCallback? onShowLikes;
  final Widget? trailing;

  /// The viewer's current reaction (multi-reaction). When set, the react
  /// button renders it (native emoji, or the reaction's image for custom
  /// reactions) instead of the default heart icon.
  final FCReaction? currentReaction;

  const PostListItemSocial({
    super.key,
    required this.post,
    required this.isLiked,
    required this.likeCount,
    this.currentReaction,
    this.isLoggedIn = false,
    this.onLike,
    this.onShowLikes,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
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
        Row(
          children: [
            // Reply button (trailing widget)
            if (trailing != null) trailing!,
            // Reactions, as in the Discourse app: the summary (the emoji
            // people used and how many; a tap lists who) packed against the
            // react button it counts for.
            if (showSummary) ...[
              if (trailing != null) SizedBox(width: DesignTokens.spacingXL),
              ReactionSummary(
                likes: post.likesInfo,
                count: likeCount,
                besideReactButton: showReactButton,
                onTap: post.likesInfo.isNotEmpty ? onShowLikes : null,
              ),
            ],
            // Show like button only if logged in and can like
            if (showReactButton) ...[
              if (trailing != null && !showSummary) SizedBox(width: DesignTokens.spacingXL),
              Builder(
                builder: (context) {
                  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
                  final iconColor = isLiked
                      ? colorScheme.error
                      : colorScheme.onSurfaceVariant.withOpacity(isDarkMode ? 0.4 : 0.5);
                  // When the viewer has a specific reaction, render it (native
                  // emoji or the reaction's image for custom reactions);
                  // otherwise fall back to the heart icon (liked = filled).
                  final Widget reactIcon = (isLiked && currentReaction != null)
                      ? ReactionGlyph(
                          reaction: currentReaction!,
                          size: DesignTokens.iconSizeMedium,
                        )
                      : Icon(
                          Icons.favorite,
                          color: iconColor,
                          size: DesignTokens.iconSizeMedium,
                        );
                  return AccessibilityHelpers.accessibleIconButton(
                    icon: reactIcon,
                    onTap: onLike,
                    label: AccessibilityHelpers.getLikeButtonLabel(context, isLiked, likeCount),
                    isSelected: isLiked,
                    context: context,
                  );
                },
              ),
            ],
          ],
        ),
      ],
    );
  }
}
