<?php

namespace ForumCopilot\XF\Repository;

use XF\Entity\User;

class UserAlert extends XFCP_UserAlert
{
    public function getAlertOptOutActions()
    {
        $alertOptOuts = parent::getAlertOptOuts();

        $result = [];

        foreach ($alertOptOuts as $contentType => $actions)
        {
            foreach ($actions as $action => $label)
            {
                $key = "{$contentType}_{$action}";

                if ($label instanceof \XF\Phrase)
                {
                    $displayName = $label->render();
                }
                else
                {
                    $displayName = (string) $label;
                }

                $result[$key] = $displayName;
            }
        }

        return $result;
    }

    public function userReceivesFcPush(User $receiver, $senderId, $contentType, $action)
    {
        if (!$receiver->user_id || $receiver->is_banned)
        {
            return false;
        }

        if ($senderId && $receiver->isIgnoring($senderId))
        {
            return false;
        }

        if (!$receiver->Option)
        {
            return false;
        }

        if (!$this->userHasAppInstalled($receiver->user_id))
        {
            return false;
        }

        $userOption = $receiver->Option;
        return $userOption->doesReceiveFcPush($contentType, $action);
    }

    public function insertAlert(
        $receiverId,
        $senderId,
        $senderName,
        $contentType,
        $contentId,
        $action,
        array $extra = [],
        array $options = []
    )
    {
        \XF::logError(sprintf(
            '[FC DEBUG] UserAlert.insertAlert: ENTER %s/%s recv=%d send=%d cid=%s',
            $contentType, $action, $receiverId, $senderId, $contentId
        ));
        $alert = parent::insertAlert($receiverId, $senderId, $senderName, $contentType, $contentId, $action, $extra, $options);

        $appOptions = \XF::options();
        $pushOn = !empty($appOptions->fc_push_enabled);
        if (!$pushOn) {
            \XF::logError('[FC DEBUG] UserAlert.insertAlert: fc_push_enabled is OFF — skipping collect');
            return $alert;
        }
        if ($pushOn && $alert)
        {
            \XF::logError(sprintf(
                '[FC DEBUG] UserAlert.insertAlert: enqueueing push for %s/%s recv=%d send=%d cid=%s',
                $contentType, $action, $receiverId, $senderId, $contentId
            ));

            // Enqueue the push job IMMEDIATELY (do not rely on the
            // app_pub_complete listener / static collector). That path only
            // fires for XF\Pub\App requests; alerts created from CLI cron
            // (e.g. Siropu Chat Custom's room-message Notify job) would never
            // reach the dispatcher otherwise.
            //
            // Unique key dedupes accidental double-inserts of the same alert
            // within one request. XF's enqueueUnique upserts on the unique
            // key, replacing execute_data — so we encode the receiver in the
            // key to keep each recipient's job independent (otherwise the
            // 50 chat-message alerts for one room message would all collapse
            // into one job containing only the last recipient).
            try
            {
                $uniqueId = sprintf(
                    'fcAlertPush_%d_%s_%d_%s',
                    (int) $receiverId,
                    preg_replace('/[^a-zA-Z0-9_]/', '_', (string) $contentType),
                    (int) $contentId,
                    preg_replace('/[^a-zA-Z0-9_]/', '_', (string) $action)
                );
                \XF::app()->jobManager()->enqueueUnique(
                    $uniqueId,
                    \ForumCopilot\Job\ProcessAlertPush::class,
                    [
                        'collectedAlerts' => [
                            [
                                'receiverId'  => (int) $receiverId,
                                'senderId'    => (int) $senderId,
                                'contentType' => (string) $contentType,
                                'contentId'   => (int) $contentId,
                                'action'      => (string) $action,
                            ],
                        ],
                    ],
                    false
                );
            }
            catch (\Throwable $e)
            {
                \XF::logError('FC insertAlert enqueue error: ' . $e->getMessage());
            }
        }
        else if (!$alert)
        {
            \XF::logError(sprintf(
                '[FC DEBUG] UserAlert.insertAlert: NO alert returned by parent for %s/%s recv=%d (XF skipped insert — recipient pref likely off)',
                $contentType, $action, $receiverId
            ));
        }

        return $alert;
    }

    public function userHasAppInstalled($userId)
    {
        $db = $this->db();
        $cutoffTime = time() - (90 * 24 * 60 * 60);

        $result = $db->fetchOne(
            'SELECT user_id FROM xf_fc_user
             WHERE user_id = ?
             AND last_seen > ?',
            [$userId, $cutoffTime]
        );

        return (bool) $result;
    }
}
