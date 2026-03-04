<?php

namespace ForumCopilot\Api\Controller;

use XF\Http\Response;
use XF\Mvc\Controller;
use XF\Mvc\ParameterBag;
use XF\Mvc\Reply\AbstractReply;
use ForumCopilot\Result\FCResult;
use ForumCopilot\Entity\FCTopic;

/**
 * Abstract Controller for ForumCopilot API
 * Extends XenForo web Controller but provides API-specific methods
 */
abstract class AbstractController extends Controller
{
    protected function preDispatchType($action, ParameterBag $params)
    {
        $this->checkCsrfIfNeeded($action, $params);
        // TODO: Add any other pre-dispatch checks if needed
    }

    public function applyReplyChanges($action, ParameterBag $params, AbstractReply &$reply)
    {
        if ($this->responseType && !$reply->getResponseType())
        {
            $reply->setResponseType($this->responseType);
        }
    }

    protected function preDispatchController($action, ParameterBag $params)
    {
        // Can be overridden by child controllers
    }

    /**
     * Check if user has content pending approval
     * Matches XenForo web implementation
     */
    protected function hasContentPendingApproval()
    {
        $pendingUntil = $this->session()->hasContentPendingUntil;
        return ($pendingUntil && $pendingUntil >= \XF::$time);
    }

    /**
     * Set JSON response type
     */
    protected function setJsonResponse()
    {
        $this->setResponseType('json');
    }

    /**
     * API success response
     * Can accept either an FCResult object or an array of data
     * 
     * @param FCResult|array $data FCResult object or array of data
     * @return Response
     */
    protected function apiSuccess($data = []): Response
    {
        // If it's an FCResult object, use its toArray() method
        if ($data instanceof FCResult) {
            $responseData = $data->toArray();
        } else {
            // Otherwise, use the old method for backward compatibility
            return $this->apiResponse(true, 'success', $data);
        }

        // Create and return a proper XF\Http\Response object
        $response = $this->app->response();
        $response->header('Content-Type', 'application/json; charset=UTF-8');
        
        // Add fc_is_login header to indicate if user is logged in
        $this->addLoginStatusHeader($response);
        
        $response->body(json_encode($responseData));
        $response->httpCode(200);
        
        return $response;
    }

    /**
     * API error response
     * Can accept either an FCResult object (for error results) or an error message string
     * 
     * @param string|FCResult $message Error message or FCResult error object
     * @param int|null $code HTTP status code
     * @return Response
     */
    protected function apiError($message, $code = null): Response
    {
        // If it's an FCResult object, use its toArray() method
        if ($message instanceof FCResult) {
            $responseData = $message->toArray();
            
            // Create and return a proper XF\Http\Response object
            $response = $this->app->response();
            $response->header('Content-Type', 'application/json; charset=UTF-8');
            
            // Add fc_is_login header to indicate if user is logged in
            $this->addLoginStatusHeader($response);
            
            $response->body(json_encode($responseData));
            $response->httpCode($code ?: 400);
            
            return $response;
        }
        
        // Otherwise, use the old method for backward compatibility
        return $this->apiResponse(false, $message, [], $code);
    }

    /**
     * API response helper (legacy method for backward compatibility)
     * 
     * IMPORTANT: resultText is ONLY included when result = false (error cases).
     * When result = true (success), resultText should NOT be present in the response.
     * 
     * @param bool $success Whether the operation was successful
     * @param string $message Error message (only used when success = false)
     * @param array $data Additional response data
     * @param int|null $code HTTP status code
     * @return Response
     */
    protected function apiResponse($success, $message, $data = [], $code = null): Response
    {
        $responseData = [
            'result' => $success,
        ];

        // Only include resultText when result is false (error cases)
        // When result = true, resultText must NOT be present
        if (!$success) {
            $responseData['resultText'] = $message;
        }

        if (!empty($data)) {
            $responseData = array_merge($responseData, $data);
        }

        // If result is true and data contains resultText, remove it (safety check)
        if ($success && isset($responseData['resultText'])) {
            unset($responseData['resultText']);
        }

        // Create and return a proper XF\Http\Response object
        $response = $this->app->response();
        $response->header('Content-Type', 'application/json; charset=UTF-8');
        
        // Add fc_is_login header to indicate if user is logged in
        $this->addLoginStatusHeader($response);
        
        $response->body(json_encode($responseData));
        $response->httpCode($code ?: 200);
        
        return $response;
    }

    /**
     * Add fc_is_login header to response
     * Indicates whether the user making the request is logged in
     * 
     * @param Response $response The response object to add the header to
     */
    protected function addLoginStatusHeader(Response $response)
    {
        $visitor = \XF::visitor();
        $isLoggedIn = ($visitor->user_id > 0) ? 'true' : 'false';
        $response->header('fc_is_login', $isLoggedIn);
    }

    /**
     * Assert user is registered
     * Returns null if authenticated, or a Response if not authenticated
     * 
     * @return Response|null
     */
    protected function assertRegisteredUser()
    {
        $visitor = \XF::visitor();
        if (!$visitor->user_id) {
            // Use apiError() which returns Response directly, not AbstractReply
            // This ensures complete() receives a Response object
            return $this->apiError('Authentication required - please log in first', 401);
        }
        return null;
    }

    /**
     * Check if the user is flooding (performing action too frequently)
     * Returns an error response if flooding, null otherwise
     * Consistent with web version
     * 
     * @param string $action The action being performed (e.g., 'report', 'post')
     * @param int|null $floodingLimit Custom flood limit in seconds
     * @return Response|null Error response if flooding, null otherwise
     */
    protected function checkFlooding($action, $floodingLimit = null)
    {
        $visitor = \XF::visitor();
        if ($visitor->hasPermission('general', 'bypassFloodCheck')) {
            return null;
        }

        $floodChecker = $this->service('XF:FloodCheck');
        $timeRemaining = $floodChecker->checkFlooding($action, $visitor->user_id, $floodingLimit);
        if ($timeRemaining) {
            return $this->apiError(
                \XF::phrase('must_wait_x_seconds_before_performing_this_action', ['count' => $timeRemaining])->render(),
                429
            );
        }

        return null;
    }

    /**
     * Assert forum is viewable
     */
    protected function assertViewableForum($nodeIdOrName)
    {
        $visitor = \XF::visitor();
        $nodeIdOrName = is_string($nodeIdOrName) && !is_numeric($nodeIdOrName) ? $nodeIdOrName : (int)$nodeIdOrName;

        if (is_int($nodeIdOrName)) {
            $finder = $this->em()->getFinder('XF:Forum')->where('node_id', $nodeIdOrName);
        } else {
            $finder = $this->em()->getFinder('XF:Forum');
            $finder->with('Node', true)->where(['Node.node_name' => $nodeIdOrName, 'Node.node_type_id' => 'Forum']);
        }

        $forum = $finder->fetchOne();
        if (!$forum) {
            throw new \XF\Mvc\Reply\Exception($this->error(\XF::phrase('forum_not_found')));
        }

        $error = null;
        if (!$forum->canView($error)) {
            throw new \XF\Mvc\Reply\Exception($this->error($error ?: \XF::phrase('cannot_view_forum')));
        }

        return $forum;
    }

    /**
     * Assert thread is viewable
     */
    protected function assertViewableThread($threadId)
    {
        $visitor = \XF::visitor();

        $thread = $this->em()->find('XF:Thread', $threadId);
        if (!$thread) {
            throw new \XF\Mvc\Reply\Exception($this->error(\XF::phrase('thread_not_found')));
        }

        $error = null;
        if (!$thread->canView($error)) {
            throw new \XF\Mvc\Reply\Exception($this->error($error ?: \XF::phrase('cannot_view_thread')));
        }

        return $thread;
    }

    /**
     * Assert post is viewable
     */
    protected function assertViewablePost($postId)
    {
        $post = $this->em()->find('XF:Post', $postId, ['Thread', 'Thread.Forum', 'Thread.Forum.Node', 'User']);
        if (!$post) {
            throw new \XF\Mvc\Reply\Exception($this->error(\XF::phrase('post_not_found')));
        }

        $error = null;
        if (!$post->canView($error)) {
            throw new \XF\Mvc\Reply\Exception($this->error($error ?: \XF::phrase('cannot_view_post')));
        }

        return $post;
    }

    /**
     * Assert conversation message is viewable
     * Based on XenForo's ConversationController::assertViewableMessage
     * 
     * @param int|string $messageId The message ID
     * @param array $extraWith Additional relations to load
     * @return \XF\Entity\ConversationMessage
     * @throws \XF\Mvc\Reply\Exception
     */
    protected function assertViewableMessage($messageId, array $extraWith = [])
    {
        $extraWith[] = 'Conversation';

        $visitor = \XF::visitor();
        if ($visitor->user_id) {
            $extraWith[] = 'Conversation.Recipients|' . $visitor->user_id;
            $extraWith[] = 'Conversation.Users|' . $visitor->user_id;
        }

        $extraWith = array_unique($extraWith);

        /** @var \XF\Entity\ConversationMessage $message */
        $message = $this->em()->find('XF:ConversationMessage', (int)$messageId, $extraWith);
        if (!$message) {
            throw new \XF\Mvc\Reply\Exception($this->error(\XF::phrase('requested_message_not_found')));
        }

        $error = null;
        if (!$message->canView($error)) {
            throw new \XF\Mvc\Reply\Exception($this->error($error ?: \XF::phrase('cannot_view_message')));
        }

        return $message;
    }

    /**
     * Extract error message from XenForo Reply Exception
     * Returns the first error message from the exception's reply object, or a fallback message
     * 
     * @param \XF\Mvc\Reply\Exception $e The exception to extract error from
     * @param string $fallback Fallback message if error cannot be extracted
     * @return string The error message
     */
    protected function extractErrorMessageFromReplyException(\XF\Mvc\Reply\Exception $e, $fallback = 'An error occurred')
    {
        $reply = $e->getReply();
        if ($reply instanceof \XF\Mvc\Reply\Error) {
            $errors = $reply->getErrors();
            if (!empty($errors)) {
                // Get first error message - Phrase objects will be rendered via __toString()
                return is_array($errors) ? (string)($errors[0] ?? $fallback) : (string)$errors;
            }
        }
        return $fallback;
    }

    /**
     * Get pagination data
     */
    protected function getPaginationData($results, $page, $perPage, $total)
    {
        $page = max(1, intval($page));
        $perPage = max(1, intval($perPage));
        $total = max(0, intval($total));
        $maxPage = ceil($total / $perPage);

        $page = min($page, $maxPage);

        return [
            'current_page' => $page,
            'last_page' => $maxPage,
            'per_page' => $perPage,
            'shown' => count($results),
            'total' => $total,
        ];
    }

    /**
     * Convert XenForo forum to FC format
     */
    protected function xenforoToFcForum(\XF\Entity\Forum $forum)
    {
        $visitor = \XF::visitor();

        return [
            'id' => (string)$forum->node_id,
            'name' => $forum->Node->title ?: $forum->title,
            'description' => $forum->description ?: $forum->Node->description,
            'parent_id' => $forum->Node->parent_node_id ? (string)$forum->Node->parent_node_id : '',
            'display_order' => $forum->Node->display_order,
            'thread_count' => $forum->discussion_count,
            'post_count' => $forum->message_count,
            'can_post' => $forum->canCreateThread(),
            'can_reply' => $forum->canCreateThread(),
            'is_read' => $visitor->user_id ? !$forum->isUnread() : true,
            'url' => $this->buildLink('canonical:forums', $forum),
        ];
    }
    
    /**
     * Convert relative URL to absolute URL
     * @param string $relativeUrl The relative URL (e.g., /xf2/data/avatars/s/0/1.jpg)
     * @return string The absolute URL
     */
    protected function getAbsoluteUrl($relativeUrl)
    {
        if (empty($relativeUrl)) {
            return '';
        }

        // If already absolute, return as is
        if (preg_match('#^https?://#', $relativeUrl)) {
            return $relativeUrl;
        }

        return \XF::app()->request()->convertToAbsoluteUri($relativeUrl);
        /*
        // Get board URL and ensure it ends with /
        $boardUrl = rtrim(\XF::options()->boardUrl, '/');
        
        // Ensure relative URL starts with /
        if (!preg_match('#^/#', $relativeUrl)) {
            $relativeUrl = '/' . $relativeUrl;
        }

        return $boardUrl . $relativeUrl;
        */
    }

    /**
     * Get forum watch status using ForumWatch repository
     * This avoids entity relationship issues by using the repository directly
     * 
     * @param \XF\Entity\Forum $forum The forum entity
     * @param \XF\Entity\User|null $visitor The visitor (defaults to current visitor)
     * @return array Array with 'canWatch' and 'isWatched' boolean values
     */
    protected function getForumWatchStatus($forum, $visitor = null)
    {
        if ($visitor === null) {
            $visitor = \XF::visitor();
        }

        // If guest user, cannot watch and not watched
        if (!$visitor->user_id) {
            return ['canWatch' => false, 'isWatched' => false];
        }

        // Use Forum entity's canWatch method (this should work as it checks permissions)
        $canWatch = $forum->canWatch();

        // Check if forum is watched by finding the ForumWatch entity
        $forumWatch = $this->em()->find('XF:ForumWatch', [
            'node_id' => $forum->node_id,
            'user_id' => $visitor->user_id
        ]);
        $isWatched = ($forumWatch !== null);

        return ['canWatch' => $canWatch, 'isWatched' => $isWatched];
    }

    /**
     * Get thread watch status using ThreadWatch repository
     * This avoids entity relationship issues by using the repository directly
     * 
     * @param \XF\Entity\Thread $thread The thread entity
     * @param \XF\Entity\User|null $visitor The visitor (defaults to current visitor)
     * @return array Array with 'canWatch' and 'isWatched' boolean values
     */
    protected function getThreadWatchStatus($thread, $visitor = null)
    {
        if ($visitor === null) {
            $visitor = \XF::visitor();
        }

        // If guest user, cannot watch and not watched
        if (!$visitor->user_id) {
            return ['canWatch' => false, 'isWatched' => false];
        }

        // Use Thread entity's canWatch method (this should work as it checks permissions)
        $canWatch = $thread->canWatch();

        // Check if thread is watched by finding the ThreadWatch entity
        $threadWatch = $this->em()->find('XF:ThreadWatch', [
            'thread_id' => $thread->thread_id,
            'user_id' => $visitor->user_id
        ]);
        $isWatched = ($threadWatch !== null);

        return ['canWatch' => $canWatch, 'isWatched' => $isWatched];
    }

    /**
     * Get list of users who liked/reacted to a post
     * Returns an array of like information with userId, username, avatarUrl, and timestamp
     * 
     * @param \XF\Entity\Post $post The post entity
     * @return array Array of like information
     */
    protected function getPostLikesInfo($post)
    {
        $likesInfo = [];
        
        try {
            // Check if reaction system is available
            if (!class_exists('\XF\Repository\ReactionRepository')) {
                return $likesInfo;
            }
            
            // Use XenForo's repository method to find reactions properly
            $reactionRepo = $this->repository('XF:Reaction');
            
            // Use the proper method to find content reactions with all relations loaded
            $finder = $reactionRepo->findContentReactions('post', $post->post_id);
            
            // Fetch reactions
            $reactions = $finder->fetch();
            
            foreach ($reactions as $reactionContent) {
                try {
                    // Use ReactionUser relation (not User) - this is the user who made the reaction
                    $user = $reactionContent->ReactionUser;
                    if (!$user) {
                        continue;
                    }
                    
                    // Get reaction information
                    $reaction = $reactionContent->Reaction;
                    $reactionId = $reactionContent->reaction_id;
                    $reactionName = '';
                    $reactionEmoji = null;
                    $reactionIconUrl = null;
                    
                    if ($reaction) {
                        try {
                            $reactionName = $reaction->getTitle()->render();
                        } catch (\Exception $e) {
                            // If title can't be rendered, use fallback
                            $reactionName = 'Reaction ' . $reactionId;
                        }
                        
                        // Get emoji character if available
                        if ($reaction->emoji_shortname) {
                            try {
                                $reactionEmoji = $reaction->emoji;
                            } catch (\Exception $e) {
                                // If emoji conversion fails, leave as null
                            }
                        }
                        
                        // Get icon URL if using custom image
                        if ($reaction->image_url) {
                            $reactionIconUrl = $this->getAbsoluteUrl($reaction->image_url);
                        }
                    }
                    
                    $likesInfo[] = [
                        'userId' => (string)$user->user_id,
                        'username' => $user->username,
                        'avatarUrl' => $this->getAbsoluteUrl($user->getAvatarUrl('s')),
                        'timestamp' => $reactionContent->reaction_date * 1000, // Convert to milliseconds
                        'reactionId' => (int)$reactionId,
                        'reactionName' => $reactionName,
                        'reactionEmoji' => $reactionEmoji,
                        'reactionIconUrl' => $reactionIconUrl,
                    ];
                } catch (\Exception $e) {
                    // Skip reactions with invalid user data
                    // Log error for debugging
                    \XF::logError('ForumCopilot: Error getting reaction user: ' . $e->getMessage());
                    continue;
                }
            }
        } catch (\Exception $e) {
            // If reaction fetching fails, log error and return empty array
            // This ensures the API doesn't break if reactions aren't available
            \XF::logError('ForumCopilot: Error fetching reactions: ' . $e->getMessage());
        }
        
        return $likesInfo;
    }

    /**
     * Get canLike and isLiked flags for a post
     * 
     * @param \XF\Entity\Post $post The post entity
     * @return array Array with 'canLike' and 'isLiked' boolean values
     */
    protected function getPostLikeFlags($post)
    {
        $canLike = false;
        $isLiked = false;
        
        try {
            // Check if user can react/like this post
            if (method_exists($post, 'canReact')) {
                $error = null;
                $canLike = $post->canReact($error);
            }
            
            // Check if user has already reacted/liked this post
            if (method_exists($post, 'isReactedTo')) {
                $isLiked = $post->isReactedTo();
            }
        } catch (\Exception $e) {
            // If checks fail, default to false
            // Log error for debugging
            \XF::logError('ForumCopilot: Error getting post like flags: ' . $e->getMessage());
        }
        
        return [
            'canLike' => $canLike,
            'isLiked' => $isLiked
        ];
    }

    /**
     * Get the position (floor number) of a post in a thread
     * Position is 1-based: first post is #1, first reply is #2, etc.
     * 
     * Tries to get position directly from XenForo's Post entity (which stores it in the database),
     * otherwise calculates it by counting visible posts.
     * 
     * @param \XF\Entity\Post $post The post entity
     * @return int The position of the post in the thread (1-based)
     */
    protected function getPostPosition($post)
    {
        try {
            // XenForo stores position in the xf_post table as 0-based (first post = 0, second post = 1, etc.)
            // But the API should return 1-based positions (first post = 1, second post = 2, etc.)
            // So we need to add 1 to the position value
            
            // Method 1: Direct property access (most common in XenForo entities)
            if (property_exists($post, 'position') && isset($post->position) && is_numeric($post->position)) {
                // XenForo uses 0-based positions, convert to 1-based for API
                return (int)$post->position + 1;
            }
            
            // Method 2: Try accessing via getValue() method (XenForo entity method)
            if (method_exists($post, 'getValue')) {
                try {
                    $position = $post->getValue('position');
                    if ($position !== null && is_numeric($position)) {
                        // XenForo uses 0-based positions, convert to 1-based for API
                        return (int)$position + 1;
                    }
                } catch (\Exception $e) {
                    // getValue might throw if field doesn't exist
                }
            }
            
            // Method 3: Try to get from entity's getter (if exists)
            if (method_exists($post, 'getPosition')) {
                $position = $post->getPosition();
                if ($position !== null && is_numeric($position)) {
                    // XenForo uses 0-based positions, convert to 1-based for API
                    return (int)$position + 1;
                }
            }
            
            // Method 4: Try to reload post with position field explicitly selected
            try {
                $reloadedPost = $this->em()->find('XF:Post', $post->post_id, ['position']);
                if ($reloadedPost && isset($reloadedPost->position) && is_numeric($reloadedPost->position)) {
                    // XenForo uses 0-based positions, convert to 1-based for API
                    return (int)$reloadedPost->position + 1;
                }
            } catch (\Exception $e) {
                // Reload might fail, continue to calculation
            }
            
            // If position is not directly available from the entity, calculate it
            // Count all visible posts that come before or at the same time as this post
            $positionFinder = $this->finder('XF:Post');
            $positionFinder->where('thread_id', $post->thread_id);
            $positionFinder->where('message_state', 'visible');
            $positionFinder->where('post_date', '<=', $post->post_date);
            $positionFinder->order('post_date', 'ASC');
            
            // The total() method returns the count, which is already 1-based (first post = 1)
            return $positionFinder->total();
        } catch (\Exception $e) {
            // If calculation fails, return 1 as fallback (first post)
            return 1;
        }
    }

    /**
     * Get the position (message number) of a conversation message
     * Position is 1-based: first message is #1, second message is #2, etc.
     * 
     * Calculates position by counting visible messages that come before or at the same time as this message.
     * 
     * @param \XF\Entity\ConversationMessage $message The message entity
     * @param \XF\Entity\ConversationMaster $conversation The conversation entity
     * @return int The position of the message in the conversation (1-based)
     */
    protected function getMessagePosition($message, $conversation)
    {
        try {
            // Count all visible messages that come before or at the same time as this message
            $messageRepo = $this->repository('XF:ConversationMessage');
            $positionFinder = $messageRepo->findMessagesForConversationView($conversation);
            $positionFinder->where('message_date', '<=', $message->message_date);
            
            // The total() method returns the count, which is already 1-based (first message = 1)
            return $positionFinder->total();
        } catch (\Exception $e) {
            // If calculation fails, return 1 as fallback (first message)
            return 1;
        }
    }

    /**
     * Clean and prepare short content from post message
     * Removes BBCode, HTML, newlines, and cleans up whitespace
     * 
     * @param string|array|null $message The post message (can be string, array, or null)
     * @param int $maxLength Maximum length of the short content (default 200)
     * @return string Cleaned short content text
     */
    protected function getShortContent($message, $maxLength = 200)
    {
        // Handle null or empty message
        if (empty($message)) {
            return '';
        }
        
        // Convert array to string if needed
        if (is_array($message)) {
            $message = '';
        }
        
        // Ensure message is a string
        $message = (string)$message;
        
        try {
            // Use XenForo's string formatter to strip BBCode
            $formatter = $this->app()->stringFormatter();
            
            // Strip BBCode (removes all BBCode tags)
            $cleaned = $formatter->stripBbCode($message, [
                'stripQuote' => true,  // Remove quote blocks
                'hideUnviewable' => true  // Hide images, attachments, etc.
            ]);
            
            // Remove HTML tags (in case any remain)
            $cleaned = strip_tags($cleaned);
            
            // Decode HTML entities (convert &amp; to &, etc.)
            $cleaned = html_entity_decode($cleaned, ENT_QUOTES | ENT_HTML5, 'UTF-8');
            
            // Replace newlines, carriage returns, and tabs with spaces
            $cleaned = preg_replace('/[\r\n\t]+/u', ' ', $cleaned);
            
            // Replace multiple spaces with single space
            $cleaned = preg_replace('/\s+/u', ' ', $cleaned);
            
            // Trim whitespace from start and end
            $cleaned = trim($cleaned);
            
            // Get substring up to max length
            if (mb_strlen($cleaned) > $maxLength) {
                $cleaned = mb_substr($cleaned, 0, $maxLength);
                // Try to cut at word boundary (avoid cutting in middle of word)
                $lastSpace = mb_strrpos($cleaned, ' ');
                if ($lastSpace !== false && $lastSpace > $maxLength * 0.7) {
                    // If we found a space and it's not too close to the start, cut there
                    $cleaned = mb_substr($cleaned, 0, $lastSpace);
                }
                $cleaned .= '...';
            }
            
            return $cleaned;
        } catch (\Exception $e) {
            // If cleaning fails, fall back to basic strip_tags
            $cleaned = strip_tags($message);
            $cleaned = html_entity_decode($cleaned, ENT_QUOTES | ENT_HTML5, 'UTF-8');
            $cleaned = preg_replace('/[\r\n\t]+/u', ' ', $cleaned);
            $cleaned = preg_replace('/\s+/u', ' ', $cleaned);
            $cleaned = trim($cleaned);
            
            if (mb_strlen($cleaned) > $maxLength) {
                $cleaned = mb_substr($cleaned, 0, $maxLength) . '...';
            }
            
            return $cleaned;
        }
    }

    /**
     * Get thread prefix label
     * Returns the title/label of the thread's prefix, or empty string if no prefix
     * 
     * @param \XF\Entity\Thread $thread The thread entity
     * @return string The prefix label/title
     */
    protected function getThreadPrefixLabel($thread)
    {
        try {
            if (!$thread->prefix_id) {
                return '';
            }
            
            // Try to get prefix from thread's Prefix relation
            if ($thread->Prefix) {
                $prefixTitle = $thread->Prefix->title;
                // If title is a Phrase object, render it to string
                if ($prefixTitle instanceof \XF\Phrase) {
                    return $prefixTitle->render();
                }
                return (string)$prefixTitle;
            }
            
            // If Prefix relation is not loaded, fetch it manually
            $prefix = $this->em()->find('XF:ThreadPrefix', $thread->prefix_id);
            if ($prefix) {
                $prefixTitle = $prefix->title;
                if ($prefixTitle instanceof \XF\Phrase) {
                    return $prefixTitle->render();
                }
                return (string)$prefixTitle;
            }
        } catch (\Exception $e) {
            // If getting prefix fails, return empty string
        }
        
        return '';
    }

    /**
     * Setup base finder for topic listing queries
     * Matches "What's New" page behavior from findThreadsWithLatestPosts()
     * 
     * @param array $options Optional options:
     *   - 'requireFindNew' (bool): If true, only show threads from forums enabled for "What's New" (default: true)
     *   - 'skipIgnored' (bool): If true, filter out ignored threads (default: true)
     * @return \XF\Finder\Thread
     */
    protected function setupTopicListFinder(array $options = [])
    {
        $visitor = \XF::visitor();

        $requireFindNew = $options['requireFindNew'] ?? true;
        $skipIgnored = $options['skipIgnored'] ?? true;
        $restrictViewable = $options['restrictViewable'] ?? false;

        $finder = $this->finder('XF:Thread');
        // Eager-load Poll so we can set hasPoll on FCTopic for thread list and thread view.
        $finder->with(['Forum', 'Forum.Node', 'Poll']);
        $finder->where('discussion_state', 'visible');

        if ($requireFindNew) {
            $finder->where('Forum.find_new', true);
        }

        $finder->where('discussion_type', '<>', 'redirect');
        $finder->order('last_post_date', 'DESC');
        $finder->indexHint('FORCE', 'last_post_date');

        if ($restrictViewable) {
            $forums = $this->repository('XF:Forum')->getViewableForums();
            $finder->where('node_id', $forums->keys());
        }

        if ($skipIgnored && $visitor->user_id) {
            $finder->skipIgnored($visitor);
        }

        return $finder;
    }

    /**
     * Apply filters to thread finder (similar to ThreadHandler::applyFilters)
     * 
     * @param \XF\Finder\Thread $threadFinder
     * @param array $filters Filter options:
     *   - 'unread' (bool): Show only unread threads (applies date cutoff automatically)
     *   - 'watched' (bool): Show only watched/subscribed threads
     *   - 'participated' (bool): Show threads where user has posted
     *   - 'started' (bool): Show threads started by user
     *   - 'unanswered' (bool): Show threads with no replies
     * @param \XF\Entity\User|null $user User to apply filters for (default: visitor)
     */
    protected function applyTopicFilters(\XF\Finder\Thread $threadFinder, array $filters, $user = null)
    {
        if (!$user) {
            $user = \XF::visitor();
        }
        
        // If unread filter is set, use unreadOnly (which already applies date cutoff)
        if (!empty($filters['unread'])) {
            $threadFinder->unreadOnly($user->user_id);
        } else {
            // Apply date cutoff for recent posts (matches web behavior)
            // Only apply if unread filter is not set (unreadOnly already handles it)
            $readMarkingCutOff = \XF::$time - (\XF::options()->readMarkingDataLifetime * 86400);
            $threadFinder->where('last_post_date', '>', $readMarkingCutOff);
        }
        
        // Watched filter
        if (!empty($filters['watched'])) {
            $threadFinder->watchedOnly($user->user_id);
        }
        
        // Participated filter
        if (!empty($filters['participated'])) {
            $threadFinder->exists('UserPosts|' . $user->user_id);
        }
        
        // Started filter
        if (!empty($filters['started'])) {
            $threadFinder->where('user_id', $user->user_id);
        }
        
        // Unanswered filter
        if (!empty($filters['unanswered'])) {
            $threadFinder->where('reply_count', 0);
        }
    }

    /**
     * Convert thread entity to FCTopic entity
     * Centralized conversion logic used across all topic listing methods
     * 
     * @param \XF\Entity\Thread $thread
     * @param \XF\Entity\User|null $visitor Visitor user (default: current visitor)
     * @param array $options Optional options:
     *   - 'useLastPost' (bool): If true, use last post for preview/author info (default: false)
     * @return FCTopic
     */
    protected function convertThreadToFCTopic(\XF\Entity\Thread $thread, $visitor = null, array $options = [])
    {
        if (!$visitor) {
            $visitor = \XF::visitor();
        }
        
        $useLastPost = $options['useLastPost'] ?? false;
        
        // Safely access forum/node information
        $forumName = 'Unknown';
        try {
            if ($thread->Forum && $thread->Forum->Node) {
                $forumName = $thread->Forum->Node->title;
            }
        } catch (\Exception $e) {
            // If add-on conflict occurs, skip this relation
        }
        
        // Get like count from first post
        $likeCount = 0;
        try {
            if ($thread->first_post_id) {
                $firstPost = $this->em()->find('XF:Post', $thread->first_post_id);
                if ($firstPost && isset($firstPost->reaction_score)) {
                    $likeCount = (int)$firstPost->reaction_score;
                }
            }
        } catch (\Exception $e) {
            // If reaction score access fails, leave as 0
        }
        
        // Get short content and author info
        $shortContent = '';
        $authorName = 'Unknown';
        $authorId = (string)$thread->user_id;
        $authorUserType = '0';
        $authorIconUrl = '';
        // Use last_post_date for timestamp to match ordering by last_post_date DESC in topic listings
        $timestamp = $thread->last_post_date * 1000;
        
        try {
            if ($useLastPost && $thread->last_post_id) {
                // Use last post for preview (matches getSubscribedTopic behavior)
                $lastPost = $this->em()->find('XF:Post', $thread->last_post_id);
                if ($lastPost) {
                    if ($lastPost->message) {
                        $shortContent = $this->getShortContent($lastPost->message);
                    }
                    
                    if ($lastPost->User) {
                        $authorName = $lastPost->User->username;
                        $authorId = (string)$lastPost->user_id;
                        $authorUserType = (string)$lastPost->User->user_group_id;
                        $authorIconUrl = $this->getAbsoluteUrl($lastPost->User->getAvatarUrl('s'));
                    } else {
                        $authorName = $thread->last_post_username ?: 'Unknown';
                        $authorId = (string)$thread->last_post_user_id;
                    }
                    $timestamp = $lastPost->post_date * 1000;
                }
            } else {
                // Use first post for preview (default behavior)
                if ($thread->first_post_id) {
                    $firstPost = $this->em()->find('XF:Post', $thread->first_post_id);
                    if ($firstPost && $firstPost->message) {
                        $message = is_array($firstPost->message) ? '' : (string)$firstPost->message;
                        $message = strip_tags($message);
                        $shortContent = mb_substr($message, 0, 200);
                        if (mb_strlen($message) > 200) {
                            $shortContent .= '...';
                        }
                    }
                }
                
                // Get author info from thread creator
                if ($thread->User) {
                    $authorName = $thread->User->username;
                    $authorId = (string)$thread->user_id;
                    $authorUserType = (string)$thread->User->user_group_id;
                    $authorIconUrl = $this->getAbsoluteUrl($thread->User->getAvatarUrl('s'));
                }
                // timestamp already set to last_post_date above to match ordering
            }
        } catch (\Exception $e) {
            // If preview generation fails, use thread creator info as fallback
            try {
                if ($thread->User) {
                    $authorName = $thread->User->username;
                    $authorId = (string)$thread->user_id;
                    $authorUserType = (string)$thread->User->user_group_id;
                    $authorIconUrl = $this->getAbsoluteUrl($thread->User->getAvatarUrl('s'));
                }
            } catch (\Exception $e2) {
                // If add-on conflict occurs, use defaults
            }
        }
        
        // For listing, use defaults for permissions that may not exist in XFMG entities
        $canReport = false;
        $canLike = false;
        $isLiked = false;
        $canUpload = false;
        
        // Get thread watch status using helper method
        $threadWatchStatus = $this->getThreadWatchStatus($thread, $visitor);
        
        // Get prefix label
        $prefixLabel = $this->getThreadPrefixLabel($thread);
        
        // Check if user can view thread content (viewContent permission)
        // Note: If thread appears in list, canView() already passed (which includes viewContent check)
        // This flag explicitly indicates the viewContent permission for the client
        $canViewContent = $visitor->hasNodePermission($thread->node_id, 'viewContent');
        // Determine if thread has a poll: discussion_type is 'poll' or Poll relation is present.
        $hasPoll = ($thread->discussion_type === 'poll');
        if (!$hasPoll) {
            try {
                $hasPoll = (bool)$thread->Poll;
            } catch (\Exception $e) {
                $hasPoll = false;
            }
        }

        return new FCTopic([
            'id' => (string)$thread->thread_id,
            'title' => $thread->title,
            'forumId' => (string)$thread->node_id,
            'forumName' => $forumName,
            'authorId' => $authorId,
            'authorName' => $authorName,
            'authorUserType' => $authorUserType,
            'timestamp' => $timestamp,
            'prefix' => $prefixLabel,
            'authorIconUrl' => $authorIconUrl,
            'replyCount' => $thread->reply_count,
            'viewCount' => $thread->view_count,
            'hasNewPosts' => $thread->isUnread(),
            'isClosed' => $thread->discussion_state === 'closed',
            'isSubscribed' => $threadWatchStatus['isWatched'],
            'canSubscribe' => $threadWatchStatus['canWatch'],
            'url' => $this->buildLink('canonical:threads', $thread),
            'shortContent' => $shortContent,
            'participatedUserIds' => [],
            'isPinned' => (bool)$thread->sticky,
            'isAnnouncement' => false,
            'isStickySource' => (bool)$thread->sticky,
            'canRename' => $thread->canEdit(),
            'canDelete' => $thread->canDelete(),
            'canClose' => $thread->canLockUnlock(),
            'canApprove' => $thread->canApproveUnapprove(),
            'canStick' => $thread->canStickUnstick(),
            'canMove' => $thread->canMove(),
            'canMerge' => $thread->canMerge(),
            'canBan' => false,
            'canReply' => $thread->canReply(),
            'canViewContent' => $canViewContent,
            'canReport' => $canReport,
            'canUpload' => $canUpload,
            'isBanned' => false,
            'isApproved' => $thread->discussion_state === 'visible',
            'isDeleted' => false,
            'isMoved' => false,
            'isMerged' => false,
            'realTopicId' => null,
            'canLike' => $canLike,
            'isLiked' => $isLiked,
            'likeCount' => $likeCount,
            'hasPoll' => $hasPoll,
        ]);
    }

    /**
     * Build poll data for a thread (or return null if no poll).
     */
    protected function buildPollDataForThread(\XF\Entity\Thread $thread): ?array
    {
        $poll = null;
        try {
            $poll = $thread->Poll;
        } catch (\Exception $e) {
            $poll = null;
        }
        if (!$poll) {
            $poll = $this->em()->findOne('XF:Poll', [
                'content_type' => 'thread',
                'content_id' => $thread->thread_id,
            ]);
        }

        if (!$poll) {
            return null;
        }

        $canViewResults = $poll->canViewResults();
        $responses = [];

        foreach ($poll->responses as $responseId => $response) {
            $responses[] = [
                'id' => (string)$responseId,
                'text' => $response['response'],
                'voteCount' => $canViewResults ? (int)$response['response_vote_count'] : null,
                'viewerVotedFor' => $poll->hasVoted($responseId),
            ];
        }

        return [
            'pollId' => (string)$poll->poll_id,
            'topicId' => (string)$thread->thread_id,
            'question' => $poll->question,
            'responses' => $responses,
            'voterCount' => $canViewResults ? (int)$poll->voter_count : null,
            'maxVotes' => (int)$poll->max_votes,
            'changeVote' => (bool)$poll->change_vote,
            'publicVotes' => (bool)$poll->public_votes,
            'viewResultsUnvoted' => (bool)$poll->view_results_unvoted,
            'closeDate' => $poll->close_date ? $poll->close_date * 1000 : 0,
            'isClosed' => $poll->isClosed(),
            'canVote' => $poll->canVote(),
            'hasVoted' => $poll->hasVoted(),
            'canViewResults' => $canViewResults,
        ];
    }

    /**
     * Build topic list from threads with pagination
     * Common logic for fetching, converting, and filtering threads
     * 
     * @param \XF\Finder\Thread $finder
     * @param int $startNum Starting position (0-indexed)
     * @param int $lastNum Ending position (inclusive)
     * @param array $options Optional options for convertThreadToFCTopic
     * @return array ['topics' => FCTopic[], 'total' => int]
     */
    protected function buildTopicListFromFinder(\XF\Finder\Thread $finder, $startNum, $lastNum, array $options = [])
    {
        $visitor = \XF::visitor();

        $perPage = $lastNum - $startNum + 1;
        $page = floor($startNum / $perPage) + 1;
        if ($page < 1) {
            $page = 1;
        }
        $finder->limitByPage($page, $perPage);

        $threads = $finder->fetch();
        $total = $finder->total();
        
        $topicList = [];
        foreach ($threads as $thread) {
            // Respect XenForo's permission system - check if thread is viewable
            $error = null;
            if (!$thread->canView($error)) {
                continue; // Skip threads user cannot view
            }
            
            // Convert thread to FCTopic
            try {
                $fcTopic = $this->convertThreadToFCTopic($thread, $visitor, $options);
                $topicList[] = $fcTopic;
            } catch (\Exception $e) {
                // Skip this topic if conversion fails
                continue;
            }
        }
        
        return ['topics' => $topicList, 'total' => (int)$total];
    }

    /**
     * Get canLike and isLiked flags for a conversation message
     * 
     * @param \XF\Entity\ConversationMessage $message The conversation message entity
     * @return array Array with 'canLike' and 'isLiked' boolean values
     */
    protected function getConversationMessageLikeFlags($message)
    {
        $canLike = false;
        $isLiked = false;
        
        try {
            // Check if user can react/like this message
            if (method_exists($message, 'canReact')) {
                $error = null;
                $canLike = $message->canReact($error);
            }
            
            // Check if user has already reacted/liked this message
            if (method_exists($message, 'isReactedTo')) {
                $isLiked = $message->isReactedTo();
            }
        } catch (\Exception $e) {
            // If checks fail, default to false
            // Log error for debugging
            \XF::logError('ForumCopilot: Error getting conversation message like flags: ' . $e->getMessage());
        }
        
        return [
            'canLike' => $canLike,
            'isLiked' => $isLiked
        ];
    }

    /**
     * Get list of users who liked/reacted to a conversation message
     * Returns an array of like information with userId, username, avatarUrl, and timestamp
     * 
     * @param \XF\Entity\ConversationMessage $message The conversation message entity
     * @return array Array of like information
     */
    protected function getConversationMessageLikesInfo($message)
    {
        $likesInfo = [];
        
        try {
            // Check if reaction system is available
            if (!class_exists('\XF\Repository\ReactionRepository')) {
                return $likesInfo;
            }
            
            // Use XenForo's repository method to find reactions properly
            $reactionRepo = $this->repository('XF:Reaction');
            
            // Use the proper method to find content reactions with all relations loaded
            $finder = $reactionRepo->findContentReactions('conversation_message', $message->message_id);
            
            // Fetch reactions
            $reactions = $finder->fetch();
            
            foreach ($reactions as $reactionContent) {
                try {
                    // Use ReactionUser relation (not User) - this is the user who made the reaction
                    $user = $reactionContent->ReactionUser;
                    if (!$user) {
                        continue;
                    }
                    
                    // Get reaction information
                    $reaction = $reactionContent->Reaction;
                    $reactionId = $reactionContent->reaction_id;
                    $reactionName = '';
                    $reactionEmoji = null;
                    $reactionIconUrl = null;
                    
                    if ($reaction) {
                        try {
                            $reactionName = $reaction->getTitle()->render();
                        } catch (\Exception $e) {
                            // If title can't be rendered, use fallback
                            $reactionName = 'Reaction ' . $reactionId;
                        }
                        
                        // Get emoji character if available
                        if ($reaction->emoji_shortname) {
                            try {
                                $reactionEmoji = $reaction->emoji;
                            } catch (\Exception $e) {
                                // If emoji conversion fails, leave as null
                            }
                        }
                        
                        // Get icon URL if using custom image
                        if ($reaction->image_url) {
                            $reactionIconUrl = $this->getAbsoluteUrl($reaction->image_url);
                        }
                    }
                    
                    $likesInfo[] = [
                        'userId' => (string)$user->user_id,
                        'username' => $user->username,
                        'avatarUrl' => $this->getAbsoluteUrl($user->getAvatarUrl('s')),
                        'timestamp' => $reactionContent->reaction_date * 1000, // Convert to milliseconds
                        'reactionId' => (int)$reactionId,
                        'reactionName' => $reactionName,
                        'reactionEmoji' => $reactionEmoji,
                        'reactionIconUrl' => $reactionIconUrl,
                    ];
                } catch (\Exception $e) {
                    // Skip reactions with invalid user data
                    // Log error for debugging
                    \XF::logError('ForumCopilot: Error getting reaction user: ' . $e->getMessage());
                    continue;
                }
            }
        } catch (\Exception $e) {
            // If reaction fetching fails, log error and return empty array
            // This ensures the API doesn't break if reactions aren't available
            \XF::logError('ForumCopilot: Error fetching conversation message reactions: ' . $e->getMessage());
        }
        
        return $likesInfo;
    }

    /**
     * Get attachments for a conversation message
     * Returns array of FCAttachment objects with inline status
     * 
     * @param \XF\Entity\ConversationMessage $message The conversation message entity
     * @return array Array of FCAttachment objects
     */
    protected function getConversationMessageAttachments($message)
    {
        $attachments = [];
        
        try {
            // Query attachments for this message
            $attachmentFinder = $this->finder('XF:Attachment');
            $attachmentFinder->where('content_type', 'conversation_message');
            $attachmentFinder->where('content_id', $message->message_id);
            $attachmentFinder->with('Data');
            $messageAttachments = $attachmentFinder->fetch();
            
            if (!$messageAttachments || $messageAttachments->count() == 0) {
                return $attachments;
            }
            
            foreach ($messageAttachments as $attachment) {
                // Skip temporary/unassociated attachments
                if ($attachment->temp_hash || $attachment->unassociated) {
                    continue;
                }
                
                // Check if user can view this attachment
                $error = null;
                $canView = $attachment->canView($error);
                
                // Get attachment data
                $data = $attachment->Data;
                if (!$data) {
                    continue;
                }
                
                // Determine if it's an image
                $isImage = false;
                $width = null;
                $height = null;
                if ($data->width && $data->height) {
                    $isImage = true;
                    $width = (int)$data->width;
                    $height = (int)$data->height;
                }
                
                // Get MIME type from extension (same mapping as posts)
                $mimeType = '';
                try {
                    $extension = strtolower($data->extension ?? '');
                    $mimeMap = [
                        'txt' => 'text/plain',
                        'jpg' => 'image/jpeg',
                        'jpeg' => 'image/jpeg',
                        'png' => 'image/png',
                        'gif' => 'image/gif',
                        'pdf' => 'application/pdf',
                        'zip' => 'application/zip',
                    ];
                    $mimeType = $mimeMap[$extension] ?? '';
                } catch (\Exception $e) {
                    // If MIME type detection fails, leave empty
                }
                
                // Get attachment URL (only if user can view full attachment)
                // Use getDirectUrl() which returns direct file URL when available, or route URL as fallback
                $url = '';
                if ($canView) {
                    try {
                        // getDirectUrl() returns direct file URL for videos/audio, or attachment route URL for others
                        $directUrl = $attachment->getDirectUrl(true);
                        $url = $this->getAbsoluteUrl($directUrl);
                    } catch (\Exception $e) {
                        // If URL building fails, try alternative method
                        try {
                            $url = $this->buildLink('canonical:attachments', $attachment);
                        } catch (\Exception $e2) {
                            // If both fail, leave URL empty
                        }
                    }
                }
                
                // Get thumbnail URL if available
                $thumbnailUrl = null;
                if ($attachment->has_thumbnail) {
                    try {
                        $thumbnailUrl = $this->getAbsoluteUrl($attachment->thumbnail_url);
                    } catch (\Exception $e) {
                        // If thumbnail URL building fails, leave as null
                    }
                }
                
                // Check permissions for viewing URLs
                // For conversation messages, canViewUrl is based on whether user can view the conversation
                // Thumbnails are always viewable (like web interface), full URLs require permission
                $canViewUrl = false;
                if ($message->Conversation) {
                    $error = null;
                    $canViewUrl = $message->Conversation->canView($error);
                }
                $canViewThumbnailUrl = $attachment->has_thumbnail; // Not dependent on canView
                
                // Check if attachment is embedded inline in the message
                $isInline = false;
                if (method_exists($message, 'isAttachmentEmbedded')) {
                    $isInline = $message->isAttachmentEmbedded($attachment->attachment_id);
                }
                
                // Create FCAttachment object
                $fcAttachment = new \ForumCopilot\Entity\FCAttachment([
                    'id' => (string)$attachment->attachment_id,
                    'fileName' => $attachment->filename,
                    'fileSize' => (int)$attachment->file_size,
                    'mimeType' => $mimeType,
                    'url' => $url,
                    'thumbnailUrl' => $thumbnailUrl,
                    'groupId' => $attachment->temp_hash ?: '',
                    'isImage' => $isImage,
                    'width' => $width,
                    'height' => $height,
                    'canViewUrl' => $canViewUrl,
                    'canViewThumbnailUrl' => $canViewThumbnailUrl,
                    'isInline' => $isInline,
                ]);
                
                $attachments[] = $fcAttachment;
            }
        } catch (\Exception $e) {
            // If attachment loading fails, log error and return empty array
            \XF::logError('ForumCopilot: Error loading message attachments: ' . $e->getMessage());
        }
        
        return $attachments;
    }

    /**
     * Checks if registration via API is supported
     * Returns true only if:
     * 1. Registration is enabled
     * 2. The registration process is not too complex for in-app registration
     * 
     * @return bool
     */
    protected function canRegisterViaAPI()
    {
        $options = $this->app()->options();
        $setup = $options->registrationSetup;

        // First check: Forum must be open
        if (!$options->boardActive) {
            return false;
        }

        // Second check: Registration must be enabled
        if (empty($setup['enabled'])) {
            return false;
        }

        // Note: CAPTCHA validation is bypassed for API registration since webview-based
        // CAPTCHAs (reCAPTCHA, hCaptcha, Turnstile, KeyCaptcha) are too complex for mobile apps.
        // Other spam protection mechanisms (DNSBL, Project Honey Pot, registration timer) 
        // in RegistrationService still apply.
        // Question CAPTCHA is still blocked as it requires custom admin-defined questions.
        $captcha = $options->captcha;
        if ($captcha === 'Question') {
            // Question & Answer CAPTCHA requires custom questions defined by admin
            // This is too complex for in-app registration
            return false;
        }

        // Third check: No unsupported custom field types during registration
        /** @var \XF\Repository\UserFieldRepository $userFieldRepo */
        $userFieldRepo = $this->repository('XF:UserField');
        $userFields = $userFieldRepo->findFieldsForList()->fetch();
        
        foreach ($userFields as $field) {
            if ($field->show_registration) {
                // Callback validators are too complex for API (require server-side PHP execution)
                if ($field->match_type === 'callback') {
                    return false;
                }
                
                // Color fields are not supported in the API
                if ($field->field_type === 'color' || $field->match_type === 'color') {
                    return false;
                }
            }
        }

        // All checks passed - registration is simple enough for in-app
        return true;
    }
}
