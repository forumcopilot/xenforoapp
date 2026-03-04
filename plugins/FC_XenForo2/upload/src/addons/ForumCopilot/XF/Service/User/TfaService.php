<?php

namespace ForumCopilot\XF\Service\User;

use XF\Http\Request;

/**
 * Extends TfaService so that passkey verification uses our own challenge/validation
 * (binary challenge + lbuchs processGet), since XenForo core uses a string challenge
 * which causes "invalid challenge" with the WebAuthn library.
 */
class TfaService extends XFCP_TfaService
{
    public function verify(Request $request, $providerId)
    {
        if ($providerId !== 'passkey') {
            return parent::verify($request, $providerId);
        }

        $webauthnChallenge = $request->get('webauthn_challenge', '');
        $webauthnPayload = $request->get('webauthn_payload');
        if (empty($webauthnChallenge) || !is_array($webauthnPayload) || empty($webauthnPayload)) {
            return parent::verify($request, $providerId);
        }

        $session = \XF::session();
        $challengeService = $this->app->service(\ForumCopilot\Service\PasskeyChallengeService::class);
        $error = null;
        $passkey = $challengeService->validateAssertion($session, $webauthnChallenge, $webauthnPayload, $error);

        if ($passkey === null || $passkey->user_id != $this->user->user_id) {
            return parent::verify($request, $providerId);
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
