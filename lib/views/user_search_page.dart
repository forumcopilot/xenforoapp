import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import 'package:forumcopilot_sdk/factory/site_proxy_factory.dart';
import 'package:forumcopilot_flutter/views/widgets/user_avatar.dart';
import 'package:forumcopilot_flutter/views/widgets/search_text_field.dart';
import 'package:forumcopilot_flutter/views/widgets/empty_state_widget.dart';
import 'package:forumcopilot_flutter/views/widgets/error_state_widget.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/models/results/fc_user_result.dart';
import '../../theme/design_tokens.dart';
import '../../utils/number_utils.dart';

class UserSearchPage extends StatefulWidget {
  final SiteContext siteContext;
  final Function(String username, String? iconUrl) onUserSelected;
  final List<String> selectedUsers;

  const UserSearchPage({
    Key? key,
    required this.siteContext,
    required this.onUserSelected,
    this.selectedUsers = const [],
  }) : super(key: key);

  @override
  State<UserSearchPage> createState() => _UserSearchPageState();
}

class _UserSearchPageState extends State<UserSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<FCSearchUser> _users = [];
  bool _isLoading = false;
  String? _error;
  int _currentPage = 1;
  final int _pageSize = 20;
  bool _hasMore = true;
  bool _hasSearched = false;
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
      if (!_isLoading && _hasMore) {
        _searchUsers();
      }
    }
  }

  Future<void> _loadDefaultUsers() async {
    await _searchUsers(reset: true);
  }

  Future<void> _searchUsers({bool reset = false}) async {
    final query = _searchController.text.trim();

    if (_isLoading) return;

    if (reset) {
      setState(() {
        _currentPage = 1;
        _hasMore = true;
        _users = [];
        _error = null;
      });
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _hasSearched = true;
    });

    try {
      final userProxy = SiteProxyFactory.getUserProxy();
      final result = await userProxy.searchUserAsync(
        query,
        _currentPage,
        _pageSize,
      );

      if (!mounted) return;

      setState(() {
        if (_currentPage == 1) {
          _users = result.list;
        } else {
          _users = [..._users, ...result.list];
        }
        _hasMore = result.list.length == _pageSize;
        if (_hasMore) {
          _currentPage++;
        }
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _handleSearch(String query) {
    setState(() {
      _currentPage = 1;
      _hasMore = true;
    });
    _searchUsers(reset: true);
  }

  void _handleClear() {
    setState(() {
      _currentPage = 1;
      _hasMore = true;
    });
    // Load default list when cleared
    _searchUsers(reset: true);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search User',
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
              hintText: AppLocalizations.of(context)?.searchUsers ?? 'Search users...',
              onSearch: _handleSearch,
              autoSearch: true,
              onClear: _handleClear,
            ),
          ),
          Expanded(
            child: _buildContent(colorScheme, textTheme),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ColorScheme colorScheme, TextTheme textTheme) {
    if (_error != null) {
      return ErrorStateWidget(
        title: AppLocalizations.of(context)?.searchFailed ?? 'Search failed',
        message: _error!,
      );
    }

    if (_isLoading && _users.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_users.isEmpty && _hasSearched) {
      return EmptyStateWidget(
        icon: Icons.search_off_rounded,
        title: 'No users found',
        description: 'Try searching with a different username',
      );
    }

    if (_users.isEmpty && !_hasSearched) {
      return EmptyStateWidget(
        icon: Icons.person_search_rounded,
        title: 'Search for users',
        description: 'Enter a username to find and invite users',
      );
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: _users.length + (_hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _users.length) {
          return Center(
            child: Padding(
              padding: DesignTokens.paddingL,
              child: const CircularProgressIndicator(),
            ),
          );
        }

        final user = _users[index];
        final isSelected = widget.selectedUsers.contains(user.username);

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
              color: isSelected ? colorScheme.onSurface.withOpacity(DesignTokens.opacityDisabled) : colorScheme.onSurface,
              fontWeight: DesignTokens.fontWeightMedium,
            ),
          ),
          subtitle: user.postCount > 0
              ? Padding(
                  padding: EdgeInsets.only(top: DesignTokens.spacingXS / 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.comment_outlined,
                        size: textTheme.bodySmall?.fontSize ?? DesignTokens.fontSizeXS,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      SizedBox(width: DesignTokens.spacingXS),
                      Text(
                        formatNumber(context, user.postCount),
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          letterSpacing: DesignTokens.letterSpacingWide,
                        ),
                      ),
                    ],
                  ),
                )
              : null,
          enabled: !isSelected,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusM),
          ),
          onTap: isSelected
              ? null
              : () {
                  widget.onUserSelected(user.username, user.iconUrl);
                  Navigator.of(context).pop({
                    'username': user.username,
                    'iconUrl': user.iconUrl,
                  });
                },
        );
      },
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
