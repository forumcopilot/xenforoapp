import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:get/get.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../services/site_proxy_service.dart';
import '../../theme/design_tokens.dart';
import '../../utils/snackbar_helper.dart';

/// Change the account's email address, confirmed with the password. The
/// forum may email a confirmation link first; the page says so.
class ChangeEmailPage extends StatefulWidget {
  const ChangeEmailPage({super.key, required this.siteContext});

  final SiteContext siteContext;

  @override
  State<ChangeEmailPage> createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _saving = false;
  bool _visible = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving || !(_formKey.currentState?.validate() ?? false)) return;
    final l10n = AppLocalizations.of(context);
    setState(() => _saving = true);
    final result = await SiteProxyService.getAccountProxy().updateEmail(_password.text, _email.text.trim());
    if (!mounted) return;
    setState(() => _saving = false);
    if (!result.result) {
      final reason = result.resultText?.trim();
      SnackbarHelper.showError(context, (reason != null && reason.isNotEmpty) ? reason : (l10n?.somethingWentWrong ?? 'Something went wrong'));
      return;
    }
    SnackbarHelper.showSuccess(
      context,
      result.confirmationRequired
          ? (l10n?.emailChangeConfirm ?? 'Check your inbox: the new address takes effect once you confirm it.')
          : (l10n?.emailChanged ?? 'Email address changed'),
    );
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.changeEmail ?? 'Change email'),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: Text(l10n?.save ?? 'Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: AutofillGroup(
          child: ListView(
            padding: const EdgeInsets.all(DesignTokens.spacingL),
            children: [
              if (_saving) const LinearProgressIndicator(),
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                enableSuggestions: false,
                autofillHints: const [AutofillHints.email],
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: l10n?.newEmailAddress ?? 'New email address'),
                validator: (v) {
                  final value = v?.trim() ?? '';
                  if (value.isEmpty) return l10n?.pleaseEnterEmail ?? 'Please enter your email';
                  if (!GetUtils.isEmail(value)) return l10n?.pleaseEnterValidEmail ?? 'Please enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: DesignTokens.spacingL),
              TextFormField(
                controller: _password,
                obscureText: !_visible,
                autofillHints: const [AutofillHints.password],
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _save(),
                decoration: InputDecoration(
                  labelText: l10n?.currentPassword ?? 'Current password',
                  suffixIcon: IconButton(
                    icon: Icon(_visible ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                    onPressed: () => setState(() => _visible = !_visible),
                  ),
                ),
                validator: (v) => (v == null || v.isEmpty) ? (l10n?.pleaseEnterPassword ?? 'Please enter your password') : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
