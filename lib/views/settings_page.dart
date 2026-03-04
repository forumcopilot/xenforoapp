import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/models/settings/fc_settings_category.dart';
import 'package:forumcopilot_sdk/factory/site_proxy_factory.dart';
import 'package:forumcopilot_flutter/utils/error_dialog.dart';
import '../theme/design_tokens.dart';
import 'settings_category_page.dart' show ForumSettingsCategoryPage;
import 'package:url_launcher/url_launcher.dart';

class ForumSettingsPage extends StatefulWidget {
  final SiteContext siteContext;

  const ForumSettingsPage({
    Key? key,
    required this.siteContext,
  }) : super(key: key);

  @override
  State<ForumSettingsPage> createState() => _ForumSettingsPageState();
}

class _ForumSettingsPageState extends State<ForumSettingsPage> {
  List<FCSettingsCategory> _categories = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final proxy = SiteProxyFactory.getAccountProxy();
      final result = await proxy.getUserSettingsCategories();

      if (mounted) {
        if (result.result) {
          setState(() {
            _categories = result.categories.where((FCSettingsCategory cat) => cat.enabled).toList();
            _isLoading = false;
          });
        } else {
          setState(() {
            _error = result.resultText ?? 'Failed to load settings categories';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Error loading settings: ${e.toString()}';
          _isLoading = false;
        });
        showErrorDialogFromException(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)?.forumSettings ?? 'Forum Settings',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: DesignTokens.fontWeightMedium,
          ),
        ),
        elevation: 0,
      ),
      body: _buildBody(colorScheme, textTheme),
    );
  }

  Widget _buildBody(ColorScheme colorScheme, TextTheme textTheme) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: colorScheme.primary,
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: DesignTokens.paddingScreen,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: colorScheme.error,
              ),
              SizedBox(height: DesignTokens.spacingL),
              Text(
                _error!,
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: DesignTokens.spacingXL),
              FilledButton.icon(
                onPressed: _loadCategories,
                icon: Icon(Icons.refresh),
                label: Text(AppLocalizations.of(context)?.retry ?? 'Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_categories.isEmpty) {
      return ListView(
        padding: DesignTokens.paddingScreen,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: DesignTokens.spacingXL),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.settings_outlined,
                  size: 64,
                  color: colorScheme.onSurfaceVariant,
                ),
                SizedBox(height: DesignTokens.spacingL),
                Text(
                  AppLocalizations.of(context)?.noSettingsAvailable ?? 'No settings available',
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: DesignTokens.spacingS),
                Text(
                  AppLocalizations.of(context)?.settingsCategoriesWillAppearHere ?? 'Settings categories will appear here when available.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          _buildDeleteAccountSection(colorScheme, textTheme),
        ],
      );
    }

    return ListView.builder(
      padding: DesignTokens.paddingScreen,
      itemCount: _categories.length + 1,
      itemBuilder: (context, index) {
        if (index < _categories.length) {
          final category = _categories[index];
          return _buildCategoryCard(category, colorScheme, textTheme);
        }
        return _buildDeleteAccountSection(colorScheme, textTheme);
      },
    );
  }

  Widget _buildCategoryCard(
    FCSettingsCategory category,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Card(
      margin: EdgeInsets.only(bottom: DesignTokens.spacingM),
      elevation: 0,
      color: colorScheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusM),
        side: BorderSide(
          color: colorScheme.outlineVariant.withOpacity(DesignTokens.opacityLow),
          width: DesignTokens.borderWidthThin,
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: DesignTokens.spacingL,
          vertical: DesignTokens.spacingM,
        ),
        leading: Icon(
          _getCategoryIcon(category.key),
          color: colorScheme.primary,
          size: DesignTokens.iconSizeL,
        ),
        title: Text(
          category.displayName,
          style: textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: DesignTokens.fontWeightMedium,
          ),
        ),
        subtitle: category.description.isNotEmpty
            ? Padding(
                padding: EdgeInsets.only(top: DesignTokens.spacingXS),
                child: Text(
                  category.description,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              )
            : null,
        trailing: Icon(
          Icons.chevron_right,
          color: colorScheme.onSurfaceVariant,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ForumSettingsCategoryPage(
                siteContext: widget.siteContext,
                category: category,
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _getCategoryIcon(String categoryKey) {
    switch (categoryKey) {
      case 'push_notifications':
        return Icons.notifications;
      case 'privacy':
        return Icons.privacy_tip;
      case 'preferences':
        return Icons.tune;
      case 'email':
        return Icons.email;
      case 'security':
        return Icons.security;
      default:
        return Icons.settings;
    }
  }

  Widget _buildDeleteAccountSection(ColorScheme colorScheme, TextTheme textTheme) {
    return Card(
      margin: EdgeInsets.only(top: DesignTokens.spacingL, bottom: DesignTokens.spacingM),
      elevation: 0,
      color: colorScheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusM),
        side: BorderSide(
          color: colorScheme.outlineVariant.withOpacity(DesignTokens.opacityLow),
          width: DesignTokens.borderWidthThin,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(DesignTokens.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Delete Account',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: DesignTokens.fontWeightSemiBold,
              ),
            ),
            SizedBox(height: DesignTokens.spacingS),
            Text(
              'Remove your account from this forum.',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: DesignTokens.spacingM),
            FilledButton(
              onPressed: () => _showDeleteAccountDialog(context, colorScheme, textTheme),
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
                padding: DesignTokens.paddingExtendedButton,
                elevation: DesignTokens.elevationMedium,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(DesignTokens.radiusExtendedButton),
                ),
              ),
              child: const Text('Delete Account'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: colorScheme.surface,
          title: Text(
            'Delete Account',
            style: textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: DesignTokens.fontWeightMedium,
            ),
          ),
          content: Text(
            'Your account is managed by the forum. Please contact the forum directly for account removal. Use the Contact Us button at the bottom of the forum home page.',
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                AppLocalizations.of(context)?.cancel ?? 'Cancel',
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await _openForumHomePage(context);
              },
              child: Text(
                'Continue',
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openForumHomePage(BuildContext context) async {
    final url = widget.siteContext.site.url;
    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Forum URL is unavailable.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
          ),
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(8),
        ),
      );
      return;
    }

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not open forum URL.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
          ),
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(8),
        ),
      );
    }
  }
}
