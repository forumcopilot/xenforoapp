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
 * registry, expired ones pruned on every write, under a database lock).
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
        static::withLock(function () use ($code, $userId, $challenge) {
            $codes = static::live();
            $codes[hash('sha256', $code)] = [
                'user_id' => $userId,
                'challenge' => $challenge,
                'expires' => \XF::$time + static::LIFETIME,
            ];
            \XF::registry()->set(static::REGISTRY_KEY, $codes);
        });
        return $code;
    }

    /**
     * The user id [$code] was issued for, if it is live and [$verifier]
     * matches its challenge; it is used up either way. A code that was
     * never issued (or has expired) changes nothing, so it costs no write.
     */
    public static function redeem(string $code, string $verifier): ?int
    {
        $key = hash('sha256', $code);
        $entry = static::withLock(function () use ($key) {
            $stored = \XF::registry()->get(static::REGISTRY_KEY);
            if (!is_array($stored) || !isset($stored[$key])) {
                return null;
            }
            $codes = static::live();
            $entry = $codes[$key] ?? null;
            unset($codes[$key]);
            \XF::registry()->set(static::REGISTRY_KEY, $codes);
            return $entry;
        });

        if (!$entry || !preg_match('/^[A-Za-z0-9._~-]{43,128}$/', $verifier)) {
            return null;
        }
        $expected = rtrim(strtr(base64_encode(hash('sha256', $verifier, true)), '+/', '-_'), '=');
        if (!hash_equals((string)$entry['challenge'], $expected)) {
            return null;
        }
        return (int)$entry['user_id'];
    }

    /**
     * Runs [$work] holding a database lock on the code list, so two
     * sign-ins close together do not overwrite each other's codes (the
     * list is read, changed and written back). Without the lock (it could
     * not be had within 5 seconds) it runs anyway, as before.
     */
    protected static function withLock(\Closure $work)
    {
        $db = \XF::db();
        $lockName = 'xf_' . static::REGISTRY_KEY;
        $locked = false;
        try {
            $locked = (bool)$db->fetchOne('SELECT GET_LOCK(?, 5)', $lockName);
        } catch (\Exception $e) {
            // Named locks unavailable (some clustered databases): no lock.
        }

        try {
            return $work();
        } finally {
            if ($locked) {
                try {
                    $db->fetchOne('SELECT RELEASE_LOCK(?)', $lockName);
                } catch (\Exception $e) {
                    // released when the connection closes anyway
                }
            }
        }
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
