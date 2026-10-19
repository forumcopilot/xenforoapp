import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import 'package:forumcopilot_flutter/controllers/login_controller.dart';
import 'package:forumcopilot_flutter/theme/design_tokens.dart';
import 'package:forumcopilot_flutter/theme/style_builders.dart';
import 'package:forumcopilot_flutter/controllers/site_controller.dart';
import 'package:forumcopilot_flutter/views/widgets/forum_icon_tile.dart';
import 'package:forumcopilot_sdk/models/entities/fc_tfa_provider.dart';
import 'package:get/get.dart';

/// Result returned from TFA input prompt
class TFADialogResult {
  final String code;
  final String provider;
  final bool usePasskey;

  /// Skip two-step verification on this device next time (XenForo's
  /// "Trust this device"). It was always on, and the screen did not say so.
  final bool trustDevice;

  TFADialogResult({
    required this.code,
    required this.provider,
    required this.usePasskey,
    this.trustDevice = true,
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
  bool _trustDevice = true;
  bool _submitted = false;

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
      return l10n.pleaseEnterYourAuthenticationCode;
    }

    final cleaned = value.replaceAll(RegExp(r'[\s-]'), '');

    if (cleaned.length != _expectedCodeLength) {
      return l10n.codeMustBeDigits(_expectedCodeLength);
    }

    if (!RegExp(r'^\d+$').hasMatch(cleaned)) {
      return l10n.codeMustContainOnlyNumbers;
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
    if (_selectedProviderId == null || _submitted) {
      return;
    }

    if (_isPasskeySelected) {
      _submitted = true;
      Get.back(
        result: TFADialogResult(
          code: '',
          provider: _selectedProviderId!,
          usePasskey: true,
          trustDevice: _trustDevice,
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      final cleanedCode = _codeController.text.replaceAll(RegExp(r'[\s-]'), '');
      _submitted = true;
      Get.back(
        result: TFADialogResult(
          code: cleanedCode,
          provider: _selectedProviderId!,
          usePasskey: false,
          trustDevice: _trustDevice,
        ),
      );
    }
  }

  /// Sends the code as soon as it is complete (6 digits, 9 for a backup
  /// code), as most apps do: the Verify button was under the keyboard.
  void _onCodeChanged(String value) {
    final cleaned = value.replaceAll(RegExp(r'[\s-]'), '');
    if (cleaned.length == _expectedCodeLength && RegExp(r'^\d+$').hasMatch(cleaned)) {
      _handleSubmit();
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

  /// The code field under the chosen method, the card's full width. A
  /// passkey needs none: the button says "Use passkey".
  Widget _buildCodeField(ColorScheme colorScheme, TextTheme textTheme, AppLocalizations l10n) {
    final expectedCodeLength = _expectedCodeLength;
    return TextFormField(
      controller: _codeController,
      focusNode: _codeFocusNode,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      maxLength: expectedCodeLength,
      autofillHints: const [AutofillHints.oneTimeCode],
      textInputAction: TextInputAction.done,
      decoration: StyleBuilders.inputDecoration(
        colorScheme: colorScheme,
        labelText: l10n.authenticationCodeLabel,
        hintText: l10n.enterCode(expectedCodeLength),
        prefixIcon: Icons.lock_outline_rounded,
        fillColor: colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacingL,
          vertical: DesignTokens.spacingL,
        ),
      ).copyWith(
        counterText: '',
        // The code's own wide, bold style cut the hint to "Enter 6-di…".
        hintStyle: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
      ),
      style: textTheme.titleLarge?.copyWith(
        fontWeight: DesignTokens.fontWeightBold,
        letterSpacing: 4,
        color: colorScheme.onSurface,
      ),
      validator: _validateCode,
      onChanged: _onCodeChanged,
      onFieldSubmitted: (_) => _handleSubmit(),
    );
  }

  Widget _buildProviderCard(
    FCTFAProvider provider, {
    required bool isSelected,
    required bool selectable,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    required AppLocalizations l10n,
  }) {
    final description = provider.description.trim();
    final isPasskey = provider.type == 'passkey' || provider.id == 'passkey';
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignTokens.spacingM),
      child: Material(
        color: isSelected
            ? colorScheme.primaryContainer
            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusL),
          side: BorderSide(
            color: isSelected ? colorScheme.primary : colorScheme.outlineVariant,
            width: isSelected ? DesignTokens.borderWidthMedium : DesignTokens.borderWidthThin,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: selectable ? () => _selectProvider(provider.id) : null,
          child: Padding(
            padding: DesignTokens.paddingL,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      _providerIcon(provider),
                      color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: DesignTokens.spacingM),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            provider.title,
                            style: textTheme.titleSmall?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: DesignTokens.fontWeightSemiBold,
                            ),
                          ),
                          if (isSelected && description.isNotEmpty) ...[
                            const SizedBox(height: DesignTokens.spacingXS),
                            Text(
                              description,
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                height: DesignTokens.lineHeightNormal,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (selectable) ...[
                      const SizedBox(width: DesignTokens.spacingS),
                      Icon(
                        isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                        color: isSelected ? colorScheme.primary : colorScheme.outline,
                      ),
                    ],
                  ],
                ),
                if (isSelected && !isPasskey) ...[
                  const SizedBox(height: DesignTokens.spacingM),
                  _buildCodeField(colorScheme, textTheme, l10n),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Which forum is asking: its icon, name and address, in one row. The
  /// patterned banner took a quarter of the screen, and with the keyboard up
  /// pushed the code field down.
  Widget _buildForumIdentity(ColorScheme colorScheme, TextTheme textTheme) {
    // The app registers it at start; never create one here (that would set
    // the app up again).
    if (!Get.isRegistered<SiteController>()) return const SizedBox.shrink();
    final siteController = Get.find<SiteController>();
    return Obx(() {
      final site = siteController.currentSite.value;
      if (site == null) return const SizedBox.shrink();
      final host = Uri.tryParse(site.url)?.host ?? '';
      return Padding(
        padding: const EdgeInsets.only(bottom: DesignTokens.spacingXL),
        child: Row(
          children: [
            ForumIconTile(name: site.displayName, url: site.logoUrl, size: 40),
            const SizedBox(width: DesignTokens.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    site.displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleMedium?.copyWith(color: colorScheme.onSurface),
                  ),
                  if (host.isNotEmpty)
                    Text(
                      host,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);

    final providerOptions = _effectiveProviders ?? const <FCTFAProvider>[];
    final hasMultipleProviders = providerOptions.length > 1;
    final actionLabel = _isPasskeySelected ? l10n.usePasskey : l10n.verifyButton;
    final errorMessage = widget.errorMessage;

    return Scaffold(
      appBar: AppBar(
        // The page's one title (the body repeated it).
        title: Text(l10n.twoFactorAuthentication),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: () => Get.back(),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
      ),
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  // Always scrollable: the keyboard closing used to make the
                  // page fit, and Flutter turned scrolling off mid-drag
                  // ("Build scheduled during frame" in debug builds).
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: DesignTokens.paddingScreen,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 560),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildForumIdentity(colorScheme, textTheme),
                          for (final provider in providerOptions)
                            _buildProviderCard(
                              provider,
                              isSelected: !hasMultipleProviders || provider.id == _selectedProvider?.id,
                              selectable: hasMultipleProviders,
                              colorScheme: colorScheme,
                              textTheme: textTheme,
                              l10n: l10n,
                            ),
                          if (errorMessage != null && errorMessage.isNotEmpty)
                            Container(
                              margin: const EdgeInsets.only(bottom: DesignTokens.spacingM),
                              padding: DesignTokens.paddingL,
                              decoration: BoxDecoration(
                                color: colorScheme.errorContainer,
                                borderRadius: BorderRadius.circular(DesignTokens.radiusL),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.error_outline_rounded, color: colorScheme.onErrorContainer, size: 20),
                                  const SizedBox(width: DesignTokens.spacingS),
                                  Expanded(
                                    child: Text(
                                      errorMessage,
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: colorScheme.onErrorContainer,
                                        height: DesignTokens.lineHeightNormal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          // XenForo's "Trust this device", on by default as
                          // before, now where it can be seen and turned off.
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            value: _trustDevice,
                            onChanged: (value) => setState(() => _trustDevice = value),
                            title: Text(l10n.trustThisDevice),
                            subtitle: Text(l10n.trustThisDeviceHint),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Pinned under the list, so it rides above the keyboard; it sat
              // at the end of the scroll view, under the keyboard.
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  DesignTokens.spacingL,
                  DesignTokens.spacingS,
                  DesignTokens.spacingL,
                  DesignTokens.spacingL,
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: SizedBox(
                      width: double.infinity,
                      // A standard full-width button: it shrank to its label,
                      // drawn so large that "Use Passkey" spilled out of it.
                      child: FilledButton(
                        onPressed: _handleSubmit,
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(52),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(DesignTokens.radiusL),
                          ),
                        ),
                        child: Text(actionLabel),
                      ),
                    ),
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
