<?php

namespace ForumCopilot\Result;

/**
 * ForumCopilot Conversations Result
 * Maps from ConversationsData_Output
 */
class FCConversationsResult extends FCResult
{
    public $conversationCount;
    public $unreadCount;
    public $canUpload;
    public $list;

    public function __construct($result = true, $resultText = 'success', $conversationCount = 0, $unreadCount = 0, $canUpload = false, $list = [])
    {
        parent::__construct($result, $resultText);
        $this->conversationCount = $conversationCount;
        $this->unreadCount = $unreadCount;
        $this->canUpload = $canUpload;
        $this->list = $list;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['conversationCount'] = $this->conversationCount;
        $data['unreadCount'] = $this->unreadCount;
        $data['canUpload'] = $this->canUpload;
        $data['list'] = array_map(function($item) {
            return is_object($item) ? $item->toArray() : $item;
        }, $this->list);
        return $data;
    }
}

