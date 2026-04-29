import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import 'package:forumcopilot_flutter/controllers/login_controller.dart';
import 'package:forumcopilot_flutter/theme/design_tokens.dart';
import 'package:forumcopilot_flutter/theme/style_builders.dart';
import 'package:forumcopilot_flutter/views/widgets/forum_header_widget.dart';
import 'package:forumcopilot_sdk/models/entities/fc_tfa_provider.dart';
import 'package:get/get.dart';

/// Result returned from TFA input prompt
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

/// Full-screen prompt for entering two-factor authentication code.
class TFAInputDialog extends StatefulWidget {
  final List<FCTFAProvider>? providers;
  final String? defaultProviderId;
  final String? errorMessage;

  const TFAInputDialog({
    super.key,
    this.providers,
    this.defaultProviderId,
    this.errorMessage,
  });

  /// Show the TFA input page and return the result.
  static Future<TFADialogResult?> show({
    required List<FCTFAProvider>? providers,
    String? defaultProviderId,
    String? errorMessage,
  }) async {
    return Get.to<TFADialogResult>(
      () => TFAInputDialog(
        providers: providers,
        defaultProviderId: defaultProviderId,
        errorMessage: errorMessage,
      ),
      fullscreenDialog: true,
      preventDuplicates: false,
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
    _selectedProviderId = widget.defaultProviderId;

    final effective = _effectiveProviders;
    if (_selectedProviderId == null &&
        effective != null &&
        effective.isNotEmpty) {
      _selectedProviderId = effective.first.id;
    }

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

  List<FCTFAProvider>? get _effectiveProviders {
    final list = widget.providers;
    if (list == null || list.isEmpty) return list;
    if (LoginController.isPasskeySupportedByPlatform) return list;
    final filtered =
        list.where((p) => p.type != 'passkey' && p.id != 'passkey').toList();
    return filtered.isEmpty ? list : filtered;
  }

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

  int get _expectedCodeLength {
    final provider = _selectedProvider;
    if (provider == null) return 6;
    if (_isPasskeySelected) return 0;
    return provider.id == 'backup' ? 9 : 6;
  }

  String? _validateCode(String? value) {
    if (_isPasskeySelected) {
      return null;
    }

    final l10n = AppLocalizations.of(context);
    if (value == null || value.isEmpty) {
      return l10n?.pleaseEnterYourAuthenticationCode ??
          'Please enter your authentication code';
    }

    final cleaned = value.replaceAll(RegExp(r'[\s-]'), '');

    if (cleaned.length != _expectedCodeLength) {
      return l10n?.codeMustBeDigits(_expectedCodeLength) ??
          'Code must be $_expectedCodeLength digits';
    }

    if (!RegExp(r'^\d+$').hasMatch(cleaned)) {
      return l10n?.codeMustContainOnlyNumbers ??
          'Code must contain only numbers';
    }

    return null;
  }

  void _selectProvider(String providerId) {
    setState(() {
      _selectedProviderId = providerId;
      _codeController.clear();
    });

    if (!_isPasskeySelected) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _codeFocusNode.requestFocus();
        }
      });
    }
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
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      final cleanedCode = _codeController.text.replaceAll(RegExp(r'[\s-]'), '');

      Get.back(
        result: TFADialogResult(
          code: cleanedCode,
          provider: _selectedProviderId!,
          usePasskey: false,
        ),
      );
    }
  }

  IconData _providerIcon(FCTFAProvider provider) {
    if (provider.type == 'passkey' || provider.id == 'passkey') {
      return Icons.key_rounded;
    }
    if (provider.id == 'backup') {
      return Icons.confirmation_number_outlined;
    }
    if (provider.id == 'email') {
      return Icons.email_outlined;
    }
    return Icons.verified_user_outlined;
  }

  Widget _buildSelectedProviderContent(
    BuildContext context,
    FCTFAProvider provider,
    ColorScheme colorScheme,
    TextTheme textTheme,
    AppLocalizations? l10n,
  ) {
    final isPasskeyProvider =
        provider.type == 'passkey' || provider.id == 'passkey';
    final expectedCodeLength = provider.id == 'backup' ? 9 : 6;

    if (isPasskeyProvider) {
      return Container(
        width: double.infinity,
        padding: DesignTokens.paddingL,
        decoration: BoxDecoration(
          color: colorScheme.secondaryContainer.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(DesignTokens.radiusL),
        ),
        child: Text(
          l10n?.passkeyContinuePrompt ?? 'Use your passkey to continue',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSecondaryContainer,
            fontWeight: DesignTokens.fontWeightMedium,
          ),
        ),
      );
    }

    return TextFormField(
      controller: _codeController,
      focusNode: _codeFocusNode,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      maxLength: expectedCodeLength,
      autofillHints: const [AutofillHints.oneTimeCode],
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      decoration: StyleBuilders.inputDecoration(
        colorScheme: colorScheme,
        labelText: l10n?.authenticationCodeLabel ?? 'Authentication Code',
        hintText: AppLocalizations.of(context)?.enterCode(expectedCodeLength) ??
            'Enter $expectedCodeLength-digit code',
        prefixIcon: Icons.lock_outline_rounded,
        fillColor: colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacingL,
          vertical: DesignTokens.spacingL,
        ),
      ).copyWith(counterText: ''),
      style: textTheme.titleLarge?.copyWith(
        fontWeight: DesignTokens.fontWeightBold,
        letterSpacing: 4,
        color: colorScheme.onSurface,
      ),
      validator: _validateCode,
      onFieldSubmitted: (_) => _handleSubmit(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);

    final effectiveProviders = _effectiveProviders;
    final providerOptions = effectiveProviders ?? const <FCTFAProvider>[];
    final hasMultipleProviders =
        effectiveProviders != null && effectiveProviders.length > 1;
    final actionLabel = _isPasskeySelected
        ? (l10n?.usePasskey ?? 'Use Passkey')
        : (l10n?.verifyButton ?? 'Verify');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n?.twoFactorAuthentication ?? 'Two-Factor Authentication',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: DesignTokens.fontWeightBold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Get.back(),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
      ),
      backgroundColor: colorScheme.surface,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const ForumHeaderWidget(
                        boardStats: null,
                        extendUnderAppBar: false,
                      ),
                      Padding(
                        padding: DesignTokens.paddingScreen,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 560),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  l10n?.twoFactorAuthentication ??
                                      'Two-Factor Authentication',
                                  style: textTheme.headlineSmall?.copyWith(
                                    color: colorScheme.onSurface,
                                    fontWeight: DesignTokens.fontWeightBold,
                                  ),
                                ),
                                const SizedBox(height: DesignTokens.spacingXL),
                                if (hasMultipleProviders) ...[
                                  ...providerOptions.map((provider) {
                                    final isSelected =
                                        provider.id == _selectedProviderId;
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: DesignTokens.spacingM,
                                      ),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(
                                          DesignTokens.radiusL,
                                        ),
                                        onTap: () =>
                                            _selectProvider(provider.id),
                                        child: AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 180),
                                          padding: DesignTokens.paddingL,
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? colorScheme.primaryContainer
                                                : colorScheme
                                                    .surfaceContainerHighest
                                                    .withValues(alpha: 0.3),
                                            borderRadius: BorderRadius.circular(
                                              DesignTokens.radiusL,
                                            ),
                                            border: Border.all(
                                              color: isSelected
                                                  ? colorScheme.primary
                                                  : colorScheme.outlineVariant,
                                              width: isSelected
                                                  ? DesignTokens
                                                      .borderWidthMedium
                                                  : DesignTokens
                                                      .borderWidthThin,
                                            ),
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Icon(
                                                _providerIcon(provider),
                                                color: isSelected
                                                    ? colorScheme.primary
                                                    : colorScheme
                                                        .onSurfaceVariant,
                                              ),
                                              const SizedBox(
                                                width: DesignTokens.spacingM,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      provider.title,
                                                      style: textTheme
                                                          .titleSmall
                                                          ?.copyWith(
                                                        color: colorScheme
                                                            .onSurface,
                                                        fontWeight: DesignTokens
                                                            .fontWeightSemiBold,
                                                      ),
                                                    ),
                                                    if (isSelected &&
                                                        provider.description
                                                            .trim()
                                                            .isNotEmpty) ...[
                                                      const SizedBox(
                                                        height: DesignTokens
                                                            .spacingXS,
                                                      ),
                                                      Text(
                                                        provider.description,
                                                        style: textTheme
                                                            .bodySmall
                                                            ?.copyWith(
                                                          color: colorScheme
                                                              .onSurfaceVariant,
                                                          height: DesignTokens
                                                              .lineHeightNormal,
                                                        ),
                                                      ),
                                                    ],
                                                    if (isSelected) ...[
                                                      const SizedBox(
                                                        height: DesignTokens
                                                            .spacingM,
                                                      ),
                                                      _buildSelectedProviderContent(
                                                        context,
                                                        provider,
                                                        colorScheme,
                                                        textTheme,
                                                        l10n,
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                width: DesignTokens.spacingS,
                                              ),
                                              Icon(
                                                isSelected
                                                    ? Icons
                                                        .radio_button_checked_rounded
                                                    : Icons
                                                        .radio_button_off_rounded,
                                                color: isSelected
                                                    ? colorScheme.primary
                                                    : colorScheme.outline,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                                if (!hasMultipleProviders &&
                                    providerOptions.isNotEmpty) ...[
                                  Container(
                                    padding: DesignTokens.paddingL,
                                    decoration: BoxDecoration(
                                      color: colorScheme.primaryContainer
                                          .withValues(alpha: 0.6),
                                      borderRadius: BorderRadius.circular(
                                        DesignTokens.radiusL,
                                      ),
                                      border: Border.all(
                                        color: colorScheme.primary,
                                        width: DesignTokens.borderWidthMedium,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(
                                              _providerIcon(
                                                  providerOptions.first),
                                              color: colorScheme.primary,
                                            ),
                                            const SizedBox(
                                              width: DesignTokens.spacingM,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    providerOptions.first.title,
                                                    style: textTheme.titleSmall
                                                        ?.copyWith(
                                                      color:
                                                          colorScheme.onSurface,
                                                      fontWeight: DesignTokens
                                                          .fontWeightSemiBold,
                                                    ),
                                                  ),
                                                  if (providerOptions
                                                      .first.description
                                                      .trim()
                                                      .isNotEmpty) ...[
                                                    const SizedBox(
                                                      height: DesignTokens
                                                          .spacingXS,
                                                    ),
                                                    Text(
                                                      providerOptions
                                                          .first.description,
                                                      style: textTheme.bodySmall
                                                          ?.copyWith(
                                                        color: colorScheme
                                                            .onSurfaceVariant,
                                                        height: DesignTokens
                                                            .lineHeightNormal,
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: DesignTokens.spacingM,
                                        ),
                                        _buildSelectedProviderContent(
                                          context,
                                          providerOptions.first,
                                          colorScheme,
                                          textTheme,
                                          l10n,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                if (widget.errorMessage != null &&
                                    widget.errorMessage!.isNotEmpty) ...[
                                  const SizedBox(
                                    height: DesignTokens.spacingL,
                                  ),
                                  Container(
                                    padding: DesignTokens.paddingL,
                                    decoration: BoxDecoration(
                                      color: colorScheme.errorContainer,
                                      borderRadius: BorderRadius.circular(
                                        DesignTokens.radiusL,
                                      ),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.error_outline_rounded,
                                          color: colorScheme.onErrorContainer,
                                          size: 20,
                                        ),
                                        const SizedBox(
                                          width: DesignTokens.spacingS,
                                        ),
                                        Expanded(
                                          child: Text(
                                            widget.errorMessage!,
                                            style:
                                                textTheme.bodyMedium?.copyWith(
                                              color:
                                                  colorScheme.onErrorContainer,
                                              height:
                                                  DesignTokens.lineHeightNormal,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                const SizedBox(
                                  height: DesignTokens.spacingXXXL,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: DesignTokens.paddingScreen,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 560),
                            child: FilledButton(
                              onPressed: _handleSubmit,
                              style: FilledButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: DesignTokens.spacingL,
                                ),
                                backgroundColor: colorScheme.primary,
                                foregroundColor: colorScheme.onPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    DesignTokens.radiusL,
                                  ),
                                ),
                                elevation: DesignTokens.elevationMedium,
                              ),
                              child: Text(
                                actionLabel,
                                style: StyleBuilders.titleTextStyle(
                                  colorScheme: colorScheme,
                                  textTheme: textTheme,
                                  color: colorScheme.onPrimary,
                                  fontWeight: DesignTokens.fontWeightBold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: DesignTokens.spacingL),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
