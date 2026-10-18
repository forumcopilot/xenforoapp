import 'package:flutter/material.dart';
import 'package:forumcopilot_flutter/views/widgets/resettable_widget.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/factory/site_proxy_factory.dart';
import 'package:forumcopilot_sdk/models/results/fc_user_result.dart';
import 'dart:async';
import 'package:forumcopilot_flutter/utils/error_dialog.dart';
import '../../theme/design_tokens.dart';

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
import '../../utils/app_navigation.dart';
import '../user_profile_page.dart';
import '../account/change_email_page.dart';
import '../account/change_password_page.dart';
import '../app_settings_page.dart';
import '../../l10n/generated/app_localizations.dart';

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
        await AppNavigation.pushGlobal(LoginPage(siteContext: widget.siteContext), name: '/LoginPage');
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
                      // View profile (tonal) and Settings (outlined), as the
                      // Discourse app's account hub; it was one English
                      // "Settings" pill.
                      settingsButton: Padding(
                        padding: DesignTokens.paddingScreenHorizontal,
                        child: Row(
                          children: [
                            Expanded(
                              child: FilledButton.tonal(
                                onPressed: () => AppNavigation.push<void>(
                                  context,
                                  UserProfilePage(siteContext: widget.siteContext, userName: username),
                                ),
                                child: Text(AppLocalizations.of(context).viewProfile),
                              ),
                            ),
                            const SizedBox(width: DesignTokens.spacingS),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => AppNavigation.push<void>(
                                  context,
                                  ForumSettingsPage(siteContext: widget.siteContext),
                                ),
                                child: Text(AppLocalizations.of(context).settings),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  SizedBox(height: DesignTokens.spacingL),
                  _AccountSection(siteContext: widget.siteContext),
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
            title: AppLocalizations.of(context).signInToViewProfile,
            message: AppLocalizations.of(context).youNeedToBeSignedInToViewYourProfile,
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

/// The account's own destinations: change email and password (the SDK and
/// add-on supported both; nothing used them), app settings, and Sign out as
/// a confirmed, error-coloured row (it was a bare icon in the app bar).
class _AccountSection extends StatelessWidget {
  const _AccountSection({required this.siteContext});

  final SiteContext siteContext;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    Widget row(IconData icon, String label, VoidCallback onTap, {Color? color}) => ListTile(
          leading: Icon(icon, color: color ?? colorScheme.onSurfaceVariant),
          title: Text(label, style: textTheme.bodyLarge?.copyWith(color: color ?? colorScheme.onSurface)),
          onTap: onTap,
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(DesignTokens.spacingL, DesignTokens.spacingS, DesignTokens.spacingL, DesignTokens.spacingXS),
          child: Semantics(
            header: true,
            child: Text(
              l10n.account,
              style: textTheme.titleSmall?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ),
        ),
        row(Icons.alternate_email_rounded, l10n.changeEmail,
            () => AppNavigation.pushForm<void>(context, ChangeEmailPage(siteContext: siteContext))),
        row(Icons.password_rounded, l10n.changePassword,
            () => AppNavigation.pushForm<void>(context, ChangePasswordPage(siteContext: siteContext))),
        row(Icons.tune_rounded, l10n.appSettings,
            () => AppNavigation.push<void>(context, const AppSettingsPage())),
        row(Icons.logout_rounded, l10n.signOut, () => _confirmSignOut(context), color: colorScheme.error),
      ],
    );
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: Text(l10n.signOut),
        content: Text(l10n.areYouSureYouWantToLogout),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialog).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialog).pop(true),
            style: TextButton.styleFrom(foregroundColor: colorScheme.error),
            child: Text(l10n.signOut),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final loginController = Get.isRegistered<LoginController>() ? Get.find<LoginController>() : Get.put(LoginController());
    await loginController.handleLogout(siteContext);
  }
}
