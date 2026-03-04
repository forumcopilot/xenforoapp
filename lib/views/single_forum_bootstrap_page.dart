import 'package:flutter/material.dart';
import 'package:forumcopilot_flutter/config/app_forum_config.dart';
import 'package:forumcopilot_flutter/views/site_home_page.dart';
import 'package:forumcopilot_flutter/services/site_initialization_service.dart';
import 'package:forumcopilot_flutter/views/widgets/progress_dialog.dart';
import 'package:forumcopilot_flutter/core/logging/app_logger.dart';

class SingleForumBootstrapPage extends StatefulWidget {
  const SingleForumBootstrapPage({super.key});

  @override
  State<SingleForumBootstrapPage> createState() =>
      _SingleForumBootstrapPageState();
}

class _SingleForumBootstrapPageState extends State<SingleForumBootstrapPage> {
  bool _isInitializing = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeForum();
    });
  }

  Future<void> _initializeForum() async {
    if (_isInitializing) return;

    setState(() {
      _isInitializing = true;
      _errorMessage = null;
    });

    final site = AppForumConfig.buildSite();
    final domain = Uri.tryParse(site.url)?.host ?? site.url;
    final progress = ProgressDialog.showWithUpdater(
      context,
      'Connecting to $domain...',
    );

    try {
      final result = await SiteInitializationService.initializeSite(
        site,
        onProgress: (message) {
          progress.messageNotifier.value = message;
        },
      );

      await progress.close();

      if (!mounted) return;

      if (result.success && result.siteContext != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const SiteHomePage(siteToInitialize: null),
          ),
        );
        return;
      }

      setState(() {
        _errorMessage = result.errorMessage ?? 'Failed to connect to forum.';
      });
    } catch (error, stackTrace) {
      await progress.close();
      if (!mounted) return;

      AppLogger.error(
        'Single forum bootstrap initialization failed',
        error: error,
        stackTrace: stackTrace,
      );
      setState(() {
        _errorMessage = error.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final configuredSite = AppForumConfig.buildSite();
    final configuredDomain =
        Uri.tryParse(configuredSite.url)?.host ?? configuredSite.url;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.forum_outlined,
                    size: 56,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    configuredSite.name,
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    configuredDomain,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  if (_isInitializing) ...[
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      'Initializing forum…',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ] else ...[
                    if (_errorMessage != null) ...[
                      Text(
                        _errorMessage!,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                    ],
                    FilledButton.icon(
                      onPressed: _initializeForum,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry Connection'),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
