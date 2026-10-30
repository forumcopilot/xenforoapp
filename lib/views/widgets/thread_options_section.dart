import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../theme/design_tokens.dart';

/// What the member fills in beyond the title and message when starting a
/// thread, as the website's "Post thread" form has it (XenForo add-on
/// 1.11.0+): the thread type, a poll, custom thread fields and tags.
class ThreadOptionsController extends ChangeNotifier {
  ThreadOptionsController(this.options) : _threadType = _initialType(options);

  final FCThreadPostingOptions options;

  static String _initialType(FCThreadPostingOptions o) {
    if (o.threadTypes.any((t) => t.type == o.defaultThreadType)) return o.defaultThreadType;
    return o.threadTypes.isNotEmpty ? o.threadTypes.first.type : o.defaultThreadType;
  }

  String _threadType;
  String get threadType => _threadType;
  bool get isPoll => _threadType == 'poll';

  void setThreadType(String type) {
    _threadType = type;
    notifyListeners();
  }

  // Custom fields: text fields keep a controller, choices a value or a set.
  final Map<String, TextEditingController> _text = {};
  final Map<String, String> _choice = {};
  final Map<String, Set<String>> _choices = {};

  TextEditingController textFor(String fieldId) => _text.putIfAbsent(fieldId, TextEditingController.new);
  String? choiceFor(String fieldId) => _choice[fieldId];
  Set<String> choicesFor(String fieldId) => _choices[fieldId] ?? const {};

  void setChoice(String fieldId, String? value) {
    if (value == null || value.isEmpty) {
      _choice.remove(fieldId);
    } else {
      _choice[fieldId] = value;
    }
    notifyListeners();
  }

  void toggleChoice(String fieldId, String value, bool selected) {
    final set = _choices.putIfAbsent(fieldId, () => <String>{});
    selected ? set.add(value) : set.remove(value);
    notifyListeners();
  }

  bool _usesText(FCThreadField f) => !f.isMultiple && !_isPicked(f);
  bool _isPicked(FCThreadField f) => f.type == 'select' || f.type == 'radio' || f.type == 'stars';

  String? _valueOf(FCThreadField f) {
    final v = _usesText(f) ? _text[f.id]?.text.trim() : _choice[f.id];
    return v == null || v.isEmpty ? null : v;
  }

  /// Field id to value (a list for several choices), as newTopic takes it.
  Map<String, dynamic> get customFields => {
        for (final f in options.threadFields)
          if (f.isMultiple && choicesFor(f.id).isNotEmpty)
            f.id: choicesFor(f.id).toList()
          else if (!f.isMultiple && _valueOf(f) != null)
            f.id: _valueOf(f),
      };

  // Tags
  final List<String> tags = [];
  final TextEditingController tagInput = TextEditingController();

  /// Adds the tags typed so far (separated by commas).
  void commitTags() {
    for (final part in tagInput.text.split(',')) {
      final tag = part.trim();
      if (tag.isNotEmpty && !tags.any((t) => t.toLowerCase() == tag.toLowerCase())) tags.add(tag);
    }
    tagInput.clear();
    notifyListeners();
  }

  void removeTag(String tag) {
    tags.remove(tag);
    notifyListeners();
  }

  // Poll
  final TextEditingController pollQuestion = TextEditingController();
  final List<TextEditingController> pollResponses = [TextEditingController(), TextEditingController()];
  bool pollMultiple = false;
  bool pollChangeVote = false;
  bool pollPublicVotes = false;
  bool pollViewResultsUnvoted = true;
  int pollCloseDays = 0;

  void update(VoidCallback change) {
    change();
    notifyListeners();
  }

  void addPollResponse() => update(() => pollResponses.add(TextEditingController()));

  void removePollResponse(int index) {
    if (pollResponses.length <= 2) return;
    final removed = pollResponses.removeAt(index);
    notifyListeners();
    WidgetsBinding.instance.addPostFrameCallback((_) => removed.dispose());
  }

  FCNewPoll? get poll => isPoll
      ? FCNewPoll(
          question: pollQuestion.text.trim(),
          responses: [for (final c in pollResponses) if (c.text.trim().isNotEmpty) c.text.trim()],
          maxVotes: pollMultiple ? 0 : 1,
          changeVote: pollChangeVote,
          publicVotes: pollPublicVotes,
          viewResultsUnvoted: pollViewResultsUnvoted,
          closeDays: pollCloseDays,
        )
      : null;

  /// The thread type to send: only when the forum offers types.
  String? get threadTypeToSend => options.threadTypes.isEmpty ? null : _threadType;

  /// What's missing before posting, as the website would say; null when
  /// nothing is. The forum checks it all again.
  String? validate(AppLocalizations l10n) {
    commitTags();
    for (final f in options.threadFields.where((f) => f.required)) {
      final missing = f.isMultiple ? choicesFor(f.id).isEmpty : _valueOf(f) == null;
      if (missing) return l10n.threadFieldRequired(f.title);
    }
    if (isPoll) {
      final p = poll!;
      if (p.question.isEmpty || p.responses.length < 2) return l10n.pollNeedsQuestionAndResponses;
    }
    if (options.canTag && tags.length < options.minTags) return l10n.addAtLeastTags(options.minTags);
    return null;
  }

  @override
  void dispose() {
    for (final c in [..._text.values, tagInput, pollQuestion, ...pollResponses]) {
      c.dispose();
    }
    super.dispose();
  }
}

/// The thread type, poll, custom fields and tags of a new thread.
class ThreadOptionsSection extends StatelessWidget {
  const ThreadOptionsSection({super.key, required this.controller});

  final ThreadOptionsController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final l10n = AppLocalizations.of(context);
        final o = controller.options;
        final children = <Widget>[
          if (o.threadTypes.length > 1) ...[
            _Label(l10n.threadTypeLabel),
            Wrap(
              spacing: DesignTokens.spacingS,
              children: [
                for (final t in o.threadTypes)
                  ChoiceChip(
                    label: Text(t.title),
                    selected: controller.threadType == t.type,
                    onSelected: (_) => controller.setThreadType(t.type),
                  ),
              ],
            ),
          ],
          if (controller.isPoll) _PollEditor(controller: controller),
          for (final f in o.threadFields) _FieldInput(field: f, controller: controller),
          if (o.canTag) _TagsInput(controller: controller),
        ];
        if (children.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final (i, child) in children.indexed) ...[
              if (i > 0) const SizedBox(height: DesignTokens.spacingM),
              child,
            ],
          ],
        );
      },
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: DesignTokens.spacingXS),
        child: Text(
          text,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      );
}

class _PollEditor extends StatelessWidget {
  const _PollEditor({required this.controller});
  final ThreadOptionsController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = controller;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: c.pollQuestion,
          decoration: InputDecoration(labelText: l10n.pollQuestion, border: const OutlineInputBorder()),
        ),
        const SizedBox(height: DesignTokens.spacingM),
        _Label(l10n.pollResponses),
        for (final (i, response) in c.pollResponses.indexed)
          Padding(
            padding: const EdgeInsets.only(bottom: DesignTokens.spacingS),
            child: TextField(
              controller: response,
              decoration: InputDecoration(
                hintText: l10n.pollResponseNumber(i + 1),
                border: const OutlineInputBorder(),
                isDense: true,
                suffixIcon: c.pollResponses.length > 2
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        tooltip: l10n.removePollResponse,
                        onPressed: () => c.removePollResponse(i),
                      )
                    : null,
              ),
            ),
          ),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton.icon(
            onPressed: c.addPollResponse,
            icon: const Icon(Icons.add),
            label: Text(l10n.addPollResponse),
          ),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: c.pollMultiple,
          title: Text(l10n.pollMultipleChoice),
          onChanged: (v) => c.update(() => c.pollMultiple = v),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: c.pollChangeVote,
          title: Text(l10n.pollChangeVote),
          onChanged: (v) => c.update(() => c.pollChangeVote = v),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: c.pollPublicVotes,
          title: Text(l10n.pollPublicVotes),
          onChanged: (v) => c.update(() => c.pollPublicVotes = v),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: c.pollViewResultsUnvoted,
          title: Text(l10n.pollViewResultsUnvoted),
          onChanged: (v) => c.update(() => c.pollViewResultsUnvoted = v),
        ),
        const SizedBox(height: DesignTokens.spacingS),
        DropdownButtonFormField<int>(
          initialValue: c.pollCloseDays,
          decoration: InputDecoration(labelText: l10n.pollCloseAfter, border: const OutlineInputBorder()),
          items: [
            DropdownMenuItem(value: 0, child: Text(l10n.pollNeverCloses)),
            for (final d in const [1, 3, 7, 14, 30]) DropdownMenuItem(value: d, child: Text(l10n.periodDays(d))),
          ],
          onChanged: (v) => c.update(() => c.pollCloseDays = v ?? 0),
        ),
      ],
    );
  }
}

class _FieldInput extends StatelessWidget {
  const _FieldInput({required this.field, required this.controller});
  final FCThreadField field;
  final ThreadOptionsController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final f = field;
    final label = f.required ? '${f.title} *' : f.title;
    final helper = f.description.isNotEmpty ? f.description : null;
    final decoration = InputDecoration(labelText: label, helperText: helper, helperMaxLines: 3, border: const OutlineInputBorder());

    if (f.isMultiple) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Label(label),
          if (helper != null) Text(helper, style: Theme.of(context).textTheme.bodySmall),
          Wrap(
            spacing: DesignTokens.spacingS,
            children: [
              for (final choice in f.choices)
                FilterChip(
                  label: Text(choice.title),
                  selected: controller.choicesFor(f.id).contains(choice.value),
                  onSelected: (on) => controller.toggleChoice(f.id, choice.value, on),
                ),
            ],
          ),
        ],
      );
    }

    if (f.type == 'select' || f.type == 'radio' || f.type == 'stars') {
      final choices = f.type == 'stars'
          ? [for (var s = 1; s <= 5; s++) FCFieldChoice(value: '$s', title: '★' * s)]
          : f.choices;
      return DropdownButtonFormField<String>(
        initialValue: controller.choiceFor(f.id),
        isExpanded: true,
        decoration: decoration,
        items: [
          if (!f.required) DropdownMenuItem<String>(value: '', child: Text(l10n.noneOption)),
          for (final c in choices) DropdownMenuItem<String>(value: c.value, child: Text(c.title)),
        ],
        onChanged: (v) => controller.setChoice(f.id, v),
      );
    }

    if (f.type == 'date') {
      final text = controller.textFor(f.id);
      return TextField(
        controller: text,
        readOnly: true,
        decoration: decoration.copyWith(suffixIcon: const Icon(Icons.calendar_today_outlined)),
        onTap: () async {
          final now = DateTime.now();
          final picked = await showDatePicker(
            context: context,
            initialDate: DateTime.tryParse(text.text) ?? now,
            firstDate: DateTime(1900),
            lastDate: DateTime(now.year + 50),
          );
          if (picked != null) {
            text.text = '${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
          }
        },
      );
    }

    final multiline = f.type == 'textarea' || f.type == 'bbcode';
    return TextField(
      controller: controller.textFor(f.id),
      minLines: multiline ? 3 : 1,
      maxLines: multiline ? 6 : 1,
      maxLength: f.maxLength > 0 ? f.maxLength : null,
      decoration: decoration,
    );
  }
}

class _TagsInput extends StatelessWidget {
  const _TagsInput({required this.controller});
  final ThreadOptionsController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = controller;
    final min = c.options.minTags;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: c.tagInput,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            labelText: min > 0 ? '${l10n.tagsLabel} *' : l10n.tagsLabel,
            helperText: min > 0 ? l10n.addAtLeastTags(min) : l10n.tagsHint,
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(icon: const Icon(Icons.add), tooltip: l10n.tagsLabel, onPressed: c.commitTags),
          ),
          onChanged: (text) {
            if (text.contains(',')) c.commitTags();
          },
          onSubmitted: (_) => c.commitTags(),
        ),
        if (c.tags.isNotEmpty) ...[
          const SizedBox(height: DesignTokens.spacingS),
          Wrap(
            spacing: DesignTokens.spacingS,
            runSpacing: DesignTokens.spacingXS,
            children: [
              for (final tag in c.tags)
                InputChip(
                  label: Text(tag),
                  onDeleted: () => c.removeTag(tag),
                ),
            ],
          ),
        ],
      ],
    );
  }
}
