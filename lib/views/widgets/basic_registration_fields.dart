import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:forumcopilot_flutter/views/widgets/forum_header_widget.dart';
import '../../theme/design_tokens.dart';
import '../../theme/style_builders.dart';

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
        Padding(
          padding: DesignTokens.paddingScreenHorizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Username field
              _buildTextField(
                controller: usernameController,
                labelText: 'Username',
                icon: Icons.person_rounded,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => emailFocusNode.requestFocus(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  if (value.length < 3) {
                    return 'Username must be at least 3 characters';
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
                labelText: 'Email',
                icon: Icons.email_rounded,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => passwordFocusNode.requestFocus(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!GetUtils.isEmail(value)) {
                    return 'Please enter a valid email';
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
                labelText: 'Password',
                isVisible: isPasswordVisible,
                onVisibilityToggle: onPasswordVisibilityToggle,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => confirmPasswordFocusNode.requestFocus(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
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
                labelText: 'Confirm Password',
                isVisible: isConfirmPasswordVisible,
                onVisibilityToggle: onConfirmPasswordVisibilityToggle,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => onConfirmPasswordSubmitted?.call(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                colorScheme: colorScheme,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    FocusNode? focusNode,
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
