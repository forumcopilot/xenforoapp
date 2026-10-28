<?php

namespace ForumCopilot\Api\Controller;

use ForumCopilot\Api\ErrorCode;
use XF\Mvc\ParameterBag;
use XF\Mvc\Entity\AbstractCollection;
use ForumCopilot\Result\FCLikePostResult;
use ForumCopilot\Result\FCUnlikePostResult;
use ForumCopilot\Result\FCFollowResult;
use ForumCopilot\Result\FCUnfollowResult;
use ForumCopilot\Result\FCAlertResult;
use ForumCopilot\Adapter\XenForoParamAdapter;

/**
 * Social Controller for ForumCopilot API
 * Handles social features like likes, follows, alerts
 */
class SocialController extends AbstractController
{
    public function actionLikePost(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        // Convert XenForo ParameterBag to forum-agnostic parameter class
        $fcParams = XenForoParamAdapter::toLikePostParams($params);
        
        // Validate parameters
        $errors = $fcParams->validate();
        if (!empty($errors)) {
            return $this->apiError('Invalid parameters: ' . implode(', ', $errors), null, ErrorCode::BAD_REQUEST);
        }

        try {
            $post = $this->assertViewablePost($fcParams->postId);

            // The reaction the member picked: added, switched, or toggled
            // off when it is the one they already have. reactionId defaults
            // to 1 (Like) for app builds that don't send it.
            $reacted = $this->toggleVisitorReaction($post, (int)$fcParams->reactionId);
            if (!is_array($reacted)) {
                return $reacted;
            }
            $visitorReactionId = $reacted['reactionId'];

            // Refresh the post so its reaction counts reflect the change.
            $post = $this->em()->find('XF:Post', $post->post_id);

            $result = new FCLikePostResult(
                true,
                null,
                $visitorReactionId !== null,
                $this->getReactionCount($post),
                $visitorReactionId
            );

            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to like post');
        }
    }

    public function actionUnlikePost(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $postId = $params->get('postId', '');

        if (empty($postId)) {
            return $this->apiError('Post ID is required', null, ErrorCode::BAD_REQUEST);
        }

        try {
            $post = $this->assertViewablePost($postId);

            if ($error = $this->removeVisitorReaction($post)) {
                return $error;
            }

            // Refresh the post so its reaction counts reflect the change.
            $post = $this->em()->find('XF:Post', $post->post_id);

            $result = new FCUnlikePostResult(
                true,
                null,
                false,
                $this->getReactionCount($post)
            );

            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to unlike post');
        }
    }

    public function actionFollow(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $userId = $params->get('userId', '');

        if (empty($userId)) {
            return $this->apiError('User ID is required', null, ErrorCode::BAD_REQUEST);
        }

        try {
            // A non-numeric id is a username (the SDK passes one identifier).
            $user = is_numeric($userId)
                ? $this->em()->find('XF:User', (int)$userId)
                : $this->em()->findOne('XF:User', ['username' => $userId]);
            if (!$user) {
                return $this->apiError('User not found', null, ErrorCode::NOT_FOUND);
            }

            $visitor = \XF::visitor();

            // As XenForo's MemberController::actionFollow: the profile must be
            // viewable, and canFollowUser applies unless already following
            $error = null;
            if (!$user->canViewBasicProfile($error)) {
                return $this->apiError($error ?: \XF::phrase('do_not_have_permission'), null, ErrorCode::NO_PERMISSION);
            }
            if ($visitor->isFollowing($user)) {
                return $this->apiSuccess(new FCFollowResult(true, null, true));
            }
            if (!$visitor->canFollowUser($user)) {
                return $this->apiError(\XF::phrase('you_not_currently_able_to_follow_this_user'), null, ErrorCode::NO_PERMISSION);
            }

            // XF:User\Follow on 2.2; aliased to FollowService on 2.3. It saves
            // without throwing, so its refusals (the follow limit) are errors.
            $userFollow = $this->service('XF:User\Follow', $user, $visitor)->follow();
            if ($userFollow && $userFollow->hasErrors()) {
                return $this->apiFieldErrors($userFollow->getErrors());
            }

            $result = new FCFollowResult(true, null, true);
            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to follow user');
        }
    }

    /**
     * Ignore a member (1.11.0), as XenForo's Ignore button
     * (MemberController::actionIgnore): their content shows collapsed
     * (isIgnored on posts and messages), and their conversations and alerts
     * stop. Staff can't be ignored. Params: userId (an id or a user name).
     */
    public function actionIgnoreUser(ParameterBag $params)
    {
        return $this->setIgnored($params, true);
    }

    /**
     * Stop ignoring a member (1.11.0). Params: userId (an id or a user name).
     */
    public function actionUnignoreUser(ParameterBag $params)
    {
        return $this->setIgnored($params, false);
    }

    protected function setIgnored(ParameterBag $params, bool $ignore)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $userId = $params->get('userId', '');
        if (!is_scalar($userId) || (string)$userId === '') {
            return $this->apiError('User ID is required', null, ErrorCode::BAD_REQUEST);
        }

        try {
            $user = is_numeric($userId)
                ? $this->em()->find('XF:User', (int)$userId)
                : $this->em()->findOne('XF:User', ['username' => (string)$userId]);
            if (!$user) {
                return $this->apiError(\XF::phrase('requested_user_not_found'), null, ErrorCode::NOT_FOUND);
            }

            $visitor = \XF::visitor();
            $error = null;
            if (!$user->canViewBasicProfile($error)) {
                return $this->apiError($error ?: \XF::phrase('do_not_have_permission'), null, ErrorCode::NO_PERMISSION);
            }

            $isIgnoring = $visitor->isIgnoring($user);
            if ($ignore !== $isIgnoring) {
                if ($ignore && !$visitor->canIgnoreUser($user, $error)) {
                    return $this->apiError($error ?: \XF::phrase('do_not_have_permission'), null, ErrorCode::NO_PERMISSION);
                }

                // XF:User\Ignore on 2.2; aliased to IgnoreService on 2.3
                $service = $this->service('XF:User\Ignore', $user, $visitor);
                $userIgnored = $ignore ? $service->ignore() : $service->unignore();
                if ($userIgnored && $userIgnored->hasErrors()) {
                    return $this->apiFieldErrors($userIgnored->getErrors());
                }
            }

            return $this->apiSuccess(['isIgnored' => $ignore]);

        } catch (\Throwable $e) {
            return $this->apiException($e, $ignore ? 'Failed to ignore member' : 'Failed to unignore member');
        }
    }

    /**
     * The members the visitor ignores (1.11.0), by name, as XenForo's
     * account "Ignoring" page lists them.
     */
    public function actionGetIgnoredUsers(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        try {
            $visitor = \XF::visitor();
            $ignored = $visitor->Profile ? (array)$visitor->Profile->ignored : [];

            $list = [];
            if ($ignored) {
                $users = $this->finder('XF:User')
                    ->where('user_id', array_keys($ignored))
                    ->order('username')
                    ->fetch();
                foreach ($users as $user) {
                    $list[] = [
                        'id' => (string)$user->user_id,
                        'username' => $user->username,
                        'iconUrl' => $this->getAbsoluteUrl($user->getAvatarUrl('s')),
                    ];
                }
            }

            return $this->apiSuccess(['total' => count($list), 'list' => $list]);

        } catch (\Throwable $e) {
            return $this->apiException($e, 'Failed to get ignored members');
        }
    }

    public function actionUnfollow(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $userId = $params->get('userId', '');

        if (empty($userId)) {
            return $this->apiError('User ID is required', null, ErrorCode::BAD_REQUEST);
        }

        try {
            // A non-numeric id is a username (the SDK passes one identifier).
            $user = is_numeric($userId)
                ? $this->em()->find('XF:User', (int)$userId)
                : $this->em()->findOne('XF:User', ['username' => $userId]);
            if (!$user) {
                return $this->apiError('User not found', null, ErrorCode::NOT_FOUND);
            }

            $visitor = \XF::visitor();
            $this->service('XF:User\Follow', $user, $visitor)->unfollow();

            $result = new FCUnfollowResult(true, null, false);
            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to unfollow user');
        }
    }

    /**
     * getAlert's optional marking params: markAllRead (bool), markReadIds and
     * markUnreadIds (alert ids). Only the visitor's own alerts are touched.
     */
    protected function applyAlertMarking(ParameterBag $params, \XF\Entity\User $visitor, $alertRepo)
    {
        if ($params->get('markAllRead')) {
            $alertRepo->markUserAlertsRead($visitor);
        }

        foreach (['markReadIds' => true, 'markUnreadIds' => false] as $key => $read) {
            $ids = $params->get($key);
            if (!is_array($ids) || !$ids) {
                continue;
            }
            $ids = array_slice(array_filter(array_map('intval', $ids)), 0, 100);
            $alerts = $this->finder('XF:UserAlert')
                ->where('alert_id', $ids)
                ->where('alerted_user_id', $visitor->user_id)
                ->fetch();
            foreach ($alerts as $alert) {
                if ($read) {
                    $alertRepo->markUserAlertRead($alert);
                } elseif (method_exists($alertRepo, 'markUserAlertUnread')) {
                    $alertRepo->markUserAlertUnread($alert);
                }
            }
        }
    }

    public function actionGetAlert(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $page = max(1, (int)$params->get('page', 1));
        $perpage = max(1, min(100, (int)$params->get('perpage', 20)));
        // Optional (1.11.0): leave alerts as they are, like XenForo's
        // skip_mark_read on its alert list
        $skipMarkRead = (bool)$params->get('skipMarkRead', false);
        // Optional (1.11.0): only alerts not read yet
        $unreadOnly = (bool)$params->get('unreadOnly', false);

        try {
            $visitor = \XF::visitor();
            
            // Use the same method as the web interface
            $alertRepo = $this->repository('XF:UserAlert');

            // Optional (1.11.0): mark alerts read or unread before listing,
            // as XenForo's alert toggle and "Mark read" do
            $this->applyAlertMarking($params, $visitor, $alertRepo);
            // The list below reads the alerts again, not the marked copies
            $this->em()->clearEntityCache('XF:UserAlert');

            $alertsFinder = $alertRepo->findAlertsForUser($visitor->user_id);
            // After XenForo's newest-first: alerts from the same second stay in
            // one order from page to page
            $alertsFinder->order('alert_id', 'DESC');
            if ($unreadOnly) {
                $alertsFinder->where('read_date', 0);
            }
            
            $alerts = $alertsFinder->limitByPage($page, $perpage)->fetch();
            
            // Add content to alerts (required for proper rendering)
            $alertRepo->addContentToAlerts($alerts);
            
            // Mark inaccessible alerts as read if needed (same as web interface)
            $this->markInaccessibleAlertsReadIfNeeded($alerts);
            
            // Filter out alerts that can't be viewed (same as web interface)
            $viewableAlerts = $alerts->filterViewable();
            
            // As XenForo's alert list (AccountController::actionAlerts): the
            // shown alerts that read themselves are marked read, and every
            // alert is marked viewed (the badge) when the first page loads.
            if (!$skipMarkRead) {
                $alertRepo->autoMarkUserAlertsRead($viewableAlerts, $visitor);
                if ($page == 1 && $visitor->alerts_unviewed) {
                    $alertRepo->markUserAlertsViewed($visitor);
                }
            }
            
            // All of the member's alerts, for paging (XenForo's totalAlerts)
            $total = $alertsFinder->total();

            $alertList = [];
            // Process viewable alerts
            foreach ($viewableAlerts as $alert) {
                try {
                    // Load ActionUser - use the User relation if available
                    $actionUser = null;
                    if ($alert->User) {
                        $actionUser = $alert->User;
                    } elseif ($alert->user_id) {
                        $actionUser = $this->em()->find('XF:User', $alert->user_id);
                    }
                    
                    // Get alert message using the render method (same as web interface)
                    $alertMessage = '';
                    try {
                        // Use the render method which properly formats the alert
                        $alertMessage = $alert->render();
                        
                        // Clean up the message: strip HTML tags, decode entities, normalize whitespace
                        $alertMessage = strip_tags($alertMessage);
                        $alertMessage = html_entity_decode($alertMessage, ENT_QUOTES | ENT_HTML5, 'UTF-8');
                        // Normalize whitespace: replace multiple whitespace/newlines with single space
                        $alertMessage = preg_replace('/\s+/', ' ', $alertMessage);
                        // Trim leading/trailing whitespace
                        $alertMessage = trim($alertMessage);
                    } catch (\Exception $e) {
                        // Fallback: construct message from alert data
                        $alertMessage = ($alert->username ?: '') . ' ' . $alert->action;
                    }
                    
                    // Get action URL from the alert handler
                    $actionUrl = '';
                    try {
                        $handler = $alert->getHandler();
                        if ($handler) {
                            $apiOutput = $handler->getApiOutput($alert);
                            if ($apiOutput && isset($apiOutput['url'])) {
                                $actionUrl = $apiOutput['url'];
                            }
                        }
                    } catch (\Exception $e) {
                        // If method fails, try to build URL from content
                        try {
                            $content = $alert->Content;
                            if ($content && method_exists($content, 'getContentUrl')) {
                                $actionUrl = $content->getContentUrl();
                            }
                        } catch (\Exception $e2) {
                            // If that also fails, leave empty
                        }
                    }
                    
                    // Build base alert data
                    $alertData = [
                        'id' => (string)$alert->alert_id,
                        'type' => $alert->content_type,
                        'message' => $alertMessage,
                        'timestamp' => $alert->event_date * 1000,
                        // "Viewed" (the badge), as it always was; isUnread
                        // is XenForo's read state (1.11.0)
                        'isRead' => $alert->view_date > 0,
                        'isUnread' => method_exists($alert, 'isUnreadInUi') ? $alert->isUnreadInUi() : !$alert->read_date,
                        'isUnviewed' => !$alert->view_date,
                        'readDate' => $alert->read_date ? $alert->read_date * 1000 : 0,
                        'viewDate' => $alert->view_date ? $alert->view_date * 1000 : 0,
                        'autoRead' => (bool)$alert->auto_read,
                        'actionUrl' => $actionUrl,
                        'fromUserId' => $alert->user_id ? (string)$alert->user_id : null,
                        'fromUsername' => $alert->username,
                        'fromUserIconUrl' => $actionUser ? $this->getAbsoluteUrl($actionUser->getAvatarUrl('s')) : null,
                        'action' => $alert->action,
                        'contentId' => (string)$alert->content_id,
                    ];
                    
                    // Add type-specific IDs based on alert content type
                    $content = $alert->Content;
                    if ($content) {
                        switch ($alert->content_type) {
                            case 'post':
                                // For post type, add post_id
                                if (isset($content->post_id)) {
                                    $alertData['postId'] = (string)$content->post_id;
                                }
                                // Also add topic_id (thread_id) for post type alerts
                                if (isset($content->thread_id)) {
                                    $alertData['topicId'] = (string)$content->thread_id;
                                }
                                break;
                                
                            case 'thread':
                                // For thread type, add topic_id (thread_id)
                                if (isset($content->thread_id)) {
                                    $alertData['topicId'] = (string)$content->thread_id;
                                }
                                break;
                                
                            case 'conversation_message':
                                // For conversation_message type, add conversation_id
                                if (isset($content->conversation_id)) {
                                    $alertData['conversationId'] = (string)$content->conversation_id;
                                }
                                break;
                                
                            case 'profile_post':
                                // For profile_post type, add profile_post_id
                                if (isset($content->profile_post_id)) {
                                    $alertData['profilePostId'] = (string)$content->profile_post_id;
                                }
                                // Also add profile_user_id (the user whose profile it's on)
                                if (isset($content->profile_user_id)) {
                                    $alertData['profileUserId'] = (string)$content->profile_user_id;
                                }
                                break;
                                
                            case 'profile_post_comment':
                                // For profile_post_comment type, add profile_post_comment_id
                                if (isset($content->profile_post_comment_id)) {
                                    $alertData['profilePostCommentId'] = (string)$content->profile_post_comment_id;
                                }
                                // Also add profile_post_id (the parent profile post)
                                if (isset($content->profile_post_id)) {
                                    $alertData['profilePostId'] = (string)$content->profile_post_id;
                                }
                                break;
                                
                            case 'report':
                                // For report type, add report_id
                                if (isset($content->report_id)) {
                                    $alertData['reportId'] = (string)$content->report_id;
                                }
                                break;
                                
                            case 'trophy':
                                // For trophy type, add trophy_id
                                if (isset($content->trophy_id)) {
                                    $alertData['trophyId'] = (string)$content->trophy_id;
                                }
                                break;
                                
                            case 'user':
                                // For user type, add user_id (the user being followed/mentioned)
                                if (isset($content->user_id)) {
                                    $alertData['userId'] = (string)$content->user_id;
                                }
                                break;
                        }
                    }
                    
                    $alertList[] = $alertData;
                } catch (\Exception $e) {
                    // Log error but continue processing other alerts
                    // Skip this alert if there's an error
                    continue;
                }
            }

            // total counts every alert, so the app's "page * perpage < total"
            // finds the next page. It was the number shown on this page,
            // which ended the list after the first page.
            $result = new FCAlertResult(
                true,
                null,
                (int)$total,
                $alertList
            );

            // Get updated visitor counts after marking alerts as viewed
            // Refetch visitor to get fresh data from database
            $visitor = $this->em()->find('XF:User', $visitor->user_id);
            
            // Add visitor counts to response (similar to web interface)
            $responseData = $result->toArray();
            $responseData['visitor'] = [
                'conversations_unread' => (string)$visitor->conversations_unread,
                'alerts_unviewed' => (string)$visitor->alerts_unviewed,
                'total_unread' => (string)($visitor->conversations_unread + $visitor->alerts_unviewed),
            ];

            // Create response manually to include visitor counts
            $response = $this->app->response();
            $response->contentType('application/json', 'utf-8');
            $this->addLoginStatusHeader($response);
            $response->body(json_encode($responseData));
            $response->httpCode(200);
            
            return $response;

        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to get alerts');
        }
    }

    /**
     * Mark inaccessible alerts as read if needed
     * Same logic as AccountController::markInaccessibleAlertsReadIfNeeded
     * 
     * @param AbstractCollection|null $displayedAlerts
     */
    protected function markInaccessibleAlertsReadIfNeeded(?AbstractCollection $displayedAlerts = null)
    {
        $visitor = \XF::visitor();

        if (!$visitor->alerts_unread)
        {
            return;
        }

        if ($displayedAlerts)
        {
            $hasInaccessibleUnread = false;
            $showingUnread = false;
            foreach ($displayedAlerts AS $alert)
            {
                /** @var \XF\Entity\UserAlert $alert */
                if ($alert->isUnread())
                {
                    $showingUnread = true;

                    if (!$alert->canView())
                    {
                        $hasInaccessibleUnread = true;
                    }
                }
            }

            if ($showingUnread && !$hasInaccessibleUnread)
            {
                // If we have unread on this page, we know we're still going to have some unread alerts left.
                // However, if we detect an inaccessible alert, let's do a check on the alerts to try to
                // sort out anything that might still be stuck.
                return;
            }
        }

        $alertRepo = $this->repository('XF:UserAlert');
        $alertRepo->markInaccessibleAlertsRead($visitor);
    }
}
