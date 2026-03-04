import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/factory/site_proxy_factory.dart';
import 'package:forumcopilot_sdk/models/results/fc_moderation_result.dart';
import 'package:xenforo_core/xenforo_core.dart' show XenForoModerationProxy;
import '../theme/design_tokens.dart';
import '../core/logging/app_logger.dart';
import 'widgets/forum_breadcrumb.dart';
import 'lists/posts_list.dart';
import 'reply_page.dart';
import 'widgets/post_actions.dart';
import 'widgets/delete_topic_dialog.dart';
import 'appbars/posts_page_app_bar.dart';
import '../utils/url_utils.dart';

class PostPage extends StatefulWidget {
  const PostPage({
    required this.siteContext,
    required this.topicId,
    required this.title,
    this.mode = PostsListMode.normal,
    this.anchorPostId,
    this.gotoPage,
    this.forumId,
    this.isAnnouncement = false,
    super.key,
  });

  final SiteContext siteContext;
  final String topicId;
  final String title;
  final PostsListMode mode;
  final String? anchorPostId;
  final int? gotoPage;
  final String? forumId;
  final bool isAnnouncement;

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  String? _forumId;
  /// Refresh callback from PostsList. When [scrollToPostId] is passed (e.g. after reply),
  /// the list refreshes by loading the thread at that post and scrolling to it in place.
  void Function([String? scrollToPostId])? _refreshCallback;
  bool _isSubscribed = false;
  bool _isClosed = false;
  bool _isSticky = false;
  bool _isDeleted = false;
  bool _showDeletedBanner = true;
  bool _showClosedBanner = true;
  bool _showStickyBanner = true;
  bool _showSubscribedBanner = true;
  String? _forumName;
  bool _canSubscribe = false;
  bool _canClose = false;
  bool _canSticky = false;
  bool _canDelete = false;
  bool _isRefreshing = false; // Add loading state for refresh
  String _actualTopicTitle = ''; // Track the actual topic title from server
  String? _threadUrl; // Track the thread URL from server

  // GlobalKey to reference the app bar state
  final GlobalKey<PostsPageAppBarState> _appBarKey = GlobalKey<PostsPageAppBarState>();

  @override
  void initState() {
    super.initState();
    // Initialize _forumId from widget.forumId if provided
    if (widget.forumId != null) {
      _forumId = widget.forumId;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _handleShare() async {
    try {
      final topicTitle = _actualTopicTitle.isNotEmpty ? _actualTopicTitle : widget.title;

      // Use the URL from API if available, otherwise fall back to manual construction
      String? urlToShare = _threadUrl;

      if (urlToShare == null || urlToShare.isEmpty) {
        // Fallback to manual URL construction for backward compatibility
        final forumUrl = widget.siteContext.site.pluginUrl;
        final forumType = widget.siteContext.ConfigData.forumType;
        final subForumId = _forumId ?? '';

        urlToShare = UrlUtils.getPostUrl(
          siteContext: widget.siteContext,
          postId: '',
          topicTitle: topicTitle,
          subForumId: subForumId,
          threadId: widget.topicId,
          forumUrl: forumUrl,
          forumType: UrlUtils.parseForumType(forumType),
        );
      }

      await UrlUtils.shareUrl(urlToShare);
    } catch (e) {
      // If sharing fails, show an error message
      if (mounted) {
        // Capture ScaffoldMessengerState to ensure dismiss button works correctly
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.failedToShareTopic(e.toString()),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
            ),
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
            behavior: SnackBarBehavior.floating,
            margin: DesignTokens.paddingS,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(DesignTokens.radiusS),
            ),
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: AppLocalizations.of(context)?.dismiss ?? 'Dismiss',
              textColor: Theme.of(context).colorScheme.onErrorContainer,
              onPressed: () {
                scaffoldMessenger.hideCurrentSnackBar();
              },
            ),
          ),
        );
      }
    }
  }

  void _handleViewOnWeb() async {
    if (_threadUrl == null || _threadUrl!.isEmpty) {
      return;
    }

    await UrlUtils.openUrl(_threadUrl!);
  }

  void _handleSubscribe() async {
    // Check if user is logged in before proceeding with subscription
    if (!widget.siteContext.isLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.pleaseLoginToSubscribe(_isSubscribed ? AppLocalizations.of(context)!.unsubscribeFrom : AppLocalizations.of(context)!.subscribeTo),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onInverseSurface,
                ),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.inverseSurface,
          margin: DesignTokens.paddingS,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusS),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    try {
      final subscriptionProxy = SiteProxyFactory.getSubscriptionProxy();

      if (_isSubscribed) {
        await subscriptionProxy.unsubscribeTopicAsync(widget.topicId);
      } else {
        await subscriptionProxy.subscribeTopicAsync(widget.topicId, 1); // mode 1 for subscribe
      }

      if (mounted) {
        setState(() {
          _isSubscribed = !_isSubscribed;
        });
      }
    } catch (e) {
      if (mounted) {
        // Capture ScaffoldMessengerState to ensure dismiss button works correctly
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        // Hide any existing SnackBar before showing a new one
        scaffoldMessenger.hideCurrentSnackBar();
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.failedToSubscribeToThread(_isSubscribed ? AppLocalizations.of(context)!.unsubscribeFrom : AppLocalizations.of(context)!.subscribeTo),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
            ),
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(DesignTokens.radiusS),
            ),
            margin: DesignTokens.paddingS,
            padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingL, vertical: DesignTokens.spacingL - DesignTokens.spacingXS),
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: AppLocalizations.of(context)?.dismiss ?? 'Dismiss',
              textColor: Theme.of(context).colorScheme.onErrorContainer,
              onPressed: () {
                scaffoldMessenger.hideCurrentSnackBar();
              },
            ),
          ),
        );
      }
    }
  }

  void _handleClose() async {
    final moderationProxy = SiteProxyFactory.getModerationProxy();
    try {
      if (_isClosed) {
        await moderationProxy.uncloseTopicAsync(widget.topicId);
      } else {
        await moderationProxy.closeTopicAsync(widget.topicId);
      }
      if (mounted) {
        setState(() {
          _isClosed = !_isClosed;
        });
        // Capture ScaffoldMessengerState to ensure dismiss button works correctly
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(
              _isClosed ? AppLocalizations.of(context)!.topicClosed : AppLocalizations.of(context)!.topicOpened,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onInverseSurface,
                  ),
            ),
            backgroundColor: Theme.of(context).colorScheme.inverseSurface,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(DesignTokens.radiusS),
            ),
            margin: DesignTokens.paddingS,
            padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingL, vertical: DesignTokens.spacingL - DesignTokens.spacingXS),
            duration: const Duration(seconds: 2),
            action: SnackBarAction(
              label: AppLocalizations.of(context)?.dismiss ?? 'Dismiss',
              textColor: Theme.of(context).colorScheme.inversePrimary,
              onPressed: () {
                scaffoldMessenger.hideCurrentSnackBar();
              },
            ),
          ),
        );
        _refreshCallback?.call();
      }
    } catch (e) {
      if (mounted) {
        // Capture ScaffoldMessengerState to ensure dismiss button works correctly
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(
              'Failed to ${_isClosed ? 'open' : 'close'} topic: $e',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
            ),
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(DesignTokens.radiusS),
            ),
            margin: DesignTokens.paddingS,
            padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingL, vertical: DesignTokens.spacingL - DesignTokens.spacingXS),
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: AppLocalizations.of(context)?.dismiss ?? 'Dismiss',
              textColor: Theme.of(context).colorScheme.onErrorContainer,
              onPressed: () {
                scaffoldMessenger.hideCurrentSnackBar();
              },
            ),
          ),
        );
      }
    }
  }

  void _handleSticky() async {
    final moderationProxy = SiteProxyFactory.getModerationProxy();
    try {
      if (_isSticky) {
        await moderationProxy.unstickTopicAsync(widget.topicId);
      } else {
        await moderationProxy.stickTopicAsync(widget.topicId);
      }
      if (mounted) {
        setState(() {
          _isSticky = !_isSticky;
        });
        // Capture ScaffoldMessengerState to ensure dismiss button works correctly
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(
              _isSticky ? AppLocalizations.of(context)!.topicStickied : AppLocalizations.of(context)!.topicUnstickied,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onInverseSurface,
                  ),
            ),
            backgroundColor: Theme.of(context).colorScheme.inverseSurface,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(DesignTokens.radiusS),
            ),
            margin: DesignTokens.paddingS,
            padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingL, vertical: DesignTokens.spacingL - DesignTokens.spacingXS),
            duration: const Duration(seconds: 2),
            action: SnackBarAction(
              label: AppLocalizations.of(context)?.dismiss ?? 'Dismiss',
              textColor: Theme.of(context).colorScheme.inversePrimary,
              onPressed: () {
                scaffoldMessenger.hideCurrentSnackBar();
              },
            ),
          ),
        );
        _refreshCallback?.call();
      }
    } catch (e) {
      if (mounted) {
        // Capture ScaffoldMessengerState to ensure dismiss button works correctly
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(
              'Failed to ${_isSticky ? 'unstick' : 'stick'} topic: $e',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
            ),
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(DesignTokens.radiusS),
            ),
            margin: DesignTokens.paddingS,
            padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingL, vertical: DesignTokens.spacingL - DesignTokens.spacingXS),
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: AppLocalizations.of(context)?.dismiss ?? 'Dismiss',
              textColor: Theme.of(context).colorScheme.onErrorContainer,
              onPressed: () {
                scaffoldMessenger.hideCurrentSnackBar();
              },
            ),
          ),
        );
      }
    }
  }

  void _handleDelete() async {
    final moderationProxy = SiteProxyFactory.getModerationProxy();

    // Handle undelete with simple confirmation (already handled in app bar)
    if (_isDeleted) {
      try {
        await moderationProxy.undeleteTopicAsync(widget.topicId, '');
        if (mounted) {
          setState(() {
            _isDeleted = false;
          });
          _refreshCallback?.call();
        }
      } catch (e) {
        // Error handling - no toast message
      }
      return;
    }

    // Handle delete with comprehensive dialog
    final result = await DeleteTopicDialog.show(
      context,
      topicTitle: widget.title,
    );

    if (result == null) {
      // User cancelled
      return;
    }

    final hardDelete = result['hardDelete'] as bool;
    final reason = result['reason'] as String? ?? '';
    final starterAlert = result['starterAlert'] as bool? ?? false;
    final starterAlertReason = result['starterAlertReason'] as String?;

    try {
      // Use extended method if available, otherwise fall back to basic method
      FCDeleteTopicResult deleteResult;
      if (moderationProxy is XenForoModerationProxy) {
        deleteResult = await moderationProxy.deleteTopicExtendedAsync(
          topicId: widget.topicId,
          hardDelete: hardDelete,
          reason: reason,
          starterAlert: starterAlert,
          starterAlertReason: starterAlertReason,
        );
      } else {
        // Fallback to basic method (map hardDelete to mode: 0 = soft, 1 = hard)
        final mode = hardDelete ? 1 : 0;
        deleteResult = await moderationProxy.deleteTopicAsync(widget.topicId, mode, reason);
      }

      if (!deleteResult.result) {
        throw Exception(deleteResult.resultText ?? 'Failed to delete topic');
      }

      if (mounted) {
        setState(() {
          _isDeleted = true;
        });
        _refreshCallback?.call();

        // If hard delete was successful, navigate back to previous screen
        if (hardDelete) {
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      // Error handling - no toast message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PostsPageAppBar(
        siteContext: widget.siteContext,
        key: _appBarKey,
        title: widget.title,
        onShare: _handleShare,
        onViewOnWeb: _threadUrl != null && _threadUrl!.isNotEmpty ? _handleViewOnWeb : null,
        onSubscribe: _handleSubscribe,
        onClose: _handleClose,
        onSticky: _handleSticky,
        onDelete: _handleDelete,
        onRefresh: () async {
          if (_refreshCallback != null && !_isRefreshing) {
            setState(() {
              _isRefreshing = true;
            });
            try {
              await Future.delayed(Duration.zero); // Allow UI to update
              _refreshCallback!();
              // Wait for the refresh to complete with a reasonable timeout
              await Future.delayed(const Duration(milliseconds: 800));
            } catch (e) {
              // Handle any errors during refresh
              if (mounted) {
                // Capture ScaffoldMessengerState to ensure dismiss button works correctly
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Text(
                      'Refresh failed: $e',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onErrorContainer,
                          ),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.errorContainer,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(DesignTokens.radiusS),
                    ),
                    margin: DesignTokens.paddingS,
                    padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingL, vertical: DesignTokens.spacingL - DesignTokens.spacingXS),
                    duration: const Duration(seconds: 4),
                    action: SnackBarAction(
                      label: AppLocalizations.of(context)?.dismiss ?? 'Dismiss',
                      textColor: Theme.of(context).colorScheme.onErrorContainer,
                      onPressed: () {
                        scaffoldMessenger.hideCurrentSnackBar();
                      },
                    ),
                  ),
                );
              }
            } finally {
              if (mounted) {
                setState(() {
                  _isRefreshing = false;
                });
              }
            }
          }
        },
        isSubscribed: _isSubscribed,
        showMarkRead: false,
        isClosed: _isClosed,
        isDeleted: _isDeleted,
        isSticky: _isSticky,
        canSubscribe: _canSubscribe,
        canClose: _canClose,
        canSticky: _canSticky,
        canDelete: _canDelete,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Status banners
              if ((_isDeleted && _showDeletedBanner) || (_isClosed && _showClosedBanner) || (_isSticky && _showStickyBanner) || (_isSubscribed && _showSubscribedBanner)) ...[
                // Deleted banner
                if (_isDeleted && _showDeletedBanner)
                  Container(
                    width: double.infinity,
                    padding: DesignTokens.paddingInput,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.errorContainer.withOpacity(DesignTokens.opacityHigh),
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).colorScheme.outlineVariant.withOpacity(DesignTokens.opacityMediumLow),
                          width: DesignTokens.borderWidthThin,
                        ),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.delete_rounded,
                          size: DesignTokens.iconSizeM,
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                        const SizedBox(width: DesignTokens.spacingM),
                        Expanded(
                          child: Text(
                            'This topic is deleted and hidden from other users',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onErrorContainer,
                                ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            size: DesignTokens.iconSizeM,
                            color: Theme.of(context).colorScheme.onErrorContainer,
                          ),
                          onPressed: () {
                            setState(() {
                              _showDeletedBanner = false;
                            });
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          splashRadius: DesignTokens.iconSizeM,
                        ),
                      ],
                    ),
                  ),
                // Closed banner
                if (_isClosed && _showClosedBanner)
                  Container(
                    width: double.infinity,
                    padding: DesignTokens.paddingInput,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiaryContainer.withOpacity(DesignTokens.opacityHigh),
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).colorScheme.outlineVariant.withOpacity(DesignTokens.opacityMediumLow),
                          width: DesignTokens.borderWidthThin,
                        ),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.lock_rounded,
                          size: DesignTokens.iconSizeM,
                          color: Theme.of(context).colorScheme.onTertiaryContainer,
                        ),
                        const SizedBox(width: DesignTokens.spacingM),
                        Expanded(
                          child: Text(
                            'This topic is closed and no longer accepting replies',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onTertiaryContainer,
                                ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            size: DesignTokens.iconSizeM,
                            color: Theme.of(context).colorScheme.onTertiaryContainer,
                          ),
                          onPressed: () {
                            setState(() {
                              _showClosedBanner = false;
                            });
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          splashRadius: DesignTokens.iconSizeM,
                        ),
                      ],
                    ),
                  ),
                // Sticky banner
                if (_isSticky && _showStickyBanner)
                  Container(
                    width: double.infinity,
                    padding: DesignTokens.paddingInput,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer.withOpacity(DesignTokens.opacityHigh),
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).colorScheme.outlineVariant.withOpacity(DesignTokens.opacityMediumLow),
                          width: DesignTokens.borderWidthThin,
                        ),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.push_pin_outlined,
                          size: DesignTokens.iconSizeM,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                        const SizedBox(width: DesignTokens.spacingM),
                        Expanded(
                          child: Text(
                            'This topic is pinned to the top of the forum',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                                ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            size: DesignTokens.iconSizeM,
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                          onPressed: () {
                            setState(() {
                              _showStickyBanner = false;
                            });
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          splashRadius: DesignTokens.iconSizeM,
                        ),
                      ],
                    ),
                  ),
                // Subscribed banner
                if (_isSubscribed && _showSubscribedBanner)
                  Container(
                    width: double.infinity,
                    padding: DesignTokens.paddingInput,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(DesignTokens.opacityHigh),
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).colorScheme.outlineVariant.withOpacity(DesignTokens.opacityMediumLow),
                          width: DesignTokens.borderWidthThin,
                        ),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.notifications_outlined,
                          size: DesignTokens.iconSizeM,
                          color: Theme.of(context).colorScheme.onSecondaryContainer,
                        ),
                        const SizedBox(width: DesignTokens.spacingM),
                        Expanded(
                          child: Text(
                            'You are subscribed to this topic',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                                ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            size: DesignTokens.iconSizeM,
                            color: Theme.of(context).colorScheme.onSecondaryContainer,
                          ),
                          onPressed: () {
                            setState(() {
                              _showSubscribedBanner = false;
                            });
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          splashRadius: DesignTokens.iconSizeM,
                        ),
                      ],
                    ),
                  ),
              ],
              // Posts list
              Expanded(
                child: PostsList(
                  siteContext: widget.siteContext,
                  topicId: widget.topicId,
                  topicTitle: widget.title,
                  mode: widget.mode,
                  anchorPostId: widget.anchorPostId,
                  gotoPage: widget.gotoPage,
                  isAnnouncement: widget.isAnnouncement,
                  forumId: _forumId,
                  onForumIdAvailable: (forumId) {
                    setState(() => _forumId = forumId);
                  },
                  onRefreshAvailable: (refreshCallback) {
                    setState(() {
                      _refreshCallback = refreshCallback;
                    });
                  },
                  onSubscriptionStatusChanged: (isSubscribed) {
                    setState(() {
                      _isSubscribed = isSubscribed;
                    });
                  },
                  onClosedStatusChanged: (isClosed) {
                    setState(() {
                      _isClosed = isClosed;
                    });
                  },
                  onStickyStatusChanged: (isSticky) {
                    setState(() {
                      _isSticky = isSticky;
                    });
                  },
                  onDeletedStatusChanged: (isDeleted) {
                    setState(() {
                      _isDeleted = isDeleted;
                    });
                  },
                  onCanSubscribeChanged: (canSubscribe) {
                    setState(() {
                      _canSubscribe = canSubscribe;
                    });
                  },
                  onCanCloseChanged: (canClose) {
                    setState(() {
                      _canClose = canClose;
                    });
                  },
                  onCanStickyChanged: (canSticky) {
                    setState(() {
                      _canSticky = canSticky;
                    });
                  },
                  onCanDeleteChanged: (canDelete) {
                    setState(() {
                      _canDelete = canDelete;
                    });
                  },
                  onTopicTitleLoaded: (topicTitle) {
                    if (topicTitle.isNotEmpty && topicTitle != _actualTopicTitle) {
                      setState(() {
                        _actualTopicTitle = topicTitle;
                      });
                      // Update the app bar title
                      _appBarKey.currentState?.updateTitle(topicTitle);
                    }
                  },
                  onThreadUrlAvailable: (threadUrl) {
                    setState(() {
                      _threadUrl = threadUrl;
                    });
                  },
                ),
              ),
            ],
          ),
          // Loading overlay when refreshing
          if (_isRefreshing) ...[
            ModalBarrier(
              dismissible: false,
              color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
            ),
            Center(
              child: Container(
                padding: DesignTokens.paddingScreen,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Refreshing...',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
