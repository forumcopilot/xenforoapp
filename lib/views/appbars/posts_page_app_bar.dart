import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import '../../theme/design_tokens.dart';

class PostsPageAppBar extends StatefulWidget implements PreferredSizeWidget {
  const PostsPageAppBar({
    required this.siteContext,
    required String title,
    this.onShare,
    this.onViewOnWeb,
    this.onSubscribe,
    this.onClose,
    this.onSticky,
    this.onDelete,
    this.onRefresh,
    this.isSubscribed = false,
    this.showMarkRead = false,
    this.isClosed = false,
    this.isDeleted = false,
    this.isSticky = false,
    this.canSubscribe = false,
    this.canClose = false,
    this.canSticky = false,
    this.canDelete = false,
    super.key,
  }) : _title = title;

  final SiteContext siteContext;
  final String _title;
  final VoidCallback? onShare;
  final VoidCallback? onViewOnWeb;
  final VoidCallback? onSubscribe;
  final VoidCallback? onClose;
  final VoidCallback? onSticky;
  final VoidCallback? onDelete;
  final VoidCallback? onRefresh;
  final bool isSubscribed;
  final bool showMarkRead;
  final bool isClosed;
  final bool isDeleted;
  final bool isSticky;
  final bool canSubscribe;
  final bool canClose;
  final bool canSticky;
  final bool canDelete;

  @override
  State<PostsPageAppBar> createState() => PostsPageAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class PostsPageAppBarState extends State<PostsPageAppBar> {
  String _currentTitle = '';

  @override
  void initState() {
    super.initState();
    _currentTitle = widget._title;
  }

  void updateTitle(String newTitle) {
    if (newTitle.isNotEmpty && newTitle != _currentTitle) {
      setState(() {
        _currentTitle = newTitle;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AppBar(
      title: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate available width for the title
          // Subtract space for back button and actions
          final availableWidth = constraints.maxWidth - 80; // 40 for back button, 40 for actions

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: _buildAdaptiveTitle(
                  _currentTitle,
                  colorScheme,
                  textTheme,
                  availableWidth,
                ),
              ),
            ],
          );
        },
      ),
      backgroundColor: colorScheme.surface,
      elevation: 3,
      shadowColor: colorScheme.shadow.withOpacity(DesignTokens.opacityLow),
      surfaceTintColor: colorScheme.surfaceTint,
      iconTheme: IconThemeData(
        color: colorScheme.onSurface,
      ),
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.of(context).maybePop();
          },
        ),
      ),
      actions: _buildActions(context),
      centerTitle: false,
    );
  }

  Widget _buildAdaptiveTitle(String title, ColorScheme colorScheme, TextTheme textTheme, double availableWidth) {
    // Test if the title fits in one line with font size 20
    final textSpan = TextSpan(
      text: title,
      style: textTheme.titleLarge?.copyWith(
        color: colorScheme.onSurface,
        fontWeight: DesignTokens.fontWeightMedium,
        fontSize: DesignTokens.fontSizeL,
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      maxLines: 1,
    );
    textPainter.layout(maxWidth: availableWidth);

    if (textPainter.didExceedMaxLines) {
      // Text is too long, use smaller font size for both lines
      return Text(
        title,
        style: textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: DesignTokens.fontWeightMedium,
          fontSize: DesignTokens.fontSizeM,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );
    } else {
      // Text fits in one line, use regular font size
      return Text(
        title,
        style: textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w500,
          fontSize: DesignTokens.fontSizeL,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }
  }

  List<Widget> _buildActions(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return [
      PopupMenuButton<String>(
        icon: Icon(
          Icons.more_vert_rounded,
          color: colorScheme.onSurfaceVariant,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusM),
        ),
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'refresh',
            child: Row(
              children: [
                Icon(
                  Icons.refresh_rounded,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: DesignTokens.spacingM),
                Text(
                  AppLocalizations.of(context)?.refresh ?? 'Refresh',
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          if (widget.siteContext.isLoggedIn && widget.canSubscribe && widget.onSubscribe != null)
            PopupMenuItem(
              value: 'subscribe',
              child: Row(
                children: [
                  Icon(
                    widget.isSubscribed ? Icons.watch_rounded : Icons.watch_outlined,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: DesignTokens.spacingM),
                  Text(
                    widget.isSubscribed
                        ? (AppLocalizations.of(context)?.unsubscribe ?? 'Unsubscribe')
                        : (AppLocalizations.of(context)?.subscribe ?? 'Subscribe'),
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          if (widget.siteContext.isLoggedIn && widget.canClose)
            PopupMenuItem(
              value: 'lock',
              child: Row(
                children: [
                  Icon(
                    widget.isClosed ? Icons.lock_open_rounded : Icons.lock_outline_rounded,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: DesignTokens.spacingM),
                  Text(
                    widget.isClosed 
                        ? (AppLocalizations.of(context)?.unlock ?? 'Unlock')
                        : (AppLocalizations.of(context)?.lock ?? 'Lock'),
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          if (widget.siteContext.isLoggedIn && widget.canSticky)
            PopupMenuItem(
              value: 'sticky',
              child: Row(
                children: [
                  Icon(
                    widget.isSticky ? Icons.push_pin_rounded : Icons.push_pin_outlined,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: DesignTokens.spacingM),
                  Text(
                    widget.isSticky 
                        ? (AppLocalizations.of(context)?.unstick ?? 'Unstick')
                        : (AppLocalizations.of(context)?.stick ?? 'Stick'),
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          if (widget.siteContext.isLoggedIn && widget.canDelete)
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(
                    widget.isDeleted ? Icons.restore_from_trash_rounded : Icons.delete_outline_rounded,
                    color: colorScheme.error,
                  ),
                  const SizedBox(width: DesignTokens.spacingM),
                  Text(
                    widget.isDeleted ? (AppLocalizations.of(context)?.undelete ?? 'Undelete') : (AppLocalizations.of(context)?.delete ?? 'Delete'),
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.error,
                    ),
                  ),
                ],
              ),
            ),
          if (widget.onShare != null)
            PopupMenuItem(
              value: 'share',
              child: Row(
                children: [
                  Icon(
                    Icons.share_rounded,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: DesignTokens.spacingM),
                  Text(
                    AppLocalizations.of(context)?.share ?? 'Share',
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          if (widget.onViewOnWeb != null)
            PopupMenuItem(
              value: 'view_on_web',
              child: Row(
                children: [
                  Icon(
                    Icons.open_in_browser_rounded,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: DesignTokens.spacingM),
                  Text(
                    AppLocalizations.of(context)?.viewOnWeb ?? 'View on Web',
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
        ],
        onSelected: (value) {
          switch (value) {
            case 'refresh':
              widget.onRefresh?.call();
              break;
            case 'subscribe':
              widget.onSubscribe?.call();
              break;
            case 'share':
              widget.onShare?.call();
              break;
            case 'view_on_web':
              widget.onViewOnWeb?.call();
              break;
            case 'lock':
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      widget.isClosed ? 'Unlock Topic' : 'Lock Topic',
                      style: textTheme.titleLarge?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    content: Text(
                      widget.isClosed
                          ? 'Are you sure you want to unlock this topic? Other users will be able to reply and interact with it again.'
                          : 'Are you sure you want to lock this topic? Other users will not be able to reply or interact with it.',
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Cancel',
                          style: textTheme.labelLarge?.copyWith(
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                      FilledButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          widget.onClose?.call();
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          padding: EdgeInsets.symmetric(
                            horizontal: DesignTokens.spacingXL,
                            vertical: DesignTokens.spacingM,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(DesignTokens.radiusL),
                          ),
                          elevation: DesignTokens.elevationMedium,
                        ),
                        child: Text(
                          widget.isClosed ? 'Unlock' : 'Lock',
                          style: textTheme.labelLarge?.copyWith(
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
              break;
            case 'sticky':
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      widget.isSticky ? 'Unstick Topic' : 'Stick Topic',
                      style: textTheme.titleLarge?.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                    content: Text(
                      widget.isSticky
                          ? 'Are you sure you want to unstick this topic? It will no longer appear at the top of the forum.'
                          : 'Are you sure you want to stick this topic? It will appear at the top of the forum for all users.',
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Cancel',
                          style: textTheme.labelLarge?.copyWith(
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                      FilledButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          widget.onSticky?.call();
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          padding: EdgeInsets.symmetric(
                            horizontal: DesignTokens.spacingXL,
                            vertical: DesignTokens.spacingM,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(DesignTokens.radiusL),
                          ),
                          elevation: DesignTokens.elevationMedium,
                        ),
                        child: Text(
                          widget.isSticky ? 'Unstick' : 'Stick',
                          style: textTheme.labelLarge?.copyWith(
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
              break;
            case 'delete':
              // For undelete, show simple confirmation dialog
              if (widget.isDeleted) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        'Undelete Topic',
                        style: textTheme.titleLarge?.copyWith(
                          color: colorScheme.error,
                        ),
                      ),
                      content: Text(
                        'Are you sure you want to undelete this topic? It will be visible to other users again.',
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Cancel',
                            style: textTheme.labelLarge?.copyWith(
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                        FilledButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            widget.onDelete?.call();
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: colorScheme.error,
                            foregroundColor: colorScheme.onError,
                            padding: EdgeInsets.symmetric(
                              horizontal: DesignTokens.spacingXL,
                              vertical: DesignTokens.spacingM,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(DesignTokens.radiusL),
                            ),
                            elevation: DesignTokens.elevationMedium,
                          ),
                          child: Text(
                            AppLocalizations.of(context)?.undelete ?? 'Undelete',
                            style: textTheme.labelLarge?.copyWith(
                              color: colorScheme.onError,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              } else {
                // For delete, let _handleDelete show the comprehensive dialog
                widget.onDelete?.call();
              }
              break;
          }
        },
      ),
    ];
  }
}
