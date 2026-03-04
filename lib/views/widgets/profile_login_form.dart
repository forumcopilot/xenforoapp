import 'package:flutter/material.dart';
import '../../theme/design_tokens.dart';
import 'package:get/get.dart';
import 'package:forumcopilot_flutter/controllers/login_controller.dart';
import 'package:forumcopilot_flutter/controllers/site_controller.dart';
import 'package:forumcopilot_flutter/views/register_page.dart';
import 'package:forumcopilot_flutter/views/forgot_password_page.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import '../../l10n/generated/app_localizations.dart';

class ProfileLoginForm extends StatefulWidget {
  final SiteContext siteContext;
  const ProfileLoginForm({Key? key, required this.siteContext}) : super(key: key);

  @override
  State<ProfileLoginForm> createState() => _ProfileLoginFormState();
}

class _ProfileLoginFormState extends State<ProfileLoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final loginController = Get.put(LoginController());
      final success = await loginController.handleLogin(siteContext: widget.siteContext, username: _usernameController.text, password: _passwordController.text, showSuccessMessage: true);

      if (success) {
        // Clear form
        _usernameController.clear();
        _passwordController.clear();
      }
    }
  }

  Future<void> _handlePasskeyLogin() async {
    final loginController = Get.put(LoginController());
    final success = await loginController.handlePasskeyLogin(
      siteContext: widget.siteContext,
      showSuccessMessage: true,
    );

    if (success) {
      _usernameController.clear();
      _passwordController.clear();
    }
  }

  /// Extract domain name from forum URL
  String _getSiteDomain() {
    final siteController = Get.put(SiteController());
    final siteUrl = siteController.currentSite.value?.url;

    if (siteUrl == null || siteUrl.isEmpty) {
      return 'this forum';
    }

    try {
      final uri = Uri.parse(siteUrl);
      return uri.host.isNotEmpty ? uri.host : 'this forum';
    } catch (e) {
      // Fallback if URL parsing fails
      return 'this forum';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Forum header is now handled by the Profile tab
          // No duplicate forum header here

          // Login Form Content
          Padding(
            padding: DesignTokens.paddingXL,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Welcome Text
                  Text(AppLocalizations.of(context)?.welcomeBack ?? 'Welcome Back',
                      style: textTheme.headlineMedium?.copyWith(color: colorScheme.onSurface, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  Text(AppLocalizations.of(context)?.signInToAccessYourProfile ?? 'Sign in to access your profile and manage your account',
                      style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant), textAlign: TextAlign.center),
                  const SizedBox(height: 32),
                  // Username field
                  TextFormField(
                    controller: _usernameController,
                    focusNode: _usernameFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      hintText: AppLocalizations.of(context)?.enterYourUsername ?? 'Enter your username',
                      prefixIcon: Icon(Icons.person_outline_rounded, color: colorScheme.onSurfaceVariant),
                      filled: true,
                      fillColor: colorScheme.surfaceVariant.withOpacity(DesignTokens.opacityLow),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(DesignTokens.radiusL), borderSide: BorderSide.none),
                      focusedBorder:
                          OutlineInputBorder(borderRadius: BorderRadius.circular(DesignTokens.radiusL), borderSide: BorderSide(color: colorScheme.primary, width: DesignTokens.borderWidthMedium)),
                      errorBorder:
                          OutlineInputBorder(borderRadius: BorderRadius.circular(DesignTokens.radiusL), borderSide: BorderSide(color: colorScheme.error, width: DesignTokens.borderWidthMedium)),
                    ),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => _passwordFocusNode.requestFocus(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: DesignTokens.spacingL),
                  // Password field
                  TextFormField(
                    controller: _passwordController,
                    focusNode: _passwordFocusNode,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: AppLocalizations.of(context)?.enterYourPassword ?? 'Enter your password',
                      prefixIcon: Icon(Icons.lock_outline_rounded, color: colorScheme.onSurfaceVariant),
                      suffixIcon: IconButton(
                        icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility, color: colorScheme.onSurfaceVariant),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: colorScheme.surfaceVariant.withOpacity(DesignTokens.opacityLow),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(DesignTokens.radiusL), borderSide: BorderSide.none),
                      focusedBorder:
                          OutlineInputBorder(borderRadius: BorderRadius.circular(DesignTokens.radiusL), borderSide: BorderSide(color: colorScheme.primary, width: DesignTokens.borderWidthMedium)),
                      errorBorder:
                          OutlineInputBorder(borderRadius: BorderRadius.circular(DesignTokens.radiusL), borderSide: BorderSide(color: colorScheme.error, width: DesignTokens.borderWidthMedium)),
                    ),
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _handleLogin(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  // Forgot password link
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ForgotPasswordPage(siteContext: widget.siteContext)));
                      },
                      child: Text(AppLocalizations.of(context)?.forgotPassword ?? 'Forgot password?', style: textTheme.bodyMedium?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.w500)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Login button
                  FilledButton(
                    onPressed: _handleLogin,
                    style: FilledButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: DesignTokens.spacingL),
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(DesignTokens.radiusL),
                      ),
                      elevation: DesignTokens.elevationMedium,
                    ),
                    child: Text(
                      'Login',
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: DesignTokens.fontWeightBold,
                      ),
                    ),
                  ),
                  if (widget.siteContext.siteType == 'xenforo' && LoginController.isPasskeySupportedByPlatform) ...[
                    const SizedBox(height: DesignTokens.spacingM),
                    OutlinedButton.icon(
                      onPressed: _handlePasskeyLogin,
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: DesignTokens.spacingL),
                        foregroundColor: colorScheme.primary,
                        side: BorderSide(color: colorScheme.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(DesignTokens.radiusL),
                        ),
                      ),
                      icon: Icon(Icons.key_rounded, color: colorScheme.primary),
                      label: Text(
                        l10n?.signInWithPasskey ?? 'Sign in with Passkey',
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: DesignTokens.fontWeightBold,
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: DesignTokens.spacingXL),
                  // Advisory text about credentials being sent to forum domain
                  Builder(
                    builder: (context) {
                      final domain = _getSiteDomain();

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                          'Your username and password will be sent to $domain',
                          style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant, fontSize: DesignTokens.fontSizeXS),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: DesignTokens.spacingL),
                  // Register link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(AppLocalizations.of(context)?.dontHaveAnAccount ?? 'Don\'t have an account?', style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant)),
                      TextButton(
                        onPressed: () {
                          Get.to(() => RegisterPage(siteContext: widget.siteContext));
                        },
                        child: Text(AppLocalizations.of(context)?.register ?? 'Register', style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
