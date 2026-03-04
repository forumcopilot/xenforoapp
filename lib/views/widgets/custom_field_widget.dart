import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/models/entities/fc_custom_field_definition.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../theme/design_tokens.dart';
import '../../theme/style_builders.dart';
import '../../l10n/generated/app_localizations.dart';

class CustomFieldWidget extends StatefulWidget {
  final FCCustomFieldDefinition field;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final VoidCallback? onFieldSubmitted;
  final String? Function(String?)? validator;

  const CustomFieldWidget({
    Key? key,
    required this.field,
    required this.controller,
    this.focusNode,
    this.onFieldSubmitted,
    this.validator,
  }) : super(key: key);

  @override
  State<CustomFieldWidget> createState() => _CustomFieldWidgetState();
}

class _CustomFieldWidgetState extends State<CustomFieldWidget> {
  FCCustomFieldDefinition get field => widget.field;
  TextEditingController get controller => widget.controller;
  FocusNode? get focusNode => widget.focusNode;
  VoidCallback? get onFieldSubmitted => widget.onFieldSubmitted;
  String? Function(String?)? get validator => widget.validator;
  
  // Parse date from controller text (YYYY-MM-DD format)
  DateTime? _getSelectedDate() {
    final text = controller.text.trim();
    if (text.isEmpty) return null;
    try {
      return DateFormat('yyyy-MM-dd').parse(text);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldByType(colorScheme),
      ],
    );
  }

  Widget _buildFieldByType(ColorScheme colorScheme) {
    final fieldType = field.type.toLowerCase();
    final options = _getOptions();
    
    // Special handling: checkbox with multiple choices (>2) should be multiselect
    // Single checkbox (1-2 choices) is for boolean yes/no fields
    if ((fieldType == 'checkbox' || fieldType == 'cbox') && options.length > 2) {
      return _buildMultiSelectField(colorScheme);
    }
    
    switch (fieldType) {
      case 'select':
      case 'drop':
        return _buildDropdownField(colorScheme);
      case 'multiselect':
        return _buildMultiSelectField(colorScheme);
      case 'radio':
        return _buildRadioField(colorScheme);
      case 'checkbox':
      case 'cbox':
        return _buildCheckboxField(colorScheme);
      case 'textarea':
        return _buildTextAreaField(colorScheme);
      case 'date':
        return _buildDateField(colorScheme);
      case 'number':
      case 'numeric':
        return _buildNumberField(colorScheme);
      case 'textbox':
      case 'input':
      default:
        // Color type is no longer supported by the API
        // If encountered, treat as regular text input
        return _buildInputField(colorScheme);
    }
  }

  Widget _buildDropdownField(ColorScheme colorScheme) {
    final options = _getOptions();
    final selectedValue = controller.text.isEmpty ? null : controller.text;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Field label
        if (field.name.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: DesignTokens.spacingS),
            child: Text(
              '${field.name}${field.required ? " *" : ""}',
              style: StyleBuilders.titleTextStyle(
                colorScheme: colorScheme,
                textTheme: textTheme,
                fontSize: DesignTokens.fontSizeM,
                fontWeight: DesignTokens.fontWeightMedium,
              ),
            ),
          ),
        // Dropdown field
        DropdownButtonFormField<String>(
          value: options.containsKey(selectedValue) ? selectedValue : null,
          decoration: StyleBuilders.inputDecoration(
            colorScheme: colorScheme,
            labelText: null, // Remove floating label since we have explicit label above
            hintText: AppLocalizations.of(context)?.selectAnOption ?? 'Select an option',
            prefixIcon: Icons.arrow_drop_down_circle_outlined,
          ),
          hint: Text(
            'Select an option',
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
          items: options.entries.map((entry) {
            return DropdownMenuItem<String>(
              value: entry.key,
              child: Text(
                entry.value,
                style: TextStyle(color: colorScheme.onSurface),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              controller.text = value ?? '';
            });
            if (onFieldSubmitted != null) {
              onFieldSubmitted!();
            }
          },
          validator: validator,
          menuMaxHeight: 300, // Better for mobile
          isExpanded: true, // Better for mobile
          icon: Icon(
            Icons.arrow_drop_down,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        // Field description
        if (field.description.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: DesignTokens.spacingS),
            child: Text(
              field.description,
              style: StyleBuilders.smallTextStyle(
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
            ),
          ),
        // Validation error display
        if (validator != null)
          Builder(
            builder: (context) {
              final error = validator!(controller.text);
              if (error != null) {
                return Padding(
                  padding: const EdgeInsets.only(
                    top: DesignTokens.spacingS,
                    left: DesignTokens.spacingM,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 16,
                        color: colorScheme.error,
                      ),
                      const SizedBox(width: DesignTokens.spacingXS),
                      Expanded(
                        child: Text(
                          error,
                          style: StyleBuilders.smallTextStyle(
                            colorScheme: colorScheme,
                            textTheme: textTheme,
                            color: colorScheme.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
      ],
    );
  }

  Widget _buildRadioField(ColorScheme colorScheme) {
    final options = _getOptions();
    final selectedValue = controller.text.isEmpty ? null : controller.text;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Field label
        if (field.name.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: DesignTokens.spacingS),
            child: Text(
              '${field.name}${field.required ? " *" : ""}',
              style: StyleBuilders.titleTextStyle(
                colorScheme: colorScheme,
                textTheme: Theme.of(context).textTheme,
                fontSize: DesignTokens.fontSizeM,
                fontWeight: DesignTokens.fontWeightMedium,
              ),
            ),
          ),
        // Radio options in Material 3 card
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(
              alpha: DesignTokens.opacityLow,
            ),
            borderRadius: BorderRadius.circular(DesignTokens.radiusL),
          ),
          padding: const EdgeInsets.symmetric(vertical: DesignTokens.spacingXS),
          child: Column(
            children: options.entries.map((entry) {
              return RadioListTile<String>(
                title: Text(
                  entry.value,
                  style: TextStyle(color: colorScheme.onSurface),
                ),
                value: entry.key,
                groupValue: selectedValue,
                onChanged: (value) {
                  setState(() {
                    controller.text = value ?? '';
                  });
                  if (onFieldSubmitted != null) {
                    onFieldSubmitted!();
                  }
                },
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacingM,
                  vertical: DesignTokens.spacingXS,
                ),
                dense: false, // Better touch targets for mobile
                visualDensity: VisualDensity.comfortable,
              );
            }).toList(),
          ),
        ),
        // Field description
        if (field.description.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: DesignTokens.spacingS),
            child: Text(
              field.description,
              style: StyleBuilders.smallTextStyle(
                colorScheme: colorScheme,
                textTheme: Theme.of(context).textTheme,
              ),
            ),
          ),
        // Validation error display
        if (validator != null)
          Builder(
            builder: (context) {
              final error = validator!(controller.text);
              if (error != null) {
                return Padding(
                  padding: const EdgeInsets.only(
                    top: DesignTokens.spacingS,
                    left: DesignTokens.spacingM,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 16,
                        color: colorScheme.error,
                      ),
                      const SizedBox(width: DesignTokens.spacingXS),
                      Expanded(
                        child: Text(
                          error,
                          style: StyleBuilders.smallTextStyle(
                            colorScheme: colorScheme,
                            textTheme: Theme.of(context).textTheme,
                            color: colorScheme.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
      ],
    );
  }

  Widget _buildCheckboxField(ColorScheme colorScheme) {
    final options = _getOptions();

    // DEBUG: Print checkbox field information
    debugPrint('[CustomFieldWidget] === CHECKBOX FIELD DEBUG ===');
    debugPrint('[CustomFieldWidget] Field name: "${field.name}"');
    debugPrint('[CustomFieldWidget] Field identifier: "${field.identifier}"');
    debugPrint('[CustomFieldWidget] Field type: "${field.type}"');
    debugPrint('[CustomFieldWidget] Raw options: "${field.options}"');
    debugPrint('[CustomFieldWidget] Parsed options: $options');
    debugPrint('[CustomFieldWidget] Current controller text: "${controller.text}"');

    // Determine the true/false values from options
    // Default to '1'/'0' if no options are specified
    String trueValue = '1';
    String falseValue = '0';
    String trueLabel = field.name;

    if (options.isNotEmpty) {
      // Find which option represents "true" (usually the first one or one containing "yes", "true", "1")
      final sortedEntries = options.entries.toList();

      debugPrint('[CustomFieldWidget] Sorted entries: $sortedEntries');

      // Look for common "true" indicators
      final trueEntry = sortedEntries.firstWhere(
        (entry) => entry.key == '1' || entry.value.toLowerCase().contains('yes') || entry.value.toLowerCase().contains('true') || entry.value.toLowerCase().contains('on'),
        orElse: () => sortedEntries.first,
      );

      trueValue = trueEntry.key;
      trueLabel = trueEntry.value;

      // The false value is the other option
      final falseEntry = sortedEntries.firstWhere(
        (entry) => entry.key != trueValue,
        orElse: () => const MapEntry('0', 'No'),
      );
      falseValue = falseEntry.key;

      debugPrint('[CustomFieldWidget] True entry: $trueEntry');
      debugPrint('[CustomFieldWidget] False entry: $falseEntry');
    }

    debugPrint('[CustomFieldWidget] Final trueValue: "$trueValue"');
    debugPrint('[CustomFieldWidget] Final falseValue: "$falseValue"');
    debugPrint('[CustomFieldWidget] Final trueLabel: "$trueLabel"');

    // Initialize controller if empty
    if (controller.text.isEmpty) {
      debugPrint('[CustomFieldWidget] Controller is empty, setting to falseValue: "$falseValue"');
      controller.text = falseValue;
    }

    final isChecked = controller.text == trueValue;
    debugPrint('[CustomFieldWidget] Is checked: $isChecked (controller.text="${controller.text}" == trueValue="$trueValue")');
    debugPrint('[CustomFieldWidget] === CHECKBOX FIELD DEBUG END ===');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Field label
        if (field.name.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: DesignTokens.spacingS),
            child: Text(
              '${field.name}${field.required ? " *" : ""}',
              style: StyleBuilders.titleTextStyle(
                colorScheme: colorScheme,
                textTheme: Theme.of(context).textTheme,
                fontSize: DesignTokens.fontSizeM,
                fontWeight: DesignTokens.fontWeightMedium,
              ),
            ),
          ),
        // Checkbox in Material 3 card
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(
              alpha: DesignTokens.opacityLow,
            ),
            borderRadius: BorderRadius.circular(DesignTokens.radiusL),
          ),
          child: CheckboxListTile(
            title: Text(
              trueLabel,
              style: TextStyle(color: colorScheme.onSurface),
            ),
            subtitle: field.description.isNotEmpty
                ? Text(
                    field.description,
                    style: StyleBuilders.smallTextStyle(
                      colorScheme: colorScheme,
                      textTheme: Theme.of(context).textTheme,
                    ),
                  )
                : null,
            value: isChecked,
            onChanged: (value) {
              debugPrint('[CustomFieldWidget] === CHECKBOX CHANGE EVENT ===');
              debugPrint('[CustomFieldWidget] User clicked checkbox, new value: $value');
              debugPrint('[CustomFieldWidget] Current controller text: "${controller.text}"');
              debugPrint('[CustomFieldWidget] Current isChecked: $isChecked');
              debugPrint('[CustomFieldWidget] Available trueValue: "$trueValue", falseValue: "$falseValue"');

              // Toggle based on the new checkbox value
              final newValue = (value == true) ? trueValue : falseValue;
              debugPrint('[CustomFieldWidget] Setting controller to: "$newValue"');

              setState(() {
                controller.text = newValue;
              });
              debugPrint('[CustomFieldWidget] Controller text after change: "${controller.text}"');

              if (onFieldSubmitted != null) {
                onFieldSubmitted!();
              }
              debugPrint('[CustomFieldWidget] === CHECKBOX CHANGE EVENT END ===');
            },
            contentPadding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.spacingM,
              vertical: DesignTokens.spacingXS,
            ),
            dense: false, // Better touch targets for mobile
            visualDensity: VisualDensity.comfortable,
          ),
        ),
        // Validation error display
        if (validator != null)
          Builder(
            builder: (context) {
              final error = validator!(controller.text);
              if (error != null) {
                return Padding(
                  padding: const EdgeInsets.only(
                    top: DesignTokens.spacingS,
                    left: DesignTokens.spacingM,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 16,
                        color: colorScheme.error,
                      ),
                      const SizedBox(width: DesignTokens.spacingXS),
                      Expanded(
                        child: Text(
                          error,
                          style: StyleBuilders.smallTextStyle(
                            colorScheme: colorScheme,
                            textTheme: Theme.of(context).textTheme,
                            color: colorScheme.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
      ],
    );
  }

  Widget _buildTextAreaField(ColorScheme colorScheme) {
    final textTheme = Theme.of(context).textTheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Field label
        if (field.name.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: DesignTokens.spacingS),
            child: Text(
              '${field.name}${field.required ? " *" : ""}',
              style: StyleBuilders.titleTextStyle(
                colorScheme: colorScheme,
                textTheme: textTheme,
                fontSize: DesignTokens.fontSizeM,
                fontWeight: DesignTokens.fontWeightMedium,
              ),
            ),
          ),
        // Textarea field
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          maxLines: 5,
          minLines: 4,
          keyboardType: TextInputType.multiline,
          textCapitalization: TextCapitalization.sentences,
          decoration: StyleBuilders.inputDecoration(
            colorScheme: colorScheme,
            labelText: null, // Remove floating label since we have explicit label above
            hintText: field.description.isNotEmpty ? field.description : null,
            prefixIcon: null, // No icon for multi-line textarea
          ),
          textInputAction: TextInputAction.newline,
          onFieldSubmitted: (_) {
            if (onFieldSubmitted != null) {
              onFieldSubmitted!();
            }
          },
          validator: validator,
          maxLength: field.maxLength != null && field.maxLength! > 0 ? field.maxLength : null,
        ),
        // Validation error display
        if (validator != null)
          Builder(
            builder: (context) {
              final error = validator!(controller.text);
              if (error != null) {
                return Padding(
                  padding: const EdgeInsets.only(
                    top: DesignTokens.spacingS,
                    left: DesignTokens.spacingM,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 16,
                        color: colorScheme.error,
                      ),
                      const SizedBox(width: DesignTokens.spacingXS),
                      Expanded(
                        child: Text(
                          error,
                          style: StyleBuilders.smallTextStyle(
                            colorScheme: colorScheme,
                            textTheme: textTheme,
                            color: colorScheme.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
      ],
    );
  }

  Widget _buildDateField(ColorScheme colorScheme) {
    final selectedDate = _getSelectedDate();
    final textTheme = Theme.of(context).textTheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Field label
        if (field.name.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: DesignTokens.spacingS),
            child: Text(
              '${field.name}${field.required ? " *" : ""}',
              style: StyleBuilders.titleTextStyle(
                colorScheme: colorScheme,
                textTheme: textTheme,
                fontSize: DesignTokens.fontSizeM,
                fontWeight: DesignTokens.fontWeightMedium,
              ),
            ),
          ),
        // Date picker field
        InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
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
              // Format date as YYYY-MM-DD (ISO 8601) and store in controller
              final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
              controller.text = formattedDate;
              setState(() {}); // Update UI to show selected date
              if (onFieldSubmitted != null) {
                onFieldSubmitted!();
              }
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
                    selectedDate != null
                        ? DateFormat('yyyy-MM-dd').format(selectedDate)
                        : 'Select date',
                    style: TextStyle(
                      color: selectedDate != null
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
        // Field description
        if (field.description.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: DesignTokens.spacingS),
            child: Text(
              field.description,
              style: StyleBuilders.smallTextStyle(
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
            ),
          ),
        // Validation error display
        if (validator != null)
          Builder(
            builder: (context) {
              final error = validator!(controller.text);
              if (error != null) {
                return Padding(
                  padding: const EdgeInsets.only(
                    top: DesignTokens.spacingS,
                    left: DesignTokens.spacingM,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 16,
                        color: colorScheme.error,
                      ),
                      const SizedBox(width: DesignTokens.spacingXS),
                      Expanded(
                        child: Text(
                          error,
                          style: StyleBuilders.smallTextStyle(
                            colorScheme: colorScheme,
                            textTheme: textTheme,
                            color: colorScheme.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
      ],
    );
  }

  Widget _buildNumberField(ColorScheme colorScheme) {
    final textTheme = Theme.of(context).textTheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Field label
        if (field.name.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: DesignTokens.spacingS),
            child: Text(
              '${field.name}${field.required ? " *" : ""}',
              style: StyleBuilders.titleTextStyle(
                colorScheme: colorScheme,
                textTheme: textTheme,
                fontSize: DesignTokens.fontSizeM,
                fontWeight: DesignTokens.fontWeightMedium,
              ),
            ),
          ),
        // Number input field
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          enabled: true, // Always enabled, readOnly handled via decoration
          decoration: StyleBuilders.inputDecoration(
            colorScheme: colorScheme,
            labelText: null,
            hintText: field.description.isNotEmpty ? field.description : AppLocalizations.of(context)?.enterANumber ?? 'Enter a number',
            prefixIcon: Icons.numbers,
          ).copyWith(
            filled: false,
          ),
          onChanged: (value) {
            setState(() {});
          },
          onFieldSubmitted: (_) {
            if (onFieldSubmitted != null) {
              onFieldSubmitted!();
            }
          },
          validator: validator,
        ),
        // Field description
        if (field.description.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: DesignTokens.spacingS),
            child: Text(
              field.description,
              style: StyleBuilders.smallTextStyle(
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
            ),
          ),
        // Validation error display
        if (validator != null)
          Builder(
            builder: (context) {
              final error = validator!(controller.text);
              if (error != null) {
                return Padding(
                  padding: const EdgeInsets.only(
                    top: DesignTokens.spacingS,
                    left: DesignTokens.spacingM,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 16,
                        color: colorScheme.error,
                      ),
                      const SizedBox(width: DesignTokens.spacingXS),
                      Expanded(
                        child: Text(
                          error,
                          style: StyleBuilders.smallTextStyle(
                            colorScheme: colorScheme,
                            textTheme: textTheme,
                            color: colorScheme.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
      ],
    );
  }

  Widget _buildInputField(ColorScheme colorScheme) {
    final textTheme = Theme.of(context).textTheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Field label
        if (field.name.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: DesignTokens.spacingS),
            child: Text(
              '${field.name}${field.required ? " *" : ""}',
              style: StyleBuilders.titleTextStyle(
                colorScheme: colorScheme,
                textTheme: textTheme,
                fontSize: DesignTokens.fontSizeM,
                fontWeight: DesignTokens.fontWeightMedium,
              ),
            ),
          ),
        // Text input field
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: _getKeyboardType(field.type),
          textCapitalization: _getTextCapitalization(field.type),
          decoration: StyleBuilders.inputDecoration(
            colorScheme: colorScheme,
            labelText: null, // Remove floating label since we have explicit label above
            hintText: field.description.isNotEmpty ? field.description : null,
            prefixIcon: null, // No icon for single-line text fields
          ),
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {
            if (onFieldSubmitted != null) {
              onFieldSubmitted!();
            }
          },
          validator: validator,
          maxLength: field.maxLength != null && field.maxLength! > 0 ? field.maxLength : null,
        ),
        // Validation error display
        if (validator != null)
          Builder(
            builder: (context) {
              final error = validator!(controller.text);
              if (error != null) {
                return Padding(
                  padding: const EdgeInsets.only(
                    top: DesignTokens.spacingS,
                    left: DesignTokens.spacingM,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 16,
                        color: colorScheme.error,
                      ),
                      const SizedBox(width: DesignTokens.spacingXS),
                      Expanded(
                        child: Text(
                          error,
                          style: StyleBuilders.smallTextStyle(
                            colorScheme: colorScheme,
                            textTheme: textTheme,
                            color: colorScheme.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
      ],
    );
  }

  /// Get options, preferring choices Map over parsing options string
  Map<String, String> _getOptions() {
    // Prefer choices Map if available (new API structure)
    if (field.choices != null && field.choices!.isNotEmpty) {
      return field.choices!;
    }
    // Fallback to parsing options string (backward compatibility)
    return _parseOptions(field.options);
  }

  Map<String, String> _parseOptions(String optionsString) {
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

  TextInputType _getKeyboardType(String fieldType) {
    switch (fieldType.toLowerCase()) {
      case 'email':
        return TextInputType.emailAddress;
      case 'phone':
      case 'telephone':
        return TextInputType.phone;
      case 'number':
      case 'numeric':
        return TextInputType.number;
      case 'url':
      case 'website':
        return TextInputType.url;
      case 'multiline':
      case 'textarea':
        return TextInputType.multiline;
      default:
        return TextInputType.text;
    }
  }

  TextCapitalization _getTextCapitalization(String fieldType) {
    switch (fieldType.toLowerCase()) {
      case 'name':
      case 'firstname':
      case 'lastname':
      case 'fullname':
        return TextCapitalization.words;
      case 'sentence':
      case 'description':
      case 'bio':
      case 'textarea':
        return TextCapitalization.sentences;
      default:
        return TextCapitalization.none;
    }
  }

  /// Build multiselect field (checkboxes for multiple selection)
  Widget _buildMultiSelectField(ColorScheme colorScheme) {
    final options = _getOptions();
    final selectedValues = controller.text.isEmpty 
        ? <String>[]
        : controller.text.split(',').where((v) => v.isNotEmpty).toSet();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Field label
        if (field.name.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: DesignTokens.spacingS),
            child: Text(
              '${field.name}${field.required ? " *" : ""}',
              style: StyleBuilders.titleTextStyle(
                colorScheme: colorScheme,
                textTheme: Theme.of(context).textTheme,
                fontSize: DesignTokens.fontSizeM,
                fontWeight: DesignTokens.fontWeightMedium,
              ),
            ),
          ),
        // Multi-select options in Material 3 card
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(
              alpha: DesignTokens.opacityLow,
            ),
            borderRadius: BorderRadius.circular(DesignTokens.radiusL),
          ),
          padding: const EdgeInsets.symmetric(vertical: DesignTokens.spacingXS),
          child: Column(
            children: options.entries.map((entry) {
              final isSelected = selectedValues.contains(entry.key);
              return CheckboxListTile(
                title: Text(
                  entry.value,
                  style: TextStyle(color: colorScheme.onSurface),
                ),
                value: isSelected,
                onChanged: (value) {
                  setState(() {
                    final newValues = Set<String>.from(selectedValues);
                    if (value == true) {
                      newValues.add(entry.key);
                    } else {
                      newValues.remove(entry.key);
                    }
                    controller.text = newValues.join(',');
                  });
                  if (onFieldSubmitted != null) {
                    onFieldSubmitted!();
                  }
                },
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacingM,
                  vertical: DesignTokens.spacingXS,
                ),
                dense: false,
                visualDensity: VisualDensity.comfortable,
              );
            }).toList(),
          ),
        ),
        // Field description
        if (field.description.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: DesignTokens.spacingS),
            child: Text(
              field.description,
              style: StyleBuilders.smallTextStyle(
                colorScheme: colorScheme,
                textTheme: Theme.of(context).textTheme,
              ),
            ),
          ),
        // Validation error display
        if (validator != null)
          Builder(
            builder: (context) {
              final error = validator!(controller.text);
              if (error != null) {
                return Padding(
                  padding: const EdgeInsets.only(
                    top: DesignTokens.spacingS,
                    left: DesignTokens.spacingM,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 16,
                        color: colorScheme.error,
                      ),
                      const SizedBox(width: DesignTokens.spacingXS),
                      Expanded(
                        child: Text(
                          error,
                          style: StyleBuilders.smallTextStyle(
                            colorScheme: colorScheme,
                            textTheme: Theme.of(context).textTheme,
                            color: colorScheme.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
      ],
    );
  }

}

/// Validator helper class for custom fields
class CustomFieldValidator {
  static String? validateField(FCCustomFieldDefinition field, String? value) {
    // Check if field is required
    if (field.required && (value == null || value.trim().isEmpty)) {
      return 'This field is required';
    }

    if (value != null && value.trim().isNotEmpty) {
      switch (field.type.toLowerCase()) {
        case 'email':
          if (!GetUtils.isEmail(value.trim())) {
            return 'Please enter a valid email address';
          }
          break;
        case 'phone':
        case 'telephone':
          if (!GetUtils.isPhoneNumber(value.trim())) {
            return 'Please enter a valid phone number';
          }
          break;
        case 'url':
        case 'website':
          if (!GetUtils.isURL(value.trim())) {
            return 'Please enter a valid URL';
          }
          break;
        case 'number':
        case 'numeric':
          if (!GetUtils.isNum(value.trim())) {
            return 'Please enter a valid number';
          }
          break;
      }
    }

    return null;
  }
}

