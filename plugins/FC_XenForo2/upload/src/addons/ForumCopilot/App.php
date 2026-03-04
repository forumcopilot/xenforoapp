<?php

namespace ForumCopilot;

use XF\Container;
use XF\Entity\UserRemember;
use XF\Http\Response;
use XF\Mvc\Reply\Error;
use XF\Repository\IpRepository;
use XF\Repository\TfaRepository;
use XF\Repository\UserRememberRepository;
use XF\Repository\UserRepository;
use XF\Session\Session;
use function intval;

class App extends \XF\App
{
	protected $isServedFromCache = false;

	protected $preLoadLocal = [
		'bannedIps',
		'bbCodeCustom',
		'discouragedIps',
		'forumTypes',
		'notices',
		'noticesLastReset',
		'routeFilters',
		'routesPublic',
		'styles',
		'userFieldsInfo',
		'threadFieldsInfo',
		'threadPrefixes',
		'threadTypes',
	];

	public function initializeExtra()
	{
		$container = $this->container;

		$container['app.classType'] = 'Pub';
		$container['app.defaultType'] = 'public';

		$container['router'] = function (Container $c)
		{
			return $c['router.public'];
		};
		$container['session'] = function (Container $c)
		{
			return $c['session.public'];
		};
	}

	public function setup(array $options = [])
	{
		parent::setup($options);
		$this->assertConfigExists();

		$this->fire('app_pub_setup', [$this]);
	}

	/**
	 * @return list<string>
	 */
	protected function getPreloadExtraKeys(): array
	{
		$keys = parent::getPreloadExtraKeys();

		$this->fire('app_pub_registry_preload', [$this, &$keys]);

		return $keys;
	}

	public function start($allowShortCircuit = false)
	{
		parent::start($allowShortCircuit);
		
		$request = $this->request();

		$session = $this->session();
		if (!$session->exists())
		{
			$this->onSessionCreation($session);
		}

		$user = $this->getVisitorFromSession($session);
		\XF::setVisitor($user);

		$visitor = \XF::visitor();
		if ($visitor->user_id)
		{
			$languageId = $visitor->language_id;
		}
		else
		{
			$username = $request->filter('_xfUsername', 'str', '');
			if ($username && !preg_match('/./su', $username))
			{
				$username = '';
			}

			$styleId = intval($request->getCookie('style_id', 0));
			$styleVariation = $request->getCookie('style_variation', '');
			if ($styleVariation && !preg_match('/./su', $styleVariation))
			{
				$styleVariation = '';
			}

			$languageId = intval($request->getCookie('language_id', 0));

			$visitor->setReadOnly(false);
			$visitor->setAsSaved('username', $username);
			$visitor->setAsSaved('style_id', $styleId);
			$visitor->setAsSaved('style_variation', $styleVariation);
			$visitor->setAsSaved('language_id', $languageId);
			$visitor->setReadOnly(true);
		}

		$language = $this->language($languageId);
		if (!$language->isUsable($visitor))
		{
			$language = $this->language(0);
		}

		$language->setTimeZone($visitor->timezone);
		\XF::setLanguage($language);
		return $this->handleApiRequest();
	}
    
    /**
     * Handle API requests
     */
    protected function handleApiRequest()
    {
        try
        {
            $request = $this->request();
            $method = '';
            $params = new \XF\Mvc\ParameterBag();

            // Handle GET requests
            if ($request->getRequestMethod() === 'get') {
                $method = $request->filter('method', 'str', '');
                
                // Get all input parameters except 'method'
                $allInput = $request->getInput();
                foreach ($allInput as $key => $value) {
                    if ($key !== 'method') {
                        $params[$key] = $value;
                    }
                }
            }
            // Handle POST requests with JSON
            else if ($request->getRequestMethod() === 'post') {
                $input = json_decode($request->getInputRaw(), true);
                if (json_last_error() !== JSON_ERROR_NONE) {
                    return $this->createJsonError('Invalid JSON request', 400);
                }

                $method = $input['method'] ?? '';
                $params = $input['params'] ?? new \XF\Mvc\ParameterBag();
            }

            if (empty($method)) {
                return $this->createJsonError('Method parameter is required', 400);
            }

            // Route to appropriate handler
            return $this->routeApiMethod($method, $params);

        }
        catch (\Exception $e)
        {
            return $this->createJsonError('Internal server error: ' . $e->getMessage(), 500);
        }
    }

    /**
     * Route API method calls
     */
    protected function routeApiMethod($method, $params)
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
            'getPasskeyChallenge' => 'AccountController@actionGetPasskeyChallenge',
            
            // User
            'getUserInfo' => 'UserController@actionGetUserInfo',
            'searchUser' => 'UserController@actionSearchUser',
            'getInboxStat' => 'UserController@actionGetInboxStat',
            'getOnlineUsers' => 'UserController@actionGetOnlineUsers',
            'getUserReplyPost' => 'UserController@actionGetUserReplyPost',
            
            // Forum
            'getForum' => 'ForumController@actionGetForum',
            'markAllAsRead' => 'ForumController@actionMarkAllAsRead',
            'getForumStatus' => 'ForumController@actionGetForumStatus',
            'getBoardStat' => 'ForumController@actionGetBoardStat',
            'getParticipatedForum' => 'ForumController@actionGetParticipatedForum',
            
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
            
            // Private Conversation
            'newConversation' => 'PrivateConversationController@actionNewConversation',
            'replyConversation' => 'PrivateConversationController@actionReplyConversation',
            'getConversations' => 'PrivateConversationController@actionGetConversations',
            'getConversation' => 'PrivateConversationController@actionGetConversation',
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
        ];
        if(!isset($map[$method])) {
            return $this->createJsonError("Unknown method: $method", 400);
        }
        $controllerClass = explode('@', $map[$method])[0];
        $action = explode('@', $map[$method])[1];
        // Use XenForo's controller factory to properly instantiate the controller
        $controller = $this->controller('\\ForumCopilot\\Api\\Controller\\' . $controllerClass, $this->request());
        
        // Convert array params to ParameterBag for controller methods if needed
        if (is_array($params)) {
            $paramBag = new \XF\Mvc\ParameterBag($params);
        } else {
            $paramBag = $params; // Already a ParameterBag
        }
        return $controller->{$action}($paramBag);
    }

    /**
     * Create JSON success response
     */
    protected function createJsonSuccess($data = null)
    {
        $response = [
            'result' => true,
            'resultText' => 'success'
        ];

        if ($data !== null) {
            $response = array_merge($response, $data);
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
     * Create JSON response
     */
    protected function createJsonResponse($data, $code = 200)
    {
        $response = $this->response();
        $response->header('Content-Type', 'application/json; charset=UTF-8');
        
        // Add fc_is_login header to indicate if user is logged in
        $visitor = \XF::visitor();
        $isLoggedIn = ($visitor->user_id > 0) ? 'true' : 'false';
        $response->header('fc_is_login', $isLoggedIn);
        
        $response->body(json_encode($data));
        $response->httpCode($code);
        return $response;
    }

	protected function getApiErrorResponse($error, $code = 400)
	{
		$renderer = $this->renderer('api');
		$reply = new Error($error, $code);

		$renderer->setReply($reply);
		$renderer->setResponseCode($code);
		$content = $renderer->renderErrors($reply->getErrors());
		$content = $renderer->postFilter($content, $reply);

		$response = $renderer->getResponse();
		$response->body($content);

		return $response;
	}

    /**
     * Handle getConfig method using the existing ConfigController
     */
    protected function handleGetConfig($params)
    {
        // Use XenForo's controller factory to properly instantiate the controller
        $configController = $this->controller('ForumCopilot\Api\Controller\ConfigController', $this->request());
        
        // Create ParameterBag from the params array
        $parameterBag = new \XF\Mvc\ParameterBag($params);
        
        // Call the actionGetConfig method
        $response = $configController->actionGetConfig($parameterBag);
        
        // Convert the reply to a response
        return $response;
    }


	protected function onSessionCreation(Session $session)
	{
		$loginUserId = $this->loginFromRememberCookie($session);

		if (!$loginUserId)
		{
			$this->request()->populateFromSearch($this->response());
		}
	}

	protected function loginFromRememberCookie(Session $session)
	{
		$rememberCookie = $this->request()->getCookie('user');
		if (!$rememberCookie)
		{
			return null;
		}

		$rememberRepo = $this->repository(UserRememberRepository::class);
		if (!$rememberRepo->validateByCookieValue($rememberCookie, $remember))
		{
			$this->response()->setCookie('user', false);
			return null;
		}

		$userRepo = $this->repository(UserRepository::class);
		$user = $userRepo->getVisitor($remember->user_id);
		if (!$user)
		{
			return null;
		}

		$trustKey = $this->request()->getCookie('tfa_trust');

		$tfaRepo = $this->repository(TfaRepository::class);
		if ($tfaRepo->isUserTfaConfirmationRequired($user, $trustKey))
		{
			$session->tfaLoginUserId = $user->user_id;
			$session->tfaLoginDate = time();
			$session->tfaLoginRedirect = true;

			return null;
		}

		$session->changeUser($user);

		$ipRepo = $this->repository(IpRepository::class);
		$ipRepo->logCookieLoginIfNeeded($user->user_id, $this->request()->getIp());

		/** @var UserRemember $remember */
		$remember->extendExpiryDate();
		$remember->save();

		return $remember->user_id;
	}

	public function complete(Response $response)
	{
		parent::complete($response);

		if ($this->container->isCached('session'))
		{
			$session = $this->session();
			if ($session->isStarted() && $session->hasData())
			{
				$session->save();
				$session->applyToResponse($response);
			}
			// don't save empty sessions as it would generally be pointless
		}

		// Add fc_is_login header to indicate if user is logged in
		$visitor = \XF::visitor();
		$isLoggedIn = ($visitor->user_id > 0) ? 'true' : 'false';
		$response->header('fc_is_login', $isLoggedIn);

		$this->fire('app_pub_complete', [$this, &$response]);
	}
}
