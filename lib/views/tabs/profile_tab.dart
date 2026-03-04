import 'package:flutter/material.dart';
import 'package:forumcopilot_flutter/views/widgets/resettable_widget.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/factory/site_proxy_factory.dart';
import 'package:forumcopilot_sdk/models/results/fc_user_result.dart';
import 'dart:async';
import 'package:forumcopilot_flutter/utils/error_dialog.dart';
import '../../theme/design_tokens.dart';
import '../../theme/style_builders.dart';

// Import the new component widgets
import '../widgets/profile_picture_section.dart';
import '../widgets/profile_info_section.dart';
import '../widgets/recent_posts_section.dart';
import '../widgets/not_signed_in_view.dart';
import '../settings_page.dart';
import 'package:forumcopilot_flutter/core/logging/app_logger.dart';
import 'package:get/get.dart';
import 'package:forumcopilot_flutter/controllers/login_controller.dart';
import '../login_page.dart';

class ProfileTab extends StatefulWidget {
  final SiteContext siteContext;
  final bool isActive;
  final bool autoShowLogin;
  const ProfileTab({
    super.key,
    required this.siteContext,
    required this.isActive,
    this.autoShowLogin = false,
  });

  @override
  ProfileTabState createState() => ProfileTabState();
}

class ProfileTabState extends FCStatefulWidget<ProfileTab> with FCTabStatefulWidget<ProfileTab> {
  bool _hasLoaded = false;
  FCUserInfoResult? _userInfo;
  List<FCUserReply>? _recentPosts;
  bool _isLoadingRecentPosts = false;
  bool _isLoadingMorePosts = false;
  String? _recentPostsError;
  int _totalPosts = 0;
  static const int _pageSize = 20;
  final ScrollController _scrollController = ScrollController();
  bool _didAttemptAutoLogin = false;

  @override
  void didUpdateWidget(covariant ProfileTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    _fetchUserInfo();
  }

  late final VoidCallback _authStateListener;

  // Track last logged login state to reduce debug noise
  bool? _lastLoggedIsLoggedIn;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo(); // Initial fetch
    _attemptAutoLoginIfNeeded();

    _authStateListener = () {
      final isLoggedInStatus = widget.siteContext.isLoggedIn;
      AppLogger.debug('👤 [PROFILE_TAB] Auth status changed: $isLoggedInStatus');
      if (isLoggedInStatus) {
        AppLogger.debug('👤 [PROFILE_TAB] User logged in - checking if user info needs to be fetched');
        // User logged in, fetch user info if not already loaded or if username changed
        final currentUsername = widget.siteContext.loginDataOutput?.user?.username;
        AppLogger.debug('👤 [PROFILE_TAB] Current username: $currentUsername');
        AppLogger.debug('👤 [PROFILE_TAB] Existing user info: ${_userInfo?.username}');

        if (_userInfo == null || (_userInfo?.username != null && _userInfo!.username != currentUsername)) {
          AppLogger.debug('👤 [PROFILE_TAB] Fetching user info due to auth status change');
          _hasLoaded = false; // Reset loaded state to force refresh
          _fetchUserInfo();
        } else {
          AppLogger.debug('👤 [PROFILE_TAB] User info already loaded and username matches');
        }
      } else {
        AppLogger.debug('👤 [PROFILE_TAB] User logged out - clearing user info');
        // User logged out, clear user info
        if (mounted) {
          setState(() {
            _userInfo = null;
            _hasLoaded = false;
          });
        }
      }
    };

    widget.siteContext.isLoggedInNotifier.addListener(_authStateListener);
    _scrollController.addListener(_onScroll);
  }

  void _attemptAutoLoginIfNeeded() {
    if (_didAttemptAutoLogin) {
      return;
    }
    _didAttemptAutoLogin = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted || widget.siteContext.isLoggedIn) {
        return;
      }
      if (!Get.isRegistered<LoginController>()) {
        Get.put(LoginController());
      }
      final loginController = Get.find<LoginController>();
      final loginResult = await loginController.attemptAutomaticLogin(widget.siteContext);
      if (!loginResult.success && loginResult.hadCredentials && Get.currentRoute != '/LoginPage') {
        await Get.to(() => LoginPage(siteContext: widget.siteContext));
      }
    });
  }

  @override
  void dispose() {
    widget.siteContext.isLoggedInNotifier.removeListener(_authStateListener);
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300 && !_isLoadingMorePosts && _hasMorePosts && _recentPosts != null && _recentPosts!.isNotEmpty) {
      final username = widget.siteContext.loginDataOutput?.user?.username;
      if (username != null) {
        _fetchRecentPosts(username, loadMore: true);
      }
    }
  }

  @override
  void resetTab() {
    _hasLoaded = false;
    clearError();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    AppLogger.debug('👤 [PROFILE_TAB] _fetchUserInfo() called');
    AppLogger.debug('👤 [PROFILE_TAB] isActive: ${widget.isActive}, hasLoaded: $_hasLoaded');
    AppLogger.debug('👤 [PROFILE_TAB] Current login state: ${widget.siteContext.isLoginInformationAvailable}');

    if (widget.isActive && !_hasLoaded) {
      setState(() {
        // Loading state handled by individual components
      });
      try {
        final username = widget.siteContext.loginDataOutput?.user?.username;
        AppLogger.debug('👤 [PROFILE_TAB] Username from context: $username');

        if (username == null) {
          AppLogger.debug('👤 [PROFILE_TAB] ❌ No username found - user not logged in');
          return;
        }

        AppLogger.debug('👤 [PROFILE_TAB] Making getUserInfo API call for username: $username');
        final proxy = SiteProxyFactory.getUserProxy();
        final info = await proxy.getUserInfoAsync(username, null);

        AppLogger.debug('👤 [PROFILE_TAB] ✅ getUserInfo API call completed successfully');
        // Debug logging for display text
        AppLogger.debug('=== Profile Tab Debug Info ===');
        AppLogger.debug('username: $username');
        AppLogger.debug('display_text: ${info.displayText} (length: ${info.displayText?.length})');
        AppLogger.debug('========================');

        if (mounted) {
          setState(() {
            _userInfo = info;
          });
          _fetchRecentPosts(username); // Fetch recent posts after user info
        }
        _hasLoaded = true;
        AppLogger.debug('👤 [PROFILE_TAB] ✅ User info loaded successfully');
      } catch (e) {
        AppLogger.debug('👤 [PROFILE_TAB] ❌ Error fetching user info: $e');
        showErrorDialogFromException(e);
        // Error handling is done by individual components
      }
    } else {
      AppLogger.debug('👤 [PROFILE_TAB] Skipping fetch - not active or already loaded');
    }
  }

  Future<void> _fetchRecentPosts(String username, {bool loadMore = false}) async {
    if (loadMore) {
      if (_isLoadingMorePosts || _recentPosts == null) return;
      setState(() {
        _isLoadingMorePosts = true;
        _recentPostsError = null;
      });
    } else {
      setState(() {
        _isLoadingRecentPosts = true;
        _recentPostsError = null;
        _recentPosts = null;
        _totalPosts = 0;
      });
    }
    try {
      final currentCount = _recentPosts?.length ?? 0;
      final startNum = loadMore ? currentCount : 0;
      final lastNum = startNum + _pageSize - 1;

      AppLogger.debug('Fetching recent posts for username: $username, startNum: $startNum, lastNum: $lastNum');
      final proxy = SiteProxyFactory.getUserProxy();
      final result = await proxy.getUserReplyPostAsync(startNum, lastNum, null, username, null);
      AppLogger.debug('Result from getUserReplyPostAsync: total: ${result.total}, posts count: ${result.posts.length}');
      if (mounted) {
        setState(() {
          if (loadMore) {
            _recentPosts = [...(_recentPosts ?? []), ...result.posts];
          } else {
            _recentPosts = result.posts;
            _totalPosts = result.total;
          }
          _isLoadingRecentPosts = false;
          _isLoadingMorePosts = false;
          // Update total if we got a new value
          if (result.total > _totalPosts) {
            _totalPosts = result.total;
          }
        });
      }
    } catch (e, stack) {
      AppLogger.debug('Error in _fetchRecentPosts: ' + e.toString());
      AppLogger.debug('Stack trace: $stack');
      final errorMessage = extractErrorMessage(e);
      showErrorDialogFromException(e);
      if (mounted) {
        setState(() {
          _recentPostsError = errorMessage;
          _isLoadingRecentPosts = false;
          _isLoadingMorePosts = false;
        });
      }
    }
  }

  bool get _hasMorePosts {
    if (_recentPosts == null) return false;
    return _recentPosts!.length < _totalPosts;
  }

  Widget _buildLoggedInContent() {
    final username = widget.siteContext.loginDataOutput?.user?.username ?? 'User';
    final imageUrl = widget.siteContext.loginDataOutput?.user?.iconUrl ?? '';

    return Builder(
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        final textTheme = Theme.of(context).textTheme;

        return ListView(
          controller: _scrollController,
          children: [
            // No forum header when user is logged in - focus on profile content
            Padding(
              padding: DesignTokens.paddingL,
              child: Column(
                children: [
                  // Profile Picture Section
                  ProfilePictureSection(
                    siteContext: widget.siteContext,
                    username: username,
                    imageUrl: imageUrl,
                    onProfileUpdated: () {
                      // Refresh user info and recent posts when profile is updated
                      _hasLoaded = false;
                      _fetchUserInfo();
                    },
                  ),

                  // Profile Information Section (includes Settings button after displayText)
                  if (_userInfo != null)
                    ProfileInfoSection(
                      userInfo: _userInfo!,
                      settingsButton: Padding(
                        padding: DesignTokens.paddingScreenHorizontal,
                        child: FilledButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForumSettingsPage(
                                  siteContext: widget.siteContext,
                                ),
                              ),
                            );
                          },
                          icon: Icon(Icons.settings, size: DesignTokens.iconSizeM),
                          label: Text(
                            'Settings',
                            style: textTheme.titleMedium?.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: DesignTokens.fontWeightBold,
                            ),
                          ),
                          style: StyleBuilders.extendedFilledButtonStyle(
                            colorScheme: colorScheme,
                          ),
                        ),
                      ),
                    ),

                  SizedBox(height: DesignTokens.spacingL),

                  // Recent Posts Section
                  RecentPostsSection(
                    siteContext: widget.siteContext,
                    recentPosts: _recentPosts,
                    isLoading: _isLoadingRecentPosts,
                    isLoadingMore: _isLoadingMorePosts,
                    hasMorePosts: _hasMorePosts,
                    remainingCount: _totalPosts - (_recentPosts?.length ?? 0),
                    error: _recentPostsError,
                    onLoadMore: () {
                      final username = widget.siteContext.loginDataOutput?.user?.username;
                      if (username != null) {
                        _fetchRecentPosts(username, loadMore: true);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Only log when login state changes to reduce noise
    final currentIsLoggedIn = widget.siteContext.isLoggedIn;
    if (_lastLoggedIsLoggedIn != currentIsLoggedIn) {
      AppLogger.debug('👤 [PROFILE_TAB] build() called - userIsLoggedIn: $currentIsLoggedIn');
      _lastLoggedIsLoggedIn = currentIsLoggedIn;
    }
    return ValueListenableBuilder<bool>(
      valueListenable: widget.siteContext.isLoggedInNotifier,
      builder: (context, isLoggedIn, child) {
        if (!isLoggedIn) {
          AppLogger.debug('👤 [PROFILE_TAB] Showing NotSignedInView - user not logged in');
          // Show only Not Signed In view when user is not logged in (no forum header)
          return NotSignedInView(
            siteContext: widget.siteContext,
            title: 'Sign in to view profile',
            message: 'You need to be signed in to view your profile.',
            icon: Icons.person_outline_rounded,
          );
        }

        AppLogger.debug('👤 [PROFILE_TAB] User is logged in - showing profile content');
        // Show profile content without forum header when user is logged in
        return _buildLoggedInContent();
      },
    );
  }
}
