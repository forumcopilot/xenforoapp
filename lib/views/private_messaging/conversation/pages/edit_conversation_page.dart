import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';
import '../../../../theme/design_tokens.dart';
import '../../../../l10n/generated/app_localizations.dart';

class EditConversationPage extends StatefulWidget {
  final SiteContext siteContext;
  final String conversationId;

  const EditConversationPage({
    super.key,
    required this.siteContext,
    required this.conversationId,
  });

  @override
  State<EditConversationPage> createState() => _EditConversationPageState();
}

class _EditConversationPageState extends State<EditConversationPage> {
  late final TextEditingController _titleController;
  bool? _openInvite;
  bool? _conversationOpen;
  bool _isSubmitting = false;
  bool _hasChanges = false;
  bool _controllerInitialized = false;

  // Cache the future to prevent FutureBuilder from recreating it on every build
  late final Future<FCRawConversationResult> _rawConversationFuture;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _titleController.addListener(_onFieldChanged);
    // Cache the future so it doesn't recreate on every build
    _rawConversationFuture = SiteProxyFactory.getPrivateConversationProxy().getRawConversationAsync(widget.conversationId);
  }

  @override
  void dispose() {
    _titleController.removeListener(_onFieldChanged);
    _titleController.dispose();
    super.dispose();
  }

  void _onFieldChanged() {
    if (!_hasChanges) {
      setState(() {
        _hasChanges = true;
      });
    }
  }

  Future<bool> _handleSubmit() async {
    if (_titleController.text.trim().isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)?.titleCannotBeEmpty ?? 'Title cannot be empty'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return false;
    }

    try {
      setState(() {
        _isSubmitting = true;
      });

      final result = await SiteProxyFactory.getPrivateConversationProxy().saveRawConversationAsync(
        widget.conversationId,
        conversationTitle: _titleController.text.trim(),
        openInvite: _openInvite,
        conversationOpen: _conversationOpen,
      );

      if (!result.result) {
        final errorMessage = result.resultText?.trim();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage ?? AppLocalizations.of(context)?.failedToSaveConversation ?? 'Failed to save conversation'),
              backgroundColor: Theme.of(context).colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        return false;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)?.conversationUpdatedSuccessfully ?? 'Conversation updated successfully'),
            backgroundColor: Theme.of(context).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.of(context).pop(true); // Return true to indicate success
      }

      return true;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return false;
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
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
          'Edit Conversation',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: DesignTokens.fontWeightSemiBold,
          ),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 3,
        shadowColor: colorScheme.shadow.withOpacity(DesignTokens.opacityLow),
        surfaceTintColor: colorScheme.surfaceTint,
        iconTheme: IconThemeData(
          color: colorScheme.onSurface,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: _isSubmitting
                ? SizedBox(
                    width: DesignTokens.iconSizeL,
                    height: DesignTokens.iconSizeL,
                    child: CircularProgressIndicator(
                      strokeWidth: DesignTokens.borderWidthMedium,
                      color: colorScheme.onSurface,
                    ),
                  )
                : Icon(Icons.save_rounded, color: colorScheme.onSurface),
            onPressed: _isSubmitting ? null : _handleSubmit,
          ),
        ],
      ),
      body: FutureBuilder<FCRawConversationResult>(
        future: _rawConversationFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: DesignTokens.paddingL,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: colorScheme.error,
                    ),
                    SizedBox(height: DesignTokens.spacingM),
                    Text(
                      'Failed to load conversation',
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.error,
                      ),
                    ),
                    SizedBox(height: DesignTokens.spacingS),
                    Text(
                      snapshot.error.toString(),
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: DesignTokens.spacingL),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(AppLocalizations.of(context)?.goBack ?? 'Go Back'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (!snapshot.hasData || !snapshot.data!.result) {
            return Center(
              child: Padding(
                padding: DesignTokens.paddingL,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: colorScheme.error,
                    ),
                    SizedBox(height: DesignTokens.spacingM),
                    Text(
                      'Cannot edit this conversation',
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.error,
                      ),
                    ),
                    SizedBox(height: DesignTokens.spacingS),
                    Text(
                      snapshot.data?.resultText ?? 'Unknown error',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: DesignTokens.spacingL),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(AppLocalizations.of(context)?.goBack ?? 'Go Back'),
                    ),
                  ],
                ),
              ),
            );
          }

          final data = snapshot.data!;

          // Initialize fields if not already set (defer controller update to avoid setState during build)
          if (!_controllerInitialized) {
            _controllerInitialized = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && data.conversationTitle != null && _titleController.text.isEmpty) {
                _titleController.removeListener(_onFieldChanged);
                _titleController.text = data.conversationTitle!;
                _titleController.addListener(_onFieldChanged);
              }
            });
          }
          if (_openInvite == null) {
            _openInvite = data.openInvite ?? false;
          }
          if (_conversationOpen == null) {
            _conversationOpen = data.conversationOpen ?? true;
          }

          return SingleChildScrollView(
            padding: DesignTokens.paddingL,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title field
                Text(
                  'Title',
                  style: textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: DesignTokens.fontWeightMedium,
                  ),
                ),
                SizedBox(height: DesignTokens.spacingS),
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)?.enterConversationTitle ?? 'Enter conversation title',
                    hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                    filled: true,
                    fillColor: colorScheme.surfaceVariant.withOpacity(DesignTokens.opacityLow),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                      borderSide: BorderSide(
                        color: colorScheme.primary,
                        width: DesignTokens.borderWidthMedium,
                      ),
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: DesignTokens.spacingL),

                // Options section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Options',
                      style: textTheme.titleSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: DesignTokens.fontWeightMedium,
                      ),
                    ),
                    SizedBox(height: DesignTokens.spacingS),
                    Container(
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceVariant.withOpacity(DesignTokens.opacityLow),
                        borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                      ),
                      child: Column(
                        children: [
                          // Open Invite toggle
                          SwitchListTile(
                            title: Text(
                              'Open Invite',
                              style: textTheme.titleSmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: DesignTokens.fontWeightMedium,
                              ),
                            ),
                            subtitle: Text(
                              'Allow any participant to invite others',
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            value: _openInvite ?? false,
                            onChanged: (value) {
                              setState(() {
                                _openInvite = value;
                                _hasChanges = true;
                              });
                            },
                            activeColor: colorScheme.primary,
                          ),
                          Divider(
                            height: 1,
                            thickness: 1,
                            color: colorScheme.outlineVariant.withOpacity(0.3),
                          ),
                          // Conversation Open toggle
                          SwitchListTile(
                            title: Text(
                              'Conversation Open',
                              style: textTheme.titleSmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: DesignTokens.fontWeightMedium,
                              ),
                            ),
                            subtitle: Text(
                              _conversationOpen == true ? 'Conversation is open for replies' : 'Conversation is closed (no replies allowed)',
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            value: _conversationOpen ?? true,
                            onChanged: (value) {
                              setState(() {
                                _conversationOpen = value;
                                _hasChanges = true;
                              });
                            },
                            activeColor: colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
