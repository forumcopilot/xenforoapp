<?php

namespace ForumCopilot\Api\Controller;

use XF\Http\Response;
use XF\Mvc\Controller;
use XF\Mvc\ParameterBag;
use XF\Mvc\Reply\AbstractReply;
use ForumCopilot\Api\ErrorCode;
use ForumCopilot\Result\FCResult;
use ForumCopilot\Entity\FCTopic;

/**
 * Abstract Controller for ForumCopilot API
 * Extends XenForo web Controller but provides API-specific methods
 */
abstract class AbstractController extends Controller
{
    /**
     * Not called: forumcopilot.php runs actions directly. Apps send no CSRF
     * token; the dispatcher instead accepts only requests whose Content-Type
     * is exactly application/json, which browsers can't send cross-site
     * without a preflight. Don't wire XenForo's checkCsrfIfNeeded in here: it
     * would refuse every app request.
     */
    protected function preDispatchType($action, ParameterBag $params)
    {
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
        $response->contentType('application/json', 'utf-8');
        
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
     * @param string|\XF\Phrase|FCResult $message Error message or FCResult error object
     * @param int|null $code HTTP status code
     * @param string|null $errorCode One of ErrorCode's constants; worked out from
     *                               the message and HTTP code when null
     * @param array $extra More fields for the reply, such as errors (field => message)
     * @return Response
     */
    protected function apiError($message, $code = null, ?string $errorCode = null, array $extra = []): Response
    {
        // If it's an FCResult object, use its toArray() method
        if ($message instanceof FCResult) {
            $responseData = $message->toArray();
            if (empty($responseData['result'])) {
                $responseData['errorCode'] = $errorCode
                    ?? ErrorCode::infer($responseData['resultText'] ?? '', $code ?: 400, !\XF::visitor()->user_id);
            }
            $responseData = array_merge($responseData, $extra);

            // Create and return a proper XF\Http\Response object
            $response = $this->app->response();
            $response->contentType('application/json', 'utf-8');

            // Add fc_is_login header to indicate if user is logged in
            $this->addLoginStatusHeader($response);

            $response->body(json_encode($responseData));
            $response->httpCode($code ?: 200);

            return $response;
        }

        $isGuest = !\XF::visitor()->user_id;
        $errorCode = $errorCode ?? ErrorCode::infer($message, $code, $isGuest);
        if ($isGuest && $errorCode === ErrorCode::NO_PERMISSION) {
            // A member might be allowed; tell the app that signing in may help
            $errorCode = ErrorCode::GUEST_DENIED;
        }
        $extra = array_merge(['errorCode' => $errorCode], $extra);
        if ($message instanceof \XF\Phrase) {
            $message = $this->plainText($message->render('raw'));
        }

        // Otherwise, use the old method for backward compatibility
        return $this->apiResponse(false, $message, $extra, $code);
    }

    /**
     * Error reply for an exception caught in an action. XenForo's own refusals
     * keep their message: a Reply\Exception from an assert or permission
     * check, or a PrintableException from a service or entity (with its
     * per-field errors). Anything else is logged in XenForo's server error log
     * under a short reference, and the member sees a plain message with that
     * reference, never the exception's own text.
     *
     * @param \Throwable $e
     * @param string $context What was being done, for the log
     *                        (e.g. "getThread")
     * @return Response
     */
    protected function apiException(\Throwable $e, string $context = ''): Response
    {
        if ($e instanceof \XF\Mvc\Reply\Exception) {
            return $this->apiReplyError($e->getReply());
        }

        if ($e instanceof \XF\PrintableException) {
            return $this->apiFieldErrors($e->getMessages());
        }

        $errorId = ErrorCode::logException($e, $context);
        return $this->apiError(
            ErrorCode::unexpectedMessage($errorId),
            null,
            ErrorCode::SERVER_ERROR,
            ['errorId' => $errorId]
        );
    }

    /**
     * Error reply from one of XenForo's own replies: the Error reply of a
     * failed assert or a service's validation, or XenForo's no-permission /
     * registration-required pages.
     */
    protected function apiReplyError(AbstractReply $reply): Response
    {
        $httpCode = $reply->getResponseCode();
        $isGuest = !\XF::visitor()->user_id;

        if ($reply instanceof \XF\Mvc\Reply\Error) {
            $errors = $reply->getErrors();
            if (count($errors) > 1 || is_string(key($errors))) {
                return $this->apiFieldErrors($errors);
            }
            $first = reset($errors);
            return $this->apiError(
                $this->plainText((string)$first),
                null,
                ErrorCode::infer($first, $httpCode, $isGuest)
            );
        }

        if ($reply instanceof \XF\Mvc\Reply\Message) {
            return $this->apiError($this->plainText($reply->getMessage()), null, ErrorCode::infer('', $httpCode, $isGuest));
        }

        // XenForo answers a guest's no-permission with the login page
        if ($isGuest && $reply instanceof \XF\Mvc\Reply\View) {
            return $this->apiError(\XF::phrase('login_required'), null, ErrorCode::GUEST_DENIED);
        }

        return $this->apiError(\XF::phrase('do_not_have_permission'));
    }

    /**
     * Validation error with XenForo's per-field messages, as from
     * $entity->getErrors() or $service->validate($errors). resultText has
     * every message, one per line; `errors` maps each field to its message, as
     * register's reply has since 1.10.0.
     *
     * @param array $errors field name (or index) => message
     * @param string|null $errorCode VALIDATION unless the message says otherwise
     */
    protected function apiFieldErrors(array $errors, ?string $errorCode = null): Response
    {
        $fieldErrors = [];
        foreach ($errors as $field => $error) {
            if (is_string($field)) {
                $fieldErrors[$field] = $this->plainText((string)$error);
            }
        }

        $first = reset($errors);
        $messages = array_unique(array_map(function ($error) {
            return $this->plainText((string)$error);
        }, array_values($errors)));
        if (!$errorCode) {
            $errorCode = $fieldErrors ? ErrorCode::ERROR : ErrorCode::infer($first, null, !\XF::visitor()->user_id);
            if ($errorCode === ErrorCode::ERROR) {
                $errorCode = ErrorCode::VALIDATION;
            }
        }
        return $this->apiError(
            implode("\n", $messages),
            null,
            $errorCode,
            $fieldErrors ? ['errors' => $fieldErrors] : []
        );
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
        $response->contentType('application/json', 'utf-8');
        
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
            // HTTP 200: the app shows resultText only from 2xx replies (401 before 1.11.0)
            return $this->apiError(\XF::phrase('login_required'), null, ErrorCode::LOGIN_REQUIRED);
        }
        return null;
    }

    /**
     * The board-wide checks XenForo's public pages run before every action
     * (XF\Pub\Controller\AbstractController::preDispatchType): banned IP,
     * banned/rejected/disabled account, "View the board" permission, closed
     * board, required two-step verification and security lock.
     *
     * forumcopilot.php calls actions directly, so none of those ran. Node
     * permissions still applied, but a member who lost "View the board" (for
     * example when a paid group expires) or was banned after signing in could
     * keep reading and posting from the app in any forum their other groups
     * open at node level.
     *
     * Errors use HTTP 200 like the rest of the API: the app only reads
     * resultText from 2xx responses.
     *
     * @param bool $signInOnly Only refuse banned IPs, as XenForo's login,
     *                         register and lost-password pages do
     * @param bool $accountSection Skip the "View the board" and required
     *                         two-step checks, as XenForo's account pages do
     *                         (Pub\Controller\AccountController)
     * @return Response|null an error response, or null if the visitor may continue
     */
    public function checkBoardAccess(bool $signInOnly = false, bool $accountSection = false)
    {
        $request = $this->request;
        $bannedIps = $this->app->container('bannedIps');
        if (!empty($bannedIps['data'])
            && \XF\Util\Ip::checkIpsAgainstBinaryRangeList($request->getAllIps(), $bannedIps['data'])
        ) {
            return $this->apiError($this->plainText(\XF::phrase('your_ip_address_has_been_banned')), null, ErrorCode::BANNED);
        }

        if ($signInOnly) {
            return null;
        }

        $visitor = \XF::visitor();
        $errorPlugin = $this->plugin('XF:Error');

        if ($visitor->is_banned) {
            return $this->apiError($this->replyText($errorPlugin->actionBanned()), null, ErrorCode::BANNED);
        }
        if ($visitor->user_state == 'rejected') {
            return $this->apiError($this->replyText($errorPlugin->actionRejected()), null, ErrorCode::ACCOUNT_DISABLED);
        }
        if ($visitor->user_state == 'disabled') {
            return $this->apiError($this->replyText($errorPlugin->actionDisabled()), null, ErrorCode::ACCOUNT_DISABLED);
        }

        if (!$accountSection && !$visitor->hasPermission('general', 'view')) {
            // A new member waiting for confirmation or approval has the
            // guests' permissions; say why rather than "no permission".
            if ($visitor->user_id && $this->isAwaitingMember($visitor)) {
                return $this->apiError($this->plainText($visitor->isAwaitingEmailConfirmation()
                    ? \XF::phrase('your_account_is_currently_awaiting_confirmation_confirmation_sent_to_x', ['email' => $visitor->email])
                    : \XF::phrase('your_account_is_currently_awaiting_approval_by_administrator')
                ), null, ErrorCode::ACCOUNT_PENDING);
            }
            return $this->apiError($this->plainText(
                \XF::phrase($visitor->user_id ? 'do_not_have_permission' : 'login_required')
            ), null, $visitor->user_id ? ErrorCode::NO_PERMISSION : ErrorCode::LOGIN_REQUIRED);
        }

        $options = $this->options();
        if (!$options->boardActive && !$visitor->is_admin) {
            return $this->apiError($this->plainText($options->boardInactiveMessage), null, ErrorCode::BOARD_CLOSED);
        }

        if (!$accountSection
            && $visitor->user_id
            && empty($visitor->Option->use_tfa)
            && \XF::config('enableTfa')
            && $visitor->hasPermission('general', 'requireTfa')
        ) {
            // Plain text drops the phrase's link to the two-step setup page
            return $this->apiError($this->plainText(
                \XF::phrase('you_must_enable_two_step_to_continue', ['link' => ''])
            ), null, ErrorCode::TFA_REQUIRED);
        }

        if ($visitor->user_id && $visitor->security_lock) {
            return $this->apiError(\XF::phrase('your_account_is_currently_security_locked'), null, ErrorCode::SECURITY_LOCKED);
        }

        return null;
    }

    /**
     * A new member waiting for their email confirmation or for approval.
     * XenForo gives them the guests' permissions until then.
     */
    protected function isAwaitingMember(\XF\Entity\User $user): bool
    {
        return in_array($user->user_state, ['email_confirm', 'email_confirm_edit', 'moderated'], true);
    }

    /**
     * Message text of an error or message reply from XenForo's Error plugin
     * (ban reason and end date, rejection reason, ...), as plain text.
     */
    protected function replyText(AbstractReply $reply): string
    {
        if ($reply instanceof \XF\Mvc\Reply\Error) {
            return $this->plainText(implode("\n", array_map('strval', $reply->getErrors())));
        }
        if ($reply instanceof \XF\Mvc\Reply\Message) {
            return $this->plainText($reply->getMessage());
        }
        return $this->plainText(\XF::phrase('do_not_have_permission'));
    }

    /**
     * Phrases and admin-written messages here are HTML; the app shows text.
     */
    protected function plainText($html): string
    {
        return trim(html_entity_decode(strip_tags((string)$html), ENT_QUOTES | ENT_HTML5, 'UTF-8'));
    }

    /**
     * Check if the user is flooding (performing action too frequently)
     * Returns an error response if flooding, null otherwise
     * Consistent with web version. HTTP 200 with errorCode flood: the app
     * shows resultText only from 2xx replies (it was 429 before 1.11.0).
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
                \XF::phrase('must_wait_x_seconds_before_performing_this_action', ['count' => $timeRemaining]),
                null,
                ErrorCode::FLOOD
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
            throw new \XF\Mvc\Reply\Exception($this->error(\XF::phrase('requested_forum_not_found'), 404));
        }

        $error = null;
        if (!$forum->canView($error)) {
            throw new \XF\Mvc\Reply\Exception($this->error($error ?: \XF::phrase('do_not_have_permission'), 403));
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
            throw new \XF\Mvc\Reply\Exception($this->error(\XF::phrase('requested_thread_not_found'), 404));
        }

        $error = null;
        if (!$thread->canView($error)) {
            throw new \XF\Mvc\Reply\Exception($this->error($error ?: \XF::phrase('do_not_have_permission'), 403));
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
            throw new \XF\Mvc\Reply\Exception($this->error(\XF::phrase('requested_post_not_found'), 404));
        }

        $error = null;
        if (!$post->canView($error)) {
            throw new \XF\Mvc\Reply\Exception($this->error($error ?: \XF::phrase('do_not_have_permission'), 403));
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
            throw new \XF\Mvc\Reply\Exception($this->error(\XF::phrase('requested_message_not_found'), 404));
        }

        $error = null;
        if (!$message->canView($error)) {
            throw new \XF\Mvc\Reply\Exception($this->error($error ?: \XF::phrase('do_not_have_permission'), 403));
        }

        return $message;
    }

    /**
     * The visitor's own copy of a conversation, as XenForo's
     * ConversationController::assertViewableUserConversation finds it: only
     * participants have one, so it is the participant check too.
     *
     * @return \XF\Entity\ConversationUser
     * @throws \XF\Mvc\Reply\Exception not found when the visitor isn't a participant
     */
    protected function assertViewableUserConversation($conversationId, array $extraWith = [])
    {
        $finder = $this->finder('XF:ConversationUser');
        $finder->where('owner_user_id', \XF::visitor()->user_id);
        $finder->where('conversation_id', (int)$conversationId);
        $finder->with($extraWith);

        $userConv = $finder->fetchOne();
        if (!$userConv || !$userConv->Master) {
            // Renamed with "direct messages" in XenForo 2.3
            $phrase = \XF::$versionId >= 2030000 ? 'requested_direct_message_not_found' : 'requested_conversation_not_found';
            throw new \XF\Mvc\Reply\Exception($this->error(\XF::phrase($phrase), 404));
        }

        return $userConv;
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
     * The visitor's watch on a forum and its options, as XenForo's forum
     * page and "Watch forum" form show them. Pass the ForumWatch (or null)
     * when it was loaded already, as getForum does for every forum in one
     * query; otherwise it is looked up through the forum's Watch relation
     * (no query when the forum was loaded with Watch|<user id>).
     *
     * @param \XF\Entity\Forum $forum The forum entity
     * @param \XF\Entity\User|null $visitor The visitor (defaults to current visitor)
     * @param \XF\Entity\ForumWatch|null|false $watch false = look it up
     * @return array canWatch, isWatched, and since 1.11.0 notifyOn ("thread",
     *               "message" or "" for no notifications; null when not
     *               watched), sendAlert, sendEmail, allowedWatchNotifications
     *               (what the forum offers: "all", "thread" or "none")
     */
    protected function getForumWatchStatus($forum, $visitor = null, $watch = false)
    {
        if ($visitor === null) {
            $visitor = \XF::visitor();
        }

        $status = [
            'canWatch' => false,
            'isWatched' => false,
            'notifyOn' => null,
            'sendAlert' => false,
            'sendEmail' => false,
            'allowedWatchNotifications' => (string)$forum->allowed_watch_notifications,
        ];

        // Guests cannot watch
        if (!$visitor->user_id) {
            return $status;
        }

        $status['canWatch'] = (bool)$forum->canWatch();

        if ($watch === false) {
            $watch = $forum->Watch[$visitor->user_id];
        }
        if ($watch) {
            $status['isWatched'] = true;
            $status['notifyOn'] = (string)$watch->notify_on;
            $status['sendAlert'] = (bool)$watch->send_alert;
            $status['sendEmail'] = (bool)$watch->send_email;
        }

        return $status;
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
     * Watch a thread the visitor just started or replied to, by their "watch
     * content on creation" / "on interaction" preference, as XenForo's own
     * ForumController::finalizeThreadCreate and
     * ThreadController::finalizeThreadReply do when the form sends no explicit
     * watch choice. Without it, threads started in the app were never watched,
     * so their starter got no alerts or pushes for replies.
     *
     * Best-effort: the post is already saved, so a failure here is logged and
     * never fails the call.
     */
    protected function autoWatchThread(\XF\Entity\Thread $thread, bool $onCreation)
    {
        try {
            if ($thread->canWatch()) {
                $this->repository('XF:ThreadWatch')->autoWatchThread($thread, \XF::visitor(), $onCreation);
            }
        } catch (\Exception $e) {
            \XF::logException($e, false, 'ForumCopilot: auto-watch failed: ');
        }
    }

    /**
     * Number of reactions on a post or conversation message: what the API
     * reports as likeCount. Not reaction_score, which sums each reaction's
     * score: XenForo's stock Wow, Sad and Angry score 0, so content whose
     * only reaction was a Wow reported 0 and the app hid its reaction row,
     * and Like + Wow reported 1. The `reactions` column (reaction_id =>
     * count, active reactions only) exists on 2.2 and 2.3.
     *
     * @param \XF\Mvc\Entity\Entity|null $content
     * @return int
     */
    protected function getReactionCount($content)
    {
        if (!$content) {
            return 0;
        }

        try {
            if ($content->isValidColumn('reactions')) {
                $counts = $content->reactions;
                return is_array($counts) ? (int) array_sum($counts) : 0;
            }
        } catch (\Throwable $e) {
            // fall back to the score below
        }

        return isset($content->reaction_score) ? max(0, (int) $content->reaction_score) : 0;
    }

    /**
     * Get list of users who liked/reacted to a post
     * Returns an array of like information with userId, username, avatarUrl, and timestamp
     * 
     * @param \XF\Entity\Post $post The post entity
     * @param array|null $reactions The post's reactions when already read for
     *                              the whole page (ReactionContent entities);
     *                              null reads them here
     * @return array Array of like information
     */
    protected function getPostLikesInfo($post, ?array $reactions = null)
    {
        $likesInfo = [];
        
        try {
            // Check if reaction system is available. XenForo 2.3 names the
            // repository ReactionRepository; 2.2 names it Reaction. Checking
            // only the 2.3 name returned an empty list on every 2.2 forum.
            if (!class_exists('\XF\Repository\ReactionRepository')
                && !class_exists('\XF\Repository\Reaction')
            ) {
                return $likesInfo;
            }
            
            if ($reactions === null) {
                // Use XenForo's repository method to find reactions properly,
                // with all relations loaded
                $reactions = $this->repository('XF:Reaction')
                    ->findContentReactions('post', $post->post_id)
                    ->fetch();
            }
            
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
                        
                        // Native emoji (2.3's emoji_shortname, or the
                        // built-in set mapped by name) and a usable icon URL,
                        // shared with getConfig so the picker and the "who
                        // reacted" list agree.
                        $reactionEmoji = ConfigController::emojiForReaction($reaction);
                        $reactionIconUrl = ConfigController::iconUrlForReaction($reaction, $this);
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
     * The position (floor number) of a post in its thread, 1-based: first
     * post is #1, first reply is #2, etc.
     *
     * XenForo keeps it in the post's position column, 0-based, counting
     * visible posts; a moderated or deleted post shares the number of the
     * visible post before it.
     *
     * @param \XF\Entity\Post $post The post entity
     * @return int The position of the post in the thread (1-based)
     */
    protected function getPostPosition($post)
    {
        return (int)$post->position + 1;
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
            // Count the visible messages up to this one. Messages posted in the
            // same second are told apart by ID, as they are ordered; counting
            // by date alone gave them all the last one's number.
            $messageRepo = $this->repository('XF:ConversationMessage');
            $positionFinder = $messageRepo->findMessagesForConversationView($conversation);
            $positionFinder->whereOr(
                ['message_date', '<', $message->message_date],
                [
                    ['message_date', '=', $message->message_date],
                    ['message_id', '<=', $message->message_id],
                ]
            );
            
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

            // The forum's censored words, as XenForo replaces them when it
            // shows the message
            $cleaned = $formatter->censorText($cleaned);
            
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
            $cleaned = strip_tags($this->app()->stringFormatter()->censorText($message));
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
                if ($firstPost) {
                    $likeCount = $this->getReactionCount($firstPost);
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
            // Locked threads: discussion_open (discussion_state is only visible/moderated/deleted)
            'isClosed' => !$thread->discussion_open,
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
            // Soft-deleted threads, which getTopic lists for moderators who may see them
            'isDeleted' => $thread->discussion_state === 'deleted',
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
            // Check if reaction system is available. XenForo 2.3 names the
            // repository ReactionRepository; 2.2 names it Reaction. Same fix
            // as getPostLikesInfo (1.8.4), which this copy had missed.
            if (!class_exists('\XF\Repository\ReactionRepository')
                && !class_exists('\XF\Repository\Reaction')
            ) {
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
                        
                        // Native emoji (2.3's emoji_shortname, or the
                        // built-in set mapped by name) and a usable icon URL,
                        // shared with getConfig so the picker and the "who
                        // reacted" list agree. Reading emoji_shortname
                        // directly threw on 2.2, which has no such column.
                        $reactionEmoji = ConfigController::emojiForReaction($reaction);
                        $reactionIconUrl = ConfigController::iconUrlForReaction($reaction);
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
     * MIME type of an attachment from its file extension, for the app to pick
     * a viewer. Empty when unknown.
     */
    protected function mimeTypeForExtension($extension): string
    {
        $map = [
            'txt' => 'text/plain', 'csv' => 'text/csv', 'pdf' => 'application/pdf',
            'zip' => 'application/zip', 'jpg' => 'image/jpeg', 'jpeg' => 'image/jpeg', 'jpe' => 'image/jpeg',
            'png' => 'image/png', 'gif' => 'image/gif', 'webp' => 'image/webp', 'heic' => 'image/heic',
            'svg' => 'image/svg+xml', 'mp4' => 'video/mp4', 'm4v' => 'video/mp4', 'mov' => 'video/quicktime',
            'webm' => 'video/webm', 'mp3' => 'audio/mpeg', 'm4a' => 'audio/mp4', 'ogg' => 'audio/ogg',
            'wav' => 'audio/wav', 'doc' => 'application/msword',
            'docx' => 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
            'xls' => 'application/vnd.ms-excel',
            'xlsx' => 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        ];
        return $map[strtolower((string)$extension)] ?? '';
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
        
        if (!$message->attach_count) {
            return $attachments;
        }

        try {
            // Usually filled for the whole page by addAttachmentsToContent
            $messageAttachments = $message->Attachments;
            
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
                
                $mimeType = $this->mimeTypeForExtension($data->extension);
                
                // Get attachment URL (only if user can view full attachment)
                // Use getDirectUrl() which returns direct file URL when available, or route URL as fallback
                $url = '';
                if ($canView) {
                    try {
                        // getDirectUrl() (XenForo 2.3) returns direct file URL for videos/audio, or attachment route URL for others
                        $url = method_exists($attachment, 'getDirectUrl')
                            ? $this->getAbsoluteUrl($attachment->getDirectUrl(true))
                            : $this->buildLink('canonical:attachments', $attachment);
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
                
                // The edit page shows the size as XenForo writes it
                $attachments[] = $fcAttachment->toArray() + [
                    'fileSizePrintable' => \XF::language()->fileSizeFormat($attachment->file_size),
                ];
            }
        } catch (\Exception $e) {
            // If attachment loading fails, log error and return empty array
            \XF::logError('ForumCopilot: Error loading message attachments: ' . $e->getMessage());
        }
        
        return $attachments;
    }

    // Reactions (posts and direct messages)

    /**
     * Adds, switches or toggles off the visitor's reaction on a post or
     * direct message, as XenForo's ReactionPlugin does: canReact first (with
     * XenForo's reason), then the reaction must exist and be active; an
     * inactive one is accepted only to take the visitor's own reaction off.
     *
     * @param \XF\Mvc\Entity\Entity $content a post or conversation message
     * @return array|Response ['reactionId' => the visitor's reaction now, or
     *                        null when toggled off], or an error reply
     */
    protected function toggleVisitorReaction($content, int $reactionId)
    {
        $error = null;
        if (!$content->canReact($error)) {
            return $this->apiError($error ?: \XF::phrase('do_not_have_permission'), null, ErrorCode::NO_PERMISSION);
        }

        $visitor = \XF::visitor();
        $contentType = $content->getEntityContentType();
        $contentId = $content->getEntityId();
        $reactionRepo = $this->repository('XF:Reaction');

        $reaction = $reactionId > 0 ? $this->em()->find('XF:Reaction', $reactionId) : null;
        $existing = $reactionRepo->getReactionByContentAndReactionUser($contentType, $contentId, $visitor->user_id);
        if (!$reaction
            || (!$reaction->active && (!$existing || $existing->reaction_id != $reaction->reaction_id))
        ) {
            return $this->apiError(\XF::phrase('requested_page_not_found'), null, ErrorCode::NOT_FOUND);
        }

        $new = $reactionRepo->reactToContent($reaction->reaction_id, $contentType, $contentId, $visitor, true, false);

        return ['reactionId' => $new ? (int)$new->reaction_id : null];
    }

    /**
     * Takes the visitor's reaction off a post or direct message, whichever it
     * is, through reactToContent as XenForo's toggle does (so its alerts and
     * counters are undone the same way). Nothing to do is not an error.
     *
     * @param \XF\Mvc\Entity\Entity $content
     * @return Response|null an error reply, or null
     */
    protected function removeVisitorReaction($content)
    {
        $error = null;
        if (!$content->canReact($error)) {
            return $this->apiError($error ?: \XF::phrase('do_not_have_permission'), null, ErrorCode::NO_PERMISSION);
        }

        $visitor = \XF::visitor();
        $reactionRepo = $this->repository('XF:Reaction');
        $existing = $reactionRepo->getReactionByContentAndReactionUser(
            $content->getEntityContentType(),
            $content->getEntityId(),
            $visitor->user_id
        );
        if ($existing) {
            $reactionRepo->reactToContent(
                $existing->reaction_id,
                $content->getEntityContentType(),
                $content->getEntityId(),
                $visitor,
                true,
                false
            );
        }

        return null;
    }

    /**
     * Whether the app's own sign-up form may be used (prefetchAccount says so
     * in canRegisterViaAPI, and register refuses otherwise): the board is
     * open, registration is on, guests are not shown a captcha, and no
     * registration field needs what the app cannot do. Otherwise members
     * sign up on the forum's website.
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

        // Third check: no captcha. The app cannot show one, and skipping it
        // would let a script sign up with one request. Forums that show
        // guests a captcha (any kind, Q&A included) are signed up on the
        // website, where it works.
        if ($this->repository('XF:User')->getGuestUser()->isShownCaptcha() && $this->app()->captcha()) {
            return false;
        }

        // Fourth check: No unsupported custom field types during registration
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
