import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import 'package:forumcopilot_flutter/services/site_proxy_service.dart';
import 'package:forumcopilot_flutter/views/widgets/user_avatar.dart';
import 'package:forumcopilot_flutter/views/widgets/user_replied_posts.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/models/entities/fc_custom_field.dart';
import 'package:forumcopilot_sdk/models/results/fc_user_result.dart';
import 'private_messaging/traditional/pages/new_traditional_pm_page.dart';
import 'package:intl/intl.dart';
import 'package:forumcopilot_flutter/views/widgets/full_screen_image_viewer.dart';
import 'private_messaging/conversation/pages/new_conversation_page.dart';
import 'package:forumcopilot_flutter/utils/error_dialog.dart';
import 'package:forumcopilot_flutter/utils/avatar_cache_utils.dart';
import 'package:forumcopilot_flutter/utils/signature_processor.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'package:forumcopilot_flutter/controllers/login_controller.dart';
import 'login_page.dart';
import '../theme/design_tokens.dart';
import '../theme/style_builders.dart';
import 'package:forumcopilot_flutter/core/logging/app_logger.dart';
import '../utils/snackbar_helper.dart';
import '../utils/app_navigation.dart';

class UserProfilePage extends StatefulWidget {
  final SiteContext siteContext;
  final String? userId;
  final String? userName;
  final String? profilePictureUrl;

  const UserProfilePage({
    super.key,
    required this.siteContext,
    this.userId,
    this.userName,
    this.profilePictureUrl,
  });

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  FCUserInfoResult? _userInfo;
  bool _isLoading = true;
  String? _error;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _userRepliedPostsKey = GlobalKey();
  bool _didAttemptAutoLogin = false;
  bool _followBusy = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _attemptAutoLoginAndLoad();
  }

  void _attemptAutoLoginAndLoad() {
    if (_didAttemptAutoLogin) {
      return;
    }
    _didAttemptAutoLogin = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) {
        return;
      }
      if (!widget.siteContext.isLoggedIn) {
        if (!Get.isRegistered<LoginController>()) {
          Get.put(LoginController());
        }
        final loginController = Get.find<LoginController>();
        final loginResult = await loginController.attemptAutomaticLogin(widget.siteContext);
        if (!loginResult.success && loginResult.hadCredentials && Get.currentRoute != '/LoginPage') {
          await AppNavigation.pushGlobal(LoginPage(siteContext: widget.siteContext), name: '/LoginPage');
        }
      }
      if (!mounted) {
        return;
      }
      _fetchUserInfo();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.hasClients && _scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300) {
      // Trigger load more via the widget's state
      final state = _userRepliedPostsKey.currentState;
      if (state is State) {
        // Use dynamic call to access checkAndLoadMore method
        (state as dynamic).checkAndLoadMore?.call(
              _scrollController.position.pixels,
              _scrollController.position.maxScrollExtent,
            );
      }
    }
  }

  /// Follows or unfollows this member. The button was hidden with a TODO;
  /// the add-on has supported follow and unfollow all along.
  Future<void> _toggleFollow() async {
    final info = _userInfo;
    if (info == null || _followBusy) return;
    setState(() => _followBusy = true);
    final wasFollowing = info.isFollowing;
    String? failure;
    try {
      final social = SiteProxyService.getSocialProxy();
      final response = wasFollowing ? await social.unfollowAsync(info.id) : await social.followAsync(info.id);
      if (response.result) {
        info.isFollowing = !wasFollowing;
      } else {
        failure = response.resultText ?? '';
      }
    } catch (e) {
      AppLogger.debug('Follow toggle failed: $e');
      failure = '';
    }
    if (!mounted) return;
    setState(() => _followBusy = false);
    if (failure != null) {
      final colorScheme = Theme.of(context).colorScheme;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(
            failure.isNotEmpty ? failure : AppLocalizations.of(context).somethingWentWrong,
            style: TextStyle(color: colorScheme.onErrorContainer),
          ),
          backgroundColor: colorScheme.errorContainer,
          behavior: SnackBarBehavior.floating,
          showCloseIcon: true,
          closeIconColor: colorScheme.onErrorContainer,
        ));
    }
  }

  Future<void> _fetchUserInfo() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final proxy = SiteProxyService.getUserProxy();
      final info = await proxy.getUserInfoAsync(widget.userName, widget.userId);

      // Debug print statements for user info fields

      setState(() {
        _userInfo = info;
        _isLoading = false;
      });
    } catch (e) {
      AppLogger.debug('Error fetching user info: $e');
      if (!mounted) return;
      showErrorDialog(AppLocalizations.of(context).failedToLoadUserInfo('$e'));
      setState(() {
        _error = AppLocalizations.of(context).failedToLoadUserInfo('$e');
        _isLoading = false;
      });
    }
  }

  /// Refresh the entire user profile page by resetting state and fetching fresh data
  Future<void> _refreshProfile() async {
    AppLogger.debug('Refreshing user profile page');
    setState(() {
      _userInfo = null;
      _isLoading = true;
      _error = null;
    });
    await _fetchUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: DesignTokens.elevationNone,
        surfaceTintColor: colorScheme.surfaceTint,
        iconTheme: IconThemeData(
          color: colorScheme.onSurface,
          size: DesignTokens.iconSizeL,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: _isLoading
            ? Text(AppLocalizations.of(context).loading)
            : _userInfo != null
                ? (widget.siteContext.loginDataOutput != null && widget.siteContext.loginDataOutput?.user?.id != _userInfo!.id)
                    ? const SizedBox.shrink() // Hide title when viewing another user's profile
                    : Text(
                        _userInfo!.username,
                        style: textTheme.titleLarge?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: DesignTokens.fontWeightBold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )
                : Text(AppLocalizations.of(context).userProfile),
        actions: [
          if (_userInfo != null && widget.siteContext.loginDataOutput != null && widget.siteContext.loginDataOutput?.user?.id != _userInfo!.id)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                switch (value) {
                  case 'report':
                    _handleReportUser(context);
                    break;
                  case 'ban':
                    if (_userInfo!.isBanned) {
                      _handleUnbanUser(context);
                    } else {
                      _handleBanUser(context);
                    }
                    break;
                  case 'spamCleaner':
                    _handleSpamCleanUser(context);
                    break;
                }
              },
              itemBuilder: (BuildContext context) => [
                // Report User - only show if user can be reported
                if (_userInfo!.canBeReported == true)
                  PopupMenuItem<String>(
                    value: 'report',
                    child: Row(
                      children: [
                        Icon(Icons.flag_outlined, color: colorScheme.error),
                        const SizedBox(width: DesignTokens.spacingM),
                        Text(
                          AppLocalizations.of(context).reportUser,
                          style: textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                // Ban/Unban User - only show if user has permission
                if (_userInfo!.canBan)
                  PopupMenuItem<String>(
                    value: 'ban',
                    child: Row(
                      children: [
                        Icon(
                          _userInfo!.isBanned ? Icons.block_outlined : Icons.block,
                          color: colorScheme.error,
                        ),
                        const SizedBox(width: DesignTokens.spacingM),
                        Text(
                          _userInfo!.isBanned ? AppLocalizations.of(context).unbanUser : AppLocalizations.of(context).banUser,
                          style: textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                // Spam Cleaner - only show if user has permission
                if (_userInfo!.canSpamClean)
                  PopupMenuItem<String>(
                    value: 'spamCleaner',
                    child: Row(
                      children: [
                        Icon(Icons.cleaning_services, color: colorScheme.error),
                        const SizedBox(width: DesignTokens.spacingM),
                        Text(
                          AppLocalizations.of(context).spamCleaner,
                          style: textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Padding(
                    padding: DesignTokens.paddingScreen,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          size: 64,
                          color: colorScheme.error,
                        ),
                        const SizedBox(height: DesignTokens.spacingL),
                        Text(
                          AppLocalizations.of(context).unableToLoadProfile,
                          style: textTheme.titleLarge?.copyWith(
                            color: colorScheme.error,
                            fontWeight: DesignTokens.fontWeightBold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: DesignTokens.spacingS),
                        Text(
                          _error!,
                          style: textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: DesignTokens.spacingXL),
                        FilledButton.icon(
                          onPressed: _fetchUserInfo,
                          icon: const Icon(Icons.refresh_rounded),
                          label: Text(AppLocalizations.of(context).tryAgain),
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
                        ),
                      ],
                    ),
                  ),
                )
              : _userInfo == null
                  ? Center(child: Text(AppLocalizations.of(context).userInformationNotAvailable))
                  : RefreshIndicator(
                      onRefresh: _refreshProfile,
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(), // Enable pull-to-refresh even when content doesn't scroll
                        child: Column(
                          children: [
                            SizedBox(height: DesignTokens.spacingL),
                            // Profile Picture with Online Indicator and tap-to-view
                            Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    final imageUrl = (_userInfo!.iconUrl != null && _userInfo!.iconUrl!.isNotEmpty)
                                        ? _userInfo!.iconUrl!
                                        : (widget.profilePictureUrl != null && widget.profilePictureUrl!.isNotEmpty ? widget.profilePictureUrl! : null);
                                    if (imageUrl != null && imageUrl.isNotEmpty) {
                                      AppNavigation.push(context, FullScreenImageViewer(
                                            imageUrls: [imageUrl],
                                            initialIndex: 0,
                                            heroTag: 'profile_picture_${_userInfo!.username}',
                                          ));
                                    }
                                  },
                                  child: UserAvatar(
                                    username: _userInfo!.username,
                                    iconUrl: (_userInfo!.iconUrl != null && _userInfo!.iconUrl!.isNotEmpty) ? _userInfo!.iconUrl! : widget.profilePictureUrl,
                                    radius: 50,
                                    showOnlineIndicator: true,
                                    isOnline: _userInfo!.isOnline,
                                    cacheKey: () {
                                      final avatarUrl = (_userInfo!.iconUrl != null && _userInfo!.iconUrl!.isNotEmpty) ? _userInfo!.iconUrl! : widget.profilePictureUrl;
                                      if (avatarUrl != null && avatarUrl.isNotEmpty) {
                                        return AvatarCacheUtils.generateAvatarCacheKey(
                                          userId: widget.userId ?? _userInfo!.id,
                                          username: _userInfo!.username,
                                          avatarUrl: avatarUrl,
                                        );
                                      }
                                      return null;
                                    }(),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: DesignTokens.spacingM),
                            // Username with Banned Badge
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _userInfo!.username,
                                  style: textTheme.titleLarge?.copyWith(
                                    color: colorScheme.onSurface,
                                    fontWeight: DesignTokens.fontWeightBold,
                                  ),
                                ),
                                if (_userInfo!.isBanned) ...[
                                  SizedBox(width: DesignTokens.spacingS),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: DesignTokens.spacingM - DesignTokens.spacingXS,
                                      vertical: DesignTokens.spacingXS / 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: colorScheme.errorContainer.withValues(alpha: DesignTokens.opacityHigh),
                                      borderRadius: BorderRadius.circular(DesignTokens.radiusS),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.block,
                                          size: DesignTokens.iconSizeXS,
                                          color: colorScheme.onErrorContainer,
                                        ),
                                        SizedBox(width: DesignTokens.spacingXS),
                                        Text(
                                          AppLocalizations.of(context).banned,
                                          style: StyleBuilders.badgeTextStyle(
                                            colorScheme: colorScheme,
                                            textTheme: textTheme,
                                            color: colorScheme.onErrorContainer,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            if (_userInfo!.displayText != null && _userInfo!.displayText!.isNotEmpty) ...[
                              SizedBox(height: DesignTokens.spacingXS),
                              Padding(
                                padding: DesignTokens.paddingScreenHorizontal,
                                child: Text(
                                  _userInfo!.displayText!,
                                  style: textTheme.bodyLarge?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                            SizedBox(height: DesignTokens.spacingM),
                            // Follow and Send Message buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (widget.siteContext.loginDataOutput?.user?.id != _userInfo!.id) ...[
                                  if (_userInfo!.isFollowing || _userInfo!.acceptsFollowers)
                                    _userInfo!.isFollowing
                                        ? OutlinedButton.icon(
                                            onPressed: _followBusy ? null : _toggleFollow,
                                            icon: const Icon(Icons.person_remove_outlined),
                                            label: Text(AppLocalizations.of(context).unfollow),
                                          )
                                        : FilledButton.tonalIcon(
                                            onPressed: _followBusy ? null : _toggleFollow,
                                            icon: const Icon(Icons.person_add_outlined),
                                            label: Text(AppLocalizations.of(context).follow),
                                          ),
                                  if (_userInfo!.acceptsPM) ...[
                                    SizedBox(width: DesignTokens.spacingM),
                                    FilledButton.icon(
                                      onPressed: () {
                                        final conversationSupported = widget.siteContext.configDataOutput?.conversation ?? false;
                                        if (conversationSupported) {
                                          Navigator.push(
                                            context,
                                            FormPageRoute(
                                              builder: (context) => NewConversationPage(
                                                siteContext: widget.siteContext,
                                                initialRecipient: _userInfo!.username,
                                                initialRecipientIconUrl: (_userInfo!.iconUrl != null && _userInfo!.iconUrl!.isNotEmpty) ? _userInfo!.iconUrl! : (widget.profilePictureUrl ?? null),
                                              ),
                                            ),
                                          );
                                        } else {
                                          AppNavigation.push(context, NewTraditionalPMPage(
                                                siteContext: widget.siteContext,
                                                initialRecipient: _userInfo!.username,
                                                initialRecipientIconUrl: (_userInfo!.iconUrl != null && _userInfo!.iconUrl!.isNotEmpty) ? _userInfo!.iconUrl! : (widget.profilePictureUrl ?? null),
                                              ));
                                        }
                                      },
                                      icon: Icon(Icons.message, size: DesignTokens.iconSizeM),
                                      label: Text(
                                        AppLocalizations.of(context).sendMessage,
                                        style: textTheme.titleMedium?.copyWith(
                                          color: colorScheme.onPrimary,
                                          fontWeight: DesignTokens.fontWeightBold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ],
                            ),
                            const SizedBox(height: DesignTokens.spacingL),
                            // Combined Core and Additional Information Section
                            Card(
                              margin: EdgeInsets.symmetric(
                                horizontal: DesignTokens.spacingL,
                                vertical: DesignTokens.spacingXS,
                              ),
                              elevation: DesignTokens.elevationNone,
                              color: colorScheme.surfaceContainerLowest,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                                side: BorderSide(
                                  color: colorScheme.outlineVariant.withValues(alpha: DesignTokens.opacityLow),
                                  width: DesignTokens.borderWidthThin,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Core Information
                                  if (_userInfo!.registrationTime != null)
                                    _buildInfoTile(
                                      context,
                                      icon: Icons.calendar_today,
                                      title: AppLocalizations.of(context).memberSince,
                                      subtitle: DateFormat.yMMMMd().format(_userInfo!.registrationTime as DateTime),
                                    ),
                                  if (_userInfo!.customFieldsList != null)
                                    ...(() {
                                      final birthdayField =
                                          _userInfo!.customFieldsList!.where((f) => f.name.toLowerCase() == 'birthday' && f.value.trim().isNotEmpty && f.value != '0').cast<FCCustomField?>().toList();
                                      if (birthdayField.isEmpty) return <Widget>[];
                                      final field = birthdayField.first;
                                      DateTime? birthdayDate;
                                      try {
                                        birthdayDate = DateFormat('d MMM yyyy').parse(field!.value);
                                      } catch (_) {}
                                      final now = DateTime.now();
                                      if (birthdayDate == null || birthdayDate.year < 1900 || birthdayDate.isAfter(now)) {
                                        return <Widget>[];
                                      }
                                      final locale = Localizations.localeOf(context).toString();
                                      final formatted = DateFormat.yMMMMd(locale).format(birthdayDate);
                                      return [
                                        _buildInfoTile(
                                          context,
                                          icon: Icons.cake,
                                          title: AppLocalizations.of(context).birthday,
                                          subtitle: formatted,
                                        ),
                                      ];
                                    })(),
                                  if (_userInfo!.lastActivityTime != null)
                                    _buildInfoTile(
                                      context,
                                      icon: Icons.access_time,
                                      title: AppLocalizations.of(context).lastActivity,
                                      subtitle: DateFormat.yMMMd(Localizations.localeOf(context).toString()).add_jm().format(_userInfo!.lastActivityTime!.toLocal()),
                                    ),
                                  if (_userInfo!.postCount != 0)
                                    _buildInfoTile(
                                      context,
                                      icon: Icons.post_add,
                                      title: AppLocalizations.of(context).posts,
                                      subtitle: NumberFormat.decimalPattern(Localizations.localeOf(context).toString()).format(_userInfo!.postCount),
                                    ),
                                  if (_userInfo!.customFieldsList != null)
                                    ...(() {
                                      final likesReceivedField = _userInfo!.customFieldsList!
                                          .where((f) => (f.name.toLowerCase() == 'likes' || f.name.toLowerCase() == 'likes_received') && f.value.trim().isNotEmpty && f.value != '0')
                                          .cast<FCCustomField?>()
                                          .toList();
                                      final likesGivenField =
                                          _userInfo!.customFieldsList!.where((f) => f.name.toLowerCase() == 'liked' && f.value.trim().isNotEmpty && f.value != '0').cast<FCCustomField?>().toList();
                                      final List<Widget> fields = [];
                                      if (likesReceivedField.isNotEmpty) {
                                        fields.add(_buildInfoTile(
                                          context,
                                          icon: Icons.thumb_up,
                                          title: AppLocalizations.of(context).likesReceived,
                                          subtitle: NumberFormat.decimalPattern(Localizations.localeOf(context).toString()).format(int.tryParse(likesReceivedField.first!.value) ?? 0),
                                        ));
                                      }
                                      if (likesGivenField.isNotEmpty) {
                                        fields.add(_buildInfoTile(
                                          context,
                                          icon: Icons.thumb_up_outlined,
                                          title: AppLocalizations.of(context).likesGiven,
                                          subtitle: NumberFormat.decimalPattern(Localizations.localeOf(context).toString()).format(int.tryParse(likesGivenField.first!.value) ?? 0),
                                        ));
                                      }
                                      return fields;
                                    })(),
                                  if (_userInfo!.followingCount != 0)
                                    _buildInfoTile(
                                      context,
                                      icon: Icons.people_outline,
                                      title: AppLocalizations.of(context).following,
                                      subtitle: _userInfo!.followingCount.toString(),
                                    ),
                                  if (_userInfo!.follower != null && _userInfo!.follower != 0)
                                    _buildInfoTile(
                                      context,
                                      icon: Icons.people,
                                      title: AppLocalizations.of(context).followers,
                                      subtitle: _userInfo!.follower.toString(),
                                    ),
                                  // About field (from direct API field)
                                  if (_userInfo!.bio != null && _userInfo!.bio!.isNotEmpty)
                                    _buildInfoTile(
                                      context,
                                      icon: Icons.person_outline,
                                      title: AppLocalizations.of(context).about,
                                      subtitle: _userInfo!.bio!,
                                    ),
                                  // Location field (from direct API field)
                                  if (_userInfo!.location != null && _userInfo!.location!.isNotEmpty)
                                    _buildInfoTile(
                                      context,
                                      icon: Icons.location_on,
                                      title: AppLocalizations.of(context).location,
                                      subtitle: _userInfo!.location!,
                                    ),
                                  // Website field (clickable)
                                  if (_userInfo!.website != null && _userInfo!.website!.isNotEmpty)
                                    _buildInfoTile(
                                      context,
                                      icon: Icons.language,
                                      title: AppLocalizations.of(context).website,
                                      subtitle: _userInfo!.website!,
                                      onTap: () async {
                                        final url = _userInfo!.website!;
                                        final uri = Uri.parse(url.startsWith('http://') || url.startsWith('https://') ? url : 'https://$url');
                                        if (await canLaunchUrl(uri)) {
                                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                                        }
                                      },
                                    ),
                                  // Signature field (from direct API field)
                                  if (_userInfo!.signature != null && _userInfo!.signature!.isNotEmpty)
                                    _buildSignatureTile(
                                      context,
                                      icon: Icons.edit_note,
                                      title: AppLocalizations.of(context).signature,
                                      signature: _userInfo!.signature!,
                                    ),
                                  // Location field from customFields (fallback for older data)
                                  if (_userInfo!.location == null && _userInfo!.customFieldsList != null)
                                    ...(() {
                                      final locationField =
                                          _userInfo!.customFieldsList!.where((f) => f.name.toLowerCase().contains('location') && f.value.trim().isNotEmpty && f.value != '0').toList();
                                      if (locationField.isEmpty) return <Widget>[];
                                      return [
                                        _buildInfoTile(
                                          context,
                                          icon: Icons.location_on,
                                          title: locationField.first.name,
                                          subtitle: locationField.first.value,
                                        ),
                                      ];
                                    })(),
                                  // Signature field from customFields (fallback for older data)
                                  if (_userInfo!.signature == null && _userInfo!.customFieldsList != null)
                                    ...(() {
                                      final signatureField = _userInfo!.customFieldsList!.where((f) => f.name.toLowerCase() == 'signature' && f.value.trim().isNotEmpty && f.value != '0').toList();
                                      if (signatureField.isEmpty) return <Widget>[];
                                      return [
                                        _buildSignatureTile(
                                          context,
                                          icon: Icons.edit_note,
                                          title: AppLocalizations.of(context).signature,
                                          signature: signatureField.first.value,
                                        ),
                                      ];
                                    })(),
                                  // Additional Information Section (Expandable)
                                  if (_userInfo!.customFieldsList != null &&
                                      _userInfo!.customFieldsList!.isNotEmpty &&
                                      _userInfo!.customFieldsList!.any((f) =>
                                          f.value.trim().isNotEmpty &&
                                          f.value != "0" &&
                                          f.name.toLowerCase() != 'birthday' &&
                                          f.name.toLowerCase() != 'likes' &&
                                          f.name.toLowerCase() != 'liked' &&
                                          f.name.toLowerCase() != 'signature' &&
                                          !f.name.toLowerCase().contains('location')))
                                    Theme(
                                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                      child: ExpansionTile(
                                        initiallyExpanded: false,
                                        backgroundColor: Colors.transparent,
                                        collapsedBackgroundColor: Colors.transparent,
                                        title: Text(
                                          AppLocalizations.of(context).showMore,
                                          style: textTheme.titleSmall?.copyWith(
                                            color: colorScheme.primary,
                                            fontWeight: DesignTokens.fontWeightMedium,
                                          ),
                                        ),
                                        children: [
                                          ..._userInfo!.customFieldsList!
                                              .where((f) =>
                                                  f.value.trim().isNotEmpty &&
                                                  f.value != "0" &&
                                                  f.name.toLowerCase() != 'likes' &&
                                                  f.name.toLowerCase() != 'liked' &&
                                                  f.name.toLowerCase() != 'signature' &&
                                                  !f.name.toLowerCase().contains('location'))
                                              .map((f) => _buildInfoTile(
                                                    context,
                                                    icon: Icons.info_outline,
                                                    title: f.name,
                                                    subtitle: f.value,
                                                  ))
                                              .toList(),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            SizedBox(height: DesignTokens.spacingS),
                            // Add UserRepliedPosts widget
                            UserRepliedPosts(
                              key: _userRepliedPostsKey,
                              siteContext: widget.siteContext,
                              userId: _userInfo!.id,
                              userName: _userInfo!.username,
                            ),
                            SizedBox(height: DesignTokens.spacingL),
                          ],
                        ),
                      ),
                    ),
    );
  }

  Widget _buildInfoTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingL,
        vertical: DesignTokens.spacingXS,
      ),
      leading: Icon(
        icon,
        size: DesignTokens.iconSizeM,
        color: colorScheme.primary,
      ),
      title: Text(
        title,
        style: textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: textTheme.bodyMedium?.copyWith(
          color: onTap != null ? colorScheme.primary : colorScheme.onSurface,
          decoration: onTap != null ? TextDecoration.underline : null,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildSignatureTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String signature,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final spans = SignatureProcessor.processSignature(signature, context);

    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingL,
        vertical: DesignTokens.spacingXS,
      ),
      leading: Icon(
        icon,
        size: DesignTokens.iconSizeM,
        color: colorScheme.primary,
      ),
      title: Text(
        title,
        style: textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      subtitle: RichText(
        text: TextSpan(children: spans),
      ),
    );
  }

  Future<void> _handleReportUser(BuildContext context) async {
    if (_userInfo == null) return;

    AppLogger.debug('Handling report of user: ${_userInfo!.id}');

    // Common report reasons
    final l10n = AppLocalizations.of(context);
    final reportReasons = [
      l10n.spamOrAdvertising,
      l10n.harassmentOrBullying,
      l10n.inappropriateContent,
      l10n.impersonationOrFakeAccount,
      l10n.otherPleaseSpecify,
    ];

    String? selectedReason;
    final TextEditingController customReasonController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<String?>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final colorScheme = Theme.of(context).colorScheme;
            final textTheme = Theme.of(context).textTheme;

            return AlertDialog(
              title: Text(
                AppLocalizations.of(context).reportUser,
                style: textTheme.titleLarge?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context).pleaseSelectReasonForReportingUser,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: DesignTokens.spacingL),
                      RadioGroup<String>(
                        groupValue: selectedReason,
                        onChanged: (value) {
                          setState(() {
                            selectedReason = value;
                          });
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: reportReasons.map((reason) {
                            return RadioListTile<String>(
                              title: Text(
                                reason,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              value: reason,
                              contentPadding: EdgeInsets.zero,
                            );
                          }).toList(),
                        ),
                      ),
                      if (selectedReason == l10n.otherPleaseSpecify) ...[
                        const SizedBox(height: DesignTokens.spacingM),
                        TextFormField(
                          controller: customReasonController,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context).pleaseSpecifyReason,
                            hintText: AppLocalizations.of(context).enterReasonForReportingUser,
                            border: const OutlineInputBorder(),
                          ),
                          maxLines: 3,
                          validator: (value) {
                            if (selectedReason == l10n.otherPleaseSpecify && (value == null || value.trim().isEmpty)) {
                              return AppLocalizations.of(context).pleaseSpecifyReason;
                            }
                            return null;
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(null),
                  child: Text(
                    AppLocalizations.of(context).cancel,
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                  ),
                ),
                FilledButton(
                  onPressed: () {
                    if (selectedReason == null) {
                      SnackbarHelper.showError(context, AppLocalizations.of(context).pleaseSelectReason);
                      return;
                    }

                    if (formKey.currentState?.validate() ?? false) {
                      final reason = selectedReason == l10n.otherPleaseSpecify ? customReasonController.text.trim() : selectedReason!;
                      Navigator.of(context).pop(reason);
                    }
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.error,
                    foregroundColor: colorScheme.onError,
                  ),
                  child: Text(AppLocalizations.of(context).submitReport),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null && context.mounted) {
      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: DesignTokens.iconSizeM,
                height: DesignTokens.iconSizeM,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.onInverseSurface,
                  ),
                ),
              ),
              const SizedBox(width: DesignTokens.spacingM),
              Text(
                AppLocalizations.of(context).submittingReport,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onInverseSurface,
                    ),
              ),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.inverseSurface,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusS),
          ),
          margin: DesignTokens.paddingS,
          padding: EdgeInsets.symmetric(
            horizontal: DesignTokens.spacingL,
            vertical: DesignTokens.spacingM,
          ),
          duration: const Duration(seconds: 30),
        ),
      );

      try {
        AppLogger.debug('Submitting report for user: ${_userInfo!.id} with reason: $result');
        final userProxy = SiteProxyService.getUserProxy();
        final reportResult = await userProxy.reportUserAsync(_userInfo!.id, result);

        AppLogger.debug('Report result: ${reportResult.result}, resultText: ${reportResult.resultText}');

        if (context.mounted) {
          // Hide loading snackbar
          ScaffoldMessenger.of(context).hideCurrentSnackBar();

          // Check if the report was successful
          if (reportResult.result) {
            AppLogger.debug('Report submitted successfully for user: ${_userInfo!.id}');
            // Show success message
            SnackbarHelper.showInfo(context, AppLocalizations.of(context).reportSubmittedSuccessfully);
          } else {
            final errorMessage =
                (reportResult.resultText != null && reportResult.resultText!.isNotEmpty) ? reportResult.resultText! : AppLocalizations.of(context).failedToSubmitReport;
            AppLogger.debug('Report failed for user: ${_userInfo!.id}, error: $errorMessage');
            // Show error message
            SnackbarHelper.showError(context, errorMessage);
          }
        }
      } catch (e) {
        AppLogger.debug('Exception occurred while reporting user: ${_userInfo!.id}, error: $e');
        if (context.mounted) {
          SnackbarHelper.showError(context, '${AppLocalizations.of(context).failedToSubmitReport}: ${e.toString()}');
        }
      }
    }
  }

  Future<void> _handleBanUser(BuildContext context) async {
    if (_userInfo == null) return;

    AppLogger.debug('Handling ban of user: ${_userInfo!.id}');

    // Common ban reasons
    final l10n = AppLocalizations.of(context);
    final banReasons = [
      l10n.violationOfCommunityGuidelines,
      l10n.spamOrAdvertising,
      l10n.harassmentOrAbusiveBehavior,
      l10n.postingInappropriateContent,
      l10n.accountCompromiseOrSecurityIssue,
      l10n.otherPleaseSpecify,
    ];

    String? reasonResult;
    Map<String, dynamic>? banConfigResult;

    // Loop to allow going back from second dialog to first dialog
    while (true) {
      if (!context.mounted) return;

      // Step 1: Select reason
      reasonResult = await showDialog<String?>(
        context: context,
        builder: (BuildContext context) {
          String? selectedReason;
          final TextEditingController customReasonController = TextEditingController();
          final formKey = GlobalKey<FormState>();

          return StatefulBuilder(
            builder: (context, setState) {
              final colorScheme = Theme.of(context).colorScheme;
              final textTheme = Theme.of(context).textTheme;

              return AlertDialog(
                title: Text(
                  AppLocalizations.of(context).banUser,
                  style: textTheme.titleLarge?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                content: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context).pleaseSelectReasonForBanningUser(_userInfo!.username),
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: DesignTokens.spacingL),
                        RadioGroup<String>(
                          groupValue: selectedReason,
                          onChanged: (value) {
                            setState(() {
                              selectedReason = value;
                            });
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: banReasons.map((reason) {
                              return RadioListTile<String>(
                                title: Text(
                                  reason,
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                value: reason,
                                contentPadding: EdgeInsets.zero,
                              );
                            }).toList(),
                          ),
                        ),
                        if (selectedReason == l10n.otherPleaseSpecify) ...[
                          const SizedBox(height: DesignTokens.spacingM),
                          TextFormField(
                            controller: customReasonController,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context).pleaseSpecifyReason,
                              hintText: AppLocalizations.of(context).enterReasonForBanningUser,
                              border: const OutlineInputBorder(),
                            ),
                            maxLines: 3,
                            validator: (value) {
                              if (selectedReason == l10n.otherPleaseSpecify && (value == null || value.trim().isEmpty)) {
                                return AppLocalizations.of(context).pleaseSpecifyReason;
                              }
                              return null;
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(null),
                    child: Text(
                      AppLocalizations.of(context).cancel,
                      style: TextStyle(color: colorScheme.onSurfaceVariant),
                    ),
                  ),
                  FilledButton(
                    onPressed: selectedReason == null
                        ? null
                        : () {
                            if (!formKey.currentState!.validate()) {
                              return;
                            }

                            final reason = selectedReason == 'Other (please specify)' ? customReasonController.text.trim() : selectedReason!;

                            Navigator.of(context).pop(reason);
                          },
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                    ),
                    child: Text(AppLocalizations.of(context).next),
                  ),
                ],
              );
            },
          );
        },
      );

      if (reasonResult == null || !context.mounted) return;

      // Step 2: Select ban type and expiration
      banConfigResult = await showDialog<Map<String, dynamic>?>(
        context: context,
        builder: (BuildContext context) {
          String? banLength = 'permanent'; // 'permanent' or 'temporary'
          DateTime? selectedEndDate;

          return StatefulBuilder(
            builder: (context, setState) {
              final colorScheme = Theme.of(context).colorScheme;
              final textTheme = Theme.of(context).textTheme;

              return AlertDialog(
                title: Text(
                  AppLocalizations.of(context).banUser,
                  style: textTheme.titleLarge?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context).setBanDurationFor(_userInfo!.username),
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: DesignTokens.spacingL),
                      RadioGroup<String>(
                        groupValue: banLength,
                        onChanged: (value) {
                          setState(() {
                            banLength = value;
                            if (value == 'permanent') {
                              selectedEndDate = null;
                            } else {
                              // Default to 7 days from now if no date selected
                              selectedEndDate ??= DateTime.now().add(const Duration(days: 7));
                            }
                          });
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                          RadioListTile<String>(
                            title: Text(
                              AppLocalizations.of(context).permanent,
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface,
                              ),
                            ),
                            value: 'permanent',
                            contentPadding: EdgeInsets.zero,
                          ),
                          RadioListTile<String>(
                            title: Text(
                              AppLocalizations.of(context).temporary,
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface,
                              ),
                            ),
                            value: 'temporary',
                            contentPadding: EdgeInsets.zero,
                          ),
                          ],
                        ),
                      ),
                      // Date picker for temporary ban
                      if (banLength == 'temporary') ...[
                        const SizedBox(height: DesignTokens.spacingM),
                        InkWell(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: selectedEndDate ?? DateTime.now().add(const Duration(days: 7)),
                              firstDate: DateTime.now().add(const Duration(days: 1)),
                              lastDate: DateTime.now().add(const Duration(days: 3650)), // 10 years
                            );
                            if (picked != null) {
                              // If time picker is available, show it
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(selectedEndDate ?? DateTime.now()),
                              );
                              setState(() {
                                if (time != null) {
                                  selectedEndDate = DateTime(
                                    picked.year,
                                    picked.month,
                                    picked.day,
                                    time.hour,
                                    time.minute,
                                  );
                                } else {
                                  selectedEndDate = DateTime(
                                    picked.year,
                                    picked.month,
                                    picked.day,
                                    23,
                                    59,
                                    59,
                                  );
                                }
                              });
                            }
                          },
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context).banUntil,
                              border: const OutlineInputBorder(),
                              suffixIcon: const Icon(Icons.calendar_today),
                            ),
                            child: Text(
                              selectedEndDate != null ? DateFormat.yMMMd().add_jm().format(selectedEndDate!) : AppLocalizations.of(context).selectDate,
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                        if (selectedEndDate == null) ...[
                          const SizedBox(height: DesignTokens.spacingXS),
                          Text(
                            AppLocalizations.of(context).pleaseSelectEndDate,
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.error,
                            ),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(null),
                    child: Text(
                      AppLocalizations.of(context).back,
                      style: TextStyle(color: colorScheme.onSurfaceVariant),
                    ),
                  ),
                  FilledButton(
                    onPressed: () {
                      if (banLength == 'temporary' && selectedEndDate == null) {
                        SnackbarHelper.showError(context, AppLocalizations.of(context).pleaseSelectEndDateForTemporaryBan);
                        return;
                      }

                      int banExpires = 0;
                      if (banLength == 'temporary' && selectedEndDate != null) {
                        banExpires = selectedEndDate!.millisecondsSinceEpoch ~/ 1000;
                      }

                      Navigator.of(context).pop({
                        'reason': reasonResult,
                        'banExpires': banExpires,
                      });
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.error,
                      foregroundColor: colorScheme.onError,
                    ),
                    child: Text(AppLocalizations.of(context).banUser),
                  ),
                ],
              );
            },
          );
        },
      );

      // If banConfigResult is null, user clicked "Back", so loop back to first dialog
      // If banConfigResult is not null, user completed the flow, so break out of loop
      if (banConfigResult != null) {
        break;
      }
      // Otherwise, continue loop to show first dialog again
    }

    if (context.mounted) {
      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: DesignTokens.iconSizeM,
                height: DesignTokens.iconSizeM,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.onInverseSurface,
                  ),
                ),
              ),
              const SizedBox(width: DesignTokens.spacingM),
              Text(
                AppLocalizations.of(context).banningUser,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onInverseSurface,
                    ),
              ),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.inverseSurface,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusS),
          ),
          margin: DesignTokens.paddingS,
          padding: EdgeInsets.symmetric(
            horizontal: DesignTokens.spacingL,
            vertical: DesignTokens.spacingM,
          ),
          duration: const Duration(seconds: 30),
        ),
      );

      try {
        AppLogger.debug('Banning user: ${_userInfo!.username} with reason: ${banConfigResult['reason']}, expires: ${banConfigResult['banExpires']}');
        final moderationProxy = SiteProxyService.getModerationProxy();
        final banResult = await moderationProxy.banUserAsync(
          _userInfo!.username,
          banConfigResult['reason'] as String,
          banConfigResult['banExpires'] as int,
          0, // deletePostMode - not used by XenForo API
          0, // deletePostValue - not used by XenForo API
        );

        AppLogger.debug('Ban result: ${banResult.result}, resultText: ${banResult.resultText}');

        if (context.mounted) {
          // Hide loading snackbar
          ScaffoldMessenger.of(context).hideCurrentSnackBar();

          // Check if the ban was successful
          if (banResult.result) {
            AppLogger.debug('User banned successfully: ${_userInfo!.id}');
            // Show success message
            SnackbarHelper.showInfo(context, AppLocalizations.of(context).userBannedSuccessfully);
            // Refresh entire page to reflect ban status
            await _refreshProfile();
          } else {
            final errorMessage = (banResult.resultText != null && banResult.resultText!.isNotEmpty) ? banResult.resultText! : AppLocalizations.of(context).failedToBanUser;
            AppLogger.debug('Ban failed for user: ${_userInfo!.id}, error: $errorMessage');
            // Show error message
            SnackbarHelper.showError(context, errorMessage);
          }
        }
      } catch (e) {
        AppLogger.debug('Exception occurred while banning user: ${_userInfo!.id}, error: $e');
        if (context.mounted) {
          SnackbarHelper.showError(context, '${AppLocalizations.of(context).failedToBanUser}: $e');
        }
      }
    }
  }

  Future<void> _handleUnbanUser(BuildContext context) async {
    if (_userInfo == null) return;

    AppLogger.debug('Handling unban of user: ${_userInfo!.id}');

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        final colorScheme = Theme.of(context).colorScheme;
        final textTheme = Theme.of(context).textTheme;

        return AlertDialog(
          title: Text(
            AppLocalizations.of(context).unbanUser,
            style: textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          content: Text(
            AppLocalizations.of(context).areYouSureUnban(_userInfo!.username),
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                AppLocalizations.of(context).cancel,
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
              ),
              child: Text(AppLocalizations.of(context).unban),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) return;

    // Show loading indicator
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: DesignTokens.iconSizeM,
              height: DesignTokens.iconSizeM,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.onInverseSurface,
                ),
              ),
            ),
            const SizedBox(width: DesignTokens.spacingM),
            Text(
              AppLocalizations.of(context).unbanningUser,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onInverseSurface,
                  ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.inverseSurface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusS),
        ),
        margin: DesignTokens.paddingS,
        padding: EdgeInsets.symmetric(
          horizontal: DesignTokens.spacingL,
          vertical: DesignTokens.spacingM,
        ),
        duration: const Duration(seconds: 30),
      ),
    );

    try {
      AppLogger.debug('Unbanning user: ${_userInfo!.id}');
      final moderationProxy = SiteProxyService.getModerationProxy();
      final unbanResult = await moderationProxy.unbanUserAsync(_userInfo!.id);

      AppLogger.debug('Unban result: ${unbanResult.result}, resultText: ${unbanResult.resultText}');

      if (context.mounted) {
        // Hide loading snackbar
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        // Check if the unban was successful
        if (unbanResult.result) {
          AppLogger.debug('User unbanned successfully: ${_userInfo!.id}');
          // Show success message
          SnackbarHelper.showInfo(context, AppLocalizations.of(context).userUnbannedSuccessfully);
          // Refresh entire page to reflect unban status
          await _refreshProfile();
        } else {
          final errorMessage =
              (unbanResult.resultText != null && unbanResult.resultText!.isNotEmpty) ? unbanResult.resultText! : AppLocalizations.of(context).failedToUnbanUser;
          AppLogger.debug('Unban failed for user: ${_userInfo!.id}, error: $errorMessage');
          // Show error message
          SnackbarHelper.showError(context, errorMessage);
        }
      }
    } catch (e) {
      AppLogger.debug('Exception occurred while unbanning user: ${_userInfo!.id}, error: $e');
      if (context.mounted) {
        SnackbarHelper.showError(context, '${AppLocalizations.of(context).failedToUnbanUser}: $e');
      }
    }
  }

  Future<void> _handleSpamCleanUser(BuildContext context) async {
    if (_userInfo == null) return;

    AppLogger.debug('Handling spam clean of user: ${_userInfo!.id}');

    // Initialize all checkboxes to true (checked)
    bool actionThreads = true;
    bool deleteMessages = true;
    bool deleteConversations = true;
    bool banUser = true;

    final result = await showDialog<Map<String, bool>?>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final colorScheme = Theme.of(context).colorScheme;
            final textTheme = Theme.of(context).textTheme;

            return AlertDialog(
              title: Text(
                AppLocalizations.of(context).spamCleanUser,
                style: textTheme.titleLarge?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context).spamClean(_userInfo!.username),
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: DesignTokens.spacingL),
                    Text(
                      AppLocalizations.of(context).selectActionsToPerform,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: DesignTokens.spacingM),
                    CheckboxListTile(
                      title: Text(
                        AppLocalizations.of(context).handleThreads,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                      subtitle: Text(
                        AppLocalizations.of(context).moveOrDeleteThreadsBasedOnAdminSettings,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      value: actionThreads,
                      onChanged: (value) {
                        setState(() {
                          actionThreads = value ?? true;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                    CheckboxListTile(
                      title: Text(
                        AppLocalizations.of(context).deleteMessages,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                      subtitle: Text(
                        AppLocalizations.of(context).deletePostsProfilePostsComments,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      value: deleteMessages,
                      onChanged: (value) {
                        setState(() {
                          deleteMessages = value ?? true;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                    CheckboxListTile(
                      title: Text(
                        AppLocalizations.of(context).deleteConversations,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                      subtitle: Text(
                        AppLocalizations.of(context).deletePrivateConversations,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      value: deleteConversations,
                      onChanged: (value) {
                        setState(() {
                          deleteConversations = value ?? true;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                    CheckboxListTile(
                      title: Text(
                        AppLocalizations.of(context).banUser,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                      subtitle: Text(
                        AppLocalizations.of(context).banTheUserAccount,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      value: banUser,
                      onChanged: (value) {
                        setState(() {
                          banUser = value ?? true;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: DesignTokens.spacingL),
                    Text(
                      AppLocalizations.of(context).thisActionCannotBeUndone,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.error,
                        fontWeight: DesignTokens.fontWeightMedium,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(null),
                  child: Text(
                    AppLocalizations.of(context).cancel,
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                  ),
                ),
                FilledButton(
                  onPressed: () {
                    Navigator.of(context).pop({
                      'actionThreads': actionThreads,
                      'deleteMessages': deleteMessages,
                      'deleteConversations': deleteConversations,
                      'banUser': banUser,
                    });
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.error,
                    foregroundColor: colorScheme.onError,
                  ),
                  child: Text(AppLocalizations.of(context).cleanSpam),
                ),
              ],
            );
          },
        );
      },
    );

    if (result == null || !context.mounted) return;

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        final colorScheme = Theme.of(context).colorScheme;
        final textTheme = Theme.of(context).textTheme;

        final selectedActions = <String>[];
        final l10n = AppLocalizations.of(context);
        if (result['actionThreads'] == true) selectedActions.add(l10n.handleThreads);
        if (result['deleteMessages'] == true) selectedActions.add(l10n.deleteMessages);
        if (result['deleteConversations'] == true) selectedActions.add(l10n.deleteConversations);
        if (result['banUser'] == true) selectedActions.add(l10n.banUser);

        return AlertDialog(
          title: Text(
            AppLocalizations.of(context).confirmSpamClean,
            style: textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context).areYouSureSpamClean(_userInfo!.username),
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              if (selectedActions.isNotEmpty) ...[
                const SizedBox(height: DesignTokens.spacingL),
                Text(
                  AppLocalizations.of(context).selectedActions,
                  style: textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: DesignTokens.spacingS),
                ...selectedActions.map((action) => Padding(
                      padding: const EdgeInsets.only(left: DesignTokens.spacingM, bottom: DesignTokens.spacingXS),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: DesignTokens.iconSizeS,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: DesignTokens.spacingS),
                          Text(
                            action,
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
              const SizedBox(height: DesignTokens.spacingL),
              Text(
                AppLocalizations.of(context).thisActionCannotBeUndone,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.error,
                  fontWeight: DesignTokens.fontWeightMedium,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                AppLocalizations.of(context).cancel,
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
              ),
              child: Text(AppLocalizations.of(context).confirm),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) return;

    // Show loading indicator
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: DesignTokens.iconSizeM,
              height: DesignTokens.iconSizeM,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.onInverseSurface,
                ),
              ),
            ),
            const SizedBox(width: DesignTokens.spacingM),
            Text(
              AppLocalizations.of(context).cleaningSpam,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onInverseSurface,
                  ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.inverseSurface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusS),
        ),
        margin: DesignTokens.paddingS,
        padding: EdgeInsets.symmetric(
          horizontal: DesignTokens.spacingL,
          vertical: DesignTokens.spacingM,
        ),
        duration: const Duration(seconds: 30),
      ),
    );

    try {
      AppLogger.debug('Spam cleaning user: ${_userInfo!.username} (${_userInfo!.id}) with actions: $result');
      final moderationProxy = SiteProxyService.getModerationProxy();
      final spamCleanResult = await moderationProxy.spamCleanUserAsync(
        userId: _userInfo!.id,
        username: _userInfo!.username,
        actionThreads: result['actionThreads'] ?? false,
        deleteMessages: result['deleteMessages'] ?? false,
        deleteConversations: result['deleteConversations'] ?? false,
        banUser: result['banUser'] ?? false,
      );

      AppLogger.debug('Spam clean result: ${spamCleanResult.result}, resultText: ${spamCleanResult.resultText}');

      if (context.mounted) {
        // Hide loading snackbar
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        // Check if the spam clean was successful
        if (spamCleanResult.result) {
          AppLogger.debug('User spam cleaned successfully: ${_userInfo!.id}');

          // Build success message with actions performed
          final actionsPerformed = <String>[];
          final l10n = AppLocalizations.of(context);
          if (spamCleanResult.actions != null) {
            if (spamCleanResult.actions!['action_threads'] == true) {
              actionsPerformed.add(l10n.handledThreads);
            }
            if (spamCleanResult.actions!['delete_messages'] == true) {
              actionsPerformed.add(l10n.deletedMessages);
            }
            if (spamCleanResult.actions!['delete_conversations'] == true) {
              actionsPerformed.add(l10n.deletedConversations);
            }
            if (spamCleanResult.actions!['ban_user'] == true) {
              actionsPerformed.add(l10n.bannedUser);
            }
          }

          final successMessage = actionsPerformed.isNotEmpty
              ? l10n.successfullyCleanedSpam(spamCleanResult.username ?? _userInfo!.username, actionsPerformed.join(', '))
              : l10n.successfullyCleanedSpamFor(spamCleanResult.username ?? _userInfo!.username);

          // Show success message
          SnackbarHelper.showInfo(context, successMessage);
          // Refresh entire page state to reflect all changes
          // This will cause all widgets including UserRepliedPosts to rebuild and fetch fresh data
          if (context.mounted) {
            await _refreshProfile();
          }
        } else {
          final errorMessage = (spamCleanResult.resultText != null && spamCleanResult.resultText!.isNotEmpty) ? spamCleanResult.resultText! : AppLocalizations.of(context).failedToCleanSpam;
          AppLogger.debug('Spam clean failed for user: ${_userInfo!.id}, error: $errorMessage');
          // Show error message
          SnackbarHelper.showError(context, errorMessage);
        }
      }
    } catch (e) {
      AppLogger.debug('Exception occurred while spam cleaning user: ${_userInfo!.id}, error: $e');
      if (context.mounted) {
        SnackbarHelper.showError(context, '${AppLocalizations.of(context).failedToCleanSpam}: $e');
      }
    }
  }
}
