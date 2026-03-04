<?php

namespace ForumCopilot\XF\Repository;

use XF\Entity\User;

class UserAlertRepository extends XFCP_UserAlertRepository
{
    public function getAlertOptOutActions()
    {
        // Use XenForo's dynamic alert opt-out discovery (same as web interface)
        // This gets all alert types from all alert handlers
        $alertOptOuts = parent::getAlertOptOuts();
        
        // Convert nested structure [contentType => [action => label]] to flat format
        // Format: 'contentType_action' => 'Display Name'
        $result = [];
        $displayOrder = 1;
        
        foreach ($alertOptOuts as $contentType => $actions) {
            foreach ($actions as $action => $label) {
                $key = "{$contentType}_{$action}";
                
                // Get the phrase as a string (label might be a Phrase object)
                if ($label instanceof \XF\Phrase) {
                    $displayName = $label->render();
                } else {
                    $displayName = (string)$label;
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

        // Check if user has app installed (entry exists in xf_fc_user)
        if (!$this->userHasAppInstalled($receiver->user_id))
        {
            return false;
        }

        $userOption = $receiver->Option;
        $receives = $userOption->doesReceiveFcPush($contentType, $action);
        
        if (!$receives) {
            $optOuts = $userOption->fc_push_optout ?? [];
        }
        
        return $receives;
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
        // Let XF create the alert first
        $alert = parent::insertAlert($receiverId, $senderId, $senderName, $contentType, $contentId, $action, $extra, $options);
        
        // Collect alert info for push notification processing (no filtering here - done in bulk later)
        // insertAlert() returns true/false, not the alert entity, so we collect info and fetch entity later
        $appOptions = \XF::options();
        if (isset($appOptions->fc_push_enabled) && $appOptions->fc_push_enabled && $alert) {
            \ForumCopilot\Service\Alert\AlertPushCollector::collectAlert(
                $receiverId,
                $senderId,
                $contentType,
                $contentId,
                $action
            );
        }
        
        return $alert;
    }

    /**
     * Check if user has app installed (entry exists in xf_fc_user)
     * Optionally check if last_seen is recent (within 90 days)
     */
    public function userHasAppInstalled($userId)
    {
        $db = $this->db();
        $cutoffTime = time() - (90 * 24 * 60 * 60); // 90 days
        
        // Check if entry exists and last_seen is recent
        $result = $db->fetchOne(
            'SELECT user_id FROM xf_fc_user 
             WHERE user_id = ? 
             AND last_seen > ?',
            [$userId, $cutoffTime]
        );
        
        return (bool)$result;
    }
}

