<?php

namespace ForumCopilot\XF\Service\User;

use XF\Http\Request;

class Tfa extends XFCP_Tfa
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
