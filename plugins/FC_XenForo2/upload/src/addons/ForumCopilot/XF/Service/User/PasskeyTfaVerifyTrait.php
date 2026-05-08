<?php

namespace ForumCopilot\XF\Service\User;

use XF\Http\Request;

trait PasskeyTfaVerifyTrait
{
    protected function verifyForumCopilotPasskey(Request $request, $providerId): ?bool
    {
        if ($providerId !== 'passkey' || !class_exists(\XF\Entity\Passkey::class))
        {
            return null;
        }

        $webauthnChallenge = $request->get('webauthn_challenge', '');
        $webauthnPayload = $request->get('webauthn_payload');
        if (empty($webauthnChallenge) || !is_array($webauthnPayload) || empty($webauthnPayload))
        {
            return null;
        }

        $session = \XF::session();
        $challengeService = $this->app->service(\ForumCopilot\Service\PasskeyChallengeService::class);
        $error = null;
        $passkey = $challengeService->validateAssertion($session, $webauthnChallenge, $webauthnPayload, $error);

        if ($passkey === null || $passkey->user_id != $this->user->user_id)
        {
            return false;
        }

        $challengeService->clearStoredChallenge($session);
        $challengeService->updatePasskeyLastUse($passkey, $request->getIp());

        $provider = $this->providers[$providerId];
        $providerData = $provider->getUserProviderConfig($this->user->user_id);
        $this->tfaRepo->updateUserTfaData($this->user, $provider, $providerData, true);
        $this->clearFailedAttempts();

        return true;
    }
}
