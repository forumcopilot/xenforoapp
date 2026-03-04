import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import 'package:forumcopilot_flutter/controllers/login_controller.dart';
import 'package:forumcopilot_flutter/theme/design_tokens.dart';
import 'package:forumcopilot_sdk/models/entities/fc_tfa_provider.dart';
import 'package:get/get.dart';

/// Result returned from TFA input dialog
class TFADialogResult {
  final String code;
  final String provider;
  final bool usePasskey;

  TFADialogResult({
    required this.code,
    required this.provider,
    required this.usePasskey,
  });
}

/// Dialog for entering two-factor authentication code
class TFAInputDialog extends StatefulWidget {
  final List<FCTFAProvider>? providers;
  final String? defaultProviderId;
  final String? errorMessage;

  const TFAInputDialog({
    Key? key,
    this.providers,
    this.defaultProviderId,
    this.errorMessage,
  }) : super(key: key);

  /// Show the TFA input dialog and return the result
  static Future<TFADialogResult?> show({
    required List<FCTFAProvider>? providers,
    String? defaultProviderId,
    String? errorMessage,
  }) async {
    return await Get.dialog<TFADialogResult>(
      TFAInputDialog(
        providers: providers,
        defaultProviderId: defaultProviderId,
        errorMessage: errorMessage,
      ),
      barrierDismissible: false,
    );
  }

  @override
  State<TFAInputDialog> createState() => _TFAInputDialogState();
}

class _TFAInputDialogState extends State<TFAInputDialog> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _codeFocusNode = FocusNode();
  String? _selectedProviderId;

  @override
  void initState() {
    super.initState();
    // Set default provider
    _selectedProviderId = widget.defaultProviderId;

    // If no default provider and providers exist, use first effective one
    final effective = _effectiveProviders;
    if (_selectedProviderId == null && effective != null && effective.isNotEmpty) {
      _selectedProviderId = effective.first.id;
    }

    // Focus on code input after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isPasskeySelected) {
        _codeFocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    _codeFocusNode.dispose();
    super.dispose();
  }

  /// Providers to show: exclude passkey on platforms where it is not supported.
  /// If the only option is passkey (e.g. on macOS), keep the list so the dialog still shows and the user gets a friendly error when choosing passkey.
  List<FCTFAProvider>? get _effectiveProviders {
    final list = widget.providers;
    if (list == null || list.isEmpty) return list;
    if (LoginController.isPasskeySupportedByPlatform) return list;
    final filtered = list.where((p) => p.type != 'passkey' && p.id != 'passkey').toList();
    return filtered.isEmpty ? list : filtered;
  }

  /// Get the selected provider (from effective list; falls back to first if selection was passkey on unsupported platform).
  FCTFAProvider? get _selectedProvider {
    final providers = _effectiveProviders;
    if (_selectedProviderId == null || providers == null || providers.isEmpty) {
      return null;
    }
    try {
      return providers.firstWhere((p) => p.id == _selectedProviderId);
    } catch (e) {
      return providers.first;
    }
  }

  bool get _isPasskeySelected {
    final provider = _selectedProvider;
    if (provider == null) return false;
    return provider.type == 'passkey' || provider.id == 'passkey';
  }

  /// Get the expected code length for the selected provider
  int get _expectedCodeLength {
    final provider = _selectedProvider;
    if (provider == null) return 6; // Default to 6
    if (_isPasskeySelected) return 0;

    // Backup codes are 9 digits, others are 6
    return provider.id == 'backup' ? 9 : 6;
  }

  /// Validate TFA code format
  String? _validateCode(String? value) {
    if (_isPasskeySelected) {
      return null;
    }
    if (value == null || value.isEmpty) {
      return 'Please enter your authentication code';
    }

    // Remove spaces and hyphens
    final cleaned = value.replaceAll(RegExp(r'[\s-]'), '');

    if (cleaned.length != _expectedCodeLength) {
      return 'Code must be $_expectedCodeLength digits';
    }

    if (!RegExp(r'^\d+$').hasMatch(cleaned)) {
      return 'Code must contain only numbers';
    }

    return null;
  }

  void _handleSubmit() {
    if (_selectedProviderId == null) {
      return;
    }
    if (_isPasskeySelected) {
      Get.back(
          result: TFADialogResult(
        code: '',
        provider: _selectedProviderId!,
        usePasskey: true,
      ));
      return;
    }

    if (_formKey.currentState!.validate()) {
      // Clean the code (remove spaces/hyphens)
      final cleanedCode = _codeController.text.replaceAll(RegExp(r'[\s-]'), '');

      Get.back(
          result: TFADialogResult(
        code: cleanedCode,
        provider: _selectedProviderId!,
        usePasskey: false,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);

    final hasMultipleProviders = _effectiveProviders != null && _effectiveProviders!.length > 1;
    final selectedProvider = _selectedProvider;
    final actionLabel = _isPasskeySelected ? (l10n?.usePasskey ?? 'Use Passkey') : 'Verify';

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          Icon(
            Icons.security_rounded,
            color: colorScheme.primary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Two-Factor Authentication',
              style: TextStyle(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter your two-factor authentication code',
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),

            // Provider selector (if multiple providers)
            if (hasMultipleProviders) ...[
              const SizedBox(height: DesignTokens.spacingL),
              ..._effectiveProviders!.map((provider) {
                return RadioListTile<String>(
                  title: Text(
                    provider.title,
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: DesignTokens.fontSizeM,
                    ),
                  ),
                  value: provider.id,
                  groupValue: _selectedProviderId,
                  onChanged: (value) {
                    setState(() {
                      _selectedProviderId = value;
                      _codeController.clear();
                    });
                  },
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                );
              }),
            ] else if (selectedProvider != null) ...[
              const SizedBox(height: DesignTokens.spacingXS),
              Text(
                selectedProvider.title,
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: DesignTokens.fontSizeS,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],

            const SizedBox(height: DesignTokens.spacingL),
            if (_isPasskeySelected) ...[
              Text(
                l10n?.passkeyContinuePrompt ?? 'Use your passkey to continue',
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
            ] else ...[
              TextFormField(
                controller: _codeController,
                focusNode: _codeFocusNode,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: _expectedCodeLength,
                decoration: InputDecoration(
                  labelText: 'Authentication Code',
                  hintText: AppLocalizations.of(context)?.enterCode(_expectedCodeLength) ?? 'Enter $_expectedCodeLength-digit code',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  counterText: '',
                  prefixIcon: Icon(
                    Icons.lock_outline_rounded,
                    color: colorScheme.primary,
                  ),
                ),
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeXL,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                  color: colorScheme.onSurface,
                ),
                validator: _validateCode,
                onFieldSubmitted: (_) => _handleSubmit(),
              ),
            ],

            // Error message display
            if (widget.errorMessage != null && widget.errorMessage!.isNotEmpty) ...[
              const SizedBox(height: DesignTokens.spacingM),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      color: colorScheme.onErrorContainer,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.errorMessage!,
                        style: TextStyle(
                          color: colorScheme.onErrorContainer,
                          fontSize: DesignTokens.fontSizeS,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: Text(
            AppLocalizations.of(context)?.cancel ?? 'Cancel',
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        FilledButton(
          onPressed: _handleSubmit,
          style: FilledButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            actionLabel,
            style: TextStyle(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
      backgroundColor: colorScheme.surface,
      elevation: 8,
    );
  }
}
