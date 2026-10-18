import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../theme/design_tokens.dart';

/// Dialog for deleting a topic.
/// 
/// Returns a Map with the following keys:
/// - 'hardDelete' (bool): true for hard delete, false for soft delete
/// - 'reason' (String): Reason for deletion
/// - 'starterAlert' (bool): Always false (kept for backward compatibility)
/// - 'starterAlertReason' (String?): Always null (kept for backward compatibility)
/// 
/// Returns null if cancelled.
class DeleteTopicDialog extends StatefulWidget {
  const DeleteTopicDialog({
    super.key,
    this.topicTitle,
  });

  /// Optional topic title to display in the dialog
  final String? topicTitle;

  /// Show the dialog and return the result
  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    String? topicTitle,
  }) {
    return showDialog<Map<String, dynamic>?>(
      context: context,
      builder: (context) => DeleteTopicDialog(topicTitle: topicTitle),
    );
  }

  @override
  State<DeleteTopicDialog> createState() => _DeleteTopicDialogState();
}

class _DeleteTopicDialogState extends State<DeleteTopicDialog> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  
  bool _hardDelete = false; // Default to soft delete

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.of(context).pop({
        'hardDelete': _hardDelete,
        'reason': _reasonController.text.trim(),
        'starterAlert': false,
        'starterAlertReason': null,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context).deleteTopic),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RadioGroup<bool>(
              groupValue: _hardDelete,
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _hardDelete = value;
                });
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                RadioListTile<bool>(
                  title: Text(AppLocalizations.of(context).softDelete),
                  subtitle: Text(AppLocalizations.of(context).topicCanBeRestoredLater),
                  value: false,
                ),
                RadioListTile<bool>(
                  title: Text(AppLocalizations.of(context).hardDelete),
                  subtitle: Text(AppLocalizations.of(context).topicWillBePermanentlyDeleted),
                  value: true,
                ),
                ],
              ),
            ),
            const SizedBox(height: DesignTokens.spacingL),
            TextFormField(
              controller: _reasonController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).reasonForDeletion,
                hintText: AppLocalizations.of(context).enterReasonForDeletingTopic,
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return AppLocalizations.of(context).pleaseEnterReasonForDeletion;
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: Text(AppLocalizations.of(context).cancel),
        ),
        FilledButton(
          onPressed: _handleSubmit,
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
          ),
          child: Text(AppLocalizations.of(context).deleteTopic),
        ),
      ],
    );
  }
}

