import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/models/entities/fc_forum.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/factory/site_proxy_factory.dart';
import 'package:forumcopilot_flutter/controllers/site_manager.dart';
import 'package:forumcopilot_flutter/core/logging/app_logger.dart';
import 'package:forumcopilot_flutter/utils/forum_navigation.dart';
import 'package:forumcopilot_flutter/views/lists/forum_topic_list.dart';
import 'package:forumcopilot_flutter/views/new_topic_page.dart';
import 'package:forumcopilot_flutter/views/widgets/forum_actions.dart';
import 'package:forumcopilot_flutter/views/widgets/subforum_masthead.dart';
import '../utils/snackbar_helper.dart';
import '../utils/app_navigation.dart';
import '../l10n/generated/app_localizations.dart';

class ForumTopicsPage extends StatefulWidget {
  final FCForum forum;
  final SiteContext siteContext;

  /// The forum [forum] is in, for the breadcrumb, when the opener has it;
  /// otherwise it is looked up from the forum's structure.
  final FCForum? parent;

  /// Opened from [parent]'s own page: its name in the breadcrumb goes back
  /// there instead of opening it a second time.
  final bool openedFromParent;

  const ForumTopicsPage({
    super.key,
    required this.forum,
    required this.siteContext,
    this.parent,
    this.openedFromParent = false,
  });

  @override
  State<ForumTopicsPage> createState() => _ForumTopicsPageState();
}

class _ForumTopicsPageState extends State<ForumTopicsPage> {
  final ForumActions _forumActions = ForumActions();
  VoidCallback? _refreshCallback;
  FCForum? _parent;

  @override
  void initState() {
    super.initState();
    _parent = widget.parent;
    if (_parent == null) _lookUpParent();
  }

  /// The parent from the forum's structure, for a page opened without it (a
  /// link, search, a notification). XenForo's top level has parent 0.
  Future<void> _lookUpParent() async {
    final id = widget.forum.parentId;
    if (id == null || id.isEmpty || id == '0' || id == widget.forum.id) return;
    try {
      final parent = await SiteManagerRegistry.getManager(widget.siteContext).getForumById(id);
      if (mounted && parent != null) setState(() => _parent = parent);
    } catch (e) {
      // The breadcrumb then names the forum only.
      AppLogger.debug('[ForumTopicsPage] Parent forum $id not found: $e');
    }
  }

  void _openParent() {
    final parent = _parent;
    if (parent == null) return;
    if (widget.openedFromParent) {
      Navigator.of(context).maybePop();
    } else {
      pushForumOrLinkForum(context, parent, widget.siteContext);
    }
  }

  Future<void> _handleNewTopic() async {
    if (!widget.siteContext.isLoggedIn) {
      SnackbarHelper.showInfo(context, AppLocalizations.of(context).pleaseLoginToCreateTopic);
      return;
    }

    final result = await Navigator.of(context).push(
      FormPageRoute(
        builder: (context) => NewTopicPage(
          siteContext: widget.siteContext,
          forumId: widget.forum.id,
          forumName: widget.forum.name,
        ),
      ),
    );

    if (result == true && _refreshCallback != null) {
      _refreshCallback!();
    }
  }

  Future<void> _handleSubscribe() async {
    if (!widget.siteContext.isLoggedIn) {
      SnackbarHelper.showInfo(context, AppLocalizations.of(context).pleaseLoginToSubscribeForums);
      return;
    }

    try {
      final subscriptionProxy = SiteProxyFactory.getSubscriptionProxy();
      final isSubscribed = widget.forum.isSubscribed;

      if (isSubscribed) {
        await subscriptionProxy.unsubscribeForumAsync(widget.forum.id);
      } else {
        await subscriptionProxy.subscribeForumAsync(widget.forum.id, 1);
      }

      if (mounted) {
        setState(() {
          widget.forum.isSubscribed = !isSubscribed;
        });
      }
    } catch (e) {
      // Error handled silently
    }
  }

  Future<void> _handleMarkRead() async {
    await _forumActions.markAllAsRead(context, widget.forum.id);
    if (_refreshCallback != null) {
      _refreshCallback!();
    }
  }

  void _onRefreshAvailable(VoidCallback callback) {
    // Defer setState to avoid calling it during build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _refreshCallback = callback;
        });
      }
    });
  }

  /// The ⋮ menu: Subscribe and Mark read, for a signed-in reader. (New
  /// Topic is the page's floating button.)
  Widget? _buildMenu(BuildContext context) {
    if (!widget.siteContext.isLoggedIn) return null;
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final canSubscribe = widget.forum.canSubscribe;
    final isSubscribed = widget.forum.isSubscribed;
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert_rounded),
      tooltip: l10n.moreOptions,
      onSelected: (value) {
        switch (value) {
          case 'subscribe':
            _handleSubscribe();
            break;
          case 'mark_read':
            _handleMarkRead();
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        if (canSubscribe)
          PopupMenuItem<String>(
            value: 'subscribe',
            child: Row(
              children: [
                Icon(
                  isSubscribed ? Icons.watch_rounded : Icons.watch_outlined,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 12),
                Text(isSubscribed ? l10n.unsubscribe : l10n.subscribe, style: textTheme.bodyLarge),
              ],
            ),
          ),
        PopupMenuItem<String>(
          value: 'mark_read',
          child: Row(
            children: [
              Icon(Icons.visibility_off_rounded, color: colorScheme.onSurfaceVariant),
              const SizedBox(width: 12),
              Text(l10n.markRead, style: textTheme.bodyLarge),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final canPostHere = widget.siteContext.isLoggedIn && widget.forum.canPost;
    final menu = _buildMenu(context);
    return Scaffold(
      body: ForumTopicList(
        siteContext: widget.siteContext,
        forum: widget.forum,
        // The forum's masthead, which collapses into the page's bar.
        header: SubforumMasthead(
          siteContext: widget.siteContext,
          forum: widget.forum,
          parent: _parent,
          onOpenParent: _parent == null ? null : _openParent,
          actions: [if (menu != null) menu],
        ),
        onRefreshAvailable: _onRefreshAvailable,
        clearFloatingButton: canPostHere,
      ),
      // As on Home (and in the Discourse app): where a thumb is, and always
      // in reach. It was a button in the header, gone once you scrolled,
      // and an entry in the ⋮ menu as well. Home's button has the same
      // (default) hero tag, so it stays put as a forum opens from there.
      floatingActionButton: canPostHere
          ? FloatingActionButton.extended(
              onPressed: _handleNewTopic,
              icon: const Icon(Icons.post_add_rounded),
              label: Text(AppLocalizations.of(context).newTopic),
            )
          : null,
    );
  }
}
