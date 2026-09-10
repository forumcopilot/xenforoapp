# Scroll performance audit — XenForo app (2026-09-09)

The sibling Discourse app (github.com/forumcopilot/discourse-app) was
audited and fixed this week: topic-list build time went from a median of
6.9 ms to 0.8 ms and jank from 31 % of frames to 3 % on a Pixel 10a. The
XenForo app shares the same code lineage and has the same problems, several
of them in a worse form. This document maps each finding onto this repo,
with the fix and a pointer to the Discourse commit that shows it done.

Reference commits in discourse-app (all on `main`, tags v1.0.6–v1.0.9):

| tag | what | commit |
|---|---|---|
| v1.0.7 | parse once, no list-wide rebuilds, avatars at size | `181d5fe` |
| v1.0.8 | virtualized feed, Offstage holders, allocation hygiene, parse warm-up | `3d042a3`, `3e46a64`, `92c63ab` |
| v1.0.9 | lighter rows and posts | `7ca5c68` |
| — | audit with before/after numbers | `docs/perf-audit-2026-09.md` |

Line numbers below are as of branch `fix/duplicate-posts-pagination`
(HEAD `9ec3a8b`).

## Measure first

Full method, sources, pitfalls and how to do before/after:
`docs/perf-benchmarking.md` in the discourse-app repo.

Write a `flutter drive --profile` integration test that opens a public
XenForo forum with long threads, flings the topic list and a thread eight
times each, and prints `FrameTiming` percentiles. The Discourse version is
in the ABDA repo, `integration_test/scroll_perf_test.dart` +
`test_driver/perf_driver.dart`, and ports in an hour. Two traps:

- Android `gfxinfo` and SurfaceFlinger latency do not see Flutter frames;
  collect `SchedulerBinding.addTimingsCallback` inside the test and print.
- After editing a path-dependency package, `rm -rf .dart_tool/flutter_build
  build/app/intermediates/flutter` before building, or Gradle ships the old
  kernel in a fresh APK and the benchmark measures nothing.

## Phase 1 — largest win, lowest risk

### 1. Post content is processed five-plus times per post, per build, uncached

`lib/views/listitems/post_list_item.dart:709` calls
`_extractPostContentData()` (`:194-296`) from `build()`. That runs
`BBCodeProcessor.processText` (`lib/utils/bbcode_processor.dart:295-368`:
four tag-strip passes with fresh `RegExp`s, `normalizeBBCode`,
`processEmoji`, a `[url]` rewrite, `findPlainUrls` + reverse `replaceRange`
loop), three inline-compiled regexes with `allMatches` (`:222-241`), an
attachment sweep, then `:596-602` constructs a new `BBCodeProcessor()` and
runs `getValidBBCodeText` and `isBBCodeStructurallyValid` (two more full
scans), and finally `BBCodeText` (`:612`) parses the string again. This
happens for every visible post every time the list rebuilds, and finding 2
makes it rebuild on every post scrolled past.

**Fix.** Compute `_PostContentData` and the validated string once per post
instance: in `initState` and in `didUpdateWidget` when the post instance
or translation changes, held in a field, read in `build()`. Then memoize
the processing itself by input string in a bounded `LRUCache` (one exists
at `lib/core/cache/lru_cache.dart`, unused by this path) so a post scrolled
back into view is free, and warm the cache for each page of posts on a
worker isolate (`compute`) when the page arrives. Discourse:
`utils/cooked_content.dart` in `3e46a64`, `post_list_item.dart` in
`181d5fe`.

**Prerequisite — fix first.** `lib/views/widgets/custom_bb_stylesheet.dart:395`
and `:1563` do `_counter++` on a static during render to build hero tags
(statics at `:296`, `:1210`). Every rebuild mutates global state and gives
each image a new hero tag. Derive the tag from stable data (post id +
image index) before caching anything, or cached output will carry stale
tags.

### 2. Scrolling rebuilds the whole thread

`lib/views/lists/posts_list.dart:1003-1016`: a `VisibilityDetector` per
post calls `setState` on the list to update `_currentVisiblePostIndex`
(`:103`), which is read by the jump dialog (`:1077-1112`) and the bottom-bar
label (`:1234`). `:562-565` also `setState`s `_isFirstPostVisible` from the
scroll handler; it gates the mini poll bar (`:1270-1272`, `:1318-1327`).
The top-level `Obx` at `:1261` wraps the list, poll bar and bottom bar, so
each of these rebuilds everything and re-runs finding 1 on every visible
post.

**Fix.** Make both values `ValueNotifier`s. Wrap the bottom-bar label and
the mini poll bar in `ValueListenableBuilder`s. Then delete the
`VisibilityDetector` entirely and derive the most-visible post from
`_itemPositionsListener.itemPositions` (already reported every scroll
frame): pick the item with the largest clamped `itemTrailingEdge -
itemLeadingEdge`. Key each row with `KeyedSubtree(key: ValueKey(post.id))`
at the outermost widget returned per index (the unkeyed `Column` wrapper
at `:1045-1051` currently defeats reuse). Discourse: `posts_list.dart` in
`181d5fe` and `92c63ab`.

### 3. Images decode at full resolution

`lib/views/widgets/cached_redirect_image.dart:201-215` renders
`Image(image: FileImage(file))` and drops the `cacheWidth`/`cacheHeight`
the caller computed (`user_avatar.dart:108-121`); they only reach the
fallback `CachedNetworkImage` at `:294-295`. `:128-135` and `:148-155`
schedule a post-frame `setState` before loading starts; `:194`, `:244`,
`:275` nest three `FutureBuilder`s and fetch twice per widget; `:210-214`
fades with `AnimatedOpacity` (a saveLayer per image for 500 ms).

Worse than in Discourse: the same widget renders every inline post image
(`custom_bb_stylesheet.dart:421`), inline attachment (`:1591`), link
thumbnail (`link_preview_card.dart:288`) and attachment grid
(`attachment_big_thumbnail_grid.dart:129`, `attachment_item_widget.dart:117`,
`attachment_widget.dart:194`, `attachment_image_carousel.dart:212`) with no
decode size at all. A 2000 px forum photo decodes at 2000 px inside a
scrolling thread. `cacheWidth:` is passed at exactly one call site in the
app.

**Fix.** `ResizeImage.resizeIfNeeded(cacheWidth, cacheHeight, FileImage(f))`;
start loading in `initState` directly; one future, derive the resolved URL
from it; pass a decode size at every call site above (display size ×
`MediaQuery.devicePixelRatioOf`). Sniff the file for `<svg`/`<?xml` and
render with `flutter_svg` if the forum allows SVG avatars. Discourse:
`cached_redirect_image.dart` in `181d5fe`.

### 4. Preview cards: up to thirty per post, each a network fetch on appearance

`lib/views/listitems/post_list_item.dart:276-278` takes ten links, ten
videos and ten tweets; `:631-654` renders a card for each; every card
fetches in `initState` and `setState`s on completion
(`link_preview_card.dart:42-90`, `video_card.dart:30-76`,
`twitter_card.dart:29-75`). The caches in `lib/utils/*_cache.dart` are only
consulted from the async fetch, never synchronously on first build.

**Fix.** One preview per post: a video if there is one, else a tweet, else
the first external link (web shows one). Consult the cache synchronously in
the first build. Discourse: `post_list_item.dart` in `7ca5c68`.

## Phase 2 — structural

### 5. The Home feed is not virtualized

`lib/views/tabs/topic_list_tab.dart:453` is `ListView(children: [header,
chips, _ReactiveTopicItems])` and `:53-56` returns
`Column(children: topicItems)` — every loaded row is one child, built and
laid out in full on every `setState` (`:191`, `:223` fire two per
load-more). The row widgets are produced by a sibling state through
`GlobalKey`s (`:305-323` → `latest_topics_list.dart:217-268` and the three
siblings), so both the tab and the list regenerate the whole feed. The
category page has the same shape at `lib/views/lists/forum_topic_list.dart:359`
with three `.where().toList()` passes in `build()` (`:353-355`).

**Fix.** `CustomScrollView` with `SliverToBoxAdapter` for header and chips
and a `SliverList` builder delegate over the rows, so only rows near the
viewport get elements and layout. The row list can stay a `List<Widget>`
(cheap objects); what must go is the single `Column`. Partition the
category page's topics once at load time. Replace the `is Center` /
`is CircularProgressIndicator` type-sniffing at `:42-51` with a bool from
the child state. Discourse: `topic_list_tab.dart` in `3d042a3`.

### 6. A hidden copy of every filter list is built every frame

`lib/views/tabs/topic_list_tab.dart:360-402` keeps the four list states in
an `IndexedStack` at `Positioned(-10000)` under `Opacity(0)` (plus
`IgnorePointer` and `ClipRect`), and all four `build()` methods still
return a full `RefreshIndicator` + `ListView.builder`:
`latest_topics_list.dart:456-458`, `unread_topics_list.dart:533-535`,
`subscribed_topics_list.dart:439-441`, `participated_topics_list.dart:426-428`.
`unread_topics_list.dart:442-447` also runs six interpolated log lines at
the top of that build.

**Fix.** Each hidden list's `build()` returns `const SizedBox.shrink()`
(after `super.build(context)` for the keep-alive mixin); wrap the holder in
`Offstage(offstage: true)` and drop the `Positioned`/`Opacity`/`ClipRect`
stack. Discourse: `3d042a3`.

## Phase 3 — hygiene

| # | where | what | fix |
|---|---|---|---|
| 7 | `posts_list.dart:999-1001`, `:1029-1039`; `post_list_item.dart:154-155`, `posts_list.dart:1242` | `AvatarActions`, `ImageActions`, `PostActionsHandler` and a `PostActions` with eight closures allocated per post per build; `PostActionsHandler` built three times | one instance each per thread, `late final` on the list state |
| 8 | `post_list_item.dart:464-468` → `custom_bb_stylesheet.dart:73-177` | ~55 tag objects per post per build | build once per post with the cached content (some tags carry per-post callbacks, so per-post, not per-theme) |
| 9 | `user_avatar.dart:5-64`, `:122` | shimmer with an `AnimationController` per avatar | flat tinted disc |
| 10 | `posts_list.dart:866`, `:979-984` | `Shimmer.fromColors` loading cards (ShaderMask saveLayer per frame) | static blocks |
| 11 | `utils/avatar_color_utils.dart:73-117` | fresh colour map + gradient list per avatar per build | memoize by `(username, isLightTheme)` |
| 12 | `forum_header_widget.dart:155`, `:177`, `:263-270` | `IntrinsicHeight` (double layout), `ColorFiltered` (full-header saveLayer), shadow + clip, all inside an `Obx` at index 0 of the feed | drop `IntrinsicHeight` (the Stack sizes to its content child), tint via `Image.color`/`colorBlendMode` |
| 13 | `post_list_item.dart:717-720` | `AnimatedContainer` root on every post for a highlight one post uses | `ColoredBox` unless highlighted |
| 14 | `topic_list_item.dart:183-193`, `:196-370` | throwaway list to count status icons; one `Wrap` of up to seven rows | one `_MetaRow` widget: counts plus a single right-aligned badge |
| 15 | `reaction_picker.dart:146-152` | `Image.network` with no decode size for custom reactions | `cacheWidth`/`cacheHeight` |
| 16 | `posts_list.dart:551`, `:534-545` | pagination triggers 3 items from the end and only at index 0 going up | 8 items either way |
| 17 | `custom_bb_stylesheet.dart:1100`, `:1119`, `:1138`, `:1160`; `post_list_item.dart:248-249` | `AppLogger.debug` interpolating full subtree text on every tag render and inside the URL loop | guard with a level check or remove |
| 18 | `lib/views/widgets/rich_text_content.dart` | dead BBCode renderer, zero call sites, three regexes per build if ever wired | delete |

## Not applicable

Topic rows here already have one avatar, no tag chips, no last-poster
avatar and no emoji-shortcode pass, so the row cuts made in Discourse
v1.0.9 mostly have nothing to cut. There is no like cooldown timer and no
topic-list skeleton.

## Also worth knowing

`packages/forumcopilot_sdk` is a vendored copy at the same version number
as the canonical one in tapatalk_flutter but has drifted in 19 files
(`fc_post`, `fc_topic`, `fc_user`, `fc_group` and mappers,
`i_fc_private_conversation_proxy`). Nothing above touches the SDK, but any
shared fix at that layer needs the copies reconciled first.
