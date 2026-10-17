import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../l10n/generated/app_localizations.dart';
import 'package:forumcopilot_sdk/factory/site_proxy_factory.dart';
import 'package:forumcopilot_sdk/models/entities/fc_reaction.dart';
import 'package:forumcopilot_flutter/views/widgets/reaction_picker.dart';
import 'package:forumcopilot_sdk/models/results/fc_private_conversation_result.dart';
import 'package:forumcopilot_sdk/models/entities/fc_like.dart';
import '../appbars/conversation_app_bar.dart';
import 'reply_conversation_page.dart';
import 'edit_conversation_page.dart';
import 'edit_conversation_message_page.dart';
import '../widgets/conversation_item.dart';
import '../widgets/conversation_header_widget.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import '../../../../theme/design_tokens.dart';
import '../../../../utils/accessibility_helpers.dart';
import 'package:get/get.dart';
import 'package:forumcopilot_flutter/controllers/login_controller.dart';
import '../../../login_page.dart';
import '../../../../utils/snackbar_helper.dart';
import '../../../../utils/app_navigation.dart';
import '../../../../services/notification_service.dart';

class ConversationPage extends StatefulWidget {
  final SiteContext siteContext;
  final String conversationId;
  final String subject;
  final VoidCallback? onMarkUnread;
  final int? initialStartNum;
  final String? anchorMessageId; // Message ID to navigate to and highlight

  const ConversationPage({
    Key? key,
    required this.siteContext,
    required this.conversationId,
    required this.subject,
    this.onMarkUnread,
    this.initialStartNum,
    this.anchorMessageId,
  }) : super(key: key);

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> with WidgetsBindingObserver {
  FCConversationResult? _conversation;
  String? _error;
  bool _isLoading = true;
  final ScrollController _scrollController = ScrollController();
  int _currentVisibleMessageIndex = 0;
  bool _showClosedBanner = true;
  bool _isLoadingMore = false;
  bool _hasMoreMessages = true;
  int _currentStartNum = 0;
  int _currentLastNum = 0; // Track the end of loaded range for proper pagination
  final int _pageSize = 20;
  String? _highlightedMessageId; // ID of message to highlight
  // Load around widget.anchorMessageId (the message a push or alert pointed
  // at) until the user replies; after that, loads show the newest messages.
  bool _anchored = true;
  Timer? _highlightTimer; // Timer to clear highlight after a few seconds
  // Whether the reader is at the newest message: content that grows under it
  // (images loading) keeps it there.
  bool _atBottom = true;
  bool _refreshingNewest = false;
  StreamSubscription<String>? _activitySub;

  @override
  void initState() {
    super.initState();
    _attemptAutoLoginAndLoad();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addObserver(this);
    NotificationService.openConversationId = widget.conversationId;
    // A push for this conversation while it is open brings the message in.
    _activitySub = NotificationService.conversationActivity.listen((id) {
      if (id == widget.conversationId || id == _conversation?.convId) _refreshNewest();
    });
  }

  // Back in the app: anything that arrived meanwhile.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _refreshNewest();
  }

  /// Brings in the messages newer than the last one loaded, without the
  /// full-screen spinner: after a reply, when the app comes back, on a push
  /// for this conversation. A reply used to reload the whole conversation
  /// behind a spinner.
  Future<void> _refreshNewest({bool scrollToEnd = false}) async {
    final current = _conversation;
    if (_refreshingNewest || _isLoading || current == null) return;
    _refreshingNewest = true;
    final stayAtEnd = scrollToEnd || _atBottom;
    try {
      final proxy = SiteProxyFactory.getPrivateConversationProxy();
      final id = current.convId;
      final meta = await proxy.getConversationAsync(id, 1, 1, false);
      if (!mounted || !meta.result) return;
      final total = meta.totalMessageNum ?? 0;
      final missing = total - _currentLastNum;
      if (missing <= 0) return;
      if (missing <= _pageSize) {
        final page = await proxy.getConversationAsync(id, _currentLastNum + 1, total, false);
        if (!mounted || !page.result || _conversation != current) return;
        final known = {for (final m in current.messages) m.messageId};
        final added = page.messages.where((m) => !known.contains(m.messageId)).toList();
        setState(() {
          _conversation = _withMessages(page, [...current.messages, ...added]);
          _currentLastNum = total;
          _hasMoreMessages = _currentStartNum > 1;
        });
      } else {
        // Too far behind to append: the newest page, as opening it shows.
        final start = math.max(1, total - _pageSize + 1);
        final page = await proxy.getConversationAsync(id, start, total, false);
        if (!mounted || !page.result || _conversation != current) return;
        setState(() {
          _conversation = page;
          _currentStartNum = start;
          _currentLastNum = total;
          _hasMoreMessages = start > 1;
        });
      }
      if (stayAtEnd) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
    } catch (e) {
      debugPrint('ConversationPage: refreshing the newest messages failed: $e');
    } finally {
      _refreshingNewest = false;
    }
  }

  /// [base]'s conversation details with [messages].
  FCConversationResult _withMessages(FCConversationResult base, List<FCConversationMessage> messages) {
    return FCConversationResult(
      result: base.result,
      resultText: base.resultText,
      convId: base.convId,
      subject: base.subject,
      convTitle: base.convTitle,
      messages: messages,
      participants: base.participants,
      participantCount: base.participantCount,
      canReply: base.canReply,
      canInvite: base.canInvite,
      canEdit: base.canEdit,
      canClose: base.canClose,
      isClosed: base.isClosed,
      totalMessageNum: base.totalMessageNum,
      canUpload: base.canUpload,
      position: base.position,
    );
  }

  void _attemptAutoLoginAndLoad() {
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
          await AppNavigation.push(context, LoginPage(siteContext: widget.siteContext));
        }
      }
      if (mounted) {
        _loadConversation();
      }
    });
  }

  Future<void> _onReplyPressed() async {
    if (_conversation != null) {
      final result = await Navigator.of(context).push(
        FormPageRoute(
          builder: (context) => ReplyConversationPage(
            siteContext: widget.siteContext,
            conversationId: widget.conversationId,
            subject: widget.subject,
            canUpload: _conversation?.canUpload,
          ),
        ),
      );

      // If reply was successful, refresh conversation and scroll to last message
      if (result == true) {
        await _refreshAndScrollToLast();
      }
    }
  }

  Future<void> _markAsUnread() async {
    try {
      final conversationProxy = SiteProxyFactory.getPrivateConversationProxy();
      final result = await conversationProxy.markConversationUnreadAsync(widget.conversationId);

      if (mounted) {
        if (result.result) {
          // Call the callback to update the conversation state in the list
          widget.onMarkUnread?.call();

          SnackbarHelper.showSuccess(context, AppLocalizations.of(context).conversationMarkedAsUnread);
          // Pop back to the conversation list
          Navigator.pop(context);
        } else {
          // API call returned false - show error message
          final errorMessage =
              result.resultText?.isNotEmpty == true ? result.resultText! : AppLocalizations.of(context).failedToMarkConversationAsUnread('');
          SnackbarHelper.showError(context, errorMessage);
        }
      }
    } catch (e) {
      if (mounted) {
        SnackbarHelper.showError(context, AppLocalizations.of(context).failedToMarkConversationAsUnread(e.toString()));
      }
    }
  }

  Future<void> _loadOlderMessages() async {
    if (_isLoadingMore || _conversation == null) return;

    if (_currentStartNum <= 1) {
      return;
    }

    await _loadConversation(loadMore: true, loadOlder: true);
  }

  Future<void> _loadConversation({bool loadMore = false, bool loadOlder = false}) async {
    if (loadMore && (_isLoadingMore || !_hasMoreMessages)) {
      return;
    }

    try {
      if (!loadMore) {
        setState(() {
          _isLoading = true;
          _error = null;
          _currentStartNum = widget.initialStartNum ?? 0;
        });
      } else {
        setState(() {
          _isLoadingMore = true;
        });
      }

      final conversationProxy = SiteProxyFactory.getPrivateConversationProxy();
      FCConversationResult conversation;

      // If anchorMessageId is provided and this is the initial load, use getConversationByMessageAsync
      if (!loadMore && _anchored && widget.anchorMessageId != null && widget.anchorMessageId!.isNotEmpty) {
        conversation = await conversationProxy.getConversationByMessageAsync(
          widget.anchorMessageId!,
          messagesPerRequest: _pageSize,
        );

        if (!conversation.result) {
          if (mounted) {
            setState(() {
              _error = conversation.resultText ?? 'Failed to load conversation';
              _isLoading = false;
            });
          }
          return;
        }

        if (mounted) {
          setState(() {
            _conversation = conversation;
            // Calculate current startNum and lastNum based on position
            // Server calculates: startNum = max(1, position - floor(messagesPerRequest / 2))
            // This centers the messages around the anchor message
            final position = conversation.position ?? 1;
            // Use floor() to match server calculation exactly (not ~/ which truncates)
            _currentStartNum = math.max(1, position - (_pageSize / 2).floor());
            _currentLastNum = _currentStartNum + conversation.messages.length - 1;

            // Check if there are more messages to load
            final totalMessages = conversation.totalMessageNum ?? conversation.messages.length;
            // There are more messages if:
            // 1. We have more messages before the current range (startNum > 1)
            // 2. We have more messages after the current range (lastNum < totalMessages)
            final hasOlderMessages = _currentStartNum > 1;
            final hasNewerMessages = _currentLastNum < totalMessages;
            _hasMoreMessages = hasOlderMessages || hasNewerMessages;

            _isLoading = false;

            // Scroll to the anchor message after loading
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_scrollController.hasClients && mounted && _conversation != null) {
                _scrollToMessage(widget.anchorMessageId!, position: position);
              }
            });
          });
        }
      } else {
        // Normal conversation loading logic
        int startNum;
        int lastNum;

        // Always calculate the last page when initially loading (not loading more)
        // This ensures we always show the most recent messages, even if initialStartNum was provided
        if (!loadMore) {
          // First, get the total message count by loading a minimal page
          // Use conversationId from widget, or from already loaded conversation if available
          final conversationIdToUse = _conversation?.convId ?? widget.conversationId;

          final metadataConversation = await conversationProxy.getConversationAsync(
            conversationIdToUse,
            1, // 1-based: position 1 = first message
            1, // Load just the first message to get totalMessageNum
            false,
          );

          final totalMessages = metadataConversation.totalMessageNum ?? metadataConversation.messages.length;

          // Calculate the last page startNum (1-based indexing)
          // Messages are numbered 1 to totalMessages
          // If totalMessages <= pageSize, start from 1, otherwise start from the last page
          if (totalMessages <= _pageSize) {
            startNum = 1; // Start from first message
            lastNum = totalMessages; // End at last message
          } else {
            // Calculate startNum for the last page
            // For 49 messages with pageSize=20: startNum = 49 - 20 + 1 = 30
            startNum = totalMessages - _pageSize + 1;
            lastNum = totalMessages; // End at last message
          }
        } else {
          // When loading more messages, determine if we're loading older or newer messages
          final totalMessages = _conversation?.totalMessageNum ?? _conversation?.messages.length ?? 0;

          if (loadOlder && _currentStartNum > 1) {
            // Explicitly loading older messages (button click)
            startNum = math.max(1, _currentStartNum - _pageSize);
            lastNum = _currentStartNum - 1; // End just before the current start
          } else {
            // Auto-loading: check scroll position to determine direction
            final scrollPosition = _scrollController.hasClients ? _scrollController.position.pixels : 0;
            final maxScroll = _scrollController.hasClients ? _scrollController.position.maxScrollExtent : 0;
            final isNearBottom = scrollPosition >= maxScroll - 200;

            if (isNearBottom && _currentLastNum < totalMessages) {
              // Loading newer messages (after current range)
              startNum = _currentLastNum + 1; // Start just after the current end
              lastNum = math.min(totalMessages, startNum + _pageSize - 1);
            } else {
              // No more messages to load in this direction
              startNum = _currentStartNum;
              lastNum = _currentLastNum;
            }
          }
        }

        // Use conversationId from widget, or from already loaded conversation if available
        final conversationIdToUse = _conversation?.convId ?? widget.conversationId;

        conversation = await conversationProxy.getConversationAsync(
          conversationIdToUse,
          startNum,
          lastNum,
          false, // returnHtml - use BBCode instead of HTML
        );

        if (mounted) {
          setState(() {
            if (loadMore && _conversation != null) {
              // Determine if we're loading older or newer messages based on startNum
              final isLoadingOlder = startNum < _currentStartNum;
              final isLoadingNewer = startNum > _currentLastNum;

              if (isLoadingOlder) {
                // Save current scroll position before prepending messages
                final previousScrollPosition = _scrollController.hasClients ? _scrollController.position.pixels : 0.0;

                // Prepend older messages to existing list (since we're loading backwards)
                _conversation = FCConversationResult(
                  result: conversation.result,
                  resultText: conversation.resultText,
                  convId: conversation.convId,
                  subject: conversation.subject,
                  convTitle: conversation.convTitle,
                  messages: [...conversation.messages, ..._conversation!.messages],
                  participants: conversation.participants,
                  participantCount: conversation.participantCount,
                  canReply: conversation.canReply,
                  canInvite: conversation.canInvite,
                  canEdit: conversation.canEdit,
                  canClose: conversation.canClose,
                  isClosed: conversation.isClosed,
                  totalMessageNum: conversation.totalMessageNum ?? _conversation!.totalMessageNum,
                  canUpload: conversation.canUpload,
                  position: conversation.position,
                );
                _currentStartNum = startNum;
                // Keep _currentLastNum the same since we're prepending
                // Check if there are more older messages to load
                final hasOlderMessages = startNum > 1;
                final hasNewerMessages = _currentLastNum < (conversation.totalMessageNum ?? _conversation!.totalMessageNum ?? 0);
                _hasMoreMessages = hasOlderMessages || hasNewerMessages;

                // Maintain scroll position after prepending older messages
                // Estimate the height of newly loaded messages and adjust scroll
                final newMessageCount = conversation.messages.length;
                if (_scrollController.hasClients && previousScrollPosition > 0 && newMessageCount > 0) {
                  // Estimate average message height (this is approximate)
                  // In a real scenario, you might want to measure actual heights
                  final estimatedMessageHeight = 100.0; // Approximate height per message
                  final estimatedNewContentHeight = newMessageCount * estimatedMessageHeight;

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_scrollController.hasClients && mounted) {
                      // Adjust scroll position to maintain visual position
                      final newScrollPosition = previousScrollPosition + estimatedNewContentHeight;
                      _scrollController.jumpTo(newScrollPosition.clamp(
                        0.0,
                        _scrollController.position.maxScrollExtent,
                      ));
                    }
                  });
                }
              } else if (isLoadingNewer) {
                // Append newer messages to existing list
                _conversation = FCConversationResult(
                  result: conversation.result,
                  resultText: conversation.resultText,
                  convId: conversation.convId,
                  subject: conversation.subject,
                  convTitle: conversation.convTitle,
                  messages: [..._conversation!.messages, ...conversation.messages],
                  participants: conversation.participants,
                  participantCount: conversation.participantCount,
                  canReply: conversation.canReply,
                  canInvite: conversation.canInvite,
                  canEdit: conversation.canEdit,
                  canClose: conversation.canClose,
                  isClosed: conversation.isClosed,
                  totalMessageNum: conversation.totalMessageNum ?? _conversation!.totalMessageNum,
                  canUpload: conversation.canUpload,
                  position: conversation.position,
                );
                _currentLastNum = lastNum;
                // Keep _currentStartNum the same since we're appending
                // Check if there are more newer messages to load
                final totalMessages = conversation.totalMessageNum ?? _conversation!.totalMessageNum ?? 0;
                final hasOlderMessages = _currentStartNum > 1;
                final hasNewerMessages = _currentLastNum < totalMessages;
                _hasMoreMessages = hasOlderMessages || hasNewerMessages;
              } else {
                // Should not happen, but handle gracefully
                _conversation = conversation;
                _currentStartNum = startNum;
                _currentLastNum = lastNum;
                _hasMoreMessages = false;
              }
            } else {
              _conversation = conversation;
              _currentStartNum = startNum;
              _currentLastNum = lastNum;
              final totalMessages = conversation.totalMessageNum ?? conversation.messages.length;
              _hasMoreMessages = startNum > 1 || lastNum < totalMessages;

              // Always scroll to bottom when initially loading (since we always load the last page)
              if (!loadMore) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_scrollController.hasClients && mounted) {
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  }
                });
              }
            }
            _isLoading = false;
            _isLoadingMore = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
          _isLoadingMore = false;
        });
      }
    }
  }

  /// Highlights a message by ID and clears it after 3 seconds
  void _highlightMessage(String messageId) {
    if (!mounted) return;

    // Cancel any existing timer
    _highlightTimer?.cancel();

    // Set the highlighted message
    setState(() {
      _highlightedMessageId = messageId;
    });

    // Clear highlight after 3 seconds
    _highlightTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _highlightedMessageId = null;
        });
      }
    });
  }

  /// Scroll to a specific message by message ID
  /// [position] is the 1-based position of the message in the entire conversation (optional)
  void _scrollToMessage(String messageId, {int? position}) {
    if (_conversation == null || !_scrollController.hasClients) return;

    // Find the index of the message in the loaded list
    final messageIndex = _conversation!.list.indexWhere((msg) => msg.messageId == messageId);
    if (messageIndex == -1) {
      return;
    }

    // If we have the position field, use it to properly center the message
    // This is especially important when the message is in the middle of multiple pages
    if (position != null && _conversation!.totalMessageNum != null) {
      final loadedMessages = _conversation!.list.length;

      // Calculate where the target message is relative to the loaded range
      // position is 1-based in the entire conversation
      // _currentStartNum is 1-based start of loaded range
      final relativePosition = position - _currentStartNum;

      // If the message is in the loaded range, scroll to it proportionally
      if (relativePosition >= 0 && relativePosition < loadedMessages) {
        // Calculate scroll position: center the message in the viewport
        // Use the relative position within the loaded messages to calculate scroll
        final maxScroll = _scrollController.position.maxScrollExtent;
        if (maxScroll > 0) {
          // Calculate scroll position to center the message
          // We want the message to be roughly in the middle of the viewport
          final scrollRatio = relativePosition / loadedMessages;
          final targetScroll = maxScroll * scrollRatio;

          // Adjust to center: subtract half viewport height (approximate)
          // This ensures the message appears in the middle of the screen
          final viewportHeight = _scrollController.position.viewportDimension;
          final centeredScroll = (targetScroll - viewportHeight / 2).clamp(0.0, maxScroll);

          _scrollController.animateTo(
            centeredScroll,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      } else {
        // Fall back to proportional scrolling
        final maxScroll = _scrollController.position.maxScrollExtent;
        if (maxScroll > 0 && loadedMessages > 0) {
          final scrollPosition = maxScroll * (messageIndex / loadedMessages);
          _scrollController.animateTo(
            scrollPosition,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      }
    } else {
      // Fallback: Calculate approximate scroll position without position field
      // This is approximate since we don't know exact heights, but should get us close
      final totalMessages = _conversation!.list.length;
      if (totalMessages > 0) {
        final scrollPosition = _scrollController.position.maxScrollExtent * (messageIndex / totalMessages);
        _scrollController.animateTo(
          scrollPosition,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    }

    // Highlight the message
    _highlightMessage(messageId);
  }

  /// After a reply: bring it in (with any other new messages) at the end of
  /// the list, scroll to it and highlight it. A conversation opened at a
  /// message (from a push) used to reload around that message, so the reply
  /// just sent was not shown; and the whole conversation reloaded behind a
  /// spinner.
  Future<void> _refreshAndScrollToLast() async {
    _anchored = false;
    await _refreshNewest(scrollToEnd: true);
    if (mounted && _conversation != null && _conversation!.list.isNotEmpty) {
      _highlightMessage(_conversation!.list.last.messageId);
    }
  }

  Future<void> _closeConversation() async {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          AppLocalizations.of(context).closeConversation,
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        content: Text(
          AppLocalizations.of(context).closeConversationConfirm,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              AppLocalizations.of(context).cancel,
              style: TextStyle(color: colorScheme.primary),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              AppLocalizations.of(context).close,
              style: TextStyle(color: colorScheme.onPrimary),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      final conversationProxy = SiteProxyFactory.getPrivateConversationProxy();
      final result = await conversationProxy.closeConversationAsync(widget.conversationId);

      if (mounted) {
        if (result.result) {
          SnackbarHelper.showSuccess(context, AppLocalizations.of(context).conversationClosed);
          // Refresh conversation to update state
          await _loadConversation();
        } else {
          SnackbarHelper.showError(context, result.resultText ?? AppLocalizations.of(context).failedToCloseConversation(''));
        }
      }
    } catch (e) {
      if (mounted) {
        SnackbarHelper.showError(context, AppLocalizations.of(context).failedToCloseConversation(e.toString()));
      }
    }
  }

  Future<void> _uncloseConversation() async {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          AppLocalizations.of(context).openConversation,
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        content: Text(
          AppLocalizations.of(context).openConversationConfirm,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              AppLocalizations.of(context).cancel,
              style: TextStyle(color: colorScheme.primary),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              AppLocalizations.of(context).open,
              style: TextStyle(color: colorScheme.onPrimary),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      final conversationProxy = SiteProxyFactory.getPrivateConversationProxy();
      final result = await conversationProxy.uncloseConversationAsync(widget.conversationId);

      if (mounted) {
        if (result.result) {
          SnackbarHelper.showSuccess(context, AppLocalizations.of(context).conversationOpened);
          // Refresh conversation to update state
          await _loadConversation();
        } else {
          SnackbarHelper.showError(context, result.resultText ?? 'Failed to open conversation');
        }
      }
    } catch (e) {
      if (mounted) {
        SnackbarHelper.showError(context, AppLocalizations.of(context).failedToOpenConversation(e.toString()));
      }
    }
  }

  Future<void> _leaveConversation() async {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          AppLocalizations.of(context).leaveConversation,
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        content: Text(
          AppLocalizations.of(context).leaveConversationConfirm,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              AppLocalizations.of(context).cancel,
              style: TextStyle(color: colorScheme.primary),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              AppLocalizations.of(context).leave,
              style: TextStyle(color: colorScheme.onPrimary),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      final conversationProxy = SiteProxyFactory.getPrivateConversationProxy();
      final result = await conversationProxy.leaveConversationAsync(widget.conversationId, 1); // 1 = soft leave
      if (!mounted) return;
      if (result.result) {
        Navigator.of(context).pop(true);
      } else {
        // The page used to close as if the conversation had been left.
        SnackbarHelper.showError(context, result.resultText ?? AppLocalizations.of(context).failedToLeaveConversation(''));
      }
    } catch (e) {
      if (mounted) {
        SnackbarHelper.showError(context, AppLocalizations.of(context).failedToLeaveConversation(e.toString()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ConversationAppBar(
        title: _conversation?.convTitle ?? widget.subject,
        siteContext: widget.siteContext,
        onLeave: _leaveConversation,
        onMarkUnread: _markAsUnread,
        participantCount: _conversation?.participantCount ?? 0,
        canEdit: _conversation?.canEdit ?? false,
        canClose: _conversation?.canClose ?? false,
        isClosed: _conversation?.isClosed ?? false,
        participants: _conversation?.participants,
        canInvite: _conversation?.canInvite ?? false,
        conversationId: widget.conversationId,
        onInviteSuccess: () => _loadConversation(),
        onClose: _conversation?.canClose == true && _conversation?.isClosed == false ? _closeConversation : null,
        onUnclose: _conversation?.canClose == true && _conversation?.isClosed == true ? _uncloseConversation : null,
        onEdit: _conversation?.canEdit == true && widget.siteContext.siteType == 'xenforo' ? _editConversation : null,
      ),
      body: _buildBody(),
    );
  }

  Future<void> _editConversation() async {
    final result = await Navigator.push(
      context,
      FormPageRoute(
        builder: (context) => EditConversationPage(
          siteContext: widget.siteContext,
          conversationId: widget.conversationId,
        ),
      ),
    );

    // Reload conversation if edit was successful
    if (result == true) {
      _loadConversation();
    }
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context).errorLoadingConversation('$_error'),
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _loadConversation,
              child: Text(AppLocalizations.of(context).retry),
            ),
          ],
        ),
      );
    }

    if (_conversation == null) {
      return Center(
        child: Text(
          AppLocalizations.of(context).conversationNotFound,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      );
    }

    return Column(
      children: [
        // Closed banner
        if ((_conversation?.isClosed ?? false) && _showClosedBanner)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.7),
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lock_outline,
                  size: 20,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context).conversationClosedNoReplies,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 20,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  onPressed: () {
                    setState(() {
                      _showClosedBanner = false;
                    });
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  splashRadius: 20,
                ),
              ],
            ),
          ),
        // Messages list
        Expanded(
          child: Stack(
            children: [
              RefreshIndicator(
                onRefresh: _loadConversation,
                // Content that grows while the reader is at the newest message
                // (images loading, reactions) keeps the newest message in view;
                // late images used to push it off screen.
                child: NotificationListener<ScrollMetricsNotification>(
                  onNotification: (notification) {
                    final metrics = notification.metrics;
                    if (_atBottom && metrics.pixels < metrics.maxScrollExtent - 1) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted && _scrollController.hasClients) {
                          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                        }
                      });
                    }
                    return false;
                  },
                  child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Conversation header with overlapping avatars, title, and participant count
                      ConversationHeaderWidget(
                        title: _conversation!.convTitle ?? widget.subject,
                        participants: _conversation!.participants,
                        participantCount: _conversation!.participantCount ?? 0,
                        siteContext: widget.siteContext,
                        canInvite: _conversation!.canInvite ?? false,
                        conversationId: widget.conversationId,
                        onInviteSuccess: () => _loadConversation(),
                      ),
                      // Load Earlier Messages button
                      if (_currentStartNum > 1 && !_isLoadingMore)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: OutlinedButton.icon(
                            onPressed: () => _loadOlderMessages(),
                            icon: const Icon(Icons.arrow_upward),
                            label: Text(AppLocalizations.of(context).loadEarlierMessages),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                            ),
                          ),
                        ),
                      // Loading indicator when loading older messages
                      if (_isLoadingMore && _currentStartNum > 1)
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      // Header (first message) - only show if messages exist
                      if (_conversation!.list.isNotEmpty)
                        ConversationHeaderItem(
                          siteContext: widget.siteContext,
                          message: _conversation!.list[0],
                          subject: _conversation!.convTitle ?? '',
                          participants: _conversation!.participants,
                          onQuote: () => _onQuoteMessage(_conversation!.list[0]),
                          onLike: () => _onLikeMessage(_conversation!.list[0]),
                          onEdit: () => _onEditMessage(_conversation!.list[0]),
                          isHighlighted: _highlightedMessageId == _conversation!.list[0].messageId,
                          isClosed: _conversation!.isClosed ?? false,
                        ),
                      // Individual reply messages
                      if (_conversation!.list.length > 1)
                        ...List.generate(_conversation!.list.length - 1, (i) {
                          final msg = _conversation!.list[i + 1];
                          return ConversationItem(
                            siteContext: widget.siteContext,
                            message: msg,
                            isFirst: false,
                            isLast: i == _conversation!.list.length - 2,
                            onQuote: () => _onQuoteMessage(msg),
                            onLike: () => _onLikeMessage(msg),
                            onEdit: () => _onEditMessage(msg),
                            isHighlighted: _highlightedMessageId == msg.messageId,
                            isClosed: _conversation!.isClosed ?? false,
                          );
                        }),
                      // Show message if no messages found
                      if (_conversation!.list.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context).noMessagesFound,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ),
                        ),
                      // Loading indicator for more messages
                      if (_isLoadingMore)
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      // End of conversation indicator
                      if (!_isLoadingMore && _conversation!.list.isNotEmpty)
                        Builder(
                          builder: (context) {
                            final totalMessages = _conversation!.totalMessageNum ?? _conversation!.list.length;
                            final isAtEnd = _currentLastNum >= totalMessages;

                            if (isAtEnd) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context).endOfConversation,
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                                          fontStyle: FontStyle.italic,
                                        ),
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      const SizedBox(height: 80), // for bottom bar spacing
                    ],
                  ),
                ),
                ),
              ),
              _buildBottomBar(context),
            ],
          ),
        ),
      ],
    );
  }

  void _onScroll() {
    if (_conversation == null) return;

    final position = _scrollController.position;
    final isNearBottom = position.pixels >= position.maxScrollExtent - 200;
    _atBottom = position.pixels >= position.maxScrollExtent - 48;

    // Only auto-load newer messages when scrolling to the bottom
    // Older messages require manual button click
    if (_hasMoreMessages && !_isLoadingMore) {
      final totalMessages = _conversation!.totalMessageNum ?? _conversation!.messages.length;
      final hasNewerMessages = _currentLastNum < totalMessages;

      if (isNearBottom && hasNewerMessages) {
        // Load newer messages when scrolling to the bottom
        _loadConversation(loadMore: true);
      }
    }

    if (position.maxScrollExtent > 0 && _conversation!.list.isNotEmpty) {
      // Calculate which message is currently most visible (local index in loaded list)
      final itemHeight = position.maxScrollExtent / _conversation!.list.length;
      final currentIndex = (position.pixels / itemHeight).round();
      final newIndex = currentIndex.clamp(0, _conversation!.list.length - 1);

      // Update the visible index (this is the local index, we'll convert to absolute when displaying)
      if (_currentVisibleMessageIndex != newIndex) {
        setState(() {
          _currentVisibleMessageIndex = newIndex;
        });
      }
    }
  }

  /// Get the absolute position (1-based) of the currently visible message
  int get _currentVisibleMessagePosition {
    if (_conversation == null || _conversation!.list.isEmpty) return 1;

    // If message has messageNumber, use it directly
    final visibleMessage = _conversation!.list[_currentVisibleMessageIndex.clamp(0, _conversation!.list.length - 1)];
    if (visibleMessage.messageNumber != null) {
      return visibleMessage.messageNumber!;
    }

    // Fallback: calculate from _currentStartNum (1-based) + local index
    return _currentStartNum + _currentVisibleMessageIndex;
  }

  /// Load first page of conversation and scroll to top
  Future<void> _jumpToFirstMessage() async {
    if (_conversation == null) return;

    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final conversationProxy = SiteProxyFactory.getPrivateConversationProxy();
      final conversationIdToUse = _conversation!.convId;

      // Load first page (messages 1 to pageSize)
      final startNum = 1;
      final lastNum = _pageSize;

      final conversation = await conversationProxy.getConversationAsync(
        conversationIdToUse,
        startNum,
        lastNum,
        false, // returnHtml - use BBCode instead of HTML
      );

      if (mounted) {
        setState(() {
          // Replace current conversation with first page (discard previous messages)
          _conversation = conversation;
          _currentStartNum = startNum;
          _currentLastNum = lastNum;
          final totalMessages = conversation.totalMessageNum ?? conversation.messages.length;
          _hasMoreMessages = lastNum < totalMessages;
          _isLoading = false;
        });

        // Scroll to top after loading
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients && mounted) {
            _scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  /// Load last page of conversation and scroll to bottom
  Future<void> _jumpToLastMessage() async {
    if (_conversation == null) return;

    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final conversationProxy = SiteProxyFactory.getPrivateConversationProxy();
      final conversationIdToUse = _conversation!.convId;

      // First, get total message count
      final metadataConversation = await conversationProxy.getConversationAsync(
        conversationIdToUse,
        1, // 1-based: position 1 = first message
        1, // Load just the first message to get totalMessageNum
        false,
      );

      final totalMessages = metadataConversation.totalMessageNum ?? metadataConversation.messages.length;

      // Calculate last page
      int startNum;
      int lastNum;
      if (totalMessages <= _pageSize) {
        startNum = 1;
        lastNum = totalMessages;
      } else {
        // Calculate startNum for the last page
        startNum = totalMessages - _pageSize + 1;
        lastNum = totalMessages;
      }

      final conversation = await conversationProxy.getConversationAsync(
        conversationIdToUse,
        startNum,
        lastNum,
        false, // returnHtml - use BBCode instead of HTML
      );

      if (mounted) {
        setState(() {
          // Replace current conversation with last page (discard previous messages)
          _conversation = conversation;
          _currentStartNum = startNum;
          _currentLastNum = lastNum;
          _hasMoreMessages = startNum > 1; // There are more messages if we're not at the first page
          _isLoading = false;
        });

        // Scroll to bottom after loading
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients && mounted) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _showJumpToMessageDialog(BuildContext context) {
    if (_conversation == null) return;

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final totalMessages = _conversation!.totalMessageNum ?? _conversation!.list.length;
    int selectedMessagePosition = _currentVisibleMessagePosition;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(
                AppLocalizations.of(context).jumpToMessage,
                style: textTheme.titleLarge?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$selectedMessagePosition',
                    style: textTheme.headlineMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Slider(
                    value: selectedMessagePosition.toDouble(),
                    min: 1,
                    max: totalMessages.toDouble(),
                    divisions: math.max(0, totalMessages - 1),
                    label: '$selectedMessagePosition',
                    onChanged: (double value) {
                      setState(() {
                        selectedMessagePosition = value.toInt();
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    AppLocalizations.of(context).cancel,
                    style: TextStyle(color: colorScheme.primary),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await _jumpToMessagePosition(selectedMessagePosition);
                  },
                  child: Text(
                    AppLocalizations.of(context).jump,
                    style: TextStyle(color: colorScheme.primary),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Jump to a specific message position (1-based) in the conversation
  Future<void> _jumpToMessagePosition(int targetPosition) async {
    if (_conversation == null) return;

    final totalMessages = _conversation!.totalMessageNum ?? _conversation!.list.length;

    // Clamp target position to valid range
    final clampedPosition = targetPosition.clamp(1, totalMessages);

    // Check if target message is already loaded
    final targetMessage = _conversation!.list.firstWhere(
      (msg) => msg.messageNumber == clampedPosition,
      orElse: () => _conversation!.list.first,
    );

    // Check if target is in currently loaded range
    final isInLoadedRange = clampedPosition >= _currentStartNum && clampedPosition <= _currentLastNum;

    if (isInLoadedRange && targetMessage.messageNumber == clampedPosition) {
      // Message is already loaded, just scroll to it
      final listIndex = _conversation!.list.indexWhere((msg) => msg.messageNumber == clampedPosition);
      if (listIndex >= 0) {
        // Calculate scroll position
        if (_scrollController.hasClients && _conversation!.list.isNotEmpty) {
          final itemHeight = _scrollController.position.maxScrollExtent / _conversation!.list.length;
          final targetOffset = listIndex * itemHeight;
          _scrollController.animateTo(
            targetOffset,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );

          // Update visible index
          setState(() {
            _currentVisibleMessageIndex = listIndex;
          });

          // Highlight the message
          _highlightMessage(targetMessage.messageId);
        }
        return;
      }
    }

    // Need to load the page containing the target message
    // Calculate which page contains the target position
    final messagesPerPage = _pageSize;
    final targetStartNum = math.max(1, clampedPosition - (messagesPerPage / 2).floor());
    final targetLastNum = math.min(totalMessages, targetStartNum + messagesPerPage - 1);

    // Load the conversation with the target range
    try {
      final conversationProxy = SiteProxyFactory.getPrivateConversationProxy();
      final conversation = await conversationProxy.getConversationAsync(
        widget.conversationId,
        targetStartNum,
        targetLastNum,
        false, // returnHtml - use BBCode instead of HTML
      );

      if (mounted) {
        setState(() {
          _conversation = conversation;
          _currentStartNum = targetStartNum;
          _currentLastNum = targetLastNum;
          final totalMessages = conversation.totalMessageNum ?? conversation.messages.length;
          _hasMoreMessages = targetStartNum > 1 || targetLastNum < totalMessages;
        });

        // Find and scroll to the target message
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients && mounted && _conversation != null) {
            final targetMsg = _conversation!.list.firstWhere(
              (msg) => msg.messageNumber == clampedPosition,
              orElse: () => _conversation!.list.first,
            );

            if (targetMsg.messageNumber == clampedPosition) {
              final listIndex = _conversation!.list.indexWhere((msg) => msg.messageNumber == clampedPosition);
              if (listIndex >= 0) {
                final itemHeight = _scrollController.position.maxScrollExtent / _conversation!.list.length;
                final targetOffset = listIndex * itemHeight;
                _scrollController.animateTo(
                  targetOffset,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );

                setState(() {
                  _currentVisibleMessageIndex = listIndex;
                });

                // Highlight the message
                _highlightMessage(targetMsg.messageId);
              }
            }
          }
        });
      }
    } catch (e) {
      if (mounted) {
        SnackbarHelper.showError(context, AppLocalizations.of(context).failedToJumpToMessage(e.toString()));
      }
    }
  }

  Widget _buildBottomBar(BuildContext context) {
    if (_conversation == null) return const SizedBox.shrink();

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: DesignTokens.spacingL,
              vertical: DesignTokens.spacingS,
            ),
            child: Row(
              children: [
                Semantics(
                  label: AppLocalizations.of(context).goToTop,
                  hint: AppLocalizations.of(context).jumpToFirstMessage,
                  button: true,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_upward),
                    onPressed: _jumpToFirstMessage,
                    tooltip: AppLocalizations.of(context).goToTop,
                  ),
                ),
                Semantics(
                  label: AppLocalizations.of(context).goToBottom,
                  hint: AppLocalizations.of(context).jumpToLastMessage,
                  button: true,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_downward),
                    onPressed: _jumpToLastMessage,
                    tooltip: AppLocalizations.of(context).goToBottom,
                  ),
                ),
                SizedBox(width: DesignTokens.spacingS),
                Semantics(
                  label: AppLocalizations.of(context).messagePositionOf(_currentVisibleMessagePosition, _conversation!.totalMessageNum ?? _conversation!.list.length),
                  hint: AppLocalizations.of(context).tapToJumpToMessage,
                  button: true,
                  child: GestureDetector(
                    onTap: () {
                      _showJumpToMessageDialog(context);
                    },
                    child: Text(
                      '${_currentVisibleMessagePosition} / ${_conversation!.totalMessageNum ?? _conversation!.list.length}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
                const Spacer(),
                if ((_conversation!.canReply ?? true) && !(_conversation!.isClosed ?? false))
                  Semantics(
                    label: AccessibilityHelpers.getReplyButtonLabel(context),
                    button: true,
                    child: FilledButton.icon(
                      onPressed: _onReplyPressed,
                      icon: const Icon(Icons.reply),
                      label: Text(AppLocalizations.of(context).reply),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onQuoteMessage(FCConversationMessage message) async {
    final result = await Navigator.of(context).push(
      FormPageRoute(
        builder: (context) => ReplyConversationPage(
          siteContext: widget.siteContext,
          conversationId: widget.conversationId,
          subject: widget.subject,
          quotedMessageId: message.messageId,
          canUpload: _conversation?.canUpload,
        ),
      ),
    );

    // If reply was successful, refresh conversation and scroll to last message
    if (result == true) {
      await _refreshAndScrollToLast();
    }
  }

  Future<void> _onEditMessage(FCConversationMessage message) async {
    final result = await Navigator.of(context).push(
      FormPageRoute(
        builder: (context) => EditConversationMessagePage(
          siteContext: widget.siteContext,
          messageId: message.messageId,
          conversationId: widget.conversationId,
        ),
      ),
    );

    // If edit was successful, refresh conversation
    if (result == true) {
      _loadConversation();
    }
  }

  Future<void> _onLikeMessage(FCConversationMessage message) async {
    if (!widget.siteContext.isLoggedIn) {
      SnackbarHelper.showError(context, AppLocalizations.of(context).pleaseLoginToLikeMessages);
      return;
    }

    // Multi-reaction path: if the forum exposes a reaction set, tapping opens
    // the chooser (same as posts). Falls through to the legacy single-Like
    // toggle below when no reaction set is available (older plugin).
    if (ReactionRegistry.instance.isAvailable) {
      final currentReactionId = _visitorReactionIdFor(message);
      final selected = await showReactionPicker(
        context,
        currentReactionId: currentReactionId,
      );
      if (selected == null) return; // dismissed
      await _applyMessageReaction(message, selected.id, currentReactionId);
      return;
    }

    // Optimistically update UI
    final wasLiked = message.isLiked;
    final oldLikeCount = message.likeCount;
    setState(() {
      message.isLiked = !wasLiked;
    });

    if (!wasLiked) {
      // Optimistically add like
      final currentUsername = widget.siteContext.currentUsername;
      if (currentUsername != null && !message.likesInfo.any((like) => like.username == currentUsername)) {
        message.likesInfo.add(FCLike(
          userId: widget.siteContext.currentUserId ?? '',
          username: currentUsername,
          avatarUrl: widget.siteContext.currentAvatarUrl ?? '',
          timestamp: DateTime.now(),
        ));
      }
    } else {
      // Optimistically remove like
      final currentUsername = widget.siteContext.currentUsername;
      if (currentUsername != null) {
        message.likesInfo.removeWhere((like) => like.username == currentUsername);
      }
    }
    setState(() {
      message.likeCount = message.likesInfo.length;
    });

    try {
      final socialProxy = SiteProxyFactory.getSocialProxy();

      if (wasLiked) {
        final result = await socialProxy.unlikeConversationMessageAsync(message.messageId);
        if (result.result) {
          // Update UI with response data from server
          setState(() {
            message.isLiked = result.isLiked;
            message.likeCount = result.likeCount;

            // Update likesInfo based on server response
            final currentUsername = widget.siteContext.currentUsername;
            if (currentUsername != null && !result.isLiked) {
              // Remove current user from likesInfo
              message.likesInfo.removeWhere((like) => like.username == currentUsername);
            }

            // Ensure likeCount matches server response (server is source of truth)
            message.likeCount = result.likeCount;
          });
        } else {
          // API returned failure, revert optimistic update
          throw Exception(result.resultText ?? 'Failed to unlike message');
        }
      } else {
        final result = await socialProxy.likeConversationMessageAsync(message.messageId);
        if (result.result) {
          // Update UI with response data from server
          setState(() {
            message.isLiked = result.isLiked;
            message.likeCount = result.likeCount;

            // Update likesInfo based on server response
            final currentUsername = widget.siteContext.currentUsername;
            if (currentUsername != null && result.isLiked) {
              // Add current user to likesInfo if not already there
              if (!message.likesInfo.any((like) => like.username == currentUsername)) {
                message.likesInfo.add(FCLike(
                  userId: widget.siteContext.currentUserId ?? '',
                  username: currentUsername,
                  avatarUrl: widget.siteContext.currentAvatarUrl ?? '',
                  timestamp: DateTime.now(),
                ));
              }
            }

            // Ensure likeCount matches server response (server is source of truth)
            message.likeCount = result.likeCount;
          });
        } else {
          // API returned failure, revert optimistic update
          throw Exception(result.resultText ?? 'Failed to like message');
        }
      }
    } catch (e) {
      // Revert UI if failed
      setState(() {
        message.isLiked = wasLiked;
        message.likeCount = oldLikeCount;

        if (wasLiked) {
          // Re-add like to likesInfo
          final currentUsername = widget.siteContext.currentUsername;
          if (currentUsername != null && !message.likesInfo.any((like) => like.username == currentUsername)) {
            message.likesInfo.add(FCLike(
              userId: widget.siteContext.currentUserId ?? '',
              username: currentUsername,
              avatarUrl: widget.siteContext.currentAvatarUrl ?? '',
              timestamp: DateTime.now(),
            ));
          }
        } else {
          // Remove like from likesInfo
          final currentUsername = widget.siteContext.currentUsername;
          if (currentUsername != null) {
            message.likesInfo.removeWhere((like) => like.username == currentUsername);
          }
        }
      });

      if (mounted) {
        SnackbarHelper.showError(context, AppLocalizations.of(context)
                    .failedToLikeOrUnlikeMessage(wasLiked ? AppLocalizations.of(context).unlike : AppLocalizations.of(context).like, e.toString()));
      }
    }
  }

  /// The viewer's current reaction id on a conversation message, from their
  /// own like entry (falls back to Like when the message is liked but no id
  /// is known).
  int? _visitorReactionIdFor(FCConversationMessage message) {
    final me = widget.siteContext.currentUsername;
    for (final like in message.likesInfo) {
      if (like.username == me) {
        return like.reactionId ??
            (message.isLiked
                ? (ReactionRegistry.instance.defaultReaction?.id ?? 1)
                : null);
      }
    }
    return message.isLiked
        ? (ReactionRegistry.instance.defaultReaction?.id ?? 1)
        : null;
  }

  /// Apply a chosen reaction to a conversation message: optimistic update +
  /// server call + revert on failure. Mirrors the post reaction flow. The
  /// server (reactToContent) adds / switches / toggles-off automatically.
  Future<void> _applyMessageReaction(
    FCConversationMessage message,
    int reactionId,
    int? currentReactionId,
  ) async {
    final togglingOff = currentReactionId == reactionId;
    final myUsername = widget.siteContext.currentUsername;
    final chosen = ReactionRegistry.instance.byId(reactionId);
    final oldLikeCount = message.likeCount;

    // --- Optimistic update ---
    setState(() {
      if (togglingOff) {
        message.isLiked = false;
        message.likesInfo.removeWhere((l) => l.username == myUsername);
      } else {
        message.isLiked = true;
        final existing =
            message.likesInfo.where((l) => l.username == myUsername).toList();
        if (existing.isEmpty) {
          message.likesInfo.add(FCLike(
            userId: widget.siteContext.currentUserId ?? '',
            username: myUsername ?? '',
            avatarUrl: widget.siteContext.currentAvatarUrl ?? '',
            timestamp: DateTime.now(),
            reactionId: reactionId,
            reactionName: chosen?.title,
            reactionEmoji: chosen?.emoji,
            reactionIconUrl: chosen?.imageUrl,
          ));
        } else {
          existing.first
            ..reactionId = reactionId
            ..reactionName = chosen?.title
            ..reactionEmoji = chosen?.emoji
            ..reactionIconUrl = chosen?.imageUrl;
        }
      }
      message.likeCount = message.likesInfo.length;
    });

    // --- Server call ---
    try {
      final socialProxy = SiteProxyFactory.getSocialProxy();
      final result = await socialProxy.likeConversationMessageAsync(
        message.messageId,
        reactionId: reactionId,
      );
      if (!result.result) {
        final msg = result.resultText;
        throw Exception((msg != null && msg.isNotEmpty) ? msg : 'React failed');
      }
      setState(() {
        message.likeCount = result.likeCount;
        if (!result.isLiked) {
          message.isLiked = false;
          message.likesInfo.removeWhere((l) => l.username == myUsername);
        }
      });
    } catch (e) {
      // --- Revert ---
      setState(() {
        message.likeCount = oldLikeCount;
        if (togglingOff) {
          final prev = ReactionRegistry.instance.byId(currentReactionId);
          message.isLiked = true;
          message.likesInfo.add(FCLike(
            userId: widget.siteContext.currentUserId ?? '',
            username: myUsername ?? '',
            avatarUrl: widget.siteContext.currentAvatarUrl ?? '',
            timestamp: DateTime.now(),
            reactionId: currentReactionId,
            reactionName: prev?.title,
            reactionEmoji: prev?.emoji,
            reactionIconUrl: prev?.imageUrl,
          ));
        } else if (currentReactionId == null) {
          message.isLiked = false;
          message.likesInfo.removeWhere((l) => l.username == myUsername);
        }
      });
      if (mounted) {
        SnackbarHelper.showInfo(context, AppLocalizations.of(context).failedToReact('$e'));
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _activitySub?.cancel();
    if (NotificationService.openConversationId == widget.conversationId) {
      NotificationService.openConversationId = null;
    }
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _highlightTimer?.cancel(); // Cancel timer on dispose
    super.dispose();
  }
}
