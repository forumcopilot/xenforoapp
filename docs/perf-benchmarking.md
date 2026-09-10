# Measuring scroll performance on a device

Repeatable before/after numbers for the two screens that matter: the topic
list and a thread. Ported from the Discourse app's harness; the traps section
is the part that saves the most time.

## Run it

Phone connected, developer mode on, listed by `adb devices`.

```bash
flutter drive --profile -d <device-id> \
  --driver=test_driver/perf_driver.dart \
  --target=integration_test/scroll_perf_test.dart > /tmp/drive.log 2>&1
grep PERF /tmp/drive.log
```

~3 minutes per run (profile build, install, test, uninstall). Keep the whole
log — it also holds the app's own debug output, which is useful for counting
side effects a frame timer cannot see.

Output is three lines:

```
PERF topic_list frames=1082 build p50=0.9 p90=3.2 p99=11.5 max=13 | raster p50=4.2 ... | total>16.7ms=25 total>33ms=2 build>16.7ms=0  raster>16.7ms=2
PERF thread     frames=1275 build p50=2.0 p90=4.3 p99=27.4 max=44 | raster p50=5.0 ... | total>16.7ms=57 total>33ms=21 build>16.7ms=40 raster>16.7ms=1
PERF home_feed  frames=1388 build p50=7.8 p90=11.4 p99=17.4 max=30 | raster p50=3.0 ... | total>16.7ms=139 total>33ms=4 build>16.7ms=20 raster>16.7ms=1
```

`topic_list` and `thread` are the comparable ones. `home_feed` is indicative
only — see below.

**Run the baseline three times before changing anything, and check the spread.**
The target is the Discourse harness's noise floor: within ~0.2 ms on p50 and
~10 % on jank counts. That spread is what tells you which later differences are
real. If three baselines do not agree that closely, something is still varying —
fix that before touching `lib/`, not after.

## What it measures — read this first

This app is **single-forum**: the forum is baked in at build time by
`lib/config/app_forum_config.dart`. There is no "open a forum by address"
step, which removes most of the flakiness the Discourse harness had.

The flip side: unlike Discourse (whose public API any instance exposes), this
app talks through the **ForumCopilot add-on endpoint**, so it can only measure
a forum that has the add-on installed.

It is currently pointed at **SatelliteGuys.US** (`https://www.satelliteguys.us/xen`),
which runs the add-on and lets guests read — so runs need no credentials. The
app's own forum, `qhhtofficialforum.com`, answers guests with HTTP 403; if you
point the config back at it, supply a throwaway account at run time (nothing is
stored in the repo):

```bash
flutter drive --profile -d <device-id> \
  --driver=test_driver/perf_driver.dart \
  --target=integration_test/scroll_perf_test.dart \
  --dart-define=PERF_USER=<user> --dart-define=PERF_PASS=<pass>
```

The harness signs in through `LoginController.handleLogin` rather than typing
into the login form (form typing through the harness is unreliable on a device)
and prints `PERF signin ok=true`.

### Both screens open pinned content

`integration_test/scroll_perf_test.dart` pushes **fixed** content on the app's
own navigator instead of using whatever is on screen:

| Half | Target | Why |
|---|---|---|
| `topic_list` | node **42**, "Video Game Reviews & Discussions" | 2,194 threads; 18/20 rows have an avatar and a snippet |
| `thread` | topic **203226**, "Where are my Satellite Guy's gamers at?" | 1,700 posts, ~700-char average with quotes throughout, avatar on nearly every post |

Pagination is deterministic as a result: the node loads `startNum` 0/21/42/63/84
and the thread loads posts 1/21/41 on every run.

Both sit under **SatelliteGuys Archives**, which is read-only — the add-on
reports `canPost=false, canReply=false`, so nobody can post and the bytes the
app receives are identical on every run.

This is not a detail. The first version of this harness measured the "latest"
feed and tapped whatever sat in row 2. Two runs of **identical code** gave:

```
run 1  topic_list  build p50=7.8  raster p50=3.0  total>16.7ms=139
run 2  topic_list  build p50=9.9  raster p50=7.0  total>16.7ms=850
```

Thermals were ruled out (all sensors `mStatus=0`, 735 %/800 % CPU idle, skin
23–28 °C). The feed had simply turned over between runs. Reported as a
before/after, run 2 → run 1 would read as an 84 % reduction in jank from a
change that did nothing.

**Changing either constant invalidates every earlier number.** Re-baseline.

### `home_feed` is the exception, and it is deliberate

The third line measures the app's landing tab, which **cannot** be pinned — its
content is the site-wide "latest" feed. It is kept anyway, and measured last,
because it is a different and far more expensive code path than the forum node:

- `lib/views/tabs/topic_list_tab.dart:53` puts every loaded row into one
  `Column(children: topicItems)` inside a `ListView(children:)`. Nothing is
  virtualised; every loaded row builds on every frame, and it gets worse as you
  paginate.
- `lib/views/lists/forum_topic_list.dart:359` spreads its rows as `ListView`
  children, so the sliver only builds what is near the viewport.

Back to back on the same build that is **build p50 = 7.8 ms (home) vs 0.9 ms
(forum node)**. Dropping the home tab from the harness would mean the audit's
largest single structural finding had no number attached to it.

**Never gate a regression on `home_feed`.** Its rows and its pagination depth
both change between runs. Use it only where the effect is an order of magnitude
and dwarfs the noise. It runs last so that its noise cannot contaminate the two
pinned measurements.

## Reading the numbers

- **Budget.** 16.7 ms per frame at 60 Hz, 8.3 ms at 120 Hz. Build and raster
  run on different threads, so each must fit on its own. The counts over
  16.7 ms and 33 ms are one and two dropped frames — what people actually feel.
- **build p50 high** → the tree does too much every frame: non-virtualized
  lists, parsing in `build()`, rebuild storms.
- **build p50 low but p99 high** → occasional expensive items entering the
  viewport: a post's BBCode parse, a batch of image decodes.
- **raster high** → GPU-side layers: `Opacity`, antialiased clips,
  `ShaderMask`, `ColorFiltered`, `BackdropFilter`, shadows.
- Both sections open pinned, frozen content, so both are comparable across
  runs — including the p99s, which is where per-item cost (a BBCode parse, a
  batch of image decodes) shows up.

## Counting side effects from the log

```bash
grep -c 'Attempting to download' /tmp/drive.log   # image cache misses
grep -c 'Failed to decode image'  /tmp/drive.log   # decoder rejections
grep -c 'Invalid image data'      /tmp/drive.log   # file -> network fallbacks
```

On the Discourse app this went 598 / 10 / 88 → 94 / 1 / 0 after the avatar
fixes; that finding came entirely from the log, not the frame timer.

## Traps

1. **Gradle can ship a stale Dart kernel.** After editing a path-dependency
   package, a fresh APK can still contain the *old* kernel — the symptom is
   numbers identical to the previous run. Before every measured build:
   ```bash
   rm -rf .dart_tool/flutter_build build/app/intermediates/flutter
   ```
   This repo's UI is in-repo, so it bites less often than it did on the
   Discourse module — but do it whenever you touch `packages/`.
2. **Android's frame stats do not see Flutter.** `dumpsys gfxinfo` reports
   zero frames and SurfaceFlinger returns no rows for the Flutter surface.
   That is why timings are collected in-process via `addTimingsCallback`.
3. **`traceAction` / `reportData` → `TimelineSummary` does not work here**
   ("no response data"). Printing the summary from inside the test does, and
   needs no driver code.
4. **`pumpAndSettle` never settles** while a spinner or shimmer animates — and
   this app has both. Pump a fixed number of frames (`_settle`).
5. **`app.main()` is `void async`** and cannot be awaited; start it and pump.
6. **`flutter drive` uninstalls the app when it finishes.** Reinstall before
   poking at the device by hand.
7. **Never benchmark on an emulator.** The numbers mean nothing.

## Notes on this port

Screens are detected by **widget type** (`TopicListItem`, `PostListItem`) not
by on-screen text, so the harness is independent of locale and of which forum
is configured. Navigation is by direct `Navigator.push` on `globalNavigatorKey`
rather than by tapping rows, which is both faster and what makes the pinned
targets possible. Labels `topic_list` and `thread` are kept so results line up
with the Discourse audit tables.
