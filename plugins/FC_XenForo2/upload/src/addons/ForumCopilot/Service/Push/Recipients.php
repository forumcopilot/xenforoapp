<?php

namespace ForumCopilot\Service\Push;

/**
 * Recipients of one push grouped by the language they read the forum in, so
 * a XenForo phrase rendered for them (a direct message's line) comes out in
 * each member's own language. Alerts need none of this: each alert's push is
 * its own job, rendered for its receiver.
 */
class Recipients
{
    /**
     * @param int[] $userIds
     * @return array<int, int[]> language id => user ids, in the order given;
     *         members on the board default (language_id 0) count as that language
     */
    public static function byLanguage(array $userIds): array
    {
        $userIds = array_values(array_unique(array_map('intval', $userIds)));
        if (!$userIds) {
            return [];
        }

        $defaultId = (int) \XF::options()->defaultLanguageId;
        $languages = \XF::db()->fetchPairs(
            'SELECT user_id, language_id FROM xf_user WHERE user_id IN (' . \XF::db()->quote($userIds) . ')'
        );

        $groups = [];
        foreach ($userIds as $userId) {
            $languageId = (int) ($languages[$userId] ?? 0);
            $groups[$languageId ?: $defaultId][] = $userId;
        }

        return $groups;
    }
}
