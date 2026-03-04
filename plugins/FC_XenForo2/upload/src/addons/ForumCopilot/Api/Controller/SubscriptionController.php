<?php

namespace ForumCopilot\Api\Controller;

use XF\Mvc\ParameterBag;
use ForumCopilot\Result\FCSubscribedForumResult;
use ForumCopilot\Result\FCSubscribeForumResult;
use ForumCopilot\Result\FCUnsubscribeForumResult;
use ForumCopilot\Result\FCSubscribedTopicResult;
use ForumCopilot\Result\FCSubscribeTopicResult;
use ForumCopilot\Result\FCUnsubscribeTopicResult;
use ForumCopilot\Adapter\XenForoParamAdapter;
use ForumCopilot\Entity\FCTopic;

/**
 * Subscription Controller for ForumCopilot API
 * Handles forum and topic subscriptions
 */
class SubscriptionController extends AbstractController
{
    public function actionGetSubscribedForum(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) {
            return $error;
        }

        try {
            $visitor = \XF::visitor();
            
            // Get subscribed forums using finder directly
            $finder = $this->finder('XF:ForumWatch');
            $finder->where('user_id', $visitor->user_id);
            $finder->with('Forum');
            
            $watches = $finder->fetch();

            $forumList = [];
            foreach ($watches as $watch) {
                try {
                    $forum = $watch->Forum;
                    if (!$forum) {
                        continue;
                    }
                    
                    // Load Node separately to avoid relation issues
                    $node = $this->em()->find('XF:Node', $forum->node_id);
                    if (!$node) {
                        continue;
                    }
                    
                    if (!$forum->canView()) {
                        continue;
                    }
                    
                    $forumList[] = [
                        'id' => (string)$forum->node_id,
                        'name' => $node->title,
                        'description' => $node->description,
                        'threadCount' => $forum->discussion_count,
                        'postCount' => $forum->message_count,
                        'canPost' => $forum->canCreateThread(),
                        'isRead' => !$forum->isUnread(),
                        'url' => $this->buildLink('canonical:forums', $forum),
                        'subscribeMode' => $watch->notify_on,
                    ];
                } catch (\Exception $e) {
                    // Skip this forum if there's an error
                    continue;
                }
            }

            $result = new FCSubscribedForumResult(
                true,
                null,
                count($forumList),
                $forumList
            );

            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiError('Failed to get subscribed forums: ' . $e->getMessage());
        }
    }

    public function actionSubscribeForum(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        // Convert XenForo ParameterBag to forum-agnostic parameter class
        $fcParams = XenForoParamAdapter::toSubscribeForumParamsExtended($params);
        
        // Validate parameters
        $errors = $fcParams->validate();
        if (!empty($errors)) {
            return $this->apiError('Invalid parameters: ' . implode(', ', $errors));
        }

        try {
            $visitor = \XF::visitor();

            // Map subscribeMode to XenForo parameters
            // subscribeMode: 0 = no email (alerts only), 1 = instant email, 2/3 = digest (not directly supported)
            // Default to 'thread' notification type (matching web version default)
            $notifyType = 'thread';
            $sendAlert = true; // Default to true (matching web version default)
            $sendEmail = ($fcParams->subscribeMode == 1); // Only send email if subscribeMode = 1

            if ($fcParams->forumId === 'ALL') {
                // Update all subscribed forums
                // Each forum may have different allowed_watch_notifications, so check individually
                $finder = $this->finder('XF:ForumWatch');
                $finder->where('user_id', $visitor->user_id);
                $watches = $finder->fetch();
                
                $forumWatchRepo = $this->repository('XF:ForumWatch');
                foreach ($watches as $watch) {
                    $watchForum = $watch->Forum;
                    if (!$watchForum) {
                        continue;
                    }
                    
                    // Check if user can watch this forum (matching web version permission check)
                    if (!$watchForum->canWatch()) {
                        continue;
                    }
                    
                    // Determine notifyType for this specific forum (matching web version logic)
                    $forumNotifyType = 'thread';
                    if ($watchForum->allowed_watch_notifications == 'none') {
                        $forumNotifyType = '';
                    }
                    
                    $forumWatchRepo->setWatchState($watchForum, $visitor, $forumNotifyType, $sendAlert, $sendEmail);
                }
            } else {
                // Subscribe to specific forum (matching web version behavior)
                $forum = $this->assertViewableForum($fcParams->forumId);
                
                if (!$forum->canWatch()) {
                    return $this->apiError('Cannot subscribe to this forum');
                }
                
                // Check forum notification settings (matching web version logic)
                // If forum doesn't allow watch notifications, set notifyType to empty
                if ($forum->allowed_watch_notifications == 'none') {
                    $notifyType = '';
                }
                // Note: API uses simplified subscribeMode, so we always use 'thread' type
                // (web version supports 'message' when allowed_watch_notifications == 'all',
                // but API doesn't expose this option via subscribeMode)
                
                $forumWatchRepo = $this->repository('XF:ForumWatch');
                $forumWatchRepo->setWatchState($forum, $visitor, $notifyType, $sendAlert, $sendEmail);
            }

            $result = new FCSubscribeForumResult(true, null);
            return $this->apiSuccess($result);

        } catch (\XF\Mvc\Reply\Exception $e) {
            // Extract XenForo's error message from the exception
            $errorMsg = $this->extractErrorMessageFromReplyException($e, 'Forum not found or not accessible');
            return $this->apiError($errorMsg);
        } catch (\Exception $e) {
            return $this->apiError('Failed to subscribe to forum: ' . $e->getMessage());
        }
    }

    public function actionUnsubscribeForum(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $forumId = $params->get('forumId', '');

        if (empty($forumId)) {
            return $this->apiError('Forum ID is required');
        }

        try {
            $visitor = \XF::visitor();
            $forumWatchRepo = $this->repository('XF:ForumWatch');

            if ($forumId === 'ALL') {
                // Unsubscribe from all forums
                $finder = $this->finder('XF:ForumWatch');
                $finder->where('user_id', $visitor->user_id);
                $watches = $finder->fetch();
                foreach ($watches as $watch) {
                    $watch->delete();
                }
            } else {
                // Unsubscribe from specific forum
                $forum = $this->assertViewableForum($forumId);
                $forumWatchRepo->setWatchState($forum, $visitor, 'delete');
            }

            $result = new FCUnsubscribeForumResult(true, null);
            return $this->apiSuccess($result);

        } catch (\XF\Mvc\Reply\Exception $e) {
            // Extract XenForo's error message from the exception
            $errorMsg = $this->extractErrorMessageFromReplyException($e, 'Forum not found or not accessible');
            return $this->apiError($errorMsg);
        } catch (\Exception $e) {
            return $this->apiError('Failed to unsubscribe from forum: ' . $e->getMessage());
        }
    }

    public function actionGetSubscribedTopic(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $startNum = $params->get('startNum', 0);
        $lastNum = $params->get('lastNum', 19);

        try {
            $visitor = \XF::visitor();
            
            // Setup base finder with common filters (but skip find_new requirement for subscribed)
            $finder = $this->setupTopicListFinder(['requireFindNew' => false]);
            
            // Apply watched filter
            $this->applyTopicFilters($finder, ['watched' => true], $visitor);
            
            // Build topic list (use last post for preview to match original behavior)
            $result = $this->buildTopicListFromFinder($finder, $startNum, $lastNum, ['useLastPost' => true]);

            return $this->apiSuccess(new FCSubscribedTopicResult(
                true,
                null,
                $result['total'],
                $result['topics']
            ));

        } catch (\Exception $e) {
            return $this->apiError('Failed to get subscribed topics: ' . $e->getMessage());
        }
    }

    public function actionSubscribeTopic(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $topicId = $params->get('topicId', '');
        $subscribeMode = $params->get('subscribeMode', 0);

        if (empty($topicId)) {
            return $this->apiError('Topic ID is required');
        }

        try {
            $thread = $this->assertViewableThread($topicId);
            $visitor = \XF::visitor();

            if (!$thread->canWatch()) {
                return $this->apiError('Cannot subscribe to this topic');
            }

            // Map subscribeMode to XenForo watch state (like Tapatalk does)
            // subscribeMode: 0 = no email (alerts only), 1 = instant email, 2/3 = digest (not directly supported)
            // Tapatalk uses: 'watch_no_email' or 'watch_email'
            $mode = 'watch_no_email'; // Default: alerts only
            if ($subscribeMode == 1 || $subscribeMode == 2 || $subscribeMode == 3) {
                // subscribeMode 1, 2, 3 all use email (XenForo doesn't support digest directly)
                $mode = 'watch_email';
            }

            if ($topicId === 'ALL') {
                // Update all subscribed topics
                $finder = $this->finder('XF:ThreadWatch');
                $finder->where('user_id', $visitor->user_id);
                $watches = $finder->fetch();
                
                foreach ($watches as $watch) {
                    // Use setWatchState for each thread to properly set the watch state
                    $watchThread = $watch->Thread;
                    if ($watchThread) {
                        $threadWatchRepo = $this->repository('XF:ThreadWatch');
                        $threadWatchRepo->setWatchState($watchThread, $visitor, $mode);
                    }
                }
            } else {
                // Subscribe to specific topic (like Tapatalk does)
                $threadWatchRepo = $this->repository('XF:ThreadWatch');
                $threadWatchRepo->setWatchState($thread, $visitor, $mode);
            }

            $result = new FCSubscribeTopicResult(true, null);
            return $this->apiSuccess($result);

        } catch (\XF\Mvc\Reply\Exception $e) {
            // Extract XenForo's error message from the exception
            $errorMsg = $this->extractErrorMessageFromReplyException($e, 'Thread not found or not accessible');
            return $this->apiError($errorMsg);
        } catch (\Exception $e) {
            return $this->apiError('Failed to subscribe to topic: ' . $e->getMessage());
        }
    }

    public function actionUnsubscribeTopic(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $topicId = $params->get('topicId', '');

        if (empty($topicId)) {
            return $this->apiError('Topic ID is required');
        }

        try {
            $visitor = \XF::visitor();
            $threadWatchRepo = $this->repository('XF:ThreadWatch');

            if ($topicId === 'ALL') {
                // Unsubscribe from all topics
                $finder = $this->finder('XF:ThreadWatch');
                $finder->where('user_id', $visitor->user_id);
                $watches = $finder->fetch();
                foreach ($watches as $watch) {
                    $watch->delete();
                }
            } else {
                // Unsubscribe from specific topic
                $thread = $this->assertViewableThread($topicId);
                $threadWatchRepo->setWatchState($thread, $visitor, 'delete');
            }

            $result = new FCUnsubscribeTopicResult(true, null);
            return $this->apiSuccess($result);

        } catch (\XF\Mvc\Reply\Exception $e) {
            // Extract XenForo's error message from the exception
            $errorMsg = $this->extractErrorMessageFromReplyException($e, 'Thread not found or not accessible');
            return $this->apiError($errorMsg);
        } catch (\Exception $e) {
            return $this->apiError('Failed to unsubscribe from topic: ' . $e->getMessage());
        }
    }
}
