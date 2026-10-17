import 'package:flutter/material.dart';
import 'package:forumcopilot_flutter/views/widgets/user_avatar.dart';
import 'package:forumcopilot_flutter/views/widgets/search_text_field.dart';
import 'package:forumcopilot_flutter/views/widgets/empty_state_widget.dart';
import 'package:forumcopilot_flutter/views/widgets/error_state_widget.dart';
import 'package:forumcopilot_flutter/views/user_profile_page.dart';
import 'package:forumcopilot_flutter/l10n/generated/app_localizations.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/factory/site_proxy_factory.dart';
import 'package:forumcopilot_sdk/models/results/fc_user_result.dart';
import '../../theme/design_tokens.dart';
import '../../utils/number_utils.dart';

class MemberSearchPage extends StatefulWidget {
  const MemberSearchPage({
    required this.siteContext,
    super.key,
  });
  final SiteContext siteContext;

  @override
  State<MemberSearchPage> createState() => _MemberSearchPageState();
}

class _MemberSearchPageState extends State<MemberSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<FCSearchUser> _searchResults = [];
  bool _isLoading = false;
  String? _error;
  bool _hasSearched = false;
  int _currentPage = 1;
  final int _pageSize = 20;
  bool _hasMore = true;
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
        _performSearch();
      }
    }
  }

  Future<void> _loadDefaultUsers() async {
    await _performSearch(reset: true);
  }

  Future<void> _performSearch({bool reset = false}) async {
    final query = _searchController.text.trim();
    
    if (_isLoading) return;

    if (reset) {
      setState(() {
        _currentPage = 1;
        _hasMore = true;
        _searchResults = [];
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
          _searchResults = result.list;
        } else {
          _searchResults = [..._searchResults, ...result.list];
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
    _performSearch(reset: true);
  }

  void _handleClear() {
    setState(() {
      _currentPage = 1;
      _hasMore = true;
    });
    // Load default list when cleared
    _performSearch(reset: true);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)?.lookupMembers ?? 'Lookup Members',
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
                  color: colorScheme.outlineVariant.withValues(alpha: DesignTokens.opacityLow),
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
          Expanded(
            child: _buildSearchResults(colorScheme, textTheme),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(ColorScheme colorScheme, TextTheme textTheme) {
    if (_error != null) {
      return ErrorStateWidget(
        title: AppLocalizations.of(context)?.searchFailed ?? 'Search failed',
        message: _error!,
      );
    }

    if (_isLoading && _searchResults.isEmpty) {
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
      itemCount: _searchResults.length + (_hasMore ? 1 : 0),
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
        return ListTile(
          contentPadding: EdgeInsets.symmetric(
            horizontal: DesignTokens.spacingL,
            vertical: DesignTokens.spacingS,
          ),
          leading: UserAvatar(
            username: member.username,
            iconUrl: member.iconUrl,
            radius: DesignTokens.avatarRadiusM,
            showOnlineIndicator: true,
            isOnline: member.isOnline,
          ),
          title: Text(
            member.username,
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: DesignTokens.fontWeightMedium,
            ),
          ),
          subtitle: member.postCount > 0
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
                        formatNumber(context, member.postCount),
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          letterSpacing: DesignTokens.letterSpacingWide,
                        ),
                      ),
                    ],
                  ),
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
                  userId: member.id,
                  userName: member.username,
                  profilePictureUrl: member.iconUrl,
                ),
              ),
            );
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

