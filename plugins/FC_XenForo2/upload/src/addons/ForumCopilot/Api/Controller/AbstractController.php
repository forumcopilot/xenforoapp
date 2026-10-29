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
     * A guest's no_permission is reported as guest_denied ("signing in may
     * help"). Off where the methods are the sign-in pages themselves.
     */
    protected $guestDeniedForGuests = true;

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
        if ($isGuest && $errorCode === ErrorCode::NO_PERMISSION && $this->guestDeniedForGuests) {
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
     * The visitor's watch on a thread. Reads the thread's Watch relation, so
     * lists that load threads with Watch|<user id> (addTopicListWith) need
     * no query per row.
     *
     * @param \XF\Entity\Thread $thread The thread entity
     * @param \XF\Entity\User|null $visitor The visitor (defaults to current visitor)
     * @return array canWatch, isWatched, emailSubscribe (1.11.0)
     */
    protected function getThreadWatchStatus($thread, $visitor = null)
    {
        if ($visitor === null) {
            $visitor = \XF::visitor();
        }

        // If guest user, cannot watch and not watched
        if (!$visitor->user_id) {
            return ['canWatch' => false, 'isWatched' => false, 'emailSubscribe' => false];
        }

        $watch = $thread->Watch[$visitor->user_id];

        return [
            'canWatch' => (bool)$thread->canWatch(),
            'isWatched' => (bool)$watch,
            'emailSubscribe' => $watch ? (bool)$watch->email_subscribe : false,
        ];
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
     * Thread finder for the What's New style lists (getLatestTopic,
     * getUnreadTopic, getParticipatedTopic), as XenForo's FindNew thread
     * handler builds it, with the relations every row needs
     * (addTopicListWith).
     *
     * @param array $options Optional options:
     *   - 'requireFindNew' (bool): only forums shown in What's New (default: true)
     *   - 'skipIgnored' (bool): leave out threads started by ignored members (default: true)
     *   - 'restrictViewable' (bool): only threads the visitor may read, decided in the
     *     query (getReadableForumIds), so pages are full and totals match (default: false)
     *   - 'includeModerated' (bool): also threads awaiting approval that the visitor may
     *     see, as What's New lists them for moderators and their authors (default: false)
     *   - 'useLastPost' (bool): rows describe the last post (default: true)
     * @return \XF\Finder\Thread
     */
    protected function setupTopicListFinder(array $options = [])
    {
        $visitor = \XF::visitor();

        $requireFindNew = $options['requireFindNew'] ?? true;
        $skipIgnored = $options['skipIgnored'] ?? true;
        $restrictViewable = $options['restrictViewable'] ?? false;
        $includeModerated = $options['includeModerated'] ?? false;

        $finder = $this->finder('XF:Thread');
        $this->addTopicListWith($finder, $options['useLastPost'] ?? true);

        if ($requireFindNew) {
            $finder->where('Forum.find_new', true);
        }

        $finder->where('discussion_type', '<>', 'redirect');
        $finder->order('last_post_date', 'DESC');
        $finder->indexHint('FORCE', 'last_post_date');

        $forums = $restrictViewable ? $this->getReadableForumIds($requireFindNew) : null;

        if ($includeModerated) {
            // ThreadHandler (What's New) takes every state but deleted, then canView
            $states = [['discussion_state', 'visible']];
            if ($forums === null) {
                $states[] = ['discussion_state', 'moderated'];
            } elseif ($forums['moderated']) {
                $states[] = [['discussion_state', 'moderated'], ['node_id', $forums['moderated']]];
            }
            if ($visitor->user_id) {
                $states[] = [['discussion_state', 'moderated'], ['user_id', $visitor->user_id]];
            }
            $finder->whereOr($states);
        } else {
            $finder->where('discussion_state', 'visible');
        }

        if ($forums !== null) {
            $readable = [['node_id', $forums['full']]];
            if ($forums['own']) {
                // "View threads by others" off: only the member's own threads
                $readable[] = [['node_id', $forums['own']], ['user_id', $visitor->user_id]];
            }
            $finder->whereOr($readable);
        }

        if ($skipIgnored && $visitor->user_id) {
            $finder->skipIgnored($visitor);
        }

        return $finder;
    }

    /**
     * Apply filters to thread finder (as XenForo's FindNew ThreadHandler
     * applyFilters does)
     *
     * @param \XF\Finder\Thread $threadFinder
     * @param array $filters Filter names, as a list (["unread", "watched"]) or a
     *   map ({"unread": true}):
     *   - 'unread' (bool): Show only unread threads (applies date cutoff automatically)
     *   - 'watched' (bool): Show only watched threads, or threads in watched forums
     *   - 'participated' (bool): Show threads where user has posted
     *   - 'started' (bool): Show threads started by user
     *   - 'unanswered' (bool): Show threads with no replies
     *   unread, watched, participated and started need a member: XenForo
     *   ignores them for guests.
     * @param \XF\Entity\User|null $user User to apply filters for (default: visitor)
     * @param array $options 'noCutoff' (bool): no "recent activity" date limit,
     *   for lists that are not What's New (default: false)
     */
    protected function applyTopicFilters(\XF\Finder\Thread $threadFinder, array $filters, $user = null, array $options = [])
    {
        if (!$user) {
            $user = \XF::visitor();
        }

        // The SDK sends a list of names; older callers a map of name => bool
        $normalized = [];
        foreach ($filters as $key => $value) {
            if (is_int($key) && is_string($value)) {
                $normalized[$value] = true;
            } elseif (is_string($key)) {
                $normalized[$key] = !empty($value) && $value !== 'false';
            }
        }
        $filters = $normalized;

        if (!$user->user_id) {
            unset($filters['unread'], $filters['watched'], $filters['participated'], $filters['started']);
        }
        
        // If unread filter is set, use unreadOnly (which already applies date cutoff)
        if (!empty($filters['unread'])) {
            $threadFinder->unreadOnly($user->user_id);
        } elseif (empty($options['noCutoff'])) {
            // Apply date cutoff for recent posts (matches web behavior)
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
     * Centralized conversion logic used across all topic listing methods.
     * Load threads with addTopicListWith() first: every value here then
     * comes from the loaded rows, with no query per thread.
     *
     * @param \XF\Entity\Thread $thread
     * @param \XF\Entity\User|null $visitor Visitor user (default: current visitor)
     * @param array $options Optional options:
     *   - 'useLastPost' (bool): author fields, timestamp and preview describe the
     *     last post (default: false: the thread starter and first post).
     *     starter* and lastPoster* fields always say which is which.
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
        
        // Reactions on the first post, from the thread's copy of them
        // (first_post_reactions, XenForo 2.1+): no need to load the post
        $likeCount = 0;
        if ($thread->isValidColumn('first_post_reactions') && is_array($thread->first_post_reactions)) {
            $likeCount = (int)array_sum($thread->first_post_reactions);
        } elseif ($thread->isValidColumn('first_post_reaction_score')) {
            $likeCount = max(0, (int)$thread->first_post_reaction_score);
        }

        // Who started the thread; thread.username keeps the name of a deleted member
        $starter = $thread->User;
        $starterName = $starter ? $starter->username : (string)$thread->username;
        $starterIconUrl = $starter ? $this->getAbsoluteUrl($starter->getAvatarUrl('s')) : '';

        // Who posted last (the starter when there are no replies)
        $lastPoster = $thread->last_post_user_id ? $thread->LastPoster : null;
        $lastPosterName = $lastPoster ? $lastPoster->username : (string)$thread->last_post_username;
        $lastPosterIconUrl = $lastPoster ? $this->getAbsoluteUrl($lastPoster->getAvatarUrl('s')) : '';

        // Use last_post_date for timestamp to match ordering by last_post_date DESC in topic listings
        $timestamp = $thread->last_post_date * 1000;
        $shortContent = '';
        try {
            if ($useLastPost) {
                $authorName = $lastPosterName ?: 'Unknown';
                $authorId = (string)$thread->last_post_user_id;
                $authorUserType = $lastPoster ? (string)$lastPoster->user_group_id : '0';
                $authorIconUrl = $lastPosterIconUrl;
                $post = $thread->last_post_id ? $thread->LastPost : null;
            } else {
                $authorName = $starterName ?: 'Unknown';
                $authorId = (string)$thread->user_id;
                $authorUserType = $starter ? (string)$starter->user_group_id : '0';
                $authorIconUrl = $starterIconUrl;
                $post = $thread->first_post_id ? $thread->FirstPost : null;
            }
            if ($post && $post->message) {
                $shortContent = $this->getShortContent($post->message);
            }
        } catch (\Exception $e) {
            // If add-on conflict occurs, leave the preview empty
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

        // Thread types (XenForo 2.2+): a thread with a poll is a "poll" thread
        $threadType = (string)$thread->discussion_type;
        $hasPoll = ($threadType === 'poll');

        // Moved threads leave a "redirect" thread behind pointing at the new place
        $isMoved = ($threadType === 'redirect');
        $realTopicId = null;
        $redirectUrl = null;
        if ($isMoved) {
            try {
                $redirect = $thread->Redirect;
                if ($redirect) {
                    $redirectUrl = (string)$redirect->target_url;
                    $threadRepo = $this->repository('XF:Thread');
                    $target = method_exists($threadRepo, 'getThreadFromUrl')
                        ? $threadRepo->getThreadFromUrl($redirectUrl, 'public')
                        : null;
                    if ($target) {
                        $realTopicId = (string)$target->thread_id;
                    }
                }
            } catch (\Exception $e) {
                // An external or broken link: no thread to point to
            }
        }

        // Question threads: the accepted answer is kept in type_data
        $solutionPostId = 0;
        if ($threadType === 'question' && $thread->isValidColumn('type_data')) {
            $typeData = $thread->type_data;
            $solutionPostId = (int)($typeData['solution_post_id'] ?? 0);
        }

        $row = [
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
            'isMoved' => $isMoved,
            'isMerged' => false,
            'realTopicId' => $realTopicId,
            'canLike' => $canLike,
            'isLiked' => $isLiked,
            'likeCount' => $likeCount,
            'hasPoll' => $hasPoll,

            // 1.11.0 (FCTopic::OPTIONAL_FIELDS)
            'starterId' => (string)$thread->user_id,
            'starterName' => $starterName,
            'startDate' => $thread->post_date * 1000,
            'lastPosterId' => (string)$thread->last_post_user_id,
            'lastPosterName' => $lastPosterName,
            'lastPosterIconUrl' => $lastPosterIconUrl,
            'lastPostedAt' => $thread->last_post_date * 1000,
            'threadType' => $threadType,
            'isSolved' => $solutionPostId > 0,
            'solutionPostId' => $solutionPostId,
            'tags' => $this->getThreadTagNames($thread),
            'redirectUrl' => $redirectUrl,
            'isIgnored' => $thread->isIgnored(),
            'emailSubscribe' => $threadWatchStatus['emailSubscribe'],
        ];

        // Suggestion votes: columns of XenForo 2.2+
        if ($thread->isValidColumn('vote_score')) {
            $row['voteScore'] = (int)$thread->vote_score;
            $row['voteCount'] = (int)$thread->vote_count;
            if ($threadType === 'suggestion' && method_exists($thread, 'canVoteOnContent')) {
                $row['canVote'] = $thread->canVoteOnContent();
                $row['userVoted'] = $thread->getVisitorContentVote() !== null;
            }
        }

        return new FCTopic($row);
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
     * Common logic for fetching, converting, and filtering threads.
     * Rows startNum..lastNum (at most TOPIC_LIST_MAX_ROWS of them).
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

        [$offset, $perPage] = $this->getTopicListWindow($startNum, $lastNum);

        $total = $finder->total();
        $threads = $finder->limit($perPage, $offset)->fetch();
        
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

    // Topic lists (topics, forums, subscriptions)

    /** Most rows one topic list call returns (the app asks for 20 or 21) */
    const TOPIC_LIST_MAX_ROWS = 100;

    /** @var \XF\Mvc\Entity\AbstractCollection|null getViewableForums(), once per call */
    protected $viewableForums = null;

    /**
     * Offset and row count for the startNum..lastNum window of a topic list,
     * capped at TOPIC_LIST_MAX_ROWS rows. Rows are counted from startNum
     * itself, so a window that doesn't start on a page boundary still gets
     * the rows it asked for.
     *
     * @return int[] [offset, rows]
     */
    protected function getTopicListWindow($startNum, $lastNum): array
    {
        $offset = max(0, (int)$startNum);
        $rows = (int)$lastNum - $offset + 1;

        return [$offset, max(1, min(self::TOPIC_LIST_MAX_ROWS, $rows))];
    }

    /**
     * Eager-loads what convertThreadToFCTopic and the thread permission
     * checks read, so a topic list costs a fixed number of queries whatever
     * its length (as XenForo's own lists load "fullForum" and node
     * permissions).
     *
     * @param \XF\Finder\Thread $finder
     * @param bool $useLastPost Load the last post (the preview of most lists)
     *                          or the first post
     * @return \XF\Finder\Thread
     */
    protected function addTopicListWith($finder, bool $useLastPost = true)
    {
        $visitor = \XF::visitor();

        $with = [
            'Forum',
            'Forum.Node',
            'Forum.Node.Permissions|' . $visitor->permission_combination_id,
            'User',
            'LastPoster',
            'Prefix',
            $useLastPost ? 'LastPost' : 'FirstPost',
        ];
        if ($userId = $visitor->user_id) {
            $with[] = 'Read|' . $userId;
            $with[] = 'Forum.Read|' . $userId;
            $with[] = 'Watch|' . $userId;
            $with[] = 'ReplyBans|' . $userId;
        }

        return $finder->with($with);
    }

    /**
     * The forums whose threads the visitor may read, split the way
     * Thread::canView decides:
     *   - full: others' threads and their content;
     *   - own: content, but only of the member's own threads ("View threads
     *     by others" off; never for guests);
     *   - moderated: full forums where threads awaiting approval show too.
     *
     * @param bool $findNewOnly Only forums shown in What's New
     * @return array ['full' => int[], 'own' => int[], 'moderated' => int[]]
     */
    protected function getReadableForumIds(bool $findNewOnly = false): array
    {
        $visitor = \XF::visitor();
        $ids = ['full' => [], 'own' => [], 'moderated' => []];

        if ($this->viewableForums === null) {
            $this->viewableForums = $this->repository('XF:Forum')->getViewableForums();
        }

        foreach ($this->viewableForums as $nodeId => $forum) {
            if ($findNewOnly && !$forum->find_new) {
                continue;
            }
            if (!$visitor->hasNodePermission($nodeId, 'viewContent')) {
                continue;
            }
            if ($visitor->hasNodePermission($nodeId, 'viewOthers')) {
                $ids['full'][] = $nodeId;
                if ($visitor->hasNodePermission($nodeId, 'viewModerated')) {
                    $ids['moderated'][] = $nodeId;
                }
            } elseif ($visitor->user_id) {
                $ids['own'][] = $nodeId;
            }
        }

        return $ids;
    }

    /**
     * The prefixes the visitor may pick when starting a thread in the forum
     * (Forum::getUsablePrefixes), as [{id, title, group}]; group is the
     * prefix group's title, "" for ungrouped prefixes.
     */
    protected function getUsablePrefixList(\XF\Entity\Forum $forum): array
    {
        $prefixes = [];
        try {
            foreach ($forum->getUsablePrefixes() as $groupId => $group) {
                foreach ($group as $prefix) {
                    if (!$prefix instanceof \XF\Entity\ThreadPrefix) {
                        continue;
                    }
                    $groupTitle = '';
                    if ($groupId && $prefix->prefix_group_id) {
                        $groupTitle = (string)\XF::phrase('thread_prefix_group.' . $prefix->prefix_group_id);
                    }
                    $prefixes[] = [
                        'id' => (string)$prefix->prefix_id,
                        'title' => (string)$prefix->title,
                        'group' => $groupTitle,
                    ];
                }
            }
        } catch (\Exception $e) {
            // If prefix retrieval fails, offer none
            $prefixes = [];
        }
        return $prefixes;
    }

    /**
     * Tag names of a thread, from its cached tag list (no query). None while
     * the forum's tagging is off: the thread page then lists no tags.
     */
    protected function getThreadTagNames(\XF\Entity\Thread $thread): array
    {
        $names = [];
        if (!$this->options()->enableTagging) {
            return $names;
        }
        $tags = $thread->tags;
        if (is_array($tags)) {
            foreach ($tags as $tag) {
                if (is_array($tag) && isset($tag['tag'])) {
                    $names[] = (string)$tag['tag'];
                }
            }
        }
        return $names;
    }

    /**
     * The title under a member's name on their posts and messages, as the
     * website shows it (message_macros::user_info, <xf:usertitle
     * banner="true">): the custom title, else the display group's title or
     * the forum's title ladder, the guest group's title for guests and
     * deleted members. Empty where the website shows none, as where the
     * forum hides titles of members who have a banner. Plain text.
     */
    protected function getMessageUserTitle(?\XF\Entity\User $user): string
    {
        try {
            return $this->plainText($this->app()->templater()->func('user_title', [$user, true]));
        } catch (\Throwable $e) {
            \XF::logException($e, false, 'ForumCopilot: user title failed: ');
            return '';
        }
    }

    // contentHtml (posts and direct messages)

    /**
     * Loads what HTML rendering needs for a page of posts or messages in a
     * few queries, as ThreadPlugin::fetchExtraContentForPostsFullView does:
     * link previews (2.2+) and embeds (2.3). Attachments are loaded by the
     * callers already.
     *
     * @param \XF\Mvc\Entity\AbstractCollection $content
     */
    protected function preloadAppHtmlContent($content)
    {
        if (!$content->count()) {
            return;
        }
        try {
            $unfurlRepo = $this->repository('XF:Unfurl');
            if (method_exists($unfurlRepo, 'addUnfurlsToContent')) {
                $unfurlRepo->addUnfurlsToContent($content, true);
            }
            if (class_exists('XF\Repository\EmbedResolverRepository')) {
                $this->repository('XF:EmbedResolver')->addEmbedsToContent($content);
            }
        } catch (\Throwable $e) {
            \XF::logException($e, false, 'Forum Copilot contentHtml preload: ');
        }
    }

    /**
     * BBCode as the app's HTML (ForumCopilot\BbCode\Renderer\AppHtml), with
     * the content's own render options (attachments, link previews, the
     * forum's censoring). Empty when rendering fails; the BBCode is always
     * sent too.
     *
     * @param \XF\Mvc\Entity\Entity|null $content the post, message or user it belongs to
     */
    protected function renderAppHtml($bbCode, string $context, $content = null): string
    {
        if ((string)$bbCode === '') {
            return '';
        }
        try {
            return (string)$this->app()->bbCode()->render((string)$bbCode, 'ForumCopilot:AppHtml', $context, $content);
        } catch (\Throwable $e) {
            \XF::logException($e, false, 'Forum Copilot contentHtml (' . $context . '): ');
            return '';
        }
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
