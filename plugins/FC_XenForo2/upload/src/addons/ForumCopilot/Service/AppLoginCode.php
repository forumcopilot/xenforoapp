<?php

namespace ForumCopilot\Service;

/**
 * One-time codes for signing the app in through the forum's website
 * (Pub\Controller\AppLogin issues them; the API's completeBrowserLogin
 * redeems them), so members who use Google, Facebook, a passkey or
 * two-step sign-in on the web can sign the app in too.
 *
 * A code is good once, for two minutes, and only together with the PKCE
 * verifier whose SHA-256 the app sent as the challenge, so a code seen by
 * another app on the phone is useless. Only its hash is stored (in the data
 * registry, expired ones pruned on every write).
 */
class AppLoginCode
{
    protected const REGISTRY_KEY = 'fcAppLoginCodes';
    protected const LIFETIME = 120;

    /**
     * Whether [$scheme] is one of the app schemes this forum lets the code
     * go to (option fc_app_login_schemes).
     */
    public static function isAllowedScheme(string $scheme): bool
    {
        if (!preg_match('/^[a-z][a-z0-9+.-]{1,40}$/', $scheme)) {
            return false;
        }
        $allowed = preg_split('/[\s,]+/', strtolower((string)\XF::options()->fc_app_login_schemes), -1, PREG_SPLIT_NO_EMPTY);
        return in_array($scheme, $allowed, true);
    }

    public static function isValidChallenge(string $challenge): bool
    {
        // base64url of a SHA-256 digest, unpadded (RFC 7636 S256).
        return (bool)preg_match('/^[A-Za-z0-9_-]{43}$/', $challenge);
    }

    public static function issue(int $userId, string $challenge): string
    {
        $code = \XF::generateRandomString(40);
        $codes = static::live();
        $codes[hash('sha256', $code)] = [
            'user_id' => $userId,
            'challenge' => $challenge,
            'expires' => \XF::$time + static::LIFETIME,
        ];
        \XF::registry()->set(static::REGISTRY_KEY, $codes);
        return $code;
    }

    /**
     * The user id [$code] was issued for, if it is live and [$verifier]
     * matches its challenge; it is used up either way.
     */
    public static function redeem(string $code, string $verifier): ?int
    {
        $codes = static::live();
        $key = hash('sha256', $code);
        $entry = $codes[$key] ?? null;
        unset($codes[$key]);
        \XF::registry()->set(static::REGISTRY_KEY, $codes);

        if (!$entry || !preg_match('/^[A-Za-z0-9._~-]{43,128}$/', $verifier)) {
            return null;
        }
        $expected = rtrim(strtr(base64_encode(hash('sha256', $verifier, true)), '+/', '-_'), '=');
        if (!hash_equals($entry['challenge'], $expected)) {
            return null;
        }
        return (int)$entry['user_id'];
    }

    protected static function live(): array
    {
        $codes = \XF::registry()->get(static::REGISTRY_KEY);
        if (!is_array($codes)) {
            return [];
        }
        return array_filter($codes, function ($entry) {
            return is_array($entry) && ($entry['expires'] ?? 0) > \XF::$time;
        });
    }
}
