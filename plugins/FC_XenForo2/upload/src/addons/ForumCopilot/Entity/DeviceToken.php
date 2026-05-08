<?php

namespace ForumCopilot\Entity;

use XF\Mvc\Entity\Entity;
use XF\Mvc\Entity\Structure;

/**
 * Persisted FCM/APNs device token for a registered mobile app install.
 *
 * Note: This is a real XF entity (table-backed). The other classes in this
 * directory with "FC*" prefixes are forum-agnostic DTOs used by the API
 * response layer — those don't extend Entity.
 *
 * `source` is the routing key:
 *   - 'forumcopilot' — official Forum Copilot mobile app, dispatched via the
 *      hosted push backend (ForumCopilotPush::sendPushNotification).
 *   - 'direct' — white-label app shipped with the customer's own Firebase
 *      project, dispatched in-process via FcmClient.
 *
 * @property string  $device_id      PK — opaque id chosen by the mobile app
 * @property int     $user_id
 * @property string  $fcm_token      FCM registration token
 * @property string  $platform       ios | android | macos | web
 * @property string  $source         forumcopilot | direct
 * @property string  $app_version
 * @property bool    $is_token_valid
 * @property int     $last_seen_at
 * @property int     $created_at
 * @property int     $updated_at
 */
class DeviceToken extends Entity
{
    public static function getStructure(Structure $structure)
    {
        $structure->table       = 'xf_fc_device_token';
        $structure->shortName   = 'ForumCopilot:DeviceToken';
        $structure->primaryKey  = 'device_id';
        $structure->contentType = 'fc_device_token';

        $structure->columns = [
            'device_id'      => ['type' => self::STR, 'maxLength' => 100, 'required' => true],
            'user_id'        => ['type' => self::UINT, 'required' => true],
            'fcm_token'      => ['type' => self::STR, 'maxLength' => 500, 'required' => true],
            'platform'       => ['type' => self::STR, 'default' => 'android',
                                 'allowedValues' => ['ios', 'android', 'macos', 'web']],
            'source'         => ['type' => self::STR, 'default' => 'direct',
                                 'allowedValues' => ['forumcopilot', 'direct']],
            'app_version'    => ['type' => self::STR, 'maxLength' => 30, 'default' => ''],
            'is_token_valid' => ['type' => self::BOOL, 'default' => true],
            'last_seen_at'   => ['type' => self::UINT, 'default' => 0],
            'created_at'     => ['type' => self::UINT, 'default' => 0],
            'updated_at'     => ['type' => self::UINT, 'default' => 0],
        ];

        $structure->relations = [
            'User' => [
                'entity'     => 'XF:User',
                'type'       => self::TO_ONE,
                'conditions' => [['user_id', '=', '$user_id']],
                'primary'    => true,
            ],
        ];

        return $structure;
    }

    protected function _preSave()
    {
        $now = \XF::$time;
        if ($this->isInsert() && !$this->created_at) {
            $this->created_at = $now;
        }
        $this->updated_at = $now;
        if (!$this->last_seen_at) {
            $this->last_seen_at = $now;
        }
    }
}
