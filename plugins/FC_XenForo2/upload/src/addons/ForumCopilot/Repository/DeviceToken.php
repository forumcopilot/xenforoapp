<?php

namespace ForumCopilot\Repository;

use XF\Mvc\Entity\Repository;

class DeviceToken extends Repository
{
    /**
     * Find all valid tokens for a set of user ids, optionally filtered by source.
     *
     * @param int[]      $userIds
     * @param string|null $source 'forumcopilot' | 'direct' | null (any)
     * @return \XF\Mvc\Entity\Finder
     */
    public function findValidTokensForUsers(array $userIds, ?string $source = null)
    {
        $finder = $this->finder('ForumCopilot:DeviceToken')
            ->where('user_id', $userIds)
            ->where('is_token_valid', true);

        if ($source !== null) {
            $finder->where('source', $source);
        }
        return $finder;
    }

    /**
     * Group a fetched collection of DeviceToken entities by their `source` value.
     *
     * @param \XF\Mvc\Entity\AbstractCollection|array $tokens
     * @return array<string, \ForumCopilot\Entity\DeviceToken[]>
     */
    public function groupBySource($tokens): array
    {
        $bySource = ['forumcopilot' => [], 'direct' => []];
        foreach ($tokens as $t) {
            $bySource[$t->source][] = $t;
        }
        return $bySource;
    }

    /**
     * Upsert a device's record from a registration request.
     *
     * The FCM token names one app install, so whoever registers it now owns
     * it: a row holding the same token under another device id (the app's id
     * was reset, or another member used this phone before) is removed first.
     * Otherwise that row kept the install's pushes, and the token's unique
     * key refused this registration.
     *
     * One INSERT ... ON DUPLICATE KEY UPDATE, so two registrations of a new
     * device at the same moment (sign-in and a token refresh) both succeed.
     */
    public function upsert(string $deviceId, int $userId, string $fcmToken, string $platform, string $source, string $appVersion = ''): \ForumCopilot\Entity\DeviceToken
    {
        $db = $this->db();
        $now = \XF::$time;

        $db->beginTransaction();
        try {
            $db->delete('xf_fc_device_token', 'fcm_token = ? AND device_id <> ?', [$fcmToken, $deviceId]);
            $db->insert('xf_fc_device_token', [
                'device_id'      => $deviceId,
                'user_id'        => $userId,
                'fcm_token'      => $fcmToken,
                'platform'       => $platform,
                'source'         => $source,
                'app_version'    => substr($appVersion, 0, 30),
                'is_token_valid' => 1,
                'last_seen_at'   => $now,
                'created_at'     => $now,
                'updated_at'     => $now,
            ], false, 'user_id = VALUES(user_id), fcm_token = VALUES(fcm_token), platform = VALUES(platform),'
                . ' source = VALUES(source), app_version = VALUES(app_version), is_token_valid = 1,'
                . ' last_seen_at = VALUES(last_seen_at), updated_at = VALUES(updated_at)');
            $db->commit();
        } catch (\Throwable $e) {
            $db->rollback();
            throw $e;
        }

        /** @var \ForumCopilot\Entity\DeviceToken $entity */
        $entity = $this->em->find('ForumCopilot:DeviceToken', $deviceId);
        return $entity;
    }

    /**
     * Gives an existing device a refreshed FCM token, taking the token from
     * any other row that still holds it (as upsert does).
     */
    public function updateToken(\ForumCopilot\Entity\DeviceToken $entity, string $fcmToken): void
    {
        $db = $this->db();
        $db->beginTransaction();
        try {
            $db->delete('xf_fc_device_token', 'fcm_token = ? AND device_id <> ?', [$fcmToken, $entity->device_id]);
            $entity->fcm_token      = $fcmToken;
            $entity->is_token_valid = true;
            $entity->last_seen_at   = \XF::$time;
            $entity->save(true, false);
            $db->commit();
        } catch (\Throwable $e) {
            $db->rollback();
            throw $e;
        }
    }

    /**
     * Removes one device for sign-out: when it belongs to [$userId], or,
     * whoever asks, when [$fcmToken] is the token it holds. Holding the
     * token shows the request comes from that install, so a phone whose
     * session already ended (password changed elsewhere, signed out by an
     * administrator) can still stop the pushes. Returns whether a row went.
     */
    public function deleteDevice(string $deviceId, int $userId, string $fcmToken = ''): bool
    {
        if ($deviceId === '') {
            return false;
        }

        $conditions = [];
        $bind = [$deviceId];
        if ($userId) {
            $conditions[] = 'user_id = ?';
            $bind[] = $userId;
        }
        if ($fcmToken !== '') {
            $conditions[] = 'fcm_token = ?';
            $bind[] = $fcmToken;
        }
        if (!$conditions) {
            return false;
        }

        return $this->db()->delete(
            'xf_fc_device_token',
            'device_id = ? AND (' . implode(' OR ', $conditions) . ')',
            $bind
        ) > 0;
    }

    /**
     * Removes a member's devices, except [$keepDeviceId] if given: after a
     * password change (the other devices are signed out, so they should stop
     * getting the member's notifications), a ban, or the account's deletion.
     */
    public function deleteForUser(int $userId, ?string $keepDeviceId = null): int
    {
        if (!$userId) {
            return 0;
        }
        if ($keepDeviceId !== null && $keepDeviceId !== '') {
            return $this->db()->delete(
                'xf_fc_device_token',
                'user_id = ? AND device_id <> ?',
                [$userId, $keepDeviceId]
            );
        }
        return $this->db()->delete('xf_fc_device_token', 'user_id = ?', $userId);
    }

    /**
     * Removes devices whose token FCM refused (is_token_valid = 0) and those
     * the app has not registered for [$unseenDays] days (the app registers
     * on every start, so such an install is gone). For a daily cron entry.
     */
    public function pruneDevices(int $unseenDays = 90): int
    {
        $cutOff = \XF::$time - max(1, $unseenDays) * 86400;
        return $this->db()->delete(
            'xf_fc_device_token',
            'is_token_valid = 0 OR last_seen_at < ?',
            $cutOff
        );
    }

    /**
     * Cron entry point (callback ForumCopilot\Repository\DeviceToken::runDailyPrune).
     */
    public static function runDailyPrune()
    {
        /** @var self $repo */
        $repo = \XF::repository('ForumCopilot:DeviceToken');
        $repo->pruneDevices();
    }

    /**
     * Mark a token invalid (e.g. after FCM returned UNREGISTERED).
     */
    public function markInvalidByToken(string $fcmToken): void
    {
        $this->db()->update(
            'xf_fc_device_token',
            ['is_token_valid' => 0, 'updated_at' => \XF::$time],
            'fcm_token = ?',
            $fcmToken
        );
    }

    public function deleteByDeviceId(string $deviceId): void
    {
        $this->db()->delete('xf_fc_device_token', 'device_id = ?', $deviceId);
    }
}
