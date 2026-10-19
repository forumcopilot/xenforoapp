<?php

namespace ForumCopilot\Pub\Controller;

use ForumCopilot\Service\AppLoginCode;
use ForumCopilot\Service\AppLoginRequest;

/**
 * Signing the app in through the forum's website: the app opens this page
 * in the system browser sheet; the member signs in the forum's own way if
 * they are not already (password, passkey, Google, Facebook, two-step),
 * confirms "Continue as {name}", and the page hands a one-time code to the
 * app's scheme (see AppLoginCode).
 *
 * The confirmation is a form with XenForo's CSRF token, so another website
 * cannot get a code for a signed-in member by sending them here.
 *
 * A guest's request is also kept in XenForo's session (AppLoginRequest): a
 * guest who signs up instead of signing in ends on register/complete, which
 * then offers "Continue in the app" (XF\Pub\Controller\Register extension).
 */
class AppLogin extends \XF\Pub\Controller\AbstractController
{
    public function actionIndex()
    {
        $params = AppLoginRequest::fromParams($this->filter([
            'scheme' => 'str',
            'state' => 'str',
            'challenge' => 'str',
        ]));
        if (!$params) {
            return $this->error(\XF::phrase('fc_app_login_invalid'));
        }

        $visitor = \XF::visitor();
        if (!$visitor->user_id) {
            AppLoginRequest::remember($this->session(), $params);

            // The forum's own sign-in page, then back here.
            return $this->redirect($this->buildLink('login', null, [
                '_xfRedirect' => $this->buildLink('canonical:forumcopilot-app-login', null, $params),
            ]));
        }

        if (!$this->isPost()) {
            return $this->view('ForumCopilot:AppLogin', 'fc_app_login_confirm', $params);
        }

        AppLoginRequest::forget($this->session());
        $code = AppLoginCode::issue((int)$visitor->user_id, $params['challenge']);
        return $this->redirect($params['scheme'] . '://login?' . http_build_query(['code' => $code, 'state' => $params['state']]), '');
    }

    /**
     * "Not you? Sign out" on the confirmation page: XenForo's sign-out (with
     * its CSRF token, as XenForo's own Log out link), then this page again,
     * where the member signs in with the account they meant.
     */
    public function actionSignOut()
    {
        $this->assertValidCsrfToken($this->filter('t', 'str'));

        $params = AppLoginRequest::fromParams($this->filter([
            'scheme' => 'str',
            'state' => 'str',
            'challenge' => 'str',
        ]));
        if (!$params) {
            return $this->error(\XF::phrase('fc_app_login_invalid'));
        }

        $this->plugin('XF:Login')->logoutVisitor(); // 2.2 name; aliased on 2.3

        return $this->redirect($this->buildLink('forumcopilot-app-login', null, $params), '');
    }

    public function assertViewingPermissions($action)
    {
        // Signing in must work on a forum guests cannot view.
    }
}
