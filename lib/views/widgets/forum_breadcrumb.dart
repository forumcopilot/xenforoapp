import 'package:flutter/material.dart';
import 'package:forumcopilot_flutter/controllers/site_manager.dart';
import 'package:forumcopilot_flutter/utils/forum_navigation.dart';
import 'package:forumcopilot_flutter/views/widgets/forum_actions.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/models/entities/fc_forum.dart';
import '../../theme/design_tokens.dart';
import 'package:forumcopilot_flutter/core/logging/app_logger.dart';
import '../../l10n/generated/app_localizations.dart';

/// A reusable breadcrumb navigation widget for forum pages
class ForumBreadcrumb extends StatelessWidget {
  final SiteContext siteContext;

  /// List of forums in the breadcrumb path
  final List<FCForum> breadcrumbForums;

  /// Optional current topic title (used in post pages)
  final String? currentTopicTitle;

  /// Whether to show the home icon button
  final bool showHomeButton;

  const ForumBreadcrumb({
    super.key,
    required this.siteContext,
    required this.breadcrumbForums,
    this.currentTopicTitle,
    this.showHomeButton = true,
  });

  @override
  Widget build(BuildContext context) {
    if (breadcrumbForums.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingL, vertical: DesignTokens.spacingS),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
            width: 1,
          ),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // Home link
            if (showHomeButton)
              IconButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                icon: Icon(
                  Icons.home_outlined,
                  size: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
                padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingS, vertical: DesignTokens.spacingXS),
                constraints: const BoxConstraints(),
                splashRadius: 20,
              ),
            // Breadcrumb items
            ...breadcrumbForums.asMap().entries.map((entry) {
              final index = entry.key;
              final forum = entry.value;
              final isLast = index == breadcrumbForums.length - 1;

              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  TextButton(
                    onPressed: () {
                      AppLogger.debug('DEBUG: Breadcrumb item tapped - Forum: ${forum.name}, ID: ${forum.id}, Index: $index');
                      _handleForumNavigation(context, siteContext, forum);
                    },
                    child: Text(
                      forum.name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isLast ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingS, vertical: DesignTokens.spacingXS),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  /// Handles navigation when a forum breadcrumb is tapped
  Future<void> _handleForumNavigation(BuildContext context, SiteContext siteContext, FCForum forum) async {
    try {
      AppLogger.debug('Breadcrumb tapped - Forum ID: ${forum.id}, Forum Name: ${forum.name}');

      // Get the forum from the manager to ensure we have the latest data
      final siteManager = SiteManagerRegistry.getManager(siteContext);
      final targetForum = await siteManager.getForumById(forum.id);

      if (targetForum != null) {
        if (targetForum.isProtected) {
          // Handle protected forum with password dialog
          final forumActions = ForumActions();
          forumActions.enterProtectedForum(
            context,
            siteContext,
            targetForum,
            onSuccess: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
              pushForumOrLinkForum(context, targetForum, siteContext);
            },
          );
        } else {
          // Regular forum navigation (or link forum -> in-app web view)
          Navigator.of(context).popUntil((route) => route.isFirst);
          pushForumOrLinkForum(context, targetForum, siteContext);
        }
      } else {
        AppLogger.debug('Forum not found in manager: ${forum.id}');
        // Show error message to user
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)?.forumNotFound(forum.name) ?? 'Forum not found: ${forum.name}'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      AppLogger.debug('Error navigating to forum ${forum.id}: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)?.failedToNavigateToForumName(forum.name) ?? 'Failed to navigate to ${forum.name}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }
}

/// A stateful wrapper for ForumBreadcrumb that handles loading breadcrumb data
class ForumBreadcrumbLoader extends StatefulWidget {
  /// The forum ID to load breadcrumb for
  final String forumId;
  final SiteContext siteContext;

  /// Optional current topic title (used in post pages)
  final String? currentTopicTitle;

  /// Whether to show the home icon button
  final bool showHomeButton;

  /// Callback when breadcrumb data is loaded
  final void Function(List<FCForum>)? onBreadcrumbLoaded;

  const ForumBreadcrumbLoader({
    super.key,
    required this.siteContext,
    required this.forumId,
    this.currentTopicTitle,
    this.showHomeButton = true,
    this.onBreadcrumbLoaded,
  });

  @override
  State<ForumBreadcrumbLoader> createState() => _ForumBreadcrumbLoaderState();
}

class _ForumBreadcrumbLoaderState extends State<ForumBreadcrumbLoader> {
  List<FCForum> _breadcrumbForums = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBreadcrumb(widget.siteContext);
  }

  @override
  void didUpdateWidget(ForumBreadcrumbLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.forumId != widget.forumId) {
      _loadBreadcrumb(widget.siteContext);
    }
  }

  Future<void> _loadBreadcrumb(SiteContext siteContext) async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final forumManager = SiteManagerRegistry.getManager(siteContext);
      final breadcrumb = await forumManager.getBreadcrumbPath(widget.forumId);

      if (mounted) {
        setState(() {
          _breadcrumbForums = breadcrumb;
          _isLoading = false;
        });

        // Notify parent of loaded breadcrumb
        widget.onBreadcrumbLoaded?.call(breadcrumb);
      }
    } catch (e) {
      AppLogger.debug('Failed to load breadcrumb for forum ${widget.forumId}: $e');
      if (mounted) {
        setState(() {
          _breadcrumbForums = [];
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingL, vertical: DesignTokens.spacingS),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: DesignTokens.spacingS),
            Text(
              'Loading breadcrumb...',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      );
    }

    return ForumBreadcrumb(
      siteContext: widget.siteContext,
      breadcrumbForums: _breadcrumbForums,
      currentTopicTitle: widget.currentTopicTitle,
      showHomeButton: widget.showHomeButton,
    );
  }
}
