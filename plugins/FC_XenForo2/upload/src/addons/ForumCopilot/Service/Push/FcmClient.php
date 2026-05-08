<?php

namespace ForumCopilot\Service\Push;

/**
 * Minimal FCM HTTP v1 client. Zero external dependencies.
 *
 * Auth flow:
 *   1. Build a JWT signed with the service-account private key (RS256, openssl)
 *   2. POST that JWT to https://oauth2.googleapis.com/token to get an access token
 *   3. Cache the access token for ~55 min (XF data registry)
 *   4. POST messages to https://fcm.googleapis.com/v1/projects/{project_id}/messages:send
 *
 * Required PHP extensions: openssl, curl, json — all standard.
 */
class FcmClient
{
    public const OAUTH_TOKEN_URL = 'https://oauth2.googleapis.com/token';
    public const FCM_SEND_URL_TEMPLATE = 'https://fcm.googleapis.com/v1/projects/%s/messages:send';
    public const FCM_SCOPE = 'https://www.googleapis.com/auth/firebase.messaging';

    /** Token TTL is 60min server-side; refresh 5min early to avoid edge expiry. */
    public const TOKEN_REFRESH_BUFFER_SECS = 300;

    /** Per-service-account cache key suffix (so multiple SAs cache independently). */
    protected const REGISTRY_KEY_PREFIX = 'fcPushAccessToken:';

    protected string $projectId;
    protected string $clientEmail;
    protected string $privateKey;

    /** Optional: in-process token cache when XF registry is unavailable (e.g. CLI tests). */
    protected static array $localCache = [];

    /**
     * @param string $serviceAccountPath Absolute path to the Firebase service-account JSON file.
     */
    public function __construct(string $serviceAccountPath)
    {
        if (!is_readable($serviceAccountPath)) {
            throw new \RuntimeException("FcmClient: service-account JSON not readable at $serviceAccountPath");
        }
        $raw = file_get_contents($serviceAccountPath);
        $sa = json_decode($raw, true);
        if (!is_array($sa) || !isset($sa['project_id'], $sa['client_email'], $sa['private_key'])) {
            throw new \RuntimeException("FcmClient: invalid service-account JSON (missing project_id / client_email / private_key)");
        }

        $this->projectId   = $sa['project_id'];
        $this->clientEmail = $sa['client_email'];
        $this->privateKey  = $sa['private_key'];
    }

    public function getProjectId(): string
    {
        return $this->projectId;
    }

    /**
     * Send one FCM message.
     *
     * @param string $deviceToken FCM registration token from the mobile app
     * @param array  $payload     Message body. At minimum should include 'notification' and/or 'data'.
     *                            See https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages
     * @return array {
     *   'success': bool,
     *   'messageName': string|null,    // The FCM "name" returned on success
     *   'httpCode': int,
     *   'error': string|null,
     *   'errorCode': string|null,      // Google's machine code, e.g. UNREGISTERED
     *   'tokenInvalid': bool,          // True if the token should be deleted from your DB
     * }
     */
    public function send(string $deviceToken, array $payload): array
    {
        $accessToken = $this->getAccessToken();
        $url = sprintf(self::FCM_SEND_URL_TEMPLATE, $this->projectId);

        $message = ['message' => array_merge(['token' => $deviceToken], $payload)];

        [$httpCode, $body, $curlError] = $this->httpPostJson($url, $message, [
            'Authorization: Bearer ' . $accessToken,
            'Content-Type: application/json',
        ]);

        if ($curlError !== '') {
            return $this->failure(0, "curl: $curlError", null, false);
        }

        $resp = json_decode($body, true);
        if ($httpCode >= 200 && $httpCode < 300) {
            return [
                'success'      => true,
                'messageName'  => $resp['name'] ?? null,
                'httpCode'     => $httpCode,
                'error'        => null,
                'errorCode'    => null,
                'tokenInvalid' => false,
            ];
        }

        $errorCode = $this->extractErrorCode($resp);
        $errorMsg  = $resp['error']['message'] ?? "HTTP $httpCode";

        // Per https://firebase.google.com/docs/cloud-messaging/manage-tokens
        // these codes mean the token is dead and should be removed from the DB.
        $tokenInvalid = $httpCode === 404
            || in_array($errorCode, ['UNREGISTERED', 'NOT_FOUND', 'INVALID_ARGUMENT', 'SENDER_ID_MISMATCH'], true);

        return $this->failure($httpCode, $errorMsg, $errorCode, $tokenInvalid);
    }

    // --------------------------------------------------------------------
    // Internal — auth
    // --------------------------------------------------------------------

    protected function getAccessToken(): string
    {
        $cache = $this->getTokenCache();
        if ($cache && isset($cache['token'], $cache['expires_at'])
            && $cache['expires_at'] > $this->now() + self::TOKEN_REFRESH_BUFFER_SECS
        ) {
            return $cache['token'];
        }
        return $this->mintAccessToken();
    }

    protected function mintAccessToken(): string
    {
        $jwt = $this->buildAssertionJwt();

        [$httpCode, $body, $curlError] = $this->httpPostForm(self::OAUTH_TOKEN_URL, [
            'grant_type' => 'urn:ietf:params:oauth:grant-type:jwt-bearer',
            'assertion'  => $jwt,
        ]);

        if ($curlError !== '') {
            throw new \RuntimeException("FcmClient: OAuth exchange failed (curl): $curlError");
        }
        if ($httpCode !== 200) {
            throw new \RuntimeException("FcmClient: OAuth exchange failed (HTTP $httpCode): $body");
        }

        $resp = json_decode($body, true);
        if (!is_array($resp) || empty($resp['access_token'])) {
            throw new \RuntimeException("FcmClient: OAuth response missing access_token: $body");
        }

        $token     = $resp['access_token'];
        $expiresIn = (int)($resp['expires_in'] ?? 3600);
        $this->setTokenCache([
            'token'      => $token,
            'expires_at' => $this->now() + $expiresIn,
        ]);

        return $token;
    }

    /**
     * Builds the RFC 7523 JWT assertion: header.claims.signature, base64url-encoded,
     * RS256 over the SHA-256 hash of the header.claims string using the SA private key.
     */
    public function buildAssertionJwt(): string
    {
        $now = $this->now();
        $header = ['alg' => 'RS256', 'typ' => 'JWT'];
        $claims = [
            'iss'   => $this->clientEmail,
            'scope' => self::FCM_SCOPE,
            'aud'   => self::OAUTH_TOKEN_URL,
            'iat'   => $now,
            'exp'   => $now + 3600,
        ];

        $segments = [
            $this->b64url(json_encode($header, JSON_UNESCAPED_SLASHES)),
            $this->b64url(json_encode($claims, JSON_UNESCAPED_SLASHES)),
        ];
        $signingInput = implode('.', $segments);

        $signature = '';
        if (!openssl_sign($signingInput, $signature, $this->privateKey, OPENSSL_ALGO_SHA256)) {
            throw new \RuntimeException('FcmClient: openssl_sign failed: ' . openssl_error_string());
        }
        $segments[] = $this->b64url($signature);
        return implode('.', $segments);
    }

    // --------------------------------------------------------------------
    // Internal — helpers
    // --------------------------------------------------------------------

    protected function failure(int $httpCode, string $error, ?string $errorCode, bool $tokenInvalid): array
    {
        return [
            'success'      => false,
            'messageName'  => null,
            'httpCode'     => $httpCode,
            'error'        => $error,
            'errorCode'    => $errorCode,
            'tokenInvalid' => $tokenInvalid,
        ];
    }

    protected function extractErrorCode(?array $resp): ?string
    {
        if (!$resp) return null;
        // FCM v1 puts the machine code in error.details[*].errorCode (preferred) and falls back to error.status.
        if (!empty($resp['error']['details']) && is_array($resp['error']['details'])) {
            foreach ($resp['error']['details'] as $detail) {
                if (!empty($detail['errorCode'])) {
                    return (string)$detail['errorCode'];
                }
            }
        }
        return $resp['error']['status'] ?? null;
    }

    protected function b64url(string $data): string
    {
        return rtrim(strtr(base64_encode($data), '+/', '-_'), '=');
    }

    protected function now(): int
    {
        return defined('\\XF::$time') ? \XF::$time : time();
    }

    /**
     * @return array{0:int,1:string,2:string} [httpCode, body, curlError]
     */
    protected function httpPostJson(string $url, array $body, array $headers): array
    {
        $ch = curl_init($url);
        curl_setopt_array($ch, [
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_POST           => true,
            CURLOPT_HTTPHEADER     => $headers,
            CURLOPT_POSTFIELDS     => json_encode($body, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE),
            CURLOPT_TIMEOUT        => 15,
            CURLOPT_SSL_VERIFYPEER => true,
            CURLOPT_SSL_VERIFYHOST => 2,
        ]);
        $resp  = curl_exec($ch);
        $code  = (int)curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $err   = curl_error($ch);
        curl_close($ch);
        return [$code, (string)$resp, $err];
    }

    /**
     * @return array{0:int,1:string,2:string} [httpCode, body, curlError]
     */
    protected function httpPostForm(string $url, array $params): array
    {
        $ch = curl_init($url);
        curl_setopt_array($ch, [
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_POST           => true,
            CURLOPT_HTTPHEADER     => ['Content-Type: application/x-www-form-urlencoded'],
            CURLOPT_POSTFIELDS     => http_build_query($params),
            CURLOPT_TIMEOUT        => 10,
            CURLOPT_SSL_VERIFYPEER => true,
            CURLOPT_SSL_VERIFYHOST => 2,
        ]);
        $resp  = curl_exec($ch);
        $code  = (int)curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $err   = curl_error($ch);
        curl_close($ch);
        return [$code, (string)$resp, $err];
    }

    protected function getTokenCache(): ?array
    {
        $key = self::REGISTRY_KEY_PREFIX . sha1($this->clientEmail);

        // Prefer XF registry; fall back to in-process cache (tests, CLI).
        if (class_exists('\\XF') && method_exists('\\XF', 'app')) {
            try {
                $val = \XF::app()->registry()->get($key);
                if (is_array($val)) return $val;
            } catch (\Throwable $e) {
                // fall through
            }
        }
        return self::$localCache[$key] ?? null;
    }

    protected function setTokenCache(array $data): void
    {
        $key = self::REGISTRY_KEY_PREFIX . sha1($this->clientEmail);
        self::$localCache[$key] = $data;

        if (class_exists('\\XF') && method_exists('\\XF', 'app')) {
            try {
                \XF::app()->registry()->set($key, $data);
            } catch (\Throwable $e) {
                // best-effort
            }
        }
    }
}
