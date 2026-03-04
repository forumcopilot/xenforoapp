import 'package:flutter/material.dart';
import 'package:forumcopilot_flutter/views/widgets/resettable_widget.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/factory/site_proxy_factory.dart';
import 'package:forumcopilot_sdk/models/results/fc_private_conversation_result.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:forumcopilot_flutter/views/widgets/not_signed_in_view.dart';
import '../../../../utils/time_utils.dart';
import '../../../../theme/design_tokens.dart';
import '../../../../theme/style_builders.dart';
import 'package:forumcopilot_flutter/core/logging/app_logger.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../pages/conversation_page.dart';
import 'conversation_list_item.dart';

class ConversationList extends StatefulWidget {
  final SiteContext siteContext;

  const ConversationList({super.key, required this.siteContext});

  @override
  ConversationListState createState() => ConversationListState();
}

class ConversationListState extends State<ConversationList> with AutomaticKeepAliveClientMixin {
  List<FCConversationSummary>? _conversations;
  String? _error;
  bool _isLoading = true;
  bool _hasLoaded = false;

  // Add authentication state tracking
  bool _wasLoggedIn = false;
  String? _lastLoadedUsername;
  late final VoidCallback _authStateListener;

  // Pagination state
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  int _currentPage = 0;
  final int _itemsPerPage = 20;
  final ScrollController _scrollController = ScrollController();

  // Track when we last became visible to refresh on return
  bool _wasVisible = false;
  
  // Track last logged values to reduce debug noise
  int? _lastLoggedConversationsCount;
  bool? _lastLoggedIsLoading;
  bool? _lastLoggedHasLoaded;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _wasLoggedIn = widget.siteContext.isLoggedIn;
    _lastLoadedUsername = widget.siteContext.loginDataOutput?.user?.username;

    _scrollController.addListener(_onScroll);

    // Listen to login state changes
    _authStateListener = () {
      final isLoggedInStatus = widget.siteContext.isLoggedIn;
      final currentUsername = widget.siteContext.loginDataOutput?.user?.username;

      AppLogger.debug('🔔 [CONVERSATION_LIST] Auth state listener triggered');
      AppLogger.debug('   - isLoggedInStatus: $isLoggedInStatus');
      AppLogger.debug('   - currentUsername: $currentUsername');
      AppLogger.debug('   - _wasLoggedIn: $_wasLoggedIn');
      AppLogger.debug('   - _lastLoadedUsername: $_lastLoadedUsername');

      if (isLoggedInStatus) {
        if (!_wasLoggedIn || _lastLoadedUsername != currentUsername) {
          AppLogger.debug('📋 [CONVERSATION_LIST] Auth state changed - resetting and reloading');
          _hasLoaded = false;
          _wasLoggedIn = isLoggedInStatus;
          _lastLoadedUsername = currentUsername;
          if (mounted) {
            loadConversations();
          }
        }
      } else if (!isLoggedInStatus && _wasLoggedIn) {
        AppLogger.debug('📋 [CONVERSATION_LIST] User logged out - clearing data');
        _hasLoaded = false;
        _wasLoggedIn = false;
        _lastLoadedUsername = null;
        if (mounted) {
          setState(() {
            _conversations = null;
            _isLoading = false;
            _error = null;
          });
        }
      }
    };

    widget.siteContext.isLoggedInNotifier.addListener(_authStateListener);
  }

  bool _shouldLoadConversations() {
    final currentUsername = widget.siteContext.loginDataOutput?.user?.username;

    if (!_hasLoaded && widget.siteContext.isLoggedIn) {
      return true;
    }

    if (_wasLoggedIn != widget.siteContext.isLoggedIn) {
      return true;
    }

    if (widget.siteContext.isLoggedIn && _lastLoadedUsername != currentUsername) {
      return true;
    }

    return false;
  }

  Future<void> loadConversations() async {
    final currentUsername = widget.siteContext.loginDataOutput?.user?.username;

    if (!widget.siteContext.isLoggedIn) {
      setState(() {
        _isLoading = false;
        _conversations = null;
        _error = null;
        _hasLoaded = false;
      });
      _wasLoggedIn = false;
      _lastLoadedUsername = null;
      return;
    }

    _wasLoggedIn = widget.siteContext.isLoggedIn;
    _lastLoadedUsername = currentUsername;

    AppLogger.debug('\n[ConversationList] Loading conversations');

    try {
      setState(() {
        _isLoading = true;
        _error = null;
        _currentPage = 0;
        _hasMoreData = true;
      });

      await _loadConversations();

      _hasLoaded = true;
    } catch (e, stackTrace) {
      AppLogger.debug('[ConversationList] Error loading conversations:');
      AppLogger.debug('  Error: $e');
      AppLogger.debug('  Stack trace: $stackTrace');

      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadConversations() async {
    final startNum = _currentPage * _itemsPerPage;
    final lastNum = startNum + _itemsPerPage - 1;
    AppLogger.debug('[ConversationList] Loading conversations (page $_currentPage, startNum: $startNum, lastNum: $lastNum)');
    final conversationProxy = SiteProxyFactory.getPrivateConversationProxy();

    final conversationsData = await conversationProxy.getConversationsAsync(startNum, lastNum);
    AppLogger.debug('[ConversationList] Conversations received: ${conversationsData.list.length} conversations');

    if (mounted) {
      AppLogger.debug('   - Setting state with ${conversationsData.list.length} conversations');
      setState(() {
        if (_currentPage == 0) {
          _conversations = conversationsData.list;
        } else {
          _conversations = [...(_conversations ?? []), ...conversationsData.list];
        }
        _isLoading = false;
        _hasMoreData = conversationsData.list.length == _itemsPerPage;
      });
      AppLogger.debug('   - State updated: conversations=${_conversations?.length ?? "null"}, isLoading=$_isLoading');
    } else {
      AppLogger.debug('   - Widget not mounted, skipping setState');
    }
  }

  void resetAndLoadConversations() {
    _hasLoaded = false;
    _currentPage = 0;
    _hasMoreData = true;
    _isLoadingMore = false;
    loadConversations();
  }

  Future<void> _deleteConversation(String conversationId) async {
    try {
      final conversationProxy = SiteProxyFactory.getPrivateConversationProxy();
      await conversationProxy.leaveConversationAsync(conversationId, 1); // 1 = soft leave

      if (mounted) {
        setState(() {
          _conversations?.removeWhere((conversation) => conversation.conv_id == conversationId);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)?.failedToLeaveConversation(e.toString()) ?? 'Failed to leave conversation: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _onConversationTap(FCConversationSummary conversation) async {
    // Use messageId if available to navigate directly to the appropriate message
    // Otherwise, calculate the last page to open at the most recent messages
    final pageSize = 20;
    int? lastPageStartNum;
    
    if (conversation.messageId != null && conversation.messageId!.isNotEmpty) {
      // messageId is available - will use getConversationByMessageAsync in ConversationPage
      // No need to calculate initialStartNum
    } else {
      // Fallback: calculate the last page
      final replyCount = int.tryParse(conversation.reply_count ?? '0') ?? 0;
      final totalMessages = replyCount + 1; // replies + first message
      lastPageStartNum = totalMessages > pageSize ? totalMessages - pageSize : 0;
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConversationPage(
          siteContext: widget.siteContext,
          conversationId: conversation.conv_id ?? '',
          subject: conversation.subject ?? (AppLocalizations.of(context)?.noSubject ?? 'No subject'),
          initialStartNum: lastPageStartNum,
          anchorMessageId: conversation.messageId, // Use messageId to navigate to specific message
          onMarkUnread: () {
            final index = _conversations!.indexWhere((c) => c.conv_id == conversation.conv_id);
            if (index != -1) {
              setState(() {
                _conversations![index] = _conversations![index].copyWith(
                  newPost: true,
                );
              });
            }
          },
        ),
      ),
    );

    // Refresh the conversation list when returning from conversation page
    if (mounted) {
      AppLogger.debug('[ConversationList] Refreshing conversation list after returning from conversation');
      await loadConversations();
    }

    // If the conversation was left (result is true), remove it from the list
    if (result == true && mounted) {
      setState(() {
        _conversations?.removeWhere((c) => c.conv_id == conversation.conv_id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // Only log when state meaningfully changes to reduce noise
    final currentConversationsCount = _conversations?.length;
    final currentIsLoading = _isLoading;
    final currentHasLoaded = _hasLoaded;
    if (_lastLoggedConversationsCount != currentConversationsCount || 
        _lastLoggedIsLoading != currentIsLoading || 
        _lastLoggedHasLoaded != currentHasLoaded) {
      AppLogger.debug('🏗️ [CONVERSATION_LIST] build() called');
      AppLogger.debug('   - isLoggedIn: ${widget.siteContext.isLoggedIn}');
      AppLogger.debug('   - conversations: ${currentConversationsCount ?? "null"}');
      AppLogger.debug('   - isLoading: $currentIsLoading');
      AppLogger.debug('   - hasLoaded: $currentHasLoaded');
      _lastLoggedConversationsCount = currentConversationsCount;
      _lastLoggedIsLoading = currentIsLoading;
      _lastLoggedHasLoaded = currentHasLoaded;
    }

    return VisibilityDetector(
      key: const Key('conversation_list'),
      onVisibilityChanged: (VisibilityInfo info) {
        final isVisible = info.visibleFraction > 0.5;

        _wasVisible = isVisible;

        // Only load conversations if they haven't been loaded yet (initial load)
        // Don't auto-refresh when returning from navigation - user can pull to refresh
        if (isVisible && _shouldLoadConversations()) {
          loadConversations();
        }
      },
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.siteContext.isLoggedInNotifier,
      builder: (context, isLoggedIn, child) {
        if (!isLoggedIn) {
          return NotSignedInView(
            siteContext: widget.siteContext,
            title: AppLocalizations.of(context)?.signInToViewMessages ?? 'Sign in to view messages',
            message: AppLocalizations.of(context)?.youNeedToBeSignedInToViewConversations ?? 'You need to be signed in to view your conversations.',
            icon: Icons.mail_outline_rounded,
          );
        }

        return _buildConversationsContent(context);
      },
    );
  }

  Widget _buildConversationsContent(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)?.errorLoadingConversations(_error ?? 'Unknown error') ?? 'Error loading conversations: $_error',
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            const SizedBox(height: DesignTokens.spacingL),
            FilledButton(
              onPressed: loadConversations,
              child: Text(AppLocalizations.of(context)?.retry ?? 'Retry'),
            ),
          ],
        ),
      );
    }

    if (_conversations == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_conversations!.isEmpty) {
      final colorScheme = Theme.of(context).colorScheme;
      final textTheme = Theme.of(context).textTheme;
      return RefreshIndicator(
        onRefresh: loadConversations,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: Padding(
                    padding: DesignTokens.paddingScreen,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 80,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(height: DesignTokens.spacingXL),
                        Text(
                          AppLocalizations.of(context)?.noConversations ?? "No conversations",
                          style: textTheme.headlineSmall?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: DesignTokens.fontWeightBold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: DesignTokens.spacingS),
                        Text(
                          AppLocalizations.of(context)?.noConversationsMessage ?? 'You have no conversations yet. Start a new conversation to begin messaging.',
                          style: textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: loadConversations,
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: DesignTokens.paddingVerticalS,
        itemCount: _conversations!.length + 1,
        itemBuilder: (context, index) {
          if (index < _conversations!.length) {
            final conversation = _conversations![index];
            return ConversationListItem(
              conversation: conversation,
              onTap: () => _onConversationTap(conversation),
              onDelete: () => _deleteConversation(conversation.conv_id ?? ''),
            );
          } else {
            if (_hasMoreData) {
              return Padding(
                padding: DesignTokens.paddingS,
                child: const Center(child: CircularProgressIndicator()),
              );
            } else {
              return const SizedBox.shrink();
            }
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    widget.siteContext.isLoggedInNotifier.removeListener(_authStateListener);
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      _loadMoreData();
    }
  }

  Future<void> _loadMoreData() async {
    if (_isLoadingMore || !_hasMoreData) return;

    _isLoadingMore = true;
    try {
      await _loadMoreConversations();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)?.errorLoadingMoreConversations(e.toString()) ?? 'Error loading more conversations: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
  }

  Future<void> _loadMoreConversations() async {
    AppLogger.debug('[ConversationList] Loading more conversations (page ${_currentPage + 1})');
    final conversationProxy = SiteProxyFactory.getPrivateConversationProxy();

    final nextPage = _currentPage + 1;
    final startNum = nextPage * _itemsPerPage;
    final lastNum = startNum + _itemsPerPage - 1;
    final conversationsData = await conversationProxy.getConversationsAsync(startNum, lastNum);
    AppLogger.debug('[ConversationList] More conversations received: ${conversationsData.list.length} conversations');

    if (mounted) {
      setState(() {
        _conversations!.addAll(conversationsData.list);
        _currentPage = nextPage;
        _hasMoreData = conversationsData.list.length >= _itemsPerPage;
      });
    }
  }
}
