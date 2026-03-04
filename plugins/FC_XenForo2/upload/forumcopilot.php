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
    echo json_encode([
        'result' => false,
        'resultText' => 'Failed to initialize XenForo: ' . $e->getMessage()
    ]);
    exit;
}

// Override PubApp to add API interception with full add-on loading
class ForumCopilotPubApp extends PubApp
{
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

            // Check if this is an API request by looking for JSON POST data
            $contentType = $_SERVER['CONTENT_TYPE'] ?? $_SERVER['HTTP_CONTENT_TYPE'] ?? '';

            if (strpos($contentType, 'application/json') !== false && $_SERVER['REQUEST_METHOD'] === 'POST')
            {
                // Parse JSON input
                $input = json_decode(file_get_contents('php://input'), true);
                if (json_last_error() !== JSON_ERROR_NONE) {
                    return $this->createJsonError('Invalid JSON request', 400);
                }

                $method = $input['method'] ?? '';
                $params = $input['params'] ?? [];

                if (empty($method)) {
                    return $this->createJsonError('Method parameter is required', 400);
                }

                // Route to appropriate handler using full add-on loaded controller system
                return $this->routeApiMethod($method, $params);
            }
            else
            {
                // Not a valid API request - return JSON error
                return $this->createJsonError('This endpoint requires a JSON POST request with Content-Type: application/json', 400);
            }
        }
        catch (\Throwable $e)
        {
            // Catch all exceptions and errors, always return JSON
            return $this->createJsonError('Internal server error: ' . $e->getMessage(), 500);
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

            // Attachment
            'uploadAttachment' => 'AttachmentController@actionUploadAttachment',
            'removeAttachment' => 'AttachmentController@actionRemoveAttachment',
            'uploadAvatar' => 'AttachmentController@actionUploadAvatar',

            // Social
            'likePost' => 'SocialController@actionLikePost',
            'unlikePost' => 'SocialController@actionUnlikePost',
            'follow' => 'SocialController@actionFollow',
            'unfollow' => 'SocialController@actionUnfollow',
            'getAlert' => 'SocialController@actionGetAlert',
            'thankPost' => 'SocialController@actionThankPost',

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
                return $this->createJsonError("Unknown method: $method", 400);
            }

            // Extract controller and action
            [$controllerNames, $action] = explode('@', $map[$method]);

            // Use ForumCopilot namespace for API controllers - maps to 'ForumCopilot:Api:TopicController@actionGetLatestTopic'
            $fullControllerName = 'ForumCopilot:Api:' . $controllerNames;

            // Use XenForo's controller factory - this gets full add-on loading and initialization
            $controller = $this->controller($fullControllerName, $this->request());

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
            return $this->createJsonError('API error: ' . $e->getMessage(), 500);
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
    protected function createJsonError($message, $code = 400)
    {
        $response = [
            'result' => false,
            'resultText' => $message
        ];
        return $this->createJsonResponse($response, $code);
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
            
            // Calculate MD5 hash of stored API key
            $expectedHash = md5($apikey);
            
            // Compare hashes
            if ($expectedHash === $md5Hash) {
                return $this->createJsonSuccess(['verified' => true]);
            } else {
                return $this->createJsonError('Invalid API key', 400);
            }
        }
        catch (\Throwable $e)
        {
            return $this->createJsonError('Verification error: ' . $e->getMessage(), 500);
        }
    }

    /**
     * Validate connection to ForumCopilot backend API.
     * Returns JSON with http_code, response_body, and optionally curl_error for debugging.
     */
    protected function handleValidateConnection()
    {
        $url = \ForumCopilot\BackendApi::API_URL . \ForumCopilot\BackendApi::VALIDATE_CONNECTION_PATH;

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
    // Catch any unhandled exceptions and return JSON error
    header('Content-Type: application/json; charset=UTF-8');
    http_response_code(500);
    echo json_encode([
        'result' => false,
        'resultText' => 'Unhandled error: ' . $e->getMessage()
    ]);
    exit;
}
