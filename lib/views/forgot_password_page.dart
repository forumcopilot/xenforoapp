import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/factory/site_proxy_factory.dart';
import 'package:get/get.dart';
import 'package:forumcopilot_flutter/views/widgets/forum_header_widget.dart';
import '../theme/design_tokens.dart';

class ForgotPasswordPage extends StatefulWidget {
  final SiteContext siteContext;
  const ForgotPasswordPage({
    required this.siteContext,
    super.key,
  });

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final accountProxy = SiteProxyFactory.getAccountProxy();
        final inputValue = _usernameController.text.trim();

        debugPrint('[ForgotPasswordPage] Attempting forgetPassword API call with input: $inputValue');
        debugPrint('[ForgotPasswordPage] Forum URL: ${widget.siteContext.site.pluginUrl}');

        final result = await accountProxy.forgetPassword(
          inputValue, // Use the input value (email or username)
          '', // token - using empty string as per existing pattern
          '', // code - using empty string as per existing pattern
        );

        debugPrint('[ForgotPasswordPage] forgetPassword API result: result=${result.result}, resultText=${result.resultText}');

        if (result.result) {
          debugPrint('[ForgotPasswordPage] Password reset request successful');

          // Show success popup dialog
          _showForgotPasswordSuccessDialog(result.resultText);
        } else {
          debugPrint('[ForgotPasswordPage] Password reset request failed: ${result.resultText}');
          // Show error dialog with actual error message from server
          _showForgotPasswordErrorDialog(result.resultText);
        }
      } catch (e) {
        debugPrint('[ForgotPasswordPage] forgetPassword API exception: ${e.toString()}');
        debugPrint('[ForgotPasswordPage] Exception type: ${e.runtimeType}');
        // Show error dialog with exception message
        _showForgotPasswordErrorDialog(AppLocalizations.of(context)!.errorSendingResetLink);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showForgotPasswordSuccessDialog(String? resultText) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusL),
          ),
          title: Row(
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: DesignTokens.spacingM),
              Expanded(
                child: Text(
                  l10n.resetLinkSent,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontWeight: DesignTokens.fontWeightBold,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (resultText != null && resultText.trim().isNotEmpty)
                Text(
                  resultText,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    height: DesignTokens.lineHeightNormal,
                  ),
                )
              else
                Text(
                  l10n.passwordResetInstructionsSent,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    height: DesignTokens.lineHeightNormal,
                  ),
                ),
            ],
          ),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacingXL,
                  vertical: DesignTokens.spacingM,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(DesignTokens.radiusL),
                ),
                elevation: DesignTokens.elevationMedium,
              ),
              child: Text(
                'OK',
                style: TextStyle(
                  color: colorScheme.onPrimary,
                  fontWeight: DesignTokens.fontWeightBold,
                ),
              ),
            ),
          ],
          backgroundColor: colorScheme.surface,
          elevation: 8,
        );
      },
    );
  }

  void _showForgotPasswordErrorDialog(String? errorMessage) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusL),
          ),
          title: Row(
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: colorScheme.error,
                size: 24,
              ),
              const SizedBox(width: DesignTokens.spacingM),
              Expanded(
                child: Text(
                  l10n.resetFailed,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontWeight: DesignTokens.fontWeightBold,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                errorMessage ?? l10n.unableToSendResetLink,
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  height: DesignTokens.lineHeightNormal,
                ),
              ),
            ],
          ),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacingXL,
                  vertical: DesignTokens.spacingM,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(DesignTokens.radiusL),
                ),
                elevation: DesignTokens.elevationMedium,
              ),
              child: Text(
                l10n.okButton,
                style: TextStyle(
                  color: colorScheme.onPrimary,
                  fontWeight: DesignTokens.fontWeightBold,
                ),
              ),
            ),
          ],
          backgroundColor: colorScheme.surface,
          elevation: 8,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.forgotPasswordTitle,
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Get.back(),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Standard Forum Header
            ForumHeaderWidget(
              extendUnderAppBar: true,
            ),
            // Forgot Password Form
            Padding(
              padding: DesignTokens.paddingXL,
              child: _buildFormView(colorScheme, textTheme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormView(ColorScheme colorScheme, TextTheme textTheme) {
    final l10n = AppLocalizations.of(context)!;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _usernameController,
            enabled: !_isLoading,
            keyboardType: TextInputType.text,
            autocorrect: false,
            enableSuggestions: false,
            textCapitalization: TextCapitalization.none,
            decoration: InputDecoration(
              labelText: l10n.usernameOrEmailLabel,
              labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
              floatingLabelStyle: TextStyle(color: colorScheme.primary),
              prefixIcon: Icon(
                Icons.person_rounded,
                color: colorScheme.onSurfaceVariant,
              ),
              filled: true,
              fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(DesignTokens.radiusL),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(DesignTokens.radiusL),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(DesignTokens.radiusL),
                borderSide: BorderSide(
                  color: colorScheme.primary,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(DesignTokens.radiusL),
                borderSide: BorderSide(
                  color: colorScheme.error,
                  width: 2,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(DesignTokens.radiusL),
                borderSide: BorderSide(
                  color: colorScheme.error,
                  width: 2,
                ),
              ),
            ),
            textInputAction: TextInputAction.done,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.pleaseEnterUsernameOrEmail;
              }
              return null;
            },
            onFieldSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 32),
          FilledButton(
            onPressed: _isLoading ? null : _submit,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(DesignTokens.radiusL),
              ),
            ),
            child: _isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        colorScheme.onPrimary,
                      ),
                    ),
                  )
                : Text(
                    l10n.sendResetLink,
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: DesignTokens.fontWeightBold,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

