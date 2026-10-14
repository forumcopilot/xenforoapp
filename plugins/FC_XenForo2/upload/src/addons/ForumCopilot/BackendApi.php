<?php

namespace ForumCopilot;

/**
 * Centralized constants for outbound calls to the ForumCopilot backend API.
 * Use these for all HTTP requests (registration, SSO, push webhook, etc.).
 */
class BackendApi
{
    public const API_URL = 'https://forumcopilot.com/api';

    /**
     * The backend API base URL: API_URL unless a test forum points the add-on
     * at another Forum Copilot environment in src/config.php, for example
     *   $config['forumCopilot']['apiUrl'] = 'https://staging.forumcopilot.com/api';
     * Live forums never set this.
     */
    public static function apiUrl(): string
    {
        try {
            $fc = \XF::config('forumCopilot');
        } catch (\Throwable $e) {
            $fc = null;
        }
        $override = is_array($fc) ? trim((string) ($fc['apiUrl'] ?? '')) : '';

        return $override !== '' ? rtrim($override, '/') : self::API_URL;
    }

    /** Path for connection validation (GET). */
    public const VALIDATE_CONNECTION_PATH = '/validate-connection';

    /** User-Agent value sent with every request to the backend (WAF/CDN friendly). */
    public const USER_AGENT = 'ForumCopilotPlugin/1.3.2 (+https://forumcopilot.com)';
}
