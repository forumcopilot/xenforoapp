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
//   PERF topic_list  frames=1183 build p50=6.9 p90=14.9 ... | raster ... | total>16.7ms=366 ...
//   PERF thread      frames=965  build p50=0.8 ...
//   PERF thread_back frames=...  (the same posts, scrolled back up through)
//   PERF thread_rebuild frames=... (visible posts republished in place)
//
// Differences from the Discourse harness this was ported from:
//
//  * This app is SINGLE-FORUM — the forum is baked in at build time by
//    AppForumConfig — so there is no "open a forum by address" step and none
//    of the flakiness that came with it.
//  * Screens are detected by widget type (TopicListItem / PostListItem) rather
//    than by on-screen text, so the harness does not depend on locale.
//  * The two comparable screens open PINNED content (see below) rather than
//    whatever the "latest" feed happens to hold, because the feed churns
//    between runs. A third line, `home_feed`, measures the app's landing tab,
//    which cannot be pinned — see the caveat on it below.
//  * If the configured forum requires a login to read anything, pass a
//    throwaway account at run time. Nothing is stored in the repo:
//
//      --dart-define=PERF_USER=<user> --dart-define=PERF_PASS=<pass>
//
// See docs/perf-benchmarking.md for the traps — especially the stale Gradle
// kernel, which silently makes a run measure the previous build.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:integration_test/integration_test.dart';

import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart' show globalNavigatorKey;
import 'package:forumcopilot_sdk/models/entities/fc_forum.dart';

import 'package:forumcopilot_flutter/controllers/login_controller.dart';
import 'package:forumcopilot_flutter/controllers/post_controller.dart';
import 'package:forumcopilot_flutter/controllers/site_controller.dart';
import 'package:forumcopilot_flutter/main.dart' as app;
import 'package:forumcopilot_flutter/views/forum_topics_page.dart';
import 'package:forumcopilot_flutter/views/listitems/post_list_item.dart';
import 'package:forumcopilot_flutter/views/listitems/topic_list_item.dart';
import 'package:forumcopilot_flutter/views/post_page.dart';

// ---------------------------------------------------------------------------
// Pinned benchmark content
// ---------------------------------------------------------------------------
//
// Both measured screens open FIXED content. This is the difference between a
// harness you can trust and one you cannot: the first version of this file
// measured the "latest" feed and tapped whatever sat in row 2, and two runs of
// IDENTICAL code disagreed by 7.0 vs 3.0 ms raster p50 and 139 vs 850 janky
// frames — purely because the feed had turned over between runs. Read as a
// before/after that would have looked like an 84 % improvement from no change
// at all.
//
// Both targets live under SatelliteGuys Archives, which is READ-ONLY
// (`canPost=false, canReply=false` from the add-on's getForum). Nothing can be
// posted, so the rows and the posts are byte-identical on every run — the only
// thing left varying is the code under test.
//
// Chosen for content, not just stability: 18/20 rows carry an avatar and a
// snippet; the thread averages ~700-char posts with quotes throughout and an
// avatar on nearly every post, which is what actually exercises the BBCode
// parse and image-decode paths the audit is about.
//
// CHANGING EITHER CONSTANT INVALIDATES EVERY EARLIER NUMBER. Re-baseline.
//
// The third line, `home_feed`, is the app's landing tab, and it is measured
// LAST and on purpose despite being unpinnable. Pinning is not available to it
// — its content is the site-wide "latest" feed — but it must not be dropped,
// because it is a DIFFERENT and far more expensive code path than the forum
// node above: topic_list_tab.dart puts every loaded row in one
// `Column(children: topicItems)` inside a `ListView(children:)`, so nothing is
// virtualised and every row builds on every frame, while forum_topic_list.dart
// spreads its rows as ListView children and stays lazy. Measured back to back
// on the same build that is build p50 = 7.8 ms (home) vs 0.9 ms (forum node).
//
// Treat `home_feed` as INDICATIVE ONLY, never as a regression gate: its rows
// and its pagination depth both change between runs. It is here so that a
// 10x structural fix to that tab has a number attached to it. It runs last so
// its noise cannot contaminate the two pinned measurements.

/// Node 42 — "Video Game Reviews & Discussions" (SatelliteGuys Archives).
/// 2,194 threads, guest-readable, read-only since 2024-04-03.
const String _perfForumId = '42';
const String _perfForumName = 'Video Game Reviews & Discussions';

/// Thread 203226 — "Where are my Satellite Guy's gamers at?", 1,700 posts.
/// Deep enough that eight flings never reach the end, so pagination is
/// measured too.
const String _perfTopicId = '203226';
const String _perfTopicTitle = "Where are my Satellite Guy's gamers at?";

const String _perfUser = String.fromEnvironment('PERF_USER');
const String _perfPass = String.fromEnvironment('PERF_PASS');

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  testWidgets('topic list and thread scrolling', (tester) async {
    // main() is `void async`: it cannot be awaited. Start it and pump until
    // the app has a SiteContext, which is what both screens need.
    app.main();
    await tester.pump(const Duration(seconds: 3));

    _stage('booted');
    final siteContext = await _awaitSiteContext(tester);
    _stage('siteContext');

    if (_perfUser.isNotEmpty && _perfPass.isNotEmpty) {
      await _signIn(tester, siteContext);
    }

    // --- topic list: a fixed forum node, not the churning "latest" feed ---
    await _push(
      tester,
      ForumTopicsPage(
        siteContext: siteContext,
        forum: FCForum(id: _perfForumId, name: _perfForumName),
      ),
    );

    // Rows on screen == the list actually rendered.
    _stage('pushed forum');
    await _pumpUntil(tester, find.byType(TopicListItem),
        timeout: const Duration(seconds: 120));
    _stage('rows visible');
    await tester.pump(const Duration(seconds: 2));

    await _measure('topic_list', () => _flings(tester, 8));
    _stage('topic_list measured');

    // --- thread: a fixed long thread, not whatever sat in row 2 ---
    globalNavigatorKey.currentState!.pop();
    await _settle(tester, frames: 30);

    await _push(
      tester,
      PostPage(
        siteContext: siteContext,
        topicId: _perfTopicId,
        title: _perfTopicTitle,
      ),
    );

    // Prove a thread actually opened before attributing frames to it.
    _stage('pushed thread');
    await _pumpUntil(tester, find.byType(PostListItem),
        timeout: const Duration(seconds: 90));
    _stage('posts visible');
    await _settle(tester, frames: 30);

    await _measure('thread', () => _flings(tester, 8));
    _stage('thread measured');

    // --- thread_back: the same posts re-entering the viewport ---
    // Flinging forward only ever meets fresh posts, so it cannot see any
    // work that depends on a post being seen twice: an element that is
    // disposed on the way down and recreated on the way up, or a rebuild of
    // a post already on screen. Eight flings back up through the posts the
    // previous segment just loaded measures exactly that, on pinned content.
    await _measure('thread_back', () => _flings(tester, 8, up: true));
    _stage('thread_back measured');

    // --- thread_rebuild: the visible posts rebuilt in place, no scrolling ---
    // Neither scroll segment rebuilds a post that is already on screen (F2
    // saw to that), yet the app does it constantly: every page load, like,
    // poll vote or translation publishes threadDataOutput and the list's Obx
    // rebuilds every visible post. Publishing the same data again is that
    // exact trigger with nothing else changing, so this isolates the cost of
    // one rebuild per visible post -- which is where per-post derivation,
    // when it is not cached, gets paid again and again.
    final controller = tester
        .widget<PostListItem>(find.byType(PostListItem).first)
        .postController;
    await _measure('thread_rebuild', () => _republish(tester, controller, 30));
    _stage('thread_rebuild measured');

    // --- home feed: unpinnable, measured last, indicative only ---
    globalNavigatorKey.currentState!.pop();
    await _pumpUntil(tester, find.byType(TopicListItem),
        timeout: const Duration(seconds: 120));
    await tester.pump(const Duration(seconds: 2));
    _stage('home visible');

    await _measure('home_feed', () => _flings(tester, 8));
  });
}

// ignore: avoid_print
void _stage(String s) => print('PERFSTAGE $s ${DateTime.now().toIso8601String()}');

/// Pushes [page] on the app's own navigator. The returned route future only
/// completes when the route is popped, so it is deliberately not awaited.
Future<void> _push(WidgetTester tester, Widget page) async {
  final navigator = globalNavigatorKey.currentState;
  if (navigator == null) {
    throw TestFailure('No navigator — the app never built its MaterialApp.');
  }
  unawaited(navigator.push(MaterialPageRoute<void>(builder: (_) => page)));
  await _settle(tester, frames: 60);
}

/// Blocks until the app has initialised its forum. Both measured screens take
/// a [SiteContext], and sign-in needs one too.
Future<SiteContext> _awaitSiteContext(WidgetTester tester) async {
  final deadline = DateTime.now().add(const Duration(seconds: 90));
  while (DateTime.now().isBefore(deadline)) {
    await tester.pump(const Duration(milliseconds: 200));
    if (Get.isRegistered<SiteController>()) {
      final ctx = Get.find<SiteController>().currentSiteContext.value;
      if (ctx != null) return ctx;
    }
  }
  throw TestFailure(
      'No SiteContext after 90s — the forum never initialised. Check the '
      'device has network and AppForumConfig is valid.');
}

/// Signs in through the app's own controller rather than the login form —
/// typing into a form through the harness is unreliable on a device. The
/// credentials come from --dart-define at run time and are never committed.
Future<void> _signIn(WidgetTester tester, SiteContext siteContext) async {
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

/// Publishes the thread's current data [count] times without changing it,
/// settling a few frames after each so every visible post rebuilds and
/// paints before the next publish.
Future<void> _republish(
    WidgetTester tester, PostController controller, int count) async {
  for (var i = 0; i < count; i++) {
    controller.threadDataOutput.refresh();
    await _settle(tester, frames: 10);
  }
}

/// [up] reverses the gesture: same distance and velocity, started high on the
/// screen so the drag has room, so a down/up pair covers the same posts.
Future<void> _flings(WidgetTester tester, int count, {bool up = false}) async {
  final start = up ? const Offset(200, 400) : const Offset(200, 760);
  final delta = up ? const Offset(0, 520) : const Offset(0, -520);
  for (var i = 0; i < count; i++) {
    await tester.flingFrom(start, delta, 3000);
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
