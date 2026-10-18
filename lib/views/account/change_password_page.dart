import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:get/get.dart';

import '../../controllers/login_controller.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../services/site_proxy_service.dart';
import '../../theme/design_tokens.dart';
import '../../utils/snackbar_helper.dart';

/// Change the account's password. The SDK and the add-on have supported it
/// for a long time; no screen used them.
class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key, required this.siteContext});

  final SiteContext siteContext;

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _current = TextEditingController();
  final _new = TextEditingController();
  final _confirm = TextEditingController();
  bool _saving = false;
  bool _visible = false;

  @override
  void dispose() {
    _current.dispose();
    _new.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving || !(_formKey.currentState?.validate() ?? false)) return;
    final l10n = AppLocalizations.of(context);
    setState(() => _saving = true);
    final result = await SiteProxyService.getAccountProxy().updatePassword(_current.text, _new.text);
    if (!mounted) return;
    setState(() => _saving = false);
    if (!result.result) {
      final reason = result.resultText?.trim();
      SnackbarHelper.showError(context, (reason != null && reason.isNotEmpty) ? reason : l10n.somethingWentWrong);
      return;
    }
    if (!Get.isRegistered<LoginController>()) Get.put(LoginController());
    await Get.find<LoginController>().rememberNewPassword(widget.siteContext, _new.text);
    if (!mounted) return;
    SnackbarHelper.showSuccess(context, l10n.passwordChanged);
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    InputDecoration field(String label) => InputDecoration(
          labelText: label,
          suffixIcon: IconButton(
            icon: Icon(_visible ? Icons.visibility_off_outlined : Icons.visibility_outlined),
            onPressed: () => setState(() => _visible = !_visible),
          ),
        );
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.changePassword),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: Text(l10n.save),
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
                controller: _current,
                obscureText: !_visible,
                autofillHints: const [AutofillHints.password],
                textInputAction: TextInputAction.next,
                decoration: field(l10n.currentPassword),
                validator: (v) => (v == null || v.isEmpty) ? l10n.pleaseEnterPassword : null,
              ),
              const SizedBox(height: DesignTokens.spacingL),
              TextFormField(
                controller: _new,
                obscureText: !_visible,
                autofillHints: const [AutofillHints.newPassword],
                textInputAction: TextInputAction.next,
                decoration: field(l10n.newPassword),
                validator: (v) => (v == null || v.isEmpty) ? l10n.pleaseEnterPassword : null,
              ),
              const SizedBox(height: DesignTokens.spacingL),
              TextFormField(
                controller: _confirm,
                obscureText: !_visible,
                autofillHints: const [AutofillHints.newPassword],
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _save(),
                decoration: field(l10n.confirmNewPassword),
                validator: (v) => v != _new.text ? l10n.passwordsDoNotMatch : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
