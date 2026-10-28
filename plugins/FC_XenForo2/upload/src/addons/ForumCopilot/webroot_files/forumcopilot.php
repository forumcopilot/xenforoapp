<?php

use XF\Pub\App as PubApp;

$phpVersion = phpversion();
if (version_compare($phpVersion, '7.2.0', '<'))
{
    header('Content-Type: application/json; charset=UTF-8');
    http_response_code(500);
    echo json_encode([
        'result' => false,
        'resultText' => "PHP 7.2.0 or newer is required. $phpVersion does not meet this requirement. Please ask your host to upgrade PHP."
    ]);
    exit;
}

$dir = __DIR__;

// Initialize XenForo exactly like index.php does
try
{
    require $dir . '/src/XF.php';
    \XF::start($dir);
}
catch (\Throwable $e)
{
    // If XenForo initialization fails, return JSON error
    header('Content-Type: application/json; charset=UTF-8');
    http_response_code(500);
    // The reason (often database details) goes to PHP's error log, not to the client
    error_log('Forum Copilot: XenForo failed to start: ' . $e->getMessage());
    echo json_encode([
        'result' => false,
        'resultText' => 'The forum is not available right now. Please try again later.',
        'errorCode' => 'server_error'
    ]);
    exit;
}

// Override PubApp to add API interception with full add-on loading
class ForumCopilotPubApp extends PubApp
{
    /**
     * Methods behind the sign-in screens. Like XenForo's login, register and
     * lost-password pages they only refuse banned IPs, so a visitor without
     * "View the board" can still reach the login form. That includes a new
     * member waiting for email confirmation or approval, who has the guests'
     * permissions until then and can still resend the confirmation email.
     */
    protected const SIGN_IN_METHODS = [
        'getConfig', 'login', 'register', 'prefetchAccount', 'forgotPassword', 'getPasskeyChallenge',
        'completeBrowserLogin', 'resendEmailConfirmation',
    ];

    /**
     * Sign-out and device cleanup must work for every visitor.
     */
    protected const ALWAYS_OPEN_METHODS = ['logout', 'unregisterDevice'];

    /**
     * XenForo's account section: like its own account pages, they skip the
     * "View the board" and required two-step checks (a new member waiting
     * for email confirmation can still correct the address), but not bans,
     * closed board or security lock.
     */
    protected const ACCOUNT_METHODS = [
        'updateEmail', 'updatePassword', 'deleteAccount', 'updateProfile',
        'getUserSettings', 'updateUserSettings', 'getUserSettingsCategories',
    ];

    public function preDispatch(\XF\Mvc\RouteMatch $match)
    {
        // This is an API-only entry point - always return JSON
        try
        {
            // Handle GET request with challenge parameter for challenge-response verification (registration security)
            if ($_SERVER['REQUEST_METHOD'] === 'GET' && isset($_GET['challenge']))
            {
                return $this->handleChallengeResponse($_GET['challenge']);
            }

            // Handle GET request with verify parameter for API key verification
            if ($_SERVER['REQUEST_METHOD'] === 'GET' && isset($_GET['verify']))
            {
                return $this->verifyApiKey($_GET['verify']);
            }

            // Handle GET request to validate connection to ForumCopilot backend API
            if ($_SERVER['REQUEST_METHOD'] === 'GET' && isset($_GET['fc_validate_connection']))
            {
                return $this->handleValidateConnection();
            }

            // Handle simple GET request to root - return health check
            if ($_SERVER['REQUEST_METHOD'] === 'GET' && empty($_GET))
            {
                return $this->createJsonSuccess();
            }

            // An API request is a JSON POST. The media type must be exactly
            // application/json (parameters such as charset allowed): browsers
            // can send other types from another site without asking first,
            // and the app always sends this one.
            $contentType = $_SERVER['CONTENT_TYPE'] ?? $_SERVER['HTTP_CONTENT_TYPE'] ?? '';
            $mediaType = strtolower(trim(explode(';', $contentType)[0]));

            if ($mediaType === 'application/json' && $_SERVER['REQUEST_METHOD'] === 'POST')
            {
                // Parse JSON input
                $input = json_decode(file_get_contents('php://input'), true);
                if (json_last_error() !== JSON_ERROR_NONE) {
                    return $this->createJsonError('Invalid JSON request', 200, 'bad_request');
                }

                $method = $input['method'] ?? '';
                $params = $input['params'] ?? [];
                if (!is_array($params)) {
                    return $this->createJsonError('params must be an object', 200, 'bad_request');
                }

                if (empty($method)) {
                    return $this->createJsonError('Method parameter is required', 200, 'bad_request');
                }

                // Route to appropriate handler using full add-on loaded controller system
                return $this->routeApiMethod($method, $params);
            }
            else
            {
                // Not a valid API request - return JSON error
                return $this->createJsonError('This endpoint requires a JSON POST request with Content-Type: application/json', 400, 'bad_request');
            }
        }
        catch (\Throwable $e)
        {
            // Catch all exceptions and errors, always return JSON
            return $this->createExceptionError($e, 'preDispatch');
        }
    }

    /**
     * Route API method calls using the same controller factory as normal routing
     */
    protected function routeApiMethod($method, $params)
    {
        try
        {
            $map = [
            // Config
            'getConfig' => 'ConfigController@actionGetConfig',

            // Account
            'login' => 'AccountController@actionLogin',
            'logout' => 'AccountController@actionLogout',
            'register' => 'AccountController@actionRegister',
            'prefetchAccount' => 'AccountController@actionPrefetchAccount',
            'forgotPassword' => 'AccountController@actionForgotPassword',
            'updatePassword' => 'AccountController@actionUpdatePassword',
            'updateEmail' => 'AccountController@actionUpdateEmail',
            'deleteAccount' => 'AccountController@actionDeleteAccount',
            'completeBrowserLogin' => 'AccountController@actionCompleteBrowserLogin',
            'resendEmailConfirmation' => 'AccountController@actionResendEmailConfirmation',

            // Drafts (XenForo's own, shared with the web editor)
            'getDraft' => 'DraftController@actionGetDraft',
            'saveDraft' => 'DraftController@actionSaveDraft',
            'deleteDraft' => 'DraftController@actionDeleteDraft',
            'getDrafts' => 'DraftController@actionGetDrafts',
            'updateProfile' => 'AccountController@actionUpdateProfile',
            'getUserSettings' => 'AccountController@actionGetUserSettings',
            'updateUserSettings' => 'AccountController@actionUpdateUserSettings',
            'getUserSettingsCategories' => 'AccountController@actionGetUserSettingsCategories',
            'getPasskeyChallenge' => 'AccountController@actionGetPasskeyChallenge',

            // User
            'getUserInfo' => 'UserController@actionGetUserInfo',
            'searchUser' => 'UserController@actionSearchUser',
            'getInboxStat' => 'UserController@actionGetInboxStat',
            'getOnlineUsers' => 'UserController@actionGetOnlineUsers',
            'getUserReplyPost' => 'UserController@actionGetUserReplyPost',
            'reportUser' => 'UserController@actionReportUser',

            // Forum
            'getForum' => 'ForumController@actionGetForum',
            'markAllAsRead' => 'ForumController@actionMarkAllAsRead',
            'getForumStatus' => 'ForumController@actionGetForumStatus',
            'getBoardStat' => 'ForumController@actionGetBoardStat',
            'getParticipatedForum' => 'ForumController@actionGetParticipatedForum',
            'loginForum' => 'ForumController@actionLoginForum',

            // Topic
            'getTopic' => 'TopicController@actionGetTopic',
            'getTopTopic' => 'TopicController@actionGetTopTopic',
            'getAnnTopic' => 'TopicController@actionGetAnnTopic',
            'getLatestTopic' => 'TopicController@actionGetLatestTopic',
            'getUnreadTopic' => 'TopicController@actionGetUnreadTopic',
            'getParticipatedTopic' => 'TopicController@actionGetParticipatedTopic',
            'getTopicByIds' => 'TopicController@actionGetTopicByIds',
            'newTopic' => 'TopicController@actionNewTopic',
            'markTopicRead' => 'TopicController@actionMarkTopicRead',

            // Post
            'getThread' => 'PostController@actionGetThread',
            'getThreadByPost' => 'PostController@actionGetThreadByPost',
            'getThreadByUnread' => 'PostController@actionGetThreadByUnread',
            'votePoll' => 'PostController@actionVotePoll',
            'replyPost' => 'PostController@actionReplyPost',
            'getRawPost' => 'PostController@actionGetRawPost',
            'saveRawPost' => 'PostController@actionSaveRawPost',
            'getQuotePost' => 'PostController@actionGetQuotePost',
            'reportPost' => 'PostController@actionReportPost',

            // Search
            'searchTopic' => 'SearchController@actionSearchTopic',
            'searchPost' => 'SearchController@actionSearchPost',
            'advanceSearchTopic' => 'SearchController@actionAdvanceSearchTopic',
            'advanceSearchPost' => 'SearchController@actionAdvanceSearchPost',

            // Device tokens (push notifications)
            'registerDevice'    => 'DeviceController@actionRegisterDevice',
            'unregisterDevice'  => 'DeviceController@actionUnregisterDevice',
            'updateDeviceToken' => 'DeviceController@actionUpdateDeviceToken',

            // Attachment
            'uploadAttachment' => 'AttachmentController@actionUploadAttachment',
            'removeAttachment' => 'AttachmentController@actionRemoveAttachment',
            'uploadAvatar' => 'AttachmentController@actionUploadAvatar',

            // Social
            'likePost' => 'SocialController@actionLikePost',
            'unlikePost' => 'SocialController@actionUnlikePost',
            'follow' => 'SocialController@actionFollow',
            'unfollow' => 'SocialController@actionUnfollow',
            // 1.11.0: ignore a member (App Store guideline 1.2)
            'ignoreUser' => 'SocialController@actionIgnoreUser',
            'unignoreUser' => 'SocialController@actionUnignoreUser',
            'getIgnoredUsers' => 'SocialController@actionGetIgnoredUsers',
            'getAlert' => 'SocialController@actionGetAlert',

            // Subscription
            'getSubscribedForum' => 'SubscriptionController@actionGetSubscribedForum',
            'subscribeForum' => 'SubscriptionController@actionSubscribeForum',
            'unsubscribeForum' => 'SubscriptionController@actionUnsubscribeForum',
            'getSubscribedTopic' => 'SubscriptionController@actionGetSubscribedTopic',
            'subscribeTopic' => 'SubscriptionController@actionSubscribeTopic',
            'unsubscribeTopic' => 'SubscriptionController@actionUnsubscribeTopic',

            // Moderation
            'doLoginMod' => 'ModerationController@actionDoLoginMod',
            'stickTopic' => 'ModerationController@actionStickTopic',
            'unstickTopic' => 'ModerationController@actionUnstickTopic',
            'closeTopic' => 'ModerationController@actionCloseTopic',
            'uncloseTopic' => 'ModerationController@actionUncloseTopic',
            'deleteTopic' => 'ModerationController@actionDeleteTopic',
            'deletePost' => 'ModerationController@actionDeletePost',
            'undeleteTopic' => 'ModerationController@actionUndeleteTopic',
            'undeletePost' => 'ModerationController@actionUndeletePost',
            'moveTopic' => 'ModerationController@actionMoveTopic',
            'renameTopic' => 'ModerationController@actionRenameTopic',
            'approveTopic' => 'ModerationController@actionApproveTopic',
            'approvePost' => 'ModerationController@actionApprovePost',
            'banUser' => 'ModerationController@actionBanUser',
            'unbanUser' => 'ModerationController@actionUnbanUser',
            'spamCleanUser' => 'ModerationController@actionSpamCleanUser',

            // Private Conversation
            'newConversation' => 'PrivateConversationController@actionNewConversation',
            'replyConversation' => 'PrivateConversationController@actionReplyConversation',
            'getConversations' => 'PrivateConversationController@actionGetConversations',
            'getConversation' => 'PrivateConversationController@actionGetConversation',
            'getConversationByMessage' => 'PrivateConversationController@actionGetConversationByMessage',
            'getRawConversation' => 'PrivateConversationController@actionGetRawConversation',
            'saveRawConversation' => 'PrivateConversationController@actionSaveRawConversation',
            'getRawMessage' => 'PrivateConversationController@actionGetRawMessage',
            'saveRawMessage' => 'PrivateConversationController@actionSaveRawMessage',
            'closeConversation' => 'PrivateConversationController@actionCloseConversation',
            'uncloseConversation' => 'PrivateConversationController@actionUncloseConversation',
            'markConversationRead' => 'PrivateConversationController@actionMarkConversationRead',
            'markConversationUnread' => 'PrivateConversationController@actionMarkConversationUnread',
            'leaveConversation' => 'PrivateConversationController@actionLeaveConversation',
            'inviteParticipant' => 'PrivateConversationController@actionInviteParticipant',
            'getQuoteConversation' => 'PrivateConversationController@actionGetQuoteConversation',
            'likeConversationMessage' => 'PrivateConversationController@actionLikeConversationMessage',
            'unlikeConversationMessage' => 'PrivateConversationController@actionUnlikeConversationMessage',
            ];

            if (!isset($map[$method])) {
                return $this->createJsonError("Unknown method: $method", 200, 'bad_request');
            }

            // Extract controller and action
            [$controllerNames, $action] = explode('@', $map[$method]);

            // Use ForumCopilot namespace for API controllers - maps to 'ForumCopilot:Api:TopicController@actionGetLatestTopic'
            $fullControllerName = 'ForumCopilot:Api:' . $controllerNames;

            // Use XenForo's controller factory - this gets full add-on loading and initialization
            $controller = $this->controller($fullControllerName, $this->request());

            // Actions are called directly below, so XenForo's own pre-dispatch
            // checks (bans, "View the board", closed board...) never run.
            // Apply them here before anything else happens for this visitor.
            if (!in_array($method, self::ALWAYS_OPEN_METHODS, true)) {
                $denied = $controller->checkBoardAccess(
                    in_array($method, self::SIGN_IN_METHODS, true),
                    in_array($method, self::ACCOUNT_METHODS, true)
                );
                if ($denied) {
                    return $denied;
                }
            }

            // Mark this visitor's session as "Using mobile app" so they show
            // up in /online/ and per-thread "X members watching" lists the
            // same way web users do. Best-effort; never blocks the API call.
            $this->recordMobileSessionActivity();

            // Convert array params to ParameterBag for controller methods if needed
            if (is_array($params)) {
                $paramBag = new \XF\Mvc\ParameterBag($params);
            } else {
                $paramBag = $params; // Already a ParameterBag
            }

            // Call the action - now with full XenForo add-on context
            return $controller->{$action}($paramBag);
        }
        catch (\Throwable $e)
        {
            // Catch all exceptions from controller actions and return JSON error
            return $this->createExceptionError($e, $method);
        }
    }

    /**
     * Record an `xf_session_activity` row for the current visitor so mobile
     * users show up in the standard XF online/presence surfaces. Cheap to call
     * on every API request — the underlying writeSession upsert is keyed on
     * (user_id, ip).
     *
     * Skips:
     *   - guests (no user_id)
     *   - users with invisible mode enabled (respects their preference)
     *   - any exception (mobile API request must not break because activity
     *     tracking failed)
     *
     * Site owners can rebrand the displayed label and optionally make it
     * clickable via Admin CP → Options → ForumCopilot Options:
     *   - fc_mobile_activity_label (default "Using mobile app")
     *   - fc_mobile_activity_url   (optional click-through URL)
     */
    protected function recordMobileSessionActivity()
    {
        try
        {
            $visitor = \XF::visitor();
            if (!$visitor->user_id)
            {
                return;
            }
            if (isset($visitor->visible) && !$visitor->visible)
            {
                // Visitor opted into invisible mode — respect that everywhere.
                return;
            }

            // Short id: XF\Repository\SessionActivity on 2.2, aliased to
            // SessionActivityRepository on 2.3. The 2.3 class name threw on every
            // 2.2 request, so the mobile activity label never appeared there.
            $activityRepo = \XF::repository('XF:SessionActivity');
            $activityRepo->updateSessionActivity(
                (int) $visitor->user_id,
                $this->request()->getIp(),
                \ForumCopilot\Service\Activity\MobileSessionActivity::class,
                'index',
                [],
                'valid',
                null
            );
        }
        catch (\Throwable $e)
        {
            // Never let activity tracking break the API request.
            \XF::logError('FC mobile session activity error: ' . $e->getMessage());
        }
    }

    /**
     * Create JSON success response
     */
    protected function createJsonSuccess($data = null)
    {
        $response = [
            'result' => true,
        ];

        if ($data !== null) {
            $response = array_merge($response, $data);
            // Remove resultText if present (should only be for errors)
            if (isset($response['resultText'])) {
                unset($response['resultText']);
            }
        }

        return $this->createJsonResponse($response);
    }

    /**
     * Create JSON error response
     */
    protected function createJsonError($message, $code = 400, $errorCode = 'error', array $extra = [])
    {
        $response = [
            'result' => false,
            'resultText' => $message,
            'errorCode' => $errorCode,
        ] + $extra;
        return $this->createJsonResponse($response, $code);
    }

    /**
     * Error reply for an exception no controller handled. XenForo's own
     * refusals keep their message; anything else is logged in XenForo's server
     * error log under a short reference that the member sees instead of the
     * exception's text. HTTP 200, as controllers answer errors: the app reads
     * resultText only from 2xx replies.
     */
    protected function createExceptionError(\Throwable $e, $method)
    {
        $isGuest = !\XF::visitor()->user_id;
        $strip = function ($html) {
            return trim(html_entity_decode(strip_tags((string)$html), ENT_QUOTES | ENT_HTML5, 'UTF-8'));
        };

        if ($e instanceof \XF\Mvc\Reply\Exception) {
            $reply = $e->getReply();
            if ($reply instanceof \XF\Mvc\Reply\Error) {
                $errors = $reply->getErrors();
                $first = reset($errors);
                return $this->createJsonError(
                    $strip($first),
                    200,
                    \ForumCopilot\Api\ErrorCode::infer($first, $reply->getResponseCode(), $isGuest)
                );
            }
            return $this->createJsonError(
                $strip(\XF::phrase($isGuest ? 'login_required' : 'do_not_have_permission')),
                200,
                $isGuest ? 'guest_denied' : 'no_permission'
            );
        }

        if ($e instanceof \XF\PrintableException) {
            $messages = $e->getMessages();
            return $this->createJsonError($strip(reset($messages)), 200, 'validation');
        }

        $errorId = \ForumCopilot\Api\ErrorCode::logException($e, (string)$method);
        return $this->createJsonError(
            \ForumCopilot\Api\ErrorCode::unexpectedMessage($errorId),
            200,
            'server_error',
            ['errorId' => $errorId]
        );
    }

    /**
     * Handle challenge-response for registration security
     * 
     * @param string $challenge The challenge (nonce) received from backend
     * @return \XF\Mvc\Reply\AbstractReply JSON response with token
     */
    protected function handleChallengeResponse(string $challenge)
    {
        // Secret key for HMAC (can be public since plugin code is public)
        // Must match the secret key used by the ForumCopilot backend
        $secretKey = 'ForumCopilot_Secret_2024';
        
        // Validate challenge format (should be 64 character hex string)
        $challenge = trim($challenge);
        if (strlen($challenge) !== 64 || !ctype_xdigit($challenge)) {
            return $this->createJsonError('Invalid challenge format', 400);
        }
        
        // Generate token using HMAC
        $token = hash_hmac('sha256', $challenge, $secretKey);
        
        // Return result with token
        return $this->createJsonSuccess([
            'token' => $token
        ]);
    }

    /**
     * Verify API key using MD5 hash
     * 
     * @param string $md5Hash MD5 hash of the API key to verify
     * @return \XF\Mvc\Reply\AbstractReply JSON response
     */
    protected function verifyApiKey(string $md5Hash)
    {
        try
        {
            $options = \XF::options();
            $apikey = $options->fc_push_api_key ?? null;
            
            if (empty($apikey)) {
                return $this->createJsonError('API key not configured', 400);
            }
            
            // One check per address every few seconds, compared in constant time
            if (!$this->allowGuestHelperCall('fcVerifyKey', 5)) {
                return $this->createJsonError('Too many requests', 200, 'flood');
            }
            $expectedHash = md5($apikey);
            
            if (hash_equals($expectedHash, (string)$md5Hash)) {
                return $this->createJsonSuccess(['verified' => true]);
            } else {
                return $this->createJsonError('Invalid API key', 400);
            }
        }
        catch (\Throwable $e)
        {
            return $this->createExceptionError($e, 'verify');
        }
    }

    /**
     * Validate connection to ForumCopilot backend API.
     * Returns JSON with http_code, response_body, and optionally curl_error for debugging.
     */
    protected function handleValidateConnection()
    {
        // Each check makes an outbound request: at most one per address every 10 seconds
        if (!$this->allowGuestHelperCall('fcValidateConnection', 10)) {
            return $this->createJsonError('Too many requests', 200, 'flood');
        }

        $url = \ForumCopilot\BackendApi::apiUrl() . \ForumCopilot\BackendApi::VALIDATE_CONNECTION_PATH;

        $ch = curl_init($url);
        curl_setopt_array($ch, [
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_HTTPHEADER => [
                'User-Agent: ' . \ForumCopilot\BackendApi::USER_AGENT
            ],
            CURLOPT_TIMEOUT => 10,
            CURLOPT_SSL_VERIFYPEER => true,
            CURLOPT_SSL_VERIFYHOST => 2
        ]);

        $responseBody = curl_exec($ch);
        $httpCode = (int) curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $curlError = curl_error($ch);
        curl_close($ch);

        $ok = ($httpCode >= 200 && $httpCode < 300 && $curlError === '');
        $data = [
            'result' => $ok,
            'http_code' => $httpCode,
            'response_body' => $responseBody !== false ? $responseBody : ''
        ];
        if ($curlError !== '') {
            $data['curl_error'] = $curlError;
        }

        return $this->createJsonResponse($data, 200);
    }

    /**
     * A flood check for the GET helpers, keyed by the caller's IP address
     * since they work without signing in. XenForo's FloodCheck service skips
     * guests, so this writes its table (xf_flood_check, pruned by XenForo's
     * cron) under user id 0 itself.
     */
    protected function allowGuestHelperCall($action, $seconds)
    {
        try
        {
            $db = \XF::db();
            $key = substr($action, 0, 12) . substr(md5($this->request()->getIp()), 0, 13);
            $updated = $db->query(
                'UPDATE xf_flood_check SET flood_time = ? WHERE user_id = 0 AND flood_action = ? AND flood_time <= ?',
                [\XF::$time, $key, \XF::$time - $seconds]
            )->rowsAffected();
            if ($updated)
            {
                return true;
            }
            try
            {
                $db->insert('xf_flood_check', ['user_id' => 0, 'flood_action' => $key, 'flood_time' => \XF::$time]);
                return true;
            }
            catch (\XF\Db\DuplicateKeyException $e)
            {
                return false;
            }
        }
        catch (\Throwable $e)
        {
            return true;
        }
    }

    /**
     * Create JSON response
     */
    protected function createJsonResponse($data, $code = 200)
    {
        $response = $this->response();
        $response->contentType('application/json','UTF-8');
        
        // Add fc_is_login header to indicate if user is logged in
        $visitor = \XF::visitor();
        $isLoggedIn = ($visitor->user_id > 0) ? 'true' : 'false';
        $response->header('fc_is_login', $isLoggedIn);
        
        $response->body(json_encode($data));
        $response->httpCode($code);
        return $response;
    }
}

// Use our extended PubApp class that includes API interception WITH full add-on loading
try
{
    \XF::runApp(ForumCopilotPubApp::class);
}
catch (\Throwable $e)
{
    // Catch any unhandled exceptions and return JSON error; the reason goes to the log
    $errorId = bin2hex(random_bytes(4));
    try
    {
        \XF::logException($e, false, 'Forum Copilot API [' . $errorId . '] runApp: ');
    }
    catch (\Throwable $logError)
    {
        error_log('Forum Copilot API [' . $errorId . '] runApp: ' . $e->getMessage());
    }
    header('Content-Type: application/json; charset=UTF-8');
    http_response_code(500);
    echo json_encode([
        'result' => false,
        'resultText' => 'An unexpected error occurred. Please try again later. (' . $errorId . ')',
        'errorCode' => 'server_error',
        'errorId' => $errorId
    ]);
    exit;
}
