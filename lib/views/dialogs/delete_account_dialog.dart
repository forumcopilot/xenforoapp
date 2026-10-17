import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/interfaces/interfaces.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../utils/network_utils.dart';

/// Asks before deleting the signed-in member's account on [siteContext]'s
/// forum, says what goes and what stays, and takes the password (or the user
/// name, for an account signed up without one) to confirm. True once the
/// forum has deleted it.
Future<bool> showDeleteAccountDialog(
  BuildContext context, {
  required SiteContext siteContext,
  required IFCAccountDeletion proxy,
}) async {
  final deleted = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _DeleteAccountDialog(siteContext: siteContext, proxy: proxy),
  );
  return deleted ?? false;
}

class _DeleteAccountDialog extends StatefulWidget {
  const _DeleteAccountDialog({required this.siteContext, required this.proxy});

  final SiteContext siteContext;
  final IFCAccountDeletion proxy;

  @override
  State<_DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<_DeleteAccountDialog> {
  final TextEditingController _controller = TextEditingController();
  bool _withUsername = false;
  bool _obscure = true;
  bool _deleting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context);
    final value = _controller.text;
    if (value.trim().isEmpty || _deleting) return;
    setState(() {
      _deleting = true;
      _error = null;
    });
    final result = await widget.proxy.deleteAccount(
      password: _withUsername ? null : value,
      username: _withUsername ? value.trim() : null,
    );
    if (!mounted) return;
    if (result.result) {
      Navigator.of(context).pop(true);
      return;
    }
    final reason = result.resultText?.trim();
    setState(() {
      _deleting = false;
      _error = NetworkUtils.isUnreachable(reason)
          ? l10n.errorNetwork
          : (reason != null && reason.isNotEmpty ? reason : l10n.unexpectedErrorOccurred);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final canDelete = _controller.text.trim().isNotEmpty && !_deleting;

    return AlertDialog(
      icon: Icon(Icons.warning_amber_rounded, color: colorScheme.error),
      title: Text(l10n.deleteAccountConfirmTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.deleteAccountConfirmMessage(widget.siteContext.site.displayName),
              style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              enabled: !_deleting,
              autofocus: true,
              obscureText: !_withUsername && _obscure,
              autofillHints: [_withUsername ? AutofillHints.username : AutofillHints.password],
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _delete(),
              decoration: InputDecoration(
                labelText: _withUsername ? l10n.usernameLabel : l10n.passwordLabel,
                errorText: _error,
                errorMaxLines: 4,
                suffixIcon: _withUsername
                    ? null
                    : IconButton(
                        icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton(
                onPressed: _deleting
                    ? null
                    : () => setState(() {
                          _withUsername = !_withUsername;
                          _controller.clear();
                          _error = null;
                        }),
                child: Text(_withUsername ? l10n.deleteAccountUsePassword : l10n.deleteAccountNoPassword),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _deleting ? null : () => Navigator.of(context).pop(false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: canDelete ? _delete : null,
          style: FilledButton.styleFrom(backgroundColor: colorScheme.error, foregroundColor: colorScheme.onError),
          child: _deleting
              ? SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2, color: colorScheme.onError))
              : Text(l10n.deleteAccount),
        ),
      ],
    );
  }
}
