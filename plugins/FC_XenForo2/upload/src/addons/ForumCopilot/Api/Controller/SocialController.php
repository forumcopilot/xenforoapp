<?php

namespace ForumCopilot\Api\Controller;

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
            return $this->apiError('Invalid parameters: ' . implode(', ', $errors));
        }

        try {
            $post = $this->assertViewablePost($fcParams->postId);
            $visitor = \XF::visitor();

            // Check if can like/react (like Tapatalk does)
            $canLike = false;
            $error = null;
            if (method_exists($post, 'canReact')) {
                $canLike = $post->canReact($error);
            } elseif (method_exists($post, 'canLike')) {
                $canLike = $post->canLike($error);
            }
            
            if (!$canLike) {
                $errorMessage = $error ? (is_string($error) ? $error : 'Cannot like this post') : 'Cannot like this post';
                return $this->apiError($errorMessage);
            }

            // Use like system (like Tapatalk does)
            $contentType = 'post'; // Use 'post' directly, not getEntityContentType()
            $contentId = $post->post_id; // Use post_id directly
            
            // Check if already reacted/liked
            $isReacted = false;
            try {
                if (method_exists($post, 'isReactedTo')) {
                    $isReacted = $post->isReactedTo();
                } else {
                    $isReacted = $post->isLiked();
                }
            } catch (\Exception $e) {
                // If check fails, assume not liked and proceed
                $isReacted = false;
            }
            
            if ($isReacted) {
                // Already liked, return current state (like Tapatalk does)
                $result = new FCLikePostResult(
                    true,
                    null,
                    true,
                    isset($post->reaction_score) ? (int)$post->reaction_score : 0
                );
            } else {
                // Use like system (like Tapatalk does)
                $contentType = 'post';
                $contentId = $post->post_id;
                
                // Check if reaction system is available (like Tapatalk does)
                if (class_exists('\XF\ControllerPlugin\Reaction')) {
                    try {
                        $reactionRepo = $this->repository('XF:Reaction');
                        $reaction = $reactionRepo->insertReaction(1, 'post', $contentId, $visitor, true, false);
                        
                        // Refresh post
                        $post = $this->em()->find('XF:Post', $post->post_id);
                        
                        $result = new FCLikePostResult(
                            true,
                            null,
                            true,
                            isset($post->reaction_score) ? (int)$post->reaction_score : 0
                        );
                    } catch (\Exception $e) {
                        return $this->apiError('Failed to like post: ' . $e->getMessage());
                    }
                } else {
                    // Use old like system
                    try {
                        $likeRepo = $this->repository('XF:LikedContent');
                        $like = $likeRepo->toggleLike($contentType, $contentId, $visitor);
                        
                        // Refresh post
                        $post = $this->em()->find('XF:Post', $post->post_id);
                        
                        $isLiked = false;
                        try {
                            $isLiked = $post->isLiked();
                        } catch (\Exception $e) {
                            $isLiked = true;
                        }
                        
                        $result = new FCLikePostResult(
                            true,
                            null,
                            $isLiked,
                            isset($post->reaction_score) ? (int)$post->reaction_score : 0
                        );
                    } catch (\Exception $e) {
                        return $this->apiError('Failed to like post: ' . $e->getMessage());
                    }
                }
            }

            return $this->apiSuccess($result);

        } catch (\XF\Mvc\Reply\Exception $e) {
            // Extract XenForo's error message from the exception
            $errorMsg = $this->extractErrorMessageFromReplyException($e, 'Post not found or not accessible');
            return $this->apiError($errorMsg);
        } catch (\Exception $e) {
            return $this->apiError('Failed to like post: ' . $e->getMessage());
        }
    }

    public function actionUnlikePost(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $postId = $params->get('postId', '');

        if (empty($postId)) {
            return $this->apiError('Post ID is required');
        }

        try {
            $post = $this->assertViewablePost($postId);
            $visitor = \XF::visitor();

            // Check if can like/react (like Tapatalk does)
            $canLike = false;
            $error = null;
            if (method_exists($post, 'canReact')) {
                $canLike = $post->canReact($error);
            } elseif (method_exists($post, 'canLike')) {
                $canLike = $post->canLike($error);
            }
            
            if (!$canLike) {
                $errorMessage = $error ? (is_string($error) ? $error : 'Cannot unlike this post') : 'Cannot unlike this post';
                return $this->apiError($errorMessage);
            }

            // Use like system (like Tapatalk does)
            $contentType = 'post'; // Use 'post' directly, not getEntityContentType()
            $contentId = $post->post_id; // Use post_id directly
            
            // Check if already reacted/liked
            $isReacted = false;
            try {
                if (method_exists($post, 'isReactedTo')) {
                    $isReacted = $post->isReactedTo();
                } else {
                    $isReacted = $post->isLiked();
                }
            } catch (\Exception $e) {
                // If check fails, assume not liked and return
                $result = new FCUnlikePostResult(
                    true,
                    null,
                    false,
                    isset($post->reaction_score) ? (int)$post->reaction_score : 0
                );
                return $this->apiSuccess($result);
            }
            
            if (!$isReacted) {
                // Not liked, return current state (like Tapatalk does)
                $result = new FCUnlikePostResult(
                    true,
                    null,
                    false,
                    isset($post->reaction_score) ? (int)$post->reaction_score : 0
                );
            } else {
                // Use unlike system (like Tapatalk does)
                $contentType = 'post';
                $contentId = $post->post_id;
                
                // Check if reaction system is available (like Tapatalk does)
                if (class_exists('\XF\ControllerPlugin\Reaction')) {
                    try {
                        $reactionRepo = $this->repository('XF:Reaction');
                        $existingReaction = $reactionRepo->getReactionByContentAndReactionUser('post', $contentId, $visitor->user_id);
                        if ($existingReaction && $existingReaction->reaction_id) {
                            $existingReaction->setOption('is_like_only', false);
                            $existingReaction->delete();
                        }
                        
                        // Refresh post
                        $post = $this->em()->find('XF:Post', $post->post_id);
                        
                        $result = new FCUnlikePostResult(
                            true,
                            null,
                            false,
                            isset($post->reaction_score) ? (int)$post->reaction_score : 0
                        );
                    } catch (\Exception $e) {
                        return $this->apiError('Failed to unlike post: ' . $e->getMessage());
                    }
                } else {
                    // Use old like system
                    try {
                        $likeRepo = $this->repository('XF:LikedContent');
                        $likeRepo->toggleLike($contentType, $contentId, $visitor);
                        
                        // Refresh post
                        $post = $this->em()->find('XF:Post', $post->post_id);
                        
                        $result = new FCUnlikePostResult(
                            true,
                            null,
                            false,
                            isset($post->reaction_score) ? (int)$post->reaction_score : 0
                        );
                    } catch (\Exception $e) {
                        return $this->apiError('Failed to unlike post: ' . $e->getMessage());
                    }
                }
            }

            return $this->apiSuccess($result);

        } catch (\XF\Mvc\Reply\Exception $e) {
            // Extract XenForo's error message from the exception
            $errorMsg = $this->extractErrorMessageFromReplyException($e, 'Post not found or not accessible');
            return $this->apiError($errorMsg);
        } catch (\Exception $e) {
            return $this->apiError('Failed to unlike post: ' . $e->getMessage());
        }
    }

    public function actionFollow(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $userId = $params->get('userId', '');

        if (empty($userId)) {
            return $this->apiError('User ID is required');
        }

        try {
            $user = $this->em()->find('XF:User', $userId);
            if (!$user) {
                return $this->apiError('User not found');
            }

            $visitor = \XF::visitor();
            
            if (!$visitor->canFollow($user)) {
                return $this->apiError('Cannot follow this user');
            }

            $visitor->follow($user);

            $result = new FCFollowResult(true, null, true);
            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiError('Failed to follow user: ' . $e->getMessage());
        }
    }

    public function actionUnfollow(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $userId = $params->get('userId', '');

        if (empty($userId)) {
            return $this->apiError('User ID is required');
        }

        try {
            $user = $this->em()->find('XF:User', $userId);
            if (!$user) {
                return $this->apiError('User not found');
            }

            $visitor = \XF::visitor();
            $visitor->unfollow($user);

            $result = new FCUnfollowResult(true, null, false);
            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiError('Failed to unfollow user: ' . $e->getMessage());
        }
    }

    public function actionGetAlert(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $page = $params->get('page', 1);
        $perpage = $params->get('perpage', 20);
        $forceRefresh = $params->get('forceRefresh', false);

        try {
            $visitor = \XF::visitor();
            
            // Use the same method as the web interface
            $alertRepo = $this->repository('XF:UserAlert');
            $alertsFinder = $alertRepo->findAlertsForUser($visitor->user_id);
            
            $alerts = $alertsFinder->limitByPage($page, $perpage)->fetch();
            
            // Add content to alerts (required for proper rendering)
            $alertRepo->addContentToAlerts($alerts);
            
            // Mark inaccessible alerts as read if needed (same as web interface)
            $this->markInaccessibleAlertsReadIfNeeded($alerts);
            
            // Filter out alerts that can't be viewed (same as web interface)
            $viewableAlerts = $alerts->filterViewable();
            
            // Auto-mark alerts as read (same as actionAlertsPopup)
            $alertRepo->autoMarkUserAlertsRead($alerts, $visitor);
            
            // Mark all alerts as viewed to reset badge (same as actionAlertsPopup)
            if ($visitor->alerts_unviewed)
            {
                $alertRepo->markUserAlertsViewed($visitor);
            }
            
            // Get total before filtering (same as web interface)
            $total = $alertsFinder->total();
            
            // Count viewable alerts for accurate total
            $viewableCount = count($viewableAlerts);

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
                        'isRead' => $alert->view_date > 0,
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

            // Use viewable count if we have filtered alerts, otherwise use total
            $resultTotal = $viewableCount > 0 ? $viewableCount : $total;
            
            $result = new FCAlertResult(
                true,
                null,
                (int)$resultTotal,
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
            $response->header('Content-Type', 'application/json; charset=UTF-8');
            $this->addLoginStatusHeader($response);
            $response->body(json_encode($responseData));
            $response->httpCode(200);
            
            return $response;

        } catch (\Exception $e) {
            return $this->apiError('Failed to get alerts: ' . $e->getMessage());
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
