<?php

namespace ForumCopilot\XF\Pub\Controller;

use ForumCopilot\Service\AppLoginRequest;

/**
 * Signing up on the website from the app, and coming back signed in.
 *
 * The app opens the register page with the app sign-in page as _xfRedirect
 * (Pub\Controller\AppLogin). XenForo drops that once the account exists: the
 * form and a Google or Facebook sign-up both end on register/complete. So
 * the app's request is kept in the session (AppLoginRequest), carried over
 * the new member's fresh session, and register/complete shows "Continue in
 * the app" (template modification fc_register_complete_app_login), a form
 * that posts to AppLogin, which hands the code to the app as for a sign-in.
 *
 * Extends XF\Pub\Controller\Register, XenForo 2.2's name for
 * RegisterController; 2.3 maps extensions of the old name onto the new.
 */
class Register extends XFCP_Register
{
    public function actionIndex()
    {
        $request = $this->appLoginRequestFromRedirect();
        if ($request && \XF::visitor()->user_id) {
            // Signed in on the website already. XenForo 2.3 would only say
            // "You are already logged in"; the app sign-in page offers
            // "Continue as {name}" and "Not you?".
            return $this->redirect($this->buildLink('forumcopilot-app-login', null, $request), '');
        }

        return parent::actionIndex();
    }

    public function actionConnectedAccount(\XF\Mvc\ParameterBag $params)
    {
        $this->appLoginRequestFromRedirect();

        return parent::actionConnectedAccount($params);
    }

    public function actionConnectedAccountRegister(\XF\Mvc\ParameterBag $params)
    {
        $this->appLoginRequestFromRedirect();

        return parent::actionConnectedAccountRegister($params);
    }

    public function actionComplete()
    {
        $reply = parent::actionComplete();

        if ($reply instanceof \XF\Mvc\Reply\View && \XF::visitor()->user_id) {
            $request = AppLoginRequest::remembered($this->session());
            if ($request) {
                $reply->setParam('fcAppLogin', $request);
            }
        }

        return $reply;
    }

    protected function finalizeRegistration(\XF\Entity\User $user)
    {
        // Signing the new member in starts a new session without the old
        // one's data; XenForo carries its own pre-registration URL over the
        // same way.
        $request = AppLoginRequest::remembered($this->session());

        parent::finalizeRegistration($user);

        if ($request) {
            AppLoginRequest::remember($this->session(), $request);
        }
    }

    /**
     * The app's sign-in request when this page was opened with this forum's
     * app sign-in page as _xfRedirect; a guest's is kept in the session.
     */
    protected function appLoginRequestFromRedirect(): ?array
    {
        $request = AppLoginRequest::fromUrl($this->filter('_xfRedirect', 'str'), $this->request);
        if ($request && !\XF::visitor()->user_id) {
            AppLoginRequest::remember($this->session(), $request);
        }

        return $request;
    }
}
