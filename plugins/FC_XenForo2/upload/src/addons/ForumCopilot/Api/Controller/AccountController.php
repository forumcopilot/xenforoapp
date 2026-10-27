<?php

namespace ForumCopilot\Api\Controller;

use ForumCopilot\Api\ErrorCode;
use XF\Mvc\ParameterBag;
use ForumCopilot\Result\FCLoginResult;
use ForumCopilot\Result\FCRegisterResult;
use ForumCopilot\Result\FCUpdatePasswordResult;
use ForumCopilot\Result\FCUpdateEmailResult;
use ForumCopilot\Result\FCUpdateProfileResult;
use ForumCopilot\Result\FCForgetPasswordResult;
use ForumCopilot\Adapter\XenForoParamAdapter;
use ForumCopilot\Entity\FCUser;
use XF\Validator\Email;

// Explicitly require FCAccountResult.php which contains multiple Result classes
// This ensures all classes in that file are loaded
require_once(__DIR__ . '/../../Result/FCAccountResult.php');

/**
 * Account Controller for ForumCopilot API
 * Handles user authentication and account management
 */
class AccountController extends AbstractController
{
    protected const NO_BOARD_ACCESS_MESSAGE = 'Your account does not currently have access to this forum';

    /**
     * Session key: when prefetchAccount opened the app's sign-up form, for
     * XenForo's registration timer.
     */
    protected const REGISTER_START_KEY = 'fcRegisterStart';

    public function actionLogin(ParameterBag $params)
    {
        // Check for passkey-only login (webauthn_payload present)
        $webauthnPayload = $params->get('webauthn_payload');
        if (!empty($webauthnPayload) && is_array($webauthnPayload)) {
            if (!$this->supportsPasskeys()) {
                return $this->apiError('Passkey login is not supported on this XenForo version', null, ErrorCode::NO_PERMISSION);
            }

            try {
                $webauthnChallenge = $params->get('webauthn_challenge', '');
                $challengeService = $this->app->service(\ForumCopilot\Service\PasskeyChallengeService::class);
                $error = null;
                $passkey = $challengeService->validateAssertion($this->session(), $webauthnChallenge, $webauthnPayload, $error);
                if ($passkey === null) {
                    $challengeService->clearStoredChallenge($this->session());
                    return $this->apiError($error ?: 'Passkey verification failed', null, ErrorCode::VALIDATION);
                }
                $user = $passkey->User;
                if (!$user) {
                    $challengeService->clearStoredChallenge($this->session());
                    return $this->apiError('Could not identify user from passkey', null, ErrorCode::VALIDATION);
                }
                if ($refusal = $this->signInRefusal($user)) {
                    $challengeService->clearStoredChallenge($this->session());
                    return $this->apiError($refusal);
                }
                $challengeService->clearStoredChallenge($this->session());
                $challengeService->updatePasskeyLastUse($passkey, $this->request->getIp());

                // Complete login using XenForo native flow (handles remember cookie and login IP log)
                $loginPlugin = $this->getLoginPlugin();
                $remember = (bool)$params->get('remember', true);
                $loginPlugin->completeLogin($user, $remember);

                // Mark user as having app installed
                $this->markUserHasApp($user->user_id);
                
                $result = $this->loginSuccessResult($user);
                
                return $this->apiSuccess($result);
                
            } catch (\Exception $e) {
                $logFile = \XF::getRootDirectory() . '/internal_data/forumcopilot_passkey.log';
                $logPrefix = '[' . date('c') . ']';
                $requestIp = $this->request->getIp();
                file_put_contents(
                    $logFile,
                    $logPrefix . ' passkey_only_login_exception ip=' . $requestIp . ' error=' . $e->getMessage() . PHP_EOL,
                    FILE_APPEND
                );
                return $this->apiException($e, 'Passkey login failed');
            }
        }
        
        // Standard password-based login flow
        // Convert XenForo ParameterBag to forum-agnostic parameter class
        $fcParams = XenForoParamAdapter::toLoginParams($params);
        
        // Validate parameters
        $errors = $fcParams->validate();
        if (!empty($errors)) {
            return $this->apiError('Invalid parameters: ' . implode(', ', $errors), null, ErrorCode::BAD_REQUEST);
        }

        try {
            // Use LoginService for proper authentication with rate limiting
            $ip = $this->request->getIp();
            $loginService = $this->getLoginService($fcParams->loginname, $ip);
            
            // Check for rate limiting (brute force protection)
            if ($loginService->isLoginLimited($limitType)) {
                return $this->apiError('Your account has temporarily been locked due to failed login attempts', null, ErrorCode::FLOOD);
            }

            // Validate password using LoginService (handles failed attempts, password upgrades, etc.)
            $user = $loginService->validate($fcParams->password, $error);
            if (!$user) {
                // LoginService already records failed attempts
                return $this->apiError($error ?: 'Invalid username or password', null, ErrorCode::VALIDATION);
            }

            if ($refusal = $this->signInRefusal($user)) {
                return $this->apiError($refusal);
            }

            // Check if user has two-factor authentication enabled
            $tfaRepo = $this->getTfaRepository();
            $tfaService = $this->getTfaService($user);
            
            if ($tfaRepo->userRequiresTfa($user)) {
                // TFA is required for this user
                $tfaCode = $params->get('tfaCode', '');
                
                if (empty($tfaCode)) {
                    // First request - trigger the selected/default provider so code-based
                    // providers like email actually generate and send their challenge.
                    $requestedProviderId = $params->get('tfaProvider', '');
                    if (!empty($requestedProviderId) && !$tfaService->isProviderValid($requestedProviderId)) {
                        return $this->apiError('Invalid TFA provider', null, ErrorCode::BAD_REQUEST);
                    }

                    $providers = $tfaService->getProviders();
                    $providerList = [];
                    $hasPasskey = false;
                    $hasCode = false;
                    
                    foreach ($providers as $providerId => $provider) {
                        // Determine provider type
                        $type = ($providerId === 'passkey') ? 'passkey' : 'code';
                        
                        $providerList[] = [
                            'id' => $providerId,
                            'title' => (string)$provider->title,
                            'description' => (string)$provider->description,
                            'type' => $type,
                        ];
                        
                        // Track available methods
                        if ($type === 'passkey') {
                            $hasPasskey = true;
                        } else {
                            $hasCode = true;
                        }
                    }

                    // Set TFA session state (similar to web implementation)
                    $loginPlugin = $this->getLoginPlugin();
                    $loginPlugin->setTfaSessionCheck($user);

                    $triggered = $tfaService->trigger(
                        $this->request,
                        !empty($requestedProviderId) ? $requestedProviderId : null
                    );
                    $triggeredProviderId = $triggered['provider']->provider_id;
                    
                    // Log IP for TFA attempt
                    $this->getIpRepository()->logIp(
                        $user->user_id,
                        $ip,
                        'user',
                        $user->user_id,
                        'login_tfa'
                    );
                    
                    // Prepare response
                    $response = [
                        'result' => false,
                        'resultText' => 'Two-factor authentication required',
                        'tfaRequired' => true,
                        'providers' => $providerList,
                        'providerId' => $triggeredProviderId,
                        'availableTfaMethods' => [
                            'passkey' => $hasPasskey,
                            'code' => $hasCode,
                        ],
                    ];
                    
                    // If passkey is available, generate our challenge (binary/base64url) for the app
                    if ($hasPasskey && $this->supportsPasskeys()) {
                        try {
                            $challengeService = $this->app->service(\ForumCopilot\Service\PasskeyChallengeService::class);
                            $challenge = $challengeService->generateAndStore($this->session());
                            $options = $this->app()->options();
                            $rpId = parse_url($options->boardUrl, PHP_URL_HOST);
                            $response['passkeyChallenge'] = $challenge;
                            $response['passkeyRpId'] = $rpId;
                            $response['passkeyTimeout'] = 60000;
                        } catch (\Exception $e) {
                            \XF::logError('Failed to generate passkey challenge for 2FA: ' . $e->getMessage());
                        }
                    }
                    
                    // Return TFA required response
                    return $this->apiSuccess($response);
                }
                
                // Second request - verify TFA code
                $providerId = $params->get('tfaProvider', '');
                if (empty($providerId)) {
                    // Use first available provider if not specified
                    $providers = $tfaService->getProviders();
                    $providerId = key($providers);
                }
                
                if (!$tfaService->isProviderValid($providerId)) {
                    return $this->apiError('Invalid TFA provider', null, ErrorCode::BAD_REQUEST);
                }
                
                // Check rate limiting for TFA attempts
                if ($tfaService->hasTooManyTfaAttempts()) {
                    return $this->apiError('Your account has temporarily been locked due to failed login attempts', null, ErrorCode::FLOOD);
                }
                
                // Handle passkey provider differently from code-based providers
                if ($providerId === 'passkey') {
                    if (!$this->supportsPasskeys()) {
                        return $this->apiError('Passkey verification is not supported on this XenForo version', null, ErrorCode::NO_PERMISSION);
                    }

                    $webauthnPayload = $params->get('webauthn_payload');
                    $webauthnChallenge = $params->get('webauthn_challenge', '');
                    if (empty($webauthnPayload) || !is_array($webauthnPayload)) {
                        return $this->apiError('webauthn_payload is required for passkey verification', null, ErrorCode::BAD_REQUEST);
                    }
                    if (empty($webauthnChallenge)) {
                        return $this->apiError('webauthn_challenge is required for passkey verification', null, ErrorCode::BAD_REQUEST);
                    }
                    $this->request->set('webauthn_challenge', $webauthnChallenge);
                    $this->request->set('webauthn_payload', $webauthnPayload);
                    $this->request->set('confirm', true);
                    $verified = $tfaService->verify($this->request, $providerId);
                    if (!$verified) {
                        return $this->apiError('Passkey verification failed', null, ErrorCode::VALIDATION);
                    }
                } else {
                    // Code-based TFA verification (totp, email, backup)
                    // Inject TFA code into request for verification (TfaService reads from request)
                    // Store original request values to restore later
                    $originalCode = $this->request->get('code', false);
                    
                    // Set the code and confirm flag for TFA verification
                    $this->request->set('code', $tfaCode);
                    $this->request->set('confirm', true);
                    
                    // Verify TFA code
                    $verified = $tfaService->verify($this->request, $providerId);
                    
                    // Restore original request value if it existed
                    if ($originalCode !== false) {
                        $this->request->set('code', $originalCode);
                    } else {
                        // Remove the code parameter if it wasn't there before
                        $input = $this->request->getInput();
                        if (isset($input['code'])) {
                            unset($input['code']);
                        }
                    }
                    
                    if (!$verified) {
                        return $this->apiError('Invalid two-factor authentication code', null, ErrorCode::VALIDATION);
                    }
                }
                
                // Clear TFA session check
                $loginPlugin = $this->getLoginPlugin();
                $loginPlugin->clearTfaSessionCheck();
                
                if ($fcParams->trustDevice) {
                    $this->trustThisDevice($user);
                }
            }

            // Complete login using XenForo native flow (handles remember cookie and login IP log)
            $loginPlugin = $this->getLoginPlugin();
            $loginPlugin->completeLogin($user, $fcParams->remember);
            
            // Mark user as having app installed (creates/updates entry in xf_fc_user)
            $this->markUserHasApp($user->user_id);
            
            // Note: Session cookies are automatically applied to response in App::complete()
            // No need to call applyToResponse() manually here

            $result = $this->loginSuccessResult($user);

            // Return the FCResult object directly - apiSuccess will handle it
            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiException($e, 'Login failed');
        }
    }

    /**
     * Get Passkey challenge for passkey-only login or passkey 2FA.
     * Uses our own binary challenge (base64url) so lbuchs WebAuthn validates correctly.
     */
    public function actionGetPasskeyChallenge(ParameterBag $params)
    {
        if (!$this->supportsPasskeys()) {
            return $this->apiError('Passkey login is not supported on this XenForo version', null, ErrorCode::NO_PERMISSION);
        }

        try {
            $challengeService = $this->app->service(\ForumCopilot\Service\PasskeyChallengeService::class);
            $challenge = $challengeService->generateAndStore($this->session());

            $options = $this->app()->options();
            $rpId = parse_url($options->boardUrl, PHP_URL_HOST);

            return $this->apiSuccess([
                'challenge' => $challenge,
                'rpId' => $rpId,
                'timeout' => 60000
            ]);
        } catch (\Exception $e) {
            $logFile = \XF::getRootDirectory() . '/internal_data/forumcopilot_passkey.log';
            $logPrefix = '[' . date('c') . ']';
            file_put_contents(
                $logFile,
                $logPrefix . ' get_passkey_challenge_fail ip=' . $this->request->getIp() . ' error=' . $e->getMessage() . PHP_EOL,
                FILE_APPEND
            );
            return $this->apiException($e, 'Failed to generate passkey challenge');
        }
    }

    protected function supportsPasskeys(): bool
    {
        return class_exists(\XF\Entity\Passkey::class);
    }

    /**
     * Why [$user] may not sign the app in, or null if they may; the same for
     * every way in (password, passkey, website).
     */
    protected function signInRefusal(\XF\Entity\User $user): ?string
    {
        if ($user->is_banned) {
            return 'Account is banned';
        }
        if ($user->user_state === 'disabled' || $user->user_state === 'rejected') {
            return 'Account is not available';
        }
        if ($user->security_lock) {
            return 'Your account is currently security locked';
        }

        // Every other API method refuses members without "View the board"
        // (see checkBoardAccess), so say so here instead of signing them in.
        // Except new members waiting for their email confirmation or for
        // approval: XenForo gives them the guest permissions, so on a forum
        // guests cannot view they lack it too. They sign in, and until their
        // account is ready the API answers them getConfig,
        // resendEmailConfirmation and logout, and tells them why otherwise.
        if (!$user->hasPermission('general', 'view') && !$this->isAwaitingMember($user)) {
            return self::NO_BOARD_ACCESS_MESSAGE;
        }

        return null;
    }

    /**
     * Gives this device a two-step trust cookie (tfa_trust), as "Trust this
     * device" does on the website (LoginPlugin::setDeviceTrusted): the app
     * holds no code to answer two-step with when XenForo next signs its
     * session in from the remember cookie (XF\Pub\App::loginFromRememberCookie).
     *
     * For fc_app_tfa_trust_days days (default 365, the remember cookie's
     * lifetime; XenForo's website uses 45). After that the app's member
     * passes two-step again when they next sign in. Signing out of the app
     * ends the trust (untrustThisDevice).
     */
    protected function trustThisDevice(\XF\Entity\User $user): void
    {
        $days = (int)(\XF::options()->fc_app_tfa_trust_days ?? 365);
        if ($days < 1 || $days > 3650) {
            $days = 365;
        }
        $lifetime = $days * 86400;

        // The entity directly rather than createTrustedKey($userId, $until),
        // whose second argument needs a 2.2 check.
        $trusted = $this->em()->create('XF:UserTfaTrusted');
        $trusted->user_id = $user->user_id;
        $trusted->trusted_until = \XF::$time + $lifetime;
        $trusted->save();

        $this->app->response()->setCookie('tfa_trust', $trusted->trusted_key, $lifetime, null, true);
    }

    /**
     * Ends this device's two-step trust (the one trustThisDevice gave the
     * app), when the member signs the app out or deletes their account.
     * The website keeps its trust on sign-out; the app's sign-out is meant
     * to leave nothing behind on the phone.
     */
    protected function untrustThisDevice(int $userId): void
    {
        $trustKey = $this->request->getCookie('tfa_trust');
        if ($userId && is_string($trustKey) && $trustKey !== '') {
            $this->app()->db()->delete(
                'xf_user_tfa_trusted',
                'user_id = ? AND trusted_key = ?',
                [$userId, $trustKey]
            );
        }
        if ($trustKey !== null && $trustKey !== false) {
            $this->app->response()->setCookie('tfa_trust', false);
        }
    }

    /**
     * The reply to a successful sign-in, whichever way it was made (password,
     * passkey, browser): the member and what they may do.
     */
    protected function loginSuccessResult(\XF\Entity\User $user): FCLoginResult
    {
        // Check if user can start conversations (send PMs)
        $canSendPM = $user->canStartConversation();

        // Create FC user entity
        $fcUser = new FCUser([
            'id' => (string)$user->user_id,
            'username' => $user->username,
            'email' => $user->email,
            'userType' => (string)$user->user_group_id,
            'iconUrl' => $this->getAbsoluteUrl($user->getAvatarUrl('m')),
            'postCount' => $user->message_count,
            'registrationTime' => $user->register_date * 1000, // Convert to milliseconds
            'lastActivityTime' => $user->last_activity * 1000,
            'isOnline' => true,
            'acceptsPM' => $user->canReceiveConversation(), // Check if user can receive conversations
            'canSendPM' => $canSendPM,
            'canModerate' => $user->is_moderator,
            'canSearch' => $user->canSearch(),
            'userState' => $user->user_state, // Include user state so app can show appropriate message
        ]);

        // Get user permissions from XenForo
        $canWhosonline = $user->canViewMemberList();
        $canProfile = $user->canViewFullProfile();
        $canUploadAvatar = $user->canUploadAvatar();

        // Get attachment permissions (user-specific)
        $canUploadAttachment = $user->canUploadAndManageAttachments('forum');
        $canUploadConversationAttachment = $user->canUploadAndManageAttachments('conversation');

        // Get attachment constraints from XenForo options (global settings)
        $options = $this->app()->options();
        $maxAttachment = (int)$options->attachmentMaxPerMessage;
        // XenForo uses a single max file size (in KB), convert to bytes
        // Use same value for both PNG and JPG since XenForo doesn't differentiate
        $maxFileSize = (int)$options->attachmentMaxFileSize * 1024; // Convert KB to bytes
        $maxPngSize = $maxFileSize;
        $maxJpgSize = $maxFileSize;
        $maxAttachmentSize = $maxFileSize;

        // Get allowed file extensions
        $attachmentExtensions = trim($options->attachmentExtensions);
        $allowedFileExtensions = !empty($attachmentExtensions) 
            ? preg_split('/\s+/', $attachmentExtensions, -1, PREG_SPLIT_NO_EMPTY)
            : [];

        // Get max image dimensions
        $maxImageWidth = !empty($options->attachmentMaxDimensions['width']) 
            ? (int)$options->attachmentMaxDimensions['width'] 
            : 0;
        $maxImageHeight = !empty($options->attachmentMaxDimensions['height']) 
            ? (int)$options->attachmentMaxDimensions['height'] 
            : 0;

        return new FCLoginResult(
            true,
            '', // resultText only for errors, empty for success
            $fcUser,
            $canWhosonline,
            $canProfile,
            $canUploadAvatar,
            $maxAttachment,
            $maxPngSize,
            $maxJpgSize,
            $canUploadAttachment,
            $canUploadConversationAttachment,
            $maxAttachmentSize,
            $allowedFileExtensions,
            $maxImageWidth,
            $maxImageHeight
        );
    }

    protected function getLoginService($login, string $ip)
    {
        $serviceId = class_exists(\XF\Service\User\LoginService::class)
            ? \XF\Service\User\LoginService::class
            : 'XF:User\Login';

        return $this->service($serviceId, $login, $ip);
    }

    protected function getTfaRepository()
    {
        $repoId = class_exists(\XF\Repository\TfaRepository::class)
            ? \XF\Repository\TfaRepository::class
            : 'XF:Tfa';

        return $this->repository($repoId);
    }

    protected function getTfaService(\XF\Entity\User $user)
    {
        $serviceId = class_exists(\XF\Service\User\TfaService::class)
            ? \XF\Service\User\TfaService::class
            : 'XF:User\Tfa';

        return $this->service($serviceId, $user);
    }

    protected function getIpRepository()
    {
        $repoId = class_exists(\XF\Repository\IpRepository::class)
            ? \XF\Repository\IpRepository::class
            : 'XF:Ip';

        return $this->repository($repoId);
    }

    protected function getUserTfaTrustedRepository()
    {
        $repoId = class_exists(\XF\Repository\UserTfaTrustedRepository::class)
            ? \XF\Repository\UserTfaTrustedRepository::class
            : 'XF:UserTfaTrusted';

        return $this->repository($repoId);
    }

    protected function getLoginPlugin()
    {
        $pluginId = class_exists(\XF\ControllerPlugin\LoginPlugin::class)
            ? \XF\ControllerPlugin\LoginPlugin::class
            : 'XF:Login';

        return $this->plugin($pluginId);
    }

    /**
     * Mark user as having app installed (creates/updates entry in xf_fc_user)
     */
    protected function markUserHasApp($userId)
    {
        $db = $this->app()->db();
        $db->insert('xf_fc_user', [
            'user_id' => $userId,
            'last_seen' => time()
        ], true); // true = replace on duplicate key (updates last_seen)
    }

    /**
     * Signs up a new member with the app's own form (older app builds and the
     * template app). Newer apps send members to the forum's register page
     * instead (XF\Pub\Controller\Register extension), which has everything
     * XenForo and the forum's add-ons put on the form.
     *
     * XenForo's RegistrationService does the work, with its spam checks
     * (StopForumSpam and the like, banned names and emails). Of what XenForo's
     * web form adds, this applies what an app can: discouraged IP addresses
     * are refused, as on the web; the registration timer runs from
     * prefetchAccount in this session; and a forum that shows guests a
     * captcha is refused, as the app cannot show one (canRegisterViaAPI).
     * The web form's hidden honeypot fields have no equivalent here.
     *
     * An error's resultText has every message; errors has those XenForo ties
     * to a field (username, email, password, dob, location, timezone,
     * custom_field_<id>), plus acceptTerms and acceptPrivacy.
     */
    public function actionRegister(ParameterBag $params)
    {
        try {
            $options = $this->app()->options();

            if ($refusal = $this->registrationRefusal()) {
                return $this->apiError($refusal);
            }
            if (!$this->canRegisterViaAPI()) {
                return $this->apiError($this->plainText(\XF::phrase('fc_register_on_website')), null, ErrorCode::NO_PERMISSION);
            }

            // XenForo's registration timer, from when prefetchAccount opened
            // the form in this session (as the web form's own start time).
            $startTime = (int)$this->session()->get(self::REGISTER_START_KEY);
            if (!$startTime) {
                return $this->apiError($this->plainText(\XF::phrase('something_went_wrong_please_try_again')));
            }
            if ($startTime + (int)$options->registrationTimer > \XF::$time) {
                return $this->apiError($this->plainText(\XF::phrase('sorry_you_must_wait_longer_to_create_account')), null, ErrorCode::FLOOD);
            }

            // Only the policies the forum has. XenForo's form has one box for
            // both; the app has one for each.
            $privacyUrl = $this->app->container('privacyPolicyUrl');
            $tosUrl = $this->app->container('tosUrl');
            $policyErrors = [];
            if ($tosUrl && !$params->get('acceptTerms')) {
                $policyErrors['acceptTerms'] = true;
            }
            if ($privacyUrl && !$params->get('acceptPrivacy')) {
                $policyErrors['acceptPrivacy'] = true;
            }
            if ($policyErrors) {
                if ($privacyUrl && $tosUrl) {
                    $message = \XF::phrase('please_read_and_accept_our_terms_and_privacy_policy_before_continuing');
                } else if ($tosUrl) {
                    $message = \XF::phrase('please_read_and_accept_our_terms_and_rules_before_continuing');
                } else {
                    $message = \XF::phrase('please_read_and_accept_our_privacy_policy_before_continuing');
                }
                return $this->registrationErrors(array_fill_keys(array_keys($policyErrors), $message));
            }

            // The form's fields as XenForo's own register form sends them
            // (Pub\Controller\Register::getRegistrationInput); XenForo checks
            // each one and says which is wrong.
            $password = (string)$params->get('password', '');
            $passwordConfirm = (string)$params->get('passwordConfirm', '');
            if ($passwordConfirm !== '' && $passwordConfirm !== $password) {
                return $this->registrationErrors(['password' => \XF::phrase('passwords_did_not_match')]);
            }

            $input = [
                'username' => (string)$params->get('username', ''),
                'email' => (string)$params->get('email', ''),
                'password' => $password,
            ];
            if ($timezone = (string)$params->get('timezone', '')) {
                $input['timezone'] = $timezone;
            }
            if ($location = (string)$params->get('location', '')) {
                $input['location'] = $location;
            }

            // dateOfBirth: YYYY-MM-DD
            $dateOfBirth = (string)$params->get('dateOfBirth', '');
            $dob = $dateOfBirth !== '' ? \DateTime::createFromFormat('Y-m-d', $dateOfBirth) : false;
            if ($dob && $dob->format('Y-m-d') === $dateOfBirth) {
                $input['dob_day'] = (int)$dob->format('d');
                $input['dob_month'] = (int)$dob->format('m');
                $input['dob_year'] = (int)$dob->format('Y');
            }

            $customFields = $params->get('customFields', []);
            if (is_array($customFields) && $customFields) {
                $input['custom_fields'] = $customFields;
            }

            // Also sets the activity summary email, as on the web.
            $emailChoice = $params->get('emailChoice', null);
            if ($options->registrationSetup['requireEmailChoice'] && $emailChoice !== null) {
                $input['email_choice'] = (bool)$emailChoice;
            }

            /** @var \XF\Service\User\Registration $registration */
            $registration = $this->service('XF:User\Registration');
            $registration->setFromInput($input);
            $registration->checkForSpam();

            if (!$registration->validate($errors)) {
                return $this->registrationErrors(is_array($errors) ? $errors : [$errors]);
            }

            $user = $registration->save();
            $setup = $options->registrationSetup;

            // One start for one account. Zeroed, not removed: XenForo does
            // not save a session left with no data, so the start would stay.
            $this->session()->set(self::REGISTER_START_KEY, 0);

            // What register/complete says on the website.
            if ($user->user_state === 'email_confirm') {
                $message = \XF::phrase('thanks_for_registering_to_complete_registration_follow_link');
            } else if ($user->user_state === 'moderated') {
                $message = \XF::phrase('thanks_for_registering_registration_must_be_approved');
            } else {
                $message = \XF::phrase('thanks_for_registering_complete');
            }

            $result = new FCRegisterResult(
                true,
                null,
                '', // previewTopicId
                (string)$user->user_id,
                $user->username,
                $user->user_state,
                ($setup['emailConfirmation'] && $user->user_state === 'email_confirm'),
                ($user->user_state === 'moderated'),
                $this->plainText($message)
            );

            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiException($e, 'Registration failed');
        }
    }

    /**
     * A failed registration: all of [$errors] in resultText, one per line,
     * and those keyed by a field name in errors.
     */
    protected function registrationErrors(array $errors)
    {
        $messages = [];
        $byField = [];
        foreach ($errors as $field => $error) {
            $text = $this->plainText($error);
            $messages[] = $text;
            if (is_string($field)) {
                $byField[$field] = $text;
            }
        }

        return $this->apiResponse(false, implode("\n", $messages), ['errorCode' => ErrorCode::VALIDATION] + ($byField ? ['errors' => $byField] : []));
    }

    /**
     * Why a visitor may not sign up now, as XenForo says it on the website,
     * or null: the board is closed, registration is off, or the visitor's IP
     * address is discouraged and the forum keeps those from registering
     * (Pub\Controller\Register::assertRegistrationActive).
     */
    protected function registrationRefusal(): ?string
    {
        $options = $this->app()->options();
        if (!$options->boardActive) {
            return $this->plainText($options->boardInactiveMessage);
        }
        if (empty($options->registrationSetup['enabled'])
            || ($options->preventDiscouragedRegistration && $this->isDiscouragedIp())
        ) {
            return $this->plainText(\XF::phrase('new_registrations_currently_not_being_accepted'));
        }

        return null;
    }

    /**
     * Whether the visitor's IP address is on the discouraged list
     * (Pub\Controller\AbstractController::isDiscouraged, which the API
     * controllers do not inherit).
     */
    protected function isDiscouragedIp(): bool
    {
        $visitor = \XF::visitor();
        if ($visitor->user_id && $visitor->Option && $visitor->Option->is_discouraged) {
            return true;
        }

        $discouragedIps = $this->app->container('discouragedIps');
        if (empty($discouragedIps['data'])) {
            return false;
        }
        return (bool)\XF\Util\Ip::checkIpsAgainstBinaryRangeList($this->request->getAllIps(), $discouragedIps['data']);
    }

    public function actionUpdatePassword(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $oldPassword = $params->get('oldPassword', '');
        $newPassword = $params->get('newPassword', '');

        if (empty($oldPassword) || empty($newPassword)) {
            return $this->apiError('Old password and new password are required', null, ErrorCode::VALIDATION);
        }

        try {
            $visitor = \XF::visitor();
            
            // Verify old password
            if (!$visitor->authenticate($oldPassword)) {
                return $this->apiError('Current password is incorrect', null, ErrorCode::VALIDATION);
            }

            // Use XenForo's Password Change service
            /** @var \XF\Service\User\PasswordChange $passwordChange */
            $passwordChange = $this->service('XF:User\PasswordChange', $visitor, $newPassword);
            $passwordChange->setLogIp(true);
            $passwordChange->setNotify(true);
            // Handled below, as XenForo's own password page does
            // (Pub\Controller\Account::actionSecuritySave).
            $passwordChange->setInvalidateRememberKeys(false);

            // Validate before saving
            if (!$passwordChange->isValid($error)) {
                return $this->apiError('Password change validation failed: ' . ($error ? $error : 'Unknown error'), null, ErrorCode::VALIDATION);
            }

            // Save password change
            $passwordChange->save();

            // Keep this session signed in: clears every remember key (other
            // devices sign in again), gives this one a new key if it had one,
            // and updates the session's password date. Without it the change
            // ended the app's own session, and the app had to sign in again
            // with the new password.
            $this->getLoginPlugin()->handleVisitorPasswordChange();

            $result = new FCUpdatePasswordResult(true, null);
            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiException($e, 'Password update failed');
        }
    }

    /**
     * Completes signing the app in through the forum's website: redeems the
     * one-time code the website handed to the app (Pub\Controller\AppLogin)
     * with the PKCE verifier, and signs this session in as that member,
     * remembered, as a password sign-in does.
     *
     * A member with two-step passed it on the website (or used a browser
     * the website trusts), so the app gets a trust cookie too, as when
     * signing in with the app's own form and "Trust this device". Without
     * it XenForo would ask for two-step again once the app's session lapses
     * and the remember cookie signs it back in, and the app has no way to
     * answer: the member was signed out.
     */
    public function actionCompleteBrowserLogin(ParameterBag $params)
    {
        $code = (string)$params->get('code', '');
        $verifier = (string)$params->get('verifier', '');
        if ($code === '' || $verifier === '') {
            return $this->apiError('The sign-in was not completed. Please try again.', null, ErrorCode::VALIDATION);
        }

        $userId = \ForumCopilot\Service\AppLoginCode::redeem($code, $verifier);
        /** @var \XF\Entity\User|null $user */
        $user = $userId ? $this->em()->find('XF:User', $userId) : null;
        if (!$user) {
            return $this->apiError('The sign-in has expired. Please try again.', null, ErrorCode::VALIDATION);
        }
        if ($refusal = $this->signInRefusal($user)) {
            return $this->apiError($refusal);
        }

        try {
            if ($this->getTfaRepository()->isUserTfaConfirmationRequired($user, $this->request->getCookie('tfa_trust'))) {
                $this->trustThisDevice($user);
            }
            $this->getLoginPlugin()->completeLogin($user, true);
            $this->markUserHasApp($user->user_id);
            return $this->apiSuccess($this->loginSuccessResult($user));
        } catch (\Exception $e) {
            return $this->apiException($e, 'Login failed');
        }
    }

    /**
     * Deletes the signed-in member's account. An app that lets people sign
     * up must let them delete the account in it too (App Store guideline
     * 5.1.1(v)); until now the app could only send them to the forum's staff.
     *
     * Confirmed with the member's password, or, for an account without one
     * (signed up with Google, Facebook, ...), with their user name typed in.
     * Staff accounts (administrators, moderators) are refused: those are
     * removed in the admin control panel. The forum can turn this off
     * (option fc_account_deletion; getConfig's accountDeletion says which).
     *
     * XenForo's own deletion, as when an administrator deletes a member: the
     * account, profile and settings go; posts stay, under the name, as a
     * guest's. This device's push registrations go with it.
     */
    public function actionDeleteAccount(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        if (!\XF::options()->fc_account_deletion) {
            return $this->apiError('This forum does not delete accounts from the app. Please contact the forum staff.', null, ErrorCode::NO_PERMISSION);
        }

        $visitor = \XF::visitor();
        if ($visitor->is_admin || $visitor->is_moderator || $visitor->is_super_admin) {
            return $this->apiError('Staff accounts cannot be deleted from the app. Please ask an administrator.', null, ErrorCode::NO_PERMISSION);
        }

        $password = (string)$params->get('password', '');
        $username = (string)$params->get('username', '');
        $handler = $visitor->Auth ? $visitor->Auth->getAuthenticationHandler() : null;
        if ($handler && $handler->hasPassword()) {
            if ($password === '' || !$visitor->authenticate($password)) {
                return $this->apiError('Your password is incorrect.', null, ErrorCode::VALIDATION);
            }
        } elseif (utf8_strtolower(trim($username)) !== utf8_strtolower($visitor->username)) {
            return $this->apiError('Type your user name to confirm.', null, ErrorCode::VALIDATION);
        }

        try {
            $userId = (int)$visitor->user_id;
            /** @var \XF\Entity\User $user */
            $user = $this->em()->find('XF:User', $userId);
            // XenForo refuses to delete the visitor's own account unless told to.
            $user->setOption('allow_self_delete', true);

            // This device's remember key, while the account still exists.
            $login = $this->getLoginPlugin();
            $login->deleteVisitorRememberRecord(false);

            $deleter = $this->service('XF:User\Delete', $user);
            if (!$deleter->delete($errors)) {
                $messages = array_map('strval', is_array($errors) ? $errors : [$errors]);
                return $this->apiError(implode(' ', $messages) ?: 'The account could not be deleted.', null, ErrorCode::VALIDATION);
            }

            // Its push registrations (best effort: the account is gone either
            // way), then this session.
            try {
                \XF::db()->delete('xf_fc_device_token', 'user_id = ?', $userId);
            } catch (\Exception $e) {
                \XF::logException($e, false, 'ForumCopilot: deleteAccount device tokens: ');
            }
            // Not logoutVisitor(): it saves the visitor's last activity, and
            // the visitor is the deleted account.
            \XF::session()->logoutUser();
            $login->clearCookies();
            $login->clearSiteData();

            return $this->apiSuccess(new \ForumCopilot\Result\FCResult(true, null));
        } catch (\Exception $e) {
            \XF::logException($e, false, 'ForumCopilot: deleteAccount: ');
            return $this->apiException($e, 'The account could not be deleted');
        }
    }

    public function actionUpdateEmail(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $password = $params->get('password', '');
        $newEmail = $params->get('newEmail', '');

        if (empty($password) || empty($newEmail)) {
            return $this->apiError('Password and new email are required', null, ErrorCode::VALIDATION);
        }

        try {
            $visitor = \XF::visitor();
            
            // Verify password
            if (!$visitor->authenticate($password)) {
                return $this->apiError('Password is incorrect', null, ErrorCode::VALIDATION);
            }

            // Validate email using XenForo's Email validator
            $bannedEmails = $this->app()->container('bannedEmails');
            $emailValidator = $this->app()->validator(\XF\Validator\Email::class);
            $emailValidator->setOption('banned', $bannedEmails);
            $emailValidator->setOption('check_typos', true);
            
            $newEmail = $emailValidator->coerceValue($newEmail);
            if (!$emailValidator->isValid($newEmail, $errorKey)) {
                $errorPhrase = $emailValidator->getPrintableErrorValue($errorKey);
                return $this->apiError($errorPhrase ?: 'Invalid email format', null, ErrorCode::VALIDATION);
            }

            // Use XenForo's Email Change service
            // Note: Email confirmation is automatically handled by the service
            // Admins/moderators/staff don't require email confirmation
            /** @var \XF\Service\User\EmailChange $emailChange */
            $emailChange = $this->service('XF:User\EmailChange', $visitor, $newEmail);

            // Check if user can change email (permission/rate limiting check)
            if (!$emailChange->canChangeEmail($error)) {
                if (!$error) {
                    $error = 'Your email may not be changed at this time';
                }
                return $this->apiError($error);
            }

            // Validate before saving
            if (!$emailChange->isValid($error)) {
                return $this->apiError('Email change validation failed: ' . ($error ? $error : 'Unknown error'), null, ErrorCode::VALIDATION);
            }

            // Save email change
            $emailChange->save();

            $confirmationRequired = $emailChange->getConfirmationRequired();
            $result = new FCUpdateEmailResult(true, null, $confirmationRequired);
            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiException($e, 'Email update failed');
        }
    }

    /**
     * Saves the signed-in member's own profile: what XenForo's account
     * details page saves (Pub\Controller\Account::accountDetailsSaveProcess),
     * plus the privacy (visible, activityVisible), preferences (timezone)
     * and signature fields of the pages next to it.
     *
     * Only the visitor's own profile: like XenForo's account pages, it never
     * edits another member. userId is optional; another member's id is
     * refused. (Staff edit members on the website, where User::canEdit()
     * applies.)
     */
    public function actionUpdateProfile(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $visitor = \XF::visitor();

        $userId = $params->get('userId', '');
        if (!is_scalar($userId) || ((string)$userId !== '' && (int)$userId !== (int)$visitor->user_id)) {
            return $this->apiError(\XF::phrase('do_not_have_permission'), null, ErrorCode::NO_PERMISSION);
        }
        if (!$visitor->canEditProfile()) {
            return $this->apiError(\XF::phrase('do_not_have_permission'), null, ErrorCode::NO_PERMISSION);
        }

        // Extract all profile fields from parameters
        $profileData = $this->arrayParam($params, 'profile');
        $userData = $this->arrayParam($params, 'user');
        $optionData = $this->arrayParam($params, 'option');
        $hasCustomFields = $params->offsetExists('customFields');
        $customFields = $this->arrayParam($params, 'customFields');
        $dobDay = $params->get('dobDay', null);
        $dobMonth = $params->get('dobMonth', null);
        $dobYear = $params->get('dobYear', null);
        $enableActivitySummaryEmail = $params->get('enableActivitySummaryEmail', null);

        try {
            $user = $visitor;
            $form = $this->formAction();

            // Which of XenForo's account pages the change belongs to, for
            // the IP log entry each of those pages writes.
            $changed = [];

            // Prepare user table input
            $userInput = [];
            if (isset($userData['customTitle']) && $visitor->hasPermission('general', 'editCustomTitle')) {
                $userInput['custom_title'] = (string)$userData['customTitle'];
                $changed['account_details_edit'] = true;
            }
            if (isset($userData['visible'])) {
                $userInput['visible'] = (bool)$userData['visible'];
                $changed['privacy_edit'] = true;
            }
            if (isset($userData['activityVisible'])) {
                $userInput['activity_visible'] = (bool)$userData['activityVisible'];
                $changed['privacy_edit'] = true;
            }
            if (isset($userData['timezone'])) {
                $userInput['timezone'] = (string)$userData['timezone'];
                $changed['preferences_edit'] = true;
            }

            // Save user fields
            if (!empty($userInput)) {
                $form->basicEntitySave($user, $userInput);
            }

            // Prepare user options input
            $optionInput = [];
            if (isset($optionData['receiveAdminEmail'])) {
                $optionInput['receive_admin_email'] = (bool)$optionData['receiveAdminEmail'];
            }
            if (isset($optionData['showDobYear'])) {
                $optionInput['show_dob_year'] = (bool)$optionData['showDobYear'];
            }
            if (isset($optionData['showDobDate'])) {
                $optionInput['show_dob_date'] = (bool)$optionData['showDobDate'];
            }

            // Save user options
            if (!empty($optionInput)) {
                $userOptions = $user->getRelationOrDefault('Option');
                $form->setupEntityInput($userOptions, $optionInput);
                $changed['account_details_edit'] = true;
            }

            // Handle activity summary email toggle (needs a 2.2 check:
            // guarded so a forum without it ignores the field)
            if ($enableActivitySummaryEmail !== null && method_exists($user, 'toggleActivitySummaryEmail')) {
                $form->setup(function () use ($user, $enableActivitySummaryEmail) {
                    $user->toggleActivitySummaryEmail((bool)$enableActivitySummaryEmail);
                });
                $changed['account_details_edit'] = true;
            }

            // Prepare profile input
            $profileInput = [];
            foreach (['location', 'website', 'about'] as $field) {
                if (isset($profileData[$field])) {
                    $profileInput[$field] = (string)$profileData[$field];
                    $changed['account_details_edit'] = true;
                }
            }

            // The signature, as XenForo's signature page checks and parses it
            // (Pub\Controller\Account::actionSignature).
            if (isset($profileData['signature'])) {
                if (!$visitor->canEditSignature()) {
                    return $this->apiError(\XF::phrase('do_not_have_permission'), null, ErrorCode::NO_PERMISSION);
                }
                /** @var \XF\Service\User\SignatureEdit $sigEditor */
                $sigEditor = $this->service('XF:User\SignatureEdit', $user);
                if (!$sigEditor->setSignature((string)$profileData['signature'], $errors)) {
                    return $this->apiFieldErrors(is_array($errors) ? $errors : [$errors]);
                }
                $profileInput['signature'] = $sigEditor->getNewSignature();
                $changed['signature_edit'] = true;
            }

            // Get profile entity
            /** @var \XF\Entity\UserProfile $userProfile */
            $userProfile = $user->getRelationOrDefault('Profile');

            // Date of birth: only filled in while it is incomplete, as on
            // XenForo's account details page, so a member cannot change
            // their age once it is set.
            if ($dobDay !== null || $dobMonth !== null || $dobYear !== null) {
                $form->setup(function () use ($userProfile, $dobDay, $dobMonth, $dobYear) {
                    if ($userProfile->dob_day && $userProfile->dob_month && $userProfile->dob_year) {
                        return;
                    }
                    if (!$dobDay || !$dobMonth) {
                        $userProfile->error(\XF::phrase('please_enter_valid_date_of_birth'), 'dob');
                    } else {
                        $userProfile->setDob((int)$dobDay, (int)$dobMonth, $dobYear ? (int)$dobYear : 0);
                    }
                });
                $changed['account_details_edit'] = true;
            }

            // Save profile fields
            if (!empty($profileInput)) {
                $form->setupEntityInput($userProfile, $profileInput);
            }

            // Personal and contact custom fields, as XenForo's account
            // details page sets them (customFieldsSaveProcess). When the app
            // sends customFields, even empty, the required ones are checked.
            if ($hasCustomFields) {
                $fieldSet = $userProfile->custom_fields;
                foreach (['personal', 'contact'] as $group) {
                    $fieldDefinition = $fieldSet->getDefinitionSet()
                        ->filterGroup($group)
                        ->filterEditable($fieldSet, 'user');
                    $customFieldsShown = array_keys($fieldDefinition->getFieldDefinitions());

                    if ($customFieldsShown) {
                        $form->setup(function () use ($fieldSet, $customFields, $customFieldsShown) {
                            $fieldSet->bulkSet($customFields, $customFieldsShown, 'user');
                        });
                    }
                }
                $changed['account_details_edit'] = true;
            }

            // Spam check for about field
            if (!empty($profileInput['about']) && $user->isSpamCheckRequired()) {
                $form->validate(function (\XF\Mvc\FormAction $form) use ($user, $profileInput) {
                    $checker = $this->app()->spam()->contentChecker();
                    $checker->check($user, $profileInput['about'], [
                        'content_type' => 'user',
                        'content_id' => $user->user_id,
                    ]);

                    $decision = $checker->getFinalDecision();
                    switch ($decision) {
                        case 'moderated':
                        case 'denied':
                            $checker->logSpamTrigger('user_about', $user->user_id);
                            $form->logError(\XF::phrase('your_content_cannot_be_submitted_try_later'));
                            break;
                    }
                });
            }

            // Validate and save
            $form->validateEntity($userProfile)->saveEntity($userProfile);

            // The IP log entries XenForo's own pages write for these changes
            $form->complete(function () use ($user, $changed) {
                $ipRepo = $this->getIpRepository();
                foreach (array_keys($changed) as $action) {
                    $ipRepo->logIp($user->user_id, $this->request->getIp(), 'user', $user->user_id, $action);
                }
            });

            // Run the form action
            $form->run();

            $result = new FCUpdateProfileResult(true, null);
            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiException($e, 'Profile update failed');
        }
    }

    /**
     * An object/array parameter, or [] when it is missing or not one.
     */
    protected function arrayParam(ParameterBag $params, string $key): array
    {
        $value = $params->get($key, []);
        return is_array($value) ? $value : [];
    }

    public function actionLogout(ParameterBag $params)
    {
        try {
            $visitor = \XF::visitor();
            
            if ($visitor->user_id) {
                // Use LoginPlugin for consistent logout behavior with web implementation
                // This handles: last activity update, remember record deletion, 
                // session logout, cookie clearing, and Clear-Site-Data header
                $loginPlugin = $this->getLoginPlugin();
                $loginPlugin->logoutVisitor();
            }

            // Logout doesn't have a specific result class, use base FCResult
            $result = new \ForumCopilot\Result\FCResult(true, null);
            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiException($e, 'Logout failed');
        }
    }

    public function actionForgotPassword(ParameterBag $params)
    {
        // Don't allow if already logged in
        $visitor = \XF::visitor();
        if ($visitor->user_id) {
            return $this->apiError('You are already logged in', null, ErrorCode::VALIDATION);
        }

        // Accept either email or username in a single parameter
        $usernameOrEmail = $params->get('usernameOrEmail', '');

        if (empty($usernameOrEmail)) {
            return $this->apiError('Username or email is required', null, ErrorCode::VALIDATION);
        }

        try {
            // Find user by email or username (similar to login logic)
            $user = null;
            
            // Check if it contains '@' to determine if it's an email
            if (strpos($usernameOrEmail, '@') !== false) {
                // It looks like an email, validate and search by email
                $emailValidator = $this->app->validator(Email::class);
                $emailValue = $emailValidator->coerceValue($usernameOrEmail);
                if ($emailValidator->isValid($emailValue)) {
                    $user = $this->em()->findOne('XF:User', ['email' => $emailValue]);
                }
            }
            
            // If not found (or not an email), try username
            if (!$user) {
                $user = $this->em()->findOne('XF:User', ['username' => $usernameOrEmail]);
            }

            // For security, don't reveal if user exists or not
            // Return success even if user not found
            if (!$user) {
                $result = new FCForgetPasswordResult(true, null, false);
                return $this->apiSuccess($result);
            }

            // Check if user has an email address (required for password reset)
            if (empty($user->email)) {
                // User exists but has no email - return success for security
                $result = new FCForgetPasswordResult(true, null, false);
                return $this->apiSuccess($result);
            }

            // Use XenForo's Password Reset service
            /** @var \XF\Service\User\PasswordReset $passwordReset */
            $passwordReset = $this->service('XF:User\PasswordReset', $user);
            
            // Check if password reset can be triggered
            if (!$passwordReset->canTriggerConfirmation($error)) {
                return $this->apiError($error ? $error : 'Password reset cannot be triggered at this time', null, ErrorCode::VALIDATION);
            }

            // Trigger the confirmation (sends email)
            $passwordReset->triggerConfirmation();

            // Return success (don't reveal if user exists for security)
            $result = new FCForgetPasswordResult(true, null, false);
            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiException($e, 'Password reset request failed');
        }
    }

    public function actionPrefetchAccount(ParameterBag $params)
    {
        $options = $this->app()->options();
        $setup = $options->registrationSetup;
        
        // Registration is open: the board is open, registration is on, and
        // XenForo would let this visitor sign up (discouraged IP addresses).
        $registrationOpen = $this->registrationRefusal() === null;
        
        // Check if API registration is possible (only if registration is open)
        $canRegister = $registrationOpen && $this->canRegisterViaAPI();
        
        // The register page, with or without friendly URLs.
        $registerViaWebUrl = $this->buildLink('canonical:register');
        
        // Get custom fields for registration
        $customFields = $this->getRegistrationCustomFields();
        
        // Build registration requirements if registration is possible
        $requirements = null;
        if ($canRegister) {
            // The app's form opens now: XenForo's registration timer starts.
            $this->session()->set(self::REGISTER_START_KEY, \XF::$time);

            $requirements = [
                'username' => [
                    'required' => true,
                    'minLength' => $options->usernameLength['min'] ?? 3,
                    'maxLength' => $options->usernameLength['max'] ?? 50
                ],
                'email' => ['required' => true],
                'password' => [
                    'required' => true,
                    'checkStrength' => true
                ],
                'dateOfBirth' => [
                    'required' => (bool)$setup['requireDob'],
                    // 0: no minimum
                    'minimumAge' => (int)($setup['minimumAge'] ?? 0),
                    'requireDob' => (bool)$setup['requireDob']
                ],
                'location' => [
                    'required' => (bool)($setup['requireLocation'] ?? false),
                    'requireLocation' => (bool)($setup['requireLocation'] ?? false)
                ],
                'emailChoice' => [
                    'required' => (bool)($setup['requireEmailChoice'] ?? false),
                    'requireEmailChoice' => (bool)($setup['requireEmailChoice'] ?? false)
                ],
                'customFields' => $customFields,
                'privacyPolicy' => $this->getPrivacyPolicyConfig(),
                'termsOfService' => $this->getTermsOfServiceConfig()
            ];
        }
        
        $result = new \ForumCopilot\Result\FCPrefetchAccountResult(
            true,
            'success',
            false,
            null,
            null,
            $customFields,
            $canRegister,
            $requirements,
            $registerViaWebUrl,
            $registrationOpen
        );
        
        return $this->apiSuccess($result);
    }

    /**
     * The custom fields XenForo's own register form shows: those set to show
     * during registration that a new member may fill in (a field that is
     * never editable by the member is left out, as XenForo would drop its
     * value).
     * 
     * @return array Array of custom field definitions
     */
    protected function getRegistrationCustomFields()
    {
        $customFields = [];
        
        try {
            // The same selection as RegistrationService::setCustomFields.
            /** @var \XF\CustomField\Set $fieldSet */
            $fieldSet = $this->em()->create('XF:UserProfile')->custom_fields;
            $shown = $fieldSet->getDefinitionSet()
                ->filterEditable($fieldSet, 'user')
                ->filter('registration')
                ->getFieldDefinitions();

            /** @var \XF\Repository\UserFieldRepository $userFieldRepo */
            $userFieldRepo = $this->repository('XF:UserField');
            $userFields = $userFieldRepo->findFieldsForList()->fetch();
            
            foreach ($userFields as $field) {
                if (isset($shown[$field->field_id])) {
                    // Skip color fields - not supported in API
                    if ($field->field_type === 'color' || $field->match_type === 'color') {
                        continue;
                    }
                    
                    // Get title and description - these are Phrase objects
                    $titleText = (string)$field->title;
                    $descText = (string)$field->description;
                    
                    $fieldData = [
                        'fieldId' => $field->field_id,
                        'title' => $titleText,
                        'description' => $descText,
                        'fieldType' => $field->field_type,
                        'required' => (bool)$field->required,
                        'displayOrder' => (int)$field->display_order,
                        'matchType' => $field->match_type,
                        'maxLength' => (int)$field->max_length
                    ];
                    
                    // Add choices if applicable
                    if (in_array($field->field_type, ['select', 'radio', 'checkbox', 'multiselect'])) {
                        $fieldData['choices'] = $field->field_choices ?: [];
                    }
                    
                    // Add match params if applicable
                    if ($field->match_params) {
                        $fieldData['matchParams'] = $field->match_params;
                    }
                    
                    $customFields[] = $fieldData;
                }
            }
        } catch (\Exception $e) {
            // If field fetching fails, return empty array
            \XF::logError('ForumCopilot: Error fetching registration custom fields: ' . $e->getMessage());
        }
        
        return $customFields;
    }


    /**
     * The privacy policy, if the forum has one: required means it exists
     * and must be accepted (acceptPrivacy).
     * 
     * @return array Privacy policy configuration
     */
    protected function getPrivacyPolicyConfig()
    {
        $privacyPolicyUrl = $this->policyUrl('privacyPolicyUrl', 'help/privacy-policy/');
        
        return [
            'required' => $privacyPolicyUrl !== '',
            'url' => $privacyPolicyUrl
        ];
    }

    /**
     * The terms and rules, if the forum has them: required means they exist
     * and must be accepted (acceptTerms).
     * 
     * @return array Terms of service configuration
     */
    protected function getTermsOfServiceConfig()
    {
        $tosUrl = $this->policyUrl('tosUrl', 'help/terms/');
        
        return [
            'required' => $tosUrl !== '',
            'url' => $tosUrl
        ];
    }

    /**
     * A policy's full address: XenForo's own help page as a canonical link
     * (its container gives a relative one, which the app cannot place on a
     * forum in a folder), or the forum's custom address. Empty when the
     * forum has none.
     */
    protected function policyUrl(string $option, string $helpRoute): string
    {
        $url = (string)$this->app->container($option);
        if ($url === '') {
            return '';
        }
        if (($this->app()->options()->{$option}['type'] ?? '') === 'default') {
            return $this->buildLink('canonical:' . $helpRoute);
        }
        return $this->getAbsoluteUrl($url);
    }

    /**
     * Sends the confirmation email again, for a member waiting to confirm
     * their email address (the app's "Resend" on its banner and waiting
     * screen). XenForo's own resend page asks for a captcha when the last
     * email went out within the hour; the app cannot show one, so it may
     * resend once every ten minutes instead.
     */
    public function actionResendEmailConfirmation(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        try {
            $visitor = \XF::visitor();

            /** @var \XF\Service\User\EmailConfirmation $emailConfirmation */
            $emailConfirmation = $this->service('XF:User\EmailConfirmation', $visitor);
            if (!$emailConfirmation->canTriggerConfirmation($error)) {
                return $this->apiError($this->plainText($error));
            }

            if ($floodError = $this->checkFlooding('fcResendConfirmation', 600)) {
                return $floodError;
            }

            $emailConfirmation->triggerConfirmation();

            return $this->apiSuccess([
                'message' => $this->plainText(\XF::phrase('confirmation_email_has_been_resent')),
            ]);
        } catch (\Exception $e) {
            return $this->apiException($e, 'Could not resend the email');
        }
    }

    /**
     * Get user settings for a specific category
     * 
     * @param ParameterBag $params - Should contain 'category' parameter
     *   Categories: 'push_notifications', 'alert_notifications', 'privacy', 'preferences', etc.
     */
    public function actionGetUserSettings(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { 
            return $error; 
        }

        try {
            $visitor = \XF::visitor();
            $category = $params->get('category', '');
            
            if (empty($category)) {
                return $this->apiError('Category parameter is required', null, ErrorCode::BAD_REQUEST);
            }

            // Get settings provider based on category
            $provider = $this->getSettingsProvider($category);
            if (!$provider) {
                return $this->apiError('Unknown settings category: ' . $category, null, ErrorCode::BAD_REQUEST);
            }

            // Get settings definition and current values
            $settingsDefinition = $provider->getSettingsDefinition($visitor);
            $currentValues = $provider->getCurrentValues($visitor);

            // Build response with metadata and values (aligned with prefetchAccount structure)
            $settings = [];
            foreach ($settingsDefinition as $key => $definition) {
                $setting = [
                    // Core identification (matches prefetchAccount)
                    'fieldId' => $key,
                    'title' => $definition['title'] ?? $key,
                    'description' => $definition['description'] ?? null,
                    
                    // Field type (matches prefetchAccount)
                    'fieldType' => $definition['fieldType'] ?? 'checkbox',
                    'dataType' => $definition['dataType'] ?? 'boolean',
                    
                    // Current value (not in prefetchAccount, but needed for settings)
                    'value' => $currentValues[$key] ?? $definition['default'] ?? null,
                    'default' => $definition['default'] ?? null,
                    
                    // Choices format - support prefetchAccount format (object: value => label)
                    'choices' => $this->formatChoices($definition['choices'] ?? null),
                    
                    // Validation (matches prefetchAccount structure)
                    'required' => $definition['required'] ?? false,
                    'readOnly' => $definition['readOnly'] ?? false,
                    'maxLength' => $definition['maxLength'] ?? null,
                    'matchType' => $definition['matchType'] ?? null,
                    'matchParams' => $definition['matchParams'] ?? null,
                    
                    // Additional constraints
                    'min' => $definition['min'] ?? null,
                    'max' => $definition['max'] ?? null,
                    'pattern' => $definition['pattern'] ?? null,
                    'placeholder' => $definition['placeholder'] ?? null,
                    
                    // Display/grouping
                    'displayOrder' => $definition['displayOrder'] ?? 0,
                    'group' => $definition['group'] ?? null,
                    
                    // Dependencies
                    'dependsOn' => $definition['dependsOn'] ?? null,
                ];
                
                $settings[] = $setting;
            }

            // Sort by displayOrder
            usort($settings, function($a, $b) {
                return ($a['displayOrder'] ?? 0) - ($b['displayOrder'] ?? 0);
            });

            return $this->apiSuccess([
                'category' => $category,
                'enabled' => $provider->isCategoryEnabled($visitor),
                'settings' => $settings
            ]);

        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to get user settings');
        }
    }

    /**
     * Update user settings for a specific category
     * 
     * @param ParameterBag $params - Should contain:
     *   - 'category': The settings category
     *   - 'settings': Object/map of key-value pairs to update
     */
    public function actionUpdateUserSettings(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { 
            return $error; 
        }

        try {
            $visitor = \XF::visitor();
            $category = $params->get('category', '');
            $settingsToUpdate = $params->get('settings', []);
            
            if (empty($category)) {
                return $this->apiError('Category parameter is required', null, ErrorCode::BAD_REQUEST);
            }

            if (!is_array($settingsToUpdate)) {
                return $this->apiError('Settings must be an object/array', null, ErrorCode::BAD_REQUEST);
            }

            // Get settings provider based on category
            $provider = $this->getSettingsProvider($category);
            if (!$provider) {
                return $this->apiError('Unknown settings category: ' . $category, null, ErrorCode::BAD_REQUEST);
            }

            // Validate and update settings
            $validationErrors = $provider->validateSettings($visitor, $settingsToUpdate);
            if (!empty($validationErrors)) {
                return $this->apiError('Validation failed: ' . implode(', ', $validationErrors), null, ErrorCode::VALIDATION);
            }

            // Apply updates
            $provider->updateSettings($visitor, $settingsToUpdate);

            // Return updated settings
            return $this->actionGetUserSettings(new ParameterBag(['category' => $category]));

        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to update user settings');
        }
    }

    /**
     * Get available settings categories
     */
    public function actionGetUserSettingsCategories(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { 
            return $error; 
        }

        try {
            $visitor = \XF::visitor();
            $categories = [];

            // List all available categories
            $availableCategories = [
                'push_notifications',
                'email_privacy',
                // Future categories can be added here:
                // 'alert_notifications',
                // 'privacy',
                // 'preferences',
            ];

            foreach ($availableCategories as $category) {
                $provider = $this->getSettingsProvider($category);
                if ($provider) {
                    $categories[] = [
                        'key' => $category,
                        'displayName' => $provider->getCategoryDisplayName(),
                        'description' => $provider->getCategoryDescription(),
                        'enabled' => $provider->isCategoryEnabled($visitor)
                    ];
                }
            }

            return $this->apiSuccess([
                'categories' => $categories
            ]);

        } catch (\Exception $e) {
            return $this->apiException($e, 'Failed to get settings categories');
        }
    }

    /**
     * Get settings provider for a category
     * 
     * @param string $category
     * @return SettingsProviderInterface|null
     */
    protected function getSettingsProvider($category)
    {
        $providers = [
            'push_notifications' => \ForumCopilot\Api\SettingsProvider\PushNotificationsProvider::class,
            'email_privacy' => \ForumCopilot\Api\SettingsProvider\EmailPrivacyProvider::class,
            // Future providers can be added here:
            // 'alert_notifications' => \ForumCopilot\Api\SettingsProvider\AlertNotificationsProvider::class,
            // 'privacy' => \ForumCopilot\Api\SettingsProvider\PrivacyProvider::class,
            // 'preferences' => \ForumCopilot\Api\SettingsProvider\PreferencesProvider::class,
        ];

        if (!isset($providers[$category])) {
            return null;
        }

        $providerClass = $providers[$category];
        if (!class_exists($providerClass)) {
            return null;
        }

        return new $providerClass($this->app());
    }

    /**
     * Format choices to match prefetchAccount format (key-value object)
     * Also supports array of {value, label} objects for flexibility
     * 
     * @param mixed $choices
     * @return array|null
     */
    protected function formatChoices($choices)
    {
        if ($choices === null) {
            return null;
        }
        
        // If already in prefetchAccount format (object: value => label)
        if (is_array($choices) && !empty($choices) && !isset($choices[0])) {
            return $choices;
        }
        
        // If array of {value, label} objects, convert to key-value object
        if (is_array($choices) && isset($choices[0]) && is_array($choices[0])) {
            $formatted = [];
            foreach ($choices as $choice) {
                if (isset($choice['value']) && isset($choice['label'])) {
                    $formatted[$choice['value']] = $choice['label'];
                }
            }
            return $formatted;
        }
        
        return $choices;
    }

}
