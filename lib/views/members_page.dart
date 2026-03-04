import 'package:flutter/material.dart';
import 'package:forumcopilot_flutter/views/widgets/user_avatar.dart';
import 'package:forumcopilot_flutter/views/widgets/search_text_field.dart';
import 'package:forumcopilot_flutter/views/widgets/empty_state_widget.dart';
import 'package:forumcopilot_flutter/views/widgets/error_state_widget.dart';
import 'package:forumcopilot_flutter/views/user_profile_page.dart';
import 'package:forumcopilot_flutter/l10n/generated/app_localizations.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/factory/site_proxy_factory.dart';
import 'package:forumcopilot_sdk/models/entities/fc_user.dart';
import 'package:forumcopilot_sdk/models/results/fc_user_result.dart';
import '../theme/design_tokens.dart';
import '../utils/number_utils.dart';

class MembersPage extends StatefulWidget {
  const MembersPage({
    required this.siteContext,
    super.key,
  });
  final SiteContext siteContext;

  @override
  State<MembersPage> createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  // Filter chip selection: 0 = All Members, 1 = Online
  int _selectedFilterIndex = 0;
  List<String> _getFilterLabels(BuildContext context) {
    return [
      AppLocalizations.of(context)?.allMembers ?? 'All Members',
      AppLocalizations.of(context)?.online ?? 'Online',
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

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Load default list of most active users on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDefaultUsers();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (_selectedFilterIndex == 0) {
        // All Members mode
        if (!_searchIsLoading && _searchHasMore) {
          _performSearch();
        }
      } else {
        // Online mode
        if (!_onlineIsLoading && _onlineHasMore) {
          _loadOnlineUsers();
        }
      }
    }
  }

  Future<void> _loadDefaultUsers() async {
    if (_selectedFilterIndex == 0) {
      await _performSearch(reset: true);
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

  Future<void> _loadOnlineUsers() async {
    if (_onlineIsLoading) return;

    setState(() {
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

      setState(() {
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
    if (index == 0 && _searchResults.isEmpty && !_hasSearched) {
      _loadDefaultUsers();
    } else if (index == 1 && _onlineUsers.isEmpty) {
      _onlineCurrentPage = 1;
      _onlineHasMore = true;
      _loadOnlineUsers();
    }
  }

  Widget _buildFilterChips() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingL,
        vertical: DesignTokens.spacingM,
      ),
      child: SizedBox(
        height: 40,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _getFilterLabels(context).length,
          separatorBuilder: (context, index) => SizedBox(width: DesignTokens.spacingS),
          itemBuilder: (context, index) {
            final isSelected = _selectedFilterIndex == index;
            return FilterChip(
              selected: isSelected,
              label: Text(_getFilterLabels(context)[index]),
              onSelected: (selected) {
                _handleFilterChange(index);
              },
              selectedColor: colorScheme.primaryContainer,
              checkmarkColor: colorScheme.onPrimaryContainer,
              labelStyle: textTheme.labelLarge?.copyWith(
                color: isSelected ? colorScheme.onPrimaryContainer : colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? DesignTokens.fontWeightSemiBold : DesignTokens.fontWeightNormal,
              ),
              backgroundColor: colorScheme.surfaceVariant,
              padding: EdgeInsets.symmetric(
                horizontal: DesignTokens.spacingM,
                vertical: DesignTokens.spacingS,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(DesignTokens.radiusL),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(ColorScheme colorScheme, TextTheme textTheme) {
    if (_selectedFilterIndex == 0) {
      // All Members mode
      return _buildSearchResults(colorScheme, textTheme);
    } else {
      // Online mode
      return _buildOnlineUsers(colorScheme, textTheme);
    }
  }

  Widget _buildSearchResults(ColorScheme colorScheme, TextTheme textTheme) {
    if (_searchError != null) {
      return ErrorStateWidget(
        title: AppLocalizations.of(context)?.searchFailed ?? 'Search failed',
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
        title: AppLocalizations.of(context)?.noMembersFound ?? 'No members found',
        description: AppLocalizations.of(context)?.trySearchingWithDifferentUsername ?? 'Try searching with a different username',
      );
    }

    if (_searchResults.isEmpty && !_hasSearched) {
      return EmptyStateWidget(
        icon: Icons.people_alt_outlined,
        title: AppLocalizations.of(context)?.searchForMembers ?? 'Search for members',
        description: AppLocalizations.of(context)?.enterUsernameToFindMembers ?? 'Enter a username to find forum members',
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
    if (_onlineError != null) {
      return ErrorStateWidget(
        title: AppLocalizations.of(context)?.failedToLoadOnlineUsers ?? 'Failed to load online users',
        message: _onlineError!,
      );
    }

    if (_onlineIsLoading && _onlineUsers.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_onlineUsers.isEmpty && !_onlineIsLoading) {
      return EmptyStateWidget(
        icon: Icons.people_outline_rounded,
        title: AppLocalizations.of(context)?.noUsersOnline ?? 'No users online',
        description: AppLocalizations.of(context)?.noMembersOnline ?? 'No members are currently online',
      );
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: _onlineUsers.length + (_onlineHasMore ? 1 : 0),
      itemBuilder: (context, index) {
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
          subtitle: user.displayText != null && user.displayText!.isNotEmpty
              ? Text(
                  user.displayText!,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              : null,
        );
      },
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
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: colorScheme.onSurfaceVariant,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusM),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserProfilePage(
              siteContext: widget.siteContext,
              userId: user.id,
              userName: user.username,
              profilePictureUrl: user.iconUrl,
            ),
          ),
        );
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
          AppLocalizations.of(context)?.members ?? 'Members',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: DesignTokens.fontWeightMedium,
          ),
        ),
        backgroundColor: colorScheme.surface,
        elevation: DesignTokens.elevationMedium,
        shadowColor: colorScheme.shadow.withOpacity(DesignTokens.opacityLow),
        surfaceTintColor: colorScheme.surfaceTint,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Filter Chips
          _buildFilterChips(),
          // Search TextField (only for All Members)
          if (_selectedFilterIndex == 0)
            Container(
              padding: DesignTokens.paddingL,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                border: Border(
                  bottom: BorderSide(
                    color: colorScheme.outlineVariant.withOpacity(DesignTokens.opacityLow),
                    width: DesignTokens.borderWidthThin,
                  ),
                ),
              ),
              child: SearchTextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                hintText: AppLocalizations.of(context)?.enterUsernameToSearch ?? 'Enter username to search...',
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





