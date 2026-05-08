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
    use PasskeyTfaVerifyTrait;

    public function verify(Request $request, $providerId)
    {
        $result = $this->verifyForumCopilotPasskey($request, $providerId);
        if ($result !== null)
        {
            return $result;
        }

        return parent::verify($request, $providerId);
    }
}
