import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import 'package:forumcopilot_sdk/models/entities/fc_custom_field_definition.dart';
import 'package:forumcopilot_sdk/models/registration/fc_registration_requirements.dart';
import 'package:get/get.dart';
import 'package:forumcopilot_flutter/views/login_page.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';
import 'package:forumcopilot_flutter/views/site_home_page.dart';
import 'package:forumcopilot_flutter/controllers/login_controller.dart';
import 'package:forumcopilot_flutter/controllers/site_controller.dart';
import 'package:forumcopilot_flutter/views/widgets/basic_registration_fields.dart';
import 'package:forumcopilot_flutter/views/additional_information_page.dart';
import 'package:forumcopilot_flutter/services/site_proxy_service.dart';
import 'package:forumcopilot_flutter/services/location_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import '../theme/design_tokens.dart';
import '../theme/style_builders.dart';

class RegisterPage extends StatefulWidget {
  final SiteContext siteContext;

  const RegisterPage({Key? key, required this.siteContext}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Registration requirements and custom fields
  bool _isLoadingRegistrationRequirements = false;
  FCRegistrationRequirements? _registrationRequirements;
  List<FCCustomFieldDefinition> _customFields = [];
  Map<String, TextEditingController> _customFieldControllers = {};
  Map<String, FocusNode> _customFieldFocusNodes = {};

  // Callback to set error on AdditionalInformationPage
  Function(String?)? _setAdditionalInfoError;

  // New field state
  DateTime? _selectedDateOfBirth;
  final _locationController = TextEditingController();
  final _locationFocusNode = FocusNode();
  bool? _emailChoice;
  bool _acceptTerms = false;
  bool _acceptPrivacy = false;

  // Error handling
  bool _shouldRedirectToWeb = false;
  bool _registrationNotAvailable = false; // New: for registrationOpen: false
  String _registerViaWebUrl = ''; // New: store web registration URL

  @override
  void initState() {
    super.initState();
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

    // Check registration support and prefetch requirements
    _checkRegistrationSupport();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _locationController.dispose();
    _locationFocusNode.dispose();
    _animationController.dispose();

    // Dispose custom field controllers and focus nodes
    for (var controller in _customFieldControllers.values) {
      controller.dispose();
    }
    for (var focusNode in _customFieldFocusNodes.values) {
      focusNode.dispose();
    }

    super.dispose();
  }

  Future<void> _checkRegistrationSupport() async {
    // All registration-related checks are now in prefetchAccount
    await _prefetchRegistrationRequirements();
  }

  Future<void> _prefetchRegistrationRequirements() async {
    setState(() {
      _isLoadingRegistrationRequirements = true;
      _shouldRedirectToWeb = false;
      _registrationNotAvailable = false;
    });

    try {
      final accountProxy = SiteProxyService.getAccountProxy();
      debugPrint('[RegisterPage] === PREFETCH ACCOUNT START ===');
      debugPrint('[RegisterPage] Forum URL: "${widget.siteContext.site.pluginUrl}"');

      final prefetchResult = await accountProxy.prefetchAccount();

      debugPrint('[RegisterPage] === PREFETCH ACCOUNT RESULT ===');
      if (prefetchResult != null) {
        debugPrint('[RegisterPage] registrationOpen: ${prefetchResult.registrationOpen}');
        debugPrint('[RegisterPage] canRegisterViaAPI: ${prefetchResult.canRegisterViaAPI}');
        debugPrint('[RegisterPage] registerViaWebUrl: ${prefetchResult.registerViaWebUrl}');

        // Step 1: Check if registration is open
        if (!prefetchResult.registrationOpen) {
          debugPrint('[RegisterPage] Registration is not available (registrationOpen: false)');
          setState(() {
            _registrationNotAvailable = true;
          });
          return;
        }

        // Step 2: Check if API registration is possible
        if (!prefetchResult.canRegisterViaAPI) {
          debugPrint('[RegisterPage] Registration via API not supported, redirecting to web');
          setState(() {
            _shouldRedirectToWeb = true;
            _registerViaWebUrl = prefetchResult.registerViaWebUrl.isNotEmpty ? prefetchResult.registerViaWebUrl : '${widget.siteContext.site.url}/register';
          });
          return;
        }

        // Step 3: All checks passed - proceed with in-app registration
        if (prefetchResult.registrationRequirements != null) {
          setState(() {
            _registrationRequirements = prefetchResult.registrationRequirements;
            _customFields = prefetchResult.registrationRequirements!.customFields;
            _setupCustomFieldControllers();
          });
          debugPrint('[RegisterPage] Registration requirements loaded successfully');
          // Auto-fill location from IP if field is empty
          _autoFillLocation();
        } else {
          debugPrint('[RegisterPage] No registration requirements found');
          setState(() {
            _registrationRequirements = null;
            _customFields = [];
          });
        }
      } else {
        debugPrint('[RegisterPage] prefetchAccount returned null');
        setState(() {
          _shouldRedirectToWeb = true;
          _registerViaWebUrl = '${widget.siteContext.site.url}/register';
        });
      }
      debugPrint('[RegisterPage] === PREFETCH ACCOUNT END ===');
    } catch (e, stackTrace) {
      debugPrint('[RegisterPage] === PREFETCH ACCOUNT ERROR ===');
      debugPrint('[RegisterPage] Error: ${e.toString()}');
      debugPrint('[RegisterPage] Stack trace: $stackTrace');
      debugPrint('[RegisterPage] === PREFETCH ACCOUNT ERROR END ===');
      setState(() {
        _shouldRedirectToWeb = true;
        _registerViaWebUrl = '${widget.siteContext.site.url}/register';
      });
    } finally {
      setState(() {
        _isLoadingRegistrationRequirements = false;
      });
    }
  }

  void _setupCustomFieldControllers() {
    // Dispose existing controllers and focus nodes
    for (var controller in _customFieldControllers.values) {
      controller.dispose();
    }
    for (var focusNode in _customFieldFocusNodes.values) {
      focusNode.dispose();
    }
    _customFieldControllers.clear();
    _customFieldFocusNodes.clear();

    debugPrint('[RegisterPage] === SETUP CUSTOM FIELD CONTROLLERS ===');
    debugPrint('[RegisterPage] Setting up ${_customFields.length} custom fields');

    // Create new controllers and focus nodes for each custom field
    for (var field in _customFields) {
      final fieldId = field.identifier;
      String initialValue = field.defaultValue?.toString() ?? '';

      debugPrint('[RegisterPage] Processing field: "${field.name}" ($fieldId)');
      debugPrint('[RegisterPage]   Type: "${field.type}"');
      debugPrint('[RegisterPage]   Default value: "${field.defaultValue}"');
      debugPrint('[RegisterPage]   Options: "${field.options}"');
      debugPrint('[RegisterPage]   Initial value before processing: "$initialValue"');

      // For boolean fields (cbox), ensure we have a valid initial value
      if (field.type.toLowerCase() == 'cbox' && initialValue.isEmpty) {
        debugPrint('[RegisterPage]   This is a checkbox field with empty initial value');
        // Parse options to determine the default false value
        Map<String, String> options;
        if (field.choices != null && field.choices!.isNotEmpty) {
          options = field.choices!;
        } else {
          options = _parseFieldOptions(field.options);
        }
        debugPrint('[RegisterPage]   Parsed options: $options');
        if (options.isNotEmpty) {
          // Find the "false" value (usually '0' or contains 'no', 'false', 'off')
          final falseEntry = options.entries.firstWhere(
            (entry) => entry.key == '0' || entry.value.toLowerCase().contains('no') || entry.value.toLowerCase().contains('false') || entry.value.toLowerCase().contains('off'),
            orElse: () => options.entries.first,
          );
          initialValue = falseEntry.key;
          debugPrint('[RegisterPage]   Found false entry: $falseEntry');
          debugPrint('[RegisterPage]   Setting initial value to: "$initialValue"');
        } else {
          initialValue = '0'; // Default fallback
          debugPrint('[RegisterPage]   No options found, using default fallback: "$initialValue"');
        }
      }

      debugPrint('[RegisterPage]   Final initial value: "$initialValue"');
      _customFieldControllers[fieldId] = TextEditingController(text: initialValue);
      _customFieldFocusNodes[fieldId] = FocusNode();

      // Verify the controller was set correctly
      final controller = _customFieldControllers[fieldId]!;
      debugPrint('[RegisterPage]   Controller created with text: "${controller.text}"');
    }
    debugPrint('[RegisterPage] === SETUP CUSTOM FIELD CONTROLLERS END ===');
  }

  /// Auto-fill location field from IP-based geolocation
  Future<void> _autoFillLocation() async {
    // Only auto-fill if location field is empty
    if (_locationController.text.trim().isNotEmpty) {
      debugPrint('[RegisterPage] Location field already has value, skipping auto-fill');
      return;
    }

    try {
      debugPrint('[RegisterPage] Attempting to auto-fill location from IP...');
      final location = await LocationService.getLocationFromIP();

      if (location != null && location.isNotEmpty) {
        if (mounted) {
          setState(() {
            _locationController.text = location;
          });
          debugPrint('[RegisterPage] Auto-filled location: $location');
        }
      } else {
        debugPrint('[RegisterPage] Could not retrieve location from IP');
      }
    } catch (e) {
      debugPrint('[RegisterPage] Error auto-filling location: $e');
      // Silently fail - user can still enter location manually
    }
  }

  Map<String, String> _parseFieldOptions(String optionsString) {
    if (optionsString.isEmpty) return {};

    final Map<String, String> options = {};
    final pairs = optionsString.split('|');

    for (final pair in pairs) {
      if (pair.contains('=')) {
        final parts = pair.split('=');
        if (parts.length == 2) {
          options[parts[0]] = parts[1];
        }
      }
    }

    return options;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.createAccount,
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: DesignTokens.fontWeightMedium,
          ),
        ),
        elevation: 0,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _buildRegistrationForm(colorScheme, textTheme),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildRegistrationForm(ColorScheme colorScheme, TextTheme textTheme) {
    List<Widget> widgets = [];

    // Show "Registration not available" message if registration is closed
    if (_registrationNotAvailable) {
      widgets.add(_buildRegistrationNotAvailableMessage(colorScheme, textTheme));
      return widgets;
    }

    // Show redirect message if web registration is required
    if (_shouldRedirectToWeb) {
      widgets.add(_buildRedirectToWebMessage(colorScheme, textTheme));
      return widgets;
    }

    // Loading indicator
    if (_isLoadingRegistrationRequirements) {
      widgets.add(Padding(
        padding: DesignTokens.paddingScreen,
        child: _buildLoadingIndicator(colorScheme, textTheme),
      ));
      return widgets;
    }

    // Build form based on registration requirements
    if (_registrationRequirements != null) {
      widgets.addAll(_buildDynamicRegistrationForm(colorScheme, textTheme));
    } else {
      // Fallback to basic fields if requirements not loaded
      widgets.add(
        BasicRegistrationFields(
          usernameController: _usernameController,
          emailController: _emailController,
          passwordController: _passwordController,
          confirmPasswordController: _confirmPasswordController,
          emailFocusNode: _emailFocusNode,
          passwordFocusNode: _passwordFocusNode,
          confirmPasswordFocusNode: _confirmPasswordFocusNode,
          isPasswordVisible: _isPasswordVisible,
          isConfirmPasswordVisible: _isConfirmPasswordVisible,
          onPasswordVisibilityToggle: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
          onConfirmPasswordVisibilityToggle: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
          onConfirmPasswordSubmitted: () {
            if (_customFields.isNotEmpty) {
              final fieldId = _customFields.first.identifier;
              _customFieldFocusNodes[fieldId]?.requestFocus();
            } else {
              _handleRegister();
            }
          },
          showHeader: true,
        ),
      );
    }

    // Register button and login link
    widgets.add(Padding(
      padding: DesignTokens.paddingScreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormActions(colorScheme, textTheme),
      ),
    ));

    return widgets;
  }

  Widget _buildRegistrationNotAvailableMessage(ColorScheme colorScheme, TextTheme textTheme) {
    return Padding(
      padding: DesignTokens.paddingScreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: DesignTokens.spacingXXL),
          Icon(
            Icons.info_outline_rounded,
            size: 64,
            color: colorScheme.primary,
          ),
          const SizedBox(height: DesignTokens.spacingXL),
          Text(
            AppLocalizations.of(context)!.registrationNotAvailable,
            style: StyleBuilders.titleTextStyle(
              colorScheme: colorScheme,
              textTheme: textTheme,
              fontSize: DesignTokens.fontSizeXL,
              fontWeight: DesignTokens.fontWeightSemiBold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: DesignTokens.spacingL),
          Text(
            AppLocalizations.of(context)!.registrationNotAvailableMessage,
            style: StyleBuilders.bodyTextStyle(
              colorScheme: colorScheme,
              textTheme: textTheme,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRedirectToWebMessage(ColorScheme colorScheme, TextTheme textTheme) {
    final regUrl = _registerViaWebUrl.isNotEmpty ? _registerViaWebUrl : '${widget.siteContext.site.url}/register';

    return Padding(
      padding: DesignTokens.paddingScreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: DesignTokens.spacingXXL),
          Icon(
            Icons.info_outline_rounded,
            size: 64,
            color: colorScheme.primary,
          ),
          const SizedBox(height: DesignTokens.spacingXL),
          Text(
            AppLocalizations.of(context)!.webRegistrationRequired,
            style: StyleBuilders.titleTextStyle(
              colorScheme: colorScheme,
              textTheme: textTheme,
              fontSize: DesignTokens.fontSizeXL,
              fontWeight: DesignTokens.fontWeightSemiBold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: DesignTokens.spacingL),
          Text(
            AppLocalizations.of(context)!.webRegistrationRequiredMessage,
            style: StyleBuilders.bodyTextStyle(
              colorScheme: colorScheme,
              textTheme: textTheme,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: DesignTokens.spacingXXL),
          FilledButton.icon(
            onPressed: () => _openRegistrationUrl(regUrl),
            icon: const Icon(Icons.open_in_new),
            label: Text(AppLocalizations.of(context)!.openRegistrationPage),
            style: FilledButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: DesignTokens.spacingXL),
            ),
          ),
        ],
      ),
    );
  }

  void _openRegistrationUrl(String url) {
    try {
      launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      debugPrint('[RegisterPage] Failed to open registration URL: $e');
    }
  }

  List<Widget> _buildDynamicRegistrationForm(ColorScheme colorScheme, TextTheme textTheme) {
    List<Widget> widgets = [];

    // Basic registration fields only (Username, Email, Password)
    widgets.add(
      BasicRegistrationFields(
        usernameController: _usernameController,
        emailController: _emailController,
        passwordController: _passwordController,
        confirmPasswordController: _confirmPasswordController,
        emailFocusNode: _emailFocusNode,
        passwordFocusNode: _passwordFocusNode,
        confirmPasswordFocusNode: _confirmPasswordFocusNode,
        isPasswordVisible: _isPasswordVisible,
        isConfirmPasswordVisible: _isConfirmPasswordVisible,
        onPasswordVisibilityToggle: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
        onConfirmPasswordVisibilityToggle: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
        onConfirmPasswordSubmitted: () {
          // If there are custom fields, navigate to Additional Information page
          // Otherwise, proceed with registration
          if (_customFields.isNotEmpty) {
            _handleContinueToAdditionalInformation();
          } else {
            _handleRegister();
          }
        },
        showHeader: true,
      ),
    );

    return widgets;
  }

  Widget _buildLoadingIndicator(ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      padding: EdgeInsets.all(DesignTokens.iconSizeM),
      decoration: StyleBuilders.cardLikeDecoration(
        colorScheme: colorScheme,
        borderRadius: DesignTokens.radiusL,
        borderOpacity: DesignTokens.opacityLow,
      ).copyWith(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: DesignTokens.opacityLow),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(width: DesignTokens.spacingL),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.loadingAdditionalFields,
              style: StyleBuilders.bodyTextStyle(
                colorScheme: colorScheme,
                textTheme: textTheme,
                fontWeight: DesignTokens.fontWeightMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFormActions(ColorScheme colorScheme, TextTheme textTheme) {
    return [
      const SizedBox(height: 32),
      // Show "Continue" button if there are custom fields, otherwise "Create Account"
      if (_customFields.isNotEmpty)
        FilledButton(
          onPressed: _handleContinueToAdditionalInformation,
          style: FilledButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            padding: EdgeInsets.symmetric(vertical: DesignTokens.spacingL + DesignTokens.spacingXS),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(DesignTokens.radiusL),
            ),
            elevation: DesignTokens.elevationNone,
          ),
          child: Text(
            AppLocalizations.of(context)!.continueButton,
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: DesignTokens.fontWeightSemiBold,
            ),
          ),
        )
      else
        FilledButton(
          onPressed: _handleRegister,
          style: FilledButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            padding: EdgeInsets.symmetric(vertical: DesignTokens.spacingL + DesignTokens.spacingXS),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(DesignTokens.radiusL),
            ),
            elevation: DesignTokens.elevationNone,
          ),
          child: Text(
            AppLocalizations.of(context)!.createAccount,
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: DesignTokens.fontWeightSemiBold,
            ),
          ),
        ),
      SizedBox(height: DesignTokens.spacingXL),
      // Advisory text about credentials being sent to forum domain
      Obx(() {
        final domain = _getSiteDomain();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            AppLocalizations.of(context)!.credentialsSentToDomain(domain),
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontSize: DesignTokens.fontSizeXS,
            ),
            textAlign: TextAlign.center,
          ),
        );
      }),
      const SizedBox(height: 16),
      // Login link with better spacing
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.alreadyHaveAccount,
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          TextButton(
            onPressed: () {
              Get.off(() => LoginPage(siteContext: widget.siteContext));
            },
            style: StyleBuilders.textButtonStyle(
              colorScheme: colorScheme,
              padding: EdgeInsets.symmetric(
                horizontal: DesignTokens.spacingS,
                vertical: DesignTokens.spacingXS,
              ),
              borderRadius: DesignTokens.radiusS,
            ),
            child: Text(
              AppLocalizations.of(context)!.logIn,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.primary,
                fontWeight: DesignTokens.fontWeightSemiBold,
              ),
            ),
          ),
        ],
      ),
    ];
  }

  void _handleContinueToAdditionalInformation() async {
    if (!_formKey.currentState!.validate()) return;

    // Clear any previous basic info errors
    // Only navigate to Additional Information page if there are custom fields
    if (_customFields.isEmpty) {
      debugPrint('[RegisterPage] No custom fields, proceeding directly with registration');
      _handleRegister();
      return;
    }

    // Ensure custom field controllers are set up before navigation
    if (_customFieldControllers.isEmpty) {
      debugPrint('[RegisterPage] Setting up custom field controllers before navigation');
      _setupCustomFieldControllers();
    }

    // Navigate to Additional Information page
    await Get.to(() => AdditionalInformationPage(
          registrationRequirements: _registrationRequirements!,
          customFields: _customFields,
          customFieldControllers: _customFieldControllers,
          customFieldFocusNodes: _customFieldFocusNodes,
          locationController: _locationController,
          locationFocusNode: _locationFocusNode,
          selectedDateOfBirth: _selectedDateOfBirth,
          emailChoice: _emailChoice,
          acceptTerms: _acceptTerms,
          acceptPrivacy: _acceptPrivacy,
          onDateOfBirthChanged: (date) {
            setState(() {
              _selectedDateOfBirth = date;
            });
          },
          onEmailChoiceChanged: (choice) {
            setState(() {
              _emailChoice = choice;
            });
          },
          onAcceptTermsChanged: (accepted) {
            setState(() {
              _acceptTerms = accepted;
            });
          },
          onAcceptPrivacyChanged: (accepted) {
            setState(() {
              _acceptPrivacy = accepted;
            });
          },
          onComplete: () {
            // When Additional Information is complete, proceed with registration
            _handleRegister();
          },
          onErrorSet: (setErrorCallback) {
            // Store callback to set error on Additional Information page
            _setAdditionalInfoError = setErrorCallback;
          },
          siteUrl: widget.siteContext.site.url,
        ));
  }

  /// Determines if an error is related to basic registration fields
  bool _isBasicFieldError(String? errorMessage) {
    if (errorMessage == null || errorMessage.isEmpty) return false;

    final lowerError = errorMessage.toLowerCase();

    // Check for common basic field errors
    return lowerError.contains('username') ||
        lowerError.contains('email') ||
        lowerError.contains('password') ||
        lowerError.contains('already exists') ||
        lowerError.contains('already taken') ||
        lowerError.contains('invalid') ||
        lowerError.contains('required');
  }

  /// Shows error message as a popup dialog
  /// If called from AdditionalInformationPage, navigates back first
  void _navigateBackToBasicInfoWithError(String errorMessage, {bool shouldNavigateBack = true}) {
    final colorScheme = Theme.of(context).colorScheme;

    // Navigate back to Basic Info page if we're coming from Additional Information page
    if (shouldNavigateBack) {
      Get.back();
      // Wait for navigation to complete before showing dialog
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _showErrorDialog(AppLocalizations.of(context)!.registrationError, errorMessage, colorScheme);
        }
      });
    } else {
      // Already on RegisterPage, show dialog directly
      _showErrorDialog('Registration Error', errorMessage, colorScheme);
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

  void _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    // Validate all required fields before submission
    if (_registrationRequirements != null) {
      final req = _registrationRequirements!;

      // Validate Date of Birth if required
      if (req.dateOfBirth != null && (req.dateOfBirth!.required || req.dateOfBirth!.requireDob == true)) {
        if (_selectedDateOfBirth == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.pleaseSelectDateOfBirth)),
          );
          return;
        }
      }

      // Validate Location if required
      if (req.location != null && (req.location!.required || req.location!.requireLocation == true)) {
        if (_locationController.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.pleaseEnterLocation)),
          );
          return;
        }
      }

      // Validate Email Choice if required
      if (req.emailChoice != null && (req.emailChoice!.required || req.emailChoice!.requireEmailChoice == true)) {
        if (_emailChoice == null || _emailChoice == false) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.pleaseIndicateEmailPreference)),
          );
          return;
        }
      }

      // Validate required custom fields
      for (var field in _customFields) {
        if (field.required) {
          final fieldId = field.identifier;
          final controller = _customFieldControllers[fieldId];
          if (controller != null) {
            final value = controller.text.trim();
            if (value.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(AppLocalizations.of(context)!.pleaseFillAllRequiredFields)),
              );
              return;
            }
          } else {
            // Controller not found for required field
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppLocalizations.of(context)?.pleaseFillInAllRequiredFields ?? 'Please fill in all required fields')),
            );
            return;
          }
        }
      }

      // Validate policies if required
      if (req.termsOfService?.required == true && !_acceptTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.pleaseAcceptTermsOfService)),
        );
        return;
      }
      if (req.privacyPolicy?.required == true && !_acceptPrivacy) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.pleaseAcceptPrivacyPolicy)),
        );
        return;
      }
    }

    final colorScheme = Theme.of(context).colorScheme;
    FocusScope.of(context).unfocus();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    await _attemptRegistration(colorScheme);
  }

  Future<void> _attemptRegistration(ColorScheme colorScheme) async {
    try {
      // Prepare custom fields data
      Map<String, dynamic> customFieldsData = {};
      if (_customFields.isNotEmpty) {
        debugPrint('[RegisterPage] === PREPARING CUSTOM FIELDS DATA ===');
        debugPrint('[RegisterPage] Available custom fields: ${_customFields.length}');
        for (var field in _customFields) {
          final fieldId = field.identifier;
          final controller = _customFieldControllers[fieldId];
          if (controller != null) {
            final value = controller.text.trim();
            if (value.isNotEmpty) {
              customFieldsData[fieldId] = value;
              debugPrint('[RegisterPage] Including field "${field.name}" ($fieldId): "$value"');
            } else {
              debugPrint('[RegisterPage] Skipping empty field "${field.name}" ($fieldId)');
            }
          } else {
            debugPrint('[RegisterPage] No controller found for field "${field.name}" ($fieldId)');
          }
        }
        debugPrint('[RegisterPage] Final custom fields data: ${customFieldsData.keys.toList()}');
      }

      // Get timezone
      final timezone = DateTime.now().timeZoneName;

      // Prepare DOB in YYYY-MM-DD format (ISO 8601)
      String? dateOfBirth;
      if (_selectedDateOfBirth != null) {
        dateOfBirth = DateFormat('yyyy-MM-dd').format(_selectedDateOfBirth!);
        debugPrint('[RegisterPage] Formatted dateOfBirth: $dateOfBirth');
      }

      final accountProxy = SiteProxyService.getAccountProxy();
      debugPrint('[RegisterPage] Attempting register API with username: ${_usernameController.text}, email: ${_emailController.text}');
      final result = await accountProxy.register(
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        passwordConfirm: _confirmPasswordController.text.trim().isEmpty ? null : _confirmPasswordController.text.trim(),
        timezone: timezone,
        dateOfBirth: dateOfBirth,
        location: _locationController.text.trim().isEmpty ? null : _locationController.text.trim(),
        emailChoice: _emailChoice,
        customFields: customFieldsData.isEmpty ? null : customFieldsData,
        acceptTerms: _registrationRequirements?.termsOfService?.required == true ? _acceptTerms : null,
        acceptPrivacy: _registrationRequirements?.privacyPolicy?.required == true ? _acceptPrivacy : null,
      );
      debugPrint('[RegisterPage] register result: result=${result.result}, userState=${result.userState}');
      Navigator.of(context).pop(); // Remove loading

      if (result.result == true) {
        _handleSuccessfulRegistration(colorScheme, result);
      } else {
        // Check if we're on Additional Information page (callback is set)
        if (_setAdditionalInfoError != null) {
          debugPrint('[RegisterPage] Error occurred on Additional Information page, showing error there');
          _setAdditionalInfoError!(result.resultText ?? AppLocalizations.of(context)!.registrationFailed);
          return;
        }

        // Check if this is a basic field error
        if (_isBasicFieldError(result.resultText)) {
          debugPrint('[RegisterPage] Basic field error detected: ${result.resultText}');
          // Already on RegisterPage, show error dialog
          _navigateBackToBasicInfoWithError(result.resultText ?? 'Registration failed. Please check your information.', shouldNavigateBack: false);
          return;
        }

        _showErrorDialog(
          AppLocalizations.of(context)!.registrationFailed,
          result.resultText ?? AppLocalizations.of(context)!.registrationFailedTryAgain,
          colorScheme,
          showOpenWebsiteButton: true,
        );
      }
    } catch (e) {
      Navigator.of(context).pop(); // Remove loading
      debugPrint('[RegisterPage] register exception: ${e.toString()}');

      // Check if we're on Additional Information page (callback is set)
      if (_setAdditionalInfoError != null) {
        debugPrint('[RegisterPage] Exception occurred on Additional Information page, showing error there');
        _setAdditionalInfoError!('${AppLocalizations.of(context)!.registrationFailedTryAgain}\n\n${e.toString()}');
        return;
      }

      _showErrorDialog(
        AppLocalizations.of(context)!.registrationError,
        '${AppLocalizations.of(context)!.registrationFailedTryAgain}\n\n${e.toString()}',
        colorScheme,
        showOpenWebsiteButton: true,
      );
    }
  }

  Future<void> _showRegistrationInfoDialog(String message, ColorScheme colorScheme) async {
    await showDialog(
      context: Get.context!,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.registrationInfo,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              height: DesignTokens.lineHeightNormal,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
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

  void _showErrorDialog(String title, String message, ColorScheme colorScheme, {bool showOpenWebsiteButton = false}) {
    final siteUrl = widget.siteContext.site.pluginUrl;
    final baseUrl = siteUrl.replaceAll(RegExp(r'/mobiquo/.*$'), '').replaceAll(RegExp(r'/api/.*$'), '');
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: colorScheme.error,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              height: DesignTokens.lineHeightNormal,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (showOpenWebsiteButton)
              FilledButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  _openSiteWebsite(baseUrl);
                },
                icon: const Icon(Icons.open_in_new),
                label: Text(AppLocalizations.of(context)!.openWebsite),
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                ),
              ),
          ],
          backgroundColor: colorScheme.surface,
          elevation: 8,
        );
      },
    );
  }

  void _openSiteWebsite(String url) {
    try {
      launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      debugPrint('[RegisterPage] Failed to open website: $e');
      Get.snackbar(
        AppLocalizations.of(context)!.errorTitle,
        AppLocalizations.of(context)!.couldNotOpenForumWebsite(url),
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
        colorText: Theme.of(context).colorScheme.onErrorContainer,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  void _handleSuccessfulRegistration(ColorScheme colorScheme, FCRegisterResult result) async {
    final userState = result.userState;
    final requiresEmailConfirmation = result.requiresEmailConfirmation ?? false;
    final requiresManualApproval = result.requiresManualApproval ?? false;
    final serverMessage = result.message;

    debugPrint(
        '[RegisterPage] Registration successful - userState: $userState, requiresEmailConfirmation: $requiresEmailConfirmation, requiresManualApproval: $requiresManualApproval, message: $serverMessage');

    // Handle different user states
    if (userState == 'email_confirm' || requiresEmailConfirmation) {
      // Email confirmation required - use server message if available, otherwise fallback
      final message = serverMessage ?? AppLocalizations.of(context)!.registrationSuccessfulEmailConfirm;
      await _showRegistrationInfoDialog(message, colorScheme);
      Get.offAll(() => LoginPage(siteContext: widget.siteContext));
      return;
    }

    if (userState == 'moderated' || requiresManualApproval) {
      // Manual approval required - use server message if available, otherwise fallback
      final message = serverMessage ?? AppLocalizations.of(context)!.registrationSuccessfulPendingApproval;
      await _showRegistrationInfoDialog(message, colorScheme);
      Get.offAll(() => LoginPage(siteContext: widget.siteContext));
      return;
    }

    // Account is valid, attempt automatic login
    try {
      final loginController = Get.put(LoginController());
      debugPrint('[RegisterPage] Attempting automatic login after registration');

      final loginSuccess = await loginController.handleLogin(
        username: _usernameController.text.trim(),
        password: _passwordController.text,
        showLoader: false,
        showSuccessMessage: false,
        siteContext: widget.siteContext,
      );

      if (loginSuccess) {
        debugPrint('[RegisterPage] Automatic login successful');
        Get.offAll(() => const SiteHomePage());
        // Use server message if available, otherwise use default success message
        final successMessage = serverMessage ?? AppLocalizations.of(context)!.registrationSuccessfulAutoLogin;
        Get.snackbar(
          AppLocalizations.of(context)!.welcome,
          successMessage,
          backgroundColor: colorScheme.primaryContainer,
          colorText: colorScheme.onPrimaryContainer,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          duration: const Duration(seconds: 3),
          icon: Icon(
            Icons.check_circle_rounded,
            color: colorScheme.onPrimaryContainer,
          ),
        );
      } else {
        debugPrint('[RegisterPage] Automatic login failed, redirecting to manual login');
        // Show server message in dialog if available, otherwise show snackbar
        if (serverMessage != null && serverMessage.isNotEmpty) {
          await _showRegistrationInfoDialog(serverMessage, colorScheme);
        }
        SiteHomePage.triggerProfileAutoLogin = true;
        Get.offAll(() {
          Future.delayed(Duration.zero, () => SiteHomePage.triggerProfileAutoLogin = false);
          return const SiteHomePage();
        });
        if (serverMessage == null || serverMessage.isEmpty) {
          Get.snackbar(
            AppLocalizations.of(context)!.registrationSuccessful,
            AppLocalizations.of(context)!.pleaseLoginWithNewAccount,
            backgroundColor: colorScheme.primaryContainer,
            colorText: colorScheme.onPrimaryContainer,
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(16),
            borderRadius: 12,
          );
        }
      }
    } catch (e) {
      debugPrint('[RegisterPage] Error during automatic login: $e');
      // Show server message in dialog if available
      if (serverMessage != null && serverMessage.isNotEmpty) {
        await _showRegistrationInfoDialog(serverMessage, colorScheme);
      }
      SiteHomePage.triggerProfileAutoLogin = true;
      Get.offAll(() {
        Future.delayed(Duration.zero, () => SiteHomePage.triggerProfileAutoLogin = false);
        return const SiteHomePage();
      });
      if (serverMessage == null || serverMessage.isEmpty) {
        Get.snackbar(
          'Registration Successful',
          'Please log in with your new account.',
          backgroundColor: colorScheme.primaryContainer,
          colorText: colorScheme.onPrimaryContainer,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    }
  }
}
