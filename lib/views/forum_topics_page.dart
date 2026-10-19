import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/models/entities/fc_forum.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/factory/site_proxy_factory.dart';
import 'package:forumcopilot_flutter/views/appbars/forum_topics_app_bar.dart';
import 'package:forumcopilot_flutter/views/lists/forum_topic_list.dart';
import 'package:forumcopilot_flutter/views/new_topic_page.dart';
import 'package:forumcopilot_flutter/views/widgets/forum_actions.dart';
import '../utils/snackbar_helper.dart';
import '../utils/app_navigation.dart';
import '../l10n/generated/app_localizations.dart';

class ForumTopicsPage extends StatefulWidget {
  final FCForum forum;
  final SiteContext siteContext;

  const ForumTopicsPage({
    super.key,
    required this.forum,
    required this.siteContext,
  });

  @override
  State<ForumTopicsPage> createState() => _ForumTopicsPageState();
}

class _ForumTopicsPageState extends State<ForumTopicsPage> {
  final ForumActions _forumActions = ForumActions();
  VoidCallback? _refreshCallback;

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    final canPostHere = widget.siteContext.isLoggedIn && widget.forum.canPost;
    return Scaffold(
      appBar: ForumTopicsAppBar(
        title: widget.forum.name,
        forumId: widget.forum.id,
        onSubscribe: widget.siteContext.isLoggedIn && widget.forum.canSubscribe
            ? _handleSubscribe
            : null,
        onMarkRead: widget.siteContext.isLoggedIn ? _handleMarkRead : null,
        isSubscribed: widget.forum.isSubscribed,
        showMarkRead: true,
        isLoggedIn: widget.siteContext.isLoggedIn,
        canSubscribe: widget.forum.canSubscribe,
      ),
      body: ForumTopicList(
        siteContext: widget.siteContext,
        forum: widget.forum,
        showSubforumHeader: true,
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
