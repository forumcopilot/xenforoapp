import 'package:flutter/material.dart';
import 'package:forumcopilot_flutter/views/widgets/custom_field_widget.dart';
import 'package:forumcopilot_sdk/models/entities/fc_custom_field_definition.dart';
import '../theme/design_tokens.dart';
import '../theme/style_builders.dart';

class CustomFieldsPage extends StatefulWidget {
  final List<FCCustomFieldDefinition> customFields;
  final Map<String, TextEditingController> customFieldControllers;
  final Map<String, FocusNode> customFieldFocusNodes;
  final VoidCallback onCustomFieldsComplete;
  final Function(String)? onError; // Callback for handling errors

  const CustomFieldsPage({
    super.key,
    required this.customFields,
    required this.customFieldControllers,
    required this.customFieldFocusNodes,
    required this.onCustomFieldsComplete,
    this.onError,
  });

  @override
  State<CustomFieldsPage> createState() => _CustomFieldsPageState();
}

class _CustomFieldsPageState extends State<CustomFieldsPage> {
  final _formKey = GlobalKey<FormState>();

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
              // Custom fields section
              Padding(
                padding: DesignTokens.paddingScreen,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: _buildCustomFieldsSection(colorScheme, textTheme),
                ),
              ),
              // Form actions
              Padding(
                padding: DesignTokens.paddingScreen,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: _buildFormActions(colorScheme, textTheme),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCustomFieldsSection(ColorScheme colorScheme, TextTheme textTheme) {
    List<Widget> widgets = [];

    // Add each custom field using the CustomFieldWidget
    for (int i = 0; i < widget.customFields.length; i++) {
      final field = widget.customFields[i];
      final controller = widget.customFieldControllers[field.key];
      final focusNode = widget.customFieldFocusNodes[field.key];

      // Skip fields that don't have controllers/focus nodes set up
      if (controller == null || focusNode == null) {
        debugPrint('[CustomFieldsPage] Warning: Missing controller or focus node for field "${field.name}" (${field.key})');
        continue;
      }

      widgets.add(
        CustomFieldWidget(
          field: field,
          controller: controller,
          focusNode: focusNode,
          onFieldSubmitted: () {
            if (i < widget.customFields.length - 1) {
              widget.customFieldFocusNodes[widget.customFields[i + 1].key]?.requestFocus();
            } else {
              _handleContinue();
            }
          },
          validator: (value) => CustomFieldValidator.validateField(field, value),
        ),
      );

      if (i < widget.customFields.length - 1) {
        widgets.add(const SizedBox(height: DesignTokens.spacingXXL));
      }
    }

    return widgets;
  }

  List<Widget> _buildFormActions(ColorScheme colorScheme, TextTheme textTheme) {
    return [
      const SizedBox(height: DesignTokens.spacingXXL),
      // Continue button with Material 3 design
      FilledButton(
        onPressed: _handleContinue,
        style: FilledButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: DesignTokens.spacingXL - DesignTokens.spacingXS),
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

  void _handleContinue() {
    if (_formKey.currentState!.validate()) {
      // All custom fields are valid, proceed with registration
      widget.onCustomFieldsComplete();
    }
  }
}
