import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forumcopilot_flutter/l10n/generated/app_localizations.dart';
import 'package:forumcopilot_flutter/views/widgets/reaction_picker.dart';
import 'package:forumcopilot_sdk/models/entities/fc_reaction.dart';

/// Covers the label on the reaction summary row under posts and direct
/// messages, which used to read "1 Likes", and said "Likes" for every
/// reaction type.
void main() {
  final registry = ReactionRegistry.instance;
  tearDown(registry.clear);

  Future<List<String>> labels(
      WidgetTester tester, Locale locale, List<int> counts) async {
    late List<String> result;
    await tester.pumpWidget(MaterialApp(
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Builder(builder: (context) {
        result = [for (final n in counts) reactionCountLabel(context, n)];
        return const SizedBox();
      }),
    ));
    return result;
  }

  testWidgets('single-Like forum: singular and plural Likes', (tester) async {
    registry.clear();
    expect(await labels(tester, const Locale('en'), [1, 2, 11]),
        ['1 like', '2 likes', '11 likes']);
  });

  testWidgets('forum with a reaction set: Reactions', (tester) async {
    registry.setFromJsonList([
      {'id': 1, 'title': 'Like', 'emoji': '👍', 'imageUrl': '', 'displayOrder': 1},
      {'id': 4, 'title': 'Wow', 'emoji': '😮', 'imageUrl': '', 'displayOrder': 2},
    ]);
    expect(await labels(tester, const Locale('en'), [1, 3]),
        ['1 reaction', '3 reactions']);
  });

  testWidgets('Russian uses its one/few/many forms', (tester) async {
    registry.clear();
    expect(await labels(tester, const Locale('ru'), [1, 3, 5, 21]),
        ['1 лайк', '3 лайка', '5 лайков', '21 лайк']);
  });
}
