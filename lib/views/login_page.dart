import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:get/get.dart';
import 'package:forumcopilot_flutter/controllers/global_loader_controller.dart';
import 'package:forumcopilot_flutter/controllers/login_controller.dart';
import 'package:forumcopilot_flutter/controllers/site_controller.dart';
import 'package:forumcopilot_flutter/views/widgets/forum_header_widget.dart';
import 'package:forumcopilot_flutter/views/site_home_page.dart';
import 'package:forumcopilot_flutter/utils/passkey_android_validation.dart';
import 'package:forumcopilot_flutter/utils/passkey_ios_validation.dart';
import 'package:forumcopilot_flutter/utils/passkey_validation_result.dart';
import 'forgot_password_page.dart';
import '../theme/design_tokens.dart';
import '../theme/style_builders.dart';

class LoginPage extends StatefulWidget {
  final SiteContext siteContext;
  const LoginPage({Key? key, required this.siteContext}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  bool _isPasswordVisible = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  Future<PasskeyValidationResult>? _passkeyValidationFuture;

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.siteContext.username ?? '';
    _passwordController.text = widget.siteContext.password ?? '';
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.forward();

    if (widget.siteContext.siteType == 'xenforo' &&
        LoginController.isPasskeySupportedByPlatform) {
      _passkeyValidationFuture = _validatePasskeyAvailability();
    }
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final loginController = Get.put(LoginController());
      final success = await loginController.handleLogin(
        siteContext: widget.siteContext,
        username: _usernameController.text,
        password: _passwordController.text,
      );

      if (success && mounted) {
        // Ensure loader is hidden so it does not block the next screen
        if (Get.isRegistered<GlobalLoaderController>()) {
          GlobalLoaderController.to.forceHide();
        }
        // Success means login completed - navigate away on next frame
        // Use addPostFrameCallback so navigation runs after current frame; works with
        // both Get.to() and Navigator.push() (e.g. from forum_app_bar)
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          try {
            if (Get.isRegistered<GlobalLoaderController>()) {
              GlobalLoaderController.to.forceHide();
            }
            final siteController = Get.find<SiteController>();
            final isSiteInitialized = siteController.isInitialized.value;
            final navigator = Navigator.of(context, rootNavigator: true);
            final canPop = navigator.canPop();

            if (isSiteInitialized && canPop) {
              navigator.pop(true);
            } else {
              Get.offAll(() => const SiteHomePage());
            }
          } catch (_) {
            if (Get.isRegistered<GlobalLoaderController>()) {
              GlobalLoaderController.to.forceHide();
            }
            Get.offAll(() => const SiteHomePage());
          }
        });
      }
    }
  }

  Future<void> _handlePasskeyLogin() async {
    final loginController = Get.put(LoginController());
    final success = await loginController.handlePasskeyLogin(
      siteContext: widget.siteContext,
    );

    if (success && mounted) {
      if (Get.isRegistered<GlobalLoaderController>()) {
        GlobalLoaderController.to.forceHide();
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        try {
          if (Get.isRegistered<GlobalLoaderController>()) {
            GlobalLoaderController.to.forceHide();
          }
          final siteController = Get.find<SiteController>();
          final isSiteInitialized = siteController.isInitialized.value;
          final navigator = Navigator.of(context, rootNavigator: true);
          final canPop = navigator.canPop();

          if (isSiteInitialized && canPop) {
            navigator.pop(true);
          } else {
            Get.offAll(() => const SiteHomePage());
          }
        } catch (_) {
          if (Get.isRegistered<GlobalLoaderController>()) {
            GlobalLoaderController.to.forceHide();
          }
          Get.offAll(() => const SiteHomePage());
        }
      });
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
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<PasskeyValidationResult> _validatePasskeyAvailability() async {
    final url = widget.siteContext.site.pluginUrl;
    final domain = _extractDomain(url);
    if (domain == null) {
      return const PasskeyValidationResult.enabled();
    }

    if (LoginController.isIOSPlatform) {
      return PasskeyIosValidationService.validateForDomain(domain);
    }

    if (LoginController.isAndroidPlatform) {
      return PasskeyAndroidValidationService.validateForDomain(domain);
    }

    return const PasskeyValidationResult.enabled();
  }

  String? _extractDomain(String url) {
    final trimmed = url.trim();
    if (trimmed.isEmpty) return null;

    final direct = Uri.tryParse(trimmed);
    if (direct != null && direct.host.isNotEmpty) {
      return direct.host;
    }

    final withScheme = Uri.tryParse('https://$trimmed');
    if (withScheme != null && withScheme.host.isNotEmpty) {
      return withScheme.host;
    }

    return null;
  }

  Widget _buildPasskeyButton({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    required AppLocalizations l10n,
    required bool enabled,
    int? errorCode,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton.icon(
          onPressed: enabled ? _handlePasskeyLogin : null,
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
            l10n.signInWithPasskey,
            style: StyleBuilders.titleTextStyle(
              colorScheme: colorScheme,
              textTheme: textTheme,
              color: colorScheme.primary,
              fontWeight: DesignTokens.fontWeightBold,
            ),
          ),
        ),
        if (!enabled && errorCode != null) ...[
          const SizedBox(height: DesignTokens.spacingS),
          Text(
            'Passkey is currently not availalbe in this forum (code: $errorCode)',
            style: StyleBuilders.smallTextStyle(
              colorScheme: colorScheme,
              textTheme: textTheme,
            ).copyWith(
              color: colorScheme.error,
              fontSize: DesignTokens.fontSizeXS,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
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
          l10n.loginTitle,
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
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Standardized Forum Header
              ForumHeaderWidget(
                boardStats: null, // Login page doesn't need board stats
                extendUnderAppBar: false, // Don't extend under app bar
              ),

              // Login Form
              Padding(
                padding: DesignTokens.paddingScreen,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Username field
                      TextFormField(
                        controller: _usernameController,
                        keyboardType: TextInputType.text,
                        autocorrect: false,
                        enableSuggestions: false,
                        textCapitalization: TextCapitalization.none,
                        decoration: StyleBuilders.inputDecoration(
                          colorScheme: colorScheme,
                          labelText: l10n.usernameLabel,
                          prefixIcon: Icons.person_rounded,
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          _passwordFocusNode.requestFocus();
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.pleaseEnterUsername;
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
                        decoration: StyleBuilders.inputDecoration(
                          colorScheme: colorScheme,
                          labelText: l10n.passwordLabel,
                          prefixIcon: Icons.lock_rounded,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility_off_rounded
                                  : Icons.visibility_rounded,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _handleLogin(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.pleaseEnterPassword;
                          }
                          return null;
                        },
                      ),
                      // Forgot password link
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => ForgotPasswordPage(
                                      siteContext: widget.siteContext)),
                            );
                          },
                          child: Text(
                            l10n.forgotPassword,
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: DesignTokens.fontWeightMedium,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: DesignTokens.spacingXL),
                      // Login button
                      FilledButton(
                        onPressed: _handleLogin,
                        style: FilledButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: DesignTokens.spacingL),
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(DesignTokens.radiusL),
                          ),
                          elevation: DesignTokens.elevationMedium,
                        ),
                        child: Text(
                          l10n.loginButton,
                          style: StyleBuilders.titleTextStyle(
                            colorScheme: colorScheme,
                            textTheme: textTheme,
                            color: colorScheme.onPrimary,
                            fontWeight: DesignTokens.fontWeightBold,
                          ),
                        ),
                      ),
                      if (widget.siteContext.siteType == 'xenforo' &&
                          LoginController.isPasskeySupportedByPlatform) ...[
                        const SizedBox(height: DesignTokens.spacingM),
                        if (_passkeyValidationFuture != null)
                          FutureBuilder<PasskeyValidationResult>(
                            future: _passkeyValidationFuture,
                            builder: (context, snapshot) {
                              final validation = snapshot.data;
                              final disabled = validation?.isDisabled ?? false;
                              final code = validation?.errorCode;

                              return _buildPasskeyButton(
                                colorScheme: colorScheme,
                                textTheme: textTheme,
                                l10n: l10n,
                                enabled: !disabled,
                                errorCode: code,
                              );
                            },
                          )
                        else
                          _buildPasskeyButton(
                            colorScheme: colorScheme,
                            textTheme: textTheme,
                            l10n: l10n,
                            enabled: true,
                          ),
                      ],
                      const SizedBox(height: DesignTokens.spacingXL),
                      // Advisory text about credentials being sent to forum domain
                      Obx(() {
                        final domain = _getSiteDomain();

                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: DesignTokens.spacingXS),
                          child: Text(
                            l10n.credentialsSentToDomain(domain),
                            style: StyleBuilders.smallTextStyle(
                              colorScheme: colorScheme,
                              textTheme: textTheme,
                            ).copyWith(
                              fontSize: DesignTokens.fontSizeXS,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }),
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
