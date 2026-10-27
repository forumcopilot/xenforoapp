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
                    'canViewContent' => $visitor->hasNodePermission($forum->node_id, 'viewContent'),
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

    /**
     * Watches a forum, as XenForo's "Watch forum" form does
     * (Pub ForumController::actionWatch).
     *
     * Optional params (1.11.0), the form's options: notifyOn ("thread",
     * "message" or "" for none, limited to what the forum allows), sendAlert
     * and sendEmail. Options not sent keep the watch's current value, or for
     * a new watch take today's defaults: new threads, alerts on, emails when
     * subscribeMode is 1.
     *
     * When the forum is already watched and none of the options are sent
     * (a 1.x app only sends subscribeMode), the watch is left as it is: the
     * app used to reset options chosen on the website.
     *
     * forumId "ALL" changes one option on every watched forum, as the
     * Watched forums page's "manage" menu does: emails (sendEmail, or
     * subscribeMode 1/0), and alerts when sendAlert is sent.
     */
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
            $forumWatchRepo = $this->repository('XF:ForumWatch');

            if ($fcParams->forumId === 'ALL') {
                $sendEmail = $fcParams->sendEmail ?? ($fcParams->subscribeMode == 1);
                $forumWatchRepo->setWatchStateForAll($visitor, $sendEmail ? 'watch_email' : 'watch_no_email');
                if ($fcParams->sendAlert !== null) {
                    $forumWatchRepo->setWatchStateForAll($visitor, $fcParams->sendAlert ? 'watch_alert' : 'watch_no_alert');
                }

                return $this->apiSuccess(new FCSubscribeForumResult(true, null));
            }

            $forum = $this->assertViewableForum($fcParams->forumId);

            $error = null;
            if (!$forum->canWatch($error)) {
                return $this->apiError($error ?: \XF::phrase('do_not_have_permission'), null, ErrorCode::NO_PERMISSION);
            }

            /** @var \XF\Entity\ForumWatch|null $watch */
            $watch = $forum->Watch[$visitor->user_id];

            if (!$watch || $fcParams->hasWatchOptions()) {
                $notifyOn = $fcParams->notifyOn ?? ($watch ? $watch->notify_on : 'thread');
                $sendAlert = $fcParams->sendAlert ?? ($watch ? (bool)$watch->send_alert : true);
                $sendEmail = $fcParams->sendEmail ?? ($watch ? (bool)$watch->send_email : $fcParams->subscribeMode == 1);

                // What the forum allows, as actionWatch limits it
                if ($forum->allowed_watch_notifications == 'none') {
                    $notifyOn = '';
                } elseif ($forum->allowed_watch_notifications == 'thread' && $notifyOn == 'message') {
                    $notifyOn = 'thread';
                }

                $forumWatchRepo->setWatchState($forum, $visitor, $notifyOn, $sendAlert, $sendEmail);
                $watch = $this->em()->find('XF:ForumWatch', [
                    'node_id' => $forum->node_id,
                    'user_id' => $visitor->user_id,
                ]);
            }

            $watchStatus = $this->getForumWatchStatus($forum, $visitor, $watch);

            $result = new FCSubscribeForumResult(true, null);
            $result->extra = [
                'isSubscribed' => $watchStatus['isWatched'],
                'notifyOn' => $watchStatus['notifyOn'],
                'sendAlert' => $watchStatus['sendAlert'],
                'sendEmail' => $watchStatus['sendEmail'],
            ];
            return $this->apiSuccess($result);

        } catch (\Throwable $e) {
            return $this->apiException($e, 'Failed to subscribe to forum');
        }
    }

    /**
     * Stops watching a forum, or every forum with "ALL". A watch is removed
     * even when the member can no longer see the forum, as on XenForo's
     * Watched forums page.
     */
    public function actionUnsubscribeForum(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $forumId = $params->get('forumId', '');

        if (!is_scalar($forumId) || (string)$forumId === '') {
            return $this->apiError('Forum ID is required', null, ErrorCode::BAD_REQUEST);
        }

        try {
            $visitor = \XF::visitor();
            $forumWatchRepo = $this->repository('XF:ForumWatch');

            if ($forumId === 'ALL') {
                $forumWatchRepo->setWatchStateForAll($visitor, 'delete');
            } else {
                $watch = is_numeric($forumId) ? $this->em()->find('XF:ForumWatch', [
                    'node_id' => (int)$forumId,
                    'user_id' => $visitor->user_id,
                ]) : null;
                if ($watch) {
                    $watch->delete();
                } else {
                    // Not watched: still say so when the forum doesn't exist
                    $this->assertViewableForum($forumId);
                }
            }

            $result = new FCUnsubscribeForumResult(true, null);
            return $this->apiSuccess($result);

        } catch (\Throwable $e) {
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

    /**
     * Watches a thread, as XenForo's "Watch thread" form does
     * (Pub ThreadController::actionWatch).
     *
     * Optional param (1.11.0): emailSubscribe (bool), the form's "and
     * receive email notifications". Without it subscribeMode decides as
     * before (0 = alerts only, 1-3 = emails too). When the thread is already
     * watched and emailSubscribe isn't sent, the watch is left as it is.
     *
     * topicId "ALL" sets emails on or off for every watched thread, as the
     * Watched threads page's "manage" menu does.
     */
    public function actionSubscribeTopic(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $topicId = $params->get('topicId', '');
        $subscribeMode = $params->get('subscribeMode', 0);
        $emailSubscribe = \ForumCopilot\Params\Subscription\FCSubscribeForumParamsExtended::toOptionalBool(
            $params->get('emailSubscribe', null)
        );

        if (!is_scalar($topicId) || (string)$topicId === '') {
            return $this->apiError('Topic ID is required', null, ErrorCode::BAD_REQUEST);
        }

        // subscribeMode: 0 = no email (alerts only), 1 = instant email, 2/3 = digest
        // (XenForo has no digests, so 1-3 all mean emails)
        if ($emailSubscribe === null) {
            $emailSubscribe = in_array((int)$subscribeMode, [1, 2, 3], true);
            $optionsSent = false;
        } else {
            $optionsSent = true;
        }
        $mode = $emailSubscribe ? 'watch_email' : 'watch_no_email';

        try {
            $visitor = \XF::visitor();
            $threadWatchRepo = $this->repository('XF:ThreadWatch');

            if ($topicId === 'ALL') {
                $threadWatchRepo->setWatchStateForAll($visitor, $mode);
                return $this->apiSuccess(new FCSubscribeTopicResult(true, null));
            }

            $thread = $this->assertViewableThread($topicId);

            $error = null;
            if (!$thread->canWatch($error)) {
                return $this->apiError($error ?: \XF::phrase('do_not_have_permission'), null, ErrorCode::NO_PERMISSION);
            }

            /** @var \XF\Entity\ThreadWatch|null $watch */
            $watch = $thread->Watch[$visitor->user_id];
            if (!$watch || $optionsSent) {
                $threadWatchRepo->setWatchState($thread, $visitor, $mode);
            } else {
                $mode = $watch->email_subscribe ? 'watch_email' : 'watch_no_email';
            }

            $result = new FCSubscribeTopicResult(true, null);
            $result->extra = [
                'isSubscribed' => true,
                'emailSubscribe' => $mode === 'watch_email',
            ];
            return $this->apiSuccess($result);

        } catch (\Throwable $e) {
            return $this->apiException($e, 'Failed to subscribe to topic');
        }
    }

    /**
     * Stops watching a thread, or every thread with "ALL". A watch is removed
     * even when the member can no longer see the thread (moved to a staff
     * forum, deleted), as on XenForo's Watched threads page.
     */
    public function actionUnsubscribeTopic(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $topicId = $params->get('topicId', '');

        if (!is_scalar($topicId) || (string)$topicId === '') {
            return $this->apiError('Topic ID is required', null, ErrorCode::BAD_REQUEST);
        }

        try {
            $visitor = \XF::visitor();
            $threadWatchRepo = $this->repository('XF:ThreadWatch');

            if ($topicId === 'ALL') {
                $threadWatchRepo->setWatchStateForAll($visitor, 'delete');
            } else {
                $watch = $this->em()->find('XF:ThreadWatch', [
                    'thread_id' => (int)$topicId,
                    'user_id' => $visitor->user_id,
                ]);
                if ($watch) {
                    $watch->delete();
                } else {
                    // Not watched: still say so when the thread doesn't exist
                    $this->assertViewableThread($topicId);
                }
            }

            $result = new FCUnsubscribeTopicResult(true, null);
            return $this->apiSuccess($result);

        } catch (\Throwable $e) {
            return $this->apiException($e, 'Failed to unsubscribe from topic');
        }
    }
}
