<?php

namespace ForumCopilot\Api\Controller;

use ForumCopilot\Api\ErrorCode;
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
    /**
     * The member's watched forums, in forum list order, as XenForo's
     * "Watched forums" page lists them (Pub WatchedController::actionForums).
     *
     * subscribeMode is a number, as the app reads it: 1 = emails on, 0 = no
     * emails. It used to be XenForo's notify_on text ("thread"), which the
     * app could not read, so its "Subscribed forums" section stayed empty.
     * That text is now notifyOn, next to sendAlert and sendEmail.
     */
    public function actionGetSubscribedForum(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) {
            return $error;
        }

        try {
            $visitor = \XF::visitor();
            
            $finder = $this->finder('XF:ForumWatch');
            $finder->where('user_id', $visitor->user_id);
            $finder->with('Forum', true);
            $finder->with('Forum.Node', true);
            $finder->with([
                'Forum.Node.Permissions|' . $visitor->permission_combination_id,
                'Forum.Read|' . $visitor->user_id,
            ]);
            $finder->order('Forum.Node.lft');
            
            $watches = $finder->fetch();

            $forumList = [];
            foreach ($watches as $watch) {
                $forum = $watch->Forum;
                if (!$forum || !$forum->Node || !$forum->canView()) {
                    continue;
                }

                $node = $forum->Node;
                // Counts need "View others' threads", as on getForum and the forum list
                $hasViewOthers = $visitor->hasNodePermission($forum->node_id, 'viewOthers');
                $watchStatus = $this->getForumWatchStatus($forum, $visitor, $watch);

                $forumList[] = [
                    'id' => (string)$forum->node_id,
                    'name' => $node->title,
                    'description' => $node->description,
                    'parentId' => $node->parent_node_id ? (string)$node->parent_node_id : '',
                    'threadCount' => $hasViewOthers ? $forum->discussion_count : 0,
                    'postCount' => $hasViewOthers ? $forum->message_count : 0,
                    'canPost' => $forum->canCreateThread(),
                    'canViewContent' => $forum->canViewThreadContent(),
                    'isRead' => !$forum->isUnread(),
                    'url' => $this->buildLink('canonical:forums', $forum),
                    'subscribeMode' => $watchStatus['sendEmail'] ? 1 : 0,
                    'notifyOn' => $watchStatus['notifyOn'],
                    'sendAlert' => $watchStatus['sendAlert'],
                    'sendEmail' => $watchStatus['sendEmail'],
                    'allowedWatchNotifications' => $watchStatus['allowedWatchNotifications'],
                ];
            }

            $result = new FCSubscribedForumResult(
                true,
                null,
                count($forumList),
                $forumList
            );

            return $this->apiSuccess($result);

        } catch (\Throwable $e) {
            return $this->apiException($e, 'Failed to get subscribed forums');
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
            return $this->apiError('Invalid parameters: ' . implode(', ', $errors), null, ErrorCode::BAD_REQUEST);
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
                    return $this->apiError('Cannot subscribe to this forum', null, ErrorCode::NO_PERMISSION);
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

        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to subscribe to forum');
        }
    }

    public function actionUnsubscribeForum(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $forumId = $params->get('forumId', '');

        if (empty($forumId)) {
            return $this->apiError('Forum ID is required', null, ErrorCode::BAD_REQUEST);
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

        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to unsubscribe from forum');
        }
    }

    /**
     * The member's watched threads, as XenForo's "Watched threads" page
     * lists them (ThreadRepository::findThreadsForWatchedList): threads the
     * member watches, newest activity first, however old.
     *
     * It used to be What's New with a "watched" filter: every recent thread
     * in a watched forum was listed too, and a watched thread with no post
     * in the last 30 days dropped off the list, so it could not be unwatched
     * from the app.
     */
    public function actionGetSubscribedTopic(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        // Same paging params, defaults and checks as getLatestTopic
        $fcParams = XenForoParamAdapter::toGetLatestTopicParams($params);
        $errors = $fcParams->validate();
        if (!empty($errors)) {
            return $this->apiError('Invalid parameters: ' . implode(', ', $errors), null, ErrorCode::BAD_REQUEST);
        }

        try {
            $visitor = \XF::visitor();

            $finder = $this->repository('XF:Thread')->findThreadsForWatchedList();
            // XenForo filters each page by canView; leaving out forums the
            // member can't see first keeps pages full and the total right.
            $finder->where('node_id', $this->repository('XF:Forum')->getViewableForums()->keys());

            // Build topic list (use last post for preview to match original behavior)
            $result = $this->buildTopicListFromFinder(
                $finder,
                $fcParams->startNum,
                $fcParams->lastNum,
                ['useLastPost' => true]
            );

            return $this->apiSuccess(new FCSubscribedTopicResult(
                true,
                null,
                $result['total'],
                $result['topics']
            ));

        } catch (\Throwable $e) {
            return $this->apiException($e, 'Failed to get subscribed topics');
        }
    }

    public function actionSubscribeTopic(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $topicId = $params->get('topicId', '');
        $subscribeMode = $params->get('subscribeMode', 0);

        if (empty($topicId)) {
            return $this->apiError('Topic ID is required', null, ErrorCode::BAD_REQUEST);
        }

        try {
            $thread = $this->assertViewableThread($topicId);
            $visitor = \XF::visitor();

            if (!$thread->canWatch()) {
                return $this->apiError('Cannot subscribe to this topic', null, ErrorCode::NO_PERMISSION);
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

        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to subscribe to topic');
        }
    }

    public function actionUnsubscribeTopic(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $topicId = $params->get('topicId', '');

        if (empty($topicId)) {
            return $this->apiError('Topic ID is required', null, ErrorCode::BAD_REQUEST);
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

        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to unsubscribe from topic');
        }
    }
}
