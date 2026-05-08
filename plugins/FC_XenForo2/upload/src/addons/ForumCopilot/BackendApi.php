<?php

namespace ForumCopilot;

/**
 * Centralized constants for outbound calls to the ForumCopilot backend API.
 * Use these for all HTTP requests (registration, SSO, push webhook, etc.).
 */
class BackendApi
{
    public const API_URL = 'https://forumcopilot.com/api';

    /** Path for connection validation (GET). */
    public const VALIDATE_CONNECTION_PATH = '/validate-connection';

    /** User-Agent value sent with every request to the backend (WAF/CDN friendly). */
    public const USER_AGENT = 'ForumCopilotPlugin/1.3.2 (+https://forumcopilot.com)';
}
