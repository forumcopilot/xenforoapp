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

Output is two lines:

```
PERF topic_list frames=1183 build p50=6.9 p90=14.9 p99=24.1 max=89 | raster p50=6.0 ... | total>16.7ms=366 total>33ms=16 build>16.7ms=54 raster>16.7ms=1
PERF thread     frames=965  build p50=0.8 p90=2.3  p99=30.2 max=83 | raster p50=4.6 ... | total>16.7ms=20  total>33ms=11 build>16.7ms=15 raster>16.7ms=0
```

**Run the baseline twice before changing anything.** On the Discourse app two
runs agreed within ~0.2 ms on p50 and ~10 % on jank counts — that spread is
your noise floor, and it tells you what size of change is real.

## The forum it measures — read this first

This app is **single-forum**: the forum is baked in at build time by
`lib/config/app_forum_config.dart`. There is no "open a forum by address"
step, which removes most of the flakiness the Discourse harness had.

The flip side: unlike Discourse (whose public API any instance exposes), this
app talks through the **ForumCopilot add-on endpoint**, so it can only measure
a forum that has the add-on installed. The currently configured forum,
`qhhtofficialforum.com`, **answers guests with HTTP 403** — a guest run will
render no rows and the harness will fail fast with the on-screen text so you
can see why.

Two ways to get a measurable run:

1. **Supply a throwaway account at run time** (nothing is stored in the repo):

   ```bash
   flutter drive --profile -d <device-id> \
     --driver=test_driver/perf_driver.dart \
     --target=integration_test/scroll_perf_test.dart \
     --dart-define=PERF_USER=<user> --dart-define=PERF_PASS=<pass>
   ```

   The harness signs in through `LoginController.handleLogin` rather than
   typing into the login form (form typing through the harness is unreliable
   on a device) and prints `PERF signin ok=true`.

2. **Point `AppForumConfig` at a forum that allows guest reading** and has the
   add-on installed. Whichever you pick, keep it fixed — numbers are only
   comparable against the same forum, same phone, same gestures.

Pick a forum with **long threads**; the `thread` numbers are the ones that
expose per-post work.

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
- The thread section opens whatever is **second in the list at run time**, so
  its p99 is only comparable between runs made close together. The topic-list
  numbers are the stable ones.

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
is configured, and the thread tap targets the second row by finder rather than
by screen coordinates. Labels `topic_list` and `thread` are kept so results
line up with the Discourse audit tables.
