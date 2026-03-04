import 'package:flutter/material.dart';

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
        'Protected Forum',
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
              '${widget.forumName} is password protected.',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the forum password';
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
            'Cancel',
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
            'Enter',
            style: textTheme.labelLarge?.copyWith(
              color: colorScheme.onPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
