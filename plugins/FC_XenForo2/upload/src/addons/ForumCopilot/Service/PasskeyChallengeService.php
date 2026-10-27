<?php

namespace ForumCopilot\Service;

use lbuchs\WebAuthn\WebAuthn;
use lbuchs\WebAuthn\Binary\ByteBuffer;
use lbuchs\WebAuthn\Attestation\AuthenticatorData;
use XF\Entity\Passkey;
use XF\Session\Session;

/**
 * Generates and validates WebAuthn challenges for the app flow.
 * Uses binary challenge + base64url encoding so lbuchs WebAuthn processGet() validates correctly
 * (XenForo core uses a 128-char string which causes "invalid challenge").
 */
class PasskeyChallengeService
{
    public const SESSION_KEY_CHALLENGE = 'forumcopilot_passkey_challenge';
    public const SESSION_KEY_TIME = 'forumcopilot_passkey_challenge_time';
    public const CHALLENGE_TTL = 900; // 15 minutes, same as XF
    public const CHALLENGE_BYTES = 32;

    /** How long the Android app signing hashes read from assetlinks.json are kept. */
    protected const ASSET_LINKS_TTL = 3600;
    /** ...and how long a failed read is kept, so it is not retried on every sign-in. */
    protected const ASSET_LINKS_FAILURE_TTL = 300;
    protected const SIMPLE_CACHE_KEY = 'passkeyAndroidKeyHashes';

    /** @var string[]|null this request's copy of the hashes */
    protected $androidKeyHashes;

    /** @var \XF\App */
    protected $app;

    public function __construct(\XF\App $app)
    {
        $this->app = $app;
    }

    /**
     * Generate a WebAuthn-compliant challenge: random bytes, base64url-encoded.
     * Store in session and return the string to send to the client.
     */
    public function generateAndStore(Session $session): string
    {
        $binary = random_bytes(self::CHALLENGE_BYTES);
        $challenge = $this->base64UrlEncode($binary);
        $session->set(self::SESSION_KEY_CHALLENGE, $challenge);
        $session->set(self::SESSION_KEY_TIME, \XF::$time);
        return $challenge;
    }

    /**
     * Get the stored challenge (base64url string) from session, or null if missing/expired.
     */
    public function getStoredChallenge(Session $session): ?string
    {
        $time = $session->get(self::SESSION_KEY_TIME);
        if ($time === null || (\XF::$time - $time > self::CHALLENGE_TTL)) {
            return null;
        }
        $challenge = $session->get(self::SESSION_KEY_CHALLENGE);
        return is_string($challenge) ? $challenge : null;
    }

    /**
     * Clear stored challenge from session.
     */
    public function clearStoredChallenge(Session $session): void
    {
        $session->remove(self::SESSION_KEY_CHALLENGE);
        $session->remove(self::SESSION_KEY_TIME);
    }

    /**
     * Validate the assertion: stored challenge must match provided challenge,
     * then verify with lbuchs WebAuthn processGet() using binary challenge.
     *
     * As XenForo's own passkey sign-in does (Service\Passkey\ManagerService::
     * validateWithUser): the origin must be the board's own (or one of the
     * Android apps the board's assetlinks.json lists), the authenticator's
     * signature counter must move forward (a counter that goes back means a
     * copied authenticator), and an unknown passkey or a failed check counts
     * as a failed login attempt for the IP address (and the member).
     * Callers check hasTooManyLoginAttempts first.
     *
     * @param string $webauthnChallenge The challenge string the client sent back (must match stored)
     * @param array $webauthnPayload Keys: clientDataJSON, authenticatorData, signature, id (credential id)
     * @param string|\XF\Phrase|null $error Set to error message on failure
     * @return Passkey|null The passkey entity on success, null on failure
     */
    public function validateAssertion(Session $session, string $webauthnChallenge, array $webauthnPayload, &$error = null): ?Passkey
    {
        $ip = (string)$this->app->request()->getIp();

        $storedChallenge = $this->getStoredChallenge($session);
        if ($storedChallenge === null) {
            $error = \XF::phrase('page_no_longer_available_back_try_again');
            return null;
        }
        if ($webauthnChallenge !== $storedChallenge) {
            $error = \XF::phrase('something_went_wrong_please_try_again');
            return null;
        }

        $clientDataJsonB64 = $webauthnPayload['clientDataJSON'] ?? '';
        $authenticatorDataB64 = $webauthnPayload['authenticatorData'] ?? '';
        $signatureB64 = $webauthnPayload['signature'] ?? '';
        $credentialId = $webauthnPayload['id'] ?? '';

        if (!is_string($clientDataJsonB64) || !is_string($authenticatorDataB64) || !is_string($signatureB64) || !is_string($credentialId)
            || $clientDataJsonB64 === '' || $authenticatorDataB64 === '' || $signatureB64 === '' || $credentialId === ''
        ) {
            $error = \XF::phrase('something_went_wrong_please_try_again');
            return null;
        }

        $clientDataJSON = $this->decodePayloadField($clientDataJsonB64);
        $authenticatorData = $this->decodePayloadField($authenticatorDataB64);
        $signature = $this->decodePayloadField($signatureB64);

        if ($clientDataJSON === null || $authenticatorData === null || $signature === null) {
            $error = \XF::phrase('something_went_wrong_please_try_again');
            return null;
        }

        // The board's own origin only, as XenForo checks it (ManagerService::
        // validateOrigin) before the WebAuthn library, whose own check also
        // takes other hosts under the same domain.
        $clientData = json_decode($clientDataJSON);
        if (!is_object($clientData) || !isset($clientData->origin) || !is_string($clientData->origin)
            || !$this->isAllowedOrigin($clientData->origin)
        ) {
            $error = \XF::phrase('something_went_wrong_please_try_again');
            return null;
        }

        $passkey = $this->findPasskeyByCredentialId($credentialId);
        if (!$passkey) {
            $this->recordFailedAttempt($ip, null);
            $error = \XF::phrase('given_passkey_or_security_key_could_not_be_verified');
            return null;
        }

        $challengeBinary = $this->base64UrlDecode($storedChallenge);
        if ($challengeBinary === null) {
            $error = \XF::phrase('something_went_wrong_please_try_again');
            return null;
        }

        try {
            $webAuthn = $this->getWebAuthn();
            try {
                $isValid = $webAuthn->processGet(
                    $clientDataJSON,
                    $authenticatorData,
                    $signature,
                    $passkey->credential_public_key,
                    $challengeBinary
                );
            } catch (\Throwable $e) {
                // Legacy lbuchs/WebAuthn versions don't expose addAndroidKeyHashes()
                // and therefore reject native Android origin (android:apk-key-hash:*).
                if (
                    strpos($e->getMessage(), 'invalid origin') !== false
                    && !method_exists($webAuthn, 'addAndroidKeyHashes')
                ) {
                    $isValid = $this->processGetCompatForAndroid(
                        $clientDataJSON,
                        $authenticatorData,
                        $signature,
                        $passkey->credential_public_key,
                        $challengeBinary
                    );
                } else {
                    throw $e;
                }
            }
        } catch (\Throwable $e) {
            $this->logValidationFailure($e);
            $isValid = false;
        }

        if (!$isValid) {
            $this->recordFailedAttempt($ip, $passkey);
            $error = \XF::phrase('given_passkey_or_security_key_could_not_be_verified');
            return null;
        }

        $newCounter = $this->getSignatureCounter($authenticatorData);
        if ($this->hasSignatureCounter($passkey)) {
            if (!$this->isValidSignatureCounter((int)$passkey->signature_counter, $newCounter, $passkey)) {
                $this->recordFailedAttempt($ip, $passkey);
                $error = \XF::phrase('given_passkey_or_security_key_could_not_be_verified');
                return null;
            }
            // Saved with the last use (updatePasskeyLastUse).
            $passkey->signature_counter = $newCounter;
        }

        return $passkey;
    }

    /**
     * Whether [$ip] (and, given [$login], that member) has had too many
     * failed sign-ins lately: XenForo's login limits, which its passkey
     * sign-in uses too (Pub\Controller\Login::actionLogin).
     */
    public function hasTooManyLoginAttempts(string $ip, ?string $login = null): bool
    {
        $limiter = $this->getLoginLimiter();
        return $limiter ? (bool)$limiter->hasTooManyLoginAttempts($ip, $login) : false;
    }

    /**
     * Clears [$login]'s failed sign-ins from [$ip] after a successful one.
     */
    public function clearFailedAttempts(string $ip, string $login): void
    {
        if ($ip === '' || $login === '') {
            return;
        }
        try {
            $this->app->repository('XF:LoginAttempt')->clearLoginAttempts($login, $ip);
        } catch (\Exception $e) {
            // as XenForo's LoginLimitTrait: never blocks the sign-in
        }
    }

    protected function recordFailedAttempt(string $ip, ?Passkey $passkey): void
    {
        $limiter = $this->getLoginLimiter();
        if (!$limiter || $ip === '') {
            return;
        }
        $user = $passkey ? $passkey->User : null;
        $limiter->recordFailedAttempt($ip, $user ? $user->username : null);
    }

    /**
     * XenForo's passkey manager, for its login limits (LoginLimitTrait).
     */
    protected function getLoginLimiter(): ?\XF\Service\Passkey\ManagerService
    {
        if (!class_exists(\XF\Service\Passkey\ManagerService::class)) {
            return null;
        }
        return $this->app->service(\XF\Service\Passkey\ManagerService::class);
    }

    /**
     * The signature counter in authenticator data (bytes 33-36, big endian),
     * as XenForo reads it.
     */
    protected function getSignatureCounter(string $authenticatorData): int
    {
        if (strlen($authenticatorData) < 37) {
            return 0;
        }
        $unpacked = unpack('N', substr($authenticatorData, 33, 4));
        return (int)($unpacked[1] ?? 0);
    }

    protected function hasSignatureCounter(Passkey $passkey): bool
    {
        return $passkey->isValidColumn('signature_counter');
    }

    /**
     * XenForo's counter rule (ManagerService::validateSignatureCounter):
     * authenticators that keep no counter send 0 every time; one that keeps
     * a counter must send a higher value than last time.
     */
    protected function isValidSignatureCounter(int $storedCounter, int $newCounter, Passkey $passkey): bool
    {
        if ($storedCounter === 0) {
            return true;
        }
        if ($newCounter === 0 || $newCounter <= $storedCounter) {
            \XF::logError(sprintf(
                'Forum Copilot: passkey signature counter for user %d (passkey %d) went from %d to %d. This may mean the authenticator was copied, reset or replaced.',
                $passkey->user_id,
                $passkey->passkey_id,
                $storedCounter,
                $newCounter
            ));
            return false;
        }
        return true;
    }

    /**
     * A failed check is logged in the server error log when it points at the
     * forum's set-up (the board URL does not match the passkey's domain), as
     * XenForo logs it; other failures (a wrong signature, ...) only with
     * diagnostic logging on.
     */
    protected function logValidationFailure(\Throwable $e): void
    {
        $message = 'Forum Copilot: passkey validation failed: ' . $e->getMessage();
        if (strpos($e->getMessage(), 'rpId') !== false) {
            \XF::logError($message . ' (Board URL: ' . $this->app->options()->boardUrl . ')');
        } else {
            \ForumCopilot\Util\Log::debug($message);
        }
    }

    /**
     * Update passkey last use date and IP (same as XenForo ManagerService),
     * and the signature counter validateAssertion read.
     * Call after successful login so the passkey entity reflects usage.
     */
    public function updatePasskeyLastUse(Passkey $passkey, string $ip): void
    {
        $passkey->last_use_date = \XF::$time;
        $passkey->last_use_ip_address = \XF\Util\Ip::stringToBinary($ip);
        $passkey->save();
    }

    /**
     * Decode a payload field that may be base64 or base64url.
     */
    protected function decodePayloadField(string $value): ?string
    {
        $decoded = base64_decode($value, true);
        if ($decoded !== false) {
            return $decoded;
        }
        $decoded = $this->base64UrlDecode($value);
        return $decoded;
    }

    /**
     * Find XF passkey by credential id. Client may send base64url; XF stores base64.
     */
    protected function findPasskeyByCredentialId(string $credentialId): ?Passkey
    {
        $passkey = $this->app->finder(\XF\Entity\Passkey::class)
            ->where('credential_id', $credentialId)
            ->fetchOne();
        if ($passkey) {
            return $passkey;
        }
        $binary = $this->base64UrlDecode($credentialId);
        if ($binary !== null) {
            $base64 = base64_encode($binary);
            return $this->app->finder(\XF\Entity\Passkey::class)
                ->where('credential_id', $base64)
                ->fetchOne() ?: null;
        }
        return null;
    }

    protected function getWebAuthn(): WebAuthn
    {
        $options = $this->app->options();
        $webAuthn = new WebAuthn(
            $options->boardTitle,
            $this->getRpId()
        );

        // Native Android passkeys use origin "android:apk-key-hash:<base64url_sha256_signing_cert>".
        // lbuchs/WebAuthn validates this origin only when the app signing hashes are registered.
        $androidKeyHashes = $this->getAndroidKeyHashesFromAssetLinks();
        if (!empty($androidKeyHashes) && method_exists($webAuthn, 'addAndroidKeyHashes')) {
            $webAuthn->addAndroidKeyHashes($androidKeyHashes);
        }

        return $webAuthn;
    }

    /**
     * Compatibility verification path for older lbuchs/WebAuthn versions.
     */
    protected function processGetCompatForAndroid(
        string $clientDataJSON,
        string $authenticatorData,
        string $signature,
        string $credentialPublicKey,
        string $challengeBinary
    ): bool {
        $clientData = json_decode($clientDataJSON);
        if (!is_object($clientData)) {
            throw new \RuntimeException('invalid client data');
        }

        if (!property_exists($clientData, 'type') || $clientData->type !== 'webauthn.get') {
            throw new \RuntimeException('invalid type');
        }

        if (!property_exists($clientData, 'challenge')) {
            throw new \RuntimeException('invalid challenge');
        }
        $challengeFromClient = ByteBuffer::fromBase64Url($clientData->challenge)->getBinaryString();
        if ($challengeFromClient !== $challengeBinary) {
            throw new \RuntimeException('invalid challenge');
        }

        if (!property_exists($clientData, 'origin') || !$this->isAllowedOrigin((string)$clientData->origin)) {
            throw new \RuntimeException('invalid origin');
        }

        $authenticatorObj = new AuthenticatorData($authenticatorData);
        $rpIdHash = hash('sha256', $this->getRpId(), true);
        if ($authenticatorObj->getRpIdHash() !== $rpIdHash) {
            throw new \RuntimeException('invalid rpId hash');
        }

        if (!$authenticatorObj->getUserPresent()) {
            throw new \RuntimeException('user not present during authentication');
        }

        $dataToVerify = $authenticatorData . hash('sha256', $clientDataJSON, true);
        if (!$this->verifySignature($dataToVerify, $signature, $credentialPublicKey)) {
            throw new \RuntimeException('invalid signature');
        }

        return true;
    }

    /**
     * The board's own origin (scheme, host and port of the board URL), as
     * XenForo accepts it (ManagerService::validateOrigin); iOS apps send
     * that too. Or a native Android app whose signing certificate the
     * board's assetlinks.json lists.
     */
    protected function isAllowedOrigin(string $origin): bool
    {
        if (strpos($origin, 'android:apk-key-hash:') === 0) {
            $hash = substr($origin, strlen('android:apk-key-hash:'));
            if ($hash === '') {
                return false;
            }
            $allowedHashes = $this->getAndroidKeyHashesFromAssetLinks();
            if (in_array($hash, $allowedHashes, true)) {
                return true;
            }
            $this->logPasskeyDebug(empty($allowedHashes)
                ? 'Android origin rejected: no hashes loaded from assetlinks.json (URL returned non-200 or empty)'
                : 'Android origin rejected: app hash not in assetlinks.json');
            return false;
        }

        $boardOrigin = $this->getBoardOrigin();
        if ($boardOrigin !== '' && strtolower(rtrim($origin, '/')) === strtolower($boardOrigin)) {
            return true;
        }

        $this->logPasskeyDebug('Origin rejected: "' . $origin . '" is not the board\'s origin "' . $boardOrigin . '"');
        return false;
    }

    protected function getBoardOrigin(): string
    {
        $parts = parse_url((string)$this->app->options()->boardUrl);
        if (!$parts || empty($parts['scheme']) || empty($parts['host'])) {
            return '';
        }
        return $parts['scheme'] . '://' . $parts['host'] . (isset($parts['port']) ? ':' . $parts['port'] : '');
    }

    protected function verifySignature(string $dataToVerify, string $signature, string $credentialPublicKey): bool
    {
        // EdDSA support via Sodium when OpenSSL lacks Ed25519.
        if (function_exists('sodium_crypto_sign_verify_detached') && !in_array('ed25519', openssl_get_curve_names(), true)) {
            $pkParts = [];
            if (preg_match('/BEGIN PUBLIC KEY\-+(?:\s|\n|\r)+([^\-]+)(?:\s|\n|\r)*\-+END PUBLIC KEY/i', $credentialPublicKey, $pkParts)) {
                $rawPk = base64_decode($pkParts[1]);
                $okpPrefix = "\x30\x2a\x30\x05\x06\x03\x2b\x65\x70\x03\x21\x00";
                if ($rawPk && strlen($rawPk) === 44 && substr($rawPk, 0, strlen($okpPrefix)) === $okpPrefix) {
                    $publicKeyXCurve = substr($rawPk, strlen($okpPrefix));
                    return sodium_crypto_sign_verify_detached($signature, $dataToVerify, $publicKeyXCurve);
                }
            }
        }

        $publicKey = openssl_pkey_get_public($credentialPublicKey);
        if ($publicKey === false) {
            throw new \RuntimeException('public key invalid');
        }

        return openssl_verify($dataToVerify, $signature, $publicKey, OPENSSL_ALGO_SHA256) === 1;
    }

    protected function getRpId(): string
    {
        $options = $this->app->options();
        return (string)parse_url($options->boardUrl, PHP_URL_HOST);
    }

    /**
     * A passkey diagnostic line: in the server error log only while the
     * add-on's diagnostic logging (fc_debug_logging) is on.
     */
    protected function logPasskeyDebug(string $message): void
    {
        \ForumCopilot\Util\Log::debug('Forum Copilot passkey: ' . $message);
    }

    /**
     * The signing certificate hashes of the Android apps the board's
     * /.well-known/assetlinks.json lists (every android_app target: the
     * forum lists the apps it lets sign in with its passkeys, the Forum
     * Copilot app and its own). Kept for an hour (a failed read for five
     * minutes), so a sign-in does not wait for the fetch each time.
     *
     * @return string[] base64url-encoded SHA-256 hashes (without padding)
     */
    protected function getAndroidKeyHashesFromAssetLinks(): array
    {
        if ($this->androidKeyHashes !== null) {
            return $this->androidKeyHashes;
        }

        $simpleCache = $this->app->simpleCache();
        $cached = $simpleCache->getValue('ForumCopilot', self::SIMPLE_CACHE_KEY);
        if (is_array($cached) && isset($cached['hashes'], $cached['until'])
            && is_array($cached['hashes']) && $cached['until'] > \XF::$time
        ) {
            return $this->androidKeyHashes = $cached['hashes'];
        }

        $hashes = $this->fetchAndroidKeyHashesFromAssetLinks();
        $this->androidKeyHashes = $hashes ?? [];
        try {
            $simpleCache->setValue('ForumCopilot', self::SIMPLE_CACHE_KEY, [
                'hashes' => $this->androidKeyHashes,
                'until' => \XF::$time + ($hashes ? self::ASSET_LINKS_TTL : self::ASSET_LINKS_FAILURE_TTL),
            ]);
        } catch (\Exception $e) {
            // Only a cache; the hashes are read again next time.
        }

        return $this->androidKeyHashes;
    }

    /**
     * Reads the hashes from the forum's public URL (the same resource
     * Android itself checks). Null when it could not be read.
     *
     * @return string[]|null
     */
    protected function fetchAndroidKeyHashesFromAssetLinks(): ?array
    {
        $boardUrl = (string)\XF::options()->boardUrl;
        $scheme = parse_url($boardUrl, PHP_URL_SCHEME);
        $host = parse_url($boardUrl, PHP_URL_HOST);
        if (!is_string($scheme) || $scheme === '' || !is_string($host) || $host === '') {
            return null;
        }
        $url = $scheme . '://' . $host . '/.well-known/assetlinks.json';

        $ch = curl_init($url);
        if ($ch === false) {
            \XF::logError('Forum Copilot passkey: assetlinks.json: curl_init failed');
            return null;
        }
        curl_setopt_array($ch, [
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_TIMEOUT => 10,
            CURLOPT_FOLLOWLOCATION => true,
            CURLOPT_SSL_VERIFYPEER => true,
        ]);
        $json = curl_exec($ch);
        $httpCode = (int)curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $curlError = curl_error($ch);
        curl_close($ch);

        if ($curlError !== '' || $httpCode !== 200 || !is_string($json) || $json === '') {
            // Native Android passkeys cannot work until this is fixed.
            \XF::logError(
                'Forum Copilot passkey: could not read ' . $url . ' (HTTP ' . $httpCode
                . ($curlError !== '' ? ', ' . $curlError : '') . '); Android app passkey sign-in needs it'
            );
            return null;
        }

        $statements = json_decode($json, true);
        if (!is_array($statements)) {
            return null;
        }

        $hashes = [];
        foreach ($statements as $statement) {
            if (!is_array($statement)) {
                continue;
            }

            $target = $statement['target'] ?? null;
            if (!is_array($target)) {
                continue;
            }

            if (($target['namespace'] ?? '') !== 'android_app') {
                continue;
            }

            $fingerprints = $target['sha256_cert_fingerprints'] ?? null;
            if (!is_array($fingerprints)) {
                continue;
            }

            foreach ($fingerprints as $fingerprint) {
                $hash = $this->convertFingerprintToAndroidKeyHash($fingerprint);
                if ($hash !== null) {
                    $hashes[$hash] = true;
                }
            }
        }

        return array_keys($hashes);
    }

    /**
     * Convert hex fingerprint (AA:BB:...) to base64url hash (no padding)
     * used in clientDataJSON origin: android:apk-key-hash:<hash>.
     */
    protected function convertFingerprintToAndroidKeyHash($fingerprint): ?string
    {
        if (!is_string($fingerprint) || $fingerprint === '') {
            return null;
        }

        $normalized = strtolower(str_replace(':', '', trim($fingerprint)));
        if (!preg_match('/^[0-9a-f]{64}$/', $normalized)) {
            return null;
        }

        $binary = hex2bin($normalized);
        if ($binary === false) {
            return null;
        }

        return rtrim(strtr(base64_encode($binary), '+/', '-_'), '=');
    }

    protected function base64UrlEncode(string $data): string
    {
        return rtrim(strtr(base64_encode($data), '+/', '-_'), '=');
    }

    protected function base64UrlDecode(string $data): ?string
    {
        $padding = 4 - (strlen($data) % 4);
        if ($padding !== 4) {
            $data .= str_repeat('=', $padding);
        }
        $decoded = base64_decode(strtr($data, '-_', '+/'), true);
        return $decoded !== false ? $decoded : null;
    }
}
