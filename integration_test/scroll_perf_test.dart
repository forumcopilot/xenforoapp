// Scroll-performance harness for the XenForo app.
//
// Run (phone connected, developer mode, listed by `adb devices`):
//
//   flutter drive --profile -d <device-id> \
//     --driver=test_driver/perf_driver.dart \
//     --target=integration_test/scroll_perf_test.dart > /tmp/drive.log 2>&1
//   grep PERF /tmp/drive.log
//
// Prints one summary line per screen so before/after runs line up with the
// Discourse audit tables:
//
//   PERF topic_list frames=1183 build p50=6.9 p90=14.9 ... | raster ... | total>16.7ms=366 ...
//   PERF thread     frames=965  build p50=0.8 ...
//
// Differences from the Discourse harness this was ported from:
//
//  * This app is SINGLE-FORUM — the forum is baked in at build time by
//    AppForumConfig — so there is no "open a forum by address" step and none
//    of the flakiness that came with it.
//  * Screens are detected by widget type (TopicListItem / PostListItem) rather
//    than by on-screen text, so the harness does not depend on locale or on
//    which forum is configured.
//  * If the configured forum requires a login to read anything (the default
//    qhhtofficialforum.com answers guests with HTTP 403), pass a throwaway
//    account at run time. Nothing is stored in the repo:
//
//      --dart-define=PERF_USER=<user> --dart-define=PERF_PASS=<pass>
//
// See docs/perf-benchmarking.md for the traps — especially the stale Gradle
// kernel, which silently makes a run measure the previous build.

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:integration_test/integration_test.dart';

import 'package:forumcopilot_flutter/controllers/login_controller.dart';
import 'package:forumcopilot_flutter/controllers/site_controller.dart';
import 'package:forumcopilot_flutter/main.dart' as app;
import 'package:forumcopilot_flutter/views/listitems/post_list_item.dart';
import 'package:forumcopilot_flutter/views/listitems/topic_list_item.dart';

const String _perfUser = String.fromEnvironment('PERF_USER');
const String _perfPass = String.fromEnvironment('PERF_PASS');

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  testWidgets('topic list and thread scrolling', (tester) async {
    // main() is `void async`: it cannot be awaited. Start it and pump until
    // the first screen exists.
    app.main();
    await tester.pump(const Duration(seconds: 3));

    if (_perfUser.isNotEmpty && _perfPass.isNotEmpty) {
      await _signIn(tester);
    }

    // Rows on screen == the list actually rendered.
    await _pumpUntil(tester, find.byType(TopicListItem),
        timeout: const Duration(seconds: 120));
    await tester.pump(const Duration(seconds: 2));

    await _measure('topic_list', () => _flings(tester, 8));

    // Back to the top, then open the second topic.
    for (var i = 0; i < 2; i++) {
      await tester.fling(
          find.byType(Scrollable).first, const Offset(0, 4000), 8000);
      await _settle(tester, frames: 60);
    }
    await tester.tap(find.byType(TopicListItem).at(1), warnIfMissed: false);
    await tester.pump(const Duration(seconds: 4));

    // Prove a thread actually opened before attributing frames to it.
    await _pumpUntil(tester, find.byType(PostListItem),
        timeout: const Duration(seconds: 90));
    await _settle(tester, frames: 30);

    await _measure('thread', () => _flings(tester, 8));
  });
}

/// Signs in through the app's own controller rather than the login form —
/// typing into a form through the harness is unreliable on a device. The
/// credentials come from --dart-define at run time and are never committed.
Future<void> _signIn(WidgetTester tester) async {
  final deadline = DateTime.now().add(const Duration(seconds: 90));
  dynamic siteContext;
  while (DateTime.now().isBefore(deadline)) {
    await tester.pump(const Duration(milliseconds: 200));
    if (Get.isRegistered<SiteController>()) {
      siteContext = Get.find<SiteController>().currentSiteContext.value;
      if (siteContext != null) break;
    }
  }
  if (siteContext == null) {
    throw TestFailure(
        'No SiteContext after 90s — the forum never initialised, so sign-in '
        'cannot run. Check the device has network and AppForumConfig is valid.');
  }

  final login = Get.isRegistered<LoginController>()
      ? Get.find<LoginController>()
      : Get.put(LoginController());
  final ok = await login.handleLogin(
    siteContext: siteContext,
    username: _perfUser,
    password: _perfPass,
    showLoader: false,
  );
  // ignore: avoid_print
  print('PERF signin ok=$ok');
  await _settle(tester, frames: 90);
}

/// Collects [FrameTiming] for every frame produced while [action] runs and
/// prints one summary line that `flutter drive` echoes to the console.
Future<void> _measure(String label, Future<void> Function() action) async {
  final frames = <FrameTiming>[];
  void collect(List<FrameTiming> t) => frames.addAll(t);
  SchedulerBinding.instance.addTimingsCallback(collect);
  await action();
  await Future<void>.delayed(const Duration(milliseconds: 500));
  SchedulerBinding.instance.removeTimingsCallback(collect);

  List<double> ms(Duration Function(FrameTiming) f) =>
      frames.map((t) => f(t).inMicroseconds / 1000).toList()..sort();
  double pct(List<double> v, double q) =>
      v.isEmpty ? 0 : v[((v.length - 1) * q).round()];
  final build = ms((t) => t.buildDuration);
  final raster = ms((t) => t.rasterDuration);
  final total = ms((t) => t.totalSpan);
  int over(List<double> v, double b) => v.where((x) => x > b).length;
  // ignore: avoid_print
  print('PERF $label frames=${frames.length} '
      'build p50=${pct(build, .5).toStringAsFixed(1)} p90=${pct(build, .9).toStringAsFixed(1)} '
      'p99=${pct(build, .99).toStringAsFixed(1)} max=${build.isEmpty ? 0 : build.last.toStringAsFixed(0)} '
      '| raster p50=${pct(raster, .5).toStringAsFixed(1)} p90=${pct(raster, .9).toStringAsFixed(1)} '
      'p99=${pct(raster, .99).toStringAsFixed(1)} max=${raster.isEmpty ? 0 : raster.last.toStringAsFixed(0)} '
      '| total>16.7ms=${over(total, 16.7)} total>33ms=${over(total, 33)} '
      'build>16.7ms=${over(build, 16.7)} raster>16.7ms=${over(raster, 16.7)}');
}

Future<void> _flings(WidgetTester tester, int count) async {
  for (var i = 0; i < count; i++) {
    await tester.flingFrom(const Offset(200, 760), const Offset(0, -520), 3000);
    await _settle(tester, frames: 75);
  }
}

/// pumpAndSettle never settles while a spinner or shimmer animates; pump a
/// fixed number of frames instead.
Future<void> _settle(WidgetTester tester, {required int frames}) async {
  for (var i = 0; i < frames; i++) {
    await tester.pump(const Duration(milliseconds: 16));
  }
}

Future<void> _pumpUntil(WidgetTester tester, Finder finder,
    {Duration timeout = const Duration(seconds: 30)}) async {
  final end = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 200));
    if (finder.evaluate().isNotEmpty) return;
  }
  final texts = find
      .byType(Text)
      .evaluate()
      .map((e) => (e.widget as Text).data)
      .whereType<String>()
      .take(30)
      .toList();
  throw TestFailure('Timed out waiting for $finder; on screen: $texts');
}
