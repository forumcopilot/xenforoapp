<?php

namespace ForumCopilot\Pub\Controller;

use ForumCopilot\Service\AppLoginCode;

/**
 * Signing the app in through the forum's website: the app opens this page
 * in the system browser sheet; the member signs in the forum's own way if
 * they are not already (password, passkey, Google, Facebook, two-step),
 * confirms "Continue as {name}", and the page hands a one-time code to the
 * app's scheme (see AppLoginCode).
 *
 * The confirmation is a form with XenForo's CSRF token, so another website
 * cannot get a code for a signed-in member by sending them here.
 */
class AppLogin extends \XF\Pub\Controller\AbstractController
{
    public function actionIndex()
    {
        $scheme = strtolower($this->filter('scheme', 'str'));
        $state = $this->filter('state', 'str');
        $challenge = $this->filter('challenge', 'str');

        if (!AppLoginCode::isAllowedScheme($scheme)
            || !preg_match('/^[A-Za-z0-9_-]{16,128}$/', $state)
            || !AppLoginCode::isValidChallenge($challenge)
        ) {
            return $this->error(\XF::phrase('fc_app_login_invalid'));
        }

        $params = ['scheme' => $scheme, 'state' => $state, 'challenge' => $challenge];
        $visitor = \XF::visitor();
        if (!$visitor->user_id) {
            // The forum's own sign-in page, then back here.
            return $this->redirect($this->buildLink('login', null, [
                '_xfRedirect' => $this->buildLink('canonical:forumcopilot-app-login', null, $params),
            ]));
        }

        if (!$this->isPost()) {
            return $this->view('ForumCopilot:AppLogin', 'fc_app_login_confirm', $params);
        }

        $code = AppLoginCode::issue((int)$visitor->user_id, $challenge);
        return $this->redirect($scheme . '://login?' . http_build_query(['code' => $code, 'state' => $state]), '');
    }

    public function assertViewingPermissions($action)
    {
        // Signing in must work on a forum guests cannot view.
    }
}
