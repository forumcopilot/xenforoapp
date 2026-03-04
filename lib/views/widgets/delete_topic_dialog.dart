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
      title: Text(AppLocalizations.of(context)?.deleteTopic ?? 'Delete Topic'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RadioListTile<bool>(
              title: Text(AppLocalizations.of(context)?.softDelete ?? 'Soft Delete'),
              subtitle: Text(AppLocalizations.of(context)?.topicCanBeRestoredLater ?? 'Topic can be restored later'),
              value: false,
              groupValue: _hardDelete,
              onChanged: (value) {
                setState(() {
                  _hardDelete = value ?? false;
                });
              },
            ),
            RadioListTile<bool>(
              title: Text(AppLocalizations.of(context)?.hardDelete ?? 'Hard Delete'),
              subtitle: Text(AppLocalizations.of(context)?.topicWillBePermanentlyDeleted ?? 'Topic will be permanently deleted'),
              value: true,
              groupValue: _hardDelete,
              onChanged: (value) {
                setState(() {
                  _hardDelete = value ?? true;
                });
              },
            ),
            const SizedBox(height: DesignTokens.spacingL),
            TextFormField(
              controller: _reasonController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)?.reasonForDeletion ?? 'Reason for deletion',
                hintText: AppLocalizations.of(context)?.enterReasonForDeletingTopic ?? 'Enter the reason for deleting this topic',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return AppLocalizations.of(context)?.pleaseEnterReasonForDeletion ?? 'Please enter a reason for deletion';
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
          child: Text(AppLocalizations.of(context)?.cancel ?? 'Cancel'),
        ),
        FilledButton(
          onPressed: _handleSubmit,
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
          ),
          child: Text(AppLocalizations.of(context)?.deleteTopic ?? 'Delete Topic'),
        ),
      ],
    );
  }
}

