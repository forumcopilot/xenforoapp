import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';

import '../../core/logging/app_logger.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../services/site_proxy_service.dart';
import '../../theme/design_tokens.dart';
import '../../utils/forum_links.dart';

/// The forum's notices at the top of Home (XenForo add-on 1.11.0+): why the
/// board is closed, updated terms the member still has to accept on the
/// website, and the notices XenForo shows the visitor. A dismissible notice
/// can be closed; for a member the forum remembers it. Older add-ons send
/// none of these, and nothing shows.
class ForumNotices extends StatefulWidget {
  const ForumNotices({super.key, required this.siteContext});

  final SiteContext siteContext;

  @override
  State<ForumNotices> createState() => _ForumNoticesState();
}

class _ForumNoticesState extends State<ForumNotices> {
  FCConfigResult? _config;
  final Set<int> _closed = {};
  late bool _wasLoggedIn;

  @override
  void initState() {
    super.initState();
    _config = widget.siteContext.configDataOutput;
    _wasLoggedIn = widget.siteContext.isLoggedIn;
    widget.siteContext.isLoggedInNotifier.addListener(_onLoginChanged);
  }

  @override
  void dispose() {
    widget.siteContext.isLoggedInNotifier.removeListener(_onLoginChanged);
    super.dispose();
  }

  /// Notices and the terms state are the visitor's, and the forum's config
  /// is read when the forum opens: read them again after a sign-in or out.
  Future<void> _onLoginChanged() async {
    final loggedIn = widget.siteContext.isLoggedIn;
    if (loggedIn == _wasLoggedIn) return;
    _wasLoggedIn = loggedIn;
    try {
      final config = await SiteProxyService.getConfigProxy()
          .getConfig(widget.siteContext.site.pluginUrl, forceRefresh: true);
      if (!mounted) return;
      setState(() {
        _config = config;
        _closed.clear();
      });
    } catch (e) {
      AppLogger.debug('Reloading the forum notices failed: $e');
    }
  }

  void _close(FCForumNotice notice) {
    setState(() => _closed.add(notice.id));
    // A guest's closed notice comes back next time; a member's stays closed.
    final proxy = SiteProxyService.getConfigProxy();
    if (widget.siteContext.isLoggedIn && proxy is IFCNoticeDismissal) {
      (proxy as IFCNoticeDismissal).dismissNoticeAsync(notice.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = _config;
    if (config == null) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final policy = config.policyAcceptance;
    final cards = <Widget>[
      if (config.boardInactiveMessage != null)
        _NoticeCard(
          icon: Icons.lock_clock_outlined,
          title: l10n.forumClosedTitle,
          message: config.boardInactiveMessage!,
          background: colorScheme.errorContainer,
          foreground: colorScheme.onErrorContainer,
        ),
      if (policy != null && widget.siteContext.isLoggedIn)
        _NoticeCard(
          icon: Icons.policy_outlined,
          title: l10n.updatedTermsTitle,
          message: l10n.updatedTermsMessage,
          background: colorScheme.tertiaryContainer,
          foreground: colorScheme.onTertiaryContainer,
          actionLabel: l10n.reviewTerms,
          onAction: () => ForumLinks.open(context, policy.acceptUrl, widget.siteContext),
        ),
      for (final notice in config.notices ?? const <FCForumNotice>[])
        if (!_closed.contains(notice.id))
          _NoticeCard(
            icon: Icons.campaign_outlined,
            title: notice.title,
            message: notice.message,
            background: colorScheme.secondaryContainer,
            foreground: colorScheme.onSecondaryContainer,
            onClose: notice.dismissible ? () => _close(notice) : null,
          ),
    ];
    if (cards.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(DesignTokens.spacingL, DesignTokens.spacingS, DesignTokens.spacingL, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (i, card) in cards.indexed) ...[
            if (i > 0) const SizedBox(height: DesignTokens.spacingS),
            card,
          ],
        ],
      ),
    );
  }
}

class _NoticeCard extends StatelessWidget {
  const _NoticeCard({
    required this.icon,
    required this.title,
    required this.message,
    required this.background,
    required this.foreground,
    this.actionLabel,
    this.onAction,
    this.onClose,
  });

  final IconData icon;
  final String title;
  final String message;
  final Color background;
  final Color foreground;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(DesignTokens.radiusM),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(DesignTokens.spacingM, DesignTokens.spacingM, DesignTokens.spacingXS, DesignTokens.spacingM),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: foreground, size: DesignTokens.iconSizeM),
            const SizedBox(width: DesignTokens.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title.isNotEmpty)
                    Text(title, style: textTheme.titleSmall?.copyWith(color: foreground)),
                  Text(message, style: textTheme.bodyMedium?.copyWith(color: foreground)),
                  if (actionLabel != null && onAction != null)
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: TextButton(
                        style: TextButton.styleFrom(foregroundColor: foreground, padding: EdgeInsets.zero),
                        onPressed: onAction,
                        child: Text(actionLabel!),
                      ),
                    ),
                ],
              ),
            ),
            if (onClose != null)
              IconButton(
                icon: Icon(Icons.close, color: foreground, size: DesignTokens.iconSizeM),
                tooltip: AppLocalizations.of(context).close,
                visualDensity: VisualDensity.compact,
                onPressed: onClose,
              )
            else
              const SizedBox(width: DesignTokens.spacingS),
          ],
        ),
      ),
    );
  }
}
