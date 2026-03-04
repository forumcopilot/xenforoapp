<?php

namespace ForumCopilot\XF\Entity;

use XF\Mvc\Entity\Structure;

class UserOption extends XFCP_UserOption
{
    public function doesReceiveFcPush($contentType, $action)
    {
        $options = $this->app()->options();

        if (!isset($options->fc_push_enabled) || !$options->fc_push_enabled)
        {
            return false;
        }

        // Ensure fc_push_optout is initialized
        if (!isset($this->fc_push_optout) || !is_array($this->fc_push_optout))
        {
            $this->fc_push_optout = [];
        }

        return ($this->doesReceiveAlert($contentType, $action)
            && !in_array("{$contentType}_{$action}", $this->fc_push_optout)
        );
    }

    protected function _postSave()
    {
        parent::_postSave();

        if ($this->isChanged('fc_push_optout'))
        {
            $inserts = [];
            foreach ($this->fc_push_optout AS $optOut)
            {
                $inserts[] = [
                    'user_id' => $this->user_id,
                    'push' => $optOut,
                ];
            }
            $this->db()->delete('xf_user_fc_push_optout', 'user_id = ?', $this->user_id);
            if ($inserts)
            {
                $this->db()->insertBulk('xf_user_fc_push_optout', $inserts, true);
            }
        }
    }

    protected function _postLoad()
    {
        parent::_postLoad();

        // Initialize fc_push_optout if not set
        if (!isset($this->fc_push_optout))
        {
            $this->fc_push_optout = [];
        }

        // Load fc_push_optout from normalization table if column is empty
        if (empty($this->fc_push_optout) && $this->user_id)
        {
            $optOuts = $this->db()->fetchAllColumn(
                'SELECT push FROM xf_user_fc_push_optout WHERE user_id = ?',
                $this->user_id
            );
            if ($optOuts)
            {
                $this->fc_push_optout = $optOuts;
            }
        }
    }

    protected function _setupDefaults()
    {
        parent::_setupDefaults();
        
        // Initialize fc_push_optout as empty array by default (all FC push notifications enabled)
        if (!isset($this->fc_push_optout))
        {
            $this->fc_push_optout = [];
        }
    }

    public static function getStructure(\XF\Mvc\Entity\Structure $structure)
    {
        $structure = parent::getStructure($structure);

        $structure->columns['fc_push_optout'] = [
            'type' => self::LIST_COMMA,
            'default' => [],
            'list' => ['type' => 'str', 'unique' => true, 'sort' => true],
            'changeLog' => false,
        ];

        $structure->relations['FcPushOptOut'] = [
            'entity' => 'ForumCopilot:UserFcPushOptOut',
            'type' => self::TO_MANY,
            'conditions' => 'user_id',
        ];

        return $structure;
    }
}

