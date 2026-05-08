<?php

namespace ForumCopilot\Service\Push;

/**
 * Sends FCM messages directly to the customer's own Firebase project,
 * using the on-disk service-account JSON specified by the
 * fc_push_direct_creds_path option.
 *
 * One instance per process is fine — FcmClient caches its access token via
 * XF's data registry across requests.
 */
class DirectDispatcher
{
    protected ?FcmClient $client = null;
    protected ?string $configError = null;

    public function __construct()
    {
        $opts = \XF::options();
        $path = trim((string)($opts->fc_push_direct_creds_path ?? ''));
        if ($path === '') {
            $this->configError = 'fc_push_direct_creds_path option is empty';
            return;
        }
        if (!is_readable($path)) {
            $this->configError = "service-account JSON not readable at $path";
            return;
        }
        try {
            $this->client = new FcmClient($path);
        } catch (\Throwable $e) {
            $this->configError = $e->getMessage();
        }
    }

    public function isReady(): bool
    {
        return $this->client !== null;
    }

    public function getConfigError(): ?string
    {
        return $this->configError;
    }

    /**
     * Dispatch one notification to a list of device-token entities.
     *
     * Returns counters: ['sent' => N, 'failed' => N, 'invalidated' => N].
     * Invalid-token rows are marked is_token_valid=0 in the DB.
     *
     * @param \ForumCopilot\Entity\DeviceToken[] $devices
     */
    public function dispatch(array $devices, string $title, string $body, string $url, array $data = []): array
    {
        if (!$this->client) {
            return ['sent' => 0, 'failed' => 0, 'invalidated' => 0, 'error' => $this->configError];
        }

        $sent = 0;
        $failed = 0;
        $invalidated = 0;

        $invalidTokens = [];

        foreach ($devices as $device) {
            $payload = $this->buildPayload($device, $title, $body, $url, $data);
            $result = $this->client->send($device->fcm_token, $payload);
            if ($result['success']) {
                $sent++;
                continue;
            }
            $failed++;
            if ($result['tokenInvalid']) {
                $invalidTokens[] = $device->fcm_token;
                $invalidated++;
            } else {
                \XF::logError(sprintf(
                    'FC DirectDispatcher: send failed for device %s (HTTP %d, %s): %s',
                    $device->device_id,
                    $result['httpCode'],
                    $result['errorCode'] ?? '?',
                    $result['error'] ?? '?'
                ));
            }
        }

        if ($invalidTokens) {
            $this->markTokensInvalid($invalidTokens);
        }

        return ['sent' => $sent, 'failed' => $failed, 'invalidated' => $invalidated];
    }

    /**
     * FCM v1 message body. Customizes per-platform delivery so the mobile app
     * shows a proper notification + can open a deep link on tap.
     */
    protected function buildPayload(\ForumCopilot\Entity\DeviceToken $device, string $title, string $body, string $url, array $data): array
    {
        // FCM v1 requires all `data` values to be strings.
        $stringData = [];
        foreach ($data as $k => $v) {
            $stringData[(string)$k] = is_scalar($v) ? (string)$v : json_encode($v);
        }
        $stringData['url'] = $url;

        $payload = [
            'notification' => ['title' => $title, 'body' => $body],
            'data'         => $stringData,
            'android' => [
                'priority'     => 'high',
                'notification' => [
                    'channel_id'   => 'forum_copilot_channel',
                    'click_action' => 'FLUTTER_NOTIFICATION_CLICK',
                ],
            ],
            'apns' => [
                'headers' => ['apns-priority' => '10'],
                'payload' => [
                    'aps' => [
                        'alert'            => ['title' => $title, 'body' => $body],
                        'sound'            => 'default',
                        'mutable-content'  => 1,
                        'thread-id'        => 'forum_copilot',
                    ],
                ],
            ],
        ];

        return $payload;
    }

    protected function markTokensInvalid(array $tokens): void
    {
        try {
            /** @var \ForumCopilot\Repository\DeviceToken $repo */
            $repo = \XF::repository('ForumCopilot:DeviceToken');
            foreach ($tokens as $t) {
                $repo->markInvalidByToken($t);
            }
        } catch (\Throwable $e) {
            \XF::logError('FC DirectDispatcher: failed to mark invalid tokens: ' . $e->getMessage());
        }
    }
}
