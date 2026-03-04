import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/models/settings/fc_settings_category.dart';
import 'package:forumcopilot_sdk/models/settings/fc_user_setting.dart';
import 'package:forumcopilot_sdk/factory/site_proxy_factory.dart';
import 'package:forumcopilot_flutter/utils/error_dialog.dart';
import 'package:forumcopilot_flutter/views/widgets/custom_field_widget.dart';
import 'package:forumcopilot_sdk/models/entities/fc_custom_field_definition.dart';
import '../theme/design_tokens.dart';

class ForumSettingsCategoryPage extends StatefulWidget {
  final SiteContext siteContext;
  final FCSettingsCategory category;

  const ForumSettingsCategoryPage({
    Key? key,
    required this.siteContext,
    required this.category,
  }) : super(key: key);

  @override
  State<ForumSettingsCategoryPage> createState() => _ForumSettingsCategoryPageState();
}

class _ForumSettingsCategoryPageState extends State<ForumSettingsCategoryPage> {
  List<FCUserSetting> _settings = [];
  Map<String, TextEditingController> _controllers = {};
  Map<String, dynamic> _originalValues = {};
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _loadSettings() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final proxy = SiteProxyFactory.getAccountProxy();
      final result = await proxy.getUserSettings(widget.category.key);

      if (mounted) {
        if (result.result) {
          // Sort by displayOrder
          final sortedSettings = List<FCUserSetting>.from(result.settings)
            ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

          // Initialize controllers and track original values
          final controllers = <String, TextEditingController>{};
          final originalValues = <String, dynamic>{};

          for (var setting in sortedSettings) {
            final value = _getSettingValue(setting);
            originalValues[setting.fieldId] = value;
            controllers[setting.fieldId] = TextEditingController(
              text: _valueToString(value),
            );
          }

          setState(() {
            _settings = sortedSettings;
            _controllers = controllers;
            _originalValues = originalValues;
            _isLoading = false;
          });
        } else {
          setState(() {
            _error = result.resultText ?? 'Failed to load settings';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Error loading settings: ${e.toString()}';
          _isLoading = false;
        });
        showErrorDialogFromException(e);
      }
    }
  }

  dynamic _getSettingValue(FCUserSetting setting) {
    return setting.value ?? setting.defaultValue;
  }

  String _valueToString(dynamic value) {
    if (value == null) return '';
    if (value is bool) return value ? '1' : '0';
    if (value is List) return value.join(',');
    return value.toString();
  }

  bool _shouldShowSetting(FCUserSetting setting) {
    if (setting.dependsOn == null) return true;

    final dependencyKey = setting.dependsOn!.key;
    final dependencyValue = setting.dependsOn!.value;

    // Get current value of dependency
    final dependencySetting = _settings.firstWhere(
      (s) => s.fieldId == dependencyKey,
      orElse: () => setting,
    );
    final currentValue = _getSettingValue(dependencySetting);

    return currentValue == dependencyValue;
  }

  List<FCUserSetting> _getVisibleSettings() {
    return _settings.where(_shouldShowSetting).toList();
  }

  Map<String, List<FCUserSetting>> _groupSettings(List<FCUserSetting> settings) {
    final grouped = <String, List<FCUserSetting>>{};
    for (var setting in settings) {
      final group = setting.group ?? 'general';
      if (!grouped.containsKey(group)) {
        grouped[group] = [];
      }
      grouped[group]!.add(setting);
    }
    return grouped;
  }

  Future<void> _onSettingChanged(FCUserSetting setting, dynamic value) async {
    // Store original setting for potential revert
    final originalSetting = setting;
    final originalValue = _originalValues[setting.fieldId];
    
    // Update local state immediately for UI responsiveness
    setState(() {
      _originalValues[setting.fieldId] = value;
      final controller = _controllers[setting.fieldId];
      if (controller != null) {
        controller.text = _valueToString(value);
      }
      // Update the setting value in the list
      final index = _settings.indexWhere((s) => s.fieldId == setting.fieldId);
      if (index != -1) {
        // Create a new setting with updated value
        final updatedSetting = FCUserSetting(
          fieldId: setting.fieldId,
          title: setting.title,
          description: setting.description,
          fieldType: setting.fieldType,
          dataType: setting.dataType,
          value: value,
          defaultValue: setting.defaultValue,
          choices: setting.choices,
          required: setting.required,
          readOnly: setting.readOnly,
          maxLength: setting.maxLength,
          matchType: setting.matchType,
          matchParams: setting.matchParams,
          min: setting.min,
          max: setting.max,
          pattern: setting.pattern,
          placeholder: setting.placeholder,
          displayOrder: setting.displayOrder,
          group: setting.group,
          dependsOn: setting.dependsOn,
        );
        _settings[index] = updatedSetting;
      }
    });

    // Save to backend immediately
    await _saveSettingImmediately(originalSetting, value, originalValue);
  }

  Future<void> _saveSettingImmediately(FCUserSetting setting, dynamic value, dynamic originalValue) async {
    try {
      // Convert value to proper type for API
      final valueForApi = _convertValueForApi(setting, value);
      final settingsToUpdate = {setting.fieldId: valueForApi};

      final proxy = SiteProxyFactory.getAccountProxy();
      final result = await proxy.updateUserSettings(
        widget.category.key,
        settingsToUpdate,
      );

      if (mounted) {
        if (result.result) {
          // Update local state with server response
          final updatedSetting = result.settings.firstWhere(
            (s) => s.fieldId == setting.fieldId,
            orElse: () => setting,
          );
          final updatedValue = _getSettingValue(updatedSetting);
          
          setState(() {
            _originalValues[setting.fieldId] = updatedValue;
            final controller = _controllers[setting.fieldId];
            if (controller != null) {
              controller.text = _valueToString(updatedValue);
            }
            // Update the setting in the list
            final index = _settings.indexWhere((s) => s.fieldId == setting.fieldId);
            if (index != -1) {
              _settings[index] = updatedSetting;
            }
            // Re-evaluate dependencies when value changes
          });
        } else {
          // Revert on error
          setState(() {
            _originalValues[setting.fieldId] = originalValue;
            final controller = _controllers[setting.fieldId];
            if (controller != null) {
              controller.text = _valueToString(originalValue);
            }
            // Revert setting in list
            final index = _settings.indexWhere((s) => s.fieldId == setting.fieldId);
            if (index != -1) {
              _settings[index] = setting;
            }
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.resultText ?? 'Failed to save setting'),
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        // Revert on error
        setState(() {
          _originalValues[setting.fieldId] = originalValue;
          final controller = _controllers[setting.fieldId];
          if (controller != null) {
            controller.text = _valueToString(originalValue);
          }
          // Revert setting in list
          final index = _settings.indexWhere((s) => s.fieldId == setting.fieldId);
          if (index != -1) {
            _settings[index] = setting;
          }
        });
        
        showErrorDialogFromException(e);
      }
    }
  }

  String? _validateSetting(FCUserSetting setting, String? value) {
    if (setting.required && (value == null || value.trim().isEmpty)) {
      return '${setting.title} is required';
    }

    if (value != null && value.isNotEmpty) {
      // Type-specific validation
      if (setting.fieldType == 'number') {
        final numValue = num.tryParse(value);
        if (numValue == null) {
          return 'Please enter a valid number';
        }
        if (setting.min != null && numValue < setting.min!) {
          return 'Value must be at least ${setting.min}';
        }
        if (setting.max != null && numValue > setting.max!) {
          return 'Value must be at most ${setting.max}';
        }
      }

      if (setting.fieldType == 'textbox' || setting.fieldType == 'textarea') {
        if (setting.maxLength != null && value.length > setting.maxLength!) {
          return 'Maximum length is ${setting.maxLength} characters';
        }
        if (setting.pattern != null) {
          try {
            final regex = RegExp(setting.pattern!);
            if (!regex.hasMatch(value)) {
              return 'Invalid format';
            }
          } catch (e) {
            // Invalid regex pattern, skip validation
          }
        }
      }
    }

    return null;
  }


  dynamic _convertValueForApi(FCUserSetting setting, dynamic value) {
    if (setting.dataType == 'boolean') {
      if (value is bool) return value;
      if (value is String) {
        return value == '1' || value.toLowerCase() == 'true';
      }
      return false;
    }
    if (setting.dataType == 'number') {
      if (value is num) return value;
      if (value is String) {
        return num.tryParse(value) ?? 0;
      }
      return 0;
    }
    if (setting.dataType == 'array') {
      if (value is List) return value;
      if (value is String) {
        return value.split(',').where((s) => s.isNotEmpty).toList();
      }
      return [];
    }
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category.displayName,
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: DesignTokens.fontWeightMedium,
          ),
        ),
        elevation: 0,
      ),
      body: _buildBody(colorScheme, textTheme),
    );
  }

  Widget _buildBody(ColorScheme colorScheme, TextTheme textTheme) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: colorScheme.primary,
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: DesignTokens.paddingScreen,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: colorScheme.error,
              ),
              SizedBox(height: DesignTokens.spacingL),
              Text(
                _error!,
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: DesignTokens.spacingXL),
              FilledButton.icon(
                onPressed: _loadSettings,
                icon: Icon(Icons.refresh),
                label: Text(AppLocalizations.of(context)?.retry ?? 'Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final visibleSettings = _getVisibleSettings();
    if (visibleSettings.isEmpty) {
      return Center(
        child: Padding(
          padding: DesignTokens.paddingScreen,
          child: Text(
            AppLocalizations.of(context)?.noSettingsAvailable ?? 'No settings available',
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    final groupedSettings = _groupSettings(visibleSettings);
    final groups = groupedSettings.keys.toList()..sort();

    return ListView.builder(
      padding: DesignTokens.paddingScreen,
      itemCount: groups.length,
      itemBuilder: (context, groupIndex) {
        final groupKey = groups[groupIndex];
        final groupSettings = groupedSettings[groupKey]!;
        return _buildSettingsGroup(groupKey, groupSettings, colorScheme, textTheme, groupIndex == 0);
      },
    );
  }

  Widget _buildSettingsGroup(
    String groupKey,
    List<FCUserSetting> settings,
    ColorScheme colorScheme,
    TextTheme textTheme,
    bool isFirstGroup,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (groupKey != 'general')
          Padding(
            padding: EdgeInsets.only(
              bottom: DesignTokens.spacingM,
              top: isFirstGroup ? 0 : DesignTokens.spacingL,
            ),
            child: Text(
              groupKey.replaceAll('_', ' ').split(' ').map((word) {
                if (word.isEmpty) return word;
                return word[0].toUpperCase() + word.substring(1);
              }).join(' '),
              style: textTheme.titleSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: DesignTokens.fontWeightSemiBold,
              ),
            ),
          ),
        ...settings.map((setting) => _buildSettingField(setting, colorScheme, textTheme)),
      ],
    );
  }

  Widget _buildSettingField(
    FCUserSetting setting,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    // Convert FCUserSetting to FCCustomFieldDefinition for CustomFieldWidget
    final fieldDef = _convertToFieldDefinition(setting);
    final controller = _controllers[setting.fieldId]!;

    // Handle toggle type specially
    if (setting.fieldType == 'toggle') {
      return _buildToggleField(setting, colorScheme, textTheme);
    }

    // For checkbox and radio, save immediately on change
    final shouldSaveImmediately = setting.fieldType == 'checkbox' || 
                                  setting.fieldType == 'cbox' || 
                                  setting.fieldType == 'radio' ||
                                  setting.fieldType == 'select' ||
                                  setting.fieldType == 'drop' ||
                                  setting.fieldType == 'multiselect';

    return Padding(
      padding: EdgeInsets.only(bottom: DesignTokens.spacingL),
      child: CustomFieldWidget(
        field: fieldDef,
        controller: controller,
        validator: (value) => _validateSetting(setting, value),
        onFieldSubmitted: () {
          final newValue = _parseValueFromController(setting, controller.text);
          final originalValue = _originalValues[setting.fieldId];
          if (newValue != originalValue) {
            if (shouldSaveImmediately) {
              // Save immediately for checkbox, radio, select
              _onSettingChanged(setting, newValue);
            } else {
              // For text-based fields, also save immediately
              _onSettingChanged(setting, newValue);
            }
          }
        },
      ),
    );
  }

  Widget _buildToggleField(
    FCUserSetting setting,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    // Get current value
    final currentValue = _getSettingValue(setting) as bool? ?? false;

    return Card(
      margin: EdgeInsets.only(bottom: DesignTokens.spacingM),
      elevation: 0,
      color: colorScheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusM),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(
            alpha: DesignTokens.opacityLow,
          ),
          width: DesignTokens.borderWidthThin,
        ),
      ),
      child: SwitchListTile(
        value: currentValue,
        onChanged: setting.readOnly
            ? null
            : (value) {
                _onSettingChanged(setting, value);
              },
        title: Text(
          setting.title,
          style: textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: DesignTokens.fontWeightMedium,
          ),
        ),
        subtitle: setting.description.isNotEmpty
            ? Text(
                setting.description,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              )
            : null,
      ),
    );
  }

  FCCustomFieldDefinition _convertToFieldDefinition(FCUserSetting setting) {
    return FCCustomFieldDefinition(
      name: setting.title,
      description: setting.description,
      key: setting.fieldId,
      fieldId: setting.fieldId,
      type: setting.fieldType,
      format: '',
      defaultValue: setting.defaultValue,
      options: '',
      displayOrder: setting.displayOrder,
      choices: setting.choices,
      required: setting.required,
      maxLength: setting.maxLength,
    );
  }

  dynamic _parseValueFromController(FCUserSetting setting, String text) {
    if (setting.dataType == 'boolean') {
      return text == '1' || text.toLowerCase() == 'true';
    }
    if (setting.dataType == 'number') {
      return num.tryParse(text) ?? 0;
    }
    if (setting.dataType == 'array') {
      return text.split(',').where((s) => s.isNotEmpty).toList();
    }
    return text;
  }
}

