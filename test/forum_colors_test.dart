import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forumcopilot_flutter/theme/app_theme.dart';
import 'package:forumcopilot_flutter/theme/forum_colors.dart';
import 'package:forumcopilot_sdk/models/entities/fc_forum_style.dart';

/// A forum is drawn in its own colours: the scheme from its accent, its
/// header from its header colours, each mode from its own scheme where it
/// has one.
void main() {
  // XenForo 2.3's default style: light and dark variations.
  const xf23 = FCForumStyle(
    light: FCStyleScheme(
      headerBackground: '#0f578a',
      headerText: '#a3d4f5',
      link: '#1474b8',
      button: '#47a7eb',
      logo: 'https://forum.example.com/styles/default/xenforo/xenforo-logo.svg',
      logoWidth: 100,
      logoHeight: 36,
    ),
    dark: FCStyleScheme(headerBackground: '#0a1c29', headerText: '#5ca5d6', link: '#5ca5d6', button: '#2970a3'),
  );

  test('no style: the app\'s own colours and no forum header', () {
    final theme = AppTheme.themeFor(Brightness.light);
    expect(theme.extension<ForumColors>(), isNull);
  });

  test("the forum's link colour is the primary colour where it reads", () {
    final theme = AppTheme.themeFor(Brightness.light, xf23);
    expect(theme.colorScheme.primary, const Color(0xFF1474B8));
    expect(contrastRatio(theme.colorScheme.onPrimary, theme.colorScheme.primary), greaterThanOrEqualTo(4.5));
    final forum = theme.extension<ForumColors>()!;
    expect(forum.headerBackground, const Color(0xFF0F578A));
    expect(forum.headerForeground, const Color(0xFFA3D4F5));
    expect(forum.line, const Color(0xFF47A7EB));
    expect(forum.logo, endsWith('.svg'));
    expect(forum.logoAspectRatio, closeTo(100 / 36, 1e-9));
  });

  test('dark mode uses the dark variation', () {
    final forum = AppTheme.themeFor(Brightness.dark, xf23).extension<ForumColors>()!;
    expect(forum.headerBackground, const Color(0xFF0A1C29));
    // No logo was given for the dark header.
    expect(forum.logo, isNull);
  });

  test('a pale accent is darkened until it reads on the page, keeping its hue', () {
    const pale = FCForumStyle(light: FCStyleScheme(link: '#9fd8ff'));
    final scheme = AppTheme.themeFor(Brightness.light, pale).colorScheme;
    expect(contrastRatio(scheme.primary, scheme.surface), greaterThanOrEqualTo(4.5));
    expect(scheme.primary, isNot(const Color(0xFF9FD8FF)));
    expect(HSVColor.fromColor(scheme.primary).hue, closeTo(HSVColor.fromColor(const Color(0xFF9FD8FF)).hue, 12));
  });

  group('a forum with only a light scheme (XenForo 2.2) in dark mode', () {
    test('a dark brand header is kept, with its logo', () {
      const xf22 = FCForumStyle(
        light: FCStyleScheme(
          headerBackground: '#185886',
          headerText: '#bcdef5',
          link: '#2577b1',
          logo: 'https://forum.example.com/styles/default/xenforo/xenforo-logo.png',
        ),
      );
      final theme = AppTheme.themeFor(Brightness.dark, xf22);
      final forum = theme.extension<ForumColors>()!;
      expect(forum.headerBackground, const Color(0xFF185886));
      expect(forum.logo, isNotNull);
      expect(contrastRatio(theme.colorScheme.primary, theme.colorScheme.surface), greaterThanOrEqualTo(4.5));
    });

    test('a white header is not: the page colours, and no logo drawn for white', () {
      const white = FCForumStyle(
        light: FCStyleScheme(headerBackground: '#ffffff', headerText: '#222222', link: '#0088cc', logo: 'https://x/logo.png'),
      );
      final theme = AppTheme.themeFor(Brightness.dark, white);
      final forum = theme.extension<ForumColors>()!;
      expect(forum.headerBackground, theme.colorScheme.surface);
      expect(forum.logo, isNull);
      expect(contrastRatio(forum.headerForeground, forum.headerBackground), greaterThanOrEqualTo(4.5));
    });
  });

  test('header text that does not read on the header is replaced', () {
    const clash = FCForumStyle(light: FCStyleScheme(headerBackground: '#1a1a1a', headerText: '#222222', link: '#0088cc'));
    final forum = AppTheme.themeFor(Brightness.light, clash).extension<ForumColors>()!;
    expect(forum.headerForeground, Colors.white);
  });

  test('a style without an accent leaves the app colours', () {
    const none = FCForumStyle(light: FCStyleScheme(headerBackground: '#123456'));
    expect(AppTheme.themeFor(Brightness.light, none).extension<ForumColors>(), isNull);
  });

  testWidgets('a Home replaced by another of the same forum keeps its colours', (tester) async {
    const style = FCForumStyle(light: FCStyleScheme(link: '#1474b8'));
    await tester.pumpWidget(const SizedBox());
    AppTheme.showForumStyle('https://a.example/forumcopilot.php', style);
    AppTheme.forumHomeOpened('https://a.example/forumcopilot.php');
    // Signing in replaces Home: the new one opens, the old one closes.
    AppTheme.forumHomeOpened('https://a.example/forumcopilot.php');
    AppTheme.forumHomeClosed('https://a.example/forumcopilot.php');
    tester.binding.scheduleFrame();
    await tester.pump();
    expect(AppTheme.forumStyle.value, style);

    // The last one closes: the app's own colours.
    AppTheme.forumHomeClosed('https://a.example/forumcopilot.php');
    tester.binding.scheduleFrame();
    await tester.pump();
    expect(AppTheme.forumStyle.value, isNull);

    // Opening it again brings its colours back without reloading its config.
    AppTheme.forumHomeOpened('https://a.example/forumcopilot.php');
    expect(AppTheme.forumStyle.value, style);
    AppTheme.forumHomeClosed('https://a.example/forumcopilot.php');
    await tester.pump();
  });
}
