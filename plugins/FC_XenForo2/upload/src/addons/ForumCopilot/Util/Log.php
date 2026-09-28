<?php

namespace ForumCopilot\Util;

/**
 * Diagnostic logging for the push pipeline.
 *
 * XenForo has no log level below "error": everything written with
 * \XF::logError() lands in the server error log as an ErrorException, so
 * trace lines that describe a correctly-skipped push read as failures to a
 * forum owner. Every such line goes through debug(), which writes only when
 * the "Diagnostic logging" option (fc_debug_logging) is on. Real failures
 * (caught exceptions, HTTP errors, missing configuration) keep calling
 * \XF::logError() directly and are never silenced.
 */
class Log
{
    /** @var bool|null Resolved once per request; null until first use. */
    protected static $enabled = null;

    public static function debug(string $message): void
    {
        if (!self::enabled()) {
            return;
        }
        \XF::logError($message);
    }

    public static function enabled(): bool
    {
        if (self::$enabled === null) {
            try {
                self::$enabled = !empty(\XF::options()->fc_debug_logging);
            } catch (\Throwable $e) {
                // Options not available yet (very early boot); stay quiet.
                return false;
            }
        }
        return self::$enabled;
    }
}
