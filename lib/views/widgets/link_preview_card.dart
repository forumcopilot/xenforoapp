import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'cached_redirect_image.dart';
import '../../utils/link_preview_cache.dart';
import '../../utils/url_utils.dart';
import '../../theme/design_tokens.dart';
import '../post_page.dart';
import '../lists/posts_list.dart';
import '../../controllers/site_manager.dart';
import '../../utils/forum_navigation.dart';
import '../../l10n/generated/app_localizations.dart';
import 'package:forumcopilot_flutter/core/logging/app_logger.dart';
import 'package:get/get.dart';
import 'package:forumcopilot_flutter/controllers/login_controller.dart';
import 'package:forumcopilot_flutter/views/login_page.dart';

class LinkPreviewCard extends StatefulWidget {
  final String url;
  final SiteContext siteContext;

  const LinkPreviewCard({
    super.key,
    required this.siteContext,
    required this.url,
  });

  @override
  State<LinkPreviewCard> createState() => _LinkPreviewCardState();
}

class _LinkPreviewCardState extends State<LinkPreviewCard> with AutomaticKeepAliveClientMixin {
  bool _isLoading = true;
  LinkPreviewData? _previewData;
  String? _error;
  bool _shouldShow = true;
  bool _imageLoadFailed = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    AppLogger.debug('Initializing LinkPreviewCard for URL: ${widget.url}');
    _fetchMetadata();
  }

  @override
  void didUpdateWidget(LinkPreviewCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only refetch if the URL actually changed
    if (oldWidget.url != widget.url && !_isLoading) {
      _fetchMetadata();
    }
  }

  Future<void> _fetchMetadata() async {
    try {
      AppLogger.debug('Fetching metadata for URL: ${widget.url}');

      // Use the cached link preview system
      final previewData = await LinkPreviewCache.fetchLinkPreview(widget.url);

      if (previewData != null) {
        AppLogger.debug('Retrieved preview data: title=${previewData.title}, domain=${previewData.domain}');

        if (mounted) {
          setState(() {
            _previewData = previewData;
            _isLoading = false;
            _shouldShow = true;
          });
        }
      } else {
        AppLogger.debug('No preview data available, hiding preview card');
        if (mounted) {
          setState(() {
            _shouldShow = false;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      AppLogger.debug('Error fetching metadata: $e');
      if (mounted) {
        setState(() {
          _error = 'Failed to load preview: ${e.toString()}';
          _isLoading = false;
          _shouldShow = false;
        });
      }
    }
  }

  Future<void> _navigateToForum(SiteContext siteContext, String forumId) async {
    try {
      AppLogger.debug('DEBUG: LinkPreview navigating to forum ID: $forumId');

      final forumManager = SiteManagerRegistry.getManager(siteContext);
      AppLogger.debug('DEBUG: LinkPreview got forum manager, getting forum by ID...');

      final targetForum = await forumManager.getForumById(forumId);
      AppLogger.debug('DEBUG: LinkPreview target forum result: ${targetForum != null ? 'Found' : 'Not found'}');

      if (targetForum != null && mounted) {
        AppLogger.debug('DEBUG: LinkPreview navigating to forum or link...');
        pushForumOrLinkForum(context, targetForum, siteContext);
        AppLogger.debug('DEBUG: LinkPreview navigation completed');
      } else {
        AppLogger.debug('DEBUG: LinkPreview forum not found or widget unmounted');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)?.forumNotFoundById(forumId) ?? 'Forum not found: $forumId'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      AppLogger.debug('DEBUG: LinkPreview error navigating to forum $forumId: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)?.failedToNavigateToForum ?? 'Failed to navigate to forum'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _launchUrl() async {
    final cleanUrl = widget.url.trim().replaceAll('"', '');

    AppLogger.debug('LinkPreviewCard URL tapped: $cleanUrl');

    // Get current forum info for intelligent URL handling
    final site = widget.siteContext.site;
    final forumUrl = site.pluginUrl;
    final forumType = widget.siteContext.ConfigData.forumType;

    await UrlUtils.handleUrlTapWithForumDetection(
      widget.siteContext,
      cleanUrl,
      context,
      forumUrl: forumUrl,
      forumType: forumType,
      onForumNavigation: (topicId, postId, forumId) {
        Future.microtask(() async {
          if (!mounted) return;
          if (!widget.siteContext.isLoggedIn) {
            if (!Get.isRegistered<LoginController>()) {
              Get.put(LoginController());
            }
            final loginController = Get.find<LoginController>();
            final loginResult = await loginController.attemptAutomaticLogin(widget.siteContext);
            if (!loginResult.success && loginResult.hadCredentials && Get.currentRoute != '/LoginPage') {
              await Get.to(() => LoginPage(siteContext: widget.siteContext));
            }
            if (!widget.siteContext.isLoggedIn) {
              AppLogger.debug('LinkPreviewCard: proceeding to thread as guest after login screen');
            }
          }
          // Handle forum navigation
          if (postId != null) {
            // Navigate to specific post
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostPage(
                  siteContext: widget.siteContext,
                  topicId: topicId,
                  title: '', // Could be enhanced with actual topic title
                  mode: PostsListMode.thread_by_post,
                  anchorPostId: postId,
                  forumId: forumId,
                ),
              ),
            );
          } else if (topicId.isNotEmpty) {
            // Navigate to topic
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostPage(
                  siteContext: widget.siteContext,
                  topicId: topicId,
                  title: '', // Could be enhanced with actual topic title
                  mode: PostsListMode.normal,
                  forumId: forumId,
                ),
              ),
            );
          } else if (forumId != null) {
            // Navigate to forum
            _navigateToForum(widget.siteContext, forumId);
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    if (!_shouldShow || _imageLoadFailed) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: DesignTokens.spacingXS),
        child: Center(
          child: SizedBox(
            width: DesignTokens.iconSizeS,
            height: DesignTokens.iconSizeS,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
            ),
          ),
        ),
      );
    }

    if (_error != null) {
      AppLogger.debug('Showing error state: $_error');
      return Container(
        margin: EdgeInsets.only(top: DesignTokens.spacingS),
        padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingM, vertical: DesignTokens.spacingS),
        decoration: BoxDecoration(
          color: colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(DesignTokens.radiusS),
          border: Border.all(
            color: colorScheme.outlineVariant.withOpacity(DesignTokens.opacityLow),
            width: DesignTokens.borderWidthThin,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.link,
              size: DesignTokens.iconSizeS,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: DesignTokens.spacingS),
            Expanded(
              child: Text(
                widget.url,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: EdgeInsets.only(top: DesignTokens.spacingS),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(DesignTokens.opacityLow),
        borderRadius: BorderRadius.circular(DesignTokens.radiusS),
        border: Border.all(
          color: colorScheme.outlineVariant.withOpacity(DesignTokens.opacityLow),
          width: DesignTokens.borderWidthThin,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _launchUrl(),
          borderRadius: BorderRadius.circular(DesignTokens.radiusS),
          child: Padding(
            padding: DesignTokens.paddingS,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_previewData?.imageUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusXS),
                    child: CachedRedirectImage(
                      imageUrl: _previewData!.imageUrl!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorWidget: (context, error, stackTrace) {
                        // Defer setState to avoid calling it during build
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) {
                            setState(() {
                              _imageLoadFailed = true;
                            });
                          }
                        });
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                const SizedBox(width: DesignTokens.spacingS),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_previewData?.title != null)
                        Text(
                          _previewData!.title!,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: DesignTokens.fontWeightMedium,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      if (_previewData?.description != null) ...[
                        SizedBox(height: 2),
                        Text(
                          _previewData!.description!,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant.withOpacity(0.8),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      SizedBox(height: DesignTokens.spacingXS),
                      Row(
                        children: [
                          Icon(
                            Icons.link,
                            size: DesignTokens.fontSizeXS,
                            color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                          ),
                          const SizedBox(width: DesignTokens.spacingXS),
                          Text(
                            _previewData?.domain ?? widget.url,
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.open_in_new_rounded,
                  size: DesignTokens.iconSizeM,
                  color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
