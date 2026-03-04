import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:forumcopilot_sdk/models/registration/fc_registration_requirements.dart';
import 'package:forumcopilot_sdk/models/entities/fc_custom_field_definition.dart';
import 'package:forumcopilot_flutter/views/widgets/custom_field_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import '../theme/design_tokens.dart';
import '../theme/style_builders.dart';
import '../l10n/generated/app_localizations.dart';

class AdditionalInformationPage extends StatefulWidget {
  final FCRegistrationRequirements registrationRequirements;
  final List<FCCustomFieldDefinition> customFields;
  final Map<String, TextEditingController> customFieldControllers;
  final Map<String, FocusNode> customFieldFocusNodes;
  final TextEditingController locationController;
  final FocusNode locationFocusNode;
  final DateTime? selectedDateOfBirth;
  final bool? emailChoice;
  final bool acceptTerms;
  final bool acceptPrivacy;
  final Function(DateTime?) onDateOfBirthChanged;
  final Function(bool?) onEmailChoiceChanged;
  final Function(bool) onAcceptTermsChanged;
  final Function(bool) onAcceptPrivacyChanged;
  final Function() onComplete;
  final Function(Function(String?))? onErrorSet; // Callback that receives setErrorMessage function
  final String siteUrl; // For building policy URLs

  const AdditionalInformationPage({
    super.key,
    required this.registrationRequirements,
    required this.customFields,
    required this.customFieldControllers,
    required this.customFieldFocusNodes,
    required this.locationController,
    required this.locationFocusNode,
    required this.selectedDateOfBirth,
    required this.emailChoice,
    required this.acceptTerms,
    required this.acceptPrivacy,
    required this.onDateOfBirthChanged,
    required this.onEmailChoiceChanged,
    required this.onAcceptTermsChanged,
    required this.onAcceptPrivacyChanged,
    required this.onComplete,
    this.onErrorSet,
    required this.siteUrl,
  });

  @override
  State<AdditionalInformationPage> createState() => _AdditionalInformationPageState();
}

class _AdditionalInformationPageState extends State<AdditionalInformationPage> {
  final _formKey = GlobalKey<FormState>();
  late DateTime? _selectedDateOfBirth;
  late bool? _emailChoice;
  late bool _acceptTerms;
  late bool _acceptPrivacy;

  @override
  void initState() {
    super.initState();
    _selectedDateOfBirth = widget.selectedDateOfBirth;
    _emailChoice = widget.emailChoice;
    _acceptTerms = widget.acceptTerms;
    _acceptPrivacy = widget.acceptPrivacy;
    
    // Register setErrorMessage callback if provided
    if (widget.onErrorSet != null) {
      widget.onErrorSet!(setErrorMessage);
    }
  }
  
  /// Sets an error message to display in a dialog
  void setErrorMessage(String? message) {
    if (mounted && message != null && message.isNotEmpty) {
      final colorScheme = Theme.of(context).colorScheme;
      _showErrorDialog('Registration Error', message, colorScheme);
    }
  }
  
  /// Shows an error dialog
  void _showErrorDialog(String title, String message, ColorScheme colorScheme) {
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
                style: TextStyle(color: colorScheme.primary),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Additional Information',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: DesignTokens.fontWeightMedium,
          ),
        ),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ..._buildFormContent(colorScheme, textTheme),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFormContent(ColorScheme colorScheme, TextTheme textTheme) {
    final req = widget.registrationRequirements;
    List<Widget> widgets = [];
    bool isFirstField = true;

    // Date of Birth field
    if (req.dateOfBirth != null && (req.dateOfBirth!.required || req.dateOfBirth!.requireDob == true)) {
      if (!isFirstField) {
        widgets.add(_buildFieldSeparator(colorScheme));
      }
      widgets.add(
        Padding(
          padding: DesignTokens.paddingScreen,
          child: _buildDateOfBirthField(colorScheme, textTheme, req.dateOfBirth!),
        ),
      );
      isFirstField = false;
    }

    // Location field
    if (req.location != null && (req.location!.required || req.location!.requireLocation == true)) {
      if (!isFirstField) {
        widgets.add(_buildFieldSeparator(colorScheme));
      }
      widgets.add(
        Padding(
          padding: DesignTokens.paddingScreen,
          child: _buildLocationField(colorScheme, textTheme),
        ),
      );
      isFirstField = false;
    }

    // Email choice checkbox
    if (req.emailChoice != null && (req.emailChoice!.required || req.emailChoice!.requireEmailChoice == true)) {
      if (!isFirstField) {
        widgets.add(_buildFieldSeparator(colorScheme));
      }
      widgets.add(
        Padding(
          padding: DesignTokens.paddingScreen,
          child: _buildEmailChoiceField(colorScheme, textTheme),
        ),
      );
      isFirstField = false;
    }

    // Custom fields
    if (widget.customFields.isNotEmpty) {
      for (var entry in widget.customFields.asMap().entries) {
        final index = entry.key;
        final field = entry.value;
        final fieldId = field.identifier;
        
        if (!isFirstField) {
          widgets.add(_buildFieldSeparator(colorScheme));
        }
        
        widgets.add(
          Padding(
            padding: DesignTokens.paddingScreen,
            child: CustomFieldWidget(
              field: field,
              controller: widget.customFieldControllers[fieldId]!,
              focusNode: widget.customFieldFocusNodes[fieldId],
              validator: (value) => CustomFieldValidator.validateField(field, value),
              onFieldSubmitted: () {
                if (index < widget.customFields.length - 1) {
                  final nextFieldId = widget.customFields[index + 1].identifier;
                  widget.customFieldFocusNodes[nextFieldId]?.requestFocus();
                }
              },
            ),
          ),
        );
        isFirstField = false;
      }
    }

    // Terms of Service and Privacy Policy
    if ((req.termsOfService != null && req.termsOfService!.required) ||
        (req.privacyPolicy != null && req.privacyPolicy!.required)) {
      if (!isFirstField) {
        widgets.add(_buildFieldSeparator(colorScheme));
      }
      widgets.add(
        Padding(
          padding: DesignTokens.paddingScreen,
          child: _buildPolicyAcceptanceFields(colorScheme, textTheme, req),
        ),
      );
      isFirstField = false;
    }

    // Form actions (Create Account button)
    widgets.add(
      Padding(
        padding: DesignTokens.paddingScreen,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _buildFormActions(colorScheme, textTheme),
        ),
      ),
    );

    return widgets;
  }

  Widget _buildDateOfBirthField(ColorScheme colorScheme, TextTheme textTheme, FCFieldRequirement requirement) {
    // Calculate date constraints based on minimum age requirement
    final now = DateTime.now();
    final minimumAge = requirement.minimumAge ?? 13;
    
    // Calculate the latest date that meets minimum age requirement
    // Latest selectable date = today minus minimum age years (prevents future dates)
    // Use DateTime subtraction to handle leap years properly
    DateTime lastSelectableDate;
    try {
      // Try to create date exactly minimumAge years ago
      lastSelectableDate = DateTime(now.year - minimumAge, now.month, now.day);
      // If the date is in the future (shouldn't happen, but safety check), use today
      if (lastSelectableDate.isAfter(now)) {
        lastSelectableDate = now;
      }
    } catch (e) {
      // If date creation fails (e.g., Feb 29 in non-leap year), use today
      lastSelectableDate = now;
    }
    
    // Calculate initial date: if no date selected, default to 18 years ago
    // Or use the latest date that meets minimum age if 18 years ago is too recent
    DateTime defaultInitialDate;
    try {
      defaultInitialDate = DateTime(now.year - 18, now.month, now.day);
      // Ensure initial date is not after last selectable date
      if (defaultInitialDate.isAfter(lastSelectableDate)) {
        defaultInitialDate = lastSelectableDate;
      }
    } catch (e) {
      // Fallback to last selectable date if calculation fails
      defaultInitialDate = lastSelectableDate;
    }
    
    final initialDate = _selectedDateOfBirth ?? defaultInitialDate;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date of Birth${requirement.required ? " *" : ""}',
          style: StyleBuilders.titleTextStyle(
            colorScheme: colorScheme,
            textTheme: textTheme,
            fontSize: DesignTokens.fontSizeM,
            fontWeight: DesignTokens.fontWeightMedium,
          ),
        ),
        const SizedBox(height: DesignTokens.spacingS),
        InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: initialDate,
              firstDate: DateTime(1900),
              lastDate: lastSelectableDate, // Prevents future dates and ensures minimum age
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: colorScheme,
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null) {
              setState(() {
                _selectedDateOfBirth = picked;
              });
              widget.onDateOfBirthChanged(picked);
            }
          },
          child: Container(
            padding: DesignTokens.paddingM,
            decoration: StyleBuilders.cardLikeDecoration(
              colorScheme: colorScheme,
              borderRadius: DesignTokens.radiusL,
              borderOpacity: DesignTokens.opacityLow,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedDateOfBirth != null
                        ? DateFormat('yyyy-MM-dd').format(_selectedDateOfBirth!)
                        : 'Select date of birth',
                    style: TextStyle(
                      color: _selectedDateOfBirth != null
                          ? colorScheme.onSurface
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Icon(Icons.calendar_today, color: colorScheme.onSurfaceVariant),
              ],
            ),
          ),
        ),
        if (requirement.minimumAge != null)
          Padding(
            padding: const EdgeInsets.only(top: DesignTokens.spacingS),
            child: Text(
              'Minimum age: ${requirement.minimumAge} years',
              style: StyleBuilders.smallTextStyle(
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLocationField(ColorScheme colorScheme, TextTheme textTheme) {
    final req = widget.registrationRequirements;
    final isRequired = req.location != null && (req.location!.required || req.location!.requireLocation == true);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location${isRequired ? " *" : ""}',
          style: StyleBuilders.titleTextStyle(
            colorScheme: colorScheme,
            textTheme: textTheme,
            fontSize: DesignTokens.fontSizeM,
            fontWeight: DesignTokens.fontWeightMedium,
          ),
        ),
        const SizedBox(height: DesignTokens.spacingS),
        TextFormField(
          controller: widget.locationController,
          focusNode: widget.locationFocusNode,
          decoration: StyleBuilders.inputDecoration(
            colorScheme: colorScheme,
            labelText: null, // Remove floating label since we have explicit label above
          ),
          textInputAction: TextInputAction.next,
          validator: (value) {
            final req = widget.registrationRequirements;
            if (req.location != null && (req.location!.required || req.location!.requireLocation == true)) {
              if (value == null || value.trim().isEmpty) {
                return 'Location is required';
              }
            }
            return null;
          },
          onFieldSubmitted: (_) {
            if (widget.customFields.isNotEmpty) {
              final fieldId = widget.customFields.first.identifier;
              widget.customFieldFocusNodes[fieldId]?.requestFocus();
            } else {
              _handleComplete();
            }
          },
        ),
      ],
    );
  }

  Widget _buildEmailChoiceField(ColorScheme colorScheme, TextTheme textTheme) {
    return CheckboxListTile(
      title: Text(
        'Receive site mailings',
        style: StyleBuilders.titleTextStyle(
          colorScheme: colorScheme,
          textTheme: textTheme,
          fontSize: DesignTokens.fontSizeM,
          fontWeight: DesignTokens.fontWeightMedium,
        ),
      ),
      value: _emailChoice ?? false,
      onChanged: (value) {
        setState(() {
          _emailChoice = value;
        });
        widget.onEmailChoiceChanged(value);
      },
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildPolicyAcceptanceFields(
    ColorScheme colorScheme,
    TextTheme textTheme,
    FCRegistrationRequirements req,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (req.termsOfService != null && req.termsOfService!.required)
          CheckboxListTile(
            title: Text.rich(
              TextSpan(
                text: 'I accept the ',
                style: StyleBuilders.bodyTextStyle(
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                children: [
                  TextSpan(
                    text: 'Terms of Service',
                    style: StyleBuilders.bodyTextStyle(
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                      color: colorScheme.primary,
                    ).copyWith(
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => _openPolicyUrl(req.termsOfService!.url),
                  ),
                ],
              ),
            ),
            value: _acceptTerms,
            onChanged: (value) {
              setState(() {
                _acceptTerms = value ?? false;
              });
              widget.onAcceptTermsChanged(value ?? false);
            },
            contentPadding: EdgeInsets.zero,
          ),
        if (req.privacyPolicy != null && req.privacyPolicy!.required)
          CheckboxListTile(
            title: Text.rich(
              TextSpan(
                text: 'I accept the ',
                style: StyleBuilders.bodyTextStyle(
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                children: [
                  TextSpan(
                    text: 'Privacy Policy',
                    style: StyleBuilders.bodyTextStyle(
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                      color: colorScheme.primary,
                    ).copyWith(
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => _openPolicyUrl(req.privacyPolicy!.url),
                  ),
                ],
              ),
            ),
            value: _acceptPrivacy,
            onChanged: (value) {
              setState(() {
                _acceptPrivacy = value ?? false;
              });
              widget.onAcceptPrivacyChanged(value ?? false);
            },
            contentPadding: EdgeInsets.zero,
          ),
      ],
    );
  }

  void _openPolicyUrl(String url) {
    try {
      final baseUrl = widget.siteUrl;
      final fullUrl = url.startsWith('http') ? url : '$baseUrl$url';
      launchUrl(
        Uri.parse(fullUrl),
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      debugPrint('[AdditionalInformationPage] Failed to open policy URL: $e');
    }
  }

  /// Builds a thick separator between fields (similar to thread view but thicker)
  /// Separator extends to full screen width (no padding)
  Widget _buildFieldSeparator(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: DesignTokens.spacingL),
      child: StyleBuilders.divider(
        colorScheme: colorScheme,
        opacity: DesignTokens.opacityLow,
        thickness: 4.0, // Thicker than thread view (which uses 2.0)
        height: 4.0,
      ),
    );
  }


  List<Widget> _buildFormActions(ColorScheme colorScheme, TextTheme textTheme) {
    return [
      const SizedBox(height: DesignTokens.spacingXXL),
      FilledButton(
        onPressed: _handleComplete,
        style: FilledButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: DesignTokens.spacingXL),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusL),
          ),
          elevation: DesignTokens.elevationNone,
        ),
        child: Text(
          'Create Account',
          style: StyleBuilders.titleTextStyle(
            colorScheme: colorScheme,
            textTheme: textTheme,
            color: colorScheme.onPrimary,
            fontWeight: DesignTokens.fontWeightSemiBold,
          ),
        ),
      ),
    ];
  }

  void _handleComplete() {
    final req = widget.registrationRequirements;
    
    // Validate Date of Birth if required
    if (req.dateOfBirth != null && (req.dateOfBirth!.required || req.dateOfBirth!.requireDob == true)) {
      if (_selectedDateOfBirth == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)?.pleaseSelectDateOfBirth ?? 'Please select your date of birth')),
        );
        return;
      }
    }
    
    // Validate Location if required
    if (req.location != null && (req.location!.required || req.location!.requireLocation == true)) {
      if (widget.locationController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)?.pleaseEnterLocation ?? 'Please enter your location')),
        );
        return;
      }
    }
    
    // Validate Email Choice if required
    if (req.emailChoice != null && (req.emailChoice!.required || req.emailChoice!.requireEmailChoice == true)) {
      if (_emailChoice == null || _emailChoice == false) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)?.pleaseIndicateEmailPreference ?? 'Please indicate your email preference')),
        );
        return;
      }
    }
    
    // Validate policies if required
    if (req.termsOfService?.required == true && !_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)?.pleaseAcceptTermsOfService ?? 'Please accept the Terms of Service')),
      );
      return;
    }
    if (req.privacyPolicy?.required == true && !_acceptPrivacy) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)?.pleaseAcceptPrivacyPolicy ?? 'Please accept the Privacy Policy')),
      );
      return;
    }

    // Validate all form fields (including custom fields)
    if (_formKey.currentState!.validate()) {
      widget.onComplete();
    }
  }
}

