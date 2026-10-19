<?php

namespace ForumCopilot\Service;

/**
 * An app's request to be signed in through the forum's website: the app
 * scheme the code goes to, the app's state and its PKCE challenge, as the
 * app sends them to Pub\Controller\AppLogin.
 *
 * XenForo forgets where a visitor was headed once they sign up: the register
 * form and a Google or Facebook sign-up both end on register/complete, with
 * the _xfRedirect gone. So the request is kept in XenForo's session while the
 * visitor signs in or signs up (AppLogin, and the Register extension), and
 * register/complete offers "Continue in the app" from it. It is good for half
 * an hour and used once.
 */
class AppLoginRequest
{
    protected const SESSION_KEY = 'fcAppLoginRequest';
    protected const LIFETIME = 1800;

    /**
     * [$params] as a request (scheme, state, challenge), or null when any of
     * them is not one AppLogin accepts.
     */
    public static function fromParams(array $params): ?array
    {
        $scheme = strtolower((string)($params['scheme'] ?? ''));
        $state = (string)($params['state'] ?? '');
        $challenge = (string)($params['challenge'] ?? '');

        if (!AppLoginCode::isAllowedScheme($scheme)
            || !preg_match('/^[A-Za-z0-9_-]{16,128}$/', $state)
            || !AppLoginCode::isValidChallenge($challenge)
        ) {
            return null;
        }

        return ['scheme' => $scheme, 'state' => $state, 'challenge' => $challenge];
    }

    /**
     * The request in [$url] when it is this forum's app sign-in page, as the
     * app sends it in _xfRedirect to the register page:
     * `<forum>/index.php?forumcopilot-app-login/&scheme=…&state=…&challenge=…`,
     * or the same with friendly URLs. Like XenForo's own redirects, an
     * address on another host does not count.
     */
    public static function fromUrl(string $url, \XF\Http\Request $request): ?array
    {
        if ($url === '' || preg_match('/[\r\n@]/', $url)) {
            return null;
        }

        $parts = @parse_url($request->convertToAbsoluteUri($url));
        $base = @parse_url($request->getFullBasePath());
        if (empty($parts['host']) || empty($base['host']) || strcasecmp($parts['host'], $base['host']) !== 0) {
            return null;
        }

        $query = $parts['query'] ?? '';
        $path = $parts['path'] ?? '';
        if (!preg_match('#^forumcopilot-app-login/?(&|$)#', $query)
            && !preg_match('#/forumcopilot-app-login/?$#', $path)
        ) {
            return null;
        }

        parse_str($query, $params);
        return static::fromParams($params);
    }

    public static function remember(\XF\Session\Session $session, array $request): void
    {
        $session->set(static::SESSION_KEY, $request + ['time' => \XF::$time]);
    }

    /**
     * The request kept in [$session], if one is and it is not older than
     * half an hour.
     */
    public static function remembered(\XF\Session\Session $session): ?array
    {
        $entry = $session->get(static::SESSION_KEY);
        if (!is_array($entry) || ($entry['time'] ?? 0) < \XF::$time - static::LIFETIME) {
            return null;
        }

        return static::fromParams($entry);
    }

    public static function forget(\XF\Session\Session $session): void
    {
        if ($session->keyExists(static::SESSION_KEY)) {
            $session->remove(static::SESSION_KEY);
        }
    }
}
