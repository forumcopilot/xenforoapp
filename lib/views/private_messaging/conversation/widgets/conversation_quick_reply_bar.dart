import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../../../theme/design_tokens.dart';

/// The composer at the bottom of a conversation: type and send without
/// leaving it. The text stays when sending fails, and is kept on this device
/// under [draftKey] (the full Reply page keeps its draft under the same key,
/// so the two share one draft).
class ConversationQuickReplyBar extends StatefulWidget {
  const ConversationQuickReplyBar({
    super.key,
    required this.draftKey,
    required this.onSend,
    this.onOpenFullEditor,
  });

  final String draftKey;

  /// Sends the text; true when it was posted.
  final Future<bool> Function(String text) onSend;

  /// Opens the full Reply page (attachments, formatting) on this bar's text,
  /// which it edits in place; true when the reply was posted there.
  final Future<bool> Function(TextEditingController controller)? onOpenFullEditor;

  @override
  State<ConversationQuickReplyBar> createState() => _ConversationQuickReplyBarState();
}

class _ConversationQuickReplyBarState extends State<ConversationQuickReplyBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _draftTimer;
  bool _sending = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onChanged);
    _restoreDraft();
  }

  Future<void> _restoreDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final draft = prefs.getString(widget.draftKey);
      // Never over text already typed.
      if (!mounted || draft == null || draft.trim().isEmpty || _controller.text.isNotEmpty) return;
      _controller.text = draft;
      _controller.selection = TextSelection.collapsed(offset: draft.length);
    } catch (e) {
      debugPrint('ConversationQuickReplyBar: restoring the draft failed: $e');
    }
  }

  void _onChanged() {
    final hasText = _controller.text.trim().isNotEmpty;
    if (hasText != _hasText) setState(() => _hasText = hasText);
    _draftTimer?.cancel();
    _draftTimer = Timer(const Duration(seconds: 2), _saveDraft);
  }

  Future<void> _saveDraft() async {
    _draftTimer?.cancel();
    final text = _controller.text;
    try {
      final prefs = await SharedPreferences.getInstance();
      if (text.trim().isEmpty) {
        await prefs.remove(widget.draftKey);
      } else {
        await prefs.setString(widget.draftKey, text);
      }
    } catch (e) {
      debugPrint('ConversationQuickReplyBar: saving the draft failed: $e');
    }
  }

  Future<void> _submit() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() => _sending = true);
    var sent = false;
    try {
      sent = await widget.onSend(text);
    } catch (e) {
      // [onSend] reports its own failures; the text stays either way.
      debugPrint('ConversationQuickReplyBar: sending failed: $e');
    } finally {
      if (mounted) setState(() => _sending = false);
    }
    if (!mounted || !sent) return;
    _controller.clear();
    await _saveDraft();
    if (mounted) _focusNode.requestFocus();
  }

  Future<void> _openFullEditor() async {
    final open = widget.onOpenFullEditor;
    if (open == null || _sending) return;
    _draftTimer?.cancel();
    final sent = await open(_controller);
    if (!mounted) return;
    if (sent) _controller.clear();
    await _saveDraft();
  }

  @override
  void dispose() {
    _draftTimer?.cancel();
    _controller.removeListener(_onChanged);
    // Left without sending: keep what was typed.
    _saveDraft();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final canSend = _hasText && !_sending;

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacingS,
          vertical: DesignTokens.spacingS,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border(
            top: BorderSide(color: theme.dividerColor.withValues(alpha: 0.5)),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (widget.onOpenFullEditor != null)
              IconButton(
                icon: const Icon(Icons.open_in_full),
                tooltip: l10n.openFullEditor,
                onPressed: _sending ? null : _openFullEditor,
              ),
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                readOnly: _sending,
                minLines: 1,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                textCapitalization: TextCapitalization.sentences,
                style: theme.textTheme.bodyLarge,
                decoration: InputDecoration(
                  hintText: l10n.writeYourReply,
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHighest,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacingL,
                    vertical: DesignTokens.spacingM,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusXL),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: DesignTokens.spacingS),
            _SendButton(
              enabled: canSend,
              sending: _sending,
              tooltip: l10n.sendMessage,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({
    required this.enabled,
    required this.sending,
    required this.tooltip,
    required this.onPressed,
  });

  final bool enabled;
  final bool sending;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final background = enabled ? colorScheme.primary : colorScheme.surfaceContainerHighest;
    final foreground = enabled ? colorScheme.onPrimary : colorScheme.onSurface.withValues(alpha: 0.38);
    return Tooltip(
      message: tooltip,
      child: Material(
        color: background,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: enabled ? onPressed : null,
          child: SizedBox.square(
            dimension: kMinInteractiveDimension,
            child: Center(
              child: sending
                  ? SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: colorScheme.primary),
                    )
                  : Icon(Icons.send_rounded, size: 22, color: foreground, semanticLabel: tooltip),
            ),
          ),
        ),
      ),
    );
  }
}
