import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';
import 'package:forumcopilot_flutter/services/site_proxy_service.dart';
import '../models/cache_context.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/models/entities/fc_post.dart';
import 'package:forumcopilot_sdk/models/entities/fc_topic.dart';
import '../theme/design_tokens.dart';
import '../theme/style_builders.dart';
import 'listitems/topic_list_item.dart';
import 'lists/posts_list.dart';
import 'post_page.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import 'login_page.dart';

class SearchPage extends StatefulWidget {
  final SiteContext siteContext;
  const SearchPage({super.key, required this.siteContext});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<String> _searchHistory = [];
  List<String> _filteredHistory = [];

  // Search results state
  String? _currentQuery;
  int _selectedFilterIndex = 0; // 0 = All (Posts), 1 = Topics Only, 2 = Titles Only
  List<String> _getFilterLabels(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [l10n.all, l10n.topicsOnly, l10n.titlesOnly];
  }

  int _topicPage = 1;
  int _postPage = 1;
  int _titlesOnlyPage = 1;
  final int _pageSize = 20;
  bool _isLoadingTopics = false;
  bool _isLoadingPosts = false;
  bool _isLoadingTitlesOnly = false;
  bool _hasMoreTopics = true;
  bool _hasMorePosts = true;
  bool _hasMoreTitlesOnly = true;
  final List<FCTopic> _topics = [];
  final List<FCPost> _posts = [];
  final List<FCTopic> _titlesOnlyTopics = [];
  final ScrollController _topicScrollController = ScrollController();
  final ScrollController _postScrollController = ScrollController();
  final ScrollController _titlesOnlyScrollController = ScrollController();
  String? _postSearchId;
  String? _topicSearchId;
  String? _titlesOnlySearchId;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onInputChanged);
    _loadSearchHistory();
    _topicScrollController.addListener(_onTopicScroll);
    _postScrollController.addListener(_onPostScroll);
    _titlesOnlyScrollController.addListener(_onTitlesOnlyScroll);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onInputChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    _topicScrollController.dispose();
    _postScrollController.dispose();
    _titlesOnlyScrollController.dispose();
    super.dispose();
  }

  void _onTopicScroll() {
    if (_topicScrollController.position.pixels >= _topicScrollController.position.maxScrollExtent - 300 && !_isLoadingTopics && _hasMoreTopics && _currentQuery != null) {
      _fetchTopics();
    }
  }

  void _onPostScroll() {
    if (_postScrollController.position.pixels >= _postScrollController.position.maxScrollExtent - 300 && !_isLoadingPosts && _hasMorePosts && _currentQuery != null) {
      _fetchPosts();
    }
  }

  void _onTitlesOnlyScroll() {
    if (_titlesOnlyScrollController.position.pixels >= _titlesOnlyScrollController.position.maxScrollExtent - 300 && !_isLoadingTitlesOnly && _hasMoreTitlesOnly && _currentQuery != null) {
      _fetchTitlesOnly();
    }
  }

  Future<void> _loadSearchHistory() async {
    await CacheContext.instance.loadFromDevice();
    setState(() {
      _searchHistory = CacheContext.instance.getSearchHistory();
      _filteredHistory = _searchHistory.take(5).toList();
    });
  }

  void _onInputChanged() {
    final input = _searchController.text.trim().toLowerCase();
    setState(() {
      if (input.isEmpty) {
        _filteredHistory = _searchHistory.take(5).toList();
      } else {
        _filteredHistory = _searchHistory.where((q) => q.toLowerCase().contains(input)).take(5).toList();
      }
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _currentQuery = null;
      _topics.clear();
      _posts.clear();
      _titlesOnlyTopics.clear();
      _topicPage = 1;
      _postPage = 1;
      _titlesOnlyPage = 1;
      _hasMoreTopics = true;
      _hasMorePosts = true;
      _hasMoreTitlesOnly = true;
      _postSearchId = null;
      _topicSearchId = null;
      _titlesOnlySearchId = null;
    });
    _searchFocusNode.requestFocus();
  }

  void _performSearch(String query) async {
    if (query.isEmpty) return;

    final trimmedQuery = query.trim();
    if (trimmedQuery == _currentQuery) return; // Don't re-search the same query

    await CacheContext.instance.addSearchQuery(trimmedQuery);
    setState(() {
      _searchHistory = CacheContext.instance.getSearchHistory();
      _onInputChanged(); // re-filter after adding
      _currentQuery = trimmedQuery;
      _searchController.text = trimmedQuery;
      // Reset search state
      _topics.clear();
      _posts.clear();
      _titlesOnlyTopics.clear();
      _topicPage = 1;
      _postPage = 1;
      _titlesOnlyPage = 1;
      _hasMoreTopics = true;
      _hasMorePosts = true;
      _hasMoreTitlesOnly = true;
      _postSearchId = null;
      _topicSearchId = null;
      _titlesOnlySearchId = null;
    });

    // Fetch results
    _fetchTopics();
    _fetchPosts();
    _fetchTitlesOnly();
  }

  Future<void> _fetchTopics() async {
    if (_isLoadingTopics || !_hasMoreTopics || _currentQuery == null) return;
    setState(() {
      _isLoadingTopics = true;
    });
    final hasAdvancedSearch = widget.siteContext.ConfigData.advancedSearch == true;
    final proxy = SiteProxyService.getSearchProxy();

    if (!hasAdvancedSearch) {
      final startNum = (_topicPage - 1) * _pageSize;
      final lastNum = _topicPage * _pageSize;
      final result = await proxy.searchTopicAsync(_currentQuery!, startNum, lastNum, null);
      if (!mounted) return;
      setState(() {
        _topics.addAll(result.topics);
        _isLoadingTopics = false;
        _hasMoreTopics = result.topics.length == _pageSize;
        if (_hasMoreTopics) _topicPage++;
      });
    } else {
      // Use advanced search for topics
      final result = await proxy.advanceSearchTopicAsync(
        _currentQuery!, // keywords
        _topicPage, // page
        _pageSize, // perpage
        _topicSearchId, // searchId for pagination
        false, // titleOnly
        null, // userId
        null, // searchUser
        null, // forumId
        null, // topicId
        null, // onlyIn
        null, // notIn
        false, // startedBy
        null, // searchTime
      );
      // Only update searchId if this is the first page
      if (_topicSearchId == null && result.search_id != null && result.search_id!.isNotEmpty) {
        _topicSearchId = result.search_id;
      }
      if (!mounted) return;
      setState(() {
        _topics.addAll(result.topics);
        _isLoadingTopics = false;
        _hasMoreTopics = result.topics.length == _pageSize;
        if (_hasMoreTopics) _topicPage++;
      });
    }
  }

  Future<void> _fetchPosts() async {
    if (_isLoadingPosts || !_hasMorePosts || _currentQuery == null) return;
    setState(() {
      _isLoadingPosts = true;
    });
    final hasAdvancedSearch = widget.siteContext.ConfigData.advancedSearch == true;
    final proxy = SiteProxyService.getSearchProxy();
    if (!hasAdvancedSearch) {
      final startNum = (_postPage - 1) * _pageSize;
      final lastNum = _postPage * _pageSize;
      final result = await proxy.searchPostAsync(_currentQuery!, startNum, lastNum, '');
      if (!mounted) return;
      setState(() {
        _posts.addAll(result.posts);
        _isLoadingPosts = false;
        _hasMorePosts = result.posts.length == _pageSize;
        if (_hasMorePosts) _postPage++;
      });
    } else {
      // Use advanced search for posts
      final result = await proxy.advanceSearchPostAsync(
        _currentQuery!, // keywords
        _postPage, // page
        _pageSize, // perpage
        _postSearchId, // searchId for pagination
        false, // titleOnly
        null, // userId
        null, // searchUser
        null, // forumId
        null, // topicId
        null, // onlyIn
        null, // notIn
        false, // startedBy
      );
      // Only update searchId if this is the first page
      if (_postSearchId == null && result.search_id != null && result.search_id!.isNotEmpty) {
        _postSearchId = result.search_id;
      }
      if (!mounted) return;
      setState(() {
        _posts.addAll(result.posts);
        _isLoadingPosts = false;
        _hasMorePosts = result.posts.length == _pageSize;
        if (_hasMorePosts) _postPage++;
      });
    }
  }

  Future<void> _fetchTitlesOnly() async {
    if (_isLoadingTitlesOnly || !_hasMoreTitlesOnly || _currentQuery == null) return;
    setState(() {
      _isLoadingTitlesOnly = true;
    });
    final hasAdvancedSearch = widget.siteContext.ConfigData.advancedSearch == true;
    final proxy = SiteProxyService.getSearchProxy();

    if (!hasAdvancedSearch) {
      // If advanced search is not available, fall back to regular topic search
      final startNum = (_titlesOnlyPage - 1) * _pageSize;
      final lastNum = _titlesOnlyPage * _pageSize;
      final result = await proxy.searchTopicAsync(_currentQuery!, startNum, lastNum, null);
      if (!mounted) return;
      setState(() {
        _titlesOnlyTopics.addAll(result.topics);
        _isLoadingTitlesOnly = false;
        _hasMoreTitlesOnly = result.topics.length == _pageSize;
        if (_hasMoreTitlesOnly) _titlesOnlyPage++;
      });
    } else {
      // Use advanced search with titleOnly = true
      final result = await proxy.advanceSearchTopicAsync(
        _currentQuery!, // keywords
        _titlesOnlyPage, // page
        _pageSize, // perpage
        _titlesOnlySearchId, // searchId for pagination
        true, // titleOnly - this is the key difference
        null, // userId
        null, // searchUser
        null, // forumId
        null, // topicId
        null, // onlyIn
        null, // notIn
        false, // startedBy
        null, // searchTime
      );
      // Only update searchId if this is the first page
      if (_titlesOnlySearchId == null && result.search_id != null && result.search_id!.isNotEmpty) {
        _titlesOnlySearchId = result.search_id;
      }
      if (!mounted) return;
      setState(() {
        _titlesOnlyTopics.addAll(result.topics);
        _isLoadingTitlesOnly = false;
        _hasMoreTitlesOnly = result.topics.length == _pageSize;
        if (_hasMoreTitlesOnly) _titlesOnlyPage++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)?.search ?? 'Search',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: DesignTokens.fontWeightMedium,
          ),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 3,
        shadowColor: colorScheme.shadow.withOpacity(0.3),
        surfaceTintColor: colorScheme.surfaceTint,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: DesignTokens.paddingL,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: colorScheme.outlineVariant.withOpacity(0.3),
                  width: 1,
                ),
              ),
            ),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)?.enterKeywordsToSearchTopics ?? 'Enter keywords to search topics...',
                hintStyle: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: colorScheme.onSurfaceVariant,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear_rounded,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        onPressed: _currentQuery != null
                            ? _clearSearch
                            : () {
                                _searchController.clear();
                                _searchFocusNode.requestFocus();
                              },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                  borderSide: BorderSide(
                    color: colorScheme.outlineVariant,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                  borderSide: BorderSide(
                    color: colorScheme.outlineVariant,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                  borderSide: BorderSide(
                    color: colorScheme.primary,
                    width: DesignTokens.borderWidthMedium,
                  ),
                ),
                filled: true,
                fillColor: colorScheme.surfaceVariant.withOpacity(DesignTokens.opacityLow),
                contentPadding: DesignTokens.paddingInput,
              ),
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  _performSearch(value.trim());
                }
              },
            ),
          ),
          // Content: Either search history or results
          Expanded(
            child: _currentQuery == null ? _buildSearchHistory(colorScheme, textTheme) : _buildSearchResults(colorScheme, textTheme),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchHistory(ColorScheme colorScheme, TextTheme textTheme) {
    if (_filteredHistory.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_outlined,
              size: 64,
              color: colorScheme.onSurfaceVariant.withOpacity(0.5),
            ),
            const SizedBox(height: DesignTokens.spacingL),
            Text(
              'Search for topics',
              style: StyleBuilders.titleTextStyle(
                colorScheme: colorScheme,
                textTheme: textTheme,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingS),
            Text(
              AppLocalizations.of(context)?.enterKeywordsToFindTopicsAndPosts ?? 'Enter keywords to find topics and posts',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: DesignTokens.paddingVerticalS,
      itemCount: _filteredHistory.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingL, vertical: DesignTokens.spacingXS),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingL, vertical: DesignTokens.spacingS),
            leading: Icon(
              Icons.history_rounded,
              color: colorScheme.onSurfaceVariant,
              size: DesignTokens.iconSizeM,
            ),
            title: Text(
              _filteredHistory[index],
              style: StyleBuilders.bodyTextStyle(
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
            ),
            trailing: Icon(
              Icons.arrow_upward_rounded,
              color: colorScheme.onSurfaceVariant,
              size: DesignTokens.iconSizeS,
            ),
            onTap: () => _performSearch(_filteredHistory[index]),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(DesignTokens.radiusM),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchResults(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      children: [
        // Filter Chips
        _buildFilterChips(colorScheme, textTheme),
        // Content
        Expanded(
          child: _selectedFilterIndex == 0
              ? _buildPostsTab(colorScheme, textTheme)
              : _selectedFilterIndex == 1
                  ? _buildTopicsTab(colorScheme, textTheme)
                  : _buildTitlesOnlyTab(colorScheme, textTheme),
        ),
      ],
    );
  }

  Widget _buildFilterChips(ColorScheme colorScheme, TextTheme textTheme) {
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
                setState(() {
                  _selectedFilterIndex = index;
                });
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

  Widget _buildTopicsTab(ColorScheme colorScheme, TextTheme textTheme) {
    if (_isLoadingTopics && _topics.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_topics.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.topic_outlined,
              size: 48,
              color: colorScheme.onSurfaceVariant.withOpacity(0.5),
            ),
            const SizedBox(height: DesignTokens.spacingL),
            Text(
              'No topics found',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingS),
            Text(
              'Try searching with different keywords',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _topicScrollController,
      itemCount: _topics.length + (_hasMoreTopics ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < _topics.length) {
          final t = _topics[index];
          return TopicListItem(
            siteContext: widget.siteContext,
            topic: t,
            onTap: () async {
              if (!widget.siteContext.isLoggedIn) {
                if (!Get.isRegistered<LoginController>()) {
                  Get.put(LoginController());
                }
                final loginController = Get.find<LoginController>();
                final loginResult = await loginController.attemptAutomaticLogin(widget.siteContext);
                if (!loginResult.success && loginResult.hadCredentials && Get.currentRoute != '/LoginPage') {
                  await Get.to(() => LoginPage(siteContext: widget.siteContext));
                }
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostPage(
                    siteContext: widget.siteContext,
                    topicId: t.id,
                    title: t.title,
                  ),
                ),
              );
            },
          );
        } else {
          return const Padding(
            padding: DesignTokens.paddingL,
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  Widget _buildPostsTab(ColorScheme colorScheme, TextTheme textTheme) {
    if (_isLoadingPosts && _posts.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.message_outlined,
              size: 48,
              color: colorScheme.onSurfaceVariant.withOpacity(0.5),
            ),
            const SizedBox(height: DesignTokens.spacingL),
            Text(
              'No posts found',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingS),
            Text(
              'Try searching with different keywords',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _postScrollController,
      itemCount: _posts.length + (_hasMorePosts ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < _posts.length) {
          final p = _posts[index];
          return TopicListItem(
            siteContext: widget.siteContext,
            topic: FCTopic(
              id: p.topicId,
              title: p.topicTitle ?? p.title,
              shortContent: p.content,
              timestamp: p.timestamp ?? DateTime.now(),
              authorId: p.authorId,
              authorName: p.authorName,
              authorIconUrl: p.authorIconUrl ?? '',
              authorUserType: p.authorUserType,
              forumId: p.topicId, // Use topicId as forumId for now
              forumName: '', // No forum name in FCPost
              replyCount: 0,
              isPinned: false,
              isAnnouncement: false,
              isSubscribed: false,
            ),
            onTap: () async {
              if (!widget.siteContext.isLoggedIn) {
                if (!Get.isRegistered<LoginController>()) {
                  Get.put(LoginController());
                }
                final loginController = Get.find<LoginController>();
                final loginResult = await loginController.attemptAutomaticLogin(widget.siteContext);
                if (!loginResult.success && loginResult.hadCredentials && Get.currentRoute != '/LoginPage') {
                  await Get.to(() => LoginPage(siteContext: widget.siteContext));
                }
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostPage(
                    siteContext: widget.siteContext,
                    topicId: p.topicId,
                    title: p.topicTitle ?? p.title,
                    mode: PostsListMode.thread_by_post,
                    anchorPostId: p.id,
                    forumId: p.topicId,
                  ),
                ),
              );
            },
          );
        } else {
          return const Padding(
            padding: DesignTokens.paddingL,
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  Widget _buildTitlesOnlyTab(ColorScheme colorScheme, TextTheme textTheme) {
    if (_isLoadingTitlesOnly && _titlesOnlyTopics.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_titlesOnlyTopics.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.title_outlined,
              size: 48,
              color: colorScheme.onSurfaceVariant.withOpacity(0.5),
            ),
            const SizedBox(height: DesignTokens.spacingL),
            Text(
              'No topics found',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingS),
            Text(
              'Try searching with different keywords',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _titlesOnlyScrollController,
      itemCount: _titlesOnlyTopics.length + (_hasMoreTitlesOnly ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < _titlesOnlyTopics.length) {
          final t = _titlesOnlyTopics[index];
          return TopicListItem(
            siteContext: widget.siteContext,
            topic: t,
            onTap: () async {
              if (!widget.siteContext.isLoggedIn) {
                if (!Get.isRegistered<LoginController>()) {
                  Get.put(LoginController());
                }
                final loginController = Get.find<LoginController>();
                final loginResult = await loginController.attemptAutomaticLogin(widget.siteContext);
                if (!loginResult.success && loginResult.hadCredentials && Get.currentRoute != '/LoginPage') {
                  await Get.to(() => LoginPage(siteContext: widget.siteContext));
                }
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostPage(
                    siteContext: widget.siteContext,
                    topicId: t.id,
                    title: t.title,
                  ),
                ),
              );
            },
          );
        } else {
          return const Padding(
            padding: DesignTokens.paddingL,
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
