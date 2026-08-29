import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:forumcopilot_flutter/services/site_proxy_service.dart';
import 'package:forumcopilot_sdk/models/entities/fc_poll.dart';
import 'package:forumcopilot_sdk/models/entities/fc_post.dart';
import 'package:get/get.dart';
import '../models/thread_view_data.dart';
import 'global_loader_controller.dart';
import 'package:forumcopilot_flutter/core/errors/error_handling_mixins.dart';
import 'package:forumcopilot_flutter/core/logging/app_logger.dart';

enum LoadMode { initial, earlier, later }

class PostController extends GlobalLoaderController with ErrorHandlingMixin {
  // Observable state to track initialization
  var isInitialized = false.obs;
  final Rx<ThreadViewData?> threadDataOutput = Rx<ThreadViewData?>(null);

  // Stream subscriptions for cleanup
  StreamSubscription? _threadDataSubscription;

  /// Applies thread data and isInitialized in the next frame to avoid
  /// setState/markNeedsBuild while the widget tree is locked (e.g. after route pop).
  Future<void> _applyThreadDataOnNextFrame(ThreadViewData data) async {
    final completer = Completer<void>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      threadDataOutput.value = data;
      isInitialized.value = true;
      if (!completer.isCompleted) completer.complete();
    });
    await completer.future;
  }

  /// Removes duplicate posts by id, keeping the first occurrence (order
  /// preserved). Guards the thread against overlapping fetches rendering the
  /// same post twice — e.g. an anchored / first-unread open returns a window
  /// centred on the anchor that can overlap a later load-more page.
  List<FCPost> _dedupPostsById(List<FCPost> posts) {
    final seen = <String>{};
    final result = <FCPost>[];
    for (final post in posts) {
      if (seen.add(post.id)) {
        result.add(post);
      }
    }
    return result;
  }

  Future<void> getThreadAsync(String topicId, int startNum, int lastNum, bool returnHtml, {LoadMode mode = LoadMode.initial}) async {
    try {
      // Note: startNum and lastNum here are in the format expected by the proxy/API.
      // For XenForo: API expects 1-based (position 1 = first post), so proxy
      // passes 1-based.
      // Internally, we store currentStartNum as 0-based for easier calculations.

      var postProxy = SiteProxyService.getPostProxy();
      var threadsResult = await postProxy.getThreadAsync(topicId, startNum, lastNum, returnHtml);

      // The proxy now returns FCPost objects directly, no conversion needed
      final fcPosts = threadsResult.posts;
      
      // Log warning if posts are empty (for all modes, but especially important for initial load)
      if (fcPosts.isEmpty) {
        AppLogger.warning('⚠️ [PostController] getThreadAsync returned empty posts list');
        AppLogger.warning('   Topic ID: $topicId');
        AppLogger.warning('   Load Mode: $mode');
        AppLogger.warning('   Start Num: $startNum, Last Num: $lastNum');
        AppLogger.warning('   Total Posts (from API): ${threadsResult.totalPostNum}');
        AppLogger.warning('   Thread Title: ${threadsResult.title}');
        AppLogger.warning('   Result: ${threadsResult.result}, Result Text: ${threadsResult.resultText}');
      }

      // Convert 1-based startNum (from API) to 0-based for internal storage
      // startNum from API is 1-based: position 1 = first post
      // currentStartNum should be 0-based: index 0 = first post
      final currentStartNum0Based = startNum - 1;
      final position = currentStartNum0Based + fcPosts.length; // 0-based after last loaded post, but we need 1-based for position

      final ThreadViewData newData;
      if (mode == LoadMode.initial || threadDataOutput.value == null) {
        newData = ThreadViewData(
          topic: threadsResult,
          posts: _dedupPostsById(fcPosts),
          currentStartNum: currentStartNum0Based, // Store as 0-based
          position: position + 1, // Convert to 1-based for position field
        );
      } else {
        final existing = threadDataOutput.value!;
        List<FCPost> mergedPosts;
        int newStartNum;
        if (mode == LoadMode.earlier) {
          // Dedup by id: an anchored/centred window can overlap the page we
          // already hold; appending blindly renders the same post twice.
          mergedPosts = _dedupPostsById([...fcPosts, ...existing.posts]);
          newStartNum = currentStartNum0Based; // Use 0-based
        } else {
          mergedPosts = _dedupPostsById([...existing.posts, ...fcPosts]);
          newStartNum = existing.currentStartNum; // Already 0-based
        }
        newData = ThreadViewData(
          topic: threadsResult,
          posts: mergedPosts,
          currentStartNum: newStartNum,
          position: newStartNum + mergedPosts.length + 1, // Convert to 1-based
        );
      }

      await _applyThreadDataOnNextFrame(newData);
    } catch (e, stackTrace) {
      await handleError(e, stackTrace, context: 'PostController.getThreadAsync');
      rethrow;
    }
  }

  Future<void> getThreadByUnreadAsync(String topicId, int postsPerRequest, bool returnHtml) async {
    try {
      var postProxy = SiteProxyService.getPostProxy();
      var threadsResult = await postProxy.getThreadByUnreadAsync(topicId, postsPerRequest, returnHtml);
      AppLogger.debug('getThreadByUnreadAsync result: ${threadsResult.toString()}');

      // Set post_level for each post
      final position = threadsResult.position; // 1-based index of first unread post
      // The proxy now returns FCPost objects directly, no conversion needed
      final fcPosts = threadsResult.posts;

      // Derive the 0-based start of the loaded window from the FIRST post
      // actually returned (postNumber = its 1-based thread position), NOT a
      // page-boundary guess. The server window is centred on the anchor and
      // does not align to page boundaries; a guess drifts and makes load-more
      // offsets overlap the loaded tail (duplicate posts).
      final int currentStartNum = (fcPosts.isNotEmpty && (fcPosts.first.postNumber ?? 0) > 0)
          ? (fcPosts.first.postNumber! - 1)
          : ((position - 1) ~/ postsPerRequest) * postsPerRequest;
      
      // Log warning if posts are empty
      if (fcPosts.isEmpty) {
        AppLogger.warning('⚠️ [PostController] getThreadByUnreadAsync returned empty posts list');
        AppLogger.warning('   Topic ID: $topicId');
        AppLogger.warning('   Posts Per Request: $postsPerRequest');
        AppLogger.warning('   Position: $position');
        AppLogger.warning('   Total Posts (from API): ${threadsResult.totalPostNum}');
        AppLogger.warning('   Result: ${threadsResult.result}, Result Text: ${threadsResult.resultText}');
      }

      final newData = ThreadViewData(
        topic: threadsResult,
        posts: fcPosts,
        currentStartNum: currentStartNum,
        position: position,
      );
      await _applyThreadDataOnNextFrame(newData);
    } catch (e, stackTrace) {
      await handleError(e, stackTrace, context: 'PostController.getThreadByUnreadAsync');
      rethrow;
    }
  }

  Future<void> getThreadByPostAsync(String postId, int postsPerRequest, bool returnHtml) async {
    try {
      AppLogger.debug('🔍 [PostController] getThreadByPostAsync called: postId=$postId, postsPerRequest=$postsPerRequest');
      var postProxy = SiteProxyService.getPostProxy();
      var threadsResult = await postProxy.getThreadByPostAsync(postId, postsPerRequest, returnHtml);
      AppLogger.debug('🔍 [PostController] getThreadByPostAsync result: ${threadsResult.toString()}');

      // Set post_level for each post
      final position = threadsResult.position; // 1-based index of anchor post
      AppLogger.debug('🔍 [PostController] Position from API (1-based): $position');

      // The proxy now returns FCPost objects directly, no conversion needed
      final fcPosts = threadsResult.posts;
      AppLogger.debug('🔍 [PostController] Received ${fcPosts.length} posts');

      // Derive the 0-based start of the loaded window from the FIRST post
      // actually returned (postNumber = its 1-based thread position), NOT a
      // page-boundary guess. The server returns a window centred on the anchor
      // (startNum = max(1, position - perPage/2)) that does not align to page
      // boundaries; a guess drifts and makes load-more offsets overlap the
      // loaded tail, rendering duplicate posts. Fall back to the guess only if
      // the posts carry no position.
      final int currentStartNum = (fcPosts.isNotEmpty && (fcPosts.first.postNumber ?? 0) > 0)
          ? (fcPosts.first.postNumber! - 1)
          : ((position - 1) ~/ postsPerRequest) * postsPerRequest;
      AppLogger.debug('🔍 [PostController] currentStartNum (0-based): $currentStartNum from position $position, firstPostNumber=${fcPosts.isNotEmpty ? fcPosts.first.postNumber : null}');
      
      // Log warning if posts are empty
      if (fcPosts.isEmpty) {
        AppLogger.warning('⚠️ [PostController] getThreadByPostAsync returned empty posts list');
        AppLogger.warning('   Post ID: $postId');
        AppLogger.warning('   Posts Per Request: $postsPerRequest');
        AppLogger.warning('   Position: $position');
        AppLogger.warning('   Total Posts (from API): ${threadsResult.totalPostNum}');
        AppLogger.warning('   Result: ${threadsResult.result}, Result Text: ${threadsResult.resultText}');
      }

      // Log post IDs and postNumbers for debugging
      for (int i = 0; i < fcPosts.length && i < 5; i++) {
        final post = fcPosts[i];
        AppLogger.debug('🔍 [PostController] Post[$i]: id=${post.id}, postNumber=${post.postNumber}');
      }
      if (fcPosts.length > 5) {
        AppLogger.debug('🔍 [PostController] ... and ${fcPosts.length - 5} more posts');
      }

      final newData = ThreadViewData(
        topic: threadsResult,
        posts: fcPosts,
        currentStartNum: currentStartNum,
        position: position,
      );
      await _applyThreadDataOnNextFrame(newData);
    } catch (e, stackTrace) {
      await handleError(e, stackTrace, context: 'PostController.getThreadByPostAsync');
      rethrow;
    }
  }

  /// Replaces the current thread's poll with the updated poll (e.g. after voting).
  /// Keeps posts and position unchanged.
  /// Defers the update to the next frame to avoid markNeedsBuild while tree is locked.
  void updateThreadPoll(FCPoll poll) {
    final current = threadDataOutput.value;
    if (current == null) return;
    final updatedTopic = current.topic.copyWith(poll: poll, hasPoll: true);
    final newData = ThreadViewData(
      topic: updatedTopic,
      posts: current.posts,
      currentStartNum: current.currentStartNum,
      position: current.position,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      threadDataOutput.value = newData;
    });
  }

  /// Loads a specific page of posts by page number (1-based).
  ///
  /// Calculates startNum and lastNum based on the page number and page size, then calls getThreadAsync.
  /// Example: gotoPage = (totalPostNum-1)/postPerPage+1;
  ///
  /// Note: The API expects startNum and lastNum to be 1-based (position 1 = first post).
  /// getThreadAsync will convert to 0-based for internal storage.
  Future<void> getThreadByPageAsync(String topicId, int gotoPage, int postsPerPage, bool returnHtml) async {
    try {
      // Calculate startNum and lastNum for the requested page
      // gotoPage is 1-based: page 1 = posts 1-20, page 2 = posts 21-40, etc.
      // For page 11: startNum = (11-1)*20 + 1 = 201 (1-based)
      // The API expects 1-based, so we calculate in 1-based
      final startNum1Based = (gotoPage - 1) * postsPerPage + 1;
      final lastNum1Based = startNum1Based + postsPerPage - 1;

      // Pass 1-based to getThreadAsync (which will convert internally)
      await getThreadAsync(topicId, startNum1Based, lastNum1Based, returnHtml, mode: LoadMode.initial);
    } catch (e, stackTrace) {
      await handleError(e, stackTrace, context: 'PostController.getThreadByPageAsync');
      rethrow;
    }
  }

  @override
  void onClose() {
    // Cleanup resources to prevent memory leaks
    _threadDataSubscription?.cancel();
    _threadDataSubscription = null;

    // Clear reactive variables
    isInitialized.value = false;
    threadDataOutput.value = null;

    super.onClose();
  }
}
