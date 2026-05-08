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
     */
    public function upsert(string $deviceId, int $userId, string $fcmToken, string $platform, string $source, string $appVersion = ''): \ForumCopilot\Entity\DeviceToken
    {
        /** @var \ForumCopilot\Entity\DeviceToken $entity */
        $entity = $this->em->find('ForumCopilot:DeviceToken', $deviceId);
        if (!$entity) {
            $entity = $this->em->create('ForumCopilot:DeviceToken');
            $entity->device_id = $deviceId;
        }

        $entity->user_id        = $userId;
        $entity->fcm_token      = $fcmToken;
        $entity->platform       = $platform;
        $entity->source         = $source;
        $entity->app_version    = $appVersion;
        $entity->is_token_valid = true;
        $entity->last_seen_at   = \XF::$time;
        $entity->save();

        return $entity;
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
