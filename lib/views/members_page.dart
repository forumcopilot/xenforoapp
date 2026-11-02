import 'package:flutter/material.dart';
import 'package:forumcopilot_flutter/views/widgets/user_avatar.dart';
import 'package:forumcopilot_flutter/views/widgets/search_text_field.dart';
import 'package:forumcopilot_flutter/views/widgets/empty_state_widget.dart';
import 'package:forumcopilot_flutter/views/widgets/error_state_widget.dart';
import 'package:forumcopilot_flutter/views/user_profile_page.dart';
import 'package:forumcopilot_flutter/views/login_page.dart';
import 'package:forumcopilot_flutter/l10n/generated/app_localizations.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/factory/site_proxy_factory.dart';
import 'package:forumcopilot_sdk/models/entities/fc_user.dart';
import 'package:forumcopilot_sdk/models/results/fc_user_result.dart';
import '../theme/design_tokens.dart';
import '../utils/number_utils.dart';
import '../utils/time_utils.dart';
import 'widgets/filter_chip_bar.dart';
import '../utils/app_navigation.dart';

class MembersPage extends StatefulWidget {
  const MembersPage({
    required this.siteContext,
    super.key,
  });
  final SiteContext siteContext;

  @override
  State<MembersPage> createState() => _MembersPageState();
}

/// The forum's members: who is online now (first, as the screen opens) and
/// all members, by name. Both follow XenForo's "View member lists"
/// permission, which the add-on checks; a visitor without it sees why, and a
/// guest can log in.
class _MembersPageState extends State<MembersPage> {
  static const _onlineTab = 0;
  static const _allTab = 1;

  int _selectedFilterIndex = _onlineTab;
  List<String> _getFilterLabels(BuildContext context) {
    return [
      AppLocalizations.of(context).online,
      AppLocalizations.of(context).allMembers,
    ];
  }

  // Search state (for All Members)
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<FCSearchUser> _searchResults = [];
  int _searchCurrentPage = 1;
  final int _searchPageSize = 20;
  bool _searchHasMore = true;
  bool _searchIsLoading = false;
  String? _searchError;
  bool _hasSearched = false;

  // Online users state (for Online)
  List<FCOnlineUser> _onlineUsers = [];
  int _onlineCurrentPage = 1;
  final int _onlinePageSize = 20;
  bool _onlineHasMore = true;
  bool _onlineIsLoading = false;
  String? _onlineError;

  /// The forum keeps its member lists from this visitor (XenForo's "View
  /// member lists" permission): the add-on refuses getOnlineUsers.
  bool _onlinePrivate = false;

  /// Members online now, as the forum counts them (guests and robots not
  /// included, nor members who hide their online status).
  int _onlineTotal = 0;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Who's online first, as XenForo's members page leads with it
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadOnlineUsers(reset: true);
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (_selectedFilterIndex == _allTab) {
        if (!_searchIsLoading && _searchHasMore) {
          _performSearch();
        }
      } else {
        if (!_onlineIsLoading && _onlineHasMore && !_onlinePrivate) {
          _loadOnlineUsers();
        }
      }
    }
  }


  Future<void> _performSearch({bool reset = false}) async {
    final query = _searchController.text.trim();

    if (_searchIsLoading) return;

    if (reset) {
      setState(() {
        _searchCurrentPage = 1;
        _searchHasMore = true;
        _searchResults = [];
        _searchError = null;
      });
    }

    setState(() {
      _searchIsLoading = true;
      _searchError = null;
      _hasSearched = true;
    });

    try {
      final userProxy = SiteProxyFactory.getUserProxy();
      final result = await userProxy.searchUserAsync(
        query,
        _searchCurrentPage,
        _searchPageSize,
      );

      if (!mounted) return;

      if (!result.result) {
        setState(() {
          _searchIsLoading = false;
          _searchHasMore = false;
          if (query.isEmpty) {
            // The forum keeps its member list to itself ("Member list is
            // not available"): ask for a name instead. It said "No members
            // found, try a different username" before anything was typed.
            _hasSearched = false;
          } else {
            // Its reason ("at least 2 characters", search not allowed).
            final reason = result.resultText?.trim() ?? '';
            _searchError = reason.isNotEmpty ? reason : AppLocalizations.of(context).searchFailed;
          }
        });
        return;
      }

      setState(() {
        if (_searchCurrentPage == 1) {
          _searchResults = result.list;
        } else {
          _searchResults = [..._searchResults, ...result.list];
        }
        _searchHasMore = result.list.length == _searchPageSize;
        if (_searchHasMore) {
          _searchCurrentPage++;
        }
        _searchIsLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _searchError = e.toString();
        _searchIsLoading = false;
      });
    }
  }

  Future<void> _loadOnlineUsers({bool reset = false}) async {
    if (_onlineIsLoading) return;

    setState(() {
      if (reset) {
        _onlineCurrentPage = 1;
        _onlineHasMore = true;
      }
      _onlineIsLoading = true;
      _onlineError = null;
    });

    try {
      final userProxy = SiteProxyFactory.getUserProxy();
      final result = await userProxy.getOnlineUsersAsync(
        _onlineCurrentPage,
        _onlinePageSize,
        null, // id
        null, // area
      );

      if (!mounted) return;

      if (!result.result) {
        // The forum refuses ("Cannot view member list"): it keeps its member
        // lists from this visitor. It used to read as "No users online".
        setState(() {
          _onlineIsLoading = false;
          _onlineHasMore = false;
          _onlinePrivate = true;
          _onlineUsers = [];
        });
        return;
      }

      setState(() {
        _onlinePrivate = false;
        _onlineTotal = result.total;
        if (_onlineCurrentPage == 1) {
          _onlineUsers = result.list;
        } else {
          _onlineUsers.addAll(result.list);
        }
        _onlineHasMore = result.list.length == _onlinePageSize;
        if (_onlineHasMore) _onlineCurrentPage++;
        _onlineIsLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _onlineError = e.toString();
        _onlineIsLoading = false;
      });
    }
  }

  void _handleSearch(String query) {
    setState(() {
      _searchCurrentPage = 1;
      _searchHasMore = true;
    });
    _performSearch(reset: true);
  }

  void _handleClear() {
    setState(() {
      _searchCurrentPage = 1;
      _searchHasMore = true;
    });
    // Load default list when cleared
    _performSearch(reset: true);
  }

  void _handleFilterChange(int index) {
    setState(() {
      _selectedFilterIndex = index;
      // Reset scroll position
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
    });

    // Load data for the selected filter if needed
    if (index == _allTab && _searchResults.isEmpty && !_hasSearched) {
      _performSearch(reset: true);
    } else if (index == _onlineTab && _onlineUsers.isEmpty && !_onlinePrivate) {
      _loadOnlineUsers(reset: true);
    }
  }

  Widget _buildFilterChips() {

    // The shared chip row (from the Discourse app): Material 3 filter chips
    // that grow with the text size instead of clipping in a 40dp row.
    return FilterChipBar(
      options: [for (final label in _getFilterLabels(context)) FilterChipOption(label: label)],
      selectedIndex: _selectedFilterIndex,
      onSelected: (index) {
        _handleFilterChange(index);
      },
    );
  }

  Widget _buildContent(ColorScheme colorScheme, TextTheme textTheme) {
    return _selectedFilterIndex == _allTab
        ? _buildSearchResults(colorScheme, textTheme)
        : _buildOnlineUsers(colorScheme, textTheme);
  }

  /// What a visitor without "View member lists" sees: why, and for a guest,
  /// Log in (members may have the permission when guests don't).
  Widget _buildPrivateState() {
    final l10n = AppLocalizations.of(context);
    final isGuest = !widget.siteContext.isLoggedIn;
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            EmptyStateWidget(
              icon: Icons.lock_outline_rounded,
              title: l10n.memberListsPrivate,
              description: isGuest ? l10n.memberListsPrivateGuest : l10n.memberListsPrivateMember,
            ),
            if (isGuest)
              FilledButton.tonal(
                onPressed: () async {
                  await AppNavigation.pushGlobal(LoginPage(siteContext: widget.siteContext), name: '/LoginPage');
                  if (mounted && widget.siteContext.isLoggedIn) _loadOnlineUsers(reset: true);
                },
                child: Text(l10n.logIn),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(ColorScheme colorScheme, TextTheme textTheme) {
    if (_searchError != null) {
      return ErrorStateWidget(
        title: AppLocalizations.of(context).searchFailed,
        message: _searchError!,
      );
    }

    if (_searchIsLoading && _searchResults.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_searchResults.isEmpty && _hasSearched) {
      return EmptyStateWidget(
        icon: Icons.search_off_rounded,
        title: AppLocalizations.of(context).noMembersFound,
        description: AppLocalizations.of(context).trySearchingWithDifferentUsername,
      );
    }

    if (_searchResults.isEmpty && !_hasSearched) {
      return EmptyStateWidget(
        icon: Icons.people_alt_outlined,
        title: AppLocalizations.of(context).searchForMembers,
        description: AppLocalizations.of(context).enterUsernameToFindMembers,
      );
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: _searchResults.length + (_searchHasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _searchResults.length) {
          return Center(
            child: Padding(
              padding: DesignTokens.paddingL,
              child: const CircularProgressIndicator(),
            ),
          );
        }

        final member = _searchResults[index];
        return _buildUserListItem(
          user: member,
          colorScheme: colorScheme,
          textTheme: textTheme,
          subtitle: member.postCount > 0
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.comment_outlined,
                      size: textTheme.bodySmall?.fontSize ?? DesignTokens.fontSizeXS,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(width: DesignTokens.spacingXS),
                    Text(
                      formatNumber(context, member.postCount),
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        letterSpacing: DesignTokens.letterSpacingWide,
                      ),
                    ),
                  ],
                )
              : null,
        );
      },
    );
  }

  Widget _buildOnlineUsers(ColorScheme colorScheme, TextTheme textTheme) {
    if (_onlinePrivate) return _buildPrivateState();

    if (_onlineError != null) {
      return ErrorStateWidget(
        title: AppLocalizations.of(context).failedToLoadOnlineUsers,
        message: _onlineError!,
      );
    }

    if (_onlineIsLoading && _onlineUsers.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Pull to refresh: who's online changes by the minute
    Future<void> refresh() => _loadOnlineUsers(reset: true);

    if (_onlineUsers.isEmpty && !_onlineIsLoading) {
      return RefreshIndicator(
        onRefresh: refresh,
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: EmptyStateWidget(
                  icon: Icons.people_outline_rounded,
                  title: AppLocalizations.of(context).noUsersOnline,
                  description: AppLocalizations.of(context).noMembersOnline,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: refresh,
      child: ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      // The count first, as XenForo's "Members online" heading
      itemCount: 1 + _onlineUsers.length + (_onlineHasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: EdgeInsets.fromLTRB(DesignTokens.spacingL, DesignTokens.spacingM, DesignTokens.spacingL, DesignTokens.spacingXS),
            child: Text(
              AppLocalizations.of(context).membersOnlineCount(_onlineTotal > 0 ? _onlineTotal : _onlineUsers.length),
              style: textTheme.titleSmall?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          );
        }
        index -= 1;
        if (index == _onlineUsers.length) {
          return Center(
            child: Padding(
              padding: DesignTokens.paddingL,
              child: const CircularProgressIndicator(),
            ),
          );
        }

        final user = _onlineUsers[index];
        return _buildUserListItem(
          user: user,
          colorScheme: colorScheme,
          textTheme: textTheme,
          subtitle: _buildOnlineUserSubtitle(user, colorScheme, textTheme),
        );
      },
      ),
    );
  }

  /// Subtitle for an Online-Users list row. Prefers the human-readable
  /// `currentActivity` (e.g. "Viewing thread Foo", "Using Forum Copilot
  /// Mobile App"). Falls back to `displayText` (user title) for older
  /// addon versions that don't populate currentActivity. Returns null when
  /// neither is available, so the list row just shows the username.
  ///
  /// Subtitle is plain text only — the row's existing tap target (open
  /// profile) is preserved; activity info is informational, not actionable.
  Widget? _buildOnlineUserSubtitle(
    FCOnlineUser user,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final activity = user.currentActivity;
    final fallback = user.displayText;
    final what = (activity != null && activity.isNotEmpty)
        ? activity
        : (fallback != null && fallback.isNotEmpty ? fallback : null);
    // When, as XenForo's online list shows it beside the activity
    final seen = user.lastActivityTime;
    final when = seen != null ? formatTimeAgo(seen, context) : null;
    final text = [if (what != null) what, if (when != null) when].join(' · ');
    if (text.isEmpty) return null;
    return Text(
      text,
      style: textTheme.bodySmall?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildUserListItem({
    required FCUser user,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    Widget? subtitle,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingL,
        vertical: DesignTokens.spacingS,
      ),
      leading: UserAvatar(
        username: user.username,
        iconUrl: user.iconUrl,
        radius: DesignTokens.avatarRadiusM,
        showOnlineIndicator: true,
        isOnline: user.isOnline,
      ),
      title: Text(
        user.username,
        style: textTheme.titleMedium?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: DesignTokens.fontWeightMedium,
        ),
      ),
      subtitle: subtitle != null
          ? Padding(
              padding: EdgeInsets.only(top: DesignTokens.spacingXS / 2),
              child: subtitle,
            )
          : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusM),
      ),
      onTap: () {
        AppNavigation.push(context, UserProfilePage(
              siteContext: widget.siteContext,
              userId: user.id,
              userName: user.username,
              profilePictureUrl: user.iconUrl,
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).members,
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: DesignTokens.fontWeightMedium,
          ),
        ),
        backgroundColor: colorScheme.surface,
        elevation: DesignTokens.elevationMedium,
        shadowColor: colorScheme.shadow.withValues(alpha: DesignTokens.opacityLow),
        surfaceTintColor: colorScheme.surfaceTint,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      body: Column(
        children: [
          // Filter Chips
          _buildFilterChips(),
          // Search TextField (only for All Members)
          if (_selectedFilterIndex == _allTab)
            Container(
              padding: DesignTokens.paddingL,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                border: Border(
                  bottom: BorderSide(
                    color: colorScheme.outlineVariant.withValues(alpha: DesignTokens.opacityLow),
                    width: DesignTokens.borderWidthThin,
                  ),
                ),
              ),
              child: SearchTextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                hintText: AppLocalizations.of(context).enterUsernameToSearch,
                onSearch: _handleSearch,
                autoSearch: true,
                onClear: _handleClear,
              ),
            ),
          // Content
          Expanded(
            child: _buildContent(colorScheme, textTheme),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}





