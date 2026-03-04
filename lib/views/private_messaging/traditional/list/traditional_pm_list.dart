import 'package:flutter/material.dart';
import '../../../../l10n/generated/app_localizations.dart';
import 'package:forumcopilot_flutter/views/widgets/resettable_widget.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/factory/site_proxy_factory.dart';
import 'package:forumcopilot_sdk/models/results/fc_private_message_result.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:forumcopilot_flutter/views/widgets/not_signed_in_view.dart';
import '../../../../utils/time_utils.dart';
import '../../../../theme/design_tokens.dart';
import '../../../../theme/style_builders.dart';
import 'package:forumcopilot_flutter/core/logging/app_logger.dart';
import '../pages/traditional_pm_page.dart';
import 'traditional_pm_list_item.dart';

class TraditionalPMList extends StatefulWidget {
  final SiteContext siteContext;
  final bool isInbox;

  const TraditionalPMList({super.key, required this.siteContext, required this.isInbox});

  @override
  TraditionalPMListState createState() => TraditionalPMListState();
}

class TraditionalPMListState extends State<TraditionalPMList> with AutomaticKeepAliveClientMixin {
  List<FCPrivateMessage>? _messages;
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

      AppLogger.debug('🔔 [TRADITIONAL_PM_LIST] Auth state listener triggered');
      AppLogger.debug('   - isLoggedInStatus: $isLoggedInStatus');
      AppLogger.debug('   - currentUsername: $currentUsername');
      AppLogger.debug('   - _wasLoggedIn: $_wasLoggedIn');
      AppLogger.debug('   - _lastLoadedUsername: $_lastLoadedUsername');

      if (isLoggedInStatus) {
        if (!_wasLoggedIn || _lastLoadedUsername != currentUsername) {
          AppLogger.debug('📋 [TRADITIONAL_PM_LIST] Auth state changed - resetting and reloading');
          _hasLoaded = false;
          _wasLoggedIn = isLoggedInStatus;
          _lastLoadedUsername = currentUsername;
          if (mounted) {
            loadMessages();
          }
        }
      } else if (!isLoggedInStatus && _wasLoggedIn) {
        AppLogger.debug('📋 [TRADITIONAL_PM_LIST] User logged out - clearing data');
        _hasLoaded = false;
        _wasLoggedIn = false;
        _lastLoadedUsername = null;
        if (mounted) {
          setState(() {
            _messages = null;
            _isLoading = false;
            _error = null;
          });
        }
      }
    };

    widget.siteContext.isLoggedInNotifier.addListener(_authStateListener);
  }

  bool _shouldLoadMessages() {
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

  Future<void> loadMessages() async {
    final currentUsername = widget.siteContext.loginDataOutput?.user?.username;

    if (!widget.siteContext.isLoggedIn) {
      setState(() {
        _isLoading = false;
        _messages = null;
        _error = null;
        _hasLoaded = false;
      });
      _wasLoggedIn = false;
      _lastLoadedUsername = null;
      return;
    }

    _wasLoggedIn = widget.siteContext.isLoggedIn;
    _lastLoadedUsername = currentUsername;

    AppLogger.debug('\n[TraditionalPMList] Loading messages - isInbox: ${widget.isInbox}');

    try {
      setState(() {
        _isLoading = true;
        _error = null;
        _currentPage = 0;
        _hasMoreData = true;
      });

      await _loadPrivateMessages();

      _hasLoaded = true;
    } catch (e, stackTrace) {
      AppLogger.debug('[TraditionalPMList] Error loading messages:');
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

  Future<void> _loadPrivateMessages() async {
    AppLogger.debug('[TraditionalPMList] Loading private messages (page $_currentPage)');
    final pmProxy = SiteProxyFactory.getPrivateMessageProxy();

    AppLogger.debug('[TraditionalPMList] Getting box info');
    final boxInfo = await pmProxy.getBoxInfoAsync();
    AppLogger.debug('[TraditionalPMList] Box info received: ${boxInfo.list.length} boxes');

    final targetBox = boxInfo.list.firstWhere(
      (box) => widget.isInbox ? box.boxType == 'INBOX' : box.boxType == 'SENT',
      orElse: () => throw Exception('Box not found'),
    );

    final startNum = _currentPage * _itemsPerPage;
    final endNum = startNum + _itemsPerPage - 1;
    AppLogger.debug('[TraditionalPMList] Getting messages from box: ${targetBox.box_id} (startNum: $startNum, endNum: $endNum)');
    final boxData = await pmProxy.getBoxAsync(targetBox.box_id ?? '', startNum, endNum);
    AppLogger.debug('[TraditionalPMList] Messages received: ${boxData.list.length} messages');

    if (mounted) {
      setState(() {
        _messages = boxData.list;
        _isLoading = false;
        _hasMoreData = boxData.list.length >= _itemsPerPage;
      });
    }
  }

  void resetAndLoadMessages() {
    _hasLoaded = false;
    _currentPage = 0;
    _hasMoreData = true;
    _isLoadingMore = false;
    loadMessages();
  }

  Future<void> _deleteMessage(String messageId, String boxId) async {
    try {
      final pmProxy = SiteProxyFactory.getPrivateMessageProxy();
      await pmProxy.deleteMessageAsync(messageId, boxId);

      if (mounted) {
        setState(() {
          _messages?.removeWhere((message) => message.msg_id == messageId);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)?.failedToDeleteMessage(e.toString()) ?? 'Failed to delete message: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _onMessageTap(FCPrivateMessage message) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TraditionalPMPage(
          siteContext: widget.siteContext,
          messageId: message.msg_id ?? '',
          boxId: widget.isInbox ? "INBOX" : "SENTBOX",
          subject: message.msg_subject ?? '',
          onMarkUnread: () {
            final index = _messages!.indexWhere((m) => m.msg_id == message.msg_id);
            if (index != -1) {
              setState(() {
                _messages![index] = _messages![index].copyWith(msgState: 1);
              });
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    AppLogger.debug('🏗️ [TRADITIONAL_PM_LIST] build() called');
    AppLogger.debug('   - isLoggedIn: ${widget.siteContext.isLoggedIn}');
    AppLogger.debug('   - messages: ${_messages?.length ?? "null"}');
    AppLogger.debug('   - isLoading: $_isLoading');
    AppLogger.debug('   - hasLoaded: $_hasLoaded');

    return VisibilityDetector(
      key: Key('traditional_pm_${widget.isInbox ? 'inbox' : 'sent'}'),
      onVisibilityChanged: (VisibilityInfo info) {
        final isVisible = info.visibleFraction > 0.5;
        _wasVisible = isVisible;

        if (isVisible && _shouldLoadMessages()) {
          loadMessages();
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
            message: 'You need to be signed in to view your private messages.',
            icon: Icons.mail_outline_rounded,
          );
        }

        final canPM = widget.siteContext.loginDataOutput?.user?.canPM ?? false;
        if (!canPM) {
          return NotSignedInView(
            siteContext: widget.siteContext,
            title: AppLocalizations.of(context)?.privateMessagesNotAvailable ?? 'Private messages not available',
            message: 'You do not have permission to use private messaging.',
            icon: Icons.mail_outline_rounded,
          );
        }

        return _buildMessagesContent(context);
      },
    );
  }

  Widget _buildMessagesContent(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error loading messages: $_error',
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            const SizedBox(height: DesignTokens.spacingL),
            FilledButton(
              onPressed: loadMessages,
              child: Text(AppLocalizations.of(context)?.retry ?? 'Retry'),
            ),
          ],
        ),
      );
    }

    if (_messages == null || _messages!.isEmpty) {
      return RefreshIndicator(
        onRefresh: loadMessages,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: Text(
                    'No ${widget.isInbox ? "inbox" : "sent"} messages',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
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
      onRefresh: loadMessages,
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: DesignTokens.paddingVerticalS,
        itemCount: _messages!.length + 1,
        itemBuilder: (context, index) {
          if (index < _messages!.length) {
            final message = _messages![index];
            return TraditionalPMListItem(
              message: message,
              onTap: () => _onMessageTap(message),
              msgState: message.msg_state ?? 0,
              isInbox: widget.isInbox,
              onDelete: () => _deleteMessage(message.msg_id ?? '', widget.isInbox ? "INBOX" : "SENTBOX"),
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
      await _loadMorePrivateMessages();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)?.errorLoadingMoreMessages(e.toString()) ?? 'Error loading more messages: $e'),
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

  Future<void> _loadMorePrivateMessages() async {
    AppLogger.debug('[TraditionalPMList] Loading more private messages (page ${_currentPage + 1})');
    final pmProxy = SiteProxyFactory.getPrivateMessageProxy();

    final boxInfo = await pmProxy.getBoxInfoAsync();
    final targetBox = boxInfo.list.firstWhere(
      (box) => widget.isInbox ? box.box_type == 'INBOX' : box.box_type == 'SENT',
      orElse: () => throw Exception('Box not found'),
    );

    final nextPage = _currentPage + 1;
    final startNum = nextPage * _itemsPerPage;
    final endNum = startNum + _itemsPerPage - 1;
    final boxData = await pmProxy.getBoxAsync(targetBox.box_id ?? '', startNum, endNum);

    if (mounted) {
      setState(() {
        _messages!.addAll(boxData.list);
        _currentPage = nextPage;
        _hasMoreData = boxData.list.length == _itemsPerPage;
      });
    }
  }
}
