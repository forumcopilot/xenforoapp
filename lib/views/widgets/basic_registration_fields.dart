import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:forumcopilot_flutter/views/widgets/forum_header_widget.dart';
import '../../theme/design_tokens.dart';
import '../../theme/style_builders.dart';
import '../../l10n/generated/app_localizations.dart';

class BasicRegistrationFields extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;
  final FocusNode confirmPasswordFocusNode;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final VoidCallback onPasswordVisibilityToggle;
  final VoidCallback onConfirmPasswordVisibilityToggle;
  final VoidCallback? onConfirmPasswordSubmitted;
  final bool showHeader;

  const BasicRegistrationFields({
    Key? key,
    required this.usernameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.emailFocusNode,
    required this.passwordFocusNode,
    required this.confirmPasswordFocusNode,
    required this.isPasswordVisible,
    required this.isConfirmPasswordVisible,
    required this.onPasswordVisibilityToggle,
    required this.onConfirmPasswordVisibilityToggle,
    this.onConfirmPasswordSubmitted,
    this.showHeader = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Standardized Forum Header (optional)
        if (showHeader) ...[
          ForumHeaderWidget(
            boardStats: null, // Registration doesn't need board stats
            extendUnderAppBar: false, // Don't extend under app bar
          ),
          const SizedBox(height: DesignTokens.spacingXL),
          const SizedBox(height: DesignTokens.spacingXL),
        ],

        // Fields with padding
        // Password managers fill these and offer to save the new account.
        Padding(
          padding: DesignTokens.paddingScreenHorizontal,
          child: AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Username field
              _buildTextField(
                controller: usernameController,
                autofillHints: const [AutofillHints.newUsername],
                labelText: AppLocalizations.of(context).usernameLabel,
                icon: Icons.person_rounded,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => emailFocusNode.requestFocus(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context).pleaseEnterAUsername;
                  }
                  if (value.length < 3) {
                    return AppLocalizations.of(context).usernameMinLength(3);
                  }
                  return null;
                },
                colorScheme: colorScheme,
              ),
              const SizedBox(height: DesignTokens.spacingL),

              // Email field
              _buildTextField(
                controller: emailController,
                focusNode: emailFocusNode,
                autofillHints: const [AutofillHints.email],
                labelText: AppLocalizations.of(context).emailLabel,
                icon: Icons.email_rounded,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => passwordFocusNode.requestFocus(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context).pleaseEnterEmail;
                  }
                  if (!GetUtils.isEmail(value)) {
                    return AppLocalizations.of(context).pleaseEnterValidEmail;
                  }
                  return null;
                },
                colorScheme: colorScheme,
              ),
              const SizedBox(height: DesignTokens.spacingL),

              // Password field
              _buildPasswordField(
                controller: passwordController,
                focusNode: passwordFocusNode,
                autofillHints: const [AutofillHints.newPassword],
                labelText: AppLocalizations.of(context).passwordLabel,
                isVisible: isPasswordVisible,
                onVisibilityToggle: onPasswordVisibilityToggle,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => confirmPasswordFocusNode.requestFocus(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context).pleaseEnterAPassword;
                  }
                  if (value.length < 6) {
                    return AppLocalizations.of(context).passwordMinLength(6);
                  }
                  return null;
                },
                colorScheme: colorScheme,
              ),
              const SizedBox(height: DesignTokens.spacingL),

              // Confirm Password field
              _buildPasswordField(
                controller: confirmPasswordController,
                focusNode: confirmPasswordFocusNode,
                autofillHints: const [AutofillHints.newPassword],
                labelText: AppLocalizations.of(context).confirmPasswordLabel,
                isVisible: isConfirmPasswordVisible,
                onVisibilityToggle: onConfirmPasswordVisibilityToggle,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => onConfirmPasswordSubmitted?.call(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context).pleaseConfirmPassword;
                  }
                  if (value != passwordController.text) {
                    return AppLocalizations.of(context).passwordsDoNotMatch;
                  }
                  return null;
                },
                colorScheme: colorScheme,
              ),
            ],
          ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    FocusNode? focusNode,
    required Iterable<String> autofillHints,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    required TextInputAction textInputAction,
    required Function(String) onFieldSubmitted,
    required String? Function(String?) validator,
    required ColorScheme colorScheme,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      autofillHints: autofillHints,
      // A username or an email address: no autocorrect.
      autocorrect: false,
      enableSuggestions: false,
      keyboardType: keyboardType,
      decoration: StyleBuilders.inputDecoration(
        colorScheme: colorScheme,
        labelText: labelText,
        prefixIcon: icon,
      ),
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required Iterable<String> autofillHints,
    required String labelText,
    required bool isVisible,
    required VoidCallback onVisibilityToggle,
    required TextInputAction textInputAction,
    required Function(String) onFieldSubmitted,
    required String? Function(String?) validator,
    required ColorScheme colorScheme,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      autofillHints: autofillHints,
      obscureText: !isVisible,
      decoration: StyleBuilders.inputDecoration(
        colorScheme: colorScheme,
        labelText: labelText,
        prefixIcon: Icons.lock_rounded,
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility_off_rounded : Icons.visibility_rounded,
            color: colorScheme.onSurfaceVariant,
          ),
          onPressed: onVisibilityToggle,
        ),
      ),
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
    );
  }
}
