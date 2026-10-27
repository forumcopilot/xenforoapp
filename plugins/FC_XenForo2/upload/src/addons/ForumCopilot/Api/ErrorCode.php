<?php

namespace ForumCopilot\Api;

/**
 * Machine-readable codes sent as `errorCode` next to `resultText` on every
 * `result: false` reply, so the app can tell kinds of error apart without
 * reading the (translated) text. Added in add-on 1.11.0; older add-ons send
 * no `errorCode`.
 */
class ErrorCode
{
    /** The method needs a signed-in member. */
    const LOGIN_REQUIRED = 'login_required';
    /** Guests may not see or do this; signing in may help. */
    const GUEST_DENIED = 'guest_denied';
    const NO_PERMISSION = 'no_permission';
    const NOT_FOUND = 'not_found';
    /** Input was refused; `errors` (field => message) names the fields when XenForo does. */
    const VALIDATION = 'validation';
    /** Too soon after the last action of this kind (XenForo's flood check). */
    const FLOOD = 'flood';
    const BOARD_CLOSED = 'board_closed';
    /** A banned account or IP address. */
    const BANNED = 'banned';
    /** A new account waiting for email confirmation or approval. */
    const ACCOUNT_PENDING = 'account_pending';
    /** A rejected or disabled account. */
    const ACCOUNT_DISABLED = 'account_disabled';
    /** The member's groups require two-step verification, which they haven't set up. */
    const TFA_REQUIRED = 'tfa_required';
    const SECURITY_LOCKED = 'security_locked';
    /** A malformed call: bad JSON, unknown method, missing or invalid parameters. */
    const BAD_REQUEST = 'bad_request';
    /** Unexpected failure; logged in XenForo's server error log under `errorId`. */
    const SERVER_ERROR = 'server_error';
    /** Any other refusal; `resultText` says why. */
    const ERROR = 'error';

    /**
     * Code for an error message, the way XenForo's Error plugin classifies
     * errors: a phrase named *_not_found is a 404, do_not_have_permission a
     * 403. Otherwise the HTTP code decides, and failing that it's ERROR.
     *
     * @param mixed $message string, \XF\Phrase or array of either
     */
    public static function infer($message, $httpCode = null, bool $isGuest = false): string
    {
        if (is_array($message)) {
            $message = reset($message);
        }

        if ($message instanceof \XF\Phrase) {
            $name = $message->getName();
            if (preg_match('/_not_found$/', $name)) {
                return self::NOT_FOUND;
            }
            if ($name === 'login_required') {
                return self::LOGIN_REQUIRED;
            }
            if ($name === 'do_not_have_permission') {
                return $isGuest ? self::GUEST_DENIED : self::NO_PERMISSION;
            }
            if (strpos($name, 'must_wait_x_seconds') === 0) {
                return self::FLOOD;
            }
        }

        switch ((int)$httpCode) {
            case 401:
                return self::LOGIN_REQUIRED;
            case 403:
                return $isGuest ? self::GUEST_DENIED : self::NO_PERMISSION;
            case 404:
                return self::NOT_FOUND;
            case 429:
                return self::FLOOD;
            case 500:
                return self::SERVER_ERROR;
        }

        return self::ERROR;
    }

    /**
     * Logs an unexpected exception in XenForo's server error log with a short
     * reference, and returns that reference. The member sees the reference;
     * the exception's own text stays in the log.
     */
    public static function logException(\Throwable $e, string $context = ''): string
    {
        $errorId = bin2hex(random_bytes(4));
        $prefix = 'Forum Copilot API [' . $errorId . ']' . ($context !== '' ? ' ' . $context : '') . ': ';
        \XF::logException($e, false, $prefix);
        return $errorId;
    }

    /**
     * The message a member sees for an unexpected error.
     */
    public static function unexpectedMessage(string $errorId): string
    {
        return \XF::phrase('unexpected_error_occurred')->render('raw') . ' (' . $errorId . ')';
    }
}
