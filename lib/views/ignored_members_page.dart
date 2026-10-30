import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/models/results/fc_user_result.dart';

import '../core/logging/app_logger.dart';
import '../l10n/generated/app_localizations.dart';
import '../services/site_proxy_service.dart';
import '../theme/design_tokens.dart';
import '../utils/app_navigation.dart';
import 'user_profile_page.dart';
import 'widgets/user_avatar.dart';

/// The members the signed-in member ignores (XenForo add-on 1.11.0+), with
/// a button to stop ignoring each one. Reached from Forum settings.
class IgnoredMembersPage extends StatefulWidget {
  final SiteContext siteContext;

  const IgnoredMembersPage({super.key, required this.siteContext});

  @override
  State<IgnoredMembersPage> createState() => _IgnoredMembersPageState();
}

class _IgnoredMembersPageState extends State<IgnoredMembersPage> {
  List<FCIgnoredUser> _members = [];
  bool _isLoading = true;
  String? _error;
  final Set<String> _busy = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final response = await SiteProxyService.getUserProxy().getIgnoredUsersAsync(1, 100);
      if (!mounted) return;
      setState(() {
        if (response.result) {
          _members = response.list;
        } else {
          _error = response.resultText ?? '';
        }
        _isLoading = false;
      });
    } catch (e) {
      AppLogger.debug('Loading ignored members failed: $e');
      if (!mounted) return;
      setState(() {
        _error = '';
        _isLoading = false;
      });
    }
  }

  Future<void> _stopIgnoring(FCIgnoredUser member) async {
    if (_busy.contains(member.id)) return;
    setState(() => _busy.add(member.id));
    String? failure;
    try {
      final response = await SiteProxyService.getUserProxy().ignoreUserAsync(member.id, 0);
      if (!response.result) failure = response.resultText ?? '';
    } catch (e) {
      AppLogger.debug('Stop ignoring failed: $e');
      failure = '';
    }
    if (!mounted) return;
    final l10n = AppLocalizations.of(context);
    setState(() {
      _busy.remove(member.id);
      if (failure == null) _members = _members.where((m) => m.id != member.id).toList();
    });
    final colorScheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(
          failure != null
              ? (failure.isNotEmpty ? failure : l10n.somethingWentWrong)
              : l10n.memberNoLongerIgnored(member.username),
          style: failure != null ? TextStyle(color: colorScheme.onErrorContainer) : null,
        ),
        backgroundColor: failure != null ? colorScheme.errorContainer : null,
        behavior: SnackBarBehavior.floating,
        showCloseIcon: true,
        closeIconColor: failure != null ? colorScheme.onErrorContainer : null,
      ));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    Widget body;
    if (_isLoading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (_error != null) {
      body = Center(
        child: Padding(
          padding: DesignTokens.paddingScreen,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: colorScheme.error),
              const SizedBox(height: DesignTokens.spacingL),
              Text(
                _error!.isNotEmpty ? _error! : l10n.somethingWentWrong,
                style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: DesignTokens.spacingL),
              FilledButton.icon(
                onPressed: _load,
                icon: const Icon(Icons.refresh),
                label: Text(l10n.retry),
              ),
            ],
          ),
        ),
      );
    } else if (_members.isEmpty) {
      body = Center(
        child: Padding(
          padding: DesignTokens.paddingScreen,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.visibility_outlined, size: 48, color: colorScheme.onSurfaceVariant),
              const SizedBox(height: DesignTokens.spacingL),
              Text(
                l10n.noIgnoredMembers,
                style: textTheme.titleMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: DesignTokens.spacingS),
              Text(
                l10n.ignoredMembersExplanation,
                style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    } else {
      body = RefreshIndicator(
        onRefresh: _load,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: DesignTokens.spacingS),
          itemCount: _members.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final member = _members[index];
            final busy = _busy.contains(member.id);
            return ListTile(
              leading: UserAvatar(username: member.username, iconUrl: member.iconUrl, radius: 20),
              title: Text(member.username, style: textTheme.titleMedium),
              trailing: TextButton(
                onPressed: busy ? null : () => _stopIgnoring(member),
                child: Text(l10n.stopIgnoringMember),
              ),
              onTap: () => AppNavigation.push(
                context,
                UserProfilePage(
                  siteContext: widget.siteContext,
                  userId: member.id,
                  userName: member.username,
                  profilePictureUrl: member.iconUrl,
                ),
              ),
            );
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.ignoredMembers)),
      body: body,
    );
  }
}
