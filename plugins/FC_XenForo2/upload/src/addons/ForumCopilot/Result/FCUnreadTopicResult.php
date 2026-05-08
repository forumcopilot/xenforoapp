<?php

namespace ForumCopilot\Result;

/**
 * ForumCopilot Unread Topic Result
 * Maps from UnreadTopicData_Output
 */
class FCUnreadTopicResult extends FCResult
{
    public $totalUnreadNum;
    public $topics;

    public function __construct($result = true, $resultText = 'success', $totalUnreadNum = 0, $topics = [])
    {
        parent::__construct($result, $resultText);
        $this->totalUnreadNum = $totalUnreadNum;
        $this->topics = $topics;
    }

    public function toArray()
    {
        $data = parent::toArray();
        $data['totalUnreadNum'] = $this->totalUnreadNum;
        $data['totalTopicNum'] = $this->totalUnreadNum; // Compatibility
        $data['topics'] = array_map(function($topic) {
            return is_object($topic) ? $topic->toArray() : $topic;
        }, $this->topics);
        return $data;
    }
}

