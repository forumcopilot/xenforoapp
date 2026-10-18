import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';

class ForumPasswordDialog extends StatefulWidget {
  final String forumName;
  final Function(String) onPasswordSubmitted;

  const ForumPasswordDialog({
    Key? key,
    required this.forumName,
    required this.onPasswordSubmitted,
  }) : super(key: key);

  @override
  State<ForumPasswordDialog> createState() => _ForumPasswordDialogState();
}

class _ForumPasswordDialogState extends State<ForumPasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      title: Text(
        AppLocalizations.of(context).protectedForum,
        style: textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).forumIsPasswordProtected(widget.forumName),
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).passwordLabel,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context).pleaseEnterTheForumPassword;
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            AppLocalizations.of(context).cancel,
            style: textTheme.labelLarge?.copyWith(
              color: colorScheme.primary,
            ),
          ),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onPasswordSubmitted(_passwordController.text);
              Navigator.of(context).pop();
            }
          },
          child: Text(
            AppLocalizations.of(context).enterButton,
            style: textTheme.labelLarge?.copyWith(
              color: colorScheme.onPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
