<?php

namespace ForumCopilot\Api\Controller;

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
    public function actionLogin(ParameterBag $params)
    {
        // Check for passkey-only login (webauthn_payload present)
        $webauthnPayload = $params->get('webauthn_payload');
        if (!empty($webauthnPayload) && is_array($webauthnPayload)) {
            if (!$this->supportsPasskeys()) {
                return $this->apiError('Passkey login is not supported on this XenForo version');
            }

            try {
                $webauthnChallenge = $params->get('webauthn_challenge', '');
                $challengeService = $this->app->service(\ForumCopilot\Service\PasskeyChallengeService::class);
                $error = null;
                $passkey = $challengeService->validateAssertion($this->session(), $webauthnChallenge, $webauthnPayload, $error);
                if ($passkey === null) {
                    $challengeService->clearStoredChallenge($this->session());
                    return $this->apiError($error ?: 'Passkey verification failed');
                }
                $user = $passkey->User;
                if (!$user) {
                    $challengeService->clearStoredChallenge($this->session());
                    return $this->apiError('Could not identify user from passkey');
                }
                if ($user->is_banned) {
                    $challengeService->clearStoredChallenge($this->session());
                    return $this->apiError('Account is banned');
                }
                if ($user->user_state === 'disabled' || $user->user_state === 'rejected') {
                    $challengeService->clearStoredChallenge($this->session());
                    return $this->apiError('Account is not available');
                }
                if ($user->security_lock) {
                    $challengeService->clearStoredChallenge($this->session());
                    return $this->apiError('Your account is currently security locked');
                }
                $challengeService->clearStoredChallenge($this->session());
                $challengeService->updatePasskeyLastUse($passkey, $this->request->getIp());

                // Complete login using XenForo native flow (handles remember cookie and login IP log)
                $loginPlugin = $this->getLoginPlugin();
                $remember = (bool)$params->get('remember', true);
                $loginPlugin->completeLogin($user, $remember);

                // Mark user as having app installed
                $this->markUserHasApp($user->user_id);
                
                // Build and return success response (same as password login)
                $canSendPM = $user->canStartConversation();
                
                $fcUser = new FCUser([
                    'id' => (string)$user->user_id,
                    'username' => $user->username,
                    'email' => $user->email,
                    'userType' => (string)$user->user_group_id,
                    'iconUrl' => $this->getAbsoluteUrl($user->getAvatarUrl('m')),
                    'postCount' => $user->message_count,
                    'registrationTime' => $user->register_date * 1000,
                    'lastActivityTime' => $user->last_activity * 1000,
                    'isOnline' => true,
                    'acceptsPM' => $user->canReceiveConversation(),
                    'canSendPM' => $canSendPM,
                    'canModerate' => $user->is_moderator,
                    'canSearch' => $user->canSearch(),
                    'userState' => $user->user_state,
                ]);
                
                $canWhosonline = $user->canViewMemberList();
                $canProfile = $user->canViewFullProfile();
                $canUploadAvatar = $user->canUploadAvatar();
                $canUploadAttachment = $user->canUploadAndManageAttachments('forum');
                $canUploadConversationAttachment = $user->canUploadAndManageAttachments('conversation');
                
                $options = $this->app()->options();
                $maxAttachment = (int)$options->attachmentMaxPerMessage;
                $maxFileSize = (int)$options->attachmentMaxFileSize * 1024;
                $maxPngSize = $maxFileSize;
                $maxJpgSize = $maxFileSize;
                $maxAttachmentSize = $maxFileSize;
                
                $attachmentExtensions = trim($options->attachmentExtensions);
                $allowedFileExtensions = !empty($attachmentExtensions) 
                    ? preg_split('/\s+/', $attachmentExtensions, -1, PREG_SPLIT_NO_EMPTY)
                    : [];
                
                $maxImageWidth = !empty($options->attachmentMaxDimensions['width']) 
                    ? (int)$options->attachmentMaxDimensions['width'] 
                    : 0;
                $maxImageHeight = !empty($options->attachmentMaxDimensions['height']) 
                    ? (int)$options->attachmentMaxDimensions['height'] 
                    : 0;
                
                $result = new FCLoginResult(
                    true,
                    '',
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
                return $this->apiError('Passkey login failed: ' . $e->getMessage());
            }
        }
        
        // Standard password-based login flow
        // Convert XenForo ParameterBag to forum-agnostic parameter class
        $fcParams = XenForoParamAdapter::toLoginParams($params);
        
        // Validate parameters
        $errors = $fcParams->validate();
        if (!empty($errors)) {
            return $this->apiError('Invalid parameters: ' . implode(', ', $errors));
        }

        try {
            // Use LoginService for proper authentication with rate limiting
            $ip = $this->request->getIp();
            $loginService = $this->getLoginService($fcParams->loginname, $ip);
            
            // Check for rate limiting (brute force protection)
            if ($loginService->isLoginLimited($limitType)) {
                return $this->apiError('Your account has temporarily been locked due to failed login attempts');
            }

            // Validate password using LoginService (handles failed attempts, password upgrades, etc.)
            $user = $loginService->validate($fcParams->password, $error);
            if (!$user) {
                // LoginService already records failed attempts
                return $this->apiError($error ?: 'Invalid username or password');
            }

            // Check if user is banned
            if ($user->is_banned) {
                return $this->apiError('Account is banned');
            }

            // Check if user is disabled or rejected (these states should block login)
            if ($user->user_state === 'disabled' || $user->user_state === 'rejected') {
                return $this->apiError('Account is not available');
            }

            // Check for security lock
            if ($user->security_lock) {
                return $this->apiError('Your account is currently security locked');
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
                        return $this->apiError('Invalid TFA provider');
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
                    return $this->apiError('Invalid TFA provider');
                }
                
                // Check rate limiting for TFA attempts
                if ($tfaService->hasTooManyTfaAttempts()) {
                    return $this->apiError('Your account has temporarily been locked due to failed login attempts');
                }
                
                // Handle passkey provider differently from code-based providers
                if ($providerId === 'passkey') {
                    if (!$this->supportsPasskeys()) {
                        return $this->apiError('Passkey verification is not supported on this XenForo version');
                    }

                    $webauthnPayload = $params->get('webauthn_payload');
                    $webauthnChallenge = $params->get('webauthn_challenge', '');
                    if (empty($webauthnPayload) || !is_array($webauthnPayload)) {
                        return $this->apiError('webauthn_payload is required for passkey verification');
                    }
                    if (empty($webauthnChallenge)) {
                        return $this->apiError('webauthn_challenge is required for passkey verification');
                    }
                    $this->request->set('webauthn_challenge', $webauthnChallenge);
                    $this->request->set('webauthn_payload', $webauthnPayload);
                    $this->request->set('confirm', true);
                    $verified = $tfaService->verify($this->request, $providerId);
                    if (!$verified) {
                        return $this->apiError('Passkey verification failed');
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
                        return $this->apiError('Invalid two-factor authentication code');
                    }
                }
                
                // Clear TFA session check
                $loginPlugin = $this->getLoginPlugin();
                $loginPlugin->clearTfaSessionCheck();
                
                // Optionally handle trusted device - hard coded to trust forever
                $trustDevice = $fcParams->trustDevice;
                if ($trustDevice) {
                    // Create trusted key with "forever" expiration (year 2100 timestamp)
                    // This is effectively permanent for practical purposes
                    $tfaTrustRepo = $this->getUserTfaTrustedRepository();
                    $trustedUntil = 4102444800; // January 1, 2100 00:00:00 UTC - effectively "forever"
                    $key = $tfaTrustRepo->createTrustedKey($user->user_id, $trustedUntil);
                    
                    // Set cookie with very long expiration (also year 2100)
                    $this->app->response()->setCookie('tfa_trust', $key, $trustedUntil - \XF::$time, null, true);
                }
            }

            // Complete login using XenForo native flow (handles remember cookie and login IP log)
            $loginPlugin = $this->getLoginPlugin();
            $loginPlugin->completeLogin($user, $fcParams->remember);
            
            // Mark user as having app installed (creates/updates entry in xf_fc_user)
            $this->markUserHasApp($user->user_id);
            
            // Note: Session cookies are automatically applied to response in App::complete()
            // No need to call applyToResponse() manually here

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

            $result = new FCLoginResult(
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

            // Return the FCResult object directly - apiSuccess will handle it
            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiError('Login failed: ' . $e->getMessage());
        }
    }

    /**
     * Get Passkey challenge for passkey-only login or passkey 2FA.
     * Uses our own binary challenge (base64url) so lbuchs WebAuthn validates correctly.
     */
    public function actionGetPasskeyChallenge(ParameterBag $params)
    {
        if (!$this->supportsPasskeys()) {
            return $this->apiError('Passkey login is not supported on this XenForo version');
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
            return $this->apiError('Failed to generate passkey challenge: ' . $e->getMessage());
        }
    }

    protected function supportsPasskeys(): bool
    {
        return class_exists(\XF\Entity\Passkey::class);
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

    public function actionRegister(ParameterBag $params)
    {
        // Existing required parameters (backward compatible)
        $username = $params->get('username', '');
        $password = $params->get('password', '');
        $email = $params->get('email', '');
        
        // New optional parameters
        $passwordConfirm = $params->get('passwordConfirm', '');
        $timezone = $params->get('timezone', '');
        $location = $params->get('location', '');
        
        // Extract and parse dateOfBirth parameter (format: YYYY-MM-DD)
        $dateOfBirth = $params->get('dateOfBirth', '');
        $dobDay = 0;
        $dobMonth = 0;
        $dobYear = 0;
        
        if (!empty($dateOfBirth)) {
            $dateTime = \DateTime::createFromFormat('Y-m-d', $dateOfBirth);
            if ($dateTime && $dateTime->format('Y-m-d') === $dateOfBirth) {
                // Valid date, extract components
                $dobYear = (int)$dateTime->format('Y');
                $dobMonth = (int)$dateTime->format('m');
                $dobDay = (int)$dateTime->format('d');
            }
        }
        $emailChoice = $params->get('emailChoice', null);
        $customFields = $params->get('customFields', []);
        $captchaToken = $params->get('captchaToken', '');
        $acceptTerms = $params->get('acceptTerms', false);
        $acceptPrivacy = $params->get('acceptPrivacy', false);

        // Validate required fields
        if (empty($username) || empty($password) || empty($email)) {
            return $this->apiError('Username, password, and email are required');
        }

        try {
            $options = $this->app()->options();
            
            // Check registration enabled
            if (!$options->registrationSetup['enabled']) {
                return $this->apiError('Registration is disabled');
            }
            
            // Validate email format
            if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
                return $this->apiError('Invalid email format');
            }
            
            // CAPTCHA validation is bypassed for API registration since webview-based CAPTCHAs
            // (reCAPTCHA, hCaptcha, Turnstile, KeyCaptcha) require webview rendering which is
            // too complex for mobile apps. Other spam protection mechanisms (DNSBL, Project 
            // Honey Pot, registration timer) in RegistrationService still apply.
            // Note: Web registration still requires CAPTCHA validation.
            
            // Validate TOS/Privacy acceptance
            $privacyUrl = $this->app->container('privacyPolicyUrl');
            $tosUrl = $this->app->container('tosUrl');
            if (($privacyUrl || $tosUrl) && (!($acceptTerms && $acceptPrivacy))) {
                if ($privacyUrl && $tosUrl) {
                    return $this->apiError('You must accept the terms and privacy policy');
                } else if ($tosUrl) {
                    return $this->apiError('You must accept the terms and rules');
                } else {
                    return $this->apiError('You must accept the privacy policy');
                }
            }

            // Use XenForo's Registration service
            /** @var \XF\Service\User\RegistrationService $registration */
            $registration = $this->service('XF:User\Registration');
            
            // Set basic fields
            $mappedFields = [
                'username' => $username,
                'email' => $email,
            ];
            if ($timezone) {
                $mappedFields['timezone'] = $timezone;
            }
            if ($location) {
                $mappedFields['location'] = $location;
            }
            $registration->setMapped($mappedFields);
            
            // Set password (with confirmation if provided)
            $registration->setPassword(
                $password, 
                $passwordConfirm ?: $password, 
                !empty($passwordConfirm)
            );
            
            // Set date of birth if provided
            if ($dobDay && $dobMonth && $dobYear) {
                $registration->setDob($dobDay, $dobMonth, $dobYear);
            }
            
            // Set custom fields if provided
            if (!empty($customFields) && is_array($customFields)) {
                $registration->setCustomFields($customFields);
            }
            
            // Set email choice if required
            if ($options->registrationSetup['requireEmailChoice'] && $emailChoice !== null) {
                $registration->setReceiveAdminEmail($emailChoice);
            }
            
            // Check for spam (automatic)
            $registration->checkForSpam();
            
            // Validate before saving
            if (!$registration->validate($errors)) {
                // Format errors as readable message
                if (is_array($errors)) {
                    $errorMessages = [];
                    foreach ($errors as $key => $error) {
                        $errorMsg = is_string($error) ? $error : (string)$error;
                        $errorMessages[] = $errorMsg;
                    }
                    $errorMessage = 'Validation failed: ' . implode(', ', $errorMessages);
                } else {
                    $errorMessage = is_string($errors) ? $errors : 'Validation failed';
                }
                return $this->apiError($errorMessage);
            }
            
            // Save user
            $user = $registration->save();
            $setup = $options->registrationSetup;
            
            // Generate user-friendly message based on user state (matches web registration)
            // These messages match what users see on the web registration complete page
            $message = null;
            if ($user->user_state === 'email_confirm') {
                // Message for email confirmation required (matches register_complete template)
                $message = 'Thanks for registering. In order to complete your registration, you must follow the link in the email that has been sent to you.';
            } else if ($user->user_state === 'moderated') {
                // Message for manual approval required (matches register_complete template)
                $message = 'Thanks for registering. Your registration must now be approved by an administrator. You will receive an email once a decision has been made.';
            } else {
                // Message for successful registration (user state is 'valid')
                // This matches the template message for completed registration
                $message = 'Thanks for registering. Your registration is now complete.';
            }
            
            // Build enhanced response
            $result = new FCRegisterResult(
                true,
                null,
                '', // previewTopicId
                (string)$user->user_id,
                $user->username,
                $user->user_state,
                ($setup['emailConfirmation'] && $user->user_state === 'email_confirm'),
                ($user->user_state === 'moderated'),
                $message
            );

            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiError('Registration failed: ' . $e->getMessage());
        }
    }

    public function actionUpdatePassword(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $oldPassword = $params->get('oldPassword', '');
        $newPassword = $params->get('newPassword', '');

        if (empty($oldPassword) || empty($newPassword)) {
            return $this->apiError('Old password and new password are required');
        }

        try {
            $visitor = \XF::visitor();
            
            // Verify old password
            if (!$visitor->authenticate($oldPassword)) {
                return $this->apiError('Current password is incorrect');
            }

            // Use XenForo's Password Change service
            /** @var \XF\Service\User\PasswordChange $passwordChange */
            $passwordChange = $this->service('XF:User\PasswordChange', $visitor, $newPassword);
            $passwordChange->setLogIp(true);
            $passwordChange->setNotify(true);
            $passwordChange->setInvalidateRememberKeys(true);

            // Validate before saving
            if (!$passwordChange->isValid($error)) {
                return $this->apiError('Password change validation failed: ' . ($error ? $error : 'Unknown error'));
            }

            // Save password change
            $passwordChange->save();

            $result = new FCUpdatePasswordResult(true, null);
            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiError('Password update failed: ' . $e->getMessage());
        }
    }

    public function actionUpdateEmail(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $password = $params->get('password', '');
        $newEmail = $params->get('newEmail', '');

        if (empty($password) || empty($newEmail)) {
            return $this->apiError('Password and new email are required');
        }

        try {
            $visitor = \XF::visitor();
            
            // Verify password
            if (!$visitor->authenticate($password)) {
                return $this->apiError('Password is incorrect');
            }

            // Validate email using XenForo's Email validator
            $bannedEmails = $this->app()->container('bannedEmails');
            $emailValidator = $this->app()->validator(\XF\Validator\Email::class);
            $emailValidator->setOption('banned', $bannedEmails);
            $emailValidator->setOption('check_typos', true);
            
            $newEmail = $emailValidator->coerceValue($newEmail);
            if (!$emailValidator->isValid($newEmail, $errorKey)) {
                $errorPhrase = $emailValidator->getPrintableErrorValue($errorKey);
                return $this->apiError($errorPhrase ?: 'Invalid email format');
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
                return $this->apiError('Email change validation failed: ' . ($error ? $error : 'Unknown error'));
            }

            // Save email change
            $emailChange->save();

            $confirmationRequired = $emailChange->getConfirmationRequired();
            $result = new FCUpdateEmailResult(true, null, $confirmationRequired);
            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiError('Email update failed: ' . $e->getMessage());
        }
    }

    public function actionUpdateProfile(ParameterBag $params)
    {
        if ($error = $this->assertRegisteredUser()) { return $error; }

        $userId = $params->get('userId', '');
        
        // Extract all profile fields from parameters
        $profileData = $params->get('profile', []);
        $userData = $params->get('user', []);
        $optionData = $params->get('option', []);
        $customFields = $params->get('customFields', []);
        $dobDay = $params->get('dobDay', null);
        $dobMonth = $params->get('dobMonth', null);
        $dobYear = $params->get('dobYear', null);
        $enableActivitySummaryEmail = $params->get('enableActivitySummaryEmail', null);

        if (empty($userId)) {
            return $this->apiError('User ID is required');
        }

        try {
            $visitor = \XF::visitor();
            
            $user = $this->em()->find('XF:User', $userId);
            if (!$user) {
                return $this->apiError('User not found');
            }

            // Check if user can edit this profile
            if ($visitor->user_id != $user->user_id) {
                if (!$visitor->canEditProfile()) {
                    return $this->apiError('Permission denied');
                }
            } else {
                // User editing own profile - check canEditProfile
                if (!$visitor->canEditProfile()) {
                    return $this->apiError('You do not have permission to edit your profile');
                }
            }

            $form = $this->formAction();

            // Prepare user table input
            $userInput = [];
            if (isset($userData['customTitle'])) {
                if ($visitor->hasPermission('general', 'editCustomTitle')) {
                    $userInput['custom_title'] = $userData['customTitle'];
                }
            }
            if (isset($userData['visible'])) {
                $userInput['visible'] = (bool)$userData['visible'];
            }
            if (isset($userData['activityVisible'])) {
                $userInput['activity_visible'] = (bool)$userData['activityVisible'];
            }
            if (isset($userData['timezone'])) {
                $userInput['timezone'] = $userData['timezone'];
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
            }

            // Handle activity summary email toggle
            if ($enableActivitySummaryEmail !== null) {
                $form->setup(function () use ($user, $enableActivitySummaryEmail) {
                    $user->toggleActivitySummaryEmail((bool)$enableActivitySummaryEmail);
                });
            }

            // Prepare profile input
            $profileInput = [];
            if (isset($profileData['location'])) {
                $profileInput['location'] = $profileData['location'];
            }
            if (isset($profileData['website'])) {
                $profileInput['website'] = $profileData['website'];
            }
            if (isset($profileData['about'])) {
                $profileInput['about'] = $profileData['about'];
            }

            // Handle signature with proper service
            if (isset($profileData['signature'])) {
                // Check if visitor can edit signature (for own profile) or if moderator editing other's profile
                $canEditSig = ($visitor->user_id == $user->user_id && $visitor->canEditSignature()) 
                    || ($visitor->user_id != $user->user_id && $visitor->is_moderator);
                
                if ($canEditSig) {
                    /** @var \XF\Service\User\SignatureEditService $sigEditor */
                    $sigEditor = $this->service('XF:User\SignatureEdit', $user);
                    if ($sigEditor->setSignature($profileData['signature'], $errors)) {
                        $profileInput['signature'] = $sigEditor->getNewSignature();
                    } else {
                        return $this->apiError('Signature validation failed: ' . implode(', ', $errors));
                    }
                } else {
                    return $this->apiError('You do not have permission to edit signature');
                }
            }

            // Get profile entity
            /** @var \XF\Entity\UserProfile $userProfile */
            $userProfile = $user->getRelationOrDefault('Profile');

            // Handle date of birth
            if ($dobDay !== null || $dobMonth !== null || $dobYear !== null) {
                $form->setup(function () use ($userProfile, $dobDay, $dobMonth, $dobYear) {
                    if ($dobDay === null || $dobMonth === null) {
                        $userProfile->error(\XF::phrase('please_enter_valid_date_of_birth'), 'dob');
                    } else {
                        $userProfile->setDob((int)$dobDay, (int)$dobMonth, $dobYear ? (int)$dobYear : 0);
                    }
                });
            }

            // Save profile fields
            if (!empty($profileInput)) {
                $form->setupEntityInput($userProfile, $profileInput);
            }

            // Handle custom fields for personal group
            if (!empty($customFields) && is_array($customFields)) {
                $fieldSet = $userProfile->custom_fields;
                $fieldDefinition = $fieldSet->getDefinitionSet()
                    ->filterGroup('personal')
                    ->filterEditable($fieldSet, 'user');
                $customFieldsShown = array_keys($fieldDefinition->getFieldDefinitions());
                
                if ($customFieldsShown) {
                    $form->setup(function () use ($fieldSet, $customFields, $customFieldsShown) {
                        $fieldSet->bulkSet($customFields, $customFieldsShown, 'user');
                    });
                }

                // Handle custom fields for contact group
                $fieldDefinitionContact = $fieldSet->getDefinitionSet()
                    ->filterGroup('contact')
                    ->filterEditable($fieldSet, 'user');
                $customFieldsShownContact = array_keys($fieldDefinitionContact->getFieldDefinitions());
                
                if ($customFieldsShownContact) {
                    $form->setup(function () use ($fieldSet, $customFields, $customFieldsShownContact) {
                        $fieldSet->bulkSet($customFields, $customFieldsShownContact, 'user');
                    });
                }
            }

            // Spam check for about field
            if (isset($profileInput['about']) && $user->isSpamCheckRequired()) {
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

            // Log IP address
            $form->complete(function () use ($user) {
                $ipRepo = $this->repository('XF:Ip');
                $ipRepo->logIp($user->user_id, $this->request->getIp(), 'user', $user->user_id, 'account_details_edit');
            });

            // Run the form action
            $form->run();

            $result = new FCUpdateProfileResult(true, null);
            return $this->apiSuccess($result);

        } catch (\XF\Mvc\Reply\Exception $e) {
            // Extract XenForo's error message from the exception
            $errorMsg = $this->extractErrorMessageFromReplyException($e, 'Profile update failed');
            return $this->apiError($errorMsg);
        } catch (\Exception $e) {
            return $this->apiError('Profile update failed: ' . $e->getMessage());
        }
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
            return $this->apiError('Logout failed: ' . $e->getMessage());
        }
    }

    public function actionForgotPassword(ParameterBag $params)
    {
        // Don't allow if already logged in
        $visitor = \XF::visitor();
        if ($visitor->user_id) {
            return $this->apiError('You are already logged in');
        }

        // Accept either email or username in a single parameter
        $usernameOrEmail = $params->get('usernameOrEmail', '');

        if (empty($usernameOrEmail)) {
            return $this->apiError('Username or email is required');
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
            /** @var \XF\Service\User\PasswordResetService $passwordReset */
            $passwordReset = $this->service('XF:User\PasswordReset', $user);
            
            // Check if password reset can be triggered
            if (!$passwordReset->canTriggerConfirmation($error)) {
                return $this->apiError($error ? $error : 'Password reset cannot be triggered at this time');
            }

            // Trigger the confirmation (sends email)
            $passwordReset->triggerConfirmation();

            // Return success (don't reveal if user exists for security)
            $result = new FCForgetPasswordResult(true, null, false);
            return $this->apiSuccess($result);

        } catch (\Exception $e) {
            return $this->apiError('Password reset request failed: ' . $e->getMessage());
        }
    }

    public function actionPrefetchAccount(ParameterBag $params)
    {
        $options = $this->app()->options();
        $setup = $options->registrationSetup;
        
        // Check if registration is open (forum must be open AND registration enabled)
        $registrationOpen = $options->boardActive && !empty($setup['enabled']);
        
        // Check if API registration is possible (only if registration is open)
        $canRegister = $registrationOpen && $this->canRegisterViaAPI();
        
        // Always include registration URL
        $registerViaWebUrl = $options->boardUrl . '/register';
        
        // Get custom fields for registration
        $customFields = $this->getRegistrationCustomFields();
        
        // Build registration requirements if registration is possible
        $requirements = null;
        if ($canRegister) {
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
                    'minimumAge' => (int)($setup['minimumAge'] ?: 13),
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
     * Get custom fields that are shown during registration
     * 
     * @return array Array of custom field definitions
     */
    protected function getRegistrationCustomFields()
    {
        $customFields = [];
        
        try {
            /** @var \XF\Repository\UserFieldRepository $userFieldRepo */
            $userFieldRepo = $this->repository('XF:UserField');
            $userFields = $userFieldRepo->findFieldsForList()->fetch();
            
            foreach ($userFields as $field) {
                if ($field->show_registration) {
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
     * Get privacy policy configuration
     * 
     * @return array Privacy policy configuration
     */
    protected function getPrivacyPolicyConfig()
    {
        $privacyPolicyUrl = $this->app->container('privacyPolicyUrl');
        
        return [
            'required' => !empty($privacyPolicyUrl),
            'url' => $privacyPolicyUrl ?: ''
        ];
    }

    /**
     * Get terms of service configuration
     * 
     * @return array Terms of service configuration
     */
    protected function getTermsOfServiceConfig()
    {
        $tosUrl = $this->app->container('tosUrl');
        
        return [
            'required' => !empty($tosUrl),
            'url' => $tosUrl ?: ''
        ];
    }

    /**
     * Validate CAPTCHA token for API registration
     * 
     * @param string $token The CAPTCHA token from the client
     * @return bool True if CAPTCHA is valid or not required
     */
    protected function validateCaptchaToken($token)
    {
        $options = $this->app()->options();
        $captcha = $options->captcha;
        
        // If no CAPTCHA configured, always pass
        if (!$captcha) {
            return true;
        }
        
        // If visitor wouldn't normally see CAPTCHA, pass
        $visitor = \XF::visitor();
        if (!$visitor->isShownCaptcha()) {
            return true;
        }
        
        // If no token provided, fail validation
        if (empty($token)) {
            return false;
        }
        
        // For API, we need to inject the token into the request
        // The CAPTCHA classes read from request, so we temporarily set it
        $paramName = null;
        $originalValue = null;
        
        // Map generic captchaToken to the appropriate request parameter based on CAPTCHA type
        switch ($captcha) {
            case 'ReCaptcha':
                $paramName = 'g-recaptcha-response';
                break;
            case 'HCaptcha':
                $paramName = 'h-captcha-response';
                break;
            case 'Turnstile':
                $paramName = 'cf-turnstile-response';
                break;
            case 'TextCaptcha':
                $paramName = 'captcha_textcaptcha';
                break;
            case 'KeyCaptcha':
                $paramName = 'capchachallenge';
                break;
            default:
                // Unknown CAPTCHA type - try to validate anyway
                return false;
        }
        
        if ($paramName) {
            // Store original value if it exists
            try {
                $originalValue = $this->request->filter($paramName, 'str');
            } catch (\Exception $e) {
                $originalValue = null;
            }
            
            // Set the token in the request
            $this->request->set($paramName, $token);
        }
        
        try {
            // Validate using XenForo's captcha system
            $isValid = $this->captchaIsValid(true);
            
            // Restore original request value
            if ($paramName !== null) {
                if ($originalValue !== null) {
                    $this->request->set($paramName, $originalValue);
                } else {
                    // Remove the parameter if it didn't exist before
                    $input = $this->request->getInput();
                    if (isset($input[$paramName])) {
                        unset($input[$paramName]);
                        // Request doesn't have an easy way to remove, so set to empty string
                        $this->request->set($paramName, '');
                    }
                }
            }
            
            return $isValid;
        } catch (\Exception $e) {
            // Restore original request value on error
            if ($paramName !== null) {
                if ($originalValue !== null) {
                    $this->request->set($paramName, $originalValue);
                } else {
                    $this->request->set($paramName, '');
                }
            }
            // Log error and fail validation
            \XF::logError('ForumCopilot: CAPTCHA validation error: ' . $e->getMessage());
            return false;
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
                return $this->apiError('Category parameter is required');
            }

            // Get settings provider based on category
            $provider = $this->getSettingsProvider($category);
            if (!$provider) {
                return $this->apiError('Unknown settings category: ' . $category);
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
            return $this->apiError('Failed to get user settings: ' . $e->getMessage());
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
                return $this->apiError('Category parameter is required');
            }

            if (!is_array($settingsToUpdate)) {
                return $this->apiError('Settings must be an object/array');
            }

            // Get settings provider based on category
            $provider = $this->getSettingsProvider($category);
            if (!$provider) {
                return $this->apiError('Unknown settings category: ' . $category);
            }

            // Validate and update settings
            $validationErrors = $provider->validateSettings($visitor, $settingsToUpdate);
            if (!empty($validationErrors)) {
                return $this->apiError('Validation failed: ' . implode(', ', $validationErrors));
            }

            // Apply updates
            $provider->updateSettings($visitor, $settingsToUpdate);

            // Return updated settings
            return $this->actionGetUserSettings(new ParameterBag(['category' => $category]));

        } catch (\Exception $e) {
            return $this->apiError('Failed to update user settings: ' . $e->getMessage());
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
            return $this->apiError('Failed to get settings categories: ' . $e->getMessage());
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
