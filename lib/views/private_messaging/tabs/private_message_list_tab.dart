import 'package:flutter/material.dart';
import 'package:forumcopilot_flutter/views/widgets/resettable_widget.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_flutter/views/widgets/not_signed_in_view.dart';
import 'package:forumcopilot_flutter/core/logging/app_logger.dart';
import '../traditional/list/traditional_pm_list.dart';
import '../conversation/list/conversation_list.dart';

class PrivateMessageListTab extends StatefulWidget {
  final SiteContext siteContext;
  final bool isActive;
  const PrivateMessageListTab({super.key, required this.isActive, required this.siteContext});
  @override
  PrivateMessageListTabState createState() => PrivateMessageListTabState();
}

class PrivateMessageListTabState extends FCStatefulWidget<PrivateMessageListTab> with FCTabStatefulWidget<PrivateMessageListTab>, TickerProviderStateMixin {
  late TabController _tabController;
  bool _isConversationMode = false;

  final GlobalKey<TraditionalPMListState> _inboxKey = GlobalKey<TraditionalPMListState>();
  final GlobalKey<TraditionalPMListState> _sentboxKey = GlobalKey<TraditionalPMListState>();
  final GlobalKey<ConversationListState> _conversationKey = GlobalKey<ConversationListState>();
  
  // Track last logged login state to reduce debug noise
  bool? _lastLoggedIsLoggedIn;

  @override
  void initState() {
    super.initState();
    _isConversationMode = widget.siteContext.configDataOutput?.conversation ?? false;
    _tabController = TabController(length: _isConversationMode ? 1 : 2, vsync: this);
  }

  @override
  void resetTab() {
    if (_isConversationMode) {
      _conversationKey.currentState?.resetAndLoadConversations();
    } else {
      _inboxKey.currentState?.resetAndLoadMessages();
      _sentboxKey.currentState?.resetAndLoadMessages();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final conversationSupported = widget.siteContext.configDataOutput?.conversation ?? false;
    // Ensure TabController length matches current mode to avoid length/children mismatch
    if (conversationSupported != _isConversationMode) {
      // Recreate controller with correct length
      _isConversationMode = conversationSupported;
      final oldIndex = _tabController.index;
      _tabController.dispose();
      _tabController = TabController(length: _isConversationMode ? 1 : 2, vsync: this);
      // Try to preserve index when switching to 2 tabs
      if (!_isConversationMode && oldIndex < _tabController.length) {
        _tabController.index = oldIndex;
      }
    }

    return ValueListenableBuilder<bool>(
      valueListenable: widget.siteContext.isLoggedInNotifier,
      builder: (context, isLoggedIn, child) {
        // Only log when login state changes to reduce noise
        if (_lastLoggedIsLoggedIn != isLoggedIn) {
          AppLogger.debug('🔄 [PRIVATE_MESSAGE_LIST_TAB] ValueListenableBuilder rebuild');
          AppLogger.debug('   - isLoggedIn: $isLoggedIn');
          AppLogger.debug('   - loginDataOutput: ${widget.siteContext.loginDataOutput != null ? "present" : "null"}');
          _lastLoggedIsLoggedIn = isLoggedIn;
        }

        if (!isLoggedIn) {
          // Only log when showing NotSignedInView (state change)
          if (_lastLoggedIsLoggedIn == true) {
            AppLogger.debug('❌ [PRIVATE_MESSAGE_LIST_TAB] Showing NotSignedInView at top level');
          }
          return NotSignedInView(
            siteContext: widget.siteContext,
            title: 'Sign in to view messages',
            message: 'You need to be signed in to view your private messages.',
            icon: Icons.mail_outline_rounded,
          );
        }

        // Only log when showing message content (state change)
        if (_lastLoggedIsLoggedIn == false) {
          AppLogger.debug('✅ [PRIVATE_MESSAGE_LIST_TAB] User is logged in - showing message content');
        }

        // User is logged in - show message content without forum header
        if (conversationSupported) {
          // For conversation mode, show a single view without tabs
          return ConversationList(
            key: _conversationKey,
            siteContext: widget.siteContext,
          );
        } else {
          // For traditional private messages, show inbox/sent tabs
          return Column(
            children: [
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(icon: Icon(Icons.inbox, size: 18), text: 'Inbox'),
                  Tab(icon: Icon(Icons.send, size: 18), text: 'Sent'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    TraditionalPMList(
                      key: _inboxKey,
                      isInbox: true,
                      siteContext: widget.siteContext,
                    ),
                    TraditionalPMList(
                      key: _sentboxKey,
                      isInbox: false,
                      siteContext: widget.siteContext,
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
