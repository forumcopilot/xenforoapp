import 'package:forumcopilot_flutter/services/site_proxy_service.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/models/entities/fc_topic.dart';
import 'package:forumcopilot_sdk/models/results/fc_subscription_result.dart';
import 'package:forumcopilot_sdk/models/results/fc_topic_result.dart';
import 'package:get/get.dart';
import 'global_loader_controller.dart';
import 'package:forumcopilot_flutter/core/errors/error_handling_mixins.dart';
import 'package:forumcopilot_flutter/core/logging/app_logger.dart';

class LatestTopicController extends GlobalLoaderController with ErrorHandlingMixin {
  var isInitialized = false.obs;
  final latestTopicsDataOutput = FCLatestTopicResult(
    result: false,
    resultText: '',
    totalLatestNum: 0,
    topics: [],
  ).obs;
  final fcTopics = <FCTopic>[].obs;

  Future<void> getLatestTopicAsync(int startNum, int lastNum, {String? searchId, List<String>? filters}) async {
    AppLogger.debug('getLatestTopicAsync called:');
    AppLogger.debug('  - startNum: $startNum');
    AppLogger.debug('  - lastNum: $lastNum');
    AppLogger.debug('  - searchId: $searchId');
    AppLogger.debug('  - filters: $filters');

    var topicProxy = SiteProxyService.getTopicProxy();
    AppLogger.debug('TopicProxy created, calling getLatestTopicAsync...');

    try {
      var result = await topicProxy.getLatestTopicAsync(startNum, lastNum, searchId: searchId, filters: filters);

      AppLogger.debug('API call completed:');
      AppLogger.debug('  - result.result: ${result.result}');
      AppLogger.debug('  - result.resultText: ${result.resultText}');
      AppLogger.debug('  - result.totalLatestNum: ${result.totalLatestNum}');
      AppLogger.debug('  - result.topics.length: ${result.topics.length}');

      // Always store the result and mark as initialized, even if result is false
      // This allows the UI to handle error states properly
      if (startNum == 0) {
        AppLogger.debug('Replacing topics list (startNum == 0)');
        latestTopicsDataOutput.value = result;
        if (result.result) {
          // Convert topics to FCTopic objects
          final convertedTopics = result.topics;
          fcTopics.value = convertedTopics;
          AppLogger.debug('Data updated successfully');

          // If first page returns empty topics, treat it as empty overall
          // even if totalLatestNum > 0, as the user should only see what they have permission to view
          if (convertedTopics.isEmpty && result.totalLatestNum > 0) {
            AppLogger.debug('First page returned empty topics (totalLatestNum=${result.totalLatestNum}). Treating as empty overall.');
            // Update totalLatestNum to 0 to reflect that there are no viewable topics
            latestTopicsDataOutput.value = FCLatestTopicResult(
              result: result.result,
              resultText: result.resultText,
              totalLatestNum: 0,
              topics: [],
            );
          }
        } else {
          // Clear topics when result is false
          fcTopics.clear();
          AppLogger.warning('API call failed: ${result.resultText}');
        }
      } else {
        AppLogger.debug('Appending to existing topics list');
        if (result.result) {
          latestTopicsDataOutput.value.topics.addAll(result.topics);
          latestTopicsDataOutput.value.totalLatestNum = result.totalLatestNum;
          final convertedTopics = result.topics;
          fcTopics.addAll(convertedTopics);
        } else {
          AppLogger.warning('API call failed: ${result.resultText}');
        }
      }
      // Always mark as initialized so UI can display error state instead of loading
      isInitialized.value = true;
    } catch (e, stackTrace) {
      await handleError(e, stackTrace, context: 'LatestTopicController.getLatestTopicAsync');
      rethrow;
    }
  }

  void markTopicAsRead(String topicId) {
    // Update FCTopic list immediately to reflect the change in UI
    final updatedTopics = fcTopics.map((topic) {
      if (topic.id == topicId) {
        // Create a copy with hasNewPosts set to false
        return topic.copyWith(hasNewPosts: false);
      }
      return topic;
    }).toList();

    // Update the observable with the modified data
    fcTopics.value = updatedTopics;

    // Also update the raw data for consistency
    var currentData = latestTopicsDataOutput.value;
    var updatedRawTopics = currentData.topics.map((topic) {
      if (topic.id == topicId) {
        return topic.copyWith(hasNewPosts: false);
      }
      return topic;
    }).toList();
    latestTopicsDataOutput.value = currentData.copyWith(topics: updatedRawTopics);
  }
}

class UnreadTopicController extends GetxController {
  final isInitialized = false.obs;
  final unreadTopicsDataOutput = FCUnreadTopicResult(
    result: false,
    resultText: '',
    totalUnreadNum: 0,
    topics: [],
  ).obs;
  final fcTopics = <FCTopic>[].obs;

  Future<void> getUnreadTopicAsync(int startNum, int lastNum) async {
    final topicProxy = SiteProxyService.getTopicProxy();
    final result = await topicProxy.getUnreadTopicAsync(startNum, lastNum);

    // Convert topics to FCTopic objects
    final convertedTopics = result.topics;

    if (startNum == 0) {
      unreadTopicsDataOutput.value = result;
      fcTopics.value = convertedTopics;

      // If first page returns empty topics, treat it as empty overall
      // even if totalUnreadNum > 0, as the user should only see what they have permission to view
      if (convertedTopics.isEmpty && result.totalUnreadNum > 0) {
        AppLogger.debug('First page returned empty unread topics (totalUnreadNum=${result.totalUnreadNum}). Treating as empty overall.');
        // Update totalUnreadNum to 0 to reflect that there are no viewable topics
        unreadTopicsDataOutput.value = FCUnreadTopicResult(
          result: result.result,
          resultText: result.resultText,
          totalUnreadNum: 0,
          topics: [],
        );
      }
    } else {
      unreadTopicsDataOutput.value.topics.addAll(result.topics);
      unreadTopicsDataOutput.value.totalUnreadNum = result.totalUnreadNum;
      fcTopics.addAll(convertedTopics);
    }
    isInitialized.value = true;
  }

  void markTopicAsRead(String topicId) {
    // Update FCTopic list immediately to reflect the change in UI
    final updatedTopics = fcTopics.map((topic) {
      if (topic.id == topicId) {
        // Create a copy with hasNewPosts set to false
        return topic.copyWith(hasNewPosts: false);
      }
      return topic;
    }).toList();

    // Update the observable with the modified data
    fcTopics.value = updatedTopics;

    // Also update the raw data for consistency
    var currentData = unreadTopicsDataOutput.value;
    var updatedRawTopics = currentData.topics.map((topic) {
      if (topic.id == topicId) {
        return topic.copyWith(hasNewPosts: false);
      }
      return topic;
    }).toList();
    unreadTopicsDataOutput.value = currentData.copyWith(topics: updatedRawTopics);
  }

  /// Reset and reload the unread topics list
  /// This is called after marking all forums as read to immediately update the list
  Future<void> resetAndReload() async {
    // Clear existing data
    unreadTopicsDataOutput.value = FCUnreadTopicResult(
      result: false,
      resultText: '',
      totalUnreadNum: 0,
      topics: [],
    );
    fcTopics.clear();
    isInitialized.value = false;

    // Reload from the beginning
    await getUnreadTopicAsync(0, 19); // Load first page (20 items)
  }
}

class ParticipatedTopicController extends GetxController {
  final isInitialized = false.obs;
  final participatedTopicsDataOutput = FCParticipatedTopicResult(
    result: false,
    resultText: '',
    totalParticipatedNum: 0,
    topics: [],
  ).obs;
  final fcTopics = <FCTopic>[].obs;

  Future<void> getParticipatedTopicAsync(SiteContext siteContext, int startNum, int lastNum) async {
    final topicProxy = SiteProxyService.getTopicProxy();

    if (siteContext.loginDataOutput?.user == null) {
      return;
    }

    final result = await topicProxy.getParticipatedTopicAsync(
      siteContext.loginDataOutput!.user!.username,
      startNum,
      lastNum,
    );

    // Convert topics to FCTopic objects
    final convertedTopics = result.topics;

    if (startNum == 0) {
      participatedTopicsDataOutput.value = result;
      fcTopics.value = convertedTopics;

      // If first page returns empty topics, treat it as empty overall
      // even if totalParticipatedNum > 0, as the user should only see what they have permission to view
      if (convertedTopics.isEmpty && result.totalParticipatedNum > 0) {
        AppLogger.debug('First page returned empty participated topics (totalParticipatedNum=${result.totalParticipatedNum}). Treating as empty overall.');
        // Update totalParticipatedNum to 0 to reflect that there are no viewable topics
        participatedTopicsDataOutput.value = FCParticipatedTopicResult(
          result: result.result,
          resultText: result.resultText,
          totalParticipatedNum: 0,
          topics: [],
        );
      }
    } else {
      participatedTopicsDataOutput.value.topics.addAll(result.topics);
      participatedTopicsDataOutput.value.totalParticipatedNum = result.totalParticipatedNum;
      fcTopics.addAll(convertedTopics);
    }
    isInitialized.value = true;
  }
}

class SubscribedTopicController extends GetxController {
  final isInitialized = false.obs;
  // TODO: Update this when SubscriptionProxy is refactored to use new interface
  final subscribedTopicsDataOutput = FCSubscribedTopicResult(
    result: false,
    resultText: '',
    totalTopicNum: 0,
    topics: [],
  ).obs;
  final fcTopics = <FCTopic>[].obs;

  Future<void> getSubscribedTopicAsync(int startNum, int lastNum) async {
    final subscriptionProxy = SiteProxyService.getSubscriptionProxy();
    final result = await subscriptionProxy.getSubscribedTopicAsync(startNum, lastNum);

    // Convert topics to FCTopic objects
    final convertedTopics = _convertFCSubscribedTopicsToFCTopics(result.topics);

    if (startNum == 0) {
      subscribedTopicsDataOutput.value = result;
      fcTopics.value = convertedTopics;

      // If first page returns empty topics, treat it as empty overall
      // even if totalTopicNum > 0, as the user should only see what they have permission to view
      if (convertedTopics.isEmpty && result.totalTopicNum > 0) {
        AppLogger.debug('First page returned empty subscribed topics (totalTopicNum=${result.totalTopicNum}). Treating as empty overall.');
        // Update totalTopicNum to 0 to reflect that there are no viewable topics
        subscribedTopicsDataOutput.value = FCSubscribedTopicResult(
          result: result.result,
          resultText: result.resultText,
          totalTopicNum: 0,
          topics: [],
        );
      }
    } else {
      subscribedTopicsDataOutput.value.topics.addAll(result.topics);
      subscribedTopicsDataOutput.value.totalTopicNum = result.totalTopicNum;
      fcTopics.addAll(convertedTopics);
    }
    isInitialized.value = true;
  }

  /// Convert FCSubscribedTopic to old FCTopic for UI compatibility
  List<FCTopic> _convertFCSubscribedTopicsToFCTopics(List<FCSubscribedTopic> fcSubscribedTopics) {
    return fcSubscribedTopics
        .map((fcSubscribedTopic) => FCTopic(
              id: fcSubscribedTopic.topicId,
              title: fcSubscribedTopic.topicTitle,
              forumId: fcSubscribedTopic.forumId,
              forumName: fcSubscribedTopic.forumName,
              authorId: fcSubscribedTopic.postAuthorId,
              authorName: fcSubscribedTopic.postAuthorName,
              authorUserType: fcSubscribedTopic.postAuthorUserType ?? '',
              timestamp: fcSubscribedTopic.postTime,
              prefix: null,
              authorIconUrl: fcSubscribedTopic.iconUrl,
              replyCount: fcSubscribedTopic.replyNumber,
              viewCount: fcSubscribedTopic.viewNumber,
              shortContent: fcSubscribedTopic.shortContent ?? '',
              hasNewPosts: fcSubscribedTopic.newPost,
              isClosed: fcSubscribedTopic.isClosed,
              isSubscribed: fcSubscribedTopic.isSubscribed,
              canSubscribe: true,
              url: null,
              participatedUserIds: const [],
              isPinned: fcSubscribedTopic.isSticky, // Map isSticky to isPinned
              isAnnouncement: fcSubscribedTopic.isAnnouncement,
              // Moderation capabilities - set defaults since FCSubscribedTopic doesn't have these
              canRename: false,
              canDelete: false,
              canClose: false,
              canApprove: false,
              canStick: false,
              canMove: false,
              canBan: false,
              // Moderation statuses - map available properties
              isBanned: false,
              isApproved: fcSubscribedTopic.isApproved,
              isDeleted: fcSubscribedTopic.isDeleted,
              isMoved: fcSubscribedTopic.isMoved,
              isMerged: fcSubscribedTopic.isMerged,
              realTopicId: null,
              // Like/thank capabilities
              canLike: false,
              isLiked: fcSubscribedTopic.isLiked,
              likeCount: 0,
              canThank: false,
            ))
        .toList();
  }
}
