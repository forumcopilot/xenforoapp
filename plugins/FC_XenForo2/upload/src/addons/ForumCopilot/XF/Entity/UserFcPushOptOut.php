<?php

namespace ForumCopilot\XF\Entity;

use XF\Mvc\Entity\Entity;
use XF\Mvc\Entity\Structure;

/**
 * COLUMNS
 * @property int $user_id
 * @property string $push
 */
class UserFcPushOptOut extends Entity
{
    public static function getStructure(Structure $structure)
    {
        $structure->table = 'xf_user_fc_push_optout';
        $structure->shortName = 'ForumCopilot:UserFcPushOptOut';
        $structure->primaryKey = ['user_id', 'push'];
        $structure->columns = [
            'user_id' => ['type' => self::UINT, 'required' => true],
            'push' => ['type' => self::STR, 'required' => true],
        ];
        return $structure;
    }
}

