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
    private const APP_PACKAGE_NAME = 'com.example.forumapp';

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
     * @param string $webauthnChallenge The challenge string the client sent back (must match stored)
     * @param array $webauthnPayload Keys: clientDataJSON, authenticatorData, signature, id (credential id)
     * @param string|null $error Set to error message on failure
     * @return Passkey|null The passkey entity on success, null on failure
     */
    public function validateAssertion(Session $session, string $webauthnChallenge, array $webauthnPayload, &$error = null): ?Passkey
    {
        $storedChallenge = $this->getStoredChallenge($session);
        if ($storedChallenge === null) {
            $error = 'No passkey challenge found in session. Please call getPasskeyChallenge first.';
            return null;
        }
        if ($webauthnChallenge !== $storedChallenge) {
            $error = 'Challenge mismatch';
            return null;
        }

        $clientDataJsonB64 = $webauthnPayload['clientDataJSON'] ?? '';
        $authenticatorDataB64 = $webauthnPayload['authenticatorData'] ?? '';
        $signatureB64 = $webauthnPayload['signature'] ?? '';
        $credentialId = $webauthnPayload['id'] ?? '';

        if ($clientDataJsonB64 === '' || $authenticatorDataB64 === '' || $signatureB64 === '' || $credentialId === '') {
            $error = 'Invalid webauthn_payload';
            return null;
        }

        $clientDataJSON = $this->decodePayloadField($clientDataJsonB64);
        $authenticatorData = $this->decodePayloadField($authenticatorDataB64);
        $signature = $this->decodePayloadField($signatureB64);

        if ($clientDataJSON === null || $authenticatorData === null || $signature === null) {
            $error = 'Invalid base64 in webauthn_payload';
            return null;
        }

        $passkey = $this->findPasskeyByCredentialId($credentialId);
        if (!$passkey) {
            $error = 'Passkey or security key could not be verified';
            return null;
        }

        $challengeBinary = $this->base64UrlDecode($storedChallenge);
        if ($challengeBinary === null) {
            $error = 'Invalid stored challenge';
            return null;
        }

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

        if (!$isValid) {
            $error = 'Passkey or security key could not be verified';
            return null;
        }

        return $passkey;
    }

    /**
     * Update passkey last use date and IP (same as XenForo ManagerService).
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

    protected function isAllowedOrigin(string $origin): bool
    {
        if (str_starts_with($origin, 'android:apk-key-hash:')) {
            $hash = substr($origin, strlen('android:apk-key-hash:'));
            if ($hash === '') {
                return false;
            }
            return in_array($hash, $this->getAndroidKeyHashesFromAssetLinks(), true);
        }

        if ($this->getRpId() !== 'localhost' && parse_url($origin, PHP_URL_SCHEME) !== 'https') {
            return false;
        }

        $host = parse_url($origin, PHP_URL_HOST);
        if (!is_string($host) || $host === '') {
            return false;
        }
        $host = trim($host, '.');
        return preg_match('/' . preg_quote($this->getRpId(), '/') . '$/i', $host) === 1;
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
     * Read Android signing certificate fingerprints from /.well-known/assetlinks.json
     * and convert them to android:apk-key-hash values expected by lbuchs/WebAuthn.
     *
     * @return string[] base64url-encoded SHA-256 hashes (without padding)
     */
    protected function getAndroidKeyHashesFromAssetLinks(): array
    {
        // Support both standard installs and subdirectory installs (e.g. /xf2).
        $rootDir = rtrim(\XF::getRootDirectory(), '/\\');
        $candidatePaths = [
            $rootDir . '/.well-known/assetlinks.json',
            dirname($rootDir) . '/.well-known/assetlinks.json',
        ];

        $json = null;
        foreach ($candidatePaths as $path) {
            if (!is_file($path)) {
                continue;
            }
            $fileContent = file_get_contents($path);
            if ($fileContent !== false && $fileContent !== '') {
                $json = $fileContent;
                break;
            }
        }

        if ($json === null) {
            return [];
        }

        $statements = json_decode($json, true);
        if (!is_array($statements)) {
            return [];
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

            if (($target['package_name'] ?? '') !== self::APP_PACKAGE_NAME) {
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
